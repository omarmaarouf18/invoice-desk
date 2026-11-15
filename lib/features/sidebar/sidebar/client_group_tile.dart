part of '../sidebar.dart';

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
    final filter = ref.watch(sidebarFilterProvider);
    final browsing =
        filter == SidebarFilter.all || filter == SidebarFilter.archived;
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
                    l.newContract,
                    Icons.gavel_outlined,
                    () => unawaited(
                      ContractActions(ref, context).newContract(clientId: c.id),
                    ),
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
                              if (group.contractCount > 0)
                                l.contractCount(group.contractCount),
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
                    if (group.contracts.isNotEmpty ||
                        (browsing && group.contractCount > 0)) ...[
                      _GroupHeader(
                        l.groupContracts(group.contractCount),
                        icon: Icons.gavel_outlined,
                      ),
                      for (final e in group.contracts)
                        _ContractRow(entry: e, query: query),
                    ],
                    if (group.invoices.isNotEmpty || browsing) ...[
                      if (group.contracts.isNotEmpty || group.contractCount > 0)
                        _GroupHeader(
                          l.groupInvoices(group.invoiceCount),
                          icon: Icons.receipt_long_outlined,
                        ),
                      for (final inv in group.invoices)
                        _InvoiceRow(invoice: inv, query: query),
                    ],
                    if (group.invoices.isEmpty && group.contracts.isEmpty)
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

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.label, {required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = context.colors.muted;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.l + 6,
        Space.xs,
        Space.m,
        2,
      ),
      child: Row(
        children: [
          Icon(icon, size: 13, color: muted),
          const SizedBox(width: Space.xs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: muted),
          ),
        ],
      ),
    );
  }
}
