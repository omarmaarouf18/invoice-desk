part of '../sidebar.dart';

class _InvoiceRow extends ConsumerWidget {
  const _InvoiceRow({required this.invoice, required this.query});
  final Invoice invoice;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final selected =
        ref.watch(workspaceProvider) == Workspace.invoice &&
        ref.watch(editorProvider.select((s) => s.invoice?.id == invoice.id));
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

class _ContractRow extends ConsumerWidget {
  const _ContractRow({required this.entry, required this.query});
  final ContractEntry entry;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = entry.contract;
    final selected =
        ref.watch(workspaceProvider) == Workspace.contract &&
        ref.watch(contractProvider.select((s) => s.contract?.id == c.id));
    final a = ContractActions(ref, context);
    final accent = theme.colorScheme.primary;
    final indent = entry.depth * 16.0;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        Space.l + 4 + indent,
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
          onTap: () => unawaited(a.open(c.id)),
          onSecondaryTapUp: (d) => unawaited(
            _menu(context, d.globalPosition, [
              (l.menuOpen, Icons.open_in_new, () => unawaited(a.open(c.id))),
              if (!c.isAmendment)
                (
                  l.duplicateContract,
                  Icons.copy_outlined,
                  () => unawaited(a.duplicate(c.id)),
                ),
              (
                l.createAmendment,
                Icons.note_add_outlined,
                () => unawaited(a.amendment(c.id)),
              ),
              (
                l.menuDelete,
                Icons.delete_outline,
                () => unawaited(a.delete(c.id)),
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
                    if (entry.depth > 0) ...[
                      Icon(
                        Icons.subdirectory_arrow_left,
                        size: 14,
                        color: context.colors.muted,
                      ),
                      const SizedBox(width: 2),
                    ],
                    Flexible(
                      child: HighlightText(
                        c.number,
                        query: query,
                        textDirection: TextDirection.ltr,
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    const SizedBox(width: Space.s),
                    ContractStatusChip(c.status, dense: true),
                  ],
                ),
                if (c.title.trim().isNotEmpty || c.projectName.isNotEmpty)
                  HighlightText(
                    c.title.trim().isNotEmpty ? c.title : c.projectName,
                    query: query,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                if (c.totalMinor > 0)
                  Text(
                    c.total.format(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
