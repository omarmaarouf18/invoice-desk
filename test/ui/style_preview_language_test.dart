import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/features/styles/style_preview.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  test('the picked language wins; contracts are Arabic or English', () {
    const none = StyleEditorState();
    const en = StyleEditorState(previewLanguage: DocLanguage.en);
    const bi = StyleEditorState(previewLanguage: DocLanguage.bilingual);
    expect(
      previewLanguageOf(
        none,
        contract: false,
        documentLanguage: DocLanguage.bilingual,
      ),
      DocLanguage.bilingual,
    );
    expect(
      previewLanguageOf(en, contract: false, documentLanguage: DocLanguage.ar),
      DocLanguage.en,
    );
    expect(
      previewLanguageOf(bi, contract: true, documentLanguage: DocLanguage.ar),
      DocLanguage.ar,
    );
  });

  DocLanguage? shown(WidgetTester tester) => tester
      .widget<DropdownButton<DocLanguage>>(
        find.byKey(const ValueKey('style-preview-lang')),
      )
      .value;

  testWidgets('the toolbar shows the language the preview uses', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final c = await pumpShell(tester, db, size: const Size(1800, 1100));
    c.read(workspaceProvider.notifier).show(Workspace.styles);
    await settle(tester);
    // No invoice open: the sample, in the default document language.
    expect(shown(tester), DocLanguage.ar);

    final inv = (await tester.runAsync(db.invoicesDao.getAll))!.single;
    await drive(tester, () => c.read(editorProvider.notifier).open(inv.id));
    // Opening a document shows its editor; come back to the styles.
    c.read(workspaceProvider.notifier).show(Workspace.styles);
    await settle(tester);
    expect(shown(tester), DocLanguage.bilingual); // The seed invoice's own.

    c.read(styleEditorProvider.notifier).setPreviewLanguage(DocLanguage.en);
    await settle(tester);
    expect(shown(tester), DocLanguage.en);
  });
}
