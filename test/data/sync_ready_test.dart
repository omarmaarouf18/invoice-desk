import 'package:clock/clock.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/account/account.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/sync/sync.dart';

/// v4 sync seams: rev, outbox, tombstones, device id, local/no-op services.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Invoice inv;

  setUp(() async {
    db = AppDatabase.memory(seed: true);
    inv = (await db.invoicesDao.getAll()).single;
  });
  tearDown(() => db.close());

  Future<int> one(String sql) async =>
      (await db.customSelect(sql).getSingle()).data.values.first! as int;
  Future<int> rev(String table, String id) =>
      one("SELECT rev FROM $table WHERE id = '$id'");
  Future<int?> outboxRev(String entity, String id) async {
    final r = await db
        .customSelect(
          "SELECT rev FROM outbox WHERE entity = '$entity' AND row_id = '$id'",
        )
        .getSingleOrNull();
    return r?.read<int>('rev');
  }

  test('every write bumps rev and the outbox, in the same transaction', () async {
    final r0 = await rev('invoices', inv.id);
    expect(await outboxRev('invoices', inv.id), r0);

    await db.invoicesDao.saveInvoice(inv.copyWith(notesEn: 'changed'));
    expect(await rev('invoices', inv.id), r0 + 1);
    expect(await outboxRev('invoices', inv.id), r0 + 1);

    await db.invoicesDao.markPaid(inv.id, inv.issueDate);
    expect(await rev('invoices', inv.id), r0 + 2);
    // One outbox row per entity row, at its latest revision.
    expect(
      await one(
        "SELECT COUNT(*) FROM outbox WHERE entity = 'invoices' AND row_id = '${inv.id}'",
      ),
      1,
    );
  });

  test('unchanged children are not rewritten', () async {
    final section = inv.sections.first;
    final before = await rev('sections', section.id);
    await db.invoicesDao.saveInvoice(inv.copyWith(notesEn: 'only the header'));
    expect(await rev('sections', section.id), before);
    final item = section.items.first;
    final itemBefore = await rev('items', item.id);
    await db.invoicesDao.saveInvoice(
      inv.copyWith(
        sections: [
          section.copyWith(
            items: [
              item.copyWith(qty: 3),
              ...section.items.skip(1),
            ],
          ),
          ...inv.sections.skip(1),
        ],
      ),
    );
    expect(await rev('items', item.id), itemBefore + 1);
    expect(await rev('sections', section.id), before);
  });

  test('a failed save leaves rows, revs and the outbox untouched', () async {
    final outboxBefore = await one('SELECT COUNT(*) FROM outbox');
    final revBefore = await rev('invoices', inv.id);
    await expectLater(
      db.invoicesDao.saveInvoice(
        inv.copyWith(
          notesEn: 'never saved',
          sections: [
            inv.sections.first.copyWith(
              items: [const LineItem(id: 'bad', qty: -1)],
            ),
          ],
        ),
      ),
      throwsA(anything),
    );
    expect(await rev('invoices', inv.id), revBefore);
    expect(await one('SELECT COUNT(*) FROM outbox'), outboxBefore);
    expect((await db.invoicesDao.getAll()).single.notesEn, inv.notesEn);
  });

  test('removed children become tombstones, not hard deletes', () async {
    final removed = inv.sections.last;
    await db.invoicesDao.saveInvoice(
      inv.copyWith(sections: [inv.sections.first]),
    );
    final row = await (db.select(
      db.sections,
    )..where((s) => s.id.equals(removed.id))).getSingle();
    expect(row.deletedAt, isNotNull);
    final tombstonedItems = await (db.select(
      db.items,
    )..where((i) => i.sectionId.equals(removed.id))).get();
    expect(tombstonedItems.every((i) => i.deletedAt != null), isTrue);
    expect((await db.invoicesDao.getById(inv.id))!.sections, hasLength(1));
    expect(await outboxRev('sections', removed.id), row.rev);

    // Purge removes tombstones only after 30 days.
    final t0 = DateTime.fromMillisecondsSinceEpoch(row.deletedAt!);
    await withClock(
      Clock.fixed(t0.add(const Duration(days: 29))),
      db.invoicesDao.purgeDeleted,
    );
    expect(await db.select(db.sections).get(), hasLength(2));
    await withClock(
      Clock.fixed(t0.add(const Duration(days: 31))),
      db.invoicesDao.purgeDeleted,
    );
    expect(await db.select(db.sections).get(), hasLength(1));
  });

  test(
    'purge keeps tombstones that were never synced',
    () {},
    skip:
        'Placeholder: sync is disabled, so purge removes every tombstone '
        'older than 30 days. When sync ships, assert unsynced tombstones '
        'survive the purge (see TODO(sync) in the DAOs).',
  );

  test('a device id is generated once and kept across opens', () async {
    final id = (
      await db.settingsDao.get(),
      await db
          .customSelect(
            'SELECT device_id FROM settings',
          )
          .getSingle(),
    ).$2.read<String>('device_id');
    expect(id, hasLength(36));
    await db.ensureDeviceId();
    final again = await db
        .customSelect('SELECT device_id FROM settings')
        .getSingle();
    expect(again.read<String>('device_id'), id);
  });

  test('library template delete is a tombstone too', () async {
    final t = (await db.libraryDao.getAll()).first;
    await db.libraryDao.deleteTemplate(t.id);
    expect(
      (await db.libraryDao.getAll()).map((x) => x.id),
      isNot(contains(t.id)),
    );
    final row = await (db.select(
      db.clauseTemplates,
    )..where((x) => x.id.equals(t.id))).getSingle();
    expect(row.deletedAt, isNotNull);
    expect(
      await one(
        "SELECT COUNT(*) FROM library_clauses WHERE template_id = '${t.id}' "
        'AND deleted_at IS NULL',
      ),
      0,
    );
  });

  test('local account and no-op sync change nothing', () async {
    const account = LocalAccountService();
    expect(account.current, isA<LocalOnly>());
    expect(await account.watch().first, isA<LocalOnly>());
    const sync = NoopSyncService();
    final outbox = await one('SELECT COUNT(*) FROM outbox');
    await sync.push();
    await sync.pull();
    expect(await sync.status.first, isA<SyncDisabled>());
    expect(await one('SELECT COUNT(*) FROM outbox'), outbox);
    expect(await db.invoicesDao.countLive(), 1);
    // The other states exist for the future service.
    expect(const SignedIn('a@example.com').email, 'a@example.com');
    expect(
      Subscribed(plan: 'sync', expiresAt: DateTime.utc(2027)).plan,
      'sync',
    );
    expect(const Expired(), isA<AccountState>());
    expect(const SyncError('offline').code, 'offline');
    expect(const [SyncIdle(), SyncSyncing(), SyncConflict()], hasLength(3));
  });
}
