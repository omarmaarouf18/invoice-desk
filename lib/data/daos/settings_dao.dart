import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.attachedDatabase);

  Stream<Settings> watch() => (select(
    appSettings,
  )..where((s) => s.id.equals(1))).watchSingleOrNull().map(_toModel);

  Future<Settings> get() async => _toModel(
    await (select(appSettings)..where((s) => s.id.equals(1))).getSingleOrNull(),
  );

  Future<void> save(Settings s) => transaction(() async {
    await into(appSettings).insertOnConflictUpdate(
      AppSettingsCompanion.insert(
        id: const Value(1),
        name: Value(s.name),
        role: Value(s.role),
        city: Value(s.city),
        email: Value(s.email),
        phone: Value(s.phone),
        website: Value(s.website),
        invoicePrefix: Value(s.invoicePrefix),
        defaultDueDays: Value(s.defaultDueDays),
        instapay: Value(s.instapay),
        wallet: Value(s.wallet),
        bankIban: Value(s.bankIban),
        notesEn: Value(s.notesEn),
        notesAr: Value(s.notesAr),
        backupDir: Value(s.backupDir),
        lastBackupAt: Value(s.lastBackupAt),
        updatedAt: Value(clock.now().toUtc().millisecondsSinceEpoch),
        legalName: Value(s.legalName),
        nationalIdOrRegistry: Value(s.nationalIdOrRegistry),
        address: Value(s.address),
        contractPrefix: Value(s.contractPrefix),
        quotePrefix: Value(s.quotePrefix),
        defaultJurisdiction: Value(s.defaultJurisdiction),
        contractWesternDigits: Value(s.contractWesternDigits),
        defaultDocLanguage: Value(s.defaultDocLanguage.code),
        docDigitStyle: Value(s.docDigitStyle.code),
        defaultInvoiceStyleId: Value(s.defaultInvoiceStyleId),
        defaultContractStyleId: Value(s.defaultContractStyleId),
      ),
    );
  });

  Settings _toModel(SettingsRow? r) => r == null
      ? const Settings()
      : Settings(
          name: r.name,
          role: r.role,
          city: r.city,
          email: r.email,
          phone: r.phone,
          website: r.website,
          invoicePrefix: r.invoicePrefix,
          defaultDueDays: r.defaultDueDays,
          instapay: r.instapay,
          wallet: r.wallet,
          bankIban: r.bankIban,
          notesEn: r.notesEn,
          notesAr: r.notesAr,
          backupDir: r.backupDir,
          lastBackupAt: r.lastBackupAt,
          legalName: r.legalName,
          nationalIdOrRegistry: r.nationalIdOrRegistry,
          address: r.address,
          contractPrefix: r.contractPrefix,
          quotePrefix: r.quotePrefix,
          defaultJurisdiction: r.defaultJurisdiction,
          defaultDocLanguage: DocLanguage.fromCode(r.defaultDocLanguage),
          docDigitStyle: DigitStyle.fromCode(r.docDigitStyle),
          defaultInvoiceStyleId: r.defaultInvoiceStyleId,
          defaultContractStyleId: r.defaultContractStyleId,
        );
}
