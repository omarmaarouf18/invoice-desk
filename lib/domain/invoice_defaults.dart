import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/models.dart';

/// Default sections of a fresh invoice.
List<InvoiceSection> defaultSections(String Function() newId) => [
  InvoiceSection(
    id: newId(),
    titleEn: 'Development & Implementation',
    titleAr: 'التطوير والتنفيذ',
    currency: Currency.egp,
    items: [LineItem(id: newId())],
  ),
  InvoiceSection(
    id: newId(),
    titleEn: 'Infrastructure & Third-party Services',
    titleAr: 'البنية التحتية',
    currency: Currency.usd,
    items: [LineItem(id: newId())],
  ),
];
