import 'package:meta/meta.dart';

/// Outcome of saving an invoice or contract.
sealed class SaveResult {
  const SaveResult();
}

/// Written to the database.
class Saved extends SaveResult {
  /// The save went through.
  const Saved();
}

/// The number (or its year/sequence) is already used by another document,
/// deleted ones included: numbers are never reused.
@immutable
class DuplicateNumber extends SaveResult {
  /// [number] is the one that clashed.
  const DuplicateNumber(this.number);

  /// As entered (trimmed).
  final String number;
}

/// Outcome of soft-deleting a contract.
sealed class DeleteResult {
  const DeleteResult();
}

/// Moved to "المحذوفات"; [stamp] (UTC ms) undoes exactly this batch (the
/// contract and the amendments deleted with it).
@immutable
class Deleted extends DeleteResult {
  /// [stamp] is UTC epoch ms.
  const Deleted(this.number, this.stamp);

  /// The deleted contract's number, for the snackbar.
  final String number;

  /// Shared by the contract and its amendments.
  final int stamp;
}

/// Refused: [count] live invoices point at the contract, and deleting it
/// would leave them without a reference. Cancel the contract instead.
@immutable
class HasLinkedInvoices extends DeleteResult {
  /// [count] live linked invoices.
  const HasLinkedInvoices(this.count);

  /// Live invoices referencing the contract.
  final int count;
}

/// Nothing to delete (unknown id or already deleted).
class NotFound extends DeleteResult {
  /// Nothing happened.
  const NotFound();
}
