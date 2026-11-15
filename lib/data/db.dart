import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:invoice_desk/data/daos/clients_dao.dart';
import 'package:invoice_desk/data/daos/contracts_dao.dart';
import 'package:invoice_desk/data/daos/invoices_dao.dart';
import 'package:invoice_desk/data/daos/library_dao.dart';
import 'package:invoice_desk/data/daos/settings_dao.dart';
import 'package:invoice_desk/data/db.steps.dart';
import 'package:invoice_desk/data/seed.dart';
import 'package:invoice_desk/data/tables.dart';

part 'db.g.dart';

@DriftDatabase(
  tables: [
    AppSettings,
    Clients,
    Invoices,
    Sections,
    Items,
    ClauseTemplates,
    LibraryClauses,
    Contracts,
    ContractClauses,
    ScopeItems,
    PaymentMilestones,
  ],
  daos: [SettingsDao, ClientsDao, InvoicesDao, LibraryDao, ContractsDao],
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

  static const currentSchemaVersion = 3;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await libraryDao.seedIfEmpty();
    },
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

  OnUpgrade get _upgrade => stepByStep(
    // v2: client soft delete + guards against orphaned live invoices.
    from1To2: (m, schema) async {
      await m.addColumn(schema.clients, schema.clients.deletedAt);
      await m.create(schema.clientsSoftDeleteGuard);
      await m.create(schema.invoicesReviveGuard);
      await m.create(schema.invoicesInsertGuard);
    },
    // v3: contracts, the clause library, legal fields on clients and
    // settings. The client delete guard now counts contracts too.
    from2To3: (m, schema) async {
      final c = schema.clients;
      for (final col in [
        c.legalName,
        c.registryNo,
        c.address,
        c.representative,
        c.representativeTitle,
      ]) {
        await m.addColumn(c, col);
      }
      final s = schema.settings;
      for (final col in [
        s.legalName,
        s.nationalIdOrRegistry,
        s.address,
        s.contractPrefix,
        s.quotePrefix,
        s.defaultJurisdiction,
        s.contractWesternDigits,
      ]) {
        await m.addColumn(s, col);
      }
      await m.create(schema.clauseTemplates);
      await m.create(schema.libraryClauses);
      await m.create(schema.contracts);
      await m.create(schema.contractClauses);
      await m.create(schema.scopeItems);
      await m.create(schema.paymentMilestones);
      for (final i in [
        schema.libraryClausesTemplate,
        schema.contractsClient,
        schema.contractsParent,
        schema.contractClausesContract,
        schema.scopeItemsContract,
        schema.milestonesContract,
        schema.milestonesInvoice,
      ]) {
        await m.create(i);
      }
      await m.drop(schema.clientsSoftDeleteGuard);
      await m.create(schema.clientsSoftDeleteGuard);
      await m.create(schema.contractsReviveGuard);
      await m.create(schema.contractsInsertGuard);
      await libraryDao.seedIfEmpty();
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
