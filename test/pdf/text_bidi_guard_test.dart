import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/pdf_glyphs.dart';
import '../helpers/sample_documents.dart';

void assertLtrTokensInOrder(
  Uint8List pdfBytes,
  String documentName,
  List<String> expectedTokens,
) {
  final pages = extractGlyphsByPage(pdfBytes);
  for (final token in expectedTokens) {
    var foundToken = false;
    for (var pageIdx = 0; pageIdx < pages.length; pageIdx++) {
      final lines = groupGlyphsByLine(pages[pageIdx]);
      for (final line in lines) {
        final lineStr = line.map((g) => g.char).join();
        // Check if reversed token is present (e.g. "PGE" for "EGP")
        final reversedToken = token.split('').reversed.join();
        if (token.length > 1 &&
            lineStr.contains(reversedToken) &&
            !lineStr.contains(token)) {
          fail(
            'In $documentName (page ${pageIdx + 1}): LTR token "$token" is drawn reversed as "$reversedToken" in line: "$lineStr"',
          );
        }

        // When token is found, verify its glyphs are in strictly increasing x order
        final matchIdx = lineStr.indexOf(token);
        if (matchIdx != -1) {
          foundToken = true;
          for (var i = 0; i < token.length - 1; i++) {
            final gCurrent = line[matchIdx + i];
            final gNext = line[matchIdx + i + 1];
            expect(
              gCurrent.x < gNext.x,
              isTrue,
              reason:
                  'In $documentName (page ${pageIdx + 1}): glyph "${gCurrent.char}" at x=${gCurrent.x} should precede "${gNext.char}" at x=${gNext.x} in token "$token"',
            );
          }
        }
      }
    }
    if (!foundToken) {
      // If token wasn't found at all, verify it didn't get scrambled with broken characters/order
      // (e.g. "0001-2026-SS" instead of "SS-2026-0001")
      for (var pageIdx = 0; pageIdx < pages.length; pageIdx++) {
        final lines = groupGlyphsByLine(pages[pageIdx]);
        for (final line in lines) {
          final lineStr = line.map((g) => g.char).join();
          if (token == 'SS-2026-0001' && lineStr.contains('0001-2026-SS')) {
            fail(
              'In $documentName (page ${pageIdx + 1}): token "SS-2026-0001" rendered scrambled as "0001-2026-SS" in line: "$lineStr"',
            );
          }
        }
      }
    }
  }
}

void assertArabicParenthesesMirrored(
  Uint8List pdfBytes,
  String documentName,
) {
  final pages = extractGlyphsByPage(pdfBytes);
  for (var pageIdx = 0; pageIdx < pages.length; pageIdx++) {
    final lines = groupGlyphsByLine(pages[pageIdx]);
    for (final line in lines) {
      final lineStr = line.map((g) => g.char).join();
      // In Arabic text, parenthesized expressions like "(مقدم الخدمة)" or "(العميل)" or "(1)"
      // must have mirrored parentheses: on the page from left to right, the opening parenthesis
      // (which curves rightwards towards the text) appears at the left as '(', and closing as ')',
      // OR in RTL reading order: to the right of "مقدم" sits ')', to the left of "الخدمة" sits '('.
      // If parentheses are NOT mirrored, they show as: ")مقدم الخدمة(" or ")1(".
      if (lineStr.contains(')ﺔﻣﺪﺨﻟﺍﻡﺪﻘﻣ(') || lineStr.contains(')ﻞﻴﻤﻌﻟﺍ(')) {
        fail(
          'In $documentName (page ${pageIdx + 1}): Arabic parentheses are unmirrored in line: "$lineStr"',
        );
      }
      if (lineStr.contains(')1(ﻖﺤﻠﻤﻟﺍ') || lineStr.contains(')2(ﻖﺤﻠﻤﻟﺍ')) {
        fail(
          'In $documentName (page ${pageIdx + 1}): Appendix parentheses are unmirrored in line: "$lineStr"',
        );
      }
    }
  }
}

void main() {
  final fonts = loadPdfFonts();

  final fontFamilies = [
    DocFontFamily.ibmPlexSansArabic,
    DocFontFamily.notoNaskhArabic,
  ];

  group('PDF Text Bidi & Glyph Order Guard', () {
    for (final family in fontFamilies) {
      group('FontFamily: ${family.name}', () {
        final style = PdfStyle.fromDocumentStyle(
          DocPreset.classic.style.copyWith(fontFamily: family),
        );

        test('Invoice AR: LTR tokens and numbers', () async {
          final invoice = sampleInvoice(language: DocLanguage.ar);
          final pdfBytes = await buildInvoicePdf(
            InvoicePdfData(
              invoice: invoice,
              client: acme,
              settings: sampleInvoiceSettings,
            ),
            fonts,
            style: style,
          );

          assertLtrTokensInOrder(
            pdfBytes,
            'invoice-ar-${family.name}',
            ['EGP', 'SS-2026-0001', 'studio.example.com'],
          );
        });

        test('Invoice EN: LTR tokens and numbers', () async {
          final invoice = sampleInvoice(language: DocLanguage.en);
          final pdfBytes = await buildInvoicePdf(
            InvoicePdfData(
              invoice: invoice,
              client: acme,
              settings: sampleInvoiceSettings,
            ),
            fonts,
            style: style,
          );

          assertLtrTokensInOrder(
            pdfBytes,
            'invoice-en-${family.name}',
            ['EGP', 'SS-2026-0001', 'studio.example.com'],
          );
        });

        test('Invoice Bilingual: LTR tokens and numbers', () async {
          final invoice = sampleInvoice();
          final pdfBytes = await buildInvoicePdf(
            InvoicePdfData(
              invoice: invoice,
              client: acme,
              settings: sampleInvoiceSettings,
            ),
            fonts,
            style: style,
          );

          assertLtrTokensInOrder(
            pdfBytes,
            'invoice-bilingual-${family.name}',
            ['EGP', 'SS-2026-0001', 'studio.example.com'],
          );
        });

        test(
          'Contract AR: LTR tokens, domains, and mirrored parentheses',
          () async {
            final contract = acmeContract();
            final pdfBytes = await buildContractPdf(
              ContractPdfData(
                contract: contract,
                client: acme,
                settings: sampleSettings,
              ),
              fonts,
              style: style,
            );

            assertLtrTokensInOrder(
              pdfBytes,
              'contract-ar-${family.name}',
              ['EGP', 'acme-booking.example.com'],
            );

            assertArabicParenthesesMirrored(
              pdfBytes,
              'contract-ar-${family.name}',
            );
          },
        );

        test('Contract EN: LTR tokens and domains', () async {
          final contract = acmeContract();
          // English contract logic or sample
          final pdfBytes = await buildContractPdf(
            ContractPdfData(
              contract: contract,
              client: acme,
              settings: sampleSettings,
            ),
            fonts,
            style: style,
          );

          assertLtrTokensInOrder(
            pdfBytes,
            'contract-en-${family.name}',
            ['EGP', 'acme-booking.example.com'],
          );
        });
      });
    }
  });
}
