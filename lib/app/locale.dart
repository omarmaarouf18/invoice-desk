import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/l10n/l10n.dart';

/// The language the UI falls back to: Arabic, the app's first language.
const appLocale = Locale('ar');

/// Every UI language the app is built for. A language only becomes
/// selectable once its ARB file exists (see [resolveAppLocale]).
const appSupportedLocales = [Locale('ar'), Locale('en')];

/// The user's UI-language choice, stored per machine in UiPrefs (D8).
enum UiLanguage {
  /// Follow the operating system; Arabic when it isn't a supported language.
  system,
  ar,
  en;

  /// [name] back to a choice; unknown or missing is [system].
  static UiLanguage fromName(String? name) =>
      values.firstWhere((v) => v.name == name, orElse: () => system);
}

/// The locale the app runs in for [choice].
///
/// [platform] is the OS locale, used for [UiLanguage.system]. A language
/// without translations in [translated] (the generated
/// `AppLocalizations.supportedLocales`) falls back to [appLocale], so an
/// English choice is safe before the English strings exist.
Locale resolveAppLocale(
  UiLanguage choice, {
  required Locale platform,
  required Iterable<Locale> translated,
}) {
  final code = switch (choice) {
    UiLanguage.system => platform.languageCode,
    UiLanguage.ar => 'ar',
    UiLanguage.en => 'en',
  };
  for (final l in translated) {
    if (l.languageCode == code) return Locale(code);
  }
  return appLocale;
}

class UiLanguageNotifier extends Notifier<UiLanguage> {
  @override
  UiLanguage build() =>
      UiLanguage.fromName(ref.read(uiPrefsProvider).uiLanguage);

  /// Switches the UI live and remembers the choice on this machine.
  void set(UiLanguage choice) {
    state = choice;
    ref.read(uiPrefsProvider).uiLanguage = choice.name;
  }
}

final uiLanguageProvider = NotifierProvider<UiLanguageNotifier, UiLanguage>(
  UiLanguageNotifier.new,
);

/// The OS locale; a seam so tests can pretend to be an English machine.
final platformLocaleProvider = Provider<Locale>(
  (ref) => PlatformDispatcher.instance.locale,
);

/// The locale MaterialApp runs in.
final localeProvider = Provider<Locale>(
  (ref) => resolveAppLocale(
    ref.watch(uiLanguageProvider),
    platform: ref.watch(platformLocaleProvider),
    translated: AppLocalizations.supportedLocales,
  ),
);
