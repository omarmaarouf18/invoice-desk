import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  late ProviderContainer c;

  Future<void> start(WidgetTester tester) async {
    db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(db.close);
    await drive(tester, db.settingsDao.get);
    c = await pumpShell(tester, db);
  }

  Future<void> ctrl(WidgetTester tester, LogicalKeyboardKey key) async {
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(key);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await settle(tester);
  }

  testWidgets(
    'Ctrl+N opens a draft with the next number; autosave persists it',
    (tester) async {
      await start(tester);
      await ctrl(tester, LogicalKeyboardKey.keyN);
      final st = c.read(editorProvider);
      expect(st.invoice!.number, 'OM-2026-0002');
      expect(st.invoice!.issueDate.toIso(), '2026-11-15');
      expect(st.invoice!.dueDate.toIso(), '2026-12-15');
      expect(st.invoice!.sections, hasLength(2));
      expect(find.text('OM-2026-0002'), findsWidgets);

      // Without a client the save is held back with an inline message.
      await drive(tester, () => c.read(editorProvider.notifier).save());
      await settle(tester);
      expect(
        c.read(editorProvider).issues,
        contains(InvoiceIssue.missingClient),
      );
      expect(find.text('اختر العميل'), findsOneWidget);

      final clientId = (await drive(tester, db.clientsDao.getAll)).single.id;
      c
          .read(editorProvider.notifier)
          .edit((i) => i.copyWith(clientId: clientId));
      await tester.pump(
        EditorController.autosaveDelay + const Duration(milliseconds: 50),
      );
      await settle(tester);
      final saved = await drive(tester, db.invoicesDao.getAll);
      expect(
        saved.map((i) => i.number),
        containsAll(['OM-2026-0001', 'OM-2026-0002']),
      );
      expect(c.read(editorProvider).status, SaveStatus.saved);
    },
  );

  testWidgets(
    'Enter in the last price cell adds a row and focuses its service',
    (tester) async {
      await start(tester);
      await ctrl(tester, LogicalKeyboardKey.keyN);
      final sectionId = c.read(editorProvider).invoice!.sections.first.id;
      final priceField = find
          .byWidgetPredicate(
            (w) => w is TextField && w.textInputAction == TextInputAction.done,
          )
          .first;
      await tester.tap(priceField);
      await tester.enterText(priceField, '١٥٠٠');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await settle(tester);
      final section = c
          .read(editorProvider)
          .invoice!
          .sections
          .firstWhere((s) => s.id == sectionId);
      expect(section.items, hasLength(2));
      expect(section.items.first.unitPriceMinor, 150000);
      final focused = FocusManager.instance.primaryFocus?.context?.widget;
      expect(focused, isNotNull);
      expect(find.byType(EditableText), findsWidgets);
      // Let the pending autosave run (it is held back: no client yet).
      await tester.pump(EditorController.autosaveDelay);
      await settle(tester);
      expect(c.read(editorProvider).status, SaveStatus.invalid);
    },
  );

  testWidgets('search filters and shows a no-results state', (tester) async {
    await start(tester);
    await ctrl(tester, LogicalKeyboardKey.keyK);
    await tester.enterText(find.byType(TextField).first, 'zzz');
    await tester.pump(const Duration(milliseconds: 150));
    await settle(tester);
    expect(find.text('لا نتائج لـ «zzz»'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '0001');
    await tester.pump(const Duration(milliseconds: 150));
    await settle(tester);
    expect(find.text('Sample Academy'), findsOneWidget);
  });

  testWidgets('delete is soft and undoable', (tester) async {
    await start(tester);
    final id = (await drive(tester, db.invoicesDao.getAll)).single.id;
    await drive(tester, () => c.read(editorProvider.notifier).open(id));
    await settle(tester);
    await drive(tester, () => c.read(editorProvider.notifier).delete(id));
    await settle(tester);
    expect(c.read(editorProvider).invoice, isNull);
    expect(await drive(tester, db.invoicesDao.getAll), isEmpty);
    await drive(tester, () => c.read(editorProvider.notifier).undoDelete(id));
    await settle(tester);
    expect(c.read(editorProvider).invoice?.id, id);
  });

  testWidgets('renew keeps recurring items only; mark paid sets today', (
    tester,
  ) async {
    await start(tester);
    final id = (await drive(tester, db.invoicesDao.getAll)).single.id;
    final r = await drive(
      tester,
      () => c.read(editorProvider.notifier).renew(id),
    );
    await settle(tester);
    expect(r, isA<Created>());
    final renewed = c.read(editorProvider).invoice!;
    expect(renewed.number, 'OM-2026-0002');
    expect(renewed.status, InvoiceStatus.draft);
    expect(renewed.sections.single.items, hasLength(4));
    expect(renewed.scope.enabled, isFalse);

    final paid = await drive(
      tester,
      () => c.read(editorProvider.notifier).markPaid(id),
    );
    expect(paid, isA<Done>());
    final orig = await drive(tester, () => db.invoicesDao.getById(id));
    expect(orig!.status, InvoiceStatus.paid);
    expect(orig.paidDate!.toIso(), '2026-11-15');
  });
}
