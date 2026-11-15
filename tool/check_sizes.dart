// Fails when a hand-written Dart file is over [maxFileLines] lines or a
// `build` method is over [maxBuildLines] lines. Generated code is skipped.
//
//   dart run tool/check_sizes.dart          # lib/
//   dart run tool/check_sizes.dart --report # print all, never fail
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

const maxFileLines = 500;
const maxBuildLines = 80;

bool isGenerated(String path) =>
    path.endsWith('.g.dart') ||
    path.endsWith('.steps.dart') ||
    path.contains('/l10n/gen/');

class _Builds extends RecursiveAstVisitor<void> {
  _Builds(this.lineOf);
  final int Function(int offset) lineOf;
  final found = <(String, int)>[];

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.name.lexeme == 'build') {
      final cls = node.thisOrAncestorOfType<ClassDeclaration>();
      final lines = lineOf(node.end) - lineOf(node.offset) + 1;
      found.add(('${cls?.namePart.typeName.lexeme ?? '?'}.build', lines));
    }
    super.visitMethodDeclaration(node);
  }
}

void main(List<String> args) {
  final report = args.contains('--report');
  final problems = <String>[];
  final files =
      Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart') && !isGenerated(f.path))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final f in files) {
    final text = f.readAsStringSync();
    final result = parseString(content: text, path: f.absolute.path);
    final info = result.lineInfo;
    final total = info.lineCount;
    if (total > maxFileLines) {
      problems.add('${f.path}: $total lines (max $maxFileLines)');
    }
    final v = _Builds((o) => info.getLocation(o).lineNumber);
    result.unit.accept(v);
    for (final (name, lines) in v.found) {
      if (lines > maxBuildLines) {
        problems.add('${f.path}: $name is $lines lines (max $maxBuildLines)');
      }
    }
  }
  if (problems.isEmpty) {
    stdout.writeln(
      'size check: ${files.length} files OK '
      '(files ≤ $maxFileLines lines, build ≤ $maxBuildLines lines)',
    );
    return;
  }
  problems.forEach(stdout.writeln);
  stdout.writeln('size check: ${problems.length} problem(s)');
  if (!report) exitCode = 1;
}
