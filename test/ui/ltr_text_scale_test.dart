// The English screens at the largest text scale.
//
// A row that only fits at the default scale is a row that breaks for a
// reader who needs larger text, so the English layouts are checked with
// the scale turned up: every screen has to lay out without a
// RenderFlex overflow.

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/settings/settings_section.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

/// The largest scale the platform offers.
const _largestScale = 2.0;

void main() {
  setUpAll(loadAppFonts);

  setUp(() {
    TestWidgetsFlutterBinding
            .instance
            .platformDispatcher
            .textScaleFactorTestValue =
        _largestScale;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher
        .clearTextScaleFactorTestValue();
  });

  testWidgets('the invoice list and editor fit the largest text', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    final id = (await tester.runAsync(db.invoicesDao.getAll))!.single.id;
    await tester.runAsync(() => c.read(editorProvider.notifier).open(id));
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the contract editor fits the largest text', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await pumpContractEditor(
      tester,
      db,
      complete: true,
      language: UiLanguage.en,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the calendar fits the largest text', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    c.read(calendarModeProvider.notifier).set(true);
    await settle(tester);
    expect(tester.takeException(), isNull);
    c.read(calendarProvider.notifier).setView(CalendarView.agenda);
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the settings fit the largest text', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    c.read(workspaceProvider.notifier).show(Workspace.settings);
    await settle(tester);
    expect(tester.takeException(), isNull);
    // Every section, not just the first one shown.
    for (final s in SettingsSection.values) {
      c.read(settingsSectionProvider.notifier).set(s);
      await settle(tester);
      expect(tester.takeException(), isNull, reason: s.name);
    }
  });
}
