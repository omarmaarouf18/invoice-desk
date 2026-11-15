@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/harness.dart';

/// The README screenshot (docs/screenshot.png): fake provider and client
/// only. Regenerate with `--update-goldens --tags golden`.
void main() {
  setUpAll(loadAppFonts);

  testWidgets('README screenshot', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() async {
      await db.settingsDao.save(sampleSettings);
      await db.clientsDao.upsert(acme);
      await db.clientsDao.upsert(
        const Client(id: 'beta', name: 'Nile Bakery', city: 'Alexandria'),
      );
    });
    final c = await pumpShell(tester, db);
    final k = acmeContract(status: ContractStatus.signed);
    await tester.runAsync(() => db.contractsDao.saveContract(k));
    final ctl = c.read(contractProvider.notifier);
    await drive(tester, () => ctl.open(k.id));
    await drive(
      tester,
      () => ctl.createInvoiceFromMilestone(k.milestones.first.id),
    );
    c.read(previewTabProvider.notifier).set(false);
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../docs/screenshot.png'),
    );
  });
}
