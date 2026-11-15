import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/editor/editor_cards.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/editor/sections_editor.dart';
import 'package:invoice_desk/features/preview/preview_pane.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// Width at which the live preview sits beside the editor.
const sideBySideWidth = 1500.0;

class EditorPage extends ConsumerWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(editorProvider.select((s) => s.invoice?.id));
    if (id == null) return const SizedBox.shrink();
    final wide = MediaQuery.sizeOf(context).width >= sideBySideWidth;
    final preview = ref.watch(previewTabProvider);
    final editor = _EditorBody(key: ValueKey(id));
    return Column(
      children: [
        _TopBar(wide: wide),
        const Divider(),
        Expanded(
          child: wide
              ? Row(
                  children: [
                    Expanded(flex: 11, child: editor),
                    const VerticalDivider(width: 1),
                    const Expanded(flex: 8, child: PreviewPane()),
                  ],
                )
              : IndexedStack(
                  index: preview ? 1 : 0,
                  children: [
                    editor,
                    if (preview) const PreviewPane() else const SizedBox(),
                  ],
                ),
        ),
      ],
    );
  }
}

class _EditorBody extends StatelessWidget {
  const _EditorBody({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.l,
            Space.l,
            Space.l,
            Space.xl * 2,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DetailsCard(),
                  SizedBox(height: Space.m),
                  SectionsCard(),
                  SizedBox(height: Space.m),
                  TotalsCard(),
                  SizedBox(height: Space.m),
                  NotesCard(),
                  SizedBox(height: Space.m),
                  ScopeCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final st = ref.watch(editorProvider);
    final inv = st.invoice!;
    final today = ref.watch(todayProvider);
    final actions = AppActions(ref, context);
    final preview = ref.watch(previewTabProvider);

    return Container(
      height: 64,
      color: theme.colorScheme.surface,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.l),
      child: Row(
        children: [
          Flexible(
            child: Text(
              inv.number.isEmpty ? '—' : inv.number,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: Space.s + 4),
          StatusChip(inv.displayStatus(today)),
          const SizedBox(width: Space.m),
          _SaveIndicator(status: st.status),
          const Spacer(),
          if (!wide) ...[
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: false,
                  label: Tooltip(message: 'Ctrl+1', child: Text(l.tabEdit)),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                ),
                ButtonSegment(
                  value: true,
                  label: Tooltip(message: 'Ctrl+2', child: Text(l.tabPreview)),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                ),
              ],
              selected: {preview},
              onSelectionChanged: (s) =>
                  ref.read(previewTabProvider.notifier).set(s.first),
            ),
            const SizedBox(width: Space.s + 4),
          ],
          if (inv.status != InvoiceStatus.paid && !st.isNew) ...[
            Tooltip(
              message: l.menuMarkPaid,
              child: OutlinedButton.icon(
                onPressed: () => unawaited(actions.markPaid()),
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: Text(l.statusPaid),
              ),
            ),
            const SizedBox(width: Space.s),
          ],
          Tooltip(
            message: '${l.save} (Ctrl+S)',
            child: OutlinedButton(onPressed: actions.save, child: Text(l.save)),
          ),
          const SizedBox(width: Space.s),
          Tooltip(
            message: '${l.exportPdfLong} (Ctrl+E)',
            child: FilledButton.icon(
              onPressed: () => unawaited(actions.exportPdf()),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: Text(l.exportPdf),
            ),
          ),
          const SizedBox(width: Space.xs),
          MenuAnchor(
            builder: (context, controller, _) => IconButton(
              tooltip: l.more,
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              icon: const Icon(Icons.more_horiz),
            ),
            menuChildren: [
              MenuItemButton(
                leadingIcon: const Icon(Icons.copy_outlined, size: 18),
                shortcut: const SingleActivator(
                  LogicalKeyboardKey.keyD,
                  control: true,
                ),
                onPressed: () => unawaited(actions.duplicate()),
                child: Text(l.menuDuplicate),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.autorenew, size: 18),
                shortcut: const SingleActivator(
                  LogicalKeyboardKey.keyR,
                  control: true,
                ),
                onPressed: () => unawaited(actions.renew()),
                child: Text(l.menuRenew),
              ),
              const Divider(),
              MenuItemButton(
                leadingIcon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                onPressed: () => unawaited(actions.delete()),
                child: Text(
                  l.menuDelete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SaveIndicator extends StatelessWidget {
  const _SaveIndicator({required this.status});
  final SaveStatus status;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final theme = Theme.of(context);
    final (label, color, icon) = switch (status) {
      SaveStatus.saved => (l.saved, c.muted, Icons.check),
      SaveStatus.saving => (l.saving, c.muted, null),
      SaveStatus.dirty => (l.unsaved, theme.colorScheme.primary, null),
      SaveStatus.invalid => (
        l.notSavedFix,
        theme.colorScheme.error,
        Icons.error_outline,
      ),
      SaveStatus.error => (
        l.saveFailed,
        theme.colorScheme.error,
        Icons.error_outline,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 16, color: color)
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
        ],
      ),
    );
  }
}
