@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  /// Seed data plus a contract (with a milestone invoice and an amendment)
  /// for Sample Academy. [complete] fills every variable.
  Future<ProviderContainer> withContracts(
    WidgetTester tester,
    AppDatabase db,
    ThemeMode mode, {
    required bool complete,
  }) async {
    final client = (await tester.runAsync(db.clientsDao.getAll))!.single;
    if (complete) {
      await tester.runAsync(
        () => db.clientsDao.upsert(
          client.copyWith(
            legalName: 'أكاديمية المتر للتعليم',
            representative: 'أحمد علي',
            representativeTitle: 'المدير التنفيذي',
          ),
        ),
      );
    }
    final c = await pumpShell(tester, db, mode: mode);
    final t = (await tester.runAsync(db.libraryDao.getAll))!.firstWhere(
      (x) => x.name == developmentTemplateName,
    );
    final ctl = c.read(contractProvider.notifier);
    await drive(
      tester,
      () => ctl.create(
        NewContractRequest(
          clientId: client.id,
          template: t,
          title: 'تطوير وتشغيل منصة تعليمية',
          projectName: 'منصة المتر',
        ),
      ),
    );
    ctl.edit((k) => k.copyWith(totalMinor: 18000000));
    await drive(tester, ctl.flush);
    final first = c.read(contractProvider).contract!;
    await drive(
      tester,
      () => ctl.createInvoiceFromMilestone(first.milestones.first.id),
    );
    if (complete) {
      ctl.setStatus(ContractStatus.signed, missing: const []);
      await drive(tester, ctl.flush);
      await drive(
        tester,
        () => ctl.createAmendment(
          first.id,
          preamble: (n, d) => 'إلحاقًا بالعقد رقم $n المؤرخ في $d.',
          clauseTitle: 'موضوع التعديل',
        ),
      );
      await drive(tester, () => ctl.open(first.id));
    }
    await settle(tester);
    return c;
  }

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
      await withContracts(tester, db, mode, complete: true);
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
      await withContracts(tester, db, mode, complete: false);
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
