import 'package:clock/clock.dart';
import 'package:invoice_desk/data/daos/contracts_dao.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/results.dart';

/// Contracts with clauses, scope items and milestones, saved as one
/// aggregate.
class ContractRepository with ClockedRepository {
  /// Wraps [_db]; writes are stamped with [clock].
  ContractRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  ContractsDao get _dao => _db.contractsDao;

  /// Live contracts, fully loaded, re-emitting on any related change.
  Stream<List<Contract>> watchAll() => _dao.watchAll();

  /// Live contracts, fully loaded, unordered.
  Future<List<Contract>> getAll() => _dao.getAll();

  /// The contract with [id], deleted or not; null when unknown or purged.
  Future<Contract?> getById(String id) => _dao.getById(id);

  /// Next sequence of a numbering series in [year]; amendments don't count.
  Future<int> nextSeqFor(TemplateKind series, int year) =>
      _dao.nextSeqFor(series, year);

  /// Next `-A<n>` for amendments of [parentId], starting at 1.
  Future<int> nextAmendmentNo(String parentId) =>
      _dao.nextAmendmentNo(parentId);

  /// Whether another contract (deleted ones included, since numbers are
  /// never reused) already has [number].
  Future<bool> numberTaken(String number, {String? exceptId}) =>
      _dao.numberTaken(number, exceptId: exceptId);

  /// Saves the aggregate atomically (clauses, scope, milestones replaced);
  /// [DuplicateNumber] when the number or series/year/seq is taken.
  Future<SaveResult> save(Contract c) => at(() async {
    try {
      // A user save adopts a demo row: it is real data from now on.
      await _dao.saveContract(c.copyWith(isDemo: false));
      return const Saved();
    } on DuplicateContractNumber catch (e) {
      return DuplicateNumber(e.number);
    }
  });

  /// Points milestone [milestoneId] at invoice [invoiceId]; purging that
  /// invoice later clears the link (ON DELETE SET NULL).
  Future<void> linkMilestone(String milestoneId, String invoiceId) =>
      at(() => _dao.linkMilestone(milestoneId, invoiceId));

  /// Soft delete with its amendments; refused while invoices are linked.
  Future<DeleteResult> softDelete(String id) => at(() async {
    final c = await _dao.getById(id);
    if (c == null) return const NotFound();
    try {
      return Deleted(c.number, await _dao.softDelete(id));
    } on ContractHasInvoices catch (e) {
      return HasLinkedInvoices(e.count);
    }
  });

  /// Restores the contract and the amendments deleted with it ([stamp]).
  Future<void> undoDelete(String id, int stamp) =>
      at(() => _dao.undoDelete(id, stamp));
}
