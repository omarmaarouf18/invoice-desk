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
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final check = checkMilestones(c);
    return PanelCard(
      title: l.cardPaymentAnnex,
      icon: Icons.payments_outlined,
      trailing: c.isLocked
          ? null
          : OutlinedButton.icon(
              key: const ValueKey('add-milestone'),
              onPressed: _ctl(ref).addMilestone,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.addMilestone),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TotalRow(contract: c),
          const SizedBox(height: Space.m),
          const _MilestoneHeader(),
          for (final (i, m) in c.milestones.indexed)
            _MilestoneRow(
              key: ValueKey(m.id),
              milestone: m,
              amount: check.amounts[i],
              contract: c,
            ),
          const SizedBox(height: Space.s),
          _SumCheck(contract: c, check: check),
        ],
      ),
    );
  }
}

class _TotalRow extends ConsumerWidget {
  const _TotalRow({required this.contract});
  final Contract contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = contract;
    final ctl = _ctl(ref);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SyncedTextField(
            key: const ValueKey('contract-total'),
            label: l.contractTotal,
            value: _rawMoney(c.totalMinor),
            readOnly: c.isLocked,
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
            onChanged: c.isLocked
                ? null
                : (x) {
                    if (x != null) ctl.edit((y) => y.copyWith(currency: x));
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
    );
  }
}

class _MilestoneHeader extends StatelessWidget {
  const _MilestoneHeader();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final style = Theme.of(context).textTheme.labelMedium;
    Widget head(String t, int flex) => Expanded(
      flex: flex,
      child: Text(t, style: style),
    );
    return Padding(
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
    );
  }
}

/// Label, % or amount, trigger, due date, computed amount, invoice link.
class _MilestoneRow extends ConsumerWidget {
  const _MilestoneRow({
    required this.milestone,
    required this.amount,
    required this.contract,
    super.key,
  });

  final PaymentMilestone milestone;

  /// After the largest-remainder split.
  final int amount;
  final Contract contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final m = milestone;
    final locked = contract.isLocked;
    final ctl = _ctl(ref);
    void edit(PaymentMilestone Function(PaymentMilestone x) f) =>
        ctl.editMilestone(m.id, f);
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SyncedTextField(
              value: m.label,
              dense: true,
              readOnly: locked,
              onChanged: (v) => edit((x) => x.copyWith(label: v)),
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
                edit(
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
              onChanged: (v) => edit((x) => x.copyWith(trigger: v)),
            ),
          ),
          const SizedBox(width: Space.s),
          Expanded(
            flex: 3,
            child: OptionalDateField(
              label: '',
              value: m.dueDate,
              enabled: !locked,
              onChanged: (d) => edit((x) => x.copyWith(dueDate: () => d)),
            ),
          ),
          const SizedBox(width: Space.s),
          Expanded(
            flex: 3,
            child: Text(
              formatMoney(amount, contract.currency),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          _MilestoneActions(milestone: m, locked: locked),
        ],
      ),
    );
  }
}

class _MilestoneActions extends ConsumerWidget {
  const _MilestoneActions({required this.milestone, required this.locked});
  final PaymentMilestone milestone;
  final bool locked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(invoicesProvider).value ?? const <Invoice>[];
    final a = ContractActions(ref, context);
    final m = milestone;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 132,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _MilestoneInvoice(
              milestone: m,
              invoice: invoices.where((i) => i.id == m.invoiceId).firstOrNull,
              today: ref.watch(todayProvider),
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
                  tooltip: context.l10n.deleteItem,
                  onPressed: () => _ctl(ref).removeMilestone(m.id),
                  icon: const Icon(Icons.close, size: 16),
                ),
        ),
      ],
    );
  }
}

/// "الدفعات = الإجمالي", or an amber warning with the difference.
class _SumCheck extends StatelessWidget {
  const _SumCheck({required this.contract, required this.check});
  final Contract contract;
  final MilestoneCheck check;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = contract;
    final amber = missingColors(context);
    final pctOff =
        check.percentSumBp != 0 &&
        check.percentSumBp != 10000 &&
        c.milestones.every((m) => m.amountMinor == null);
    final ok = check.balanced && c.milestones.isNotEmpty && !pctOff;
    final text = pctOff
        ? l.milestonesPercentOff(formatBpAsPercent(check.percentSumBp))
        : ok
        ? l.milestonesBalanced
        : l.milestonesOff(
            formatMoney(check.sum, c.currency),
            formatMoney(check.total, c.currency),
            formatMoney(check.difference, c.currency),
          );
    return Container(
      key: const ValueKey('milestone-check'),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: Space.m - 4,
        vertical: Space.s,
      ),
      decoration: BoxDecoration(
        color: ok ? context.colors.subtle : amber.bg,
        borderRadius: BorderRadius.circular(Space.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle_outline : Icons.warning_amber_rounded,
            size: 18,
            color: ok ? theme.colorScheme.primary : amber.fg,
          ),
          const SizedBox(width: Space.s),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: ok ? null : amber.fg,
              ),
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
