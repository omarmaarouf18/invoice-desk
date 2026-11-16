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
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';

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

  test('sample invoice', () async {
    final bytes = await buildInvoicePdf(sampleInvoiceData(), fonts);
    expectPdfGolden(bytes, 'invoice_sample');
    _writeSample('sample-invoice.pdf', bytes);
  });

  test('sample invoice with scope page', () async {
    final bytes = await buildInvoicePdf(sampleInvoiceData(scope: true), fonts);
    expectPdfGolden(bytes, 'invoice_sample_scope');
    _writeSample('sample-invoice-scope.pdf', bytes);
  });

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
}
