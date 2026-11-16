import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/seed.dart'
    show defaultNotesAr, defaultNotesEn;
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';

import 'contract_fixtures.dart';

/// The provider printed on the docs/ sample invoices (fictional).
final Settings sampleInvoiceSettings = sampleSettings.copyWith(
  role: 'Product Studio',
  city: 'Mansoura, Egypt',
  website: 'studio.example.com',
  invoicePrefix: 'SS',
  instapay: 'sample.studio@instapay',
  notesEn: defaultNotesEn,
  notesAr: defaultNotesAr,
);

/// A two-currency invoice to Acme Studio, with Arabic text that used to run
/// together (words ending in ر، ز، و، د).
Invoice sampleInvoice({bool scope = false}) => Invoice(
  id: 'sample-invoice',
  clientId: acme.id,
  number: 'SS-2026-0001',
  year: 2026,
  seq: 1,
  issueDate: const CalendarDate(2026, 9, 14),
  dueDate: const CalendarDate(2026, 10, 14),
  status: InvoiceStatus.sent,
  notesEn: defaultNotesEn,
  notesAr: defaultNotesAr,
  scope: scope
      ? const ScopePage(
          enabled: true,
          title: 'تطبيق أكمي للحجوزات',
          overview:
              'تطبيق حجوزات متكامل مع لوحة تحكم، يجوز تطوير مزايا إضافية '
              'بعد التسليم بعقد منفصل.',
          done: 'تصميم الواجهات\nتطوير التطبيق ولوحة التحكم\nربط بوابة الدفع',
          delivered: 'الكود المصدري\nحسابات المتاجر\nدليل الاستخدام',
          warranty: 'ضمان 3 أشهر على الأخطاء البرمجية من تاريخ التسليم.',
        )
      : const ScopePage(),
  sections: const [
    InvoiceSection(
      id: 's1',
      titleEn: 'Development & Implementation',
      titleAr: 'التطوير والتنفيذ',
      currency: Currency.egp,
      items: [
        LineItem(
          id: 'i1',
          service: 'Booking App',
          description:
              'تصميم وتطوير التطبيق ولوحة التحكم، الاختبار، والرفع على المتاجر',
          unitPriceMinor: 2200000,
        ),
      ],
    ),
    InvoiceSection(
      id: 's2',
      titleEn: 'Infrastructure & Third-party Services',
      titleAr: 'البنية التحتية',
      currency: Currency.usd,
      items: [
        LineItem(
          id: 'i2',
          service: 'Domain name',
          description: 'acme-booking.example.com',
          cycle: BillingCycle.annual,
          unitPriceMinor: 1150,
        ),
        LineItem(
          id: 'i3',
          service: 'Cloud server',
          description: 'Microsoft Azure',
          cycle: BillingCycle.monthly,
          unitPriceMinor: 10000,
        ),
        LineItem(
          id: 'i4',
          service: 'Apple Developer Program',
          cycle: BillingCycle.annual,
          unitPriceMinor: 9900,
        ),
      ],
    ),
  ],
);

InvoicePdfData sampleInvoiceData({bool scope = false}) => InvoicePdfData(
  invoice: sampleInvoice(scope: scope),
  client: acme.copyWith(city: 'Cairo, Egypt'),
  settings: sampleInvoiceSettings,
);
