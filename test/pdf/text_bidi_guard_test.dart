import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/sample_documents.dart';

/// A single rendered glyph on a PDF page with its baseline and x position.
class PageGlyph {
  PageGlyph({
    required this.char,
    required this.codePoint,
    required this.x,
    required this.y,
    required this.fontId,
    required this.fontSize,
  });

  final String char;
  final int codePoint;
  final double x;
  final double y;
  final int fontId;
  final double fontSize;

  @override
  String toString() =>
      '$char@(${x.toStringAsFixed(1)},${y.toStringAsFixed(1)})';
}

/// Parses font width tables from PDF objects.
Map<int, List<double>> _parseFontWidths(String pdf) {
  final wArrays = <int, List<double>>{};
  for (final m in RegExp(
    r'(\d+)\s+0\s+obj\s*\[([-\d\s.]+)\]\s*endobj',
  ).allMatches(pdf)) {
    final objId = int.parse(m.group(1)!);
    final widths = m
        .group(2)!
        .trim()
        .split(RegExp(r'\s+'))
        .map(double.parse)
        .toList();
    wArrays[objId] = widths;
  }

  final fontToW = <int, List<double>>{};
  for (final m in RegExp(
    r'/Name/F(\d+).*?/W\s*\[0\s*(\d+)\s*0\s*R\]',
    dotAll: true,
  ).allMatches(pdf)) {
    final fontId = int.parse(m.group(1)!);
    final wObj = int.parse(m.group(2)!);
    if (wArrays.containsKey(wObj)) {
      fontToW[fontId] = wArrays[wObj]!;
    }
  }
  return fontToW;
}

/// Parses /ToUnicode CMaps to translate font CIDs to Unicode characters.
Map<int, Map<int, int>> _parseToUnicodeCmaps(Uint8List bytes) {
  final raw = latin1.decode(bytes);
  final cmapsByObjId = <int, Map<int, int>>{};

  for (final m in RegExp(
    r'(\d+)\s+0\s+obj\s*<<((?:(?!>>\s*stream|endobj).)*)>>\s*stream\r?\n',
    dotAll: true,
  ).allMatches(raw)) {
    final objId = int.parse(m.group(1)!);
    final dict = m.group(2)!;
    final end = raw.indexOf('endstream', m.end);
    var streamBytes = bytes.sublist(m.end, end);
    if (dict.contains('/FlateDecode')) {
      try {
        streamBytes = Uint8List.fromList(ZLibCodec().decode(streamBytes));
      } on Object catch (_) {
        continue;
      }
    }
    final text = latin1.decode(streamBytes);
    if (!text.contains('begincmap')) continue;

    final cmap = <int, int>{};
    for (final bfchar in RegExp(
      r'<([0-9a-fA-F]+)>\s*<([0-9a-fA-F]+)>',
    ).allMatches(text)) {
      final cid = int.parse(bfchar.group(1)!, radix: 16);
      final unicode = int.parse(bfchar.group(2)!, radix: 16);
      cmap[cid] = unicode;
    }
    cmapsByObjId[objId] = cmap;
  }

  final fontToCmap = <int, Map<int, int>>{};
  for (final m in RegExp(
    r'/Name/F(\d+).*?/ToUnicode\s*(\d+)\s*0\s*R',
    dotAll: true,
  ).allMatches(raw)) {
    final fontId = int.parse(m.group(1)!);
    final cmapObj = int.parse(m.group(2)!);
    if (cmapsByObjId.containsKey(cmapObj)) {
      fontToCmap[fontId] = cmapsByObjId[cmapObj]!;
    }
  }
  return fontToCmap;
}

/// Decompresses and extracts content streams for each page.
List<String> _extractContentStreams(Uint8List bytes) {
  final raw = latin1.decode(bytes);
  final streams = <String>[];
  for (final m in RegExp(
    r'\d+\s+0\s+obj\s*<<((?:(?!>>\s*stream|endobj).)*)>>\s*stream\r?\n',
    dotAll: true,
  ).allMatches(raw)) {
    final dict = m.group(1)!;
    if (RegExp('/Type|/Subtype|/Length1').hasMatch(dict)) continue;
    final end = raw.indexOf('endstream', m.end);
    var streamBytes = bytes.sublist(m.end, end);
    if (dict.contains('/FlateDecode')) {
      try {
        streamBytes = Uint8List.fromList(ZLibCodec().decode(streamBytes));
      } on Object catch (_) {
        continue;
      }
    }
    final decoded = latin1.decode(streamBytes);
    if (decoded.contains('begincmap')) continue;
    streams.add(decoded);
  }
  return streams;
}

/// Extracts all glyphs placed on each page with their baseline and x coordinates.
List<List<PageGlyph>> extractGlyphsByPage(Uint8List pdfBytes) {
  final rawPdf = latin1.decode(pdfBytes);
  final fontWidths = _parseFontWidths(rawPdf);
  final cmaps = _parseToUnicodeCmaps(pdfBytes);
  final pages = _extractContentStreams(pdfBytes);

  final runRe = RegExp(
    r'BT\s+/F(\d+)\s+([\d.]+)\s+Tf\s+[-\d.]+\s+Tc\s+([-\d.]+)\s+([-\d.]+)\s+Td\s+\[<([0-9a-f]+)>\]TJ\s+ET',
  );
  final cmRe = RegExp(r'1\s+0\s+0\s+1\s+([-\d.]+)\s+([-\d.]+)\s+cm');
  final instructions = RegExp(
    r'(\bq\b|\bQ\b|1\s+0\s+0\s+1\s+[-\d.]+\s+[-\d.]+\s+cm|BT\s+/F\d+\s+[\d.]+\s+Tf\s+[-\d.]+\s+Tc\s+[-\d.]+\s+[-\d.]+\s+Td\s+\[<[0-9a-f]+>\]TJ\s+ET)',
  );

  final result = <List<PageGlyph>>[];

  for (final pageStream in pages) {
    final stack = <(double, double)>[(0.0, 0.0)];
    final glyphs = <PageGlyph>[];

    for (final m in instructions.allMatches(pageStream)) {
      final tok = m.group(1)!.trim();
      if (tok == 'q') {
        stack.add(stack.last);
      } else if (tok == 'Q') {
        if (stack.length > 1) stack.removeLast();
      } else if (tok.endsWith('cm')) {
        final cmMatch = cmRe.firstMatch(tok);
        if (cmMatch != null) {
          final tx = double.parse(cmMatch.group(1)!);
          final ty = double.parse(cmMatch.group(2)!);
          final (currTx, currTy) = stack.last;
          stack[stack.length - 1] = (currTx + tx, currTy + ty);
        }
      } else if (tok.startsWith('BT')) {
        final runMatch = runRe.firstMatch(tok);
        if (runMatch != null) {
          final fontId = int.parse(runMatch.group(1)!);
          final size = double.parse(runMatch.group(2)!);
          final x = double.parse(runMatch.group(3)!);
          final y = double.parse(runMatch.group(4)!);
          final hex = runMatch.group(5)!;
          final cids = [
            for (var i = 0; i < hex.length; i += 4)
              int.parse(hex.substring(i, i + 4), radix: 16),
          ];

          final wArr = fontWidths[fontId] ?? const [];
          final cmap = cmaps[fontId] ?? const {};
          final (currTx, currTy) = stack.last;
          var currX = currTx + x;
          final absY = currTy + y;

          for (final cid in cids) {
            final wPt = (cid < wArr.length ? wArr[cid] : 1000) / 1000 * size;
            final u = cmap[cid] ?? 0;
            glyphs.add(
              PageGlyph(
                char: String.fromCharCode(u),
                codePoint: u,
                x: currX,
                y: absY,
                fontId: fontId,
                fontSize: size,
              ),
            );
            currX += wPt;
          }
        }
      }
    }
    result.add(glyphs);
  }

  return result;
}

/// Groups glyphs on a page by baseline y (within 0.5pt), sorted from left to right.
List<List<PageGlyph>> groupGlyphsByLine(List<PageGlyph> pageGlyphs) {
  final linesMap = <double, List<PageGlyph>>{};
  for (final g in pageGlyphs) {
    double? matchingY;
    for (final y in linesMap.keys) {
      if ((y - g.y).abs() < 0.5) {
        matchingY = y;
        break;
      }
    }
    if (matchingY != null) {
      linesMap[matchingY]!.add(g);
    } else {
      linesMap[g.y] = [g];
    }
  }

  final lines = linesMap.values.toList();
  for (final line in lines) {
    line.sort((a, b) => a.x.compareTo(b.x));
  }
  return lines;
}

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
