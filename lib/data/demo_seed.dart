import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:uuid/uuid.dart';

part 'demo_seed_contracts.dart';

/// First sequence of demo numbers (`DEMO-2026-9001`, `DEMO-CT-2026-9001`):
/// far from real numbering, which ignores `DEMO-` rows.
const demoSeqStart = 9001;

/// Seeds the fictional demo set (no real people, companies, numbers or
/// domains). Every date is relative to today on [clock], so the calendar
/// looks alive on the day it is seeded; ids derive from the clock's
/// instant, so a fixed clock gives the same rows every time. Every row
/// carries `isDemo`.
Future<void> seedDemo(AppDatabase db, {Clock clock = const Clock()}) =>
    withClock(clock, () => db.transaction(() => _DemoSeed(db, clock).run()));

class _DemoSeed {
  _DemoSeed(this.db, Clock clock)
    : t = CalendarDate.fromDateTime(clock.now()),
      salt = clock.now().toUtc().microsecondsSinceEpoch;

  final AppDatabase db;

  /// Today.
  final CalendarDate t;
  final int salt;
  var _n = 0;
  late int _invSeq;
  late int _ctSeq;

  static const _ns = '6f1d8a8e-0b6b-4e0b-9a43-5d2c1f0c7a11';

  String id() => const Uuid().v5(_ns, 'demo:$salt:${_n++}');

  Future<void> run() async {
    _invSeq = await _nextDemoSeq('invoices');
    _ctSeq = await _nextDemoSeq('contracts');
    final c = await _clients();
    final inv = await _invoices(c);
    await _contracts(c, inv);
    await _reminders(c, inv);
  }

  Future<int> _nextDemoSeq(String table) async {
    final row = await db
        .customSelect(
          'SELECT MAX(seq) AS m FROM $table WHERE number LIKE ?',
          variables: [const Variable('DEMO-%')],
        )
        .getSingle();
    final m = row.read<int?>('m');
    return m == null || m < demoSeqStart ? demoSeqStart : m + 1;
  }

  // ── Clients ──────────────────────────────────────────────────────────

  Future<List<Client>> _clients() async {
    final list = [
      Client(
        id: id(),
        name: 'Acme Studio',
        contact: 'Sara Adel',
        city: 'Cairo',
        phone: '0100 000 0001',
        email: 'billing@acme-studio.example.com',
        isDemo: true,
      ),
      Client(
        id: id(),
        name: 'مخبز النيل',
        contact: 'أ. محمود',
        city: 'الجيزة',
        phone: '0100 000 0002',
        email: 'info@nile-bakery.example.eg',
        isDemo: true,
      ),
      Client(
        id: id(),
        name: 'Delta Clinics',
        contact: 'Dr. Hany',
        city: 'Tanta',
        phone: '0100 000 0003',
        email: 'admin@delta-clinics.example.com',
        legalName: 'Delta Clinics (demo)',
        representative: 'Hany Fawzy',
        representativeTitle: 'المدير التنفيذي',
        isDemo: true,
      ),
      Client(
        id: id(),
        name: 'مكتب الصفوة للمحاماة',
        contact: 'أ. ريم',
        city: 'الإسكندرية',
        phone: '0100 000 0004',
        email: 'office@alsafwa-law.example.eg',
        isDemo: true,
      ),
      Client(
        id: id(),
        name: 'Bright Path Academy',
        contact: 'Nour Samir',
        city: 'Mansoura',
        phone: '0100 000 0005',
        email: 'hello@brightpath.example.com',
        isDemo: true,
      ),
    ];
    for (final c in list) {
      await db.clientsDao.upsert(c);
    }
    return list;
  }

  // ── Invoices ─────────────────────────────────────────────────────────

  LineItem item(
    String service,
    int major, {
    BillingCycle cycle = BillingCycle.oneTime,
    String description = '',
    int qty = 1,
  }) => LineItem(
    id: id(),
    service: service,
    description: description,
    cycle: cycle,
    qty: qty,
    unitPriceMinor: major * Currency.minorFactor,
  );

  InvoiceSection section(
    Currency currency,
    String en,
    String ar,
    List<LineItem> items,
  ) => InvoiceSection(
    id: id(),
    currency: currency,
    titleEn: en,
    titleAr: ar,
    items: items,
  );

  Future<Invoice> invoice(
    Client client, {
    required CalendarDate issue,
    required CalendarDate due,
    required List<InvoiceSection> sections,
    InvoiceStatus status = InvoiceStatus.sent,
    CalendarDate? paid,
    bool vat = false,
    String contractRef = '',
    ScopePage scope = const ScopePage(),
  }) async {
    final seq = _invSeq++;
    final inv = Invoice(
      id: id(),
      clientId: client.id,
      number: 'DEMO-${issue.year}-$seq',
      year: issue.year,
      seq: seq,
      issueDate: issue,
      dueDate: due,
      paidDate: paid,
      status: status,
      vatOn: vat,
      contractRef: contractRef,
      scope: scope,
      sections: sections,
      isDemo: true,
    );
    await db.invoicesDao.saveInvoice(inv);
    return inv;
  }

  Future<Map<String, Invoice>> _invoices(List<Client> c) async {
    final [acme, bakery, delta, law, academy] = c;
    const egp = Currency.egp;
    const usd = Currency.usd;
    final out = <String, Invoice>{};
    // Due today.
    out['dueToday'] = await invoice(
      acme,
      issue: t.addDays(-30),
      due: t,
      sections: [
        section(egp, 'Website', 'الموقع', [
          item('Website maintenance', 15000, description: 'Q4 updates'),
        ]),
        section(usd, 'Hosting', 'الاستضافة', [
          item('Cloud hosting', 25, cycle: BillingCycle.monthly),
        ]),
      ],
    );
    // Paid last month; its monthly item renews.
    out['paidLastMonth'] = await invoice(
      acme,
      issue: t.addMonths(-1).addDays(-10),
      due: t.addMonths(-1).addDays(20),
      paid: t.addMonths(-1),
      status: InvoiceStatus.paid,
      sections: [
        section(egp, 'Marketing', 'التسويق', [
          item(
            'Social media management',
            8000,
            cycle: BillingCycle.monthly,
          ),
        ]),
      ],
    );
    // Overdue by 10 days.
    out['overdue'] = await invoice(
      bakery,
      issue: t.addDays(-40),
      due: t.addDays(-10),
      sections: [
        section(egp, 'Design', 'التصميم', [
          item('تصميم قائمة الطعام', 6500, description: 'نسختان مطبوعة ورقمية'),
        ]),
      ],
    );
    out['draft'] = await invoice(
      bakery,
      issue: t,
      due: t.addDays(14),
      status: InvoiceStatus.draft,
      sections: [
        section(egp, 'Photography', 'التصوير', [
          item('تصوير المنتجات', 4000, qty: 2),
        ]),
      ],
    );
    // Due this week.
    out['dueThisWeek'] = await invoice(
      delta,
      issue: t.addDays(-25),
      due: t.addDays(3),
      sections: [
        section(usd, 'Development', 'التطوير', [
          item('Booking system support', 1200),
        ]),
      ],
    );
    // Annual items, renewing next month.
    out['annual'] = await invoice(
      delta,
      issue: t.addMonths(-11),
      due: t.addMonths(-11).addDays(14),
      paid: t.addMonths(-11).addDays(6),
      status: InvoiceStatus.paid,
      sections: [
        section(usd, 'Infrastructure', 'البنية التحتية', [
          item(
            'Domain name',
            15,
            cycle: BillingCycle.annual,
            description: 'delta-clinics.example.com',
          ),
          item('SSL certificate', 60, cycle: BillingCycle.annual),
        ]),
        section(egp, 'Setup', 'الإعداد', [item('Server setup', 3000)]),
      ],
    );
    // Postponed (see _postpone) from 5 days ago to next week.
    out['postponed'] = await invoice(
      law,
      issue: t.addDays(-35),
      due: t.addDays(-5),
      sections: [
        section(egp, 'Development', 'التطوير', [
          item('نظام متابعة القضايا — المرحلة الأولى', 18000),
        ]),
      ],
    );
    out['lawMonthly'] = await invoice(
      law,
      issue: t.addDays(-25),
      due: t.addDays(-11),
      paid: t.addDays(-20),
      status: InvoiceStatus.paid,
      sections: [
        section(egp, 'Hosting', 'الاستضافة', [
          item('استضافة نظام القضايا', 1200, cycle: BillingCycle.monthly),
        ]),
      ],
    );
    out['vat'] = await invoice(
      academy,
      issue: t.addDays(-8),
      due: t.addDays(6),
      vat: true,
      sections: [
        section(egp, 'Training', 'التدريب', [
          item('Teacher training workshop', 6000, qty: 2),
        ]),
      ],
    );
    out['paidThisWeek'] = await invoice(
      academy,
      issue: t.addDays(-20),
      due: t.addDays(-6),
      paid: t.addDays(-3),
      status: InvoiceStatus.paid,
      scope: const ScopePage(
        enabled: true,
        title: 'Learning portal handover',
        overview: 'Course catalogue and student accounts.',
        done: 'Catalogue\nStudent accounts',
        delivered: 'Source code\nAdmin guide',
        warranty: 'ضمان 1 شهر على الأعطال البرمجية',
      ),
      sections: [
        section(usd, 'Development', 'التطوير', [
          item('Learning portal fixes', 300),
        ]),
      ],
    );
    out['void'] = await invoice(
      acme,
      issue: t.addDays(-60),
      due: t.addDays(-30),
      status: InvoiceStatus.voided,
      sections: [
        section(egp, 'Website', 'الموقع', [item('Landing page', 5000)]),
      ],
    );
    out['academyOld'] = await invoice(
      academy,
      issue: t.addDays(-90),
      due: t.addDays(-60),
      paid: t.addDays(-62),
      status: InvoiceStatus.paid,
      sections: [
        section(egp, 'Content', 'المحتوى', [item('Course videos', 9000)]),
      ],
    );
    return out;
  }
}
