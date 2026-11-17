import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';

/// What the style editor shows: the selected style, the unsaved draft of a
/// user style, and the preview's document and language.
@immutable
class StyleEditorState {
  const StyleEditorState({
    this.selectedId = 'preset_classic',
    this.draft,
    this.revision = 0,
    this.dirty = false,
    this.previewContract = false,
    this.previewLanguage,
  });

  /// A preset id (`preset_…`) or a user style id.
  final String selectedId;

  /// The user style being edited; null while a preset is selected.
  final CustomStyle? draft;

  /// Bumped on every edit; the preview debounces on it.
  final int revision;

  /// The draft has edits that are not saved yet.
  final bool dirty;

  /// Preview the open contract instead of an invoice.
  final bool previewContract;

  /// The preview's language; null follows the previewed document.
  final DocLanguage? previewLanguage;

  /// A preset is selected (read-only).
  bool get isPreset => draft == null;

  /// The look being shown.
  DocumentStyle get style => draft?.style ?? DocPreset.fromId(selectedId).style;

  StyleEditorState copyWith({
    String? selectedId,
    CustomStyle? Function()? draft,
    int? revision,
    bool? dirty,
    bool? previewContract,
    DocLanguage? Function()? previewLanguage,
  }) => StyleEditorState(
    selectedId: selectedId ?? this.selectedId,
    draft: draft != null ? draft() : this.draft,
    revision: revision ?? this.revision,
    dirty: dirty ?? this.dirty,
    previewContract: previewContract ?? this.previewContract,
    previewLanguage: previewLanguage != null
        ? previewLanguage()
        : this.previewLanguage,
  );
}

/// The style editor's single write path: edits change the draft at once
/// and reach the database 600 ms after the last one (like Settings).
class StyleEditorController extends Notifier<StyleEditorState> {
  static const _debounce = Duration(milliseconds: 600);
  Timer? _timer;

  @override
  StyleEditorState build() {
    ref.onDispose(() => _timer?.cancel());
    return const StyleEditorState();
  }

  /// Shows [preset] (read-only).
  Future<void> selectPreset(DocPreset preset) async {
    await flush();
    state = state.copyWith(
      selectedId: preset.id,
      draft: () => null,
      revision: state.revision + 1,
    );
  }

  /// Opens user style [s] for editing.
  Future<void> selectUser(CustomStyle s) async {
    await flush();
    state = state.copyWith(
      selectedId: s.id,
      draft: () => s,
      revision: state.revision + 1,
    );
  }

  /// Applies [change] to the draft; ignored while a preset is selected.
  void edit(DocumentStyle Function(DocumentStyle s) change) {
    final d = state.draft;
    if (d == null) return;
    _apply(d.copyWith(style: change(d.style)));
  }

  /// Renames the draft; an empty name is kept out of the database.
  void setName(String name) {
    final d = state.draft;
    if (d == null || name.trim().isEmpty) return;
    _apply(d.copyWith(name: name));
  }

  void _apply(CustomStyle next) {
    state = state.copyWith(
      draft: () => next,
      dirty: true,
      revision: state.revision + 1,
    );
    _timer?.cancel();
    _timer = Timer(_debounce, () => unawaited(flush()));
  }

  /// Writes a pending edit now (leaving the page, switching styles).
  Future<void> flush() async {
    _timer?.cancel();
    final d = state.draft;
    if (!state.dirty || d == null) return;
    state = state.copyWith(dirty: false);
    await ref.read(styleRepositoryProvider).saveUserStyle(d);
  }

  /// Keeps the draft in step with the database: a rename or reset from
  /// the list replaces it, and a deleted style falls back to Classic.
  /// Pending edits win over the stored row.
  void sync(List<CustomStyle> stored) {
    final d = state.draft;
    if (d == null) return;
    final row = stored.where((s) => s.id == d.id).firstOrNull;
    if (row == null) {
      _timer?.cancel();
      state = state.copyWith(
        selectedId: DocPreset.classic.id,
        draft: () => null,
        dirty: false,
        revision: state.revision + 1,
      );
    } else if (!state.dirty && (row.name != d.name || row.style != d.style)) {
      state = state.copyWith(draft: () => row, revision: state.revision + 1);
    }
  }

  /// Previews a contract ([on]) or an invoice.
  // ignore: avoid_positional_boolean_parameters, a two-way switch
  void setPreviewContract(bool on) => state = state.copyWith(
    previewContract: on,
    previewLanguage: () => null,
    revision: state.revision + 1,
  );

  /// Previews in [lang]; null follows the document.
  void setPreviewLanguage(DocLanguage? lang) => state = state.copyWith(
    previewLanguage: () => lang,
    revision: state.revision + 1,
  );
}

final styleEditorProvider =
    NotifierProvider<StyleEditorController, StyleEditorState>(
      StyleEditorController.new,
    );
