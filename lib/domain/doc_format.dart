import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_language.dart';

// Text that is printed on documents, per document language. UI strings live
// in the ARB files instead: the document language is independent of the UI
// language (ADR-0011).

// ── Digits ────────────────────────────────────────────────────────────────

/// `12` → `١٢`; everything that is not a Western digit is kept.
String arabicIndicDigits(String s) => s.replaceAllMapped(
  RegExp('[0-9]'),
  (m) => String.fromCharCode(0x0660 + int.parse(m.group(0)!)),
);

/// [s] with its digits in [style]. Western leaves it unchanged.
String applyDigitStyle(String s, DigitStyle style) =>
    style == DigitStyle.arabicIndic ? arabicIndicDigits(s) : s;

// ── Dates ─────────────────────────────────────────────────────────────────

/// Full English month names, `January` … `December`.
const englishMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// The date as printed on a document: `14 سبتمبر 2026` for [DocLanguage.ar]
/// (digits per [digits]); `14 Sep 2026` for English and bilingual, which
/// always use Western digits.
String formatDocDate(
  CalendarDate d,
  DocLanguage lang, {
  DigitStyle digits = DigitStyle.western,
}) => lang == DocLanguage.ar
    ? applyDigitStyle(formatArabicDate(d), digits)
    : formatInvoiceDate(d);

/// Day and month only: `14 سبتمبر` / `14 Sep`.
String formatDocDayMonth(
  CalendarDate d,
  DocLanguage lang, {
  DigitStyle digits = DigitStyle.western,
}) => lang == DocLanguage.ar
    ? applyDigitStyle(formatArabicDayMonth(d), digits)
    : formatInvoiceDate(d).substring(0, formatInvoiceDate(d).lastIndexOf(' '));

/// Month and year: `نوفمبر 2026` / `November 2026`.
String formatDocMonthYear(
  CalendarDate d,
  DocLanguage lang, {
  DigitStyle digits = DigitStyle.western,
}) => lang == DocLanguage.ar
    ? applyDigitStyle(formatArabicMonthYear(d), digits)
    : '${englishMonthNames[d.month - 1]} ${d.year}';

// ── Ordinals and headings ─────────────────────────────────────────────────

const _units = [
  'الأول',
  'الثاني',
  'الثالث',
  'الرابع',
  'الخامس',
  'السادس',
  'السابع',
  'الثامن',
  'التاسع',
];

/// `الأول` … `الثلاثون` for clause headings; digits beyond 30 and below 1.
String arabicOrdinal(int n) {
  if (n < 1) return '$n';
  if (n <= 9) return _units[n - 1];
  if (n == 10) return 'العاشر';
  if (n == 11) return 'الحادي عشر';
  if (n < 20) return '${_units[n - 11]} عشر';
  if (n == 20) return 'العشرون';
  if (n == 30) return 'الثلاثون';
  if (n < 30) {
    final unit = n - 20 == 1 ? 'الحادي' : _units[n - 21];
    return '$unit والعشرون';
  }
  return '$n';
}

/// The heading of clause [n] (from 1): `البند الأول` in Arabic,
/// `Article 1` otherwise. Contracts are never bilingual (D2); bilingual
/// falls back to English.
String clauseHeading(int n, DocLanguage lang) =>
    lang == DocLanguage.ar ? 'البند ${arabicOrdinal(n)}' : 'Article $n';

/// [clauseHeading] followed by the clause [title] when it has one:
/// `البند الأول: موضوع العقد`, `Article 1: Subject`.
String clauseHeadingWithTitle(int n, String title, DocLanguage lang) {
  final head = clauseHeading(n, lang);
  final t = title.trim();
  return t.isEmpty ? head : '$head: $t';
}

/// Sub-item label inside a clause: `١.` or `1.`.
String subItemLabel(int n, {required bool western}) =>
    western ? '$n.' : '${arabicIndicDigits('$n')}.';

// ── Currencies ────────────────────────────────────────────────────────────

/// The currency's name as written out in a document: `جنيه مصري`,
/// `Egyptian pounds`. Used for `{{currency}}` and `{{total}}`.
String currencyName(Currency c, DocLanguage lang) => lang == DocLanguage.ar
    ? switch (c) {
        Currency.egp => 'جنيه مصري',
        Currency.usd => 'دولار أمريكي',
        Currency.sar => 'ريال سعودي',
        Currency.aed => 'درهم إماراتي',
        Currency.eur => 'يورو',
      }
    : switch (c) {
        Currency.egp => 'Egyptian pounds',
        Currency.usd => 'US dollars',
        Currency.sar => 'Saudi riyals',
        Currency.aed => 'UAE dirhams',
        Currency.eur => 'euros',
      };

/// Arabic currency names; the same as `currencyName(c, DocLanguage.ar)`.
String currencyNameAr(Currency c) => currencyName(c, DocLanguage.ar);

/// The Arabic currency name in its definite form, for labels that name the
/// currency itself rather than an amount: `الجنيه المصري`,
/// `الدولار الأمريكي`, `الريال السعودي`, `الدرهم الإماراتي`, `اليورو`.
String currencyNameDefiniteAr(Currency c) => switch (c) {
  Currency.egp => 'الجنيه المصري',
  Currency.usd => 'الدولار الأمريكي',
  Currency.sar => 'الريال السعودي',
  Currency.aed => 'الدرهم الإماراتي',
  Currency.eur => 'اليورو',
};

/// An amount written out with its currency name: `180,000 جنيه مصري`,
/// `180,000 Egyptian pounds`. [minor] is in minor units.
String formatDocMoney(int minor, Currency c, DocLanguage lang) =>
    '${formatAmount(minor, c)} ${currencyName(c, lang)}';
