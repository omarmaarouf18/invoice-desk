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
    this.defaultInvoiceStyleId,
    this.defaultContractStyleId,
    this.invoiceNumberPattern = defaultNumberPattern,
    this.numberYearlyReset = true,
    this.defaultVatOn = false,
    this.defaultVatRateBp = 1400,
    this.taxRegistrationNo = '',
    this.dateFormat = DocDateFormat.long,
    this.defaultCurrency = Currency.egp,
    this.currencyDisplay = CurrencyDisplay.code,
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

  /// Default style ID for new invoices; null means classic preset.
  final String? defaultInvoiceStyleId;

  /// Default style ID for new contracts; null means classic preset.
  final String? defaultContractStyleId;

  /// The invoice-number pattern every install starts with (schema v8):
  /// `OM-2026-0001`.
  static const defaultNumberPattern = '{PREFIX}-{YYYY}-{SEQ:4}';

  /// How new invoice numbers are built from tokens: `{PREFIX}`, `{YYYY}`,
  /// `{YY}` and `{SEQ}` / `{SEQ:n}` (zero-padded to n digits). Existing
  /// numbers are never rewritten.
  final String invoiceNumberPattern;

  /// The sequence starts again at 1 each year. Off, it keeps counting
  /// across years.
  final bool numberYearlyReset;

  /// New invoices start with VAT on.
  final bool defaultVatOn;

  /// The VAT rate new invoices start with, in basis points (1400 = 14 %).
  final int defaultVatRateBp;

  /// Tax registration number, printed with the provider block when set.
  final String taxRegistrationNo;

  /// How documents print dates.
  final DocDateFormat dateFormat;

  /// The currency of a new invoice's first section.
  final Currency defaultCurrency;

  /// How documents write currencies next to amounts.
  final CurrencyDisplay currencyDisplay;

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
    String? Function()? defaultInvoiceStyleId,
    String? Function()? defaultContractStyleId,
    String? invoiceNumberPattern,
    bool? numberYearlyReset,
    bool? defaultVatOn,
    int? defaultVatRateBp,
    String? taxRegistrationNo,
    DocDateFormat? dateFormat,
    Currency? defaultCurrency,
    CurrencyDisplay? currencyDisplay,
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
    defaultInvoiceStyleId: defaultInvoiceStyleId != null
        ? defaultInvoiceStyleId()
        : this.defaultInvoiceStyleId,
    defaultContractStyleId: defaultContractStyleId != null
        ? defaultContractStyleId()
        : this.defaultContractStyleId,
    invoiceNumberPattern: invoiceNumberPattern ?? this.invoiceNumberPattern,
    numberYearlyReset: numberYearlyReset ?? this.numberYearlyReset,
    defaultVatOn: defaultVatOn ?? this.defaultVatOn,
    defaultVatRateBp: defaultVatRateBp ?? this.defaultVatRateBp,
    taxRegistrationNo: taxRegistrationNo ?? this.taxRegistrationNo,
    dateFormat: dateFormat ?? this.dateFormat,
    defaultCurrency: defaultCurrency ?? this.defaultCurrency,
    currencyDisplay: currencyDisplay ?? this.currencyDisplay,
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
