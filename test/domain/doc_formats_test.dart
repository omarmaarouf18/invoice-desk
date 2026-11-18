import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';

void main() {
  group('currency display: every currency × language × mode', () {
    // 22,000.00 in each currency; USD/EUR always show decimals.
    const minor = 2200000;
    final expected = <(Currency, DocLanguage, CurrencyDisplay), String>{};
    for (final c in Currency.values) {
      final code = formatMoney(minor, c); // today's output
      for (final lang in DocLanguage.values) {
        expected[(c, lang, CurrencyDisplay.code)] = code;
        expected[(c, lang, CurrencyDisplay.symbol)] = code;
        expected[(c, lang, CurrencyDisplay.local)] = code;
      }
    }
    // The only differences: Arabic documents in local mode.
    expected[(Currency.egp, DocLanguage.ar, CurrencyDisplay.local)] =
        '22,000 ج.م';
    expected[(Currency.sar, DocLanguage.ar, CurrencyDisplay.local)] =
        '22,000 ر.س';
    expected[(Currency.aed, DocLanguage.ar, CurrencyDisplay.local)] =
        '22,000 د.إ';

    for (final MapEntry(key: (c, lang, mode), value: want)
        in expected.entries) {
      test('${c.code} ${lang.name} ${mode.name}', () {
        expect(formatDocCurrency(minor, c, lang, mode), want);
      });
    }

    test('code mode is exactly today', () {
      expect(
        formatDocCurrency(
          2200000,
          Currency.egp,
          DocLanguage.ar,
          CurrencyDisplay.code,
        ),
        '22,000 EGP',
      );
      expect(
        formatDocCurrency(
          25550,
          Currency.usd,
          DocLanguage.ar,
          CurrencyDisplay.code,
        ),
        r'$255.50',
      );
    });

    test('negative amounts keep their sign before the number', () {
      expect(
        formatDocCurrency(
          -150,
          Currency.egp,
          DocLanguage.ar,
          CurrencyDisplay.local,
        ),
        '-1.50 ج.م',
      );
    });

    test('bags keep currencies apart', () {
      final bag = MoneyBag()
        ..add(const Money(2200000, Currency.egp))
        ..add(const Money(25550, Currency.usd));
      expect(
        formatDocCurrencyBag(bag, DocLanguage.ar, CurrencyDisplay.local),
        r'22,000 ج.م + $255.50',
      );
      expect(
        formatDocCurrencyBag(bag, DocLanguage.en, CurrencyDisplay.local),
        bag.format(),
      );
    });
  });

  group('date format', () {
    const d = CalendarDate(2026, 9, 4);
    test("long is today's output", () {
      for (final lang in DocLanguage.values) {
        expect(
          formatDocDateAs(d, lang, DocDateFormat.long),
          formatDocDate(d, lang),
        );
      }
    });

    test('numeric is day first, with Arabic digits only in Arabic', () {
      expect(
        formatDocDateAs(d, DocLanguage.en, DocDateFormat.numeric),
        '04/09/2026',
      );
      expect(
        formatDocDateAs(
          d,
          DocLanguage.bilingual,
          DocDateFormat.numeric,
          digits: DigitStyle.arabicIndic,
        ),
        '04/09/2026',
      );
      expect(
        formatDocDateAs(
          d,
          DocLanguage.ar,
          DocDateFormat.numeric,
          digits: DigitStyle.arabicIndic,
        ),
        '٠٤/٠٩/٢٠٢٦',
      );
    });

    test('unknown stored values fall back to the defaults', () {
      expect(DocDateFormat.fromCode('x'), DocDateFormat.long);
      expect(CurrencyDisplay.fromDb(null), CurrencyDisplay.code);
      expect(CurrencyDisplay.fromDb('local'), CurrencyDisplay.local);
    });
  });
}
