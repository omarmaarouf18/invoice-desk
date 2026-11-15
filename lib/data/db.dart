import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:invoice_desk/data/daos/clients_dao.dart';
import 'package:invoice_desk/data/daos/invoices_dao.dart';
import 'package:invoice_desk/data/daos/settings_dao.dart';
import 'package:invoice_desk/data/db.steps.dart';
import 'package:invoice_desk/data/seed.dart';
import 'package:invoice_desk/data/tables.dart';

part 'db.g.dart';

@DriftDatabase(
  tables: [AppSettings, Clients, Invoices, Sections, Items],
  daos: [SettingsDao, ClientsDao, InvoicesDao],
  include: {'triggers.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {this.seedOnCreate = true});

  /// In-memory database for tests. FKs on, no seed unless asked.
  factory AppDatabase.memory({bool seed = false}) => AppDatabase(
    NativeDatabase.memory(setup: _setupPragmas),
    seedOnCreate: seed,
  );

  /// Opens (or creates) the database file at [file].
  factory AppDatabase.file(File file, {bool seed = true}) => AppDatabase(
    NativeDatabase.createInBackground(file, setup: _setupPragmas),
    seedOnCreate: seed,
  );

  final bool seedOnCreate;

  static const currentSchemaVersion = 2;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      await _upgrade(m, from, to);
      final broken = await customSelect('PRAGMA foreign_key_check').get();
      if (broken.isNotEmpty) {
        throw StateError('Migration left ${broken.length} broken FK rows');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated && seedOnCreate) {
        await seedDatabase(this);
      }
    },
  );

  static final OnUpgrade _upgrade = stepByStep(
    // v2: client soft delete + guards against orphaned live invoices.
    from1To2: (m, schema) async {
      await m.addColumn(schema.clients, schema.clients.deletedAt);
      await m.create(schema.clientsSoftDeleteGuard);
      await m.create(schema.invoicesReviveGuard);
      await m.create(schema.invoicesInsertGuard);
    },
  );

  /// All tables, for stream invalidation after raw SQL (restore).
  void markAllUpdated() => markTablesUpdated(allTables);
}

void _setupPragmas(dynamic raw) {
  // ignore: avoid_dynamic_calls, sqlite3 Database from drift's setup hook
  raw
    ..execute('PRAGMA journal_mode = WAL;')
    ..execute('PRAGMA synchronous = FULL;')
    ..execute('PRAGMA foreign_keys = ON;')
    ..execute('PRAGMA busy_timeout = 5000;');
}
