import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';

import '../helpers/harness.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    final name = mode.name;

    testWidgets('seed: sidebar + editor ($name)', (tester) async {
      final db = AppDatabase.memory(seed: true);
      addTearDown(() => tester.runAsync(db.close));
      await tester.runAsync(() => db.settingsDao.get());
      final c = await pumpShell(tester, db, mode: mode);
      final id = (await tester.runAsync(db.invoicesDao.getAll))!.single.id;
      await tester.runAsync(() => c.read(editorProvider.notifier).open(id));
      await settle(tester);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/seed_editor_$name.png'),
      );
    });

    testWidgets('first run: empty state ($name)', (tester) async {
      final db = AppDatabase.memory();
      addTearDown(() => tester.runAsync(db.close));
      await tester.runAsync(() => db.settingsDao.get());
      await pumpShell(tester, db, mode: mode);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/empty_$name.png'),
      );
    });
  }
}
