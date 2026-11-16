@Tags(['golden'])
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';

import '../helpers/harness.dart';

/// The README screenshot (docs/screenshot.png): the calendar's month view
/// with the fictional demo set. Regenerate with
/// `--update-goldens --tags golden`.
void main() {
  setUpAll(loadAppFonts);

  testWidgets('README screenshot', (tester) async {
    final db = AppDatabase.memory(
      seeder: (db) => seedDemo(db, clock: Clock.fixed(testNow)),
    );
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db);
    c.read(calendarModeProvider.notifier).set(true);
    c
        .read(calendarProvider.notifier)
        .select(CalendarDate.fromDateTime(testNow));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshot.png'),
    );
  });
}
