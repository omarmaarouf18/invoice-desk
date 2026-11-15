part of '../editor_cards.dart';

class TotalsCard extends ConsumerWidget {
  const TotalsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final vatOn = _watchInv(ref, (i) => i.vatOn);
    final rate = _watchInv(ref, (i) => i.vatRateBp);
    final totals = _watchInv(ref, (i) => i.totals.total);
    final inv = ref.read(editorProvider).invoice!;
    final t = inv.totals;
    final due = _watchInv(ref, (i) => i.dueDate);
    final ctl = _ctl(ref);

    Widget row(String k, String v, {TextStyle? style}) => Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.muted,
              ),
            ),
          ),
          Text(
            v,
            textDirection: TextDirection.ltr,
            style: style ?? theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );

    return PanelCard(
      title: l.cardTotals,
      icon: Icons.calculate_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Switch(
                value: vatOn,
                onChanged: (v) => ctl.edit((i) => i.copyWith(vatOn: v)),
              ),
              const SizedBox(width: Space.s),
              Expanded(child: Text(l.vat, style: theme.textTheme.bodyLarge)),
              SizedBox(
                width: 120,
                child: _RateField(
                  bp: rate,
                  enabled: vatOn,
                  onChanged: (bp) => ctl.edit((i) => i.copyWith(vatRateBp: bp)),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          const Divider(),
          const SizedBox(height: Space.s),
          row(l.subtotal, t.subtotal.format()),
          if (vatOn)
            row(
              '${l.vatLine} (${formatBpAsPercent(rate)}%)',
              t.vat.format(),
            ),
          const SizedBox(height: Space.s),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Space.m,
              vertical: Space.m - 4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.inverseSurface,
              borderRadius: BorderRadius.circular(Space.radiusSmall),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.totalDue,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                      Text(
                        l.dueBy(formatArabicDate(due)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onInverseSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final m in totals.nonZero)
                      Text(
                        m.format(),
                        textDirection: TextDirection.ltr,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                    if (totals.isEmpty)
                      Text(
                        '0',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RateField extends StatefulWidget {
  const _RateField({
    required this.bp,
    required this.enabled,
    required this.onChanged,
  });
  final int bp;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  State<_RateField> createState() => _RateFieldState();
}

class _RateFieldState extends State<_RateField> {
  bool _bad = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: SyncedTextField(
          label: l.vatRate,
          value: formatBpAsPercent(widget.bp),
          textDirection: TextDirection.ltr,
          errorText: _bad ? l.errRate : null,
          onChanged: (v) {
            final bp = parsePercentToBp(v);
            final ok = bp != null && bp <= 10000;
            setState(() => _bad = !ok);
            if (ok) widget.onChanged(bp);
          },
        ),
      ),
    );
  }
}
