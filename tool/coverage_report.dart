// Coverage per layer from coverage/lcov.info, as a Markdown table (for the
// CI job summary), and the gates: lib/core, lib/domain and the money,
// numbering and migration code must stay at or above 90% line coverage.
// No global percentage gate.
//
//   dart run tool/coverage_report.dart [coverage/lcov.info]
import 'dart:io';

const gate = 90.0;

/// Layers, most specific first.
const layers = [
  'lib/core',
  'lib/domain',
  'lib/data/repositories',
  'lib/data',
  'lib/pdf',
  'lib/account',
  'lib/sync',
  'lib/features',
  'lib/widgets',
  'lib/app',
  'lib/theme',
];

/// Files gated besides lib/core and lib/domain (money, numbering,
/// migrations). Money and numbering live in core/domain, so they are
/// already covered by those gates; these add the data-side code.
const gatedFiles = [
  'lib/data/db.dart', // migrations
  'lib/data/daos/invoices_dao.dart', // invoice numbering
  'lib/data/daos/contracts_dao.dart', // contract numbering
];

bool _generated(String f) =>
    f.endsWith('.g.dart') ||
    f.endsWith('.steps.dart') ||
    f.contains('/l10n/gen/');

void main(List<String> args) {
  final path = args.isEmpty ? 'coverage/lcov.info' : args.first;
  final files = <String, (int, int)>{}; // file -> (hit, found)
  String? current;
  var hit = 0;
  var found = 0;
  for (final line in File(path).readAsLinesSync()) {
    if (line.startsWith('SF:')) {
      current = line.substring(3).replaceFirst(RegExp('^.*?(?=lib/)'), '');
      hit = 0;
      found = 0;
    } else if (line.startsWith('DA:')) {
      found++;
      if (!line.endsWith(',0')) hit++;
    } else if (line == 'end_of_record' && current != null) {
      if (!_generated(current)) files[current] = (hit, found);
      current = null;
    }
  }

  double pct((int, int) v) => v.$2 == 0 ? 100 : v.$1 * 100 / v.$2;
  (int, int) sum(Iterable<(int, int)> xs) =>
      xs.fold((0, 0), (a, b) => (a.$1 + b.$1, a.$2 + b.$2));

  final byLayer = <String, List<(int, int)>>{};
  for (final e in files.entries) {
    final layer = layers.firstWhere(
      (l) => e.key.startsWith('$l/'),
      orElse: () => 'lib (other)',
    );
    (byLayer[layer] ??= []).add(e.value);
  }

  final out = StringBuffer()
    ..writeln('### Coverage by layer')
    ..writeln()
    ..writeln('| Layer | Lines | Covered | % |')
    ..writeln('|---|---:|---:|---:|');
  for (final l in [...layers, 'lib (other)']) {
    final v = byLayer[l];
    if (v == null) continue;
    final s = sum(v);
    out.writeln('| `$l` | ${s.$2} | ${s.$1} | ${pct(s).toStringAsFixed(1)} |');
  }
  final total = sum(files.values);
  out
    ..writeln(
      '| **all (excl. generated)** | ${total.$2} | ${total.$1} | '
      '${pct(total).toStringAsFixed(1)} |',
    )
    ..writeln()
    ..writeln('### Gates (≥ ${gate.toStringAsFixed(0)}%)')
    ..writeln();

  final failures = <String>[];
  void check(String name, (int, int) v) {
    final p = pct(v);
    final ok = p >= gate;
    if (!ok) failures.add(name);
    out.writeln('- ${ok ? '✅' : '❌'} `$name`: ${p.toStringAsFixed(1)}%');
  }

  for (final l in ['lib/core', 'lib/domain']) {
    check(l, sum(byLayer[l] ?? const []));
  }
  for (final f in gatedFiles) {
    final v = files[f];
    if (v != null) check(f, v);
  }
  stdout.write(out);
  final summary = Platform.environment['GITHUB_STEP_SUMMARY'];
  if (summary != null) {
    File(summary).writeAsStringSync(out.toString(), mode: FileMode.append);
  }
  if (failures.isNotEmpty) {
    stderr.writeln('coverage gate failed: ${failures.join(', ')}');
    exitCode = 1;
  }
}
