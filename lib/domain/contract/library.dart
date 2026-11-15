part of '../contract_models.dart';

@immutable
/// A clause as the library keeps it. Contracts copy it; later edits
/// here never reach existing contracts.
class LibraryClause {
  /// A library clause; ids are UUIDs.
  const LibraryClause({
    required this.id,
    this.title = '',
    this.body = '',
    this.optional = false,
    this.enabledByDefault = true,
  });

  /// Stable UUID; contracts remember it to offer "استرجاع النص".
  final String id;

  /// Heading after "البند الأول: "; may hold `{{variables}}`.
  final String title;

  /// Text; lines starting `- ` become numbered sub-items.
  final String body;

  /// Shown with an "اختياري" tag.
  final bool optional;

  /// Whether a new contract starts with it switched on.
  final bool enabledByDefault;

  /// A copy with the given fields replaced.
  LibraryClause copyWith({
    String? id,
    String? title,
    String? body,
    bool? optional,
    bool? enabledByDefault,
  }) => LibraryClause(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    optional: optional ?? this.optional,
    enabledByDefault: enabledByDefault ?? this.enabledByDefault,
  );
}

@immutable
/// A named, ordered set of clauses with its preamble, closing line and
/// variable defaults.
class ClauseTemplate {
  /// A template; ids are UUIDs.
  const ClauseTemplate({
    required this.id,
    required this.name,
    this.kind = TemplateKind.contract,
    this.archived = false,
    this.preamble = '',
    this.closing = '',
    this.varDefaults = const {},
    this.clauses = const [],
  });

  /// Stable UUID.
  final String id;

  /// Shown on the template cards, e.g. "عقد تطوير وتشغيل".
  final String name;

  /// Picks the numbering series of contracts made from it.
  final TemplateKind kind;

  /// Hidden from the new-contract sheet.
  final bool archived;

  /// Printed as "تمهيد" before the clauses.
  final String preamble;

  /// Printed after the clauses (quotes use it for acceptance).
  final String closing;

  /// Starting values of custom variables, copied into each new contract.
  final Map<String, String> varDefaults;

  /// In order.
  final List<LibraryClause> clauses;

  /// A copy with the given fields replaced.
  ClauseTemplate copyWith({
    String? name,
    TemplateKind? kind,
    bool? archived,
    String? preamble,
    String? closing,
    Map<String, String>? varDefaults,
    List<LibraryClause>? clauses,
  }) => ClauseTemplate(
    id: id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    archived: archived ?? this.archived,
    preamble: preamble ?? this.preamble,
    closing: closing ?? this.closing,
    varDefaults: varDefaults ?? this.varDefaults,
    clauses: clauses ?? this.clauses,
  );
}
