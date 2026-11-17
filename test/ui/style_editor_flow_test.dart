import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/pdf_render.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/features/styles/style_inspector.dart';
import 'package:invoice_desk/features/styles/styles_page.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../helpers/contract_fixtures.dart' show loadPdfFonts;
import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';
import '../helpers/pdf_golden.dart';

/// Brief, Phase 5: create from Blank, enable blocks, assign to an invoice,
/// export the PDF.
void main() {
  setUpAll(loadAppFonts);

  testWidgets('Blank → notes on → assigned → exported in that style', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(db.close);
    // A draft: a sent invoice's look is locked, so its picker is disabled.
    final seeded = (await tester.runAsync(db.invoicesDao.getAll))!.single;
    await tester.runAsync(
      () => db.invoicesDao.saveInvoice(
        seeded.copyWith(status: InvoiceStatus.draft),
      ),
    );
    // Wide enough for the three columns (list, preview, inspector).
    final c = await pumpShell(tester, db, size: const Size(1800, 1600));
    final inv = (await tester.runAsync(db.invoicesDao.getAll))!.single;
    await drive(tester, () => c.read(editorProvider.notifier).open(inv.id));
    await settle(tester);

    // 1. Open the editor and create a style from Blank.
    c.read(workspaceProvider.notifier).show(Workspace.styles);
    await settle(tester);
    expect(find.byType(StylesPage), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('style-new-blank')));
    await settle(tester);
    final draft = c.read(styleEditorProvider).draft!;
    expect(draft.basePreset, 'blank');
    expect(draft.style.blockOrder, isNot(contains(DocBlock.notes)));

    // 2. Turn the notes block on in the inspector.
    final notes = find.descendant(
      of: find.byKey(const ValueKey('block-notes')),
      matching: find.byType(Checkbox),
    );
    // Scroll the inspector (the outer list, not the reorderable one).
    final inspector = find
        .descendant(
          of: find.byType(StyleInspector),
          matching: find.byType(Scrollable),
        )
        .first;
    for (
      var i = 0;
      i < 12 && (notes.evaluate().isEmpty || tester.getCenter(notes).dy > 1500);
      i++
    ) {
      await tester.drag(inspector, const Offset(0, -300));
      await tester.pump();
    }
    await tester.tap(notes);
    await settle(tester);
    await drive(tester, c.read(styleEditorProvider.notifier).flush);
    final saved = (await tester.runAsync(
      () => c.read(styleRepositoryProvider).getUserStyleById(draft.id),
    ))!;
    expect(saved.style.blockOrder.last, DocBlock.notes);
    expect(saved.style.showNotes, isTrue);

    // 3. Back to the invoice and pick the new style.
    await tester.tap(find.byKey(const ValueKey('styles-back')));
    await settle(tester);
    expect(c.read(workspaceProvider), Workspace.invoice);
    // The Details card's picker, driven through its own callback (the
    // dropdown overlay is not what this flow is about).
    final picker = find.byWidgetPredicate(
      (w) =>
          w is DropdownButtonFormField<String?> &&
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.startsWith('style-picker-'),
    );
    expect(picker, findsOneWidget);
    tester.widget<DropdownButtonFormField<String?>>(picker).onChanged!(
      saved.id,
    );
    await settle(tester);
    await drive(tester, c.read(editorProvider.notifier).flush);
    final assigned = (await tester.runAsync(
      () => db.invoicesDao.getById(inv.id),
    ))!;
    expect(assigned.styleId, saved.id);

    // 4. Export: the bytes are the Blank look with notes.
    final fonts = loadPdfFonts();
    final client = (await tester.runAsync(db.clientsDao.getAll))!.single;
    final settings = (await tester.runAsync(db.settingsDao.get))!;
    final data = InvoicePdfData(
      invoice: assigned,
      client: client,
      settings: settings,
    );
    final bytes = (await tester.runAsync(
      () => renderInvoicePdf(c.read(styleRepositoryProvider), data, fonts),
    ))!;
    final expected = DocPreset.blank.style.copyWith(
      blockOrder: [...DocPreset.blank.style.blockOrder, DocBlock.notes],
      showNotes: true,
    );
    final want = (await tester.runAsync(
      () => buildInvoicePdf(
        data,
        fonts,
        style: PdfStyle.fromDocumentStyle(expected),
      ),
    ))!;
    final plainBlank = (await tester.runAsync(
      () => buildInvoicePdf(
        data,
        fonts,
        style: PdfStyle.fromDocumentStyle(DocPreset.blank.style),
      ),
    ))!;
    expect(pdfContentDump(bytes), pdfContentDump(want));
    expect(pdfContentDump(bytes), isNot(pdfContentDump(plainBlank)));
  });
}
