import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/seed.dart'
    show defaultNotesAr, defaultNotesEn;
import 'package:invoice_desk/domain/models.dart';
import 'package:uuid/uuid.dart';

/// The pre-0.4 single-invoice fixture many tests are written against
/// (fictional details).
const legacySettings = Settings(
  name: 'Test Provider',
  role: 'Freelance Developer',
  city: 'Cairo',
  website: 'provider.example.com',
  notesEn: defaultNotesEn,
  notesAr: defaultNotesAr,
);

Future<void> legacySeed(AppDatabase db) async {
  const uuid = Uuid();
  String id() => uuid.v4();
  await db.settingsDao.save(legacySettings);
  final client = Client(
    id: id(),
    name: 'Sample Academy',
    city: 'Mansoura, Egypt',
    phone: '0100 000 0099',
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
            usd(
              'Domain name',
              BillingCycle.annual,
              1150,
              'sample-academy.example.com',
            ),
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
