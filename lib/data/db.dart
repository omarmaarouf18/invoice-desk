import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:invoice_desk/data/daos/calendar_dao.dart';
import 'package:invoice_desk/data/daos/clients_dao.dart';
import 'package:invoice_desk/data/daos/contracts_dao.dart';
import 'package:invoice_desk/data/daos/invoices_dao.dart';
import 'package:invoice_desk/data/daos/library_dao.dart';
import 'package:invoice_desk/data/daos/settings_dao.dart';
import 'package:invoice_desk/data/db.steps.dart';
import 'package:invoice_desk/data/seed.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/data/tables_calendar.dart';
import 'package:invoice_desk/data/tables_styles.dart';
import 'package:uuid/uuid.dart';

part 'db.g.dart';

/// Fills a just-created database (fresh install, tests).
typedef Seeder = Future<void> Function(AppDatabase db);

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
    Outbox,
    Postponements,
    Reminders,
    DocumentAssets,
    DocumentStyles,
  ],
  daos: [
    SettingsDao,
    ClientsDao,
    InvoicesDao,
    LibraryDao,
    ContractsDao,
    CalendarDao,
  ],
  include: {'triggers.drift', 'sync_triggers.drift'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {this.seedOnCreate = true, Seeder? seeder})
    : seeder = seeder ?? seedDatabase;

  /// In-memory database for tests. FKs on, no seed unless asked: [seed]
  /// runs the fresh-install seed (profile + demo set), [seeder] a custom
  /// one.
  factory AppDatabase.memory({bool seed = false, Seeder? seeder}) =>
      AppDatabase(
        NativeDatabase.memory(setup: _setupPragmas),
        seedOnCreate: seed || seeder != null,
        seeder: seeder,
      );

  /// Opens (or creates) the database file at [file].
  factory AppDatabase.file(File file, {bool seed = true}) => AppDatabase(
    NativeDatabase.createInBackground(file, setup: _setupPragmas),
    seedOnCreate: seed,
  );

  final bool seedOnCreate;

  /// What [seedOnCreate] runs.
  final Seeder seeder;

  static const currentSchemaVersion = 7;

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
      // v3 added the clause library; seed it once all steps have run.
      if (from < 3) await libraryDao.seedIfEmpty();
      final broken = await customSelect('PRAGMA foreign_key_check').get();
      if (broken.isNotEmpty) {
        throw StateError('Migration left ${broken.length} broken FK rows');
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated && seedOnCreate) {
        await seeder(this);
      }
      await ensureDeviceId();
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
      // The library is seeded after the last step (see onUpgrade): the
      // seeding code writes the current schema's columns.
    },
    // v4: sync-ready rows (rev, child tombstones, device id, outbox).
    from3To4: (m, schema) async {
      await m.create(schema.outbox);
      final withRev = [
        (schema.settings, schema.settings.rev),
        (schema.clients, schema.clients.rev),
        (schema.invoices, schema.invoices.rev),
        (schema.sections, schema.sections.rev),
        (schema.items, schema.items.rev),
        (schema.clauseTemplates, schema.clauseTemplates.rev),
        (schema.libraryClauses, schema.libraryClauses.rev),
        (schema.contracts, schema.contracts.rev),
        (schema.contractClauses, schema.contractClauses.rev),
        (schema.scopeItems, schema.scopeItems.rev),
        (schema.paymentMilestones, schema.paymentMilestones.rev),
      ];
      for (final (t, c) in withRev) {
        await m.addColumn(t, c);
      }
      await m.addColumn(schema.settings, schema.settings.deviceId);
      await m.addColumn(schema.settings, schema.settings.updatedAt);
      await m.addColumn(
        schema.clauseTemplates,
        schema.clauseTemplates.deletedAt,
      );
      final children = [
        (schema.sections, schema.sections.updatedAt, schema.sections.deletedAt),
        (schema.items, schema.items.updatedAt, schema.items.deletedAt),
        (
          schema.libraryClauses,
          schema.libraryClauses.updatedAt,
          schema.libraryClauses.deletedAt,
        ),
        (
          schema.contractClauses,
          schema.contractClauses.updatedAt,
          schema.contractClauses.deletedAt,
        ),
        (
          schema.scopeItems,
          schema.scopeItems.updatedAt,
          schema.scopeItems.deletedAt,
        ),
        (
          schema.paymentMilestones,
          schema.paymentMilestones.updatedAt,
          schema.paymentMilestones.deletedAt,
        ),
      ];
      for (final (t, u, d) in children) {
        await m.addColumn(t, u);
        await m.addColumn(t, d);
      }
      // Backfill before the triggers exist: every existing row is revision
      // 1 and has one outbox entry, so a first sync pushes everything.
      final now = clock.now().toUtc().millisecondsSinceEpoch;
      for (final t in [
        'settings',
        'sections',
        'items',
        'library_clauses',
        'contract_clauses',
        'scope_items',
        'payment_milestones',
      ]) {
        await customStatement('UPDATE $t SET updated_at = ?', [now]);
      }
      for (final (t, _) in withRev) {
        final name = t.actualTableName;
        final id = name == 'settings' ? 'CAST(id AS TEXT)' : 'id';
        await customStatement('UPDATE $name SET rev = 1');
        await customStatement(
          'INSERT INTO outbox (entity, row_id, rev, changed_at) '
          "SELECT '$name', $id, 1, updated_at FROM $name",
        );
      }
      for (final trigger in [
        schema.settingsSyncInsert,
        schema.settingsSyncUpdate,
        schema.clientsSyncInsert,
        schema.clientsSyncUpdate,
        schema.invoicesSyncInsert,
        schema.invoicesSyncUpdate,
        schema.sectionsSyncInsert,
        schema.sectionsSyncUpdate,
        schema.itemsSyncInsert,
        schema.itemsSyncUpdate,
        schema.clauseTemplatesSyncInsert,
        schema.clauseTemplatesSyncUpdate,
        schema.libraryClausesSyncInsert,
        schema.libraryClausesSyncUpdate,
        schema.contractsSyncInsert,
        schema.contractsSyncUpdate,
        schema.contractClausesSyncInsert,
        schema.contractClausesSyncUpdate,
        schema.scopeItemsSyncInsert,
        schema.scopeItemsSyncUpdate,
        schema.paymentMilestonesSyncInsert,
        schema.paymentMilestonesSyncUpdate,
      ]) {
        await m.create(trigger);
      }
    },
    // v5: the calendar. Demo flags, the postponement history and manual
    // reminders (both sync-ready), and indexes for date-range queries.
    // Existing rows are real data: is_demo defaults to 0.
    from4To5: (m, schema) async {
      await m.addColumn(schema.clients, schema.clients.isDemo);
      await m.addColumn(schema.invoices, schema.invoices.isDemo);
      await m.addColumn(schema.contracts, schema.contracts.isDemo);
      await m.addColumn(
        schema.clauseTemplates,
        schema.clauseTemplates.isDemo,
      );
      await m.create(schema.postponements);
      await m.create(schema.reminders);
      for (final i in [
        schema.invoicesDue,
        schema.invoicesPaid,
        schema.milestonesDue,
        schema.postponementsEntity,
        schema.remindersDate,
      ]) {
        await m.create(i);
      }
      for (final t in [
        schema.postponementsSyncInsert,
        schema.postponementsSyncUpdate,
        schema.remindersSyncInsert,
        schema.remindersSyncUpdate,
      ]) {
        await m.create(t);
      }
    },
    // v6: the document language. Every invoice gets `bilingual`, so the
    // invoices that exist keep the look they have today; new ones get the
    // language they are created in (D7).
    from5To6: (m, schema) async {
      await m.addColumn(schema.invoices, schema.invoices.language);
      await m.addColumn(schema.clients, schema.clients.preferredLanguage);
      await m.addColumn(schema.settings, schema.settings.defaultDocLanguage);
      await m.addColumn(schema.settings, schema.settings.docDigitStyle);
      // The per-contract digit switch becomes the document digit style, so
      // the contracts that exist keep their digits.
      await customStatement(
        'UPDATE settings SET doc_digit_style = ? WHERE contract_western_digits = ?',
        ['arabic_indic', 0],
      );
    },
    // v7: document assets (logos) and custom document styles (ADR-0012).
    // Existing documents retain null style_id (resolving to default / Classic).
    from6To7: (m, schema) async {
      await m.create(schema.documentAssets);
      await m.create(schema.documentStyles);
      await m.addColumn(schema.invoices, schema.invoices.styleId);
      await m.addColumn(schema.invoices, schema.invoices.styleSnapshot);
      await m.addColumn(schema.contracts, schema.contracts.styleId);
      await m.addColumn(schema.contracts, schema.contracts.styleSnapshot);
      await m.addColumn(schema.clients, schema.clients.styleId);
      await m.addColumn(schema.settings, schema.settings.defaultInvoiceStyleId);
      await m.addColumn(
        schema.settings,
        schema.settings.defaultContractStyleId,
      );
      for (final t in [
        schema.documentAssetsSyncInsert,
        schema.documentAssetsSyncUpdate,
        schema.documentStylesSyncInsert,
        schema.documentStylesSyncUpdate,
      ]) {
        await m.create(t);
      }
    },
  );

  /// v4: a random device id, generated once (fresh install or upgrade),
  /// kept across restores.
  Future<void> ensureDeviceId() => transaction(() async {
    final row = await customSelect(
      'SELECT device_id FROM settings WHERE id = 1',
    ).getSingleOrNull();
    if (row != null && row.read<String>('device_id').isNotEmpty) return;
    final id = const Uuid().v4();
    final now = clock.now().toUtc().millisecondsSinceEpoch;
    if (row == null) {
      await customStatement(
        'INSERT INTO settings (id, device_id, updated_at) VALUES (1, ?, ?)',
        [id, now],
      );
    } else {
      await customStatement(
        'UPDATE settings SET device_id = ?, updated_at = ? WHERE id = 1',
        [id, now],
      );
    }
  });

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
