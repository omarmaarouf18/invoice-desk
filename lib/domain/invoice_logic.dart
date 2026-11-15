import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/models.dart';

/// Derived totals of an invoice. Never stored.
class InvoiceTotals {
  InvoiceTotals._(this.subtotal, this.vat, this.total);

  /// Sums the sections per currency, then VAT per currency (half-up).
  factory InvoiceTotals.of(Invoice invoice) {
    final subtotal = MoneyBag();
    for (final s in invoice.sections) {
      subtotal.add(s.subtotal);
    }
    final vat = MoneyBag();
    if (invoice.vatOn) {
      for (final m in subtotal.entries) {
        vat.add(m.vat(invoice.vatRateBp));
      }
    }
    final total = MoneyBag()
      ..addBag(subtotal)
      ..addBag(vat);
    return InvoiceTotals._(subtotal, vat, total);
  }

  /// Before VAT, per currency.
  final MoneyBag subtotal;

  /// VAT per currency; empty when VAT is off.
  final MoneyBag vat;

  /// Subtotal plus VAT, per currency; currencies are never added together.
  final MoneyBag total;
}

/// Values derived from an invoice; never stored.
extension InvoiceDerived on Invoice {
  /// Recomputed on every call; cheap for invoice-sized data.
  InvoiceTotals get totals => InvoiceTotals.of(this);

  /// Sent and due before [today]; due today is not overdue yet.
  bool isOverdue(CalendarDate today) =>
      status == InvoiceStatus.sent && dueDate.isBefore(today);

  /// Sent and not paid: counts towards "غير مدفوع".
  bool get isUnpaid => status == InvoiceStatus.sent;

  /// The chip shown for this invoice on [today].
  DisplayStatus displayStatus(CalendarDate today) => switch (status) {
    InvoiceStatus.draft => DisplayStatus.draft,
    InvoiceStatus.paid => DisplayStatus.paid,
    InvoiceStatus.voided => DisplayStatus.voided,
    InvoiceStatus.sent =>
      isOverdue(today) ? DisplayStatus.overdue : DisplayStatus.sent,
  };
}

/// `{prefix}-{year}-{seq:0000}`.
String formatInvoiceNumber(String prefix, int year, int seq) =>
    '$prefix-$year-${seq.toString().padLeft(4, '0')}';

/// Next sequence for [year] given the (year, seq) pairs already used.
int nextSeq(Iterable<({int year, int seq})> used, int year) {
  var max = 0;
  for (final u in used) {
    if (u.year == year && u.seq > max) max = u.seq;
  }
  return max + 1;
}

/// Extracts (year, seq) from a number like `OM-2026-0001`. Null when the
/// number does not end in `-YYYY-N`.
({int year, int seq})? parseInvoiceNumber(String number) {
  final m = RegExp(r'-(\d{4})-(\d+)$').firstMatch(number.trim());
  if (m == null) return null;
  return (year: int.parse(m.group(1)!), seq: int.parse(m.group(2)!));
}

/// Renewal: only recurring items survive; sections that become empty are
/// dropped. Returns null when nothing recurs.
List<InvoiceSection>? renewalSections(
  List<InvoiceSection> sections,
  String Function() newId,
) {
  final out = <InvoiceSection>[];
  for (final s in sections) {
    final items = [
      for (final i in s.items)
        if (i.cycle.isRecurring) i.copyWith(id: newId()),
    ];
    if (items.isNotEmpty) out.add(s.copyWith(id: newId(), items: items));
  }
  return out.isEmpty ? null : out;
}

/// Deep copy with fresh ids for sections and items.
List<InvoiceSection> cloneSections(
  List<InvoiceSection> sections,
  String Function() newId,
) => [
  for (final s in sections)
    s.copyWith(
      id: newId(),
      items: [for (final i in s.items) i.copyWith(id: newId())],
    ),
];

/// Validation problems the editor shows inline.
/// Validation problems the editor shows inline.
enum InvoiceIssue {
  /// No client picked.
  missingClient,

  /// The number is blank.
  emptyNumber,

  /// Another invoice (deleted included) has this number.
  duplicateNumber,

  /// Reserved for malformed numbers; free-form numbers are accepted today.
  badNumber,
}

/// Problems that block saving; [numberTaken] is asked for the trimmed
/// number and this invoice's id.
Set<InvoiceIssue> validateInvoice(
  Invoice invoice, {
  required bool Function(String number, String exceptId) numberTaken,
}) {
  final issues = <InvoiceIssue>{};
  if (invoice.clientId.isEmpty) issues.add(InvoiceIssue.missingClient);
  if (invoice.number.trim().isEmpty) {
    issues.add(InvoiceIssue.emptyNumber);
  } else if (numberTaken(invoice.number.trim(), invoice.id)) {
    issues.add(InvoiceIssue.duplicateNumber);
  }
  return issues;
}
