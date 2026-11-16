// Regression test for B1 (Arabic words running together in PDFs).
//
// The vendored pdf package (third_party/pdf) mirrors RTL words by their pen
// advance instead of their ink box. Without that patch, a word ending in a
// letter whose final form overhangs to the left (ر، ز) is shifted into the
// following space. This test reads the laid-out word positions and glyph
// widths back out of an uncompressed PDF and checks every inter-word gap.
@Tags(['rtl'])
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const _phrases = [
  'تصميم وتطوير التطبيق ولوحة التحكم',
  'لن تظهر في الفواتير القادمة',
  'يجوز سداد البنود الدولارية بالجنيه',
  'التطوير والتنفيذ بإشعار قبلها',
  'عقد وعد بند جديد',
];

/// One `BT … Td [<cids>]TJ ET` text run from a page content stream.
class _Run {
  _Run(this.x, this.size, this.cids);
  final double x;
  final double size;
  final List<int> cids;
}

final _runRe = RegExp(
  r'BT /F\d+ ([\d.]+) Tf [-\d.]+ Tc ([-\d.]+) ([-\d.]+) Td \[<([0-9a-f]+)>\]TJ ET',
);

List<_Run> _runs(String pdf) => [
  for (final m in _runRe.allMatches(pdf))
    _Run(double.parse(m[2]!), double.parse(m[1]!), [
      for (var i = 0; i < m[4]!.length; i += 4)
        int.parse(m[4]!.substring(i, i + 4), radix: 16),
    ]),
];

/// The font's `/W` array (CID → width in 1/1000 em), as written by the
/// pdf package: `/W[0 N 0 R]` pointing at a flat array object.
List<double> _widths(String pdf) {
  final ref = RegExp(r'/W\[0 (\d+) 0 R\]').firstMatch(pdf)![1];
  final arr = RegExp('\n$ref 0 obj\n?\\[([^\\]]*)\\]').firstMatch(pdf)![1]!;
  return arr.trim().split(RegExp(r'\s+')).map(double.parse).toList();
}

Future<String> _render(pw.Font font, String text, double size) async {
  final doc = pw.Document(compress: false)
    ..addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        textDirection: pw.TextDirection.rtl,
        build: (_) => pw.Text(
          text,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(font: font, fontSize: size),
        ),
      ),
    );
  return String.fromCharCodes(await doc.save());
}

void main() {
  for (final weight in ['Regular', 'SemiBold', 'Bold']) {
    final bytes = ByteData.sublistView(
      File('assets/fonts/IBMPlexSansArabic-$weight.ttf').readAsBytesSync(),
    );
    final font = pw.Font.ttf(bytes);
    final space = _spaceAdvance(bytes);

    for (final size in [8.0, 9.5, 14.0, 26.0]) {
      test('IBM Plex Sans Arabic $weight ${size}pt: every RTL gap is one '
          'space', () async {
        for (final phrase in _phrases) {
          final pdf = await _render(font, phrase, size);
          final widths = _widths(pdf);
          final runs = _runs(pdf);
          expect(runs, hasLength(phrase.split(' ').length), reason: phrase);
          // Runs are written in logical order: each next word sits to the
          // left of the previous one.
          for (var i = 0; i + 1 < runs.length; i++) {
            final right = runs[i];
            final left = runs[i + 1];
            final leftAdvance =
                left.cids.fold<double>(0, (a, c) => a + widths[c]) /
                1000 *
                size;
            final gap = right.x - (left.x + leftAdvance);
            // /W widths are rounded to 1/1000 em per glyph; the bug moves
            // a gap by 0.05–0.15 em, far outside this tolerance.
            final tolerance = 0.0006 * size * left.cids.length + 0.01;
            expect(
              gap,
              closeTo(space * size, tolerance),
              reason: '"$phrase", gap after word ${i + 1}',
            );
          }
        }
      });
    }
  }
}

double _spaceAdvance(ByteData bytes) {
  final ttf = TtfParser(bytes);
  return ttf.glyphInfoMap[ttf.charToGlyphIndexMap[0x20]]!.advanceWidth;
}
