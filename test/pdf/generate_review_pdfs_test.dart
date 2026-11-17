import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/sample_documents.dart';

void main() {
  final fonts = loadPdfFonts();
  const outDir = 'Claude outputs/style-review';

  test('generates all review PDFs for styles review', () async {
    Directory(outDir).createSync(recursive: true);

    for (final preset in DocPreset.values) {
      final presetName = preset.nameEn.toLowerCase();
      final pdfStyle = PdfStyle.fromDocumentStyle(preset.style);

      // Invoices: ar, en, bilingual
      for (final lang in DocLanguage.values) {
        final data = sampleInvoiceData(language: lang);
        final bytes = await buildInvoicePdf(data, fonts, style: pdfStyle);
        final file = File('$outDir/invoice-$presetName-${lang.name}.pdf')
          ..writeAsBytesSync(bytes);
        expect(file.existsSync(), isTrue);
      }

      // Contracts: ar, en
      for (final lang in [DocLanguage.ar, DocLanguage.en]) {
        final data = sampleContractData(language: lang);
        final bytes = await buildContractPdf(data, fonts, style: pdfStyle);
        final file = File('$outDir/contract-$presetName-${lang.name}.pdf')
          ..writeAsBytesSync(bytes);
        expect(file.existsSync(), isTrue);
      }
    }

    // Additional comparison: Dedicated Formal / رسمي style sample
    const formalStyleDoc = DocumentStyle(
      primary: 0xFF1E3A5F,
      accent: 0xFF2563EB,
      ink: 0xFF0F172A,
      muted: 0xFF475569,
      surface: 0xFFF8FAFC,
      tableHeaderBg: 0xFFF1F5F9,
      border: 0xFFCBD5E1,
      fontFamily: DocFontFamily.notoNaskhArabic,
    );
    final formalPdfStyle = PdfStyle.fromDocumentStyle(formalStyleDoc);

    for (final lang in DocLanguage.values) {
      final data = sampleInvoiceData(language: lang);
      final bytes = await buildInvoicePdf(data, fonts, style: formalPdfStyle);
      File(
        '$outDir/invoice-formal-sample-${lang.name}.pdf',
      ).writeAsBytesSync(bytes);
    }
    for (final lang in [DocLanguage.ar, DocLanguage.en]) {
      final data = sampleContractData(language: lang);
      final bytes = await buildContractPdf(data, fonts, style: formalPdfStyle);
      File(
        '$outDir/contract-formal-sample-${lang.name}.pdf',
      ).writeAsBytesSync(bytes);
    }
  });
}
