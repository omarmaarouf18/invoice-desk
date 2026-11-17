import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/styles/style_actions.dart';
import 'package:invoice_desk/l10n/gen/app_localizations.dart';

/// The style editor names presets from ARB; the presets carry their own
/// names too. The two must never disagree (Bold is «بارز», not «جريء»).
void main() {
  test('UI preset names match the presets', () {
    final ar = lookupAppLocalizations(const Locale('ar'));
    final en = lookupAppLocalizations(const Locale('en'));
    for (final p in DocPreset.values) {
      expect(presetName(ar, p), p.nameAr, reason: p.id);
      expect(presetName(en, p), p.nameEn, reason: p.id);
    }
  });
}
