import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/sample_documents.dart';

/// A placed text run with its absolute page coordinates.
class PlacedRun {
  PlacedRun({
    required this.xMin,
    required this.xMax,
    required this.y,
    required this.fontId,
    required this.fontSize,
    required this.cids,
  });

  final double xMin;
  final double xMax;
  final double y;
  final int fontId;
  final double fontSize;
  final List<int> cids;

  double get width => xMax - xMin;

  @override
  String toString() =>
      '[x: ${xMin.toStringAsFixed(2)}..${xMax.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}, F$fontId ${fontSize}pt]';
}

/// Parses font width tables from an uncompressed or standard PDF.
Map<int, List<double>> parseFontWidths(String pdf) {
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

/// Decompresses and extracts content streams from a PDF.
List<String> extractContentStreams(Uint8List bytes) {
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
      streamBytes = Uint8List.fromList(ZLibCodec().decode(streamBytes));
    }
    final decoded = latin1.decode(streamBytes);
    if (decoded.contains('begincmap')) continue;
    streams.add(decoded);
  }
  return streams;
}

/// Parses placed text runs from a page content stream.
List<PlacedRun> parsePageRuns(
  String stream,
  Map<int, List<double>> fontWidths,
) {
  final runRe = RegExp(
    r'BT\s+/F(\d+)\s+([\d.]+)\s+Tf\s+[-\d.]+\s+Tc\s+([-\d.]+)\s+([-\d.]+)\s+Td\s+\[<([0-9a-f]+)>\]TJ\s+ET',
  );
  final cmRe = RegExp(r'1\s+0\s+0\s+1\s+([-\d.]+)\s+([-\d.]+)\s+cm');

  // Tokenize by instructions: q, Q, cm, BT ... ET
  final instructions = RegExp(
    r'(\bq\b|\bQ\b|1\s+0\s+0\s+1\s+[-\d.]+\s+[-\d.]+\s+cm|BT\s+/F\d+\s+[\d.]+\s+Tf\s+[-\d.]+\s+Tc\s+[-\d.]+\s+[-\d.]+\s+Td\s+\[<[0-9a-f]+>\]TJ\s+ET)',
  );

  final stack = <(double, double)>[(0.0, 0.0)];
  final runs = <PlacedRun>[];

  for (final m in instructions.allMatches(stream)) {
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
        final wPt =
            cids.fold<double>(
              0,
              (sum, c) => sum + (c < wArr.length ? wArr[c] : 1000),
            ) /
            1000 *
            size;

        final (currTx, currTy) = stack.last;
        final absX = currTx + x;
        final absY = currTy + y;

        runs.add(
          PlacedRun(
            xMin: absX,
            xMax: absX + wPt,
            y: absY,
            fontId: fontId,
            fontSize: size,
            cids: cids,
          ),
        );
      }
    }
  }

  return runs;
}

/// Checks that no two text runs on the same baseline overlap or touch.
///
/// On invoice documents, all legitimate inter-word gaps are ≥ 1.77pt, so
/// [minGap] defaults to 1.5pt (~2pt) to catch any overlapping or touching runs.
/// For contracts with attached punctuation (like `word،`), [minGap] can be set
/// lower (e.g. 0.2pt).
void expectNoOverlaps(
  Uint8List pdfBytes,
  String documentName, {
  double minGap = 1.5,
}) {
  final rawPdf = latin1.decode(pdfBytes);
  final fontWidths = parseFontWidths(rawPdf);
  final pages = extractContentStreams(pdfBytes);

  for (var pageIdx = 0; pageIdx < pages.length; pageIdx++) {
    final runs = parsePageRuns(pages[pageIdx], fontWidths);

    // Group runs that share the same baseline (within 0.5pt).
    final lines = <double, List<PlacedRun>>{};
    for (final r in runs) {
      double? matchingY;
      for (final y in lines.keys) {
        if ((y - r.y).abs() < 0.5) {
          matchingY = y;
          break;
        }
      }
      if (matchingY != null) {
        lines[matchingY]!.add(r);
      } else {
        lines[r.y] = [r];
      }
    }

    for (final entry in lines.entries) {
      final lineRuns = entry.value..sort((a, b) => a.xMin.compareTo(b.xMin));

      for (var i = 0; i + 1 < lineRuns.length; i++) {
        final left = lineRuns[i];
        final right = lineRuns[i + 1];
        final gap = right.xMin - left.xMax;

        expect(
          gap,
          greaterThanOrEqualTo(minGap),
          reason:
              '$documentName (page ${pageIdx + 1}, baseline y=${entry.key.toStringAsFixed(1)}): '
              'text runs touch or overlap: gap = ${gap.toStringAsFixed(4)}pt\n'
              '  left:  $left\n'
              '  right: $right',
        );
      }
    }
  }
}

void main() {
  final fonts = loadPdfFonts();

  group('PDF text overlap guard', () {
    for (final lang in DocLanguage.values) {
      for (final paid in [false, true]) {
        for (final scope in [false, true]) {
          test(
            'invoice: ${lang.name}, ${paid ? "paid" : "unpaid"}, scope: $scope has no overlapping or touching text',
            () async {
              final data = sampleInvoiceData(
                language: lang,
                status: paid ? InvoiceStatus.paid : InvoiceStatus.sent,
                paidDate: paid ? const CalendarDate(2026, 9, 20) : null,
                scope: scope,
              );
              final bytes = await buildInvoicePdf(data, fonts);
              expectNoOverlaps(
                bytes,
                'invoice_${lang.name}_${paid ? "paid" : "unpaid"}${scope ? "_scope" : ""}',
              );
            },
          );
        }
      }
    }

    test('sample contract has no overlapping text', () async {
      final bytes = await buildContractPdf(
        ContractPdfData(
          contract: acmeContract(),
          client: acme,
          settings: sampleSettings,
        ),
        fonts,
      );
      expectNoOverlaps(bytes, 'sample_contract', minGap: -0.01);
    });
  });
}
