import 'package:clock/clock.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/daos/invoices_dao.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/results.dart';

/// Invoices with their sections and items, saved as one aggregate.
class InvoiceRepository with ClockedRepository {
  /// Wraps [_db]; writes are stamped with [clock].
  InvoiceRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  InvoicesDao get _dao => _db.invoicesDao;

  /// Live invoices, fully loaded, re-emitting on any related change.
  Stream<List<Invoice>> watchAll() => _dao.watchAll();

  /// Invoices with sections and items; trashed ones only with
  /// [includeDeleted].
  Future<List<Invoice>> getAll({bool includeDeleted = false}) =>
      _dao.getAll(includeDeleted: includeDeleted);

  /// The invoice with [id], deleted or not; null when unknown or purged.
  Future<Invoice?> getById(String id) => _dao.getById(id);

  /// Next free sequence in [year]; deleted invoices keep their numbers.
  Future<int> nextSeqFor(int year) => _dao.nextSeqFor(year);

  /// Whether another invoice (deleted ones included) already has [number].
  Future<bool> numberTaken(String number, {String? exceptId}) =>
      _dao.numberTaken(number, exceptId: exceptId);

  /// Saves the aggregate atomically; [DuplicateNumber] when the number or
  /// its year/sequence is taken.
  Future<SaveResult> save(Invoice inv) => at(() async {
    try {
      // A user save adopts a demo row: it is real data from now on.
      await _dao.saveInvoice(inv.copyWith(isDemo: false));
      return const Saved();
    } on DuplicateInvoiceNumber catch (e) {
      return DuplicateNumber(e.number);
    }
  });

  /// Moves the invoice to the trash (purged after 30 days).
  Future<void> softDelete(String id) => at(() => _dao.softDelete(id));

  /// Takes the invoice out of the trash; refused by the database while its
  /// client is deleted.
  Future<void> undoDelete(String id) => at(() => _dao.undoDelete(id));

  /// Status paid with [date] as the paid date.
  Future<void> markPaid(String id, CalendarDate date) =>
      at(() => _dao.markPaid(id, date));

  /// Invoices not in the trash.
  Future<int> countLive() => _dao.countLive();
}
