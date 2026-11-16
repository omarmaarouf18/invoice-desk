import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

import 'generated/schema.dart';

/// Rows every old schema has: settings, two clients, a paid invoice with a
/// section and an item.
void insertV1Data(sql.Database raw) => raw
  ..execute(
    "INSERT INTO settings (id, name, invoice_prefix) VALUES (1, 'Provider', 'OM')",
  )
  ..execute(
    'INSERT INTO clients (id, name, phone, created_at, updated_at, archived) '
    "VALUES ('c1', 'Sample Academy', '0122', 1, 2, 0), "
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
    expect(clients.map((c) => c.name), ['Sample Academy', 'Empty Co']);
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
    expect(settings.name, 'Provider');
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

  test('v1 → current keeps data, adds guards and seeds the library', () async {
    final schema = await verifier.schemaAt(1);
    insertV1Data(schema.rawDatabase);
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
    await expectCarriedOver(db);
    await expectLater(db.clientsDao.softDelete('c1'), throwsA(anything));
    await db.clientsDao.softDelete('c2');
    expect((await db.clientsDao.getAll()).single.id, 'c1');
  });

  test('v2 → current keeps a soft-deleted client and its batch', () async {
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
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
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
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);
    await db.libraryDao.seedIfEmpty();
    expect(await db.libraryDao.getAll(), hasLength(2));
  });

  test(
    'v3 → v4: rev 1, outbox for every row, device id, live triggers',
    () async {
      final schema = await verifier.schemaAt(3);
      insertV1Data(schema.rawDatabase);
      schema.rawDatabase
        ..execute(
          'INSERT INTO clause_templates (id, name, kind, position, created_at, '
          "updated_at) VALUES ('t1', 'T', 'contract', 0, 1, 1)",
        )
        ..execute(
          'INSERT INTO library_clauses (id, template_id, position, title) '
          "VALUES ('lc1', 't1', 0, 'بند')",
        )
        ..execute(
          'INSERT INTO contracts (id, client_id, number, series, year, seq, '
          'kind, issue_date, status, currency, created_at, updated_at) VALUES '
          "('k1', 'c1', 'CT-2026-0001', 'contract', 2026, 1, 'contract', "
          "'2026-11-15', 'draft', 'EGP', 1, 3)",
        )
        ..execute(
          'INSERT INTO contract_clauses (id, contract_id, position, title) '
          "VALUES ('cc1', 'k1', 0, 'بند')",
        )
        ..execute(
          'INSERT INTO payment_milestones (id, contract_id, position, label, '
          "percent_bp) VALUES ('m1', 'k1', 0, 'مقدم', 10000)",
        );
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

      Future<int> one(String sql) async =>
          (await db.customSelect(sql).getSingle()).data.values.first! as int;
      const syncable = [
        'settings',
        'clients',
        'invoices',
        'sections',
        'items',
        'clause_templates',
        'library_clauses',
        'contracts',
        'contract_clauses',
        'scope_items',
        'payment_milestones',
      ];
      for (final t in syncable) {
        final rows = await one('SELECT COUNT(*) FROM $t');
        final id = t == 'settings' ? 'CAST(x.id AS TEXT)' : 'x.id';
        expect(
          await one('SELECT COUNT(*) FROM $t WHERE rev >= 1'),
          rows,
          reason: t,
        );
        // Each row has exactly one outbox entry, at its current revision.
        expect(
          await one(
            'SELECT COUNT(*) FROM $t x JOIN outbox o '
            "ON o.entity = '$t' AND o.row_id = $id AND o.rev = x.rev",
          ),
          rows,
          reason: t,
        );
      }
      // Backfilled rows start at rev 1; settings is at 3 because the device
      // id was written right after the migration and the digit style took
      // over the old contract switch in v6.
      expect(await one('SELECT rev FROM invoices'), 1);
      expect(await one('SELECT rev FROM settings'), 3);
      expect(
        await one('SELECT COUNT(*) FROM sections WHERE updated_at = 0'),
        0,
      );
      expect(
        await one(
          "SELECT COUNT(*) FROM outbox WHERE entity = 'contracts' AND changed_at = 3",
        ),
        1,
      );
      final device = await db
          .customSelect('SELECT device_id FROM settings')
          .getSingle();
      expect(device.read<String>('device_id'), hasLength(36));

      // Triggers are live: a write bumps rev and the outbox entry.
      await db.clientsDao.setArchived('c1', archived: true);
      expect(await one("SELECT rev FROM clients WHERE id = 'c1'"), 2);
      expect(
        await one(
          "SELECT rev FROM outbox WHERE entity = 'clients' AND row_id = 'c1'",
        ),
        2,
      );
      // Old data still reads the same.
      expect(
        (await db.invoicesDao.getAll()).single.sections.single.items,
        hasLength(1),
      );
      expect(
        (await db.contractsDao.getById('k1'))!.milestones.single.percentBp,
        10000,
      );
    },
  );

  test(
    'v4 → v5: real rows stay real, calendar tables are sync-ready',
    () async {
      final schema = await verifier.schemaAt(4);
      insertV1Data(schema.rawDatabase);
      schema.rawDatabase.execute(
        'INSERT INTO contracts (id, client_id, number, series, year, seq, '
        'kind, issue_date, status, currency, created_at, updated_at) VALUES '
        "('k1', 'c1', 'CT-2026-0001', 'contract', 2026, 1, 'contract', "
        "'2026-11-15', 'signed', 'EGP', 1, 3)",
      );
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

      Future<int> one(String sql) async =>
          (await db.customSelect(sql).getSingle()).data.values.first! as int;
      for (final t in [
        'clients',
        'invoices',
        'contracts',
        'clause_templates',
      ]) {
        expect(
          await one('SELECT COUNT(*) FROM $t WHERE is_demo = 1'),
          0,
          reason: t,
        );
      }
      for (final i in [
        'invoices_due',
        'invoices_paid',
        'milestones_due',
        'postponements_entity',
        'reminders_date',
      ]) {
        expect(
          await one(
            "SELECT COUNT(*) FROM sqlite_master WHERE type = 'index' "
            "AND name = '$i'",
          ),
          1,
          reason: i,
        );
      }
      // The new tables are sync-ready: writes bump rev and fill the outbox.
      await db.customStatement(
        'INSERT INTO reminders (id, date, text, created_at, updated_at) '
        "VALUES ('r1', '2026-11-20', 'call', 1, 1)",
      );
      await db.customStatement(
        'INSERT INTO postponements (id, entity_type, entity_id, from_date, '
        "to_date, created_at, updated_at) VALUES ('p1', 'invoice', 'i1', "
        "'2026-10-14', '2026-11-30', 1, 1)",
      );
      expect(await one("SELECT rev FROM reminders WHERE id = 'r1'"), 1);
      expect(
        await one(
          'SELECT COUNT(*) FROM outbox WHERE entity IN '
          "('reminders', 'postponements')",
        ),
        2,
      );
      // Old data reads the same, now with the effective due date.
      final inv = (await db.invoicesDao.getAll()).single;
      expect(inv.number, 'OM-2026-0001');
      expect(inv.isDemo, isFalse);
      expect(inv.postponedTo?.toIso(), '2026-11-30');
      expect(inv.dueDate.toIso(), '2026-10-14');
      expect((await db.contractsDao.getById('k1'))!.isDemo, isFalse);
    },
  );

  test(
    'v5 → v6: the invoices keep their look, the digits keep their style',
    () async {
      final schema = await verifier.schemaAt(5);
      insertV1Data(schema.rawDatabase);
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

      // The invoice that existed keeps the bilingual look (ADR-0011).
      final inv = (await db.invoicesDao.getAll()).single;
      expect(inv.language, DocLanguage.bilingual);
      // The client has no preference yet.
      expect((await db.clientsDao.getAll()).first.preferredLanguage, null);
      // The default language is Arabic (D7) and the old contract switch
      // (off) became Arabic-Indic digits, so the contracts keep theirs.
      final s = await db.settingsDao.get();
      expect(s.defaultDocLanguage, DocLanguage.ar);
      expect(s.docDigitStyle, DigitStyle.arabicIndic);
      expect(s.contractWesternDigits, isFalse);
    },
  );

  test('v5 → v6: Western digits stay Western', () async {
    final schema = await verifier.schemaAt(5);
    insertV1Data(schema.rawDatabase);
    schema.rawDatabase.execute(
      'UPDATE settings SET contract_western_digits = 1',
    );
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, AppDatabase.currentSchemaVersion);

    final s = await db.settingsDao.get();
    expect(s.docDigitStyle, DigitStyle.western);
    expect(s.contractWesternDigits, isTrue);
  });
}
