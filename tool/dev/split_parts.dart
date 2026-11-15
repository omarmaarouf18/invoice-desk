// Dev helper (not part of the app): moves top-level declarations of a
// library into `part` files.
//   dart run tool/dev/split_parts.dart lib/x.dart x/a.dart=A,_B x/c.dart=C
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;

String nameOf(CompilationUnitMember d, String src) {
  final text = src.substring(
    d.firstTokenAfterCommentAndMetadata.offset,
    d.end,
  );
  final type = RegExp(
    r'^(?:(?:abstract|final|sealed|base|interface)\s+)*'
    r'(?:class|enum|mixin|typedef|extension)\s+(\w+)',
  ).firstMatch(text);
  if (type != null) return type.group(1)!;
  final fn = RegExp(r'(\w+)\s*(?:<[^>()]*>)?\s*[(=]').firstMatch(
    text.split('\n').first,
  );
  return fn?.group(1) ?? '';
}

void main(List<String> args) {
  final lib = File(args.first);
  final src = lib.readAsStringSync();
  final unit = parseString(content: src).unit;
  final wanted = <String, String>{};
  for (final spec in args.skip(1)) {
    final [file, names] = spec.split('=');
    for (final n in names.split(',')) {
      wanted[n] = file;
    }
  }
  final chunks = <String, List<String>>{};
  final cuts = <(int, int)>[];
  for (final d in unit.declarations) {
    final n = nameOf(d, src);
    final target = wanted.remove(n);
    if (target == null) continue;
    final start = d.offset; // includes the doc comment
    var end = d.end;
    while (end < src.length && src[end] == '\n') {
      end++;
    }
    (chunks[target] ??= []).add(src.substring(start, d.end));
    cuts.add((start, end));
  }
  if (wanted.isNotEmpty) {
    stderr.writeln('not found: ${wanted.keys}');
    exit(1);
  }
  var out = src;
  for (final (s, e) in cuts.reversed) {
    out = out.substring(0, s) + out.substring(e);
  }
  // `part` directives after the last import.
  final lastDirective = unit.directives.last;
  final parts = chunks.keys.map((f) => "part '$f';").join('\n');
  out =
      '${out.substring(0, lastDirective.end)}\n\n$parts'
      '${out.substring(lastDirective.end)}';
  lib.writeAsStringSync(out);
  for (final e in chunks.entries) {
    final path = p.join(p.dirname(lib.path), e.key);
    Directory(p.dirname(path)).createSync(recursive: true);
    final rel = p.relative(lib.path, from: p.dirname(path));
    File(path).writeAsStringSync(
      "part of '$rel';\n\n${e.value.join('\n\n')}\n",
    );
  }
}
