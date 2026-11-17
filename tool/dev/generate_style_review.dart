// CLI tool intended to print status during manual review PDF generation.
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../../test/helpers/contract_fixtures.dart';
import '../../test/helpers/sample_documents.dart';

void main() {
  test('generate style review PDFs', () async {
    final outDir =
        Platform.environment['STYLE_REVIEW_DIR'] ??
        'Claude outputs/style-review';
    final dir = Directory(outDir)..createSync(recursive: true);
    final fonts = loadPdfFonts();

    print('Generating style review PDFs in "${dir.path}"...');

    var count = 0;
    for (final preset in DocPreset.values) {
      final presetName = preset.nameEn.toLowerCase();
      final pdfStyle = PdfStyle.fromDocumentStyle(preset.style);

      // Invoices: ar, en, bilingual
      for (final lang in DocLanguage.values) {
        final data = sampleInvoiceData(language: lang);
        final bytes = await buildInvoicePdf(data, fonts, style: pdfStyle);
        File(
          '${dir.path}/invoice-$presetName-${lang.name}.pdf',
        ).writeAsBytesSync(bytes);
        count++;
      }

      // Contracts: ar, en
      for (final lang in [DocLanguage.ar, DocLanguage.en]) {
        final data = sampleContractData(language: lang);
        final bytes = await buildContractPdf(data, fonts, style: pdfStyle);
        File(
          '${dir.path}/contract-$presetName-${lang.name}.pdf',
        ).writeAsBytesSync(bytes);
        count++;
      }
    }

    print(
      'Done! Generated $count review PDFs across ${DocPreset.values.length} presets.',
    );
  });
}
