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
