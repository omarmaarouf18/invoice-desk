part of '../settings_page.dart';

const ({String prefix, String year, String yy, String seq}) _tokens = (
  prefix: '{PREFIX}',
  year: '{YYYY}',
  yy: '{YY}',
  seq: '{SEQ:4}',
);

/// Numbering pattern, yearly reset and a live "next number" preview.
/// Existing numbers are never rewritten.
class _NumberingCard extends ConsumerWidget {
  const _NumberingCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final problem = checkNumberPattern(
      s.invoiceNumberPattern,
      yearlyReset: s.numberYearlyReset,
    );
    final error = switch (problem) {
      NumberPatternProblem.noSequence => l.numberPatternNoSeq(_tokens.seq),
      NumberPatternProblem.noYearWithReset => l.numberPatternNoYear(
        _tokens.year,
        _tokens.yy,
      ),
      null => null,
    };
    return PanelCard(
      title: l.numberingTitle,
      icon: Icons.tag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SyncedTextField(
            key: const ValueKey('number-pattern'),
            label: l.numberPattern,
            value: s.invoiceNumberPattern,
            textDirection: TextDirection.ltr,
            errorText: error,
            onChanged: (v) =>
                update((x) => x.copyWith(invoiceNumberPattern: v.trim())),
          ),
          const SizedBox(height: Space.xs),
          Text(
            l.numberPatternHint(
              _tokens.prefix,
              _tokens.year,
              _tokens.yy,
              _tokens.seq,
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SwitchListTile(
            key: const ValueKey('number-yearly-reset'),
            contentPadding: EdgeInsets.zero,
            title: Text(l.numberYearlyReset),
            value: s.numberYearlyReset,
            onChanged: (v) => update((x) => x.copyWith(numberYearlyReset: v)),
          ),
          if (problem == null) _NextNumberPreview(s: s),
          Text(
            l.numberExistingKept,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.colors.muted),
          ),
        ],
      ),
    );
  }
}

class _NextNumberPreview extends ConsumerWidget {
  const _NextNumberPreview({required this.s});
  final Settings s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.read(clockProvider).now().year;
    return FutureBuilder<String>(
      key: ValueKey(
        '${s.invoicePrefix}|${s.invoiceNumberPattern}|${s.numberYearlyReset}',
      ),
      future: ref.read(invoiceRepositoryProvider).previewNumber(s, year),
      builder: (context, snap) => Padding(
        padding: const EdgeInsets.only(bottom: Space.xs),
        child: Text(
          context.l10n.numberNextPreview(snap.data ?? '…'),
          key: const ValueKey('number-next-preview'),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}

/// Default VAT for new invoices and the tax registration number.
class _TaxCard extends StatelessWidget {
  const _TaxCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PanelCard(
      title: l.taxVatTitle,
      icon: Icons.percent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            key: const ValueKey('default-vat-on'),
            contentPadding: EdgeInsets.zero,
            title: Text(l.defaultVatOn),
            value: s.defaultVatOn,
            onChanged: (v) => update((x) => x.copyWith(defaultVatOn: v)),
          ),
          _SPair(
            SyncedTextField(
              key: const ValueKey('default-vat-rate'),
              label: l.defaultVatRate,
              value: formatBpAsPercent(s.defaultVatRateBp),
              textDirection: TextDirection.ltr,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (v) {
                final bp = parsePercentToBp(v);
                if (bp != null && bp <= 10000) {
                  update((x) => x.copyWith(defaultVatRateBp: bp));
                }
              },
            ),
            _SettingField(
              update,
              l.taxRegistrationNo,
              s.taxRegistrationNo,
              (x, v) => x.copyWith(taxRegistrationNo: v.trim()),
              dir: TextDirection.ltr,
              hint: l.taxRegistrationNoHint,
            ),
          ),
        ],
      ),
    );
  }
}

/// Date format, default currency and currency display.
class _DocFormatsCard extends ConsumerWidget {
  const _DocFormatsCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final today = CalendarDate.fromDateTime(ref.read(clockProvider).now());
    final muted = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: context.colors.muted);
    return PanelCard(
      title: l.docFormatsTitle,
      icon: Icons.text_format,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.dateFormatLabel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: Space.xs),
          SegmentedButton<DocDateFormat>(
            key: const ValueKey('date-format'),
            showSelectedIcon: false,
            segments: [
              for (final f in DocDateFormat.values)
                ButtonSegment(
                  value: f,
                  label: Ltr(formatDocDateAs(today, DocLanguage.en, f)),
                ),
            ],
            selected: {s.dateFormat},
            onSelectionChanged: (v) =>
                update((x) => x.copyWith(dateFormat: v.first)),
          ),
          const SizedBox(height: Space.m),
          _CurrencyChoices(s: s, update: update),
          const SizedBox(height: Space.s),
          Text(l.docFormatsFrozenHint, style: muted),
        ],
      ),
    );
  }
}

class _CurrencyChoices extends StatelessWidget {
  const _CurrencyChoices({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final labels = Theme.of(context).textTheme.labelLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<Currency>(
          key: ValueKey('default-currency-${s.defaultCurrency.code}'),
          initialValue: s.defaultCurrency,
          decoration: InputDecoration(labelText: l.defaultCurrencyLabel),
          items: [
            for (final c in Currency.values)
              DropdownMenuItem(value: c, child: Ltr(c.code)),
          ],
          onChanged: (c) {
            if (c != null) update((x) => x.copyWith(defaultCurrency: c));
          },
        ),
        const SizedBox(height: Space.m),
        Text(l.currencyDisplayLabel, style: labels),
        const SizedBox(height: Space.xs),
        SegmentedButton<CurrencyDisplay>(
          key: const ValueKey('currency-display'),
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: CurrencyDisplay.code,
              label: Text('${l.currencyDisplayCode} · EGP'),
            ),
            ButtonSegment(
              value: CurrencyDisplay.local,
              label: Text('${l.currencyDisplayLocal} · ج.م'),
            ),
            ButtonSegment(
              value: CurrencyDisplay.symbol,
              label: Text('${l.currencyDisplaySymbol} · \$'),
            ),
          ],
          selected: {s.currencyDisplay},
          onSelectionChanged: (v) =>
              update((x) => x.copyWith(currencyDisplay: v.first)),
        ),
        const SizedBox(height: Space.xs),
        Text(
          l.currencyDisplayHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
