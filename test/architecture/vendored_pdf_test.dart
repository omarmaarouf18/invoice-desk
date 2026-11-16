// Guards the vendored, patched pdf package (third_party/pdf, ADR-0013).
//
// Fails when pub resolves pdf from anywhere else, when the vendored copy and
// the pin drift apart, or when the RTL advance-width patch is not applied.
@Tags(['rtl'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _vendoredVersion = '3.13.1';

String? _match(String source, String pattern) =>
    RegExp(pattern, multiLine: true).firstMatch(source)?.group(1);

void main() {
  final lock = File('pubspec.lock').readAsStringSync();
  final pubspec = File('pubspec.yaml').readAsStringSync();
  final vendoredPubspec = File(
    'third_party/pdf/pubspec.yaml',
  ).readAsStringSync();

  test('pubspec.lock resolves pdf from third_party/pdf', () {
    final entry = _match(lock, r'^  pdf:\n((?:    .*\n)+)');
    expect(entry, isNotNull, reason: 'no pdf entry in pubspec.lock');
    expect(entry, contains('source: path'));
    expect(entry, contains('path: "third_party/pdf"'));
    expect(_match(entry!, 'version: "([^"]+)"'), _vendoredVersion);
  });

  test('vendored copy, pin and override agree on the version', () {
    expect(_match(vendoredPubspec, r'^version: (\S+)'), _vendoredVersion);
    expect(_match(pubspec, r'^  pdf: (\S+)$'), _vendoredVersion);
    expect(
      pubspec,
      contains('dependency_overrides:\n'),
      reason: 'the override is what makes pub use the patched copy',
    );
    expect(pubspec, contains('    path: third_party/pdf\n'));
  });

  test('the RTL advance-width patch is applied', () {
    final source = File(
      'third_party/pdf/lib/src/widgets/text.dart',
    ).readAsStringSync();
    final added = File('third_party/pdf/rtl-advance-width.patch')
        .readAsLinesSync()
        .where((l) => l.startsWith('+') && !l.startsWith('+++'))
        .map((l) => l.substring(1))
        .where((l) => l.trim().isNotEmpty);
    for (final line in added) {
      expect(source, contains(line), reason: 'patch line missing: $line');
    }
    expect(
      source,
      isNot(contains('delta - (span.offset.x + span.width),')),
      reason: 'unpatched RTL mirroring is back',
    );
  });
}
