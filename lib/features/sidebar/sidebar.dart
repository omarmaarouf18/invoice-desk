import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/sidebar/sidebar_model.dart';
import 'package:invoice_desk/features/sidebar/sidebar_providers.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final actions = AppActions(ref, context);
    final onSettings = ref.watch(workspaceProvider) == Workspace.settings;
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              Space.m,
              Space.m,
              Space.s,
              Space.s,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      l.sidebarTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                Tooltip(
                  message: l.myProfile,
                  child: TextButton.icon(
                    style: onSettings
                        ? TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                          )
                        : null,
                    onPressed: () => ref
                        .read(workspaceProvider.notifier)
                        .show(
                          onSettings ? Workspace.invoice : Workspace.settings,
                        ),
                    icon: const Icon(Icons.person_outline, size: 18),
                    label: Text(l.myProfile),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: Space.m),
            child: _SearchField(),
          ),
          const SizedBox(height: Space.s + 4),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.m),
            child: Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: '${l.newInvoice} (Ctrl+N)',
                    child: FilledButton.icon(
                      onPressed: actions.newInvoice,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l.newInvoice),
                    ),
                  ),
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  child: Tooltip(
                    message: '${l.newClient} (Ctrl+Shift+N)',
                    child: OutlinedButton.icon(
                      onPressed: () => unawaited(actions.newClient()),
                      icon: const Icon(Icons.person_add_alt, size: 18),
                      label: Text(l.newClient),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.s + 4),
          const _FilterChips(),
          const SizedBox(height: Space.s),
          const _SummaryStrip(),
          const Divider(),
          const Expanded(child: _ClientList()),
        ],
      ),
    );
  }
}

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  final _c = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _c.dispose();
    super.dispose();
  }

  void _changed(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      if (mounted) ref.read(searchQueryProvider.notifier).set(v);
    });
    setState(() {});
  }

  void _clear() {
    _debounce?.cancel();
    _c.clear();
    ref.read(searchQueryProvider.notifier).set('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Cleared from elsewhere (e.g. the "no results" button).
    ref.listen(searchQueryProvider, (_, q) {
      if (q.isEmpty && _c.text.isNotEmpty) _c.clear();
    });
    final l = context.l10n;
    final focus = ref.watch(searchFocusProvider);
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _clear},
      child: TextField(
        controller: _c,
        focusNode: focus,
        onChanged: _changed,
        decoration: InputDecoration(
          hintText: l.searchHint,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _c.text.isEmpty
              ? const Padding(
                  padding: EdgeInsetsDirectional.only(end: Space.s),
                  child: Center(
                    widthFactor: 1,
                    child: _KeyHint(label: 'Ctrl K'),
                  ),
                )
              : IconButton(
                  tooltip: '${l.clearSearch} (Esc)',
                  onPressed: _clear,
                  icon: const Icon(Icons.close, size: 18),
                ),
        ),
      ),
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 6,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    ),
  );
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final current = ref.watch(sidebarFilterProvider);
    final labels = {
      SidebarFilter.all: l.filterAll,
      SidebarFilter.unpaid: l.filterUnpaid,
      SidebarFilter.overdue: l.filterOverdue,
      SidebarFilter.paid: l.filterPaid,
      SidebarFilter.drafts: l.filterDrafts,
      SidebarFilter.archived: l.archived,
    };
    // Wraps rather than scrolls, so every filter (the archive included)
    // is visible at the sidebar's width.
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.m),
      child: Wrap(
        spacing: Space.xs,
        runSpacing: Space.xs,
        children: [
          for (final e in labels.entries)
            ChoiceChip(
              label: Text(e.value),
              avatar: e.key == SidebarFilter.archived
                  ? const Icon(Icons.archive_outlined, size: 16)
                  : null,
              selected: current == e.key,
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              labelPadding: const EdgeInsetsDirectional.symmetric(
                horizontal: 6,
              ),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 2),
              onSelected: (_) =>
                  ref.read(sidebarFilterProvider.notifier).set(e.key),
            ),
        ],
      ),
    );
  }
}

class _SummaryStrip extends ConsumerWidget {
  const _SummaryStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final summary = ref.watch(sidebarDataProvider).value?.summary;
    if (summary == null) return const SizedBox(height: 40);
    final filter = ref.read(sidebarFilterProvider.notifier);
    final overdueColor = context.colors.statusFg[DisplayStatus.overdue];
    Widget link(String label, Widget value, SidebarFilter f, {Color? color}) =>
        InkWell(
          borderRadius: BorderRadius.circular(Space.radiusSmall),
          onTap: () => filter.set(f),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                DefaultTextStyle.merge(
                  style: theme.textTheme.titleSmall?.copyWith(color: color),
                  child: value,
                ),
              ],
            ),
          ),
        );
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(
        Space.m,
        0,
        Space.m,
        Space.s,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: context.colors.subtle,
        borderRadius: BorderRadius.circular(Space.radiusSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: link(
              l.summaryUnpaid,
              Text(
                summary.unpaid.format(empty: '—'),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.end,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SidebarFilter.unpaid,
            ),
          ),
          link(
            l.summaryOverdue,
            Text('${summary.overdueCount}'),
            SidebarFilter.overdue,
            color: summary.overdueCount > 0 ? overdueColor : null,
          ),
        ],
      ),
    );
  }
}

class _ClientList extends ConsumerWidget {
  const _ClientList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final data = ref.watch(sidebarDataProvider);
    final query = ref.watch(searchQueryProvider);
    return switch (data) {
      AsyncData(:final value) when value.groups.isEmpty => _EmptyList(
        query: query,
      ),
      AsyncData(:final value) => Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsetsDirectional.only(
            top: Space.xs,
            bottom: Space.l,
          ),
          itemCount: value.groups.length,
          itemBuilder: (context, i) => _ClientGroupTile(
            key: ValueKey(value.groups[i].client.id),
            group: value.groups[i],
            query: query,
          ),
        ),
      ),
      AsyncError() => Center(child: Text(l.dbErrorTitle)),
      _ => const Center(
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    };
  }
}

class _EmptyList extends ConsumerWidget {
  const _EmptyList({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hasQuery = query.trim().isNotEmpty;
    final filtered = ref.watch(sidebarFilterProvider) != SidebarFilter.all;
    return Padding(
      padding: const EdgeInsets.all(Space.l),
      child: Column(
        children: [
          const SizedBox(height: Space.l),
          Icon(
            hasQuery ? Icons.search_off : Icons.inbox_outlined,
            size: 32,
            color: context.colors.muted,
          ),
          const SizedBox(height: Space.s),
          Text(
            hasQuery
                ? l.noResults(query.trim())
                : (filtered ? l.noInvoicesForClient : l.noClientsYet),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.muted,
            ),
            textAlign: TextAlign.center,
          ),
          if (hasQuery || filtered) ...[
            const SizedBox(height: Space.s),
            TextButton(
              onPressed: () {
                ref.read(searchQueryProvider.notifier).set('');
                ref.read(sidebarFilterProvider.notifier).set(SidebarFilter.all);
              },
              child: Text(l.clearSearch),
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> _menu(
  BuildContext context,
  Offset position,
  List<(String, IconData, VoidCallback)> items,
) async {
  final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
  final selected = await showMenu<int>(
    context: context,
    position: RelativeRect.fromRect(
      position & const Size(1, 1),
      Offset.zero & overlay.size,
    ),
    items: [
      for (final (i, (label, icon, _)) in items.indexed)
        PopupMenuItem(
          value: i,
          height: 36,
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: Space.s + 4),
              Text(label),
            ],
          ),
        ),
    ],
  );
  if (selected != null) items[selected].$3();
}

class _ClientGroupTile extends ConsumerWidget {
  const _ClientGroupTile({required this.group, required this.query, super.key});
  final ClientGroup group;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = group.client;
    final override = ref.watch(expandedClientsProvider.select((m) => m[c.id]));
    final isActive = ref.watch(activeClientIdProvider) == c.id;
    final searching =
        query.trim().isNotEmpty ||
        ref.watch(sidebarFilterProvider) != SidebarFilter.all;
    final expanded = isActive || searching || (override ?? false);
    final actions = AppActions(ref, context);
    // ignore: avoid_positional_boolean_parameters, local helper
    void toggle([bool? to]) => ref
        .read(expandedClientsProvider.notifier)
        .set(c.id, expanded: to ?? !expanded);
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Focus(
          canRequestFocus: false,
          skipTraversal: true,
          onKeyEvent: (node, e) {
            if (e is! KeyDownEvent) return KeyEventResult.ignored;
            final open = rtl
                ? LogicalKeyboardKey.arrowLeft
                : LogicalKeyboardKey.arrowRight;
            final shut = rtl
                ? LogicalKeyboardKey.arrowRight
                : LogicalKeyboardKey.arrowLeft;
            if (e.logicalKey == open) {
              toggle(true);
              return KeyEventResult.handled;
            }
            if (e.logicalKey == shut) {
              toggle(false);
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Semantics(
            button: true,
            expanded: expanded,
            child: InkWell(
              onTap: toggle,
              onSecondaryTapUp: (d) => unawaited(
                _menu(context, d.globalPosition, [
                  (
                    l.newInvoice,
                    Icons.add,
                    () => actions.newInvoice(clientId: c.id),
                  ),
                  (
                    l.menuEdit,
                    Icons.edit_outlined,
                    () => unawaited(actions.editClient(c)),
                  ),
                  if (c.archived)
                    (
                      l.menuUnarchive,
                      Icons.unarchive_outlined,
                      () => unawaited(actions.setArchived(c, archived: false)),
                    )
                  else
                    (
                      l.menuArchive,
                      Icons.archive_outlined,
                      () => unawaited(actions.setArchived(c, archived: true)),
                    ),
                  (
                    l.menuDeleteClient,
                    Icons.person_remove_outlined,
                    () => unawaited(actions.deleteClient(c)),
                  ),
                ]),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  Space.s + 4,
                  Space.s,
                  Space.m,
                  Space.s,
                ),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: expanded ? 0 : (rtl ? 0.25 : -0.25),
                      duration: motion(context),
                      child: Icon(
                        Icons.expand_more,
                        size: 20,
                        color: context.colors.muted,
                      ),
                    ),
                    const SizedBox(width: Space.xs),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HighlightText(
                            c.name,
                            query: query,
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            [
                              l.invoiceCount(group.invoiceCount),
                              if (group.unpaidCount > 0)
                                l.unpaidCount(group.unpaidCount),
                              if (c.archived) l.archived,
                            ].join(' · '),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: motion(context),
          alignment: AlignmentDirectional.topStart,
          child: expanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final inv in group.invoices)
                      _InvoiceRow(invoice: inv, query: query),
                    if (group.invoices.isEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          40,
                          0,
                          Space.m,
                          Space.s,
                        ),
                        child: Text(
                          l.noInvoicesForClient,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _InvoiceRow extends ConsumerWidget {
  const _InvoiceRow({required this.invoice, required this.query});
  final Invoice invoice;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final selected = ref.watch(
      editorProvider.select((s) => s.invoice?.id == invoice.id),
    );
    final today = ref.watch(todayProvider);
    final status = invoice.displayStatus(today);
    final actions = AppActions(ref, context);
    final accent = theme.colorScheme.primary;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.l + 4,
        1,
        Space.s + 4,
        1,
      ),
      child: Material(
        color: selected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45)
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Space.radiusSmall),
          side: BorderSide(
            color: selected ? accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(Space.radiusSmall),
          onTap: () => unawaited(actions.open(invoice.id)),
          onSecondaryTapUp: (d) => unawaited(
            _menu(context, d.globalPosition, [
              (
                l.menuOpen,
                Icons.open_in_new,
                () => unawaited(actions.open(invoice.id)),
              ),
              (
                l.menuDuplicate,
                Icons.copy_outlined,
                () => unawaited(actions.duplicate(invoice.id)),
              ),
              (
                l.menuRenew,
                Icons.autorenew,
                () => unawaited(actions.renew(invoice.id)),
              ),
              if (invoice.status != InvoiceStatus.paid)
                (
                  l.menuMarkPaid,
                  Icons.check_circle_outline,
                  () => unawaited(actions.markPaid(invoice.id)),
                ),
              (
                l.menuDelete,
                Icons.delete_outline,
                () => unawaited(actions.delete(invoice.id)),
              ),
            ]),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Space.s + 2,
              vertical: Space.s - 1,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    HighlightText(
                      invoice.number,
                      query: query,
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(width: Space.s),
                    StatusChip(status, dense: true),
                    const Spacer(),
                    Text(
                      formatArabicDayMonth(invoice.issueDate),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  invoice.totals.total.format(empty: '—'),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
