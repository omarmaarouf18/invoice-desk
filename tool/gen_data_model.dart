// Regenerates the schema reference in docs/DATA_MODEL.md from the newest
// drift snapshot (drift_schemas/app_db/drift_schema_vN.json): every table,
// column, constraint, index and trigger. Text outside the
// `<!-- generated:start -->` / `<!-- generated:end -->` markers is kept.
//
//   dart run tool/gen_data_model.dart          # write
//   dart run tool/gen_data_model.dart --check  # fail if out of date
import 'dart:convert';
import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

const _start = '<!-- generated:start -->';
const _end = '<!-- generated:end -->';

/// Splits a CREATE TABLE body into its top-level comma-separated parts.
List<String> _parts(String body) {
  final out = <String>[];
  var depth = 0;
  var quote = false;
  final cur = StringBuffer();
  for (final ch in body.split('')) {
    if (ch == "'") quote = !quote;
    if (!quote && ch == '(') depth++;
    if (!quote && ch == ')') depth--;
    if (!quote && depth == 0 && ch == ',') {
      out.add(cur.toString().trim());
      cur.clear();
    } else {
      cur.write(ch);
    }
  }
  if (cur.isNotEmpty) out.add(cur.toString().trim());
  return out;
}

String _md(String s) => s.replaceAll('|', r'\|');

void main(List<String> args) {
  final snaps =
      Directory('drift_schemas/app_db')
          .listSync()
          .whereType<File>()
          .where((f) => RegExp(r'drift_schema_v\d+\.json$').hasMatch(f.path))
          .toList()
        ..sort((a, b) {
          int v(File f) =>
              int.parse(RegExp(r'v(\d+)\.json$').firstMatch(f.path)!.group(1)!);
          return v(a).compareTo(v(b));
        });
  final latest = snaps.last;
  final version = RegExp(r'v(\d+)\.json$').firstMatch(latest.path)!.group(1);
  final json = jsonDecode(latest.readAsStringSync()) as Map<String, dynamic>;
  final db = sqlite3.openInMemory();
  final ddl = <String, String>{};
  for (final e in json['fixed_sql'] as List) {
    final m = e as Map<String, dynamic>;
    final sql = ((m['sql'] as List).first as Map)['sql'] as String;
    ddl[m['name'] as String] = sql;
  }
  // Tables first, then indexes and triggers.
  for (final kind in ['TABLE', 'INDEX', 'TRIGGER']) {
    ddl.values.where((s) => s.contains('CREATE $kind')).forEach(db.execute);
  }

  final b = StringBuffer()
    ..writeln(_start)
    ..writeln()
    ..writeln(
      '_Generated from `${latest.path}` (schema v$version) by '
      '`dart run tool/gen_data_model.dart`. Do not edit by hand._',
    )
    ..writeln();
  final tables = db
      .select(
        "SELECT name, sql FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%' ORDER BY rowid",
      )
      .toList();
  for (final t in tables) {
    final name = t['name'] as String;
    final sql = t['sql'] as String;
    final body = sql.substring(sql.indexOf('(') + 1, sql.lastIndexOf(')'));
    final parts = _parts(body);
    b
      ..writeln(
        '### `$name`${sql.trim().endsWith('STRICT') ? ' (STRICT)' : ''}',
      )
      ..writeln()
      ..writeln('| Column | Type | Null | Default | Constraints |')
      ..writeln('|---|---|---|---|---|');
    for (final c in db.select('PRAGMA table_info("$name")')) {
      final col = c['name'] as String;
      final def = parts.firstWhere(
        (p) => p.startsWith('"$col" '),
        orElse: () => '',
      );
      final extra = [
        if (c['pk'] != 0) 'PK',
        for (final m in RegExp(
          r'(CHECK\s*\(.*\)|REFERENCES [^,]*|UNIQUE)',
        ).allMatches(def))
          m.group(0)!.trim(),
      ].join('; ');
      b.writeln(
        '| `$col` | ${c['type']} | ${c['notnull'] == 1 ? 'no' : 'yes'} | '
        '${_md('${c['dflt_value'] ?? ''}')} | ${_md(extra)} |',
      );
    }
    final tableLevel = parts.where(
      (p) => p.startsWith('UNIQUE') || p.startsWith('CHECK'),
    );
    if (tableLevel.isNotEmpty) {
      b
        ..writeln()
        ..writeln(
          'Table constraints: ${tableLevel.map((p) => '`$p`').join(', ')}',
        );
    }
    final idx = db
        .select(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          'AND tbl_name = ? AND sql IS NOT NULL ORDER BY name',
          [name],
        )
        .map((r) => r['name'] as String);
    for (final i in idx) {
      final cols = db
          .select('PRAGMA index_info("$i")')
          .map((r) => r['name'])
          .join(', ');
      b.writeln('\nIndex `$i` on ($cols).');
    }
    b.writeln();
  }
  b
    ..writeln('### Triggers')
    ..writeln();
  for (final r in db.select(
    "SELECT name, tbl_name, sql FROM sqlite_master WHERE type = 'trigger' "
    'ORDER BY name',
  )) {
    b
      ..writeln('**`${r['name']}`** on `${r['tbl_name']}`')
      ..writeln()
      ..writeln('```sql')
      ..writeln(r['sql'])
      ..writeln('```')
      ..writeln();
  }
  b.writeln(_end);
  db.close();

  final doc = File('docs/DATA_MODEL.md');
  final old = doc.existsSync() ? doc.readAsStringSync() : '$_start\n$_end\n';
  final s = old.indexOf(_start);
  final e = old.indexOf(_end) + _end.length;
  final updated =
      '${old.substring(0, s)}${b.toString().trimRight()}${old.substring(e)}';
  if (args.contains('--check')) {
    if (updated != old) {
      stderr.writeln(
        'docs/DATA_MODEL.md is out of date: run '
        'dart run tool/gen_data_model.dart',
      );
      exitCode = 1;
    }
    return;
  }
  doc.writeAsStringSync(updated);
  stdout.writeln('wrote docs/DATA_MODEL.md (schema v$version)');
}
