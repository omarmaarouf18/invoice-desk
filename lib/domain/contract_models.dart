import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:meta/meta.dart';

part 'contract/library.dart';
part 'contract/parts.dart';
part 'contract/contract.dart';

/// What a library template produces, and a contract's numbering series.
enum TemplateKind {
  /// A full contract, numbered CT-….
  contract('contract'),

  /// A quote with terms, numbered QT-….
  quote('quote');

  const TemplateKind(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static TemplateKind fromDb(String v) =>
      TemplateKind.values.firstWhere((k) => k.dbValue == v);
}

/// What kind of document a contract row is.
enum ContractKind {
  /// A contract from a contract template.
  contract('contract'),

  /// A quote from a quote template.
  quote('quote'),

  /// A change to a signed original, numbered `<original>-A<n>`.
  amendment('amendment');

  const ContractKind(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static ContractKind fromDb(String v) =>
      ContractKind.values.firstWhere((k) => k.dbValue == v);
}

/// Lifecycle of a contract. Past draft needs every variable resolved.
enum ContractStatus {
  /// Being written; the PDF carries a "مسودة" watermark.
  draft('draft'),

  /// Sent to the client for signature.
  sent('sent'),

  /// Signed; locks the document.
  signed('signed'),

  /// In force (work under way); still locked.
  active('active'),

  /// Delivered and closed; still locked.
  completed('completed'),

  /// Called off; also how a contract with invoices is retired.
  cancelled('cancelled');

  const ContractStatus(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Signed, active and completed documents are read-only (unless unlocked).
  bool get locks => this == signed || this == active || this == completed;

  /// "عقود سارية".
  bool get isInForce => this == signed || this == active;

  /// Moving to these needs every variable resolved.
  bool get needsResolvedVariables => this != draft && this != cancelled;

  /// Inverse of [dbValue]; throws on unknown values.
  static ContractStatus fromDb(String v) =>
      ContractStatus.values.firstWhere((s) => s.dbValue == v);
}
