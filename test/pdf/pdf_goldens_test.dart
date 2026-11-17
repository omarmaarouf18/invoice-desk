// PDF goldens: the full drawing-operator dump of each sample document.
//
// They lock the layout glyph by glyph (B1: Arabic word gaps; later: Classic
// must not move when styles arrive). Update with `--update-goldens`, then
// read the .txt diff and the regenerated samples before committing.
//
// With `--dart-define=SAMPLE_PDF_DIR=docs` the same documents are also written
// as the README samples.
@Tags(['golden'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/pdf_golden.dart';
import '../helpers/sample_documents.dart';

const _sampleDir = String.fromEnvironment('SAMPLE_PDF_DIR');

void _writeSample(String fileName, Uint8List bytes) {
  if (_sampleDir.isNotEmpty) {
    File('$_sampleDir/$fileName').writeAsBytesSync(bytes);
  }
}

void main() {
  final fonts = loadPdfFonts();

  for (final lang in DocLanguage.values) {
    for (final paid in [false, true]) {
      for (final scope in [false, true]) {
        final paidSuffix = paid ? '_paid' : '_unpaid';
        final scopeSuffix = scope ? '_scope' : '';
        final goldenName = switch ((lang, paid, scope)) {
          (DocLanguage.bilingual, false, false) => 'invoice_sample',
          (DocLanguage.bilingual, false, true) => 'invoice_sample_scope',
          _ => 'invoice_${lang.name}$paidSuffix$scopeSuffix',
        };

        test(
          'invoice: ${lang.name}, ${paid ? "paid" : "unpaid"}, scope: $scope',
          () async {
            final data = sampleInvoiceData(
              language: lang,
              status: paid ? InvoiceStatus.paid : InvoiceStatus.sent,
              paidDate: paid ? const CalendarDate(2026, 9, 20) : null,
              scope: scope,
            );
            final bytes = await buildInvoicePdf(data, fonts);
            expectPdfGolden(bytes, goldenName);

            if (!paid && !scope) {
              final sampleName = switch (lang) {
                DocLanguage.bilingual => 'sample-invoice.pdf',
                DocLanguage.ar => 'sample-invoice-ar.pdf',
                DocLanguage.en => 'sample-invoice-en.pdf',
              };
              _writeSample(sampleName, bytes);
            } else if (!paid && scope && lang == DocLanguage.bilingual) {
              _writeSample('sample-invoice-scope.pdf', bytes);
            }
          },
        );
      }
    }
  }

  test('sample contract', () async {
    final bytes = await buildContractPdf(
      ContractPdfData(
        contract: acmeContract(),
        client: acme,
        settings: sampleSettings,
      ),
      fonts,
    );
    expectPdfGolden(bytes, 'contract_sample');
    _writeSample('sample-contract.pdf', bytes);
  });

  test('sample contract: en', () async {
    final bytes = await buildContractPdf(
      sampleContractData(language: DocLanguage.en),
      fonts,
    );
    expectPdfGolden(bytes, 'contract_classic_en');
  });

  final nonClassicPresets = DocPreset.values.where(
    (p) => p != DocPreset.classic,
  );

  for (final preset in nonClassicPresets) {
    final pdfStyle = PdfStyle.fromDocumentStyle(preset.style);

    // Invoices: ar, en, bilingual
    for (final lang in DocLanguage.values) {
      test(
        'invoice preset: ${preset.nameEn.toLowerCase()}, ${lang.name}',
        () async {
          final data = sampleInvoiceData(language: lang);
          final bytes = await buildInvoicePdf(data, fonts, style: pdfStyle);
          expectPdfGolden(
            bytes,
            'invoice_${preset.nameEn.toLowerCase()}_${lang.name}',
          );
        },
      );
    }

    // Contracts: ar, en
    for (final lang in [DocLanguage.ar, DocLanguage.en]) {
      test(
        'contract preset: ${preset.nameEn.toLowerCase()}, ${lang.name}',
        () async {
          final data = sampleContractData(language: lang);
          final bytes = await buildContractPdf(data, fonts, style: pdfStyle);
          expectPdfGolden(
            bytes,
            'contract_${preset.nameEn.toLowerCase()}_${lang.name}',
          );
        },
      );
    }
  }
}
