// ignore_for_file: recursive_getters, drift check constraints reference their own column
import 'package:drift/drift.dart';

@DataClassName('SettingsRow')
class AppSettings extends Table {
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

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('ClientRow')
class Clients extends Table {
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

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('InvoiceRow')
@TableIndex(name: 'invoices_client', columns: {#clientId})
class Invoices extends Table {
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
class Sections extends Table {
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
class Items extends Table {
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
class ClauseTemplates extends Table {
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
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

@DataClassName('LibraryClauseRow')
@TableIndex(name: 'library_clauses_template', columns: {#templateId})
class LibraryClauses extends Table {
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
class Contracts extends Table {
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
class ContractClauses extends Table {
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
class ScopeItems extends Table {
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
class PaymentMilestones extends Table {
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
