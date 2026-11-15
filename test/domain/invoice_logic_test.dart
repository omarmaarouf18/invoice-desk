import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

var _n = 0;
String _id() => 'id${_n++}';

Invoice _invoice({
  InvoiceStatus status = InvoiceStatus.sent,
  bool vat = false,
  List<InvoiceSection>? sections,
}) => Invoice(
  id: 'inv',
  clientId: 'c',
  number: 'OM-2026-0001',
  year: 2026,
  seq: 1,
  issueDate: const CalendarDate(2026, 9, 14),
  dueDate: const CalendarDate(2026, 10, 14),
  status: status,
  vatOn: vat,
  sections:
      sections ??
      [
        InvoiceSection(
          id: 's1',
          currency: Currency.egp,
          items: [
            LineItem(id: _id(), unitPriceMinor: 2200000),
          ],
        ),
        InvoiceSection(
          id: 's2',
          currency: Currency.usd,
          items: [
            LineItem(
              id: _id(),
              cycle: BillingCycle.annual,
              unitPriceMinor: 1150,
            ),
            LineItem(
              id: _id(),
              cycle: BillingCycle.monthly,
              unitPriceMinor: 10000,
            ),
            LineItem(
              id: _id(),
              cycle: BillingCycle.annual,
              unitPriceMinor: 9900,
            ),
            LineItem(id: _id(), unitPriceMinor: 2500),
            LineItem(
              id: _id(),
              cycle: BillingCycle.monthly,
              unitPriceMinor: 2000,
            ),
          ],
        ),
      ],
);

void main() {
  group('totals', () {
    test('line, section and multi-currency invoice totals', () {
      const item = LineItem(id: 'x', qty: 3, unitPriceMinor: 1250);
      expect(item.lineMinor, 3750);
      final inv = _invoice();
      expect(inv.sections[1].subtotal, const Money(25550, Currency.usd));
      expect(inv.totals.total.format(), r'22,000 EGP + $255.50');
      expect(inv.totals.vat.isEmpty, isTrue);
    });

    test('VAT applies per currency', () {
      final t = _invoice(vat: true).totals;
      expect(t.vat.of(Currency.egp), 308000);
      expect(t.vat.of(Currency.usd), 3577);
      expect(t.total.of(Currency.usd), 29127);
    });

    test('sections with the same currency add up', () {
      final inv = _invoice(
        sections: const [
          InvoiceSection(
            id: 'a',
            currency: Currency.usd,
            items: [LineItem(id: '1', unitPriceMinor: 100)],
          ),
          InvoiceSection(
            id: 'b',
            currency: Currency.usd,
            items: [LineItem(id: '2', qty: 2, unitPriceMinor: 50)],
          ),
        ],
      );
      expect(inv.totals.total.format(), r'$2.00');
    });
  });

  group('numbering', () {
    test('next seq per year and rollover', () {
      final used = [
        (year: 2026, seq: 1),
        (year: 2026, seq: 7),
        (year: 2025, seq: 40),
      ];
      expect(nextSeq(used, 2026), 8);
      expect(nextSeq(used, 2027), 1);
      expect(nextSeq(const [], 2026), 1);
      expect(formatInvoiceNumber('OM', 2026, 8), 'OM-2026-0008');
      expect(parseInvoiceNumber('XY-2027-0012'), (year: 2027, seq: 12));
      expect(parseInvoiceNumber('custom'), isNull);
    });

    test('validation flags duplicates and missing fields', () {
      final inv = _invoice().copyWith(clientId: '');
      expect(
        validateInvoice(inv, numberTaken: (n, id) => n == 'OM-2026-0001'),
        {InvoiceIssue.missingClient, InvoiceIssue.duplicateNumber},
      );
      expect(
        validateInvoice(
          inv.copyWith(number: ' ', clientId: 'c'),
          numberTaken: (_, _) => false,
        ),
        {InvoiceIssue.emptyNumber},
      );
    });
  });

  group('renewal', () {
    test('keeps only monthly and annual items', () {
      final out = renewalSections(_invoice().sections, _id)!;
      expect(out, hasLength(1));
      expect(out.single.currency, Currency.usd);
      expect(out.single.items.map((i) => i.unitPriceMinor), [
        1150,
        10000,
        9900,
        2000,
      ]);
      expect(out.single.items.every((i) => i.cycle.isRecurring), isTrue);
    });

    test('returns null when nothing recurs', () {
      final secs = [
        InvoiceSection(
          id: 's',
          currency: Currency.egp,
          items: [LineItem(id: _id(), unitPriceMinor: 5)],
        ),
      ];
      expect(renewalSections(secs, _id), isNull);
    });
  });

  group('overdue', () {
    final inv = _invoice();
    test('derived against the injected day', () {
      expect(inv.isOverdue(const CalendarDate(2026, 10, 14)), isFalse);
      expect(inv.isOverdue(const CalendarDate(2026, 10, 15)), isTrue);
      expect(
        inv.displayStatus(const CalendarDate(2026, 11, 15)),
        DisplayStatus.overdue,
      );
      final paid = inv.copyWith(status: InvoiceStatus.paid);
      expect(paid.isOverdue(const CalendarDate(2027, 1, 1)), isFalse);
      final draft = inv.copyWith(status: InvoiceStatus.draft);
      expect(
        draft.displayStatus(const CalendarDate(2027, 1, 1)),
        DisplayStatus.draft,
      );
    });
  });
}
