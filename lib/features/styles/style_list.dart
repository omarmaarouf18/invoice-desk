import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/styles/style_actions.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/features/styles/style_thumbnail.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// The start column: ready-made presets, then the user's own styles, then
/// "New from Blank" and "Import".
class StyleList extends ConsumerWidget {
  const StyleList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final selected = ref.watch(styleEditorProvider.select((s) => s.selectedId));
    final mine = ref.watch(userStylesProvider).value ?? const <CustomStyle>[];
    final ctl = ref.read(styleEditorProvider.notifier);
    Widget heading(String text) => Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.s,
        Space.m,
        Space.s,
        Space.xs,
      ),
      child: Semantics(
        header: true,
        child: Text(text, style: theme.textTheme.labelLarge),
      ),
    );

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Space.s),
              children: [
                heading(l.stylesPresets),
                for (final p in DocPreset.values)
                  _StyleRow(
                    key: ValueKey('style-row-${p.id}'),
                    name: presetName(l, p),
                    style: p.style,
                    selected: selected == p.id,
                    onTap: () => unawaited(ctl.selectPreset(p)),
                  ),
                heading(l.stylesMine),
                if (mine.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(Space.s),
                    child: Text(
                      l.stylesNoneYet,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                for (final s in mine)
                  _StyleRow(
                    key: ValueKey('style-row-${s.id}'),
                    name: s.name,
                    style: s.style,
                    selected: selected == s.id,
                    onTap: () => unawaited(ctl.selectUser(s)),
                    menu: _UserStyleMenu(style: s),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          const _ListFooter(),
        ],
      ),
    );
  }
}

class _ListFooter extends ConsumerWidget {
  const _ListFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final actions = StyleActions(ref, context);
    return Padding(
      padding: const EdgeInsets.all(Space.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.tonalIcon(
            key: const ValueKey('style-new-blank'),
            onPressed: () => unawaited(actions.newFromBlank()),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l.styleNewFromBlank),
          ),
          const SizedBox(height: Space.xs),
          TextButton.icon(
            key: const ValueKey('style-import'),
            onPressed: () => unawaited(actions.import()),
            icon: const Icon(Icons.file_open_outlined, size: 18),
            label: Text(l.styleImport),
          ),
        ],
      ),
    );
  }
}

class _StyleRow extends StatelessWidget {
  const _StyleRow({
    required this.name,
    required this.style,
    required this.selected,
    required this.onTap,
    super.key,
    this.menu,
  });

  final String name;
  final DocumentStyle style;
  final bool selected;
  final VoidCallback onTap;
  final Widget? menu;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    selected: selected,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
    ),
    selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
    contentPadding: const EdgeInsetsDirectional.only(
      start: Space.s,
      end: Space.xs,
    ),
    leading: StyleThumbnail(style: style, width: 28),
    title: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis),
    trailing: menu,
    onTap: onTap,
  );
}

enum _Action { duplicate, rename, reset, export, delete }

class _UserStyleMenu extends ConsumerWidget {
  const _UserStyleMenu({required this.style});
  final CustomStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final a = StyleActions(ref, context);
    return PopupMenuButton<_Action>(
      key: ValueKey('style-menu-${style.id}'),
      tooltip: l.styleMoreActions,
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (v) => unawaited(switch (v) {
        _Action.duplicate => a.duplicateUser(style),
        _Action.rename => a.rename(style),
        _Action.reset => a.reset(style),
        _Action.export => a.export(style),
        _Action.delete => a.delete(style),
      }),
      itemBuilder: (_) => [
        PopupMenuItem(value: _Action.duplicate, child: Text(l.styleDuplicate)),
        PopupMenuItem(value: _Action.rename, child: Text(l.styleRename)),
        PopupMenuItem(value: _Action.reset, child: Text(l.styleResetToPreset)),
        PopupMenuItem(value: _Action.export, child: Text(l.styleExport)),
        const PopupMenuDivider(),
        PopupMenuItem(value: _Action.delete, child: Text(l.styleDelete)),
      ],
    );
  }
}
