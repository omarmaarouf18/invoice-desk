import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/daos/invoices_dao.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/sidebar/sidebar_model.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  setUp(() => db = AppDatabase.memory(seed: true));
  tearDown(() => db.close());

  test('seed creates settings, client and invoice', () async {
    final s = await db.settingsDao.get();
    expect(s.name, 'Omar Maarouf');
    final all = await db.invoicesDao.getAll();
    expect(all.single.number, 'OM-2026-0001');
    expect(all.single.sections, hasLength(2));
    expect(all.single.sections[1].items, hasLength(5));
    expect(await db.invoicesDao.nextSeqFor(2026), 2);
    expect(await db.invoicesDao.nextSeqFor(2027), 1);
  });

  test('save is atomic: a failing item rolls back the whole invoice', () async {
    final inv = (await db.invoicesDao.getAll()).single;
    final broken = inv.copyWith(
      notesEn: 'changed',
      sections: [
        inv.sections.first.copyWith(
          items: [
            ...inv.sections.first.items,
            // duplicate primary key → constraint failure mid-transaction
            inv.sections.first.items.first,
          ],
        ),
      ],
    );
    await expectLater(db.invoicesDao.saveInvoice(broken), throwsA(anything));
    final after = (await db.invoicesDao.getAll()).single;
    expect(after.notesEn, inv.notesEn);
    expect(after.sections, hasLength(2));
  });

  test('duplicate numbers are rejected', () async {
    final inv = (await db.invoicesDao.getAll()).single;
    final copy = inv.copyWith(id: 'other', sections: const []);
    await expectLater(
      db.invoicesDao.saveInvoice(copy),
      throwsA(isA<DuplicateInvoiceNumber>()),
    );
    await db.invoicesDao.saveInvoice(copy.copyWith(number: 'OM-2026-0002'));
    expect(await db.invoicesDao.numberTaken('OM-2026-0002'), isTrue);
    expect(
      await db.invoicesDao.numberTaken('OM-2026-0002', exceptId: 'other'),
      isFalse,
    );
  });

  test('soft delete, undo and purge', () async {
    final inv = (await db.invoicesDao.getAll()).single;
    await db.invoicesDao.softDelete(inv.id);
    expect(await db.invoicesDao.getAll(), isEmpty);
    await db.invoicesDao.undoDelete(inv.id);
    expect(await db.invoicesDao.getAll(), hasLength(1));

    await db.invoicesDao.softDelete(inv.id);
    expect(await db.invoicesDao.purgeDeleted(), 0);
    final later = DateTime.now().add(const Duration(days: 31));
    await withClock(Clock.fixed(later), () async {
      expect(await db.invoicesDao.purgeDeleted(), 1);
    });
    expect(await db.invoicesDao.getAll(includeDeleted: true), isEmpty);
  });

  test('search matches client, phone, number and contract ref', () async {
    final clients = await db.clientsDao.getAll();
    final invoices = await db.invoicesDao.getAll();
    const today = CalendarDate(2026, 11, 15);
    SidebarData run(String q) => buildSidebar(
      clients: clients,
      invoices: invoices,
      query: q,
      filter: SidebarFilter.all,
      today: today,
    );
    expect(run('metr').groups, hasLength(1));
    expect(run('0001').groups.single.invoices, hasLength(1));
    expect(run('٠١٢٢٢').groups, hasLength(1));
    expect(run('nothing').groups, isEmpty);
    expect(run('').summary.unpaid.format(), r'22,000 EGP + $255.50');
    expect(run('').summary.overdueCount, 1);
  });

  test('backup via VACUUM INTO reopens with the same invoice count', () async {
    final dir = await Directory.systemTemp.createTemp('bk');
    addTearDown(() => dir.delete(recursive: true));
    final file = await BackupService(db, paths: AppPaths(dir)).backupNow(dir);
    final info = BackupService.inspect(file);
    expect(info.invoiceCount, 1);
    expect(info.userVersion, AppDatabase.currentSchemaVersion);

    final reopened = AppDatabase.file(file, seed: false);
    expect(await reopened.invoicesDao.countLive(), 1);
    await reopened.close();

    // restore into an empty DB
    final empty = AppDatabase.memory();
    addTearDown(empty.close);
    expect(await empty.invoicesDao.countLive(), 0);
    await BackupService(empty, paths: AppPaths(dir)).restoreFrom(file);
    final restored = await empty.invoicesDao.getAll();
    expect(
      restored.single.sections[1].subtotal,
      const Money(25550, Currency.usd),
    );
    expect(restored.single.status, InvoiceStatus.sent);
  });
}
