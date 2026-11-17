import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/style_file.dart';

void main() {
  final logo = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 1, 2, 3]);

  test('round-trips name, base preset, style and logo', () {
    final file = StyleFile(
      name: 'Acme brand',
      basePreset: 'modern',
      style: DocPreset.modern.style.copyWith(footerTextEn: 'Thanks'),
      logo: logo,
      logoMime: 'image/png',
    );
    final back = StyleFile.decode(file.encode());
    expect(back.name, 'Acme brand');
    expect(back.basePreset, 'modern');
    expect(back.style, file.style);
    expect(back.logo, logo);
    expect(back.logoMime, 'image/png');
  });

  test('never writes or reads a machine-local logo asset id', () {
    const file = StyleFile(
      name: 'x',
      style: DocumentStyle(logoAssetId: 'abc123'),
    );
    expect(file.encode(), isNot(contains('abc123')));
    final raw = jsonEncode({
      'format': styleFileFormat,
      'version': 1,
      'style': {'logoAssetId': 'abc123'},
    });
    expect(StyleFile.decode(raw).style.logoAssetId, isNull);
  });

  test('rejects what is not a style file', () {
    for (final raw in [
      'not json',
      '[]',
      '{}',
      jsonEncode({
        'format': 'other',
        'version': 1,
        'style': <String, Object>{},
      }),
      jsonEncode({
        'format': styleFileFormat,
        'version': 2,
        'style': <String, Object>{},
      }),
      jsonEncode({
        'format': styleFileFormat,
        'version': '1',
        'style': <String, Object>{},
      }),
      jsonEncode({'format': styleFileFormat, 'version': 1}),
    ]) {
      expect(() => StyleFile.decode(raw), throwsFormatException, reason: raw);
    }
  });

  test('clamps out-of-range values and drops a broken logo', () {
    final raw = jsonEncode({
      'format': styleFileFormat,
      'version': 1,
      'name': '  Padded  ',
      'style': {'baseSize': 99, 'tableStyle': 'neon', 'extra': true},
      'logo': {'mime': 'image/png', 'base64': '!!not base64!!'},
    });
    final f = StyleFile.decode(raw);
    expect(f.name, 'Padded');
    expect(f.style.baseSize, 14);
    expect(f.style.tableStyle, TableStyle.plain);
    expect(f.logo, isNull);
  });

  test('fuzz: random style payloads decode or throw FormatException', () {
    final rnd = Random(7);
    Object? junk(int depth) => switch (rnd.nextInt(depth > 2 ? 5 : 7)) {
      0 => rnd.nextInt(1 << 32) - (1 << 31),
      1 => rnd.nextDouble() * 1e6,
      2 => String.fromCharCodes(
        List.generate(rnd.nextInt(8), (_) => 32 + rnd.nextInt(1500)),
      ),
      3 => rnd.nextBool(),
      4 => null,
      5 => [for (var i = 0; i < 3; i++) junk(depth + 1)],
      _ => {for (var i = 0; i < 4; i++) 'k$i': junk(depth + 1)},
    };
    const keys = [
      'primary', 'ink', 'baseSize', 'scale', 'fontFamily', 'headerStyle', //
      'blockOrder', 'logoSize', 'footerTextAr', 'showNotes', 'paper',
    ];
    for (var i = 0; i < 500; i++) {
      final raw = jsonEncode({
        'format': styleFileFormat,
        'version': 1,
        'name': junk(0),
        'basePreset': junk(0),
        'style': {
          for (final k in keys)
            if (rnd.nextBool()) k: junk(1),
        },
        if (rnd.nextBool()) 'logo': junk(0),
      });
      try {
        StyleFile.decode(raw);
      } on FormatException {
        // Allowed.
      }
    }
  });
}
