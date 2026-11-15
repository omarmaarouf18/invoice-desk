import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import 'generated/schema.dart';

/// Rows every old schema has: settings, two clients, a paid invoice with a
/// section and an item.
void insertV1Data(sql.Database raw) => raw
  ..execute(
    "INSERT INTO settings (id, name, invoice_prefix) VALUES (1, 'Omar', 'OM')",
  )
  ..execute(
    'INSERT INTO clients (id, name, phone, created_at, updated_at, archived) '
    "VALUES ('c1', 'EL METR Academy', '0122', 1, 2, 0), "
    "('c2', 'Empty Co', '', 1, 1, 1)",
  )
  ..execute(
    'INSERT INTO invoices (id, client_id, number, year, seq, issue_date, '
    'due_date, paid_date, status, created_at, updated_at) VALUES '
    "('i1', 'c1', 'OM-2026-0001', 2026, 1, '2026-09-14', '2026-10-14', "
    "'2026-10-01', 'paid', 1, 1)",
  )
  ..execute(
    'INSERT INTO sections (id, invoice_id, position, currency) '
    "VALUES ('s1', 'i1', 0, 'EGP')",
  )
  ..execute(
    'INSERT INTO items (id, section_id, position, cycle, qty, '
    "unit_price_minor) VALUES ('t1', 's1', 0, 'one-time', 2, 150000)",
  );

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('every old schema upgrades to the current one', () async {
    for (final from in GeneratedHelper.versions) {
      if (from == AppDatabase.currentSchemaVersion) continue;
      final schema = await verifier.schemaAt(from);
      final db = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
      await db.close();
    }
  });

  Future<void> expectCarriedOver(AppDatabase db) async {
    final clients = await db.clientsDao.getAll();
    expect(clients.map((c) => c.name), ['EL METR Academy', 'Empty Co']);
    expect(clients.last.archived, isTrue);
    expect(clients.first.legalName, '');
    final rows = await (db.select(
      db.clients,
    )..where((c) => c.id.isIn(['c1', 'c2']))).get();
    expect(rows.every((r) => r.deletedAt == null), isTrue);
    expect(rows.first.updatedAt, 2);

    final inv = (await db.invoicesDao.getAll()).single;
    expect(inv.number, 'OM-2026-0001');
    expect(inv.paidDate?.toIso(), '2026-10-01');
    expect(inv.sections.single.items.single.unitPriceMinor, 150000);
    final settings = await db.settingsDao.get();
    expect(settings.name, 'Omar');
    expect(settings.contractPrefix, 'CT');
    expect(settings.quotePrefix, 'QT');

    // The library is seeded once, with both templates.
    final lib = await db.libraryDao.getAll();
    expect(lib.map((t) => t.name), [
      developmentTemplateName,
      quoteTemplateName,
    ]);
    expect(lib.first.clauses, hasLength(14));
    expect(lib.first.clauses.where((c) => c.optional), hasLength(4));
    expect(lib.last.clauses, hasLength(6));
    expect(await db.contractsDao.getAll(), isEmpty);
  }

  test('v1 → v3 keeps data, adds guards and seeds the library', () async {
    final schema = await verifier.schemaAt(1);
    insertV1Data(schema.rawDatabase);
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 3);
    await expectCarriedOver(db);
    await expectLater(db.clientsDao.softDelete('c1'), throwsA(anything));
    await db.clientsDao.softDelete('c2');
    expect((await db.clientsDao.getAll()).single.id, 'c1');
  });

  test('v2 → v3 keeps a soft-deleted client and its batch', () async {
    final schema = await verifier.schemaAt(2);
    insertV1Data(schema.rawDatabase);
    schema.rawDatabase
      ..execute(
        'INSERT INTO clients (id, name, created_at, updated_at, deleted_at) '
        "VALUES ('c3', 'Gone Co', 1, 1, 5)",
      )
      ..execute(
        'INSERT INTO invoices (id, client_id, number, year, seq, issue_date, '
        'due_date, status, deleted_at, created_at, updated_at) VALUES '
        "('i3', 'c3', 'OM-2026-0003', 2026, 3, '2026-09-14', '2026-10-14', "
        "'sent', 5, 1, 1)",
      );
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 3);
    await expectCarriedOver(db);
    final gone = await (db.select(
      db.clients,
    )..where((c) => c.id.equals('c3'))).getSingle();
    expect(gone.deletedAt, 5);
    await db.clientsDao.undoDeleteWithDocuments('c3', 5);
    expect((await db.invoicesDao.getAll()).map((i) => i.id), contains('i3'));

    // The v3 guard counts contracts: a live contract blocks the delete.
    await db.customStatement(
      'INSERT INTO contracts (id, client_id, number, series, year, seq, '
      'kind, issue_date, status, currency, created_at, updated_at) VALUES '
      "('k1', 'c2', 'CT-2026-0001', 'contract', 2026, 1, 'contract', "
      "'2026-11-15', 'draft', 'EGP', 1, 1)",
    );
    await expectLater(db.clientsDao.softDelete('c2'), throwsA(anything));
  });

  test('the library is not seeded twice', () async {
    final schema = await verifier.schemaAt(2);
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 3);
    await db.libraryDao.seedIfEmpty();
    expect(await db.libraryDao.getAll(), hasLength(2));
  });
}
