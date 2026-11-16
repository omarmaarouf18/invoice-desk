import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/events.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/summary.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';

const today = CalendarDate(2026, 11, 15);
final clk = Clock.fixed(DateTime(2026, 11, 15, 10));
const client = Client(id: 'c1', name: 'Acme Studio');
final wide = DateRange(today.addDays(-400), today.addDays(400));

Invoice inv(
  String id, {
  InvoiceStatus status = InvoiceStatus.sent,
  CalendarDate issue = const CalendarDate(2026, 11, 1),
  CalendarDate due = const CalendarDate(2026, 11, 20),
  CalendarDate? paid,
  List<LineItem>? items,
  Currency currency = Currency.egp,
  ScopePage scope = const ScopePage(),
}) => Invoice(
  id: id,
  clientId: 'c1',
  number: 'INV-$id',
  year: issue.year,
  seq: 1,
  issueDate: issue,
  dueDate: due,
  paidDate: paid,
  status: status,
  scope: scope,
  sections: [
    InvoiceSection(
      id: 's$id',
      currency: currency,
      items:
          items ??
          [LineItem(id: 'l$id', service: 'Work', unitPriceMinor: 1000)],
    ),
  ],
);

List<CalendarEvent> run(
  CalendarData d, {
  DateRange? range,
  Clock? clock,
}) => calendarEvents(range ?? wide, d, clock ?? clk);

Postponement pp(
  String id,
  String entity,
  CalendarDate from,
  CalendarDate to,
  int at, {
  PostponedEntity type = PostponedEntity.invoice,
}) => Postponement(
  id: id,
  entityType: type,
  entityId: entity,
  fromDate: from,
  toDate: to,
  reason: 'r$id',
  createdAt: at,
);

void main() {
  group('invoices', () {
    test('sent and not yet due → due on its due date', () {
      final e = run(CalendarData(invoices: [inv('a')], clients: const [client]));
      expect(e.single.type, CalendarEventType.due);
      expect(e.single.date, const CalendarDate(2026, 11, 20));
      expect(e.single.clientName, 'Acme Studio');
      expect(e.single.amounts.single, const Money(1000, Currency.egp));
    });

    test('due today is not overdue; yesterday is, with a rollup today', () {
      final e = run(
        CalendarData(
          invoices: [
            inv('a', due: today),
            inv('b', due: today.addDays(-10)),
          ],
        ),
      );
      final a = e.firstWhere((x) => x.invoiceId == 'a');
      final b = e.firstWhere((x) => x.invoiceId == 'b');
      expect(a.type, CalendarEventType.due);
      expect(b.type, CalendarEventType.overdue);
      expect(b.daysOverdue, 10);
      final roll = e.singleWhere(
        (x) => x.type == CalendarEventType.overdueRollup,
      );
      expect(roll.date, today);
      expect(roll.count, 1);
    });

    test('the rollup counts overdue invoices outside the range', () {
      final e = run(
        CalendarData(invoices: [inv('b', due: today.addDays(-60))]),
        range: DateRange(today.addDays(-3), today.addDays(3)),
      );
      expect(e.single.type, CalendarEventType.overdueRollup);
      expect(e.single.count, 1);
    });

    test('paid → paid event on the paid date; draft and void → nothing', () {
      final e = run(
        CalendarData(
          invoices: [
            inv('p', status: InvoiceStatus.paid, paid: today.addDays(-2)),
            inv('d', status: InvoiceStatus.draft),
            inv('v', status: InvoiceStatus.voided),
          ],
        ),
      );
      expect(e.single.type, CalendarEventType.paid);
      expect(e.single.date, today.addDays(-2));
    });
  });

  group('postponements', () {
    test('a chain: the latest move wins, the original stays visible', () {
      final i = inv('a', due: today.addDays(-5));
      final e = run(
        CalendarData(
          invoices: [i],
          postponements: [
            pp('2', 'a', today.addDays(2), today.addDays(9), 20),
            pp('1', 'a', today.addDays(-5), today.addDays(2), 10),
          ],
        ),
      );
      expect(e.single.type, CalendarEventType.postponed);
      expect(e.single.date, today.addDays(9));
      expect(e.single.originalDate, today.addDays(-5));
      expect(e.single.reason, 'r2');
    });

    test('overdue is measured against the effective date', () {
      // Due in the future but postponed to the past → overdue.
      final e = run(
        CalendarData(
          invoices: [inv('a', due: today.addDays(5))],
          postponements: [pp('1', 'a', today.addDays(5), today.addDays(-3), 1)],
        ),
      );
      final a = e.firstWhere((x) => x.invoiceId == 'a');
      expect(a.type, CalendarEventType.overdue);
      expect(a.daysOverdue, 3);
      expect(
        inv(
          'a',
          due: today.addDays(-3),
        ).copyWith(postponedTo: () => today.addDays(4)).effectiveDueDate,
        today.addDays(4),
      );
    });
  });

  group('contracts', () {
    Contract contract({
      ContractStatus status = ContractStatus.signed,
      List<PaymentMilestone> ms = const [],
      Map<String, String> vars = const {},
    }) => Contract(
      id: 'k',
      clientId: 'c1',
      number: 'CT-2026-0001',
      year: 2026,
      seq: 1,
      issueDate: today.addDays(-30),
      status: status,
      title: 'App',
      startDate: today.addDays(-20),
      endDate: today.addDays(21),
      totalMinor: 100000,
      vars: vars,
      milestones: ms,
    );

    test('start, end and warranty end', () {
      final e = run(
        CalendarData(
          contracts: [
            contract(vars: {'warrantyMonths': '6'}),
          ],
        ),
      );
      expect(e.map((x) => x.type), [
        CalendarEventType.contractStart,
        CalendarEventType.contractEnd,
        CalendarEventType.warrantyEnd,
      ]);
      expect(e.last.date, today.addDays(21).addMonths(6));
    });

    test('draft contracts and quotes show nothing', () {
      expect(
        run(CalendarData(contracts: [contract(status: ContractStatus.draft)])),
        isEmpty,
      );
    });

    test('milestones: not invoiced shows, sent invoice takes over', () {
      final ms = [
        PaymentMilestone(id: 'm1', percentBp: 5000, dueDate: today.addDays(4)),
        PaymentMilestone(
          id: 'm2',
          percentBp: 3000,
          dueDate: today.addDays(-4),
        ),
        PaymentMilestone(
          id: 'm3',
          percentBp: 2000,
          dueDate: today.addDays(8),
          invoiceId: 'i3',
        ),
      ];
      final e = run(
        CalendarData(
          contracts: [contract(ms: ms)],
          invoices: [inv('i3', due: today.addDays(8))],
        ),
      ).where((x) => x.milestoneId != null).toList();
      expect(e.map((x) => x.milestoneId), ['m2', 'm1']);
      expect(e.first.isLate, isTrue);
      expect(e.first.daysOverdue, 4);
      expect(e.last.amounts.single.minor, 50000);
    });

    test('a postponed milestone moves', () {
      final e = run(
        CalendarData(
          contracts: [
            contract(
              ms: [PaymentMilestone(id: 'm1', dueDate: today.addDays(1))],
            ),
          ],
          postponements: [
            pp(
              '1',
              'm1',
              today.addDays(1),
              today.addDays(6),
              1,
              type: PostponedEntity.milestone,
            ),
          ],
        ),
      ).singleWhere((x) => x.milestoneId == 'm1');
      expect(e.type, CalendarEventType.postponed);
      expect(e.date, today.addDays(6));
    });
  });

  group('renewals', () {
    List<LineItem> recurring() => [
      const LineItem(
        id: 'm',
        service: 'Hosting',
        cycle: BillingCycle.monthly,
        unitPriceMinor: 500,
      ),
      const LineItem(
        id: 'y',
        service: 'Domain',
        cycle: BillingCycle.annual,
        unitPriceMinor: 1500,
      ),
      const LineItem(id: 'o', service: 'Setup', unitPriceMinor: 9000),
    ];

    test('monthly repeats (end of month clamps), annual once a year', () {
      final p = inv(
        'p',
        status: InvoiceStatus.paid,
        issue: const CalendarDate(2026, 1, 31),
        paid: const CalendarDate(2026, 2, 1),
        items: recurring(),
      );
      final e = run(
        CalendarData(invoices: [p]),
        range: const DateRange(
          CalendarDate(2026, 2, 1),
          CalendarDate(2027, 2, 28),
        ),
      ).where((x) => x.type == CalendarEventType.renewal).toList();
      expect(e.first.date, const CalendarDate(2026, 2, 28));
      expect(e[1].date, const CalendarDate(2026, 3, 31));
      expect(e, hasLength(13));
      final jan = e.singleWhere(
        (x) => x.date == const CalendarDate(2027, 1, 31),
      );
      expect(jan.title, 'Hosting، Domain');
      expect(jan.amounts.single.minor, 2000);
    });

    test('stops per service once a renewal invoice exists', () {
      final p = inv(
        'p',
        status: InvoiceStatus.paid,
        issue: today.addDays(-40),
        paid: today.addDays(-40),
        items: recurring(),
      );
      final r = inv(
        'r',
        status: InvoiceStatus.draft,
        issue: today.addDays(-5),
        items: [
          const LineItem(
            id: 'm2',
            service: ' hosting ',
            cycle: BillingCycle.monthly,
          ),
        ],
      );
      final e = run(
        CalendarData(invoices: [p, r]),
      ).where((x) => x.type == CalendarEventType.renewal);
      expect(e.every((x) => x.title == 'Domain'), isTrue);
      expect(e, isNotEmpty);
    });

    test('unpaid invoices do not renew', () {
      final e = run(CalendarData(invoices: [inv('s', items: recurring())]));
      expect(e.where((x) => x.type == CalendarEventType.renewal), isEmpty);
    });
  });

  test('invoice scope warranty in months', () {
    expect(warrantyMonthsIn('ضمان ٣ أشهر'), 3);
    expect(warrantyMonthsIn('6 months support'), 6);
    expect(warrantyMonthsIn('بدون'), isNull);
    final e = run(
      CalendarData(
        invoices: [
          inv(
            'w',
            status: InvoiceStatus.paid,
            paid: today,
            scope: const ScopePage(enabled: true, warranty: 'ضمان 1 شهر'),
          ),
        ],
      ),
    ).singleWhere((x) => x.type == CalendarEventType.warrantyEnd);
    expect(e.date, today.addMonths(1));
  });

  test('reminders keep their time and done state', () {
    final e = run(
      const CalendarData(
        reminders: [
          Reminder(id: 'r', date: today, text: 'Call', time: '09:30'),
          Reminder(id: 'd', date: today, text: 'Done', doneAt: 1),
        ],
      ),
    );
    expect(e.firstWhere((x) => x.reminderId == 'r').time, '09:30');
    expect(e.firstWhere((x) => x.reminderId == 'd').done, isTrue);
  });

  test('range boundaries are inclusive on both ends', () {
    final d = CalendarData(
      invoices: [
        inv('a', due: const CalendarDate(2026, 11, 30)),
        inv('b', due: const CalendarDate(2026, 12, 1)),
      ],
    );
    final e = run(
      d,
      range: const DateRange(
        CalendarDate(2026, 11, 20),
        CalendarDate(2026, 11, 30),
      ),
    );
    expect(e.map((x) => x.invoiceId), ['a']);
  });

  group('week start and civil dates', () {
    test('month grid starts on the chosen weekday and spans 42 days', () {
      const nov = CalendarDate(2026, 11, 1); // a Sunday
      for (final ws in WeekStart.values) {
        final g = ws.monthGrid(nov);
        expect(g.start.weekday, ws.isoWeekday);
        expect(g.start.daysUntil(g.end), 41);
        expect(g.contains(nov), isTrue);
      }
      expect(
        WeekStart.saturday.monthGrid(nov).start,
        const CalendarDate(2026, 10, 31),
      );
      expect(WeekStart.sunday.monthGrid(nov).start, nov);
      expect(
        WeekStart.monday.monthGrid(nov).start,
        const CalendarDate(2026, 10, 26),
      );
    });

    test('DST transitions never skip or repeat a day', () {
      // Egypt (late April / late October) and EU (late March) switches.
      for (final start in const [
        CalendarDate(2026, 4, 20),
        CalendarDate(2026, 10, 25),
        CalendarDate(2026, 3, 26),
      ]) {
        final days = [for (var i = 0; i < 10; i++) start.addDays(i)];
        for (var i = 1; i < days.length; i++) {
          expect(days[i - 1].daysUntil(days[i]), 1);
          expect(days[i].weekday, (days[i - 1].weekday % 7) + 1);
        }
      }
    });

    test('today is the local civil day, late at night too', () {
      final e = run(
        CalendarData(invoices: [inv('a', due: today)]),
        clock: Clock.fixed(DateTime(2026, 11, 15, 23, 59)),
      );
      expect(e.single.type, CalendarEventType.due);
    });
  });

  group('summary and filters', () {
    final events = run(
      CalendarData(
        clients: const [client],
        invoices: [
          inv('a', due: today.addDays(2)),
          inv('b', due: today.addDays(-2), currency: Currency.usd),
          inv('p', status: InvoiceStatus.paid, paid: today.addDays(-1)),
        ],
      ),
    );

    test('month summary splits expected, collected and overdue', () {
      final s = monthSummary(events, today);
      expect(s[SummaryKind.expected]!.of(Currency.egp), 1000);
      expect(s[SummaryKind.collected]!.of(Currency.egp), 1000);
      expect(s[SummaryKind.overdue]!.of(Currency.usd), 1000);
      expect(s[SummaryKind.overdue]!.of(Currency.egp), 0);
    });

    test('day totals skip the rollup; filters combine', () {
      final todays = events.where((e) => e.date == today);
      expect(dueTotal(todays).isEmpty, isTrue);
      final usd = events.where(
        const CalendarFilter(currency: Currency.usd).accepts,
      );
      expect(usd.map((e) => e.invoiceId).whereType<String>(), ['b']);
      final q = events.where(const CalendarFilter(query: 'acme INV-a').accepts);
      expect(q.single.invoiceId, 'a');
      expect(todayCounts(events, today), (due: 0, overdue: 1));
    });
  });
}
