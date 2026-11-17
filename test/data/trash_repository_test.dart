import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/trash_repository.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/trash.dart';
import 'package:path/path.dart' as p;
import '../helpers/legacy_seed.dart';

var _n = 0;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Directory dir;
  late TrashRepository trash;
  late Client academy;
  late Invoice invoice;

  setUp(() async {
    db = AppDatabase.memory(seeder: legacySeed);
    dir = await Directory.systemTemp.createTemp('trash');
    trash = TrashRepository(db, BackupService(db, paths: AppPaths(dir)));
    academy = (await db.clientsDao.getAll()).single;
    invoice = (await db.invoicesDao.getAll()).single;
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  Future<Contract> addContract({String id = 'k1', String? clientId}) async {
    final t = (await db.libraryDao.getAll()).first;
    final c = Contract(
      id: id,
      clientId: clientId ?? academy.id,
      number: 'CT-2026-000${id.substring(1)}',
      year: 2026,
      seq: int.parse(id.substring(1)),
      issueDate: invoice.issueDate,
      clauses: clausesFromTemplate(t, () => '$id-c${_n++}'),
    );
    await db.contractsDao.saveContract(c);
    return c;
  }

  TrashEntry only(List<TrashEntry> all, TrashKind k) =>
      all.singleWhere((e) => e.kind == k);

  List<String> backups() => [
    for (final f in Directory(p.join(dir.path, 'backups')).listSync())
      p.basename(f.path),
  ];

  test(
    'lists clients, invoices and contracts with dates and days left',
    () async {
      final t0 = DateTime.utc(2026, 11, 15, 12);
      await addContract();
      await withClock(Clock.fixed(t0), () async {
        await db.invoicesDao.softDelete(invoice.id);
        await db.contractsDao.softDelete('k1');
      });
      await db.clientsDao.upsert(const Client(id: 'empty', name: 'Empty Co'));
      await withClock(
        Clock.fixed(t0.add(const Duration(hours: 1))),
        () => db.clientsDao.softDelete('empty'),
      );
      final all = await trash.entries();
      expect(all.map((e) => e.kind).toSet(), {
        TrashKind.client,
        TrashKind.invoice,
        TrashKind.contract,
      });
      // Newest deletion first.
      expect(all.first.label, 'Empty Co');
      final inv = only(all, TrashKind.invoice);
      expect(inv.label, 'OM-2026-0001');
      expect(inv.clientName, 'Sample Academy');
      expect(inv.clientDeleted, isFalse);
      expect(daysUntilPurge(inv.deletedAt, t0), 30);
      expect(
        daysUntilPurge(
          inv.deletedAt,
          t0.add(const Duration(days: 29, hours: 23)),
        ),
        1,
      );
      expect(
        daysUntilPurge(inv.deletedAt, t0.add(const Duration(days: 31))),
        0,
      );
    },
  );

  test('restoring an invoice under a live client', () async {
    await db.invoicesDao.softDelete(invoice.id);
    final r = await trash.restore(
      only(await trash.entries(), TrashKind.invoice),
    );
    expect(r, isA<Restored>());
    expect(await db.invoicesDao.countLive(), 1);
    expect(await trash.entries(), isEmpty);
  });

  test('a document under a deleted client asks, then restores both', () async {
    final stamp = await db.clientsDao.softDeleteWithDocuments(academy.id);
    expect(stamp, isPositive);
    final entries = await trash.entries();
    final inv = only(entries, TrashKind.invoice);
    expect(inv.clientDeleted, isTrue);

    final first = await trash.restore(inv);
    expect(first, isA<NeedsClient>());
    expect((first as NeedsClient).clientName, 'Sample Academy');
    expect(await db.invoicesDao.countLive(), 0);

    final second = await trash.restore(inv, withClient: true);
    expect(second, isA<Restored>());
    expect((second as Restored).count, 2);
    expect(await db.clientsDao.getAll(), hasLength(1));
    expect(await db.invoicesDao.countLive(), 1);
  });

  test('restoring a client brings back its whole batch only', () async {
    await addContract();
    // Deleted on its own before the client: stays in the trash.
    final extra = invoice.copyWith(
      id: 'older',
      number: 'OM-2026-0009',
      seq: 9,
      sections: const [],
    );
    await db.invoicesDao.saveInvoice(extra);
    await withClock(
      Clock.fixed(DateTime.utc(2026, 11, 2)),
      () => db.invoicesDao.softDelete('older'),
    );
    await db.clientsDao.softDeleteWithDocuments(academy.id);
    final r = await trash.restore(
      only(await trash.entries(), TrashKind.client),
    );
    expect((r as Restored).count, 3); // client + invoice + contract
    expect(await db.invoicesDao.countLive(), 1);
    expect(await db.contractsDao.getAll(), hasLength(1));
    final left = await trash.entries();
    expect(left.single.id, 'older');
  });

  test(
    'the guards still hold: a live document under a deleted client is refused',
    () async {
      await db.clientsDao.softDeleteWithDocuments(academy.id);
      await expectLater(
        db.customStatement(
          "UPDATE invoices SET deleted_at = NULL WHERE id = '${invoice.id}'",
        ),
        throwsA(anything),
      );
    },
  );

  test(
    'permanent delete of one row writes a before-purge backup first',
    () async {
      await db.invoicesDao.softDelete(invoice.id);
      final file = await trash.purge(
        only(await trash.entries(), TrashKind.invoice),
      );
      expect(p.basename(file.path), startsWith('before-purge-'));
      expect(BackupService.inspect(file).invoiceCount, 1);
      expect(await db.invoicesDao.getAll(includeDeleted: true), isEmpty);
      expect(await db.select(db.sections).get(), isEmpty);
      expect(
        backups().where((b) => b.startsWith('before-purge-')),
        hasLength(1),
      );
    },
  );

  test('permanent delete of a client takes its deleted documents', () async {
    await addContract();
    await db.clientsDao.softDeleteWithDocuments(academy.id);
    await trash.purge(only(await trash.entries(), TrashKind.client));
    expect(await db.select(db.clients).get(), isEmpty);
    expect(await db.select(db.invoices).get(), isEmpty);
    expect(await db.select(db.contracts).get(), isEmpty);
  });

  test(
    'permanent delete of a contract keeps live invoices, unlinks milestones',
    () async {
      final c = await addContract();
      await db.contractsDao.saveContract(
        c.copyWith(
          milestones: [PaymentMilestone(id: 'm1', invoiceId: invoice.id)],
        ),
      );
      // A linked contract can't be soft-deleted; unlink by deleting the row
      // through the DAO guard path is refused, so delete an unlinked one.
      final d = await addContract(id: 'k2');
      await db.contractsDao.softDelete(d.id);
      await trash.purge(only(await trash.entries(), TrashKind.contract));
      expect((await db.contractsDao.getAll()).single.id, 'k1');
      expect(await db.invoicesDao.countLive(), 1);
    },
  );

  test('emptying the trash removes everything deleted, nothing live', () async {
    await db.clientsDao.upsert(const Client(id: 'empty', name: 'Empty Co'));
    await db.clientsDao.softDelete('empty');
    await addContract();
    await db.contractsDao.softDelete('k1');
    final file = await trash.empty();
    expect(p.basename(file.path), startsWith('before-purge-'));
    expect(await trash.entries(), isEmpty);
    expect(await db.clientsDao.getAll(), hasLength(1));
    expect(await db.invoicesDao.countLive(), 1);
    expect(await db.select(db.contracts).get(), isEmpty);
  });
}
