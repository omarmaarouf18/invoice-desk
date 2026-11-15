// Dev helper: moves methods of one class into `extension` blocks in part
// files of the same library.
//   dart run tool/dev/split_members.dart lib/x.dart _Builder \
//       x/header.dart=header,parties
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  final lib = File(args[0]);
  final className = args[1];
  final src = lib.readAsStringSync();
  final unit = parseString(content: src).unit;
  final wanted = <String, String>{};
  for (final spec in args.skip(2)) {
    final [file, names] = spec.split('=');
    for (final n in names.split(',')) {
      wanted[n] = file;
    }
  }
  final cls = unit.declarations.whereType<ClassDeclaration>().firstWhere(
    (c) => src
        .substring(c.firstTokenAfterCommentAndMetadata.offset, c.end)
        .startsWith(RegExp('class\\s+$className\\b')),
  );
  final chunks = <String, List<String>>{};
  final cuts = <(int, int)>[];
  final methods = <MethodDeclaration>[];
  cls.accept(_Collect(cls, methods));
  for (final m in methods) {
    final target = wanted.remove(m.name.lexeme);
    if (target == null) continue;
    var start = m.offset;
    while (start > 0 && src[start - 1] == ' ') {
      start--;
    }
    var end = m.end;
    while (end < src.length && src[end] == '\n') {
      end++;
    }
    (chunks[target] ??= []).add(src.substring(start, m.end));
    cuts.add((start, end));
  }
  if (wanted.isNotEmpty) {
    stderr.writeln('not found: ${wanted.keys}');
    exit(1);
  }
  cuts.sort((a, b) => a.$1.compareTo(b.$1));
  var out = src;
  for (final (s, e) in cuts.reversed) {
    out = out.substring(0, s) + out.substring(e);
  }
  final last = unit.directives.last;
  final parts = chunks.keys.map((f) => "part '$f';").join('\n');
  out = '${out.substring(0, last.end)}\n$parts${out.substring(last.end)}';
  lib.writeAsStringSync(out);
  for (final e in chunks.entries) {
    final path = p.join(p.dirname(lib.path), e.key);
    Directory(p.dirname(path)).createSync(recursive: true);
    final rel = p.relative(lib.path, from: p.dirname(path));
    final stem = p
        .basenameWithoutExtension(e.key)
        .split('_')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join();
    File(path).writeAsStringSync(
      "part of '$rel';\n\nextension _$stem on $className {\n"
      '${e.value.join('\n\n')}\n}\n',
    );
  }
}

class _Collect extends RecursiveAstVisitor<void> {
  _Collect(this.cls, this.out);
  final ClassDeclaration cls;
  final List<MethodDeclaration> out;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.thisOrAncestorOfType<ClassDeclaration>() == cls) out.add(node);
  }
}
