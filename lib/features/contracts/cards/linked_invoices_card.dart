part of '../contract_cards.dart';

class LinkedInvoicesCard extends ConsumerWidget {
  const LinkedInvoicesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final number = _watch(ref, (c) => c.number);
    final linkedIds = _watch(
      ref,
      (c) => {
        for (final m in c.milestones)
          if (m.invoiceId != null) m.invoiceId!,
      },
    );
    final today = ref.watch(todayProvider);
    final invoices = [
      for (final i in ref.watch(invoicesProvider).value ?? const <Invoice>[])
        if (i.contractRef.trim() == number || linkedIds.contains(i.id)) i,
    ]..sort((a, b) => a.issueDate.compareTo(b.issueDate));
    final a = ContractActions(ref, context);
    return PanelCard(
      title: l.cardLinkedInvoices,
      icon: Icons.receipt_long_outlined,
      child: invoices.isEmpty
          ? Text(l.noLinkedInvoices, style: theme.textTheme.bodySmall)
          : Column(
              children: [
                for (final i in invoices)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onTap: () => unawaited(a.openInvoice(i.id)),
                    title: Row(
                      children: [
                        Text(i.number, textDirection: TextDirection.ltr),
                        const SizedBox(width: Space.s),
                        StatusChip(i.displayStatus(today), dense: true),
                        const Spacer(),
                        Text(
                          i.totals.total.format(),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    subtitle: Text(formatArabicDate(i.issueDate)),
                  ),
              ],
            ),
    );
  }
}
