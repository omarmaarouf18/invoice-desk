import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:uuid/uuid.dart';

const defaultNotesEn = '''
Covers initial setup plus the first billing period of every recurring service.
Monthly items renew each month unless cancelled with 7 days' notice; annual items renew each year unless cancelled before the renewal date.
One-time items will not appear on future invoices.
USD items may be paid in EGP at the bank's selling rate on the payment date.''';

const defaultNotesAr = '''
تغطي هذه الفاتورة تكاليف الإعداد وأول فترة لكل خدمة متكررة.
البنود الشهرية تتجدد كل شهر ما لم تُلغَ بإشعار قبلها بـ 7 أيام، والسنوية تتجدد كل سنة ما لم تُلغَ قبل موعد التجديد.
البنود التي تُدفع مرة واحدة لن تظهر في الفواتير القادمة.
يجوز سداد البنود الدولارية بالجنيه بسعر البيع في البنك يوم السداد.''';

const seedSettings = Settings(
  name: 'Omar Maarouf',
  role: 'Security Engineer & Systems Architect',
  city: 'Mansoura, Egypt',
  website: 'omar-maarouf.me',
  notesEn: defaultNotesEn,
  notesAr: defaultNotesAr,
);

Future<void> seedDatabase(AppDatabase db) async {
  const uuid = Uuid();
  String id() => uuid.v4();
  await db.settingsDao.save(seedSettings);
  final client = Client(
    id: id(),
    name: 'EL METR Academy',
    city: 'Mansoura, Egypt',
    phone: '01222700727',
  );
  await db.clientsDao.upsert(client);

  LineItem usd(String service, BillingCycle c, int minor, [String d = '']) =>
      LineItem(
        id: id(),
        service: service,
        description: d,
        cycle: c,
        unitPriceMinor: minor,
      );

  await db.invoicesDao.saveInvoice(
    Invoice(
      id: id(),
      clientId: client.id,
      number: 'OM-2026-0001',
      year: 2026,
      seq: 1,
      issueDate: const CalendarDate(2026, 9, 14),
      dueDate: const CalendarDate(2026, 10, 14),
      status: InvoiceStatus.sent,
      notesEn: defaultNotesEn,
      notesAr: defaultNotesAr,
      sections: [
        InvoiceSection(
          id: id(),
          titleEn: 'Development & Implementation',
          titleAr: 'التطوير والتنفيذ',
          currency: Currency.egp,
          items: [
            LineItem(
              id: id(),
              service: 'Single-Teacher Learning App',
              description:
                  'تصميم وتطوير التطبيق ولوحة التحكم، الاختبار، والرفع على المتاجر',
              unitPriceMinor: 2200000,
            ),
          ],
        ),
        InvoiceSection(
          id: id(),
          titleEn: 'Infrastructure & Third-party Services',
          titleAr: 'البنية التحتية',
          currency: Currency.usd,
          items: [
            usd('Domain name', BillingCycle.annual, 1150, 'elmetracademy.app'),
            usd('Cloud server', BillingCycle.monthly, 10000, 'Microsoft Azure'),
            usd('Apple Developer Program', BillingCycle.annual, 9900),
            usd('Google Play Console', BillingCycle.oneTime, 2500),
            usd('WhatsApp OTP', BillingCycle.monthly, 2000),
          ],
        ),
      ],
    ),
  );
}
