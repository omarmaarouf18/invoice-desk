part of '../sidebar.dart';

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
      SidebarFilter.contractsInForce: l.filterContractsInForce,
      SidebarFilter.archived: l.archived,
      SidebarFilter.trash: l.trash,
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
              avatar: switch (e.key) {
                SidebarFilter.archived => const Icon(
                  Icons.archive_outlined,
                  size: 16,
                ),
                SidebarFilter.contractsInForce => const Icon(
                  Icons.gavel_outlined,
                  size: 16,
                ),
                SidebarFilter.trash => const Icon(
                  Icons.delete_outline,
                  size: 16,
                ),
                _ => null,
              },
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
