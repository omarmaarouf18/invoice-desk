import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/domain/models.dart';

part 'clients_dao.g.dart';

@DriftAccessor(tables: [Clients, Invoices, Contracts])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.attachedDatabase);

  int _now() => clock.now().toUtc().millisecondsSinceEpoch;

  SimpleSelectStatement<$ClientsTable, ClientRow> _live() =>
      select(clients)..where((c) => c.deletedAt.isNull());

  /// Live (not soft-deleted) clients, archived ones included.
  Stream<List<Client>> watchAll() =>
      _live().watch().map((rows) => rows.map(_toModel).toList());

  Future<List<Client>> getAll() async =>
      (await _live().get()).map(_toModel).toList();

  /// Number of live invoices for [id].
  Future<int> countLiveInvoices(String id) async {
    final c = invoices.id.count();
    final q = selectOnly(invoices)
      ..addColumns([c])
      ..where(invoices.clientId.equals(id) & invoices.deletedAt.isNull());
    return (await q.getSingle()).read(c)!;
  }

  /// Number of live contracts (amendments included) for [id].
  Future<int> countLiveContracts(String id) async {
    final c = contracts.id.count();
    final q = selectOnly(contracts)
      ..addColumns([c])
      ..where(contracts.clientId.equals(id) & contracts.deletedAt.isNull());
    return (await q.getSingle()).read(c)!;
  }

  /// Soft-deletes a client that has no live invoices or contracts. The DB trigger
  /// `clients_soft_delete_guard` aborts otherwise.
  Future<void> softDelete(String id) => transaction(() async {
    await (update(clients)..where((c) => c.id.equals(id))).write(
      ClientsCompanion(deletedAt: Value(_now()), updatedAt: Value(_now())),
    );
  });

  Future<void> undoDelete(String id) => transaction(() async {
    await (update(clients)..where((c) => c.id.equals(id))).write(
      ClientsCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  });

  /// Soft-deletes the client and every live invoice and contract of theirs
  /// in one transaction, all with the same timestamp. Returns that
  /// timestamp, which [undoDeleteWithDocuments] needs to restore exactly
  /// this batch.
  Future<int> softDeleteWithDocuments(String id) => transaction(() async {
    final stamp = _now();
    await (update(
      invoices,
    )..where((i) => i.clientId.equals(id) & i.deletedAt.isNull())).write(
      InvoicesCompanion(deletedAt: Value(stamp), updatedAt: Value(stamp)),
    );
    await (update(
      contracts,
    )..where((c) => c.clientId.equals(id) & c.deletedAt.isNull())).write(
      ContractsCompanion(deletedAt: Value(stamp), updatedAt: Value(stamp)),
    );
    await (update(clients)..where((c) => c.id.equals(id))).write(
      ClientsCompanion(deletedAt: Value(stamp), updatedAt: Value(stamp)),
    );
    return stamp;
  });

  /// Restores the client, then the invoices and contracts deleted with it
  /// (not ones that were deleted separately before).
  Future<void> undoDeleteWithDocuments(String id, int stamp) =>
      transaction(() async {
        await (update(clients)..where((c) => c.id.equals(id))).write(
          ClientsCompanion(
            deletedAt: const Value(null),
            updatedAt: Value(_now()),
          ),
        );
        await (update(invoices)..where(
              (i) => i.clientId.equals(id) & i.deletedAt.equals(stamp),
            ))
            .write(
              InvoicesCompanion(
                deletedAt: const Value(null),
                updatedAt: Value(_now()),
              ),
            );
        await (update(contracts)..where(
              (c) => c.clientId.equals(id) & c.deletedAt.equals(stamp),
            ))
            .write(
              ContractsCompanion(
                deletedAt: const Value(null),
                updatedAt: Value(_now()),
              ),
            );
      });

  /// Hard-deletes clients soft-deleted more than [age] ago once no invoice
  /// or contract rows reference them (run after those purges).
  Future<int> purgeDeleted({Duration age = const Duration(days: 30)}) =>
      transaction(() async {
        final cutoff = _now() - age.inMilliseconds;
        return (delete(clients)..where(
              (c) =>
                  c.deletedAt.isSmallerThanValue(cutoff) &
                  notExistsQuery(
                    select(invoices)..where((i) => i.clientId.equalsExp(c.id)),
                  ),
            ))
            .go();
      });

  Future<void> upsert(Client c) => transaction(() async {
    final now = _now();
    final existing = await (select(
      clients,
    )..where((t) => t.id.equals(c.id))).getSingleOrNull();
    await into(clients).insertOnConflictUpdate(
      ClientsCompanion.insert(
        id: c.id,
        name: c.name.trim(),
        contact: Value(c.contact.trim()),
        city: Value(c.city.trim()),
        phone: Value(c.phone.trim()),
        email: Value(c.email.trim()),
        archived: Value(c.archived),
        legalName: Value(c.legalName.trim()),
        registryNo: Value(c.registryNo.trim()),
        address: Value(c.address.trim()),
        representative: Value(c.representative.trim()),
        representativeTitle: Value(c.representativeTitle.trim()),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  });

  Future<void> setArchived(String id, {required bool archived}) =>
      transaction(() async {
        await (update(clients)..where((t) => t.id.equals(id))).write(
          ClientsCompanion(
            archived: Value(archived),
            updatedAt: Value(_now()),
          ),
        );
      });

  Client _toModel(ClientRow r) => Client(
    id: r.id,
    name: r.name,
    contact: r.contact,
    city: r.city,
    phone: r.phone,
    email: r.email,
    archived: r.archived,
    legalName: r.legalName,
    registryNo: r.registryNo,
    address: r.address,
    representative: r.representative,
    representativeTitle: r.representativeTitle,
  );
}
