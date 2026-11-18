import 'package:flutter_test/flutter_test.dart';

import '../../tool/release.dart';

const _pubspec = 'name: invoice_desk\nversion: 0.5.0+6\npublish_to: none\n';
const _changelog = '''
# Changelog

## [Unreleased]

## [0.5.0] - 2026-11-20

### Added
- English UI.

## [0.4.0] - 2026-11-16

- Calendar.

[0.5.0]: https://example.invalid/compare
''';

Map<String, String> _allSums() => {
  for (final (i, a) in releaseAssets.indexed)
    a.name: i.toRadixString(16).padLeft(64, '0'),
};

void main() {
  group('verify', () {
    test('accepts the matching tag and returns the version', () {
      expect(
        verify(tag: 'v0.5.0', pubspec: _pubspec, changelog: _changelog),
        '0.5.0',
      );
    });

    test('rejects a tag that differs from pubspec', () {
      expect(
        () => verify(tag: 'v0.5.1', pubspec: _pubspec, changelog: _changelog),
        throwsA(
          isA<ReleaseError>().having(
            (e) => e.message,
            'message',
            contains('expected v0.5.0'),
          ),
        ),
      );
    });

    test('rejects a tag that is not vX.Y.Z', () {
      for (final tag in ['0.5.0', 'v0.5', 'v0.5.0-rc1', 'release']) {
        expect(
          () => verify(tag: tag, pubspec: _pubspec, changelog: _changelog),
          throwsA(isA<ReleaseError>()),
        );
      }
    });

    test('rejects a version without a CHANGELOG section', () {
      const pubspec = 'version: 0.6.0+7\n';
      expect(
        () => verify(tag: 'v0.6.0', pubspec: pubspec, changelog: _changelog),
        throwsA(
          isA<ReleaseError>().having(
            (e) => e.message,
            'message',
            contains('## [0.6.0]'),
          ),
        ),
      );
    });
  });

  group('changelogSection', () {
    test('stops at the next heading', () {
      expect(changelogSection(_changelog, '0.5.0'), '### Added\n- English UI.');
    });

    test('stops at the link references', () {
      expect(changelogSection(_changelog, '0.4.0'), '- Calendar.');
    });

    test('does not match a longer version with the same prefix', () {
      const text = '## [0.5.10] - 2027-01-01\n\n- x\n';
      expect(
        () => changelogSection(text, '0.5.1'),
        throwsA(isA<ReleaseError>()),
      );
    });

    test('an empty section fails', () {
      expect(
        () => changelogSection(_changelog, 'Unreleased'),
        throwsA(isA<ReleaseError>()),
      );
    });
  });

  test('parseChecksums reads sha256sum text and binary mode', () {
    final a = 'a' * 64;
    final b = 'b' * 64;
    expect(parseChecksums('$a  one.exe\n$b *two.zip\n\n'), {
      'one.exe': a,
      'two.zip': b,
    });
    expect(() => parseChecksums('nonsense'), throwsA(isA<ReleaseError>()));
  });

  group('buildManifest', () {
    Map<String, Object> build(Map<String, String> sums) => buildManifest(
      version: '0.5.0',
      date: '2026-11-20',
      notes: 'notes',
      repo: 'omarmaarouf18/invoice-desk',
      checksums: sums,
      sizes: {for (final n in sums.keys) n: 1000},
    );

    test('lists every asset with a versioned download URL', () {
      final m = build(_allSums());
      expect(m['schema'], 1);
      expect(m['version'], '0.5.0');
      final assets = (m['assets']! as List).cast<Map<String, Object>>();
      expect(assets.map((a) => a['name']), releaseAssets.map((a) => a.name));
      expect(
        assets.first['url'],
        'https://github.com/omarmaarouf18/invoice-desk/releases/download/v0.5.0/InvoiceDesk-Setup-x64.exe',
      );
      expect(assets.first['size'], 1000);
    });

    test('asset names carry no version (stable latest/download URLs)', () {
      for (final a in releaseAssets) {
        expect(a.name, isNot(contains(RegExp(r'\d+\.\d+\.\d+'))));
      }
    });

    test('a missing platform fails', () {
      final sums = _allSums()..remove('InvoiceDesk-macOS.dmg');
      expect(
        () => build(sums),
        throwsA(
          isA<ReleaseError>().having(
            (e) => e.message,
            'message',
            contains('InvoiceDesk-macOS.dmg'),
          ),
        ),
      );
    });

    test('a stray file such as the MSIX fails', () {
      final sums = _allSums()..['InvoiceDesk-x64.msix'] = 'c' * 64;
      expect(() => build(sums), throwsA(isA<ReleaseError>()));
    });
  });
}
