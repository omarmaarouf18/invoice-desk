import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/harness.dart';

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  late Client client;
  late Invoice invoice;

  Future<ProviderContainer> start(WidgetTester tester) async {
    db = AppDatabase.memory(seed: true);
    addTearDown(db.close);
    client = (await drive(tester, db.clientsDao.getAll)).single;
    invoice = (await drive(tester, db.invoicesDao.getAll)).single;
    return pumpShell(tester, db);
  }

  Future<void> openTrash(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(ChoiceChip, 'المحذوفات'));
    await settle(tester);
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.tap(f);
    await settle(tester);
  }

  testWidgets('trash lists rows with dates and days left; empty state', (
    tester,
  ) async {
    await start(tester);
    await openTrash(tester);
    expect(find.text('المحذوفات فاضية.'), findsOneWidget);

    await drive(
      tester,
      () => withClock(
        Clock.fixed(testNow),
        () => db.invoicesDao.softDelete(invoice.id),
      ),
    );
    await settle(tester);
    expect(find.text('OM-2026-0001'), findsOneWidget);
    expect(find.textContaining('حُذف في 15 نوفمبر'), findsOneWidget);
    expect(find.textContaining('يُحذف نهائيًا خلال 30 يوم'), findsOneWidget);
    expect(find.textContaining('لـ EL METR Academy'), findsOneWidget);
  });

  testWidgets('restoring a document of a deleted client offers both', (
    tester,
  ) async {
    await start(tester);
    await drive(
      tester,
      () => db.clientsDao.softDeleteWithDocuments(client.id),
    );
    await openTrash(tester);
    expect(find.textContaining('العميل محذوف'), findsOneWidget);
    await tap(tester, find.byKey(ValueKey('restore-${invoice.id}')));
    expect(find.text('العميل EL METR Academy في المحذوفات'), findsOneWidget);
    await tap(tester, find.byKey(const ValueKey('restore-with-client')));
    expect(await drive(tester, db.invoicesDao.countLive), 1);
    expect(await drive(tester, db.clientsDao.getAll), hasLength(1));
    expect(find.text('المحذوفات فاضية.'), findsOneWidget);
  });

  testWidgets('permanent delete needs the typed number', (tester) async {
    await start(tester);
    await drive(tester, () => db.invoicesDao.softDelete(invoice.id));
    await openTrash(tester);
    await tap(tester, find.byKey(ValueKey('purge-${invoice.id}')));
    FilledButton button() => tester.widget<FilledButton>(
      find.byKey(const ValueKey('typed-confirm-button')),
    );
    expect(button().onPressed, isNull);
    await tester.enterText(find.byKey(const ValueKey('typed-confirm')), 'OM');
    await tester.pump();
    expect(button().onPressed, isNull);
    await tester.enterText(
      find.byKey(const ValueKey('typed-confirm')),
      'OM-2026-0001',
    );
    await tester.pump();
    await tap(tester, find.byKey(const ValueKey('typed-confirm-button')));
    await settle(tester);
    expect(
      await drive(tester, () => db.invoicesDao.getAll(includeDeleted: true)),
      isEmpty,
    );
    expect(find.textContaining('before-purge-'), findsOneWidget);
  });

  testWidgets('"إفراغ المحذوفات" needs "إفراغ"', (tester) async {
    await start(tester);
    await drive(
      tester,
      () => db.clientsDao.upsert(const Client(id: 'x', name: 'X Co')),
    );
    await drive(tester, () => db.clientsDao.softDelete('x'));
    await drive(tester, () => db.invoicesDao.softDelete(invoice.id));
    await openTrash(tester);
    expect(find.text('عنصران'), findsOneWidget);
    await tap(tester, find.byKey(const ValueKey('empty-trash')));
    await tester.enterText(
      find.byKey(const ValueKey('typed-confirm')),
      'إفراغ',
    );
    await tester.pump();
    await tap(tester, find.byKey(const ValueKey('typed-confirm-button')));
    await settle(tester);
    expect(find.text('المحذوفات فاضية.'), findsOneWidget);
    expect(await drive(tester, db.clientsDao.getAll), hasLength(1));
  });
}
