import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/data/repositories/client_repository.dart';
import 'package:invoice_desk/data/repositories/contract_repository.dart';
import 'package:invoice_desk/data/repositories/demo_repository.dart';
import 'package:invoice_desk/data/repositories/invoice_repository.dart';
import 'package:invoice_desk/domain/calendar/events.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:path/path.dart' as p;

import '../helpers/legacy_seed.dart';

final fixed = Clock.fixed(DateTime(2026, 11, 15, 10));
const today = CalendarDate(2026, 11, 15);

Future<CalendarData> snapshot(AppDatabase db) async => CalendarData(
  invoices: await db.invoicesDao.getAll(),
  contracts: await db.contractsDao.getAll(),
  clients: await db.clientsDao.getAll(),
  postponements: await db.calendarDao.allPostponements(),
  reminders: await db.calendarDao.allReminders(),
);

Future<int> count(AppDatabase db, String sql) async =>
    (await db.customSelect(sql).getSingle()).data.values.first! as int;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  Future<AppDatabase> demoDb() async {
    final db = AppDatabase.memory(
      seeder: (db) => seedDemo(db, clock: fixed),
    );
    addTearDown(db.close);
    await db.settingsDao.get();
    return db;
  }

  test('fictional: no real names, numbers or domains', () async {
    final db = await demoDb();
    final clients = await db.clientsDao.getAll();
    expect(clients, hasLength(5));
    for (final c in clients) {
      expect(c.isDemo, isTrue);
      expect(c.phone, startsWith('0100 000 00'));
      expect(c.email, matches(RegExp(r'@[\w.-]+\.example\.(com|eg)$')));
    }
    final dump = clients.map((c) => '${c.name}${c.phone}').join();
    expect(dump, isNot(contains('METR')));
    expect(dump, isNot(contains('01222700727')));
    final invoices = await db.invoicesDao.getAll();
    expect(invoices, hasLength(14));
    expect(
      invoices.every((i) => i.isDemo && i.number.startsWith('DEMO-')),
      isTrue,
    );
    expect(invoices.map((i) => i.status).toSet(), InvoiceStatus.values.toSet());
    expect(
      await count(db, 'SELECT COUNT(*) FROM contracts WHERE is_demo = 1'),
      4,
    ); // 3 contracts + 1 amendment
  });

  test('deterministic for a fixed clock', () async {
    final a = await demoDb();
    final b = await demoDb();
    String sig(List<Invoice> l) => [
      for (final i in l..sort((x, y) => x.id.compareTo(y.id)))
        '${i.id} ${i.number} ${i.issueDate} ${i.dueDate} ${i.paidDate} ${i.status} ${i.totals.total}',
    ].join('\n');
    expect(
      sig(await a.invoicesDao.getAll()),
      sig(await b.invoicesDao.getAll()),
    );
  });

  test('every event type within ±30 days of the seed day', () async {
    final db = await demoDb();
    final events = calendarEvents(
      DateRange(today.addDays(-30), today.addDays(30)),
      await snapshot(db),
      fixed,
    );
    final types = events.map((e) => e.type).toSet();
    expect(types, CalendarEventType.values.toSet());
    final due = events.where((e) => e.date == today);
    expect(due.map((e) => e.type), contains(CalendarEventType.due));
    final overdue = events.firstWhere(
      (e) => e.type == CalendarEventType.overdue,
    );
    expect(overdue.daysOverdue, 10);
    expect(
      events
          .where((e) => e.type == CalendarEventType.contractEnd)
          .map((e) => e.date),
      contains(today.addDays(21)),
    );
  });

  test('real numbering ignores demo rows', () async {
    final db = await demoDb();
    expect(await db.invoicesDao.nextSeqFor(2026), 1);
  });

  group('removal', () {
    late AppDatabase db;
    late DemoRepository repo;
    late Directory tmp;

    setUp(() async {
      db = AppDatabase.memory(seeder: legacySeed);
      await db.settingsDao.get();
      tmp = Directory.systemTemp.createTempSync('demo');
      final paths = AppPaths(tmp);
      repo = DemoRepository(
        db,
        BackupService(db, paths: paths, clock: fixed),
        clock: fixed,
      );
      expect(await repo.addDemo(), isTrue);
      expect(await repo.addDemo(), isFalse, reason: 'only once');
    });
    tearDown(() async {
      await db.close();
      tmp.deleteSync(recursive: true);
    });

    test('backs up, deletes only demo rows, keeps real ones', () async {
      final realBefore = (await db.invoicesDao.getAll())
          .where((i) => !i.isDemo)
          .map((i) => i.id)
          .toList();
      expect(realBefore, hasLength(1));
      final r = await repo.removeDemo();
      expect(p.basename(r.backup.path), startsWith('before-remove-demo-'));
      expect(r.backup.existsSync(), isTrue);
      expect(r.invoices, 14);
      expect(r.clients, 5);
      expect(r.reminders, 3);
      expect((await db.invoicesDao.getAll()).map((i) => i.id), realBefore);
      expect((await db.clientsDao.getAll()).single.name, 'Sample Academy');
      for (final t in [
        'clients',
        'invoices',
        'contracts',
        'reminders',
      ]) {
        expect(await count(db, 'SELECT COUNT(*) FROM $t WHERE is_demo = 1'), 0);
      }
      expect(await count(db, 'SELECT COUNT(*) FROM postponements'), 0);
      expect((await db.customSelect('PRAGMA foreign_key_check').get()).length, 0);
      expect(await repo.hasDemo(), isFalse);
    });

    test('editing adopts a row: it survives removal', () async {
      final invoices = InvoiceRepository(db, clock: fixed);
      final clients = ClientRepository(db, clock: fixed);
      final contracts = ContractRepository(db, clock: fixed);
      final demo = (await invoices.getAll()).firstWhere((i) => i.isDemo);
      await invoices.save(demo.copyWith(notesEn: 'edited'));
      final adopted = (await invoices.getById(demo.id))!;
      expect(adopted.isDemo, isFalse);
      final c = (await clients.getAll()).firstWhere((c) => c.isDemo);
      await clients.save(c.copyWith(city: 'Giza'));
      expect((await clients.getById(c.id))!.isDemo, isFalse);
      final k = (await contracts.getAll()).firstWhere((k) => k.isDemo);
      await contracts.save(k.copyWith(title: 'mine'));
      expect((await contracts.getById(k.id))!.isDemo, isFalse);

      final r = await repo.removeDemo();
      expect(await invoices.getById(demo.id), isNotNull);
      expect(await contracts.getById(k.id), isNotNull);
      // The adopted invoice's client stays (and is real now).
      final owner = await clients.getById(adopted.clientId);
      expect(owner, isNotNull);
      expect(owner!.isDemo, isFalse);
      expect(r.keptClients, greaterThanOrEqualTo(1));
      expect((await db.customSelect('PRAGMA foreign_key_check').get()).length, 0);
    });
  });
}
