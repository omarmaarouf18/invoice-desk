import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';

/// The fictional client the style editor previews on when no invoice is
/// open. Never written to the database.
const styleSampleClient = Client(
  id: 'style-sample-client',
  name: 'Acme Studio',
  email: 'hello@acme.example',
  phone: '+20 100 000 0000',
  city: 'Cairo',
);

/// A short fictional invoice that shows every block a style can change:
/// two sections, a monthly item, notes and a paid stamp.
///
/// [issue] is the date it is dated on (the editor passes today, from the
/// injected clock), so the preview never shows a stale year.
Invoice styleSampleInvoice(DocLanguage language, CalendarDate issue) => Invoice(
  id: 'style-sample-invoice',
  clientId: styleSampleClient.id,
  language: language,
  number: 'AS-${issue.year}-0042',
  year: issue.year,
  seq: 42,
  issueDate: issue,
  dueDate: issue.addDays(14),
  status: InvoiceStatus.paid,
  paidDate: issue,
  notesEn: 'Thank you for your business.',
  notesAr: 'شكرًا لتعاملكم معنا.',
  sections: const [
    InvoiceSection(
      id: 'sample-s1',
      titleEn: 'Design & Development',
      titleAr: 'التصميم والتطوير',
      currency: Currency.egp,
      items: [
        LineItem(
          id: 'sample-i1',
          service: 'Website redesign',
          description: 'تصميم الواجهات وتطوير الموقع',
          unitPriceMinor: 1500000,
        ),
        LineItem(
          id: 'sample-i2',
          service: 'Maintenance',
          description: 'دعم فني شهري',
          cycle: BillingCycle.monthly,
          unitPriceMinor: 250000,
        ),
      ],
    ),
  ],
);
