import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:uuid/uuid.dart';

part 'library_dao.g.dart';

/// The clause library: templates and their clauses (Settings → مكتبة البنود).
@DriftAccessor(tables: [ClauseTemplates, LibraryClauses])
class LibraryDao extends DatabaseAccessor<AppDatabase> with _$LibraryDaoMixin {
  LibraryDao(super.attachedDatabase);

  int _now() => clock.now().toUtc().millisecondsSinceEpoch;

  /// Every template with its clauses, by position. Re-emits on any change.
  Stream<List<ClauseTemplate>> watchAll() => customSelect(
    // Drift shares watch streams by SQL text: each aggregate needs its own
    // query, or it inherits another stream's table set.
    'SELECT 1 AS library_tick',
    readsFrom: {clauseTemplates, libraryClauses},
  ).watch().asyncMap((_) => getAll());

  Future<List<ClauseTemplate>> getAll() async {
    final ts = await (select(
      clauseTemplates,
    )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();
    final cs = await (select(
      libraryClauses,
    )..orderBy([(c) => OrderingTerm.asc(c.position)])).get();
    final byTemplate = groupBy(cs, (c) => c.templateId);
    return [
      for (final t in ts) _toModel(t, byTemplate[t.id] ?? const []),
    ];
  }

  Future<ClauseTemplate?> getById(String id) async =>
      (await getAll()).where((t) => t.id == id).firstOrNull;

  Future<LibraryClause?> clauseById(String id) async {
    final r = await (select(
      libraryClauses,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    return r == null ? null : _clauseToModel(r);
  }

  /// Saves a template and replaces its clauses, atomically.
  Future<void> saveTemplate(ClauseTemplate t) => transaction(() async {
    final now = _now();
    final existing = await (select(
      clauseTemplates,
    )..where((x) => x.id.equals(t.id))).getSingleOrNull();
    final position =
        existing?.position ??
        ((await (selectOnly(
                          clauseTemplates,
                        )..addColumns([clauseTemplates.position.max()]))
                        .getSingle())
                    .read(clauseTemplates.position.max()) ??
                -1) +
            1;
    await into(clauseTemplates).insertOnConflictUpdate(
      ClauseTemplatesCompanion.insert(
        id: t.id,
        name: t.name.trim(),
        kind: t.kind.dbValue,
        position: position,
        archived: Value(t.archived),
        preamble: Value(t.preamble),
        closing: Value(t.closing),
        varDefaults: Value(jsonEncode(t.varDefaults)),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
    await (delete(
      libraryClauses,
    )..where((c) => c.templateId.equals(t.id))).go();
    for (final (i, c) in t.clauses.indexed) {
      await into(libraryClauses).insert(
        LibraryClausesCompanion.insert(
          id: c.id,
          templateId: t.id,
          position: i,
          title: Value(c.title),
          body: Value(c.body),
          optional: Value(c.optional),
          enabledByDefault: Value(c.enabledByDefault),
        ),
      );
    }
  });

  /// "حفظ في المكتبة": overwrites one library clause's wording.
  Future<void> updateClauseText(
    String id, {
    required String title,
    required String body,
  }) => transaction(() async {
    final r = await (select(
      libraryClauses,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    if (r == null) return;
    await (update(libraryClauses)..where((c) => c.id.equals(id))).write(
      LibraryClausesCompanion(title: Value(title), body: Value(body)),
    );
    await (update(clauseTemplates)..where((t) => t.id.equals(r.templateId)))
        .write(ClauseTemplatesCompanion(updatedAt: Value(_now())));
  });

  Future<void> deleteTemplate(String id) => transaction(() async {
    await (delete(clauseTemplates)..where((t) => t.id.equals(id))).go();
  });

  /// Seeds the starting templates when the library is empty.
  Future<void> seedIfEmpty() => transaction(() async {
    final n = await clauseTemplates.count().getSingle();
    if (n > 0) return;
    const uuid = Uuid();
    for (final t in seedTemplates) {
      await saveTemplate(
        ClauseTemplate(
          id: uuid.v4(),
          name: t.name,
          kind: TemplateKind.fromDb(t.kind),
          preamble: t.preamble,
          closing: t.closing,
          varDefaults: t.defaults,
          clauses: [
            for (final c in t.clauses)
              LibraryClause(
                id: uuid.v4(),
                title: c.title,
                body: c.body,
                optional: c.optional,
                enabledByDefault: c.enabledByDefault,
              ),
          ],
        ),
      );
    }
  });

  ClauseTemplate _toModel(TemplateRow t, List<LibraryClauseRow> cs) =>
      ClauseTemplate(
        id: t.id,
        name: t.name,
        kind: TemplateKind.fromDb(t.kind),
        archived: t.archived,
        preamble: t.preamble,
        closing: t.closing,
        varDefaults: decodeStringMap(t.varDefaults),
        clauses: cs.map(_clauseToModel).toList(),
      );

  LibraryClause _clauseToModel(LibraryClauseRow r) => LibraryClause(
    id: r.id,
    title: r.title,
    body: r.body,
    optional: r.optional,
    enabledByDefault: r.enabledByDefault,
  );
}

/// Tolerant JSON object → `Map<String, String>`.
Map<String, String> decodeStringMap(String json) {
  try {
    final v = jsonDecode(json);
    if (v is Map) {
      return {for (final e in v.entries) '${e.key}': '${e.value ?? ''}'};
    }
  } on FormatException {
    // fall through
  }
  return const {};
}
