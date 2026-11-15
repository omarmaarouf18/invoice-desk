import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/harness.dart';

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  late ProviderContainer c;

  Future<void> start(WidgetTester tester) async {
    db = AppDatabase.memory(seed: true);
    addTearDown(db.close);
    await drive(
      tester,
      () => db.clientsDao.upsert(const Client(id: 'empty', name: 'Empty Co')),
    );
    c = await pumpShell(tester, db);
  }

  Future<void> menu(WidgetTester tester, String client, String item) async {
    await tester.tap(find.text(client), buttons: kSecondaryButton);
    await settle(tester);
    await tester.tap(find.text(item).last);
    await settle(tester);
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder f) async {
    await tester.tap(f);
    await settle(tester);
  }

  testWidgets('client without invoices: delete from the menu, then undo', (
    tester,
  ) async {
    await start(tester);
    expect(find.text('Empty Co'), findsOneWidget);
    await menu(tester, 'Empty Co', 'حذف العميل');

    expect(find.text('Empty Co'), findsNothing);
    expect(find.text('اتحذف العميل Empty Co'), findsOneWidget);
    expect(await drive(tester, db.clientsDao.getAll), hasLength(1));

    await tapAndSettle(tester, find.text('تراجع'));
    expect(await drive(tester, db.clientsDao.getAll), hasLength(2));
    expect(find.text('Empty Co'), findsOneWidget);
  });

  testWidgets('client dialog has the delete button', (tester) async {
    await start(tester);
    await menu(tester, 'Empty Co', 'تعديل');
    await tapAndSettle(
      tester,
      find.byKey(const ValueKey('client-dialog-delete')),
    );
    expect(find.text('اتحذف العميل Empty Co'), findsOneWidget);
    expect(await drive(tester, db.clientsDao.getAll), hasLength(1));
  });

  testWidgets(
    'client with invoices: archive hides them; the filter shows them',
    (
      tester,
    ) async {
      await start(tester);
      await menu(tester, 'EL METR Academy', 'حذف العميل');
      expect(find.text('EL METR Academy عنده فواتير'), findsOneWidget);
      expect(find.textContaining('1 فاتورة'), findsWidgets);
      expect(
        find.textContaining(r'غير المدفوع: 22,000 EGP + $255.50'),
        findsOneWidget,
      );

      await tapAndSettle(tester, find.byKey(const ValueKey('archive-client')));
      expect(find.text('EL METR Academy'), findsNothing);
      expect(find.text('OM-2026-0001'), findsNothing);
      expect(await drive(tester, db.invoicesDao.countLive), 1);

      // Search doesn't find them either.
      await tester.enterText(find.byType(TextField).first, '0001');
      await tester.pump(const Duration(milliseconds: 150));
      await settle(tester);
      expect(find.text('EL METR Academy'), findsNothing);
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pump(const Duration(milliseconds: 150));
      await settle(tester);

      await tapAndSettle(tester, find.widgetWithText(ChoiceChip, 'مؤرشف'));
      expect(find.text('EL METR Academy'), findsOneWidget);
      expect(find.text('OM-2026-0001'), findsOneWidget);
      expect(find.text('Empty Co'), findsNothing);

      await menu(tester, 'EL METR Academy', 'إلغاء الأرشفة');
      expect(find.text('EL METR Academy'), findsNothing);
      await tapAndSettle(tester, find.widgetWithText(ChoiceChip, 'الكل'));
      expect(find.text('EL METR Academy'), findsOneWidget);
    },
  );

  testWidgets(
    'delete with invoices needs the typed name, backs up, and undo restores',
    (tester) async {
      await start(tester);
      final backups = c.read(appPathsProvider).defaultBackupDir;
      await menu(tester, 'EL METR Academy', 'حذف العميل');
      await tapAndSettle(
        tester,
        find.byKey(const ValueKey('delete-client-and-invoices')),
      );

      FilledButton confirm() => tester.widget<FilledButton>(
        find.byKey(const ValueKey('confirm-delete-all')),
      );
      final field = find.byKey(const ValueKey('confirm-client-name'));
      expect(confirm().onPressed, isNull);
      await tester.enterText(field, 'EL METR');
      await tester.pump();
      expect(confirm().onPressed, isNull);
      await tester.enterText(field, ' EL METR Academy ');
      await tester.pump();
      expect(confirm().onPressed, isNotNull);

      await tapAndSettle(
        tester,
        find.byKey(const ValueKey('confirm-delete-all')),
      );
      await settle(tester);

      final files = await tester.runAsync(
        () => backups.list().map((e) => e.path).toList(),
      );
      final before = files!.where((p) => p.contains('before-delete-client-'));
      expect(before, hasLength(1));
      expect(File(before.single).lengthSync(), greaterThan(0));

      expect(await drive(tester, db.clientsDao.getAll), hasLength(1));
      expect(await drive(tester, db.invoicesDao.countLive), 0);
      expect(find.text('EL METR Academy'), findsNothing);
      expect(find.text('اتحذف EL METR Academy و1 فاتورة'), findsOneWidget);

      await tapAndSettle(tester, find.text('تراجع'));
      expect(await drive(tester, db.clientsDao.getAll), hasLength(2));
      final restored = await drive(tester, db.invoicesDao.getAll);
      expect(restored.single.number, 'OM-2026-0001');
      expect(restored.single.sections, hasLength(2));
      expect(find.text('EL METR Academy'), findsOneWidget);
    },
  );
}
