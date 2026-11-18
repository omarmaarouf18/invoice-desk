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

  /// Sent and due before [today]; due today is not overdue yet. Measured
  /// against the effective (postponed) due date.
  bool isOverdue(CalendarDate today) =>
      status == InvoiceStatus.sent && effectiveDueDate.isBefore(today);

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
/// With [yearlyReset] off the count runs across years: the max of all.
int nextSeq(
  Iterable<({int year, int seq})> used,
  int year, {
  bool yearlyReset = true,
}) {
  var max = 0;
  for (final u in used) {
    if ((!yearlyReset || u.year == year) && u.seq > max) max = u.seq;
  }
  return max + 1;
}

/// Why a numbering pattern cannot be used.
enum NumberPatternProblem {
  /// No `{SEQ}` / `{SEQ:n}`: every number would be the same.
  noSequence,

  /// Yearly reset without `{YYYY}` or `{YY}`: 2026 and 2027 would both
  /// produce `…-0001`.
  noYearWithReset,
}

final _seqToken = RegExp(r'\{SEQ(?::(\d))?\}');

/// Null when [pattern] is usable with [yearlyReset].
NumberPatternProblem? checkNumberPattern(
  String pattern, {
  required bool yearlyReset,
}) {
  if (!_seqToken.hasMatch(pattern)) return NumberPatternProblem.noSequence;
  if (yearlyReset && !pattern.contains('{YYYY}') && !pattern.contains('{YY}')) {
    return NumberPatternProblem.noYearWithReset;
  }
  return null;
}

/// [pattern] with its tokens filled: `{PREFIX}`, `{YYYY}`, `{YY}` (last two
/// digits), `{SEQ}` and `{SEQ:n}` (zero-padded to n, 1–9). Other text is
/// kept as typed. `{PREFIX}-{YYYY}-{SEQ:4}` is [formatInvoiceNumber].
String formatNumberPattern(
  String pattern, {
  required String prefix,
  required int year,
  required int seq,
}) => pattern
    .replaceAll('{PREFIX}', prefix)
    .replaceAll('{YYYY}', '$year')
    .replaceAll('{YY}', (year % 100).toString().padLeft(2, '0'))
    .replaceAllMapped(
      _seqToken,
      (m) => seq.toString().padLeft(int.tryParse(m.group(1) ?? '') ?? 1, '0'),
    );

/// The number [s] gives sequence [seq] of [year]. An unusable saved
/// pattern falls back to the default, so numbering never breaks.
String invoiceNumberFor(Settings s, int year, int seq) => formatNumberPattern(
  checkNumberPattern(
            s.invoiceNumberPattern,
            yearlyReset: s.numberYearlyReset,
          ) ==
          null
      ? s.invoiceNumberPattern
      : Settings.defaultNumberPattern,
  prefix: s.invoicePrefix,
  year: year,
  seq: seq,
);

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
