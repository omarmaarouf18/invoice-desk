// Licence report for the packages that ship in the app (dependencies and
// their transitive closure; dev dependencies excluded). Fails on GPL or
// AGPL unless the package is in [allowList].
//
//   dart run tool/check_licenses.dart            # table + gate
//   dart run tool/check_licenses.dart --markdown # for the CI summary
import 'dart:convert';
import 'dart:io';

/// Packages allowed despite a copyleft licence, with the reason.
const allowList = <String, String>{};

String classify(String text) {
  final t = text.toUpperCase();
  if (t.contains('GNU AFFERO GENERAL PUBLIC LICENSE')) return 'AGPL';
  if (t.contains('GNU LESSER GENERAL PUBLIC LICENSE')) return 'LGPL';
  if (t.contains('GNU GENERAL PUBLIC LICENSE')) return 'GPL';
  if (t.contains('MOZILLA PUBLIC LICENSE')) return 'MPL-2.0';
  if (t.contains('APACHE LICENSE')) return 'Apache-2.0';
  if (t.contains('PERMISSION IS HEREBY GRANTED, FREE OF CHARGE')) return 'MIT';
  if (t.contains('REDISTRIBUTION AND USE IN SOURCE AND BINARY FORMS')) {
    return 'BSD';
  }
  if (t.contains('ZLIB')) return 'Zlib';
  return 'unknown';
}

void main(List<String> args) {
  final deps =
      jsonDecode(
            Process.runSync('dart', [
                  'pub',
                  'deps',
                  '--json',
                ], runInShell: true).stdout
                as String,
          )
          as Map<String, dynamic>;
  final packages = {
    for (final p in deps['packages'] as List)
      (p as Map<String, dynamic>)['name'] as String: p,
  };
  final root = deps['root'] as String;
  final rootPkg = packages[root]!;
  // Shipped = closure of the root's non-dev dependencies.
  final directDeps = (rootPkg['directDependencies'] as List?)?.cast<String>();
  final devDeps = (rootPkg['devDependencies'] as List?)?.cast<String>() ?? [];
  final start = (directDeps ?? (rootPkg['dependencies'] as List).cast<String>())
      .where((d) => !devDeps.contains(d));
  final shipped = <String>{};
  final todo = [...start];
  while (todo.isNotEmpty) {
    final n = todo.removeLast();
    if (!shipped.add(n)) continue;
    final p = packages[n];
    if (p == null) continue;
    todo.addAll(((p['dependencies'] as List?) ?? const []).cast<String>());
  }

  final config =
      jsonDecode(File('.dart_tool/package_config.json').readAsStringSync())
          as Map<String, dynamic>;
  final roots = {
    for (final p in config['packages'] as List)
      (p as Map)['name'] as String: Uri.parse(p['rootUri'] as String),
  };

  final rows = <(String, String, String)>[];
  final bad = <String>[];
  for (final name in shipped.toList()..sort()) {
    final p = packages[name]!;
    if (p['source'] == 'sdk' || name == root) continue;
    final uri = roots[name];
    var licence = 'unknown';
    if (uri != null && uri.scheme == 'file') {
      final dir = Directory.fromUri(uri);
      final file = dir
          .listSync()
          .whereType<File>()
          .where(
            (f) => RegExp(
              r'(^|/)(LICENSE|LICENCE|COPYING)(\.\w+)?$',
              caseSensitive: false,
            ).hasMatch(f.path),
          )
          .firstOrNull;
      if (file != null) licence = classify(file.readAsStringSync());
    }
    rows.add((name, p['version'] as String? ?? '', licence));
    if ((licence == 'GPL' || licence == 'AGPL') &&
        !allowList.containsKey(name)) {
      bad.add('$name ($licence)');
    }
  }

  final md = args.contains('--markdown');
  final out = StringBuffer();
  if (md) {
    out
      ..writeln('### Licences of shipped dependencies (${rows.length})')
      ..writeln()
      ..writeln('| Package | Version | Licence |')
      ..writeln('|---|---|---|');
    for (final (n, v, l) in rows) {
      out.writeln('| $n | $v | $l |');
    }
  } else {
    final counts = <String, int>{};
    for (final r in rows) {
      counts[r.$3] = (counts[r.$3] ?? 0) + 1;
    }
    out.writeln(
      'licences: ${rows.length} shipped packages — '
      '${counts.entries.map((e) => '${e.key} ${e.value}').join(', ')}',
    );
    for (final (n, v, _) in rows.where((r) => r.$3 == 'unknown')) {
      out.writeln('  unknown: $n $v');
    }
  }
  stdout.write(out);
  final summary = Platform.environment['GITHUB_STEP_SUMMARY'];
  if (md && summary != null) {
    File(summary).writeAsStringSync(out.toString(), mode: FileMode.append);
  }
  if (bad.isNotEmpty) {
    stderr.writeln('copyleft licences in shipped deps: ${bad.join(', ')}');
    exitCode = 1;
  }
}
