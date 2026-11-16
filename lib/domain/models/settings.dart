part of '../models.dart';

@immutable
/// The provider's profile and defaults (one row).
class Settings {
  /// Defaults match a fresh install.
  const Settings({
    this.name = '',
    this.role = '',
    this.city = '',
    this.email = '',
    this.phone = '',
    this.website = '',
    this.invoicePrefix = 'OM',
    this.defaultDueDays = 30,
    this.instapay = '',
    this.wallet = '',
    this.bankIban = '',
    this.notesEn = '',
    this.notesAr = '',
    this.backupDir,
    this.lastBackupAt,
    this.legalName = '',
    this.nationalIdOrRegistry = '',
    this.address = '',
    this.contractPrefix = 'CT',
    this.quotePrefix = 'QT',
    this.defaultJurisdiction = 'المحكمة الاقتصادية المختصة',
    this.defaultDocLanguage = DocLanguage.ar,
    this.docDigitStyle = DigitStyle.western,
  });

  /// Printed on invoices; `{{provider.name}}`.
  final String name;

  /// Job title under the name.
  final String role;

  /// City under the name.
  final String city;

  /// `{{provider.email}}`.
  final String email;

  /// `{{provider.phone}}`.
  final String phone;

  /// Printed in the invoice header and footer.
  final String website;

  /// Invoice numbers are `<prefix>-<year>-<seq>`.
  final String invoicePrefix;

  /// Days from issue to due date on new invoices (0–3650).
  final int defaultDueDays;

  /// InstaPay address printed under "Payment".
  final String instapay;

  /// Mobile wallet number printed under "Payment".
  final String wallet;

  /// IBAN printed under "Payment".
  final String bankIban;

  /// Default English notes of new invoices, one per line.
  final String notesEn;

  /// Default Arabic notes of new invoices, one per line.
  final String notesAr;

  /// Custom backup folder; null means `<data dir>/backups`.
  final String? backupDir;

  /// UTC epoch milliseconds.
  final int? lastBackupAt;

  /// `{{provider.legalName}}`; falls back to [name] when empty.
  final String legalName;

  /// `{{provider.id}}`.
  final String nationalIdOrRegistry;

  /// `{{provider.address}}`.
  final String address;

  /// Contract numbers are `<prefix>-<year>-<seq>`.
  final String contractPrefix;

  /// Quote numbers are `<prefix>-<year>-<seq>`.
  final String quotePrefix;

  /// Copied into each new contract's `{{jurisdiction}}`.
  final String defaultJurisdiction;

  /// The language a new document starts in when neither the document nor
  /// the client has a preference (D7).
  final DocLanguage defaultDocLanguage;

  /// How digits are printed in Arabic document text (D6). English text
  /// always uses Western digits.
  final DigitStyle docDigitStyle;

  /// Sub-item numbers in contract PDFs: `1.` instead of `١.`. The document
  /// digit style decides (schema v6).
  bool get contractWesternDigits => docDigitStyle == DigitStyle.western;

  /// A name is set; the first-run checklist uses it.
  bool get hasProfile => name.trim().isNotEmpty;

  /// A copy with the given fields replaced (null keeps the old value).
  Settings copyWith({
    String? name,
    String? role,
    String? city,
    String? email,
    String? phone,
    String? website,
    String? invoicePrefix,
    int? defaultDueDays,
    String? instapay,
    String? wallet,
    String? bankIban,
    String? notesEn,
    String? notesAr,
    String? backupDir,
    int? lastBackupAt,
    String? legalName,
    String? nationalIdOrRegistry,
    String? address,
    String? contractPrefix,
    String? quotePrefix,
    String? defaultJurisdiction,
    DocLanguage? defaultDocLanguage,
    DigitStyle? docDigitStyle,
    bool? contractWesternDigits,
  }) => Settings(
    name: name ?? this.name,
    role: role ?? this.role,
    city: city ?? this.city,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    website: website ?? this.website,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    defaultDueDays: defaultDueDays ?? this.defaultDueDays,
    instapay: instapay ?? this.instapay,
    wallet: wallet ?? this.wallet,
    bankIban: bankIban ?? this.bankIban,
    notesEn: notesEn ?? this.notesEn,
    notesAr: notesAr ?? this.notesAr,
    backupDir: backupDir ?? this.backupDir,
    lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    legalName: legalName ?? this.legalName,
    nationalIdOrRegistry: nationalIdOrRegistry ?? this.nationalIdOrRegistry,
    address: address ?? this.address,
    contractPrefix: contractPrefix ?? this.contractPrefix,
    quotePrefix: quotePrefix ?? this.quotePrefix,
    defaultJurisdiction: defaultJurisdiction ?? this.defaultJurisdiction,
    defaultDocLanguage: defaultDocLanguage ?? this.defaultDocLanguage,
    // The old per-contract switch is the document digit style now: the
    // first one given wins.
    docDigitStyle:
        docDigitStyle ??
        (contractWesternDigits == null
            ? this.docDigitStyle
            : (contractWesternDigits
                  ? DigitStyle.western
                  : DigitStyle.arabicIndic)),
  );
}
