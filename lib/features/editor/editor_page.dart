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
import 'package:invoice_desk/widgets/editor_chrome.dart';

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

class _EditorBody extends ConsumerWidget {
  const _EditorBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;
    final hasPayment =
        settings != null &&
        (settings.instapay.trim().isNotEmpty ||
            settings.wallet.trim().isNotEmpty ||
            settings.bankIban.trim().isNotEmpty);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (settings != null && !hasPayment) ...[
                    const _PaymentWarningBanner(),
                    const SizedBox(height: Space.m),
                  ],
                  const DetailsCard(),
                  const SizedBox(height: Space.m),
                  const SectionsCard(),
                  const SizedBox(height: Space.m),
                  const TotalsCard(),
                  const SizedBox(height: Space.m),
                  const NotesCard(),
                  const SizedBox(height: Space.m),
                  const ScopeCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentWarningBanner extends ConsumerWidget {
  const _PaymentWarningBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final amber = missingColors(context);
    return Container(
      key: const ValueKey('payment-warning-banner'),
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.m,
        Space.s + 4,
        Space.m,
        Space.s + 4,
      ),
      decoration: BoxDecoration(
        color: amber.bg,
        borderRadius: BorderRadius.circular(Space.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(Icons.payment_outlined, size: 20, color: amber.fg),
          const SizedBox(width: Space.m - 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.warnNoPaymentMethod,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: amber.fg,
                  ),
                ),
                Text(
                  l.warnNoPaymentMethodHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: amber.fg.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.m),
          FilledButton.tonal(
            key: const ValueKey('open-settings-payment-warning'),
            onPressed: () =>
                ref.read(workspaceProvider.notifier).show(Workspace.settings),
            child: Text(l.openSettings),
          ),
        ],
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
    final actions = AppActions(ref, context);
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
          StatusChip(inv.displayStatus(ref.watch(todayProvider))),
          const SizedBox(width: Space.m),
          SaveIndicator(status: st.status),
          const Spacer(),
          if (!wide) ...[
            const EditPreviewTabs(),
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
          SaveExportButtons(
            onSave: actions.save,
            onExport: () => unawaited(actions.exportPdf()),
          ),
          const SizedBox(width: Space.xs),
          _InvoiceMenu(actions: actions),
        ],
      ),
    );
  }
}

class _InvoiceMenu extends StatelessWidget {
  const _InvoiceMenu({required this.actions});
  final AppActions actions;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return MoreMenu(
      children: [
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
        DeleteMenuItem(onPressed: () => unawaited(actions.delete())),
      ],
    );
  }
}

class SaveIndicator extends StatelessWidget {
  const SaveIndicator({required this.status, super.key});
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
