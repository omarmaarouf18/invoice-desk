// A text field is read in the direction of its content, not in the
// direction of the interface: an Arabic line in an English screen used to
// be cut at its first word, because the paragraph was laid out from the
// left and the beginning of the line fell outside the field.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/widgets/common.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

/// Arabic text, long enough not to fit in the field.
const _arabic =
    'تصميم وتطوير التطبيق ولوحة التحكم، الاختبار، والرفع على المتاجر';

/// English text, long enough not to fit in the field.
const _english = 'Design and development of the application and the dashboard';

void main() {
  setUpAll(loadAppFonts);

  Widget host(
    TextDirection ui,
    String value, {
    TextDirection? explicit,
  }) => MaterialApp(
    home: Directionality(
      textDirection: ui,
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 120,
            child: SyncedTextField(
              value: value,
              textDirection: explicit,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    ),
  );

  testWidgets('Arabic text in an English screen is read from the right', (
    tester,
  ) async {
    await tester.pumpWidget(host(TextDirection.ltr, _arabic));
    await tester.pump();

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.textDirection, TextDirection.rtl);
    expect(editable.textAlign, TextAlign.start);

    // The line starts at the right, so the field is scrolled to its far
    // end: that is where the first word is.
    final scroll = tester
        .widget<TextField>(find.byType(TextField))
        .scrollController!;
    expect(scroll.position.maxScrollExtent, greaterThan(0));
    expect(scroll.offset, scroll.position.maxScrollExtent);
  });

  testWidgets('English text in an Arabic screen is read from the left', (
    tester,
  ) async {
    await tester.pumpWidget(host(TextDirection.rtl, _english));
    await tester.pump();

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.textDirection, TextDirection.ltr);
    expect(editable.textAlign, TextAlign.start);

    final scroll = tester
        .widget<TextField>(find.byType(TextField))
        .scrollController!;
    expect(scroll.position.maxScrollExtent, greaterThan(0));
    expect(scroll.offset, 0);
  });

  testWidgets('an empty field follows the interface', (tester) async {
    await tester.pumpWidget(host(TextDirection.rtl, ''));
    await tester.pump();
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.textDirection, TextDirection.rtl);
  });

  testWidgets('a digit does not decide the direction', (tester) async {
    await tester.pumpWidget(host(TextDirection.rtl, '1200'));
    await tester.pump();
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.textDirection, TextDirection.rtl);
  });

  testWidgets('an explicit direction wins', (tester) async {
    await tester.pumpWidget(
      host(TextDirection.rtl, _arabic, explicit: TextDirection.ltr),
    );
    await tester.pump();
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.textDirection, TextDirection.ltr);
  });

  testWidgets('the invoice editor reads an Arabic line in an English screen', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    final id = (await tester.runAsync(db.invoicesDao.getAll))!.single.id;
    await tester.runAsync(() => c.read(editorProvider.notifier).open(id));
    await settle(tester);

    // The description of the seed is Arabic; the screen around it is not.
    final description = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .firstWhere((e) => e.controller.text.contains('تصميم'));
    expect(description.textDirection, TextDirection.rtl);
  });
}
