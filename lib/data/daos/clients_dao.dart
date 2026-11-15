import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/domain/models.dart';

part 'clients_dao.g.dart';

@DriftAccessor(tables: [Clients])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  ClientsDao(super.attachedDatabase);

  Stream<List<Client>> watchAll() =>
      select(clients).watch().map((rows) => rows.map(_toModel).toList());

  Future<List<Client>> getAll() async =>
      (await select(clients).get()).map(_toModel).toList();

  Future<void> upsert(Client c) => transaction(() async {
    final now = clock.now().toUtc().millisecondsSinceEpoch;
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
            updatedAt: Value(clock.now().toUtc().millisecondsSinceEpoch),
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
  );
}
