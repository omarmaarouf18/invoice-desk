import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/settings/settings_section.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  late ProviderContainer c;

  Future<void> start(
    WidgetTester tester, {
    Settings Function(Settings s)? updateSettings,
  }) async {
    db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(db.close);
    if (updateSettings != null) {
      final s = await db.settingsDao.get();
      await db.settingsDao.save(updateSettings(s));
    }
    c = await pumpShell(tester, db);
    final inv = (await db.invoicesDao.getAll()).single;
    await tester.runAsync(() => c.read(editorProvider.notifier).open(inv.id));
    await settle(tester);
  }

  testWidgets(
    'switching invoice language shows/hides irrelevant notes and section titles',
    (tester) async {
      await start(tester);
      final ctl = c.read(editorProvider.notifier);
      final sectionId = c.read(editorProvider).invoice!.sections.first.id;

      // 1. Initially bilingual: both fields visible
      expect(c.read(editorProvider).invoice!.language, DocLanguage.bilingual);
      expect(find.byKey(const ValueKey('notes-en')), findsOneWidget);
      expect(find.byKey(const ValueKey('notes-ar')), findsOneWidget);
      expect(
        find.byKey(ValueKey('section-title-en-$sectionId')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('section-title-ar-$sectionId')),
        findsOneWidget,
      );

      // 2. Switch to Arabic: English fields hidden, Arabic fields visible
      ctl.setLanguage(DocLanguage.ar);
      await settle(tester);
      expect(c.read(editorProvider).invoice!.language, DocLanguage.ar);
      expect(find.byKey(const ValueKey('notes-en')), findsNothing);
      expect(find.byKey(const ValueKey('notes-ar')), findsOneWidget);
      expect(find.byKey(ValueKey('section-title-en-$sectionId')), findsNothing);
      expect(
        find.byKey(ValueKey('section-title-ar-$sectionId')),
        findsOneWidget,
      );

      // 3. Switch to English: Arabic fields hidden, English fields visible
      ctl.setLanguage(DocLanguage.en);
      await settle(tester);
      expect(c.read(editorProvider).invoice!.language, DocLanguage.en);
      expect(find.byKey(const ValueKey('notes-en')), findsOneWidget);
      expect(find.byKey(const ValueKey('notes-ar')), findsNothing);
      expect(
        find.byKey(ValueKey('section-title-en-$sectionId')),
        findsOneWidget,
      );
      expect(find.byKey(ValueKey('section-title-ar-$sectionId')), findsNothing);

      // 4. Switch back to bilingual: both visible again
      ctl.setLanguage(DocLanguage.bilingual);
      await settle(tester);
      expect(find.byKey(const ValueKey('notes-en')), findsOneWidget);
      expect(find.byKey(const ValueKey('notes-ar')), findsOneWidget);
      expect(
        find.byKey(ValueKey('section-title-en-$sectionId')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('section-title-ar-$sectionId')),
        findsOneWidget,
      );

      // Flush autosave timer
      await tester.pump(
        EditorController.autosaveDelay + const Duration(milliseconds: 100),
      );
    },
  );

  testWidgets(
    'B3: payment warning banner shown when payment methods are empty, clicking it opens Settings',
    (tester) async {
      // Clear payment methods in settings
      await start(
        tester,
        updateSettings: (s) =>
            s.copyWith(instapay: '', wallet: '', bankIban: ''),
      );

      // Banner is visible
      expect(
        find.byKey(const ValueKey('payment-warning-banner')),
        findsOneWidget,
      );

      // Tap "Open settings" button on banner
      await tester.tap(
        find.byKey(const ValueKey('open-settings-payment-warning')),
      );
      await settle(tester);

      // Should navigate to settings workspace
      expect(c.read(workspaceProvider), Workspace.settings);
      expect(c.read(settingsSectionProvider), SettingsSection.payment);
    },
  );

  testWidgets(
    'B3: payment warning banner not shown when a payment method is set',
    (tester) async {
      await start(
        tester,
        updateSettings: (s) => s.copyWith(instapay: 'test@instapay'),
      );

      expect(
        find.byKey(const ValueKey('payment-warning-banner')),
        findsNothing,
      );
    },
  );
}
