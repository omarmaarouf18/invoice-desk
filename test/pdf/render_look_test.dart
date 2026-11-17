import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/pdf_render.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/pdf_golden.dart';
import '../helpers/sample_documents.dart';

/// The previews and exports print the document's resolved look; a
/// document with no style anywhere still prints Classic, unchanged.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final fonts = loadPdfFonts();
  late AppDatabase db;
  late StyleRepository styles;

  setUp(() {
    db = AppDatabase.memory();
    styles = StyleRepository(db, clock: Clock.fixed(DateTime.utc(2026, 11)));
  });
  tearDown(() => db.close());

  test('no style anywhere: the same content as Classic', () async {
    final data = sampleInvoiceData();
    final rendered = await renderInvoicePdf(styles, data, fonts);
    final classic = await buildInvoicePdf(data, fonts);
    expect(pdfContentDump(rendered), pdfContentDump(classic));
  });

  test('a document style id is printed', () async {
    final base = sampleInvoiceData();
    final data = InvoicePdfData(
      invoice: base.invoice.copyWith(styleId: () => DocPreset.modern.id),
      client: base.client,
      settings: base.settings,
    );
    final rendered = await renderInvoicePdf(styles, data, fonts);
    final modern = await buildInvoicePdf(
      data,
      fonts,
      style: PdfStyle.fromDocumentStyle(DocPreset.modern.style),
    );
    expect(pdfContentDump(rendered), pdfContentDump(modern));
    expect(
      pdfContentDump(rendered),
      isNot(pdfContentDump(await buildInvoicePdf(data, fonts))),
    );
  });

  test('a contract snapshot is printed', () async {
    final base = sampleContractData();
    final data = ContractPdfData(
      contract: base.contract.copyWith(
        styleSnapshot: DocPreset.formal.style.toRawJson,
      ),
      client: base.client,
      settings: base.settings,
      language: base.language,
    );
    final rendered = await renderContractPdf(styles, data, fonts);
    final formal = await buildContractPdf(
      data,
      fonts,
      style: PdfStyle.fromDocumentStyle(DocPreset.formal.style),
    );
    expect(pdfContentDump(rendered), pdfContentDump(formal));
  });
}
