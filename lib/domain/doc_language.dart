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

/// Resolves the language a new document starts in (D7): the document's own
/// choice, else the client's preference, else the global default.
DocLanguage resolveDocLanguage({
  required DocLanguage globalDefault,
  DocLanguage? document,
  DocLanguage? client,
}) => document ?? client ?? globalDefault;
