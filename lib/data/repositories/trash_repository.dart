import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/trash.dart';

/// "المحذوفات": lists soft-deleted clients, invoices and contracts, restores
/// them within the database guards, and deletes them for good (after a
/// `before-purge-…` backup).
class TrashRepository {
  /// [_backups] writes the `before-purge-…` file before any hard delete;
  /// [clock] stamps restores.
  TrashRepository(this._db, this._backups, {this.clock = const Clock()});
  final AppDatabase _db;
  final BackupService _backups;

  /// Dates every write (restores set `updated_at`).
  final Clock clock;

  int get _nowMs => clock.now().toUtc().millisecondsSinceEpoch;

  /// Every trash entry, newest deletion first. Re-emits on any change.
  Stream<List<TrashEntry>> watch() => _db
      .customSelect(
        // Its own SQL text: drift shares watch streams by query.
        'SELECT 1 AS trash_tick',
        readsFrom: {_db.clients, _db.invoices, _db.contracts},
      )
      .watch()
      .asyncMap((_) => entries());

  /// Every trash entry, newest deletion first.
  Future<List<TrashEntry>> entries() async {
    final clients = await _db.select(_db.clients).get();
    final byId = {for (final c in clients) c.id: c};
    TrashEntry doc(
      TrashKind kind,
      String id,
      String label,
      int deletedAt,
      String clientId,
    ) {
      final owner = byId[clientId];
      return TrashEntry(
        kind: kind,
        id: id,
        label: label,
        deletedAt: deletedAt,
        clientId: clientId,
        clientName: owner?.name ?? '',
        clientDeleted: owner?.deletedAt != null,
      );
    }

    final out = <TrashEntry>[
      for (final c in clients)
        if (c.deletedAt != null)
          TrashEntry(
            kind: TrashKind.client,
            id: c.id,
            label: c.name,
            deletedAt: c.deletedAt!,
          ),
      for (final i in await (_db.select(
        _db.invoices,
      )..where((t) => t.deletedAt.isNotNull())).get())
        doc(TrashKind.invoice, i.id, i.number, i.deletedAt!, i.clientId),
      for (final k in await (_db.select(
        _db.contracts,
      )..where((t) => t.deletedAt.isNotNull())).get())
        doc(TrashKind.contract, k.id, k.number, k.deletedAt!, k.clientId),
    ]..sort((a, b) => b.deletedAt.compareTo(a.deletedAt));
    return out;
  }

  /// Restores [e]. A client comes back with every row deleted in the same
  /// batch (same stamp). A document whose client is deleted returns
  /// [NeedsClient] unless [withClient] is set, which restores the client
  /// first (just the client, not its batch).
  Future<RestoreResult> restore(TrashEntry e, {bool withClient = false}) =>
      _db.transaction(() async {
        switch (e.kind) {
          case TrashKind.client:
            final row = await _clientRow(e.id);
            if (row?.deletedAt == null) return const NotInTrash();
            final stamp = row!.deletedAt!;
            final docs = await _countBatch(e.id, stamp);
            await withClock(
              clock,
              () => _db.clientsDao.undoDeleteWithDocuments(e.id, stamp),
            );
            return Restored(1 + docs);
          case TrashKind.invoice || TrashKind.contract:
            final owner = await _clientRow(e.clientId!);
            if (owner?.deletedAt != null) {
              if (!withClient) return NeedsClient(owner!.name);
              await withClock(
                clock,
                () => _db.clientsDao.undoDelete(owner!.id),
              );
            }
            final n = e.kind == TrashKind.invoice
                ? await _restoreInvoice(e.id)
                : await _restoreContract(e.id);
            if (n == 0) return const NotInTrash();
            return Restored(n + (owner?.deletedAt != null ? 1 : 0));
        }
      });

  Future<int> _restoreInvoice(String id) async =>
      (_db.update(
        _db.invoices,
      )..where((t) => t.id.equals(id) & t.deletedAt.isNotNull())).write(
        InvoicesCompanion(
          deletedAt: const Value(null),
          updatedAt: Value(_nowMs),
        ),
      );

  /// A contract comes back with the amendments deleted alongside it.
  Future<int> _restoreContract(String id) async {
    final row = await (_db.select(
      _db.contracts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    final stamp = row?.deletedAt;
    if (stamp == null) return 0;
    return (_db.update(_db.contracts)..where(
          (t) =>
              (t.id.equals(id) | t.parentId.equals(id)) &
              t.deletedAt.equals(stamp),
        ))
        .write(
          ContractsCompanion(
            deletedAt: const Value(null),
            updatedAt: Value(_nowMs),
          ),
        );
  }

  Future<ClientRow?> _clientRow(String id) => (_db.select(
    _db.clients,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> _countBatch(String clientId, int stamp) async {
    final inv =
        await (_db.select(_db.invoices)..where(
              (t) => t.clientId.equals(clientId) & t.deletedAt.equals(stamp),
            ))
            .get();
    final con =
        await (_db.select(_db.contracts)..where(
              (t) => t.clientId.equals(clientId) & t.deletedAt.equals(stamp),
            ))
            .get();
    return inv.length + con.length;
  }

  /// "حذف نهائي": writes a `before-purge-…` backup, then hard-deletes [e].
  /// A client takes its (deleted) documents along; the database guards make
  /// sure it has no live ones. Returns the backup file.
  Future<File> purge(TrashEntry e) async {
    final backup = await _backups.backupBefore('purge');
    await _db.transaction(() async {
      switch (e.kind) {
        case TrashKind.invoice:
          await (_db.delete(_db.invoices)..where(
                (t) => t.id.equals(e.id) & t.deletedAt.isNotNull(),
              ))
              .go();
        case TrashKind.contract:
          // Amendments go with their original (ON DELETE CASCADE).
          await (_db.delete(_db.contracts)..where(
                (t) => t.id.equals(e.id) & t.deletedAt.isNotNull(),
              ))
              .go();
        case TrashKind.client:
          final row = await _clientRow(e.id);
          if (row?.deletedAt == null) return;
          await (_db.delete(_db.contracts)..where(
                (t) => t.clientId.equals(e.id) & t.deletedAt.isNotNull(),
              ))
              .go();
          await (_db.delete(_db.invoices)..where(
                (t) => t.clientId.equals(e.id) & t.deletedAt.isNotNull(),
              ))
              .go();
          // FK RESTRICT still refuses this if anything live remains.
          await (_db.delete(_db.clients)..where((t) => t.id.equals(e.id))).go();
      }
    });
    return backup;
  }

  /// "إفراغ المحذوفات": backup, then hard-deletes every trashed row
  /// (contracts, invoices, then clients). Returns the backup file.
  Future<File> empty() async {
    final backup = await _backups.backupBefore('purge');
    await _db.transaction(() async {
      await (_db.delete(
        _db.contracts,
      )..where((t) => t.deletedAt.isNotNull())).go();
      await (_db.delete(
        _db.invoices,
      )..where((t) => t.deletedAt.isNotNull())).go();
      await (_db.delete(
        _db.clients,
      )..where((t) => t.deletedAt.isNotNull())).go();
    });
    return backup;
  }
}
