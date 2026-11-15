import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Imports of every hand-written Dart file under [dir].
Map<String, List<String>> importsUnder(String dir) => {
  for (final f in Directory(dir).listSync(recursive: true).whereType<File>())
    if (f.path.endsWith('.dart') &&
        !f.path.endsWith('.g.dart') &&
        !f.path.contains('/l10n/gen/'))
      f.path: [
        for (final m in RegExp(
          r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''',
          multiLine: true,
        ).allMatches(f.readAsStringSync()))
          m.group(1)!,
      ],
};

List<String> violations(
  List<String> dirs,
  bool Function(String import) forbidden,
) => [
  for (final dir in dirs)
    for (final e in importsUnder(dir).entries)
      for (final i in e.value)
        if (forbidden(i)) '${e.key} → $i',
];

void main() {
  test('UI layers never import the database, DAOs, tables or drift', () {
    final bad = violations(
      ['lib/features', 'lib/widgets', 'lib/app'],
      (i) =>
          i.startsWith('package:drift') ||
          i.contains('/data/daos/') ||
          i.endsWith('/data/db.dart') ||
          i.endsWith('/data/tables.dart'),
    );
    expect(bad, isEmpty, reason: 'Go through lib/data/repositories:\n$bad');
  });

  test('core and domain are pure Dart (no Flutter, no drift)', () {
    final bad = violations(
      ['lib/core', 'lib/domain'],
      (i) =>
          i.startsWith('package:flutter') ||
          i.startsWith('dart:ui') ||
          i.startsWith('package:drift') ||
          i.contains('/data/') ||
          i.contains('/features/'),
    );
    expect(bad, isEmpty, reason: '$bad');
  });

  test('the account and sync seams stay UI-free', () {
    final dirs = [
      for (final d in ['lib/account', 'lib/sync'])
        if (Directory(d).existsSync()) d,
    ];
    final bad = violations(dirs, (i) => i.startsWith('package:flutter/'));
    expect(bad, isEmpty, reason: '$bad');
  });
}
