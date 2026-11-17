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
import '../helpers/pdf_glyphs.dart';
import '../helpers/sample_documents.dart';

/// Arabic letters, in logical and presentation forms (what the shaped PDF
/// glyphs map back to).
bool _isArabic(int cp) =>
    (cp >= 0x0600 && cp <= 0x06FF) ||
    (cp >= 0x0750 && cp <= 0x077F) ||
    (cp >= 0xFB50 && cp <= 0xFDFF) ||
    (cp >= 0xFE70 && cp <= 0xFEFF);

/// Letter spacing pulls cursive Arabic apart («ف ا ت و ر ة»), so no run
/// that draws an Arabic glyph may carry a non-zero `Tc`.
void _expectNoTrackedArabic(Uint8List bytes, String name) {
  final pages = extractGlyphsByPage(bytes);
  var arabicGlyphs = 0;
  for (var p = 0; p < pages.length; p++) {
    for (final g in pages[p]) {
      if (!_isArabic(g.codePoint)) continue;
      arabicGlyphs++;
      expect(
        g.charSpace,
        0,
        reason:
            '$name page ${p + 1}: Arabic glyph "${g.char}" drawn with '
            'letter spacing ${g.charSpace}',
      );
    }
  }
  expect(arabicGlyphs, greaterThan(0), reason: '$name drew no Arabic');
}

void main() {
  final fonts = loadPdfFonts();

  for (final preset in DocPreset.values) {
    final style = PdfStyle.fromDocumentStyle(preset.style);
    group('${preset.name}: Arabic runs have no letter spacing', () {
      for (final lang in [DocLanguage.ar, DocLanguage.bilingual]) {
        test('invoice ${lang.name} (paid, with scope page)', () async {
          final bytes = await buildInvoicePdf(
            sampleInvoiceData(
              scope: true,
              language: lang,
              status: InvoiceStatus.paid,
              paidDate: const CalendarDate(2026, 9, 20),
            ),
            fonts,
            style: style,
          );
          _expectNoTrackedArabic(bytes, 'invoice-${preset.name}-${lang.name}');
        });
      }

      test('contract ar', () async {
        final bytes = await buildContractPdf(
          sampleContractData(),
          fonts,
          style: style,
        );
        _expectNoTrackedArabic(bytes, 'contract-${preset.name}-ar');
      });
    });
  }

  test('Latin titles keep their tracking', () async {
    final bytes = await buildInvoicePdf(
      sampleInvoiceData(language: DocLanguage.en),
      fonts,
    );
    final tracked = extractGlyphsByPage(
      bytes,
    ).expand((p) => p).where((g) => g.charSpace > 0);
    expect(tracked.map((g) => g.char).join(), contains('INVOICE'));
  });
}
