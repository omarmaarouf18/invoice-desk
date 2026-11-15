import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';

void main() {
  group('Money', () {
    test('formats per currency', () {
      expect(const Money(2200000, Currency.egp).format(), '22,000 EGP');
      expect(const Money(25550, Currency.usd).format(), r'$255.50');
      expect(const Money(150, Currency.egp).format(), '1.50 EGP');
      expect(const Money(100000, Currency.eur).format(), '€1,000.00');
    });

    test('bag keeps currencies apart', () {
      final bag = MoneyBag()
        ..add(const Money(2200000, Currency.egp))
        ..add(const Money(25550, Currency.usd))
        ..add(const Money(0, Currency.sar));
      expect(bag.format(), r'22,000 EGP + $255.50');
      expect(MoneyBag().format(empty: '—'), '—');
    });

    test('VAT in basis points rounds half-up', () {
      expect(applyBasisPoints(10000, 1400), 1400);
      expect(applyBasisPoints(1150, 1400), 161); // 161.0
      expect(applyBasisPoints(1, 5000), 1); // 0.5 → 1
      expect(applyBasisPoints(3, 1400), 0); // 0.42 → 0
      expect(applyBasisPoints(25550, 1400), 3577); // 3577.0
      expect(applyBasisPoints(1075, 1400), 151); // 150.5 → 151
    });

    test('parses input with Arabic-Indic digits and separators', () {
      expect(parseMoneyInput('٢٢٬٠٠٠'), 2200000);
      expect(parseMoneyInput('22,000.5'), 2200050);
      expect(parseMoneyInput('11.50'), 1150);
      expect(parseMoneyInput('١١٫٥'), 1150);
      expect(parseMoneyInput('-5'), isNull);
      expect(parseMoneyInput('1.234'), isNull);
      expect(parseIntInput('٣'), 3);
      expect(parseIntInput('x'), isNull);
    });
  });

  group('dates & digits', () {
    test('formats', () {
      const d = CalendarDate(2026, 9, 14);
      expect(formatArabicDate(d), '14 سبتمبر 2026');
      expect(formatInvoiceDate(d), '14 Sep 2026');
      expect(d.addDays(30), const CalendarDate(2026, 10, 14));
      expect(CalendarDate.tryParse('٢٠٢٦-٠٩-١٤'), d);
      expect(CalendarDate.tryParse('2026-02-30'), isNull);
    });

    test('folds for search', () {
      expect(foldForSearch('أحمد'), foldForSearch('احمد'));
      expect(foldForSearch('OM-٢٠٢٦'), 'om-2026');
    });
  });
}
