// ignore_for_file: recursive_getters, drift check constraints reference their own column
import 'package:drift/drift.dart';

@DataClassName('SettingsRow')
class AppSettings extends Table with SyncRev {
  @override
  String get tableName => 'settings';

  IntColumn get id => integer().check(id.equals(1))();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get role => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get website => text().withDefault(const Constant(''))();
  TextColumn get invoicePrefix => text().withDefault(const Constant('OM'))();
  IntColumn get defaultDueDays => integer()
      .withDefault(const Constant(30))
      .check(defaultDueDays.isBetweenValues(0, 3650))();
  TextColumn get instapay => text().withDefault(const Constant(''))();
  TextColumn get wallet => text().withDefault(const Constant(''))();
  TextColumn get bankIban => text().withDefault(const Constant(''))();
  TextColumn get notesEn => text().withDefault(const Constant(''))();
  TextColumn get notesAr => text().withDefault(const Constant(''))();
  TextColumn get backupDir => text().nullable()();
  IntColumn get lastBackupAt => integer().nullable()();

  // v3: contracts.
  TextColumn get legalName => text().withDefault(const Constant(''))();
  TextColumn get nationalIdOrRegistry =>
      text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get contractPrefix => text().withDefault(const Constant('CT'))();
  TextColumn get quotePrefix => text().withDefault(const Constant('QT'))();
  TextColumn get defaultJurisdiction => text().withDefault(
    const Constant('المحكمة الاقتصادية المختصة'),
  )();

  /// Sub-item numbers in contracts: Western (1.) instead of Arabic (١.).
  BoolColumn get contractWesternDigits =>
      boolean().withDefault(const Constant(false))();

  // v6: document language.
  /// The language a new document starts in (D7): `ar`, `en` or `bilingual`.
  TextColumn get defaultDocLanguage => text().withDefault(
    const Constant('ar'),
  )();

  /// How digits are printed in Arabic document text (D6): `western` or
  /// `arabic_indic`. It takes over `contractWesternDigits`.
  TextColumn get docDigitStyle => text().withDefault(
    const Constant('western'),
  )();

  // v7: document styles (default invoice and contract style IDs).
  TextColumn get defaultInvoiceStyleId => text().nullable()();
  TextColumn get defaultContractStyleId => text().nullable()();

  // v4: sync.
  /// Random UUID of this installation, generated once.
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('ClientRow')
class Clients extends Table with SyncRev {
  TextColumn get id => text()();
  TextColumn get name =>
      text().check(name.trim().length.isBiggerThanValue(0))();
  TextColumn get contact => text().withDefault(const Constant(''))();
  TextColumn get city => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  /// Soft delete (schema v2). Purged after 30 days once no invoice rows
  /// reference the client. See `triggers.drift` for the guards.
  IntColumn get deletedAt => integer().nullable()();

  // v3: legal details used in contracts.
  TextColumn get legalName => text().withDefault(const Constant(''))();
  TextColumn get registryNo => text().withDefault(const Constant(''))();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get representative => text().withDefault(const Constant(''))();
  TextColumn get representativeTitle =>
      text().withDefault(const Constant(''))();

  /// v5: demo row (removed with the demo set; cleared on user edits).
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  /// v6: the language their documents are written in; null means "follow
  /// the global default" (D7).
  TextColumn get preferredLanguage => text().nullable()();

  /// v7: preferred document style ID; null means follow resolution (D7).
  TextColumn get styleId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('InvoiceRow')
@TableIndex(name: 'invoices_client', columns: {#clientId})
@TableIndex(name: 'invoices_due', columns: {#dueDate})
@TableIndex(name: 'invoices_paid', columns: {#paidDate})
class Invoices extends Table with SyncRev {
  TextColumn get id => text()();
  TextColumn get clientId =>
      text().references(Clients, #id, onDelete: KeyAction.restrict)();
  TextColumn get number => text().unique()();
  IntColumn get year => integer()();
  IntColumn get seq => integer().check(seq.isBiggerOrEqualValue(0))();
  TextColumn get issueDate => text()();
  TextColumn get dueDate => text()();
  TextColumn get paidDate => text().nullable()();
  TextColumn get status =>
      text().check(status.isIn(const ['draft', 'sent', 'paid', 'void']))();
  TextColumn get contractRef => text().withDefault(const Constant(''))();
  BoolColumn get vatOn => boolean().withDefault(const Constant(false))();
  IntColumn get vatRateBp => integer()
      .withDefault(const Constant(1400))
      .check(vatRateBp.isBetweenValues(0, 10000))();
  TextColumn get notesEn => text().withDefault(const Constant(''))();
  TextColumn get notesAr => text().withDefault(const Constant(''))();
  BoolColumn get scopeOn => boolean().withDefault(const Constant(false))();
  TextColumn get scopeTitle => text().withDefault(const Constant(''))();
  TextColumn get scopeOverview => text().withDefault(const Constant(''))();
  TextColumn get scopeDone => text().withDefault(const Constant(''))();
  TextColumn get scopeDelivered => text().withDefault(const Constant(''))();
  TextColumn get scopeWarranty => text().withDefault(const Constant(''))();
  IntColumn get deletedAt => integer().nullable()();

  /// v6: the language the document is written in: `ar`, `en` or
  /// `bilingual`. Existing invoices get `bilingual`, so they keep their
  /// look (ADR-0011).
  TextColumn get language => text().withDefault(const Constant('bilingual'))();

  /// v7: document style ID (preset or custom style); null means follow resolution.
  TextColumn get styleId => text().nullable()();

  /// v7: immutable style JSON snapshot taken when sent or paid (D3, ADR-0012).
  TextColumn get styleSnapshot => text().nullable()();

  /// v5: demo row (removed with the demo set; cleared on user edits).
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {year, seq},
  ];

  @override
  bool get isStrict => true;
}

@DataClassName('SectionRow')
@TableIndex(name: 'sections_invoice', columns: {#invoiceId})
class Sections extends Table with SyncRev, ChildSync {
  TextColumn get id => text()();
  TextColumn get invoiceId =>
      text().references(Invoices, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get titleEn => text().withDefault(const Constant(''))();
  TextColumn get titleAr => text().withDefault(const Constant(''))();
  TextColumn get currency =>
      text().check(currency.isIn(const ['EGP', 'USD', 'SAR', 'AED', 'EUR']))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('ItemRow')
@TableIndex(name: 'items_section', columns: {#sectionId})
class Items extends Table with SyncRev, ChildSync {
  TextColumn get id => text()();
  TextColumn get sectionId =>
      text().references(Sections, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get service => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get cycle =>
      text().check(cycle.isIn(const ['one-time', 'monthly', 'annual']))();
  IntColumn get qty => integer().check(qty.isBiggerOrEqualValue(0))();
  IntColumn get unitPriceMinor =>
      integer().check(unitPriceMinor.isBiggerOrEqualValue(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

// ── v3: contracts ──────────────────────────────────────────────────────

/// A library template: an ordered set of clauses plus the preamble, the
/// closing line and default values for its custom variables.
@DataClassName('TemplateRow')
class ClauseTemplates extends Table with SyncRev {
  TextColumn get id => text()();
  TextColumn get name =>
      text().check(name.trim().length.isBiggerThanValue(0))();
  TextColumn get kind => text().check(kind.isIn(const ['contract', 'quote']))();
  IntColumn get position => integer()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  TextColumn get preamble => text().withDefault(const Constant(''))();
  TextColumn get closing => text().withDefault(const Constant(''))();

  /// JSON object of variable name → default value.
  TextColumn get varDefaults => text().withDefault(const Constant('{}'))();

  /// v4: tombstone instead of a hard delete.
  IntColumn get deletedAt => integer().nullable()();

  /// v5: demo row (removed with the demo set; cleared on user edits).
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('LibraryClauseRow')
@TableIndex(name: 'library_clauses_template', columns: {#templateId})
class LibraryClauses extends Table with SyncRev, ChildSync {
  TextColumn get id => text()();
  TextColumn get templateId =>
      text().references(ClauseTemplates, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  BoolColumn get optional => boolean().withDefault(const Constant(false))();
  BoolColumn get enabledByDefault =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('ContractRow')
@TableIndex(name: 'contracts_client', columns: {#clientId})
@TableIndex(name: 'contracts_parent', columns: {#parentId})
class Contracts extends Table with SyncRev {
  TextColumn get id => text()();
  TextColumn get clientId =>
      text().references(Clients, #id, onDelete: KeyAction.restrict)();
  TextColumn get number => text().unique()();

  /// Numbering series: `contract` (CT-…) or `quote` (QT-…). Amendments use
  /// their original's series, year and seq plus [amendmentNo].
  TextColumn get series =>
      text().check(series.isIn(const ['contract', 'quote']))();
  IntColumn get year => integer()();
  IntColumn get seq => integer().check(seq.isBiggerOrEqualValue(0))();
  IntColumn get amendmentNo => integer()
      .withDefault(const Constant(0))
      .check(amendmentNo.isBiggerOrEqualValue(0))();

  /// The original contract of an amendment.
  TextColumn get parentId => text().nullable().references(
    Contracts,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get kind =>
      text().check(kind.isIn(const ['contract', 'quote', 'amendment']))();
  TextColumn get templateName => text().withDefault(const Constant(''))();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get projectName => text().withDefault(const Constant(''))();
  TextColumn get projectSummary => text().withDefault(const Constant(''))();
  TextColumn get preamble => text().withDefault(const Constant(''))();
  TextColumn get closing => text().withDefault(const Constant(''))();
  TextColumn get issueDate => text()();
  TextColumn get startDate => text().nullable()();
  TextColumn get signedDate => text().nullable()();
  TextColumn get endDate => text().nullable()();
  TextColumn get status => text().check(
    status.isIn(const [
      'draft',
      'sent',
      'signed',
      'active',
      'completed',
      'cancelled',
    ]),
  )();
  TextColumn get jurisdiction => text().withDefault(const Constant(''))();
  TextColumn get currency =>
      text().check(currency.isIn(const ['EGP', 'USD', 'SAR', 'AED', 'EUR']))();
  IntColumn get totalMinor => integer()
      .withDefault(const Constant(0))
      .check(totalMinor.isBiggerOrEqualValue(0))();

  /// JSON object of custom variable name → value.
  TextColumn get vars => text().withDefault(const Constant('{}'))();

  /// One out-of-scope entry per line.
  TextColumn get outOfScope => text().withDefault(const Constant(''))();

  /// Signed contracts are read-only unless explicitly unlocked.
  BoolColumn get unlocked => boolean().withDefault(const Constant(false))();

  /// JSON list of `{at, event}` entries (unlocks, status changes).
  TextColumn get history => text().withDefault(const Constant('[]'))();
  IntColumn get deletedAt => integer().nullable()();

  /// v7: document style ID (preset or custom style); null means follow resolution.
  TextColumn get styleId => text().nullable()();

  /// v7: immutable style JSON snapshot taken when signed (D3, ADR-0012).
  TextColumn get styleSnapshot => text().nullable()();

  /// v5: demo row (removed with the demo set; cleared on user edits).
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {series, year, seq, amendmentNo},
  ];

  @override
  bool get isStrict => true;
}

@DataClassName('ContractClauseRow')
@TableIndex(name: 'contract_clauses_contract', columns: {#contractId})
class ContractClauses extends Table with SyncRev, ChildSync {
  TextColumn get id => text()();
  TextColumn get contractId =>
      text().references(Contracts, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get body => text().withDefault(const Constant(''))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get optional => boolean().withDefault(const Constant(false))();

  /// Not a foreign key: the library may change or lose the clause, the
  /// contract keeps its snapshot.
  TextColumn get fromLibraryClauseId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('ScopeItemRow')
@TableIndex(name: 'scope_items_contract', columns: {#contractId})
class ScopeItems extends Table with SyncRev, ChildSync {
  TextColumn get id => text()();
  TextColumn get contractId =>
      text().references(Contracts, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get phase => text().withDefault(const Constant(''))();
  TextColumn get item => text().withDefault(const Constant(''))();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get acceptance => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('MilestoneRow')
@TableIndex(name: 'milestones_contract', columns: {#contractId})
@TableIndex(name: 'milestones_invoice', columns: {#invoiceId})
@TableIndex(name: 'milestones_due', columns: {#dueDate})
class PaymentMilestones extends Table with SyncRev, ChildSync {
  TextColumn get id => text()();
  TextColumn get contractId =>
      text().references(Contracts, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get label => text().withDefault(const Constant(''))();
  IntColumn get percentBp => integer().nullable().check(
    percentBp.isBetweenValues(0, 10000),
  )();
  IntColumn get amountMinor =>
      integer().nullable().check(amountMinor.isBiggerOrEqualValue(0))();
  TextColumn get trigger => text().withDefault(const Constant(''))();
  TextColumn get dueDate => text().nullable()();
  TextColumn get invoiceId => text().nullable().references(
    Invoices,
    #id,
    onDelete: KeyAction.setNull,
  )();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

// ── v5: calendar ───────────────────────────────────────────────────────
// The calendar's own tables live in `tables_calendar.dart`.
// ── v4: sync-ready rows ────────────────────────────────────────────────

/// Every syncable table: a revision that triggers bump on each insert and
/// update (see sync_triggers.drift), in the same transaction as the write.
mixin SyncRev on Table {
  IntColumn get rev => integer().withDefault(const Constant(0))();
}

/// Child rows (sections, items, clauses, …) that used to be replaced
/// wholesale: since v4 they are upserted and tombstoned, so a future sync
/// engine sees every change and every deletion.
mixin ChildSync on Table {
  /// UTC epoch ms of the last write; 0 for rows from before v4 until the
  /// migration backfills it.
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  /// Tombstone: hidden everywhere, purged after 30 days.
  IntColumn get deletedAt => integer().nullable()();
}

/// What a future sync engine pushes: one row per changed entity row, kept
/// at its latest revision. Written by triggers in the same transaction as
/// the change.
@DataClassName('OutboxRow')
class Outbox extends Table {
  @override
  String get tableName => 'outbox';

  IntColumn get id => integer().autoIncrement()();

  /// Table name of the changed row.
  TextColumn get entity => text()();

  /// The changed row's id (settings: `1`).
  TextColumn get rowId => text()();

  /// The row's revision after the change.
  IntColumn get rev => integer()();

  /// The row's `updated_at` (UTC epoch ms) at the change.
  IntColumn get changedAt => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {entity, rowId},
  ];

  @override
  bool get isStrict => true;
}
