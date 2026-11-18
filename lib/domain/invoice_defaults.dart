import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/models.dart';

/// Default sections of a fresh invoice. The first one is in [currency]
/// (Settings → Invoices → default currency); the second, for third-party
/// services, stays in US dollars.
List<InvoiceSection> defaultSections(
  String Function() newId, {
  Currency currency = Currency.egp,
}) => [
  InvoiceSection(
    id: newId(),
    titleEn: 'Development & Implementation',
    titleAr: 'التطوير والتنفيذ',
    currency: currency,
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
