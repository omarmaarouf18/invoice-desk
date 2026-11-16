@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    final name = mode.name;

    testWidgets('seed: sidebar + editor ($name)', (tester) async {
      final db = AppDatabase.memory(seeder: legacySeed);
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

    testWidgets('contracts: sidebar + signed contract editor ($name)', (
      tester,
    ) async {
      final db = AppDatabase.memory(seeder: legacySeed);
      addTearDown(() => tester.runAsync(db.close));
      await pumpContractEditor(tester, db, complete: true, mode: mode);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/contract_editor_$name.png'),
      );
    });

    testWidgets('contracts: variables panel with missing ones ($name)', (
      tester,
    ) async {
      final db = AppDatabase.memory(seeder: legacySeed);
      addTearDown(() => tester.runAsync(db.close));
      await pumpContractEditor(tester, db, complete: false, mode: mode);
      await tester.tap(find.byKey(const ValueKey('missing-variables')));
      await settle(tester);
      await tester.pump(const Duration(milliseconds: 400));
      await settle(tester);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/contract_variables_$name.png'),
      );
    });
  }
}
