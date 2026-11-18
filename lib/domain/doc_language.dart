/// The language a document (invoice, contract, reminder text) is written in.
///
/// Independent of the UI language: an English-speaking user can send an
/// Arabic invoice. Stored as [code] (`ar`, `en`, `bilingual`).
enum DocLanguage {
  /// Arabic only, laid out right-to-left.
  ar('ar'),

  /// English only, laid out left-to-right.
  en('en'),

  /// English layout with Arabic secondary labels: the look of every invoice
  /// made before 0.5. Contracts do not support it (ADR-0011).
  bilingual('bilingual');

  const DocLanguage(this.code);

  /// Storage and JSON value.
  final String code;

  /// [code] back to a language; anything unknown (or null) is [fallback],
  /// so a newer or damaged value never breaks rendering.
  static DocLanguage fromCode(
    String? code, {
    DocLanguage fallback = DocLanguage.ar,
  }) {
    for (final l in values) {
      if (l.code == code) return l;
    }
    return fallback;
  }

  /// The main page direction is right-to-left (only for [ar]).
  bool get isRtl => this == DocLanguage.ar;

  /// Arabic text is printed (as the only language or as the secondary one).
  bool get hasArabic => this != DocLanguage.en;

  /// English text is printed.
  bool get hasEnglish => this != DocLanguage.ar;
}

/// How digits are printed in Arabic text. English text always uses Western
/// digits. Stored as [code].
enum DigitStyle {
  /// `123`: the default for new documents (D6).
  western('western'),

  /// `١٢٣`: Arabic-Indic digits.
  arabicIndic('arabic_indic');

  const DigitStyle(this.code);

  /// Storage value.
  final String code;

  /// [code] back to a style; unknown or null is [western].
  static DigitStyle fromCode(String? code) =>
      code == arabicIndic.code ? arabicIndic : western;
}

/// How dates are printed on documents (Settings → Invoices). Stored as
/// [code].
enum DocDateFormat {
  /// `14 Sep 2026` / `14 سبتمبر 2026`: the default, and every document
  /// before schema v8.
  long('long'),

  /// `14/09/2026`, day first in every language.
  numeric('numeric');

  const DocDateFormat(this.code);

  /// Storage value.
  final String code;

  /// [code] back to a format; unknown or null is [long].
  static DocDateFormat fromCode(String? code) =>
      code == numeric.code ? numeric : long;
}

/// How a currency is written next to an amount on documents. Stored as
/// [code].
enum CurrencyDisplay {
  /// `22,000 EGP`, `$255.50`: the default, and every document before
  /// schema v8.
  code('code'),

  /// Arabic symbols in Arabic documents (`22,000 ج.م`, `ر.س`, `د.إ`; `$`
  /// and `€` as they are); English and bilingual documents use [code].
  local('local'),

  /// `$` / `€` where the currency has a symbol, else the code.
  symbol('symbol');

  const CurrencyDisplay(this.dbValue);

  /// Storage value.
  final String dbValue;

  /// [value] back to a display; unknown or null is [CurrencyDisplay.code].
  static CurrencyDisplay fromDb(String? value) =>
      CurrencyDisplay.values.where((d) => d.dbValue == value).firstOrNull ??
      CurrencyDisplay.code;
}

/// Resolves the language a new document starts in (D7): the document's own
/// choice, else the client's preference, else the global default.
DocLanguage resolveDocLanguage({
  required DocLanguage globalDefault,
  DocLanguage? document,
  DocLanguage? client,
}) => document ?? client ?? globalDefault;
