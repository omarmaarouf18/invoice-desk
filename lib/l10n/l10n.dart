import 'package:flutter/widgets.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/l10n/gen/app_localizations.dart';

export 'package:invoice_desk/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// The document language that matches the UI language.
  ///
  /// The UI is never bilingual (D2), so the UI and the documents share one
  /// language table: `doc_format` formats dates, headings and currency
  /// names the same way in both.
  DocLanguage get docLanguage =>
      Localizations.localeOf(this).languageCode == 'ar'
      ? DocLanguage.ar
      : DocLanguage.en;
}
