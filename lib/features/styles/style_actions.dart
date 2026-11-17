import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart' show newId;
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:path/path.dart' as p;

/// The UI name of a preset, in the UI language.
String presetName(AppLocalizations l, DocPreset preset) => switch (preset) {
  DocPreset.classic => l.presetClassic,
  DocPreset.modern => l.presetModern,
  DocPreset.minimal => l.presetMinimal,
  DocPreset.bold => l.presetBold,
  DocPreset.formal => l.presetFormal,
  DocPreset.blank => l.presetBlank,
};

const _styleFiles = XTypeGroup(label: 'JSON', extensions: ['json']);
const _images = XTypeGroup(
  label: 'PNG / JPG',
  extensions: ['png', 'jpg', 'jpeg'],
);

/// What the style editor's buttons and menus do. Each one reports its
/// outcome in a snackbar and selects the style it created.
class StyleActions {
  StyleActions(this.ref, this.context);
  final WidgetRef ref;
  final BuildContext context;

  AppLocalizations get l => context.l10n;
  StyleRepository get _repo => ref.read(styleRepositoryProvider);
  StyleEditorController get _ctl => ref.read(styleEditorProvider.notifier);

  /// "New from Blank": a user copy of the Blank preset.
  Future<void> newFromBlank() => duplicatePreset(DocPreset.blank);

  /// A user copy of [preset], named after it.
  Future<void> duplicatePreset(DocPreset preset) async {
    final copy = await _repo.duplicateStyle(
      id: newId(),
      name: l.styleCopyName(presetName(l, preset)),
      presetId: preset.id,
    );
    await _ctl.selectUser(copy);
  }

  /// A copy of user style [s] (with its logo).
  Future<void> duplicateUser(CustomStyle s) async {
    await _ctl.flush();
    final source = await _repo.getUserStyleById(s.id) ?? s;
    final copy = await _repo.duplicateStyle(
      id: newId(),
      name: l.styleCopyName(source.name),
      source: source,
    );
    await _ctl.selectUser(copy);
  }

  /// Asks for a new name for [s].
  Future<void> rename(CustomStyle s) async {
    await _ctl.flush();
    if (!context.mounted) return;
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _RenameDialog(initial: s.name),
    );
    if (name == null || name.trim().isEmpty) return;
    await _repo.renameStyle(s.id, name);
  }

  /// Puts [s] back to its base preset after a confirmation.
  Future<void> reset(CustomStyle s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.styleResetToPreset),
        content: Text(l.styleResetConfirm(s.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.styleReset),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    await _ctl.flush();
    await _repo.resetStyle(s.id);
  }

  /// Moves [s] to the trash, with Undo.
  Future<void> delete(CustomStyle s) async {
    await _ctl.flush();
    await _repo.softDeleteUserStyle(s.id);
    showSnack(
      l.styleDeleted(s.name),
      actions: [(l.undo, () => unawaited(_repo.undoDeleteUserStyle(s.id)))],
    );
  }

  /// Saves [s] as a `.json` style file the user picks.
  Future<void> export(CustomStyle s) async {
    await _ctl.flush();
    final prefs = ref.read(uiPrefsProvider);
    final location = await getSaveLocation(
      suggestedName: '${s.name}.json',
      initialDirectory: prefs.lastExportDir,
      acceptedTypeGroups: const [_styleFiles],
    );
    if (location == null) return;
    var path = location.path;
    if (!path.toLowerCase().endsWith('.json')) path = '$path.json';
    try {
      final raw = await _repo.exportStyleFile(s.id);
      if (raw == null) return;
      await File(path).writeAsString(raw, flush: true);
    } on Object catch (e) {
      debugPrint('style export failed: $e');
      return showSnack(l.styleExportFailed);
    }
    prefs.lastExportDir = p.dirname(path);
    showSnack(l.styleExported(p.basename(path)));
  }

  /// Imports a `.json` style file the user picks, and selects it.
  Future<void> import() async {
    final file = await openFile(acceptedTypeGroups: const [_styleFiles]);
    if (file == null) return;
    try {
      final style = await _repo.importStyleFile(
        await file.readAsString(),
        id: newId(),
        fallbackName: l.styleNewName,
      );
      await _ctl.selectUser(style);
      showSnack(l.styleImported(style.name));
    } on InvalidAssetException {
      showSnack(l.logoRejected);
    } on Object catch (e) {
      debugPrint('style import failed: $e');
      showSnack(l.styleImportFailed);
    }
  }

  /// Picks a PNG/JPG and makes it the draft's logo.
  Future<void> chooseLogo() async {
    final file = await openFile(acceptedTypeGroups: const [_images]);
    if (file == null) return;
    try {
      final id = await _repo.saveAsset(bytes: await file.readAsBytes());
      _ctl.edit((s) => s.copyWith(logoAssetId: id));
    } on InvalidAssetException {
      showSnack(l.logoRejected);
    }
  }

  /// Takes the logo off the draft (the asset is purged later if unused).
  void removeLogo() => _ctl.edit((s) => s.copyWith(clearLogoAssetId: true));
}

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.initial});
  final String initial;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    void submit() => Navigator.pop(context, _c.text);
    return AlertDialog(
      title: Text(l.styleRename),
      content: TextField(
        controller: _c,
        autofocus: true,
        decoration: InputDecoration(labelText: l.styleNameLabel),
        onSubmitted: (_) => submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: submit, child: Text(l.save)),
      ],
    );
  }
}
