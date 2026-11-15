import 'package:clock/clock.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/daos/invoices_dao.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/results.dart';

/// Invoices with their sections and items, saved as one aggregate.
class InvoiceRepository with ClockedRepository {
  InvoiceRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  InvoicesDao get _dao => _db.invoicesDao;

  /// Live invoices, fully loaded, re-emitting on any related change.
  Stream<List<Invoice>> watchAll() => _dao.watchAll();

  Future<List<Invoice>> getAll({bool includeDeleted = false}) =>
      _dao.getAll(includeDeleted: includeDeleted);

  Future<Invoice?> getById(String id) => _dao.getById(id);

  /// Next free sequence in [year]; deleted invoices keep their numbers.
  Future<int> nextSeqFor(int year) => _dao.nextSeqFor(year);

  Future<bool> numberTaken(String number, {String? exceptId}) =>
      _dao.numberTaken(number, exceptId: exceptId);

  /// Saves the aggregate atomically; [DuplicateNumber] when the number or
  /// its year/sequence is taken.
  Future<SaveResult> save(Invoice inv) => at(() async {
    try {
      await _dao.saveInvoice(inv);
      return const Saved();
    } on DuplicateInvoiceNumber catch (e) {
      return DuplicateNumber(e.number);
    }
  });

  Future<void> softDelete(String id) => at(() => _dao.softDelete(id));

  Future<void> undoDelete(String id) => at(() => _dao.undoDelete(id));

  Future<void> markPaid(String id, CalendarDate date) =>
      at(() => _dao.markPaid(id, date));

  Future<int> countLive() => _dao.countLive();
}
