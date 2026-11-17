import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/contract_ops.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';

import '../helpers/contract_fixtures.dart';

void main() {
  const d = CalendarDate(2026, 9, 14);

  group('DocLanguage', () {
    test('codes round-trip; unknown falls back', () {
      for (final l in DocLanguage.values) {
        expect(DocLanguage.fromCode(l.code), l);
      }
      expect(DocLanguage.fromCode(null), DocLanguage.ar);
      expect(DocLanguage.fromCode('fr'), DocLanguage.ar);
      expect(
        DocLanguage.fromCode('xx', fallback: DocLanguage.bilingual),
        DocLanguage.bilingual,
      );
    });

    test('direction and scripts', () {
      expect(DocLanguage.ar.isRtl, isTrue);
      expect(DocLanguage.en.isRtl, isFalse);
      expect(DocLanguage.bilingual.isRtl, isFalse);
      expect(DocLanguage.bilingual.hasArabic, isTrue);
      expect(DocLanguage.bilingual.hasEnglish, isTrue);
      expect(DocLanguage.ar.hasEnglish, isFalse);
      expect(DocLanguage.en.hasArabic, isFalse);
    });

    test('DigitStyle codes; unknown is western', () {
      for (final s in DigitStyle.values) {
        expect(DigitStyle.fromCode(s.code), s);
      }
      expect(DigitStyle.fromCode(null), DigitStyle.western);
      expect(DigitStyle.fromCode('roman'), DigitStyle.western);
    });

    test('resolution: document, then client, then global (D7)', () {
      expect(
        resolveDocLanguage(
          globalDefault: DocLanguage.ar,
          client: DocLanguage.en,
          document: DocLanguage.bilingual,
        ),
        DocLanguage.bilingual,
      );
      expect(
        resolveDocLanguage(
          globalDefault: DocLanguage.ar,
          client: DocLanguage.en,
        ),
        DocLanguage.en,
      );
      expect(
        resolveDocLanguage(globalDefault: DocLanguage.ar),
        DocLanguage.ar,
      );
    });
  });

  group('dates', () {
    test('Arabic month names, digits per style', () {
      expect(formatDocDate(d, DocLanguage.ar), '14 سبتمبر 2026');
      expect(
        formatDocDate(d, DocLanguage.ar, digits: DigitStyle.arabicIndic),
        '١٤ سبتمبر ٢٠٢٦',
      );
      expect(formatDocDayMonth(d, DocLanguage.ar), '14 سبتمبر');
      expect(formatDocMonthYear(d, DocLanguage.ar), 'سبتمبر 2026');
    });

    test('English and bilingual: what invoices always printed', () {
      for (final l in [DocLanguage.en, DocLanguage.bilingual]) {
        expect(formatDocDate(d, l), formatInvoiceDate(d));
        expect(formatDocDate(d, l), '14 Sep 2026');
        // Digit style never applies to English text.
        expect(
          formatDocDate(d, l, digits: DigitStyle.arabicIndic),
          '14 Sep 2026',
        );
        expect(formatDocDayMonth(d, l), '14 Sep');
        expect(formatDocMonthYear(d, l), 'September 2026');
      }
    });

    test('same as the Arabic helpers it replaces', () {
      for (var m = 1; m <= 12; m++) {
        final x = CalendarDate(2027, m, 1);
        expect(formatDocDate(x, DocLanguage.ar), formatArabicDate(x));
        expect(formatDocMonthYear(x, DocLanguage.ar), formatArabicMonthYear(x));
      }
    });
  });

  group('headings, digits and currencies', () {
    test('clause headings', () {
      expect(clauseHeading(1, DocLanguage.ar), 'البند الأول');
      expect(clauseHeading(21, DocLanguage.ar), 'البند الحادي والعشرون');
      expect(clauseHeading(1, DocLanguage.en), 'Article 1');
      expect(clauseHeading(31, DocLanguage.en), 'Article 31');
      expect(
        clauseHeadingWithTitle(2, ' موضوع العقد ', DocLanguage.ar),
        'البند الثاني: موضوع العقد',
      );
      expect(clauseHeadingWithTitle(2, '  ', DocLanguage.en), 'Article 2');
    });

    test('digit styles', () {
      expect(
        applyDigitStyle('Page 12 of 30', DigitStyle.western),
        'Page 12 of 30',
      );
      expect(applyDigitStyle('صفحة 12', DigitStyle.arabicIndic), 'صفحة ١٢');

      // Amounts: Western keeps , and .; Arabic-Indic uses ٬ and ٫.
      expect(
        applyDigitStyle('22,000.00', DigitStyle.western),
        '22,000.00',
      );
      expect(
        applyDigitStyle('22,000.00', DigitStyle.arabicIndic),
        '٢٢٬٠٠٠٫٠٠',
      );
      expect(
        applyDigitStyle('255.50', DigitStyle.arabicIndic),
        '٢٥٥٫٥٠',
      );

      // Quantities:
      expect(applyDigitStyle('1.5', DigitStyle.western), '1.5');
      expect(applyDigitStyle('1.5', DigitStyle.arabicIndic), '١٫٥');
      expect(applyDigitStyle('1,500', DigitStyle.western), '1,500');
      expect(applyDigitStyle('1,500', DigitStyle.arabicIndic), '١٬٥٠٠');

      // Dates:
      const date = CalendarDate(2026, 9, 14);
      expect(
        formatDocDate(date, DocLanguage.ar),
        '14 سبتمبر 2026',
      );
      expect(
        formatDocDate(date, DocLanguage.ar, digits: DigitStyle.arabicIndic),
        '١٤ سبتمبر ٢٠٢٦',
      );

      // Totals with formatDocMoney:
      expect(
        formatDocMoney(
          18000000,
          Currency.egp,
          DocLanguage.ar,
        ),
        '180,000 جنيه مصري',
      );
      expect(
        formatDocMoney(
          18000000,
          Currency.egp,
          DocLanguage.ar,
          digits: DigitStyle.arabicIndic,
        ),
        '١٨٠٬٠٠٠ جنيه مصري',
      );
    });

    test('currency names per language', () {
      for (final c in Currency.values) {
        expect(currencyName(c, DocLanguage.ar), currencyNameAr(c));
        expect(currencyName(c, DocLanguage.en), isNotEmpty);
      }
      expect(
        formatDocMoney(18000000, Currency.egp, DocLanguage.en),
        '180,000 Egyptian pounds',
      );
      expect(
        formatDocMoney(18000000, Currency.egp, DocLanguage.ar),
        '180,000 جنيه مصري',
      );
    });
  });

  test('default milestones follow the language; Arabic unchanged', () {
    var n = 0;
    String id() => 'm${n++}';
    final ar = defaultMilestones(TemplateKind.contract, id);
    expect(ar.map((m) => m.label), [
      'الدفعة المقدمة',
      'الدفعة الثانية',
      'الدفعة الأخيرة',
    ]);
    final en = defaultMilestones(
      TemplateKind.quote,
      id,
      language: DocLanguage.en,
    );
    expect(en.map((m) => m.label), ['Advance payment', 'Final payment']);
    expect(en.map((m) => m.percentBp), [5000, 5000]);
  });

  test('contract variables follow the resolver language', () {
    VariableResolver r([DocLanguage? l]) => l == null
        ? VariableResolver(
            contract: acmeContract(),
            client: acme,
            settings: sampleSettings,
          )
        : VariableResolver(
            contract: acmeContract(),
            client: acme,
            settings: sampleSettings,
            language: l,
          );
    expect(r().resolve('total'), '180,000 جنيه مصري');
    expect(r().resolve('contract.date'), '15 نوفمبر 2026');
    final en = r(DocLanguage.en);
    expect(en.resolve('total'), '180,000 Egyptian pounds');
    expect(en.resolve('currency'), 'Egyptian pounds');
    expect(en.resolve('contract.date'), '15 Nov 2026');
  });
}
