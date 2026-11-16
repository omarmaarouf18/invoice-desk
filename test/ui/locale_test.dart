import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/app/ui_prefs.dart';

void main() {
  const ar = Locale('ar');
  const en = Locale('en');
  const english = Locale('en', 'US');
  const french = Locale('fr', 'FR');

  group('resolveAppLocale', () {
    test('explicit choices', () {
      expect(
        resolveAppLocale(
          UiLanguage.ar,
          platform: english,
          translated: [ar, en],
        ),
        ar,
      );
      expect(
        resolveAppLocale(UiLanguage.en, platform: ar, translated: [ar, en]),
        en,
      );
    });

    test('system follows the OS, else Arabic', () {
      expect(
        resolveAppLocale(
          UiLanguage.system,
          platform: english,
          translated: [ar, en],
        ),
        en,
      );
      expect(
        resolveAppLocale(
          UiLanguage.system,
          platform: french,
          translated: [ar, en],
        ),
        ar,
      );
    });

    test('a language without translations falls back to Arabic', () {
      expect(
        resolveAppLocale(UiLanguage.en, platform: english, translated: [ar]),
        ar,
      );
    });
  });

  test('UiLanguage names; unknown is system', () {
    for (final l in UiLanguage.values) {
      expect(UiLanguage.fromName(l.name), l);
    }
    expect(UiLanguage.fromName(null), UiLanguage.system);
    expect(UiLanguage.fromName('klingon'), UiLanguage.system);
  });

  test('the choice is kept in UiPrefs and drives localeProvider', () {
    final prefs = UiPrefs.memory();
    final container = ProviderContainer(
      overrides: [
        uiPrefsProvider.overrideWithValue(prefs),
        platformLocaleProvider.overrideWithValue(french),
      ],
    );
    addTearDown(container.dispose);

    expect(container.read(uiLanguageProvider), UiLanguage.system);
    expect(container.read(localeProvider), ar);

    container.read(uiLanguageProvider.notifier).set(UiLanguage.ar);
    expect(prefs.uiLanguage, 'ar');
    expect(container.read(localeProvider), ar);
  });
}
