import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  test('every upgrade path ends in the current schema', () async {
    const versions = GeneratedHelper.versions;
    for (final (i, from) in versions.indexed) {
      for (final to in versions.skip(i + 1)) {
        final schema = await verifier.schemaAt(from);
        final db = AppDatabase(schema.newConnection());
        await verifier.migrateAndValidate(db, to);
        await db.close();
      }
    }
  });

  test('v1 → v2 keeps data and adds the client delete guards', () async {
    final schema = await verifier.schemaAt(1);
    schema.rawDatabase
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

    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 2);

    final clients = await db.clientsDao.getAll();
    expect(clients.map((c) => c.name), ['EL METR Academy', 'Empty Co']);
    expect(clients.last.archived, isTrue);
    final rows = await db.select(db.clients).get();
    expect(rows.every((r) => r.deletedAt == null), isTrue);
    expect(rows.first.updatedAt, 2);

    final inv = (await db.invoicesDao.getAll()).single;
    expect(inv.number, 'OM-2026-0001');
    expect(inv.paidDate?.toIso(), '2026-10-01');
    expect(inv.sections.single.items.single.unitPriceMinor, 150000);
    expect((await db.settingsDao.get()).name, 'Omar');

    // The new guards are live after the upgrade.
    await expectLater(db.clientsDao.softDelete('c1'), throwsA(anything));
    await db.clientsDao.softDelete('c2');
    expect((await db.clientsDao.getAll()).single.id, 'c1');
  });
}
