// The English (left-to-right) screens.
//
// The Arabic goldens lock the right-to-left layout; these lock the
// left-to-right one, so a widget that only works in RTL (a row that
// overflows, an icon that points the wrong way) shows up as a diff.
//
// Regenerate with `flutter test --tags golden --update-goldens`.
@Tags(['golden'])
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('ltr: sidebar + invoice editor', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    final id = (await tester.runAsync(db.invoicesDao.getAll))!.single.id;
    await tester.runAsync(() => c.read(editorProvider.notifier).open(id));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/ltr_sidebar_editor.png'),
    );
  });

  testWidgets('ltr: contract editor', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await pumpContractEditor(
      tester,
      db,
      complete: true,
      language: UiLanguage.en,
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/ltr_contract_editor.png'),
    );
  });

  testWidgets('ltr: calendar month view', (tester) async {
    final db = AppDatabase.memory(
      seeder: (db) => seedDemo(db, clock: Clock.fixed(testNow)),
    );
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    c.read(calendarModeProvider.notifier).set(true);
    c.read(calendarProvider.notifier)
      ..setView(CalendarView.month)
      ..select(CalendarDate.fromDateTime(testNow));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/ltr_calendar_month.png'),
    );
  });

  testWidgets('ltr: settings', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    c.read(workspaceProvider.notifier).show(Workspace.settings);
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/ltr_settings.png'),
    );
  });
}
