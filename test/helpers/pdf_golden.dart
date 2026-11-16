import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// The page content streams of [pdf], inflated, in file order.
///
/// This is every drawing operator: glyph ids, positions, colours, rules.
/// It does not depend on a rasteriser or on system fonts, so it is stable
/// across machines, and any layout change (one glyph moving by 0.01 pt)
/// shows up as a readable text diff.
///
/// Page dictionaries sit inside compressed object streams, so content
/// streams are recognised by their own dictionary instead: no /Type,
/// /Subtype or /Length1 (fonts, images, object and xref streams have one),
/// and not a ToUnicode CMap.
String pdfContentDump(Uint8List pdf) {
  final text = latin1.decode(pdf);
  final out = StringBuffer();
  var n = 0;
  for (final head in RegExp(
    r'\d+ 0 obj\s*<<((?:(?!>>\s*stream|endobj).)*)>>\s*stream\r?\n',
    dotAll: true,
  ).allMatches(text)) {
    final dict = head[1]!;
    if (RegExp('/Type|/Subtype|/Length1').hasMatch(dict)) continue;
    final end = text.indexOf('endstream', head.end);
    var data = pdf.sublist(head.end, end);
    if (dict.contains('/FlateDecode')) {
      data = Uint8List.fromList(ZLibCodec().decode(data));
    }
    if (latin1.decode(data).contains('begincmap')) continue;
    out
      ..writeln('%% content stream ${++n}')
      // One text run (BT … ET) per line keeps diffs readable.
      ..writeln(
        latin1
            .decode(data)
            .trim()
            .replaceAll(RegExp(r'\s*\bBT\b'), '\nBT')
            .replaceAll(RegExp(r'\bET\b\s*'), 'ET\n')
            .trim(),
      );
  }
  return out.toString();
}

/// Compares [pdf]'s content dump with `test/pdf/goldens/[name].txt`;
/// `flutter test --update-goldens` rewrites it.
void expectPdfGolden(Uint8List pdf, String name) {
  final file = File('test/pdf/goldens/$name.txt');
  final actual = pdfContentDump(pdf);
  expect(actual, contains('TJ'), reason: 'no page content found in the PDF');
  if (autoUpdateGoldenFiles) {
    file
      ..createSync(recursive: true)
      ..writeAsStringSync(actual);
    return;
  }
  expect(file.existsSync(), isTrue, reason: '${file.path} missing');
  final expected = file.readAsStringSync();
  if (expected == actual) return;
  final a = actual.split('\n');
  final e = expected.split('\n');
  var line = 0;
  while (line < a.length && line < e.length && a[line] == e[line]) {
    line++;
  }
  fail(
    '${file.path} differs at line ${line + 1}:\n'
    '  expected: ${line < e.length ? e[line] : '<end>'}\n'
    '  actual:   ${line < a.length ? a[line] : '<end>'}',
  );
}
