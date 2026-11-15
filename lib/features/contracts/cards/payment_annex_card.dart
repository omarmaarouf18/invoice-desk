part of '../contract_cards.dart';

String _rawMoney(int minor) => minor % Currency.minorFactor == 0
    ? '${minor ~/ Currency.minorFactor}'
    : (minor / Currency.minorFactor).toStringAsFixed(2);

/// `30%` → percent; `25000` → fixed amount; empty → neither.
({int? bp, int? minor})? parseShare(String input) {
  final s = input.trim();
  if (s.isEmpty) return (bp: null, minor: null);
  if (s.endsWith('%') || s.endsWith('٪')) {
    final bp = parsePercentToBp(s.substring(0, s.length - 1));
    if (bp == null || bp > 10000) return null;
    return (bp: bp, minor: null);
  }
  final m = parseMoneyInput(s);
  return m == null ? null : (bp: null, minor: m);
}

String shareText(PaymentMilestone m) => m.amountMinor != null
    ? _rawMoney(m.amountMinor!)
    : m.percentBp != null
    ? '${formatBpAsPercent(m.percentBp!)}%'
    : '';

class PaymentAnnexCard extends ConsumerWidget {
  const PaymentAnnexCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final locked = c.isLocked;
    final ctl = _ctl(ref);
    final check = checkMilestones(c);
    final invoices = ref.watch(invoicesProvider).value ?? const <Invoice>[];
    final byId = {for (final i in invoices) i.id: i};
    final amber = missingColors(context);
    final today = ref.watch(todayProvider);
    final a = ContractActions(ref, context);

    Widget head(String t, int flex) => Expanded(
      flex: flex,
      child: Text(t, style: theme.textTheme.labelMedium),
    );

    final balanced = check.balanced && c.milestones.isNotEmpty;
    final pctOff =
        check.percentSumBp != 0 &&
        check.percentSumBp != 10000 &&
        c.milestones.every((m) => m.amountMinor == null);

    return PanelCard(
      title: l.cardPaymentAnnex,
      icon: Icons.payments_outlined,
      trailing: locked
          ? null
          : OutlinedButton.icon(
              key: const ValueKey('add-milestone'),
              onPressed: ctl.addMilestone,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.addMilestone),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SyncedTextField(
                  key: const ValueKey('contract-total'),
                  label: l.contractTotal,
                  value: _rawMoney(c.totalMinor),
                  readOnly: locked,
                  textDirection: TextDirection.ltr,
                  formatOnBlur: (raw) {
                    final m = parseMoneyInput(raw);
                    return m == null ? raw : formatAmount(m, c.currency);
                  },
                  onChanged: (v) {
                    final m = parseMoneyInput(v);
                    if (m != null) ctl.edit((x) => x.copyWith(totalMinor: m));
                  },
                ),
              ),
              const SizedBox(width: Space.m - 4),
              SizedBox(
                width: 140,
                child: DropdownButtonFormField<Currency>(
                  key: ValueKey('ccur-${c.currency}'),
                  initialValue: c.currency,
                  decoration: InputDecoration(labelText: l.currency),
                  items: [
                    for (final x in Currency.values)
                      DropdownMenuItem(value: x, child: Text(x.code)),
                  ],
                  onChanged: locked
                      ? null
                      : (x) {
                          if (x != null) {
                            ctl.edit((y) => y.copyWith(currency: x));
                          }
                        },
                ),
              ),
              const SizedBox(width: Space.m),
              Expanded(
                flex: 4,
                child: Text(
                  formatContractMoney(c.totalMinor, c.currency),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.m),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
            child: Row(
              children: [
                head(l.milestoneLabel, 4),
                const SizedBox(width: Space.s),
                head(l.milestoneShare, 2),
                const SizedBox(width: Space.s),
                head(l.milestoneTrigger, 4),
                const SizedBox(width: Space.s),
                head(l.milestoneDue, 3),
                const SizedBox(width: Space.s),
                head(l.milestoneAmount, 3),
                const SizedBox(width: 172),
              ],
            ),
          ),
          for (final (i, m) in c.milestones.indexed)
            Padding(
              key: ValueKey(m.id),
              padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SyncedTextField(
                      value: m.label,
                      dense: true,
                      readOnly: locked,
                      onChanged: (v) =>
                          ctl.editMilestone(m.id, (x) => x.copyWith(label: v)),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 2,
                    child: SyncedTextField(
                      value: shareText(m),
                      dense: true,
                      readOnly: locked,
                      hint: l.milestoneShareHint,
                      textDirection: TextDirection.ltr,
                      onChanged: (v) {
                        final s = parseShare(v);
                        if (s == null) return;
                        ctl.editMilestone(
                          m.id,
                          (x) => x.copyWith(
                            percentBp: () => s.bp,
                            amountMinor: () => s.minor,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 4,
                    child: SyncedTextField(
                      value: m.trigger,
                      dense: true,
                      readOnly: locked,
                      hint: l.milestoneTriggerHint,
                      onChanged: (v) => ctl.editMilestone(
                        m.id,
                        (x) => x.copyWith(trigger: v),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 3,
                    child: OptionalDateField(
                      label: '',
                      value: m.dueDate,
                      enabled: !locked,
                      onChanged: (d) => ctl.editMilestone(
                        m.id,
                        (x) => x.copyWith(dueDate: () => d),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 3,
                    child: Text(
                      formatMoney(check.amounts[i], c.currency),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(
                    width: 132,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: _MilestoneInvoice(
                        milestone: m,
                        invoice: byId[m.invoiceId],
                        today: today,
                        onCreate: () => unawaited(a.createInvoice(m)),
                        onOpen: (id) => unawaited(a.openInvoice(id)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: locked
                        ? null
                        : IconButton(
                            tooltip: l.deleteItem,
                            onPressed: () => ctl.removeMilestone(m.id),
                            icon: const Icon(Icons.close, size: 16),
                          ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: Space.s),
          Container(
            key: const ValueKey('milestone-check'),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Space.m - 4,
              vertical: Space.s,
            ),
            decoration: BoxDecoration(
              color: balanced && !pctOff ? context.colors.subtle : amber.bg,
              borderRadius: BorderRadius.circular(Space.radiusSmall),
            ),
            child: Row(
              children: [
                Icon(
                  balanced && !pctOff
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
                  size: 18,
                  color: balanced && !pctOff
                      ? theme.colorScheme.primary
                      : amber.fg,
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  child: Text(
                    pctOff
                        ? l.milestonesPercentOff(
                            formatBpAsPercent(check.percentSumBp),
                          )
                        : balanced
                        ? l.milestonesBalanced
                        : l.milestonesOff(
                            formatMoney(check.sum, c.currency),
                            formatMoney(check.total, c.currency),
                            formatMoney(check.difference, c.currency),
                          ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: balanced && !pctOff ? null : amber.fg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MilestoneInvoice extends StatelessWidget {
  const _MilestoneInvoice({
    required this.milestone,
    required this.invoice,
    required this.today,
    required this.onCreate,
    required this.onOpen,
  });

  final PaymentMilestone milestone;
  final Invoice? invoice;
  final CalendarDate today;
  final VoidCallback onCreate;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final inv = invoice;
    if (inv == null) {
      return TextButton.icon(
        key: ValueKey('create-invoice-${milestone.id}'),
        onPressed: onCreate,
        icon: const Icon(Icons.receipt_long_outlined, size: 16),
        label: Text(context.l10n.createInvoice),
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      onTap: () => onOpen(inv.id),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              inv.number,
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            StatusChip(inv.displayStatus(today), dense: true),
          ],
        ),
      ),
    );
  }
}
