import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/sidebar/sidebar_model.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Client academy;

  setUp(() async {
    db = AppDatabase.memory(seed: true);
    academy = (await db.clientsDao.getAll()).single;
  });
  tearDown(() => db.close());

  Future<Client> addClient(String name) async {
    final c = Client(id: name.toLowerCase(), name: name);
    await db.clientsDao.upsert(c);
    return c;
  }

  test(
    'client without invoices: soft delete, undo, purge after 30 days',
    () async {
      final empty = await addClient('Empty Co');
      expect(await db.clientsDao.countLiveInvoices(empty.id), 0);

      await db.clientsDao.softDelete(empty.id);
      expect((await db.clientsDao.getAll()).map((c) => c.id), [academy.id]);

      await db.clientsDao.undoDelete(empty.id);
      expect(await db.clientsDao.getAll(), hasLength(2));

      final t0 = DateTime(2026, 11, 15);
      await withClock(
        Clock.fixed(t0),
        () => db.clientsDao.softDelete(empty.id),
      );
      await withClock(
        Clock.fixed(t0.add(const Duration(days: 29))),
        () async => expect(await db.clientsDao.purgeDeleted(), 0),
      );
      await withClock(
        Clock.fixed(t0.add(const Duration(days: 31))),
        () async => expect(await db.clientsDao.purgeDeleted(), 1),
      );
      expect(await db.select(db.clients).get(), hasLength(1));
    },
  );

  test('DB refuses a raw delete of a client that has invoices', () async {
    await expectLater(
      db.customStatement('DELETE FROM clients WHERE id = ?', [academy.id]),
      throwsA(
        isA<SqliteException>().having(
          (e) => e.message,
          'message',
          contains('FOREIGN KEY'),
        ),
      ),
    );
    // Soft-deleting the client alone is refused too.
    await expectLater(
      db.clientsDao.softDelete(academy.id),
      throwsA(
        isA<SqliteException>().having(
          (e) => e.message,
          'message',
          contains('client has live invoices'),
        ),
      ),
    );
    expect(await db.clientsDao.getAll(), hasLength(1));
    expect(await db.invoicesDao.countLive(), 1);
  });

  test(
    'delete with invoices is one batch; undo restores only that batch',
    () async {
      // A second invoice that was deleted on its own before.
      final first = (await db.invoicesDao.getAll()).single;
      final older = first.copyWith(
        id: 'older',
        number: 'OM-2026-0009',
        seq: 9,
        sections: const [],
      );
      await db.invoicesDao.saveInvoice(older);
      await withClock(
        Clock.fixed(DateTime(2026, 11, 2)),
        () => db.invoicesDao.softDelete('older'),
      );

      final stamp = await db.clientsDao.softDeleteWithInvoices(academy.id);
      expect(await db.clientsDao.getAll(), isEmpty);
      expect(await db.invoicesDao.getAll(), isEmpty);
      // Reviving an invoice of a deleted client, or adding one, is refused.
      await expectLater(db.invoicesDao.undoDelete(first.id), throwsA(anything));
      await expectLater(
        db.invoicesDao.saveInvoice(
          first.copyWith(id: 'new', number: 'OM-2026-0010', seq: 10),
        ),
        throwsA(anything),
      );

      await db.clientsDao.undoDeleteWithInvoices(academy.id, stamp);
      expect((await db.clientsDao.getAll()).single.id, academy.id);
      final live = await db.invoicesDao.getAll();
      expect(live.map((i) => i.id), [first.id]);
      expect(live.single.sections, hasLength(2));
    },
  );

  test('purge removes invoices first, then the client', () async {
    final t0 = DateTime(2026, 11, 15);
    await withClock(
      Clock.fixed(t0),
      () => db.clientsDao.softDeleteWithInvoices(academy.id),
    );
    await withClock(Clock.fixed(t0.add(const Duration(days: 31))), () async {
      // Client purge alone can't run while invoice rows remain.
      expect(await db.clientsDao.purgeDeleted(), 0);
      expect(await db.invoicesDao.purgeDeleted(), 1);
      expect(await db.clientsDao.purgeDeleted(), 1);
    });
    expect(await db.select(db.clients).get(), isEmpty);
    expect(await db.select(db.sections).get(), isEmpty);
  });

  test(
    'archive hides the client and their invoices; the filter shows them',
    () async {
      final other = await addClient('Beta Studio');
      await db.clientsDao.setArchived(academy.id, archived: true);
      final clients = await db.clientsDao.getAll();
      final invoices = await db.invoicesDao.getAll();
      const today = CalendarDate(2026, 11, 15);
      SidebarData run(SidebarFilter f, [String q = '']) => buildSidebar(
        clients: clients,
        invoices: invoices,
        query: q,
        filter: f,
        today: today,
      );

      expect(run(SidebarFilter.all).groups.map((g) => g.client.id), [other.id]);
      expect(run(SidebarFilter.unpaid).groups, isEmpty);
      expect(run(SidebarFilter.all, 'metr').groups, isEmpty);
      expect(run(SidebarFilter.all, '0001').groups, isEmpty);
      expect(run(SidebarFilter.all).summary.unpaid.isEmpty, isTrue);

      final archived = run(SidebarFilter.archived);
      expect(archived.groups.single.client.id, academy.id);
      expect(archived.groups.single.invoices, hasLength(1));
      expect(run(SidebarFilter.archived, '0001').groups, hasLength(1));
      expect(run(SidebarFilter.archived, 'beta').groups, isEmpty);
    },
  );

  test(
    'pre-delete backup lands in the backup folder and is not pruned',
    () async {
      final dir = await Directory.systemTemp.createTemp('bk');
      addTearDown(() => dir.delete(recursive: true));
      final service = BackupService(db, paths: AppPaths(dir));
      final file = await withClock(
        Clock.fixed(DateTime(2026, 11, 15, 9, 5, 7)),
        () => service.backupBefore('delete-client'),
      );
      expect(
        file.path,
        endsWith('backups/before-delete-client-2026-11-15-090507.sqlite'),
      );
      expect(BackupService.inspect(file).invoiceCount, 1);
      await service.prune(file.parent, keep: 0);
      expect(file.existsSync(), isTrue);
    },
  );

  test('a v1-era backup (no clients.deleted_at) still restores', () async {
    final dir = await Directory.systemTemp.createTemp('bk');
    addTearDown(() => dir.delete(recursive: true));
    final file = await BackupService(db, paths: AppPaths(dir)).backupNow(dir);
    // Turn the copy into a v1 file: drop the v2 column and triggers.
    final old = AppDatabase.file(file, seed: false);
    await old.customStatement('DROP TRIGGER clients_soft_delete_guard');
    await old.customStatement('DROP TRIGGER invoices_revive_guard');
    await old.customStatement('DROP TRIGGER invoices_insert_guard');
    await old.customStatement('ALTER TABLE clients DROP COLUMN deleted_at');
    await old.customStatement('PRAGMA user_version = 1');
    await old.close();
    expect(BackupService.inspect(file).userVersion, 1);
    expect(BackupService.inspect(file).isCompatible, isTrue);

    final target = AppDatabase.memory();
    addTearDown(target.close);
    await BackupService(target, paths: AppPaths(dir)).restoreFrom(file);
    expect((await target.clientsDao.getAll()).single.name, 'EL METR Academy');
    expect(await target.invoicesDao.countLive(), 1);
  });
}
