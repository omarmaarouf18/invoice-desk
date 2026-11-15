import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';

void main() {
  group('Money', () {
    test('arithmetic stays in minor units', () {
      const a = Money(1050, Currency.egp);
      expect(
        a + const Money(25, Currency.egp),
        const Money(1075, Currency.egp),
      );
      expect(a.times(3), const Money(3150, Currency.egp));
      expect(const Money.zero(Currency.usd).isZero, isTrue);
      expect(a.compareTo(const Money(2000, Currency.egp)), lessThan(0));
    });

    test('adding different currencies is a programming error', () {
      expect(
        () => const Money(1, Currency.egp) + const Money(1, Currency.usd),
        throwsA(isA<AssertionError>()),
      );
    });

    test('value equality and printing', () {
      const a = Money(25550, Currency.usd);
      expect(a, const Money(25550, Currency.usd));
      expect(a == const Money(25550, Currency.eur), isFalse);
      expect(a.hashCode, const Money(25550, Currency.usd).hashCode);
      expect('$a', r'$255.50');
      expect(formatMoney(-500, Currency.eur), '-€5.00');
      expect(formatMoney(150000, Currency.sar), '1,500 SAR');
      expect(formatMoney(150050, Currency.aed), '1,500.50 AED');
    });

    test('MoneyBag keeps currencies apart and compares by value', () {
      final a = MoneyBag()
        ..add(const Money(100, Currency.egp))
        ..add(const Money(0, Currency.usd));
      final b = MoneyBag({Currency.egp: 100});
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a.entries, hasLength(2));
      expect(a.nonZero, hasLength(1));
      expect('$a', '1 EGP');
      expect(MoneyBag().format(empty: '—'), '—');
      expect(a == MoneyBag({Currency.egp: 101}), isFalse);
    });

    test('percent input and output', () {
      expect(parsePercentToBp('14'), 1400);
      expect(parsePercentToBp('12.5'), 1250);
      expect(parsePercentToBp('١٤٫٥'), 1450);
      expect(parsePercentToBp('abc'), isNull);
      expect(formatBpAsPercent(1400), '14');
      expect(formatBpAsPercent(1250), '12.5');
      expect(formatBpAsPercent(1205), '12.05');
      expect(parseIntInput('١٢'), 12);
      expect(parseIntInput('-3'), isNull);
      expect(parseIntInput(''), 0);
      expect(parseMoneyInput('1.234'), isNull);
    });

    test('currency codes round-trip; unknown codes throw', () {
      for (final c in Currency.values) {
        expect(Currency.fromCode(c.code), c);
      }
      expect(() => Currency.fromCode('XXX'), throwsStateError);
    });
  });

  group('CalendarDate', () {
    test('parse throws on bad input; tryParse returns null', () {
      expect(() => CalendarDate.parse('2026-02-30'), throwsFormatException);
      expect(CalendarDate.tryParse(null), isNull);
      expect(CalendarDate.tryParse('15/11/2026'), isNull);
      expect(CalendarDate.tryParse('2026-13-01'), isNull);
      expect(
        CalendarDate.tryParse('٢٠٢٦-١١-١٥'),
        const CalendarDate(2026, 11, 15),
      );
    });

    test('ordering, equality and conversions', () {
      const a = CalendarDate(2025, 12, 31);
      const b = CalendarDate(2026, 1, 1);
      expect(a.compareTo(b), lessThan(0));
      expect(b.compareTo(a), greaterThan(0));
      expect(const CalendarDate(2026, 1, 2).compareTo(b), greaterThan(0));
      expect(a.isBefore(b), isTrue);
      expect(b.isBefore(b), isFalse);
      expect(a.addDays(1), b);
      expect(b.addDays(-1), a);
      expect(a.daysUntil(b), 1);
      expect(b.toDateTime(), DateTime(2026));
      expect(a.hashCode, const CalendarDate(2025, 12, 31).hashCode);
      expect('$a', '2025-12-31');
      expect(formatInvoiceDate(b), '1 Jan 2026');
      expect(formatArabicDayMonth(b), '1 يناير');
    });
  });

  group('digits', () {
    test('Arabic-Indic and Eastern Arabic-Indic digits become Western', () {
      expect(normalizeDigits('٠١٢٣٤٥٦٧٨٩'), '0123456789');
      expect(normalizeDigits('۰۱۲۳۴۵۶۷۸۹'), '0123456789');
      expect(normalizeDigits('OM-٢٠٢٦'), 'OM-2026');
    });

    test('search folding and LTR isolation', () {
      expect(
        foldForSearch('أحمد إبراهيم آية مدرسة على'),
        'احمد ابراهيم ايه مدرسه علي',
      );
      expect(foldForSearch('مـــدرسةٌ'), 'مدرسه');
      expect(ltr('EG12'), '\u2066EG12\u2069');
    });
  });
}
