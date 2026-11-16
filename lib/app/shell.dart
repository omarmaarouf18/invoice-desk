import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/calendar/banners.dart';
import 'package:invoice_desk/features/calendar/calendar_page.dart';
import 'package:invoice_desk/features/contracts/contract_actions.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_page.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/editor/editor_page.dart';
import 'package:invoice_desk/features/library/library_page.dart';
import 'package:invoice_desk/features/settings/settings_page.dart';
import 'package:invoice_desk/features/sidebar/sidebar.dart';
import 'package:invoice_desk/features/sidebar/sidebar_providers.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

const sidebarWidth = 320.0;

/// The width of the sidebar for the text scale in effect.
///
/// A row in the sidebar holds an invoice number, a status chip and a date
/// side by side, so the sidebar needs more room when the text is large;
/// otherwise the number would have to be cut short.
double sidebarWidthFor(BuildContext context) {
  final scale = MediaQuery.textScalerOf(context).scale(1);
  return sidebarWidth * (1 + (scale - 1) * 0.4);
}

/// RTL app shell: sidebar on the start (right) side, workspace beside it,
/// and every global keyboard shortcut.
class Shell extends ConsumerWidget {
  const Shell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = AppActions(ref, context);
    final ca = ContractActions(ref, context);
    // Ctrl+S/E/D act on whichever document the workspace shows.
    bool onContract() => ref.read(workspaceProvider) == Workspace.contract;
    void focusSearch() {
      final f = ref.read(searchFocusProvider)..requestFocus();
      final ctx = f.context;
      if (ctx != null) {
        final field = ctx.findAncestorStateOfType<EditableTextState>();
        field?.selectAll(SelectionChangedCause.keyboard);
      }
    }

    SingleActivator ctrl(LogicalKeyboardKey k, {bool shift = false}) =>
        SingleActivator(k, control: true, shift: shift);

    return CallbackShortcuts(
      bindings: {
        ctrl(LogicalKeyboardKey.keyN): a.newInvoice,
        ctrl(LogicalKeyboardKey.keyN, shift: true): () =>
            unawaited(a.newClient()),
        ctrl(LogicalKeyboardKey.keyK, shift: true): () =>
            unawaited(ca.newContract()),
        ctrl(LogicalKeyboardKey.keyC, shift: true): () => ref
            .read(calendarModeProvider.notifier)
            .set(!ref.read(calendarModeProvider)),
        ctrl(LogicalKeyboardKey.keyK): focusSearch,
        ctrl(LogicalKeyboardKey.keyF): focusSearch,
        ctrl(LogicalKeyboardKey.keyS): () => onContract()
            ? unawaited(ref.read(contractProvider.notifier).flush())
            : a.save(),
        ctrl(LogicalKeyboardKey.keyE): () => unawaited(
          onContract() ? ca.exportPdf() : a.exportPdf(),
        ),
        ctrl(LogicalKeyboardKey.keyD): () => unawaited(
          onContract() ? ca.duplicate() : a.duplicate(),
        ),
        ctrl(LogicalKeyboardKey.keyR): () => unawaited(a.renew()),
        ctrl(LogicalKeyboardKey.digit1): () =>
            ref.read(previewTabProvider.notifier).set(false),
        ctrl(LogicalKeyboardKey.digit2): () =>
            ref.read(previewTabProvider.notifier).set(true),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Column(
            children: [
              const ModeBar(),
              const TopBanners(),
              const StartupNotification(),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: sidebarWidthFor(context),
                      child: const Sidebar(),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: FocusTraversalGroup(child: const _Workspace()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Workspace extends ConsumerWidget {
  const _Workspace();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(calendarModeProvider)) return const CalendarPage();
    final ws = ref.watch(workspaceProvider);
    final hasInvoice = ref.watch(
      editorProvider.select((s) => s.invoice != null),
    );
    final hasContract = ref.watch(
      contractProvider.select((s) => s.contract != null),
    );
    final Widget child = switch (ws) {
      Workspace.settings => const SettingsPage(),
      Workspace.library => const LibraryPage(),
      Workspace.invoice when hasInvoice => const EditorPage(),
      Workspace.contract when hasContract => const ContractPage(),
      Workspace.invoice || Workspace.contract => const WelcomePane(),
    };
    final open = ws == Workspace.contract ? hasContract : hasInvoice;
    return AnimatedSwitcher(
      duration: motion(context),
      child: KeyedSubtree(key: ValueKey('${ws.name}$open'), child: child),
    );
  }
}

/// The top-level switch: الفواتير والعقود | التقويم (Ctrl+Shift+C).
class ModeBar extends ConsumerWidget {
  const ModeBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final on = ref.watch(calendarModeProvider);
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: Space.m),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: SegmentedButton<bool>(
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: [
          ButtonSegment(
            value: false,
            icon: const Icon(Icons.receipt_long_outlined, size: 18),
            label: Text(l.invoicesAndContracts),
          ),
          ButtonSegment(
            value: true,
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
            label: Text(l.calendar),
            tooltip: 'Ctrl+Shift+C',
          ),
        ],
        selected: {on},
        onSelectionChanged: (v) =>
            ref.read(calendarModeProvider.notifier).set(v.first),
      ),
    );
  }
}

/// Shown when nothing is open: first-run steps, or a nudge to pick one.
class WelcomePane extends ConsumerWidget {
  const WelcomePane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider).value;
    final clients = ref.watch(clientsProvider).value;
    final invoices = ref.watch(invoicesProvider).value;
    if (settings == null || clients == null || invoices == null) {
      return const SizedBox.shrink();
    }
    final a = AppActions(ref, context);
    final profileDone = settings.hasProfile;
    final clientDone = clients.isNotEmpty;

    if (profileDone && clientDone && invoices.isNotEmpty) {
      return _PickOne(onNew: a.newInvoice);
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(Space.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.emptyTitle, style: theme.textTheme.headlineSmall),
              const SizedBox(height: Space.xs),
              Text(
                l.emptyBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.muted,
                ),
              ),
              const SizedBox(height: Space.l),
              _Step(
                n: 1,
                title: l.stepProfile,
                body: l.stepProfileBody,
                done: profileDone,
                action: l.stepProfile,
                onPressed: () => ref
                    .read(workspaceProvider.notifier)
                    .show(Workspace.settings),
              ),
              const SizedBox(height: Space.m - 4),
              _Step(
                n: 2,
                title: l.stepClient,
                body: l.stepClientBody,
                done: clientDone,
                action: l.newClient,
                onPressed: () => unawaited(a.newClient()),
              ),
              if (profileDone && clientDone) ...[
                const SizedBox(height: Space.l),
                FilledButton.icon(
                  onPressed: a.newInvoice,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.stepInvoice),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Everything is set up: nudge towards the list or a new invoice.
class _PickOne extends StatelessWidget {
  const _PickOne({required this.onNew});
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: context.colors.muted,
          ),
          const SizedBox(height: Space.m - 4),
          Text(l.pickInvoice, style: theme.textTheme.titleMedium),
          const SizedBox(height: Space.xs),
          Text(l.pickInvoiceBody, style: theme.textTheme.bodySmall),
          const SizedBox(height: Space.m),
          FilledButton.icon(
            onPressed: onNew,
            icon: const Icon(Icons.add, size: 18),
            label: Text('${l.newInvoice}  ·  Ctrl+N'),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.n,
    required this.title,
    required this.body,
    required this.done,
    required this.action,
    required this.onPressed,
  });

  final int n;
  final String title;
  final String body;
  final bool done;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.m),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: done ? accent : theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: done
                  ? Icon(
                      Icons.check,
                      size: 18,
                      color: theme.colorScheme.onPrimary,
                      semanticLabel: context.l10n.done,
                    )
                  : Text(
                      '$n',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
            ),
            const SizedBox(width: Space.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(body, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: Space.s),
            if (done)
              Text(
                context.l10n.done,
                style: theme.textTheme.labelMedium?.copyWith(color: accent),
              )
            else
              FilledButton.tonal(onPressed: onPressed, child: Text(action)),
          ],
        ),
      ),
    );
  }
}
