import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:meta/meta.dart';

part 'models/settings.dart';
part 'models/client.dart';
part 'models/invoice.dart';

/// Stored lifecycle of an invoice; overdue is derived, not stored.
enum InvoiceStatus {
  /// Being written.
  draft('draft'),

  /// Sent and unpaid.
  sent('sent'),

  /// Paid; has a paid date.
  paid('paid'),

  /// Cancelled; kept so its number is never reused.
  voided('void');

  const InvoiceStatus(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static InvoiceStatus fromDb(String v) =>
      InvoiceStatus.values.firstWhere((s) => s.dbValue == v);
}

/// What the UI shows: status plus the derived overdue state.
enum DisplayStatus {
  /// Not sent yet.
  draft,

  /// Sent, not yet due.
  sent,

  /// Sent and past its due date (derived, never stored).
  overdue,

  /// Paid.
  paid,

  /// Cancelled; kept for numbering.
  voided,
}

/// How often a line item is billed; renewals keep only recurring ones.
enum BillingCycle {
  /// Billed once.
  oneTime('one-time'),

  /// Renews monthly.
  monthly('monthly'),

  /// Renews yearly.
  annual('annual');

  const BillingCycle(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Monthly or annual.
  bool get isRecurring => this != BillingCycle.oneTime;

  /// Inverse of [dbValue]; throws on unknown values.
  static BillingCycle fromDb(String v) =>
      BillingCycle.values.firstWhere((s) => s.dbValue == v);
}

/// Splits a multi-line notes field into non-empty trimmed lines.
List<String> splitLines(String text) =>
    text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
