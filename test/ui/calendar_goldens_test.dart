@Tags(['golden'])
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';

import '../helpers/harness.dart';

/// The calendar with the demo set, seeded on the test's fixed day.
void main() {
  setUpAll(loadAppFonts);

  Future<ProviderContainer> calendar(
    WidgetTester tester, {
    ThemeMode mode = ThemeMode.light,
    CalendarView view = CalendarView.month,
    bool panel = false,
  }) async {
    final db = AppDatabase.memory(
      seeder: (db) => seedDemo(db, clock: Clock.fixed(testNow)),
    );
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, mode: mode);
    c.read(calendarModeProvider.notifier).set(true);
    c.read(calendarProvider.notifier)
      ..setView(view)
      ..select(CalendarDate.fromDateTime(testNow), open: panel);
    await settle(tester);
    return c;
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('calendar: month view with demo data (${mode.name})', (
      tester,
    ) async {
      await calendar(tester, mode: mode);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/calendar_month_${mode.name}.png'),
      );
    });
  }

  testWidgets('calendar: agenda view', (tester) async {
    await calendar(tester, view: CalendarView.agenda);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/calendar_agenda_light.png'),
    );
  });

  testWidgets('calendar: day panel on today', (tester) async {
    await calendar(tester, panel: true);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/calendar_day_panel_light.png'),
    );
  });

  testWidgets('the "today" banner', (tester) async {
    await calendar(tester);
    await expectLater(
      find.byKey(const Key('today-banner')),
      matchesGoldenFile('goldens/today_banner_light.png'),
    );
  });
}
