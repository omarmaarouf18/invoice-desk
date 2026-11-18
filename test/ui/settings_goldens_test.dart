// Settings → Invoices (numbering, tax, document formats), both directions.
//
// Regenerate with `flutter test --tags golden --update-goldens`.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/settings/settings_section.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final lang in [UiLanguage.ar, UiLanguage.en]) {
    testWidgets('settings: invoices (${lang.name})', (tester) async {
      final db = AppDatabase.memory(seeder: legacySeed);
      addTearDown(() => tester.runAsync(db.close));
      final c = await pumpShell(
        tester,
        db,
        language: lang,
        size: const Size(1440, 1600),
      );
      c.read(settingsSectionProvider.notifier).set(SettingsSection.invoices);
      c.read(workspaceProvider.notifier).show(Workspace.settings);
      await settle(tester);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/settings_invoices_${lang.name}.png'),
      );
    });
  }
}
