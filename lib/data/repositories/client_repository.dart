import 'package:clock/clock.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/models.dart';

/// Clients: live list, archive, and the soft-delete rules (a client with
/// live documents can only go together with them, as one batch).
class ClientRepository with ClockedRepository {
  ClientRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  /// Live clients (archived included), re-emitting on change.
  Stream<List<Client>> watchAll() => _db.clientsDao.watchAll();

  Future<List<Client>> getAll() => _db.clientsDao.getAll();

  Future<Client?> getById(String id) async =>
      (await getAll()).where((c) => c.id == id).firstOrNull;

  /// Inserts or updates; trims text fields and keeps `createdAt`.
  Future<void> save(Client c) => at(() => _db.clientsDao.upsert(c));

  Future<void> setArchived(String id, {required bool archived}) =>
      at(() => _db.clientsDao.setArchived(id, archived: archived));

  Future<int> countLiveInvoices(String id) =>
      _db.clientsDao.countLiveInvoices(id);

  Future<int> countLiveContracts(String id) =>
      _db.clientsDao.countLiveContracts(id);

  /// Soft delete of a client without live documents. The database refuses
  /// otherwise (trigger `clients_soft_delete_guard`).
  Future<void> softDelete(String id) => at(() => _db.clientsDao.softDelete(id));

  Future<void> undoDelete(String id) => at(() => _db.clientsDao.undoDelete(id));

  /// Client plus every live invoice and contract, one transaction, one
  /// stamp (UTC ms), which [undoDeleteWithDocuments] needs.
  Future<int> softDeleteWithDocuments(String id) =>
      at(() => _db.clientsDao.softDeleteWithDocuments(id));

  Future<void> undoDeleteWithDocuments(String id, int stamp) =>
      at(() => _db.clientsDao.undoDeleteWithDocuments(id, stamp));
}
