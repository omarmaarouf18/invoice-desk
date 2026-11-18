// ignore_for_file: recursive_getters, drift check constraints reference their own column
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/tables.dart';

/// The provider's profile and defaults: one row, id 1 (split out of
/// tables.dart to keep files under 500 lines).
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

  // v8: settings redesign (SET-01). Defaults keep the behaviour of v7.
  /// New invoice numbers: `{PREFIX}`, `{YYYY}`, `{YY}`, `{SEQ}`/`{SEQ:n}`.
  TextColumn get invoiceNumberPattern =>
      text().withDefault(const Constant('{PREFIX}-{YYYY}-{SEQ:4}'))();
  BoolColumn get numberYearlyReset =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get defaultVatOn => boolean().withDefault(const Constant(false))();

  /// Basis points (1400 = 14 %).
  IntColumn get defaultVatRateBp => integer()
      .withDefault(const Constant(1400))
      .check(defaultVatRateBp.isBetweenValues(0, 10000))();
  TextColumn get taxRegistrationNo => text().withDefault(const Constant(''))();

  /// `long` (14 Sep 2026) or `numeric` (14/09/2026).
  TextColumn get dateFormat => text()
      .withDefault(const Constant('long'))
      .check(dateFormat.isIn(const ['long', 'numeric']))();

  /// ISO code of a new invoice's first section.
  TextColumn get defaultCurrency => text()
      .withDefault(const Constant('EGP'))
      .check(defaultCurrency.isIn(const ['EGP', 'USD', 'SAR', 'AED', 'EUR']))();

  /// `code`, `local` or `symbol`.
  TextColumn get currencyDisplay => text()
      .withDefault(const Constant('code'))
      .check(currencyDisplay.isIn(const ['code', 'local', 'symbol']))();

  // v4: sync.
  /// Random UUID of this installation, generated once.
  TextColumn get deviceId => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}
