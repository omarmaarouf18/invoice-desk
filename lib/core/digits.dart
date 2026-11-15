/// Converts Arabic-Indic (٠-٩) and Eastern Arabic-Indic (۰-۹) digits to
/// Western digits. Everything else is left untouched.
String normalizeDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= 0x0660 && rune <= 0x0669) {
      buffer.writeCharCode(0x30 + rune - 0x0660);
    } else if (rune >= 0x06F0 && rune <= 0x06F9) {
      buffer.writeCharCode(0x30 + rune - 0x06F0);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// Search/collation key: lower-case, Western digits, unified Arabic letter
/// variants (أ إ آ → ا, ى → ي, ة → ه), no tatweel or diacritics.
String foldForSearch(String input) {
  return normalizeDigits(input)
      .toLowerCase()
      .replaceAll(RegExp('[أإآٱ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll(RegExp(r'[\u0640\u064B-\u0652]'), '');
}

/// Wraps [text] in Unicode LTR isolate marks so numbers, emails and IBANs
/// keep their order inside RTL text.
String ltr(String text) => '\u2066$text\u2069';
