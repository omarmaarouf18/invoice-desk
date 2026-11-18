part of '../contract_models.dart';

@immutable
/// A contract, quote or amendment with its clauses and both annexes.
class Contract {
  /// A contract; [number] is unique, ids are UUIDs.
  const Contract({
    required this.id,
    required this.clientId,
    required this.number,
    required this.year,
    required this.seq,
    required this.issueDate,
    this.series = TemplateKind.contract,
    this.amendmentNo = 0,
    this.parentId,
    this.kind = ContractKind.contract,
    this.templateName = '',
    this.title = '',
    this.projectName = '',
    this.projectSummary = '',
    this.preamble = '',
    this.closing = '',
    this.startDate,
    this.signedDate,
    this.endDate,
    this.status = ContractStatus.draft,
    this.jurisdiction = '',
    this.currency = Currency.egp,
    this.totalMinor = 0,
    this.vars = const {},
    this.outOfScope = '',
    this.unlocked = false,
    this.styleId,
    this.styleSnapshot,
    this.issueSnapshot,
    this.history = const [],
    this.clauses = const [],
    this.scope = const [],
    this.milestones = const [],
    this.createdAt = 0,
    this.updatedAt = 0,
    this.isDemo = false,
  });

  /// Stable UUID.
  final String id;

  /// Owner; the database refuses a live contract under a deleted client.
  final String clientId;

  /// e.g. `CT-2026-0003` or `CT-2026-0003-A1`; unique, never reused.
  final String number;

  /// Numbering series; amendments keep their original's.
  final TemplateKind series;

  /// Year part of the number.
  final int year;

  /// Sequence within series and year, from 1.
  final int seq;

  /// 0 for originals; n for the `-An` amendment.
  final int amendmentNo;

  /// The original of an amendment.
  final String? parentId;

  /// Contract, quote or amendment.
  final ContractKind kind;

  /// The template it was made from, for reference only.
  final String templateName;

  /// Printed after "عقد" on the cover.
  final String title;

  /// `{{project.name}}`.
  final String projectName;

  /// `{{project.summary}}`.
  final String projectSummary;

  /// "تمهيد", copied from the template.
  final String preamble;

  /// Closing line, copied from the template.
  final String closing;

  /// `{{contract.date}}`.
  final CalendarDate issueDate;

  /// When work starts, if agreed.
  final CalendarDate? startDate;

  /// Set when moved to signed, unless already given.
  final CalendarDate? signedDate;

  /// When it ends, if agreed.
  final CalendarDate? endDate;

  /// Signed, active and completed lock the document.
  final ContractStatus status;

  /// `{{jurisdiction}}`; defaults from settings.
  final String jurisdiction;

  /// Currency of the total and every milestone.
  final Currency currency;

  /// Total in minor units (hundredths); milestones split it.
  final int totalMinor;

  /// Custom variable values; never contains resolved built-ins.
  final Map<String, String> vars;

  /// One entry per line.
  final String outOfScope;

  /// A locked status was explicitly unlocked (logged in [history]).
  final bool unlocked;

  /// Custom style ID overriding client or global default.
  final String? styleId;

  /// Frozen style JSON when signed or locked (ADR-0012).
  final String? styleSnapshot;

  /// Provider, payment, client and formats as printed when it was
  /// committed (ADR-0014); null renders from live data.
  final String? issueSnapshot;

  /// Oldest first.
  final List<ContractEvent> history;

  /// In order, disabled ones included.
  final List<ContractClause> clauses;

  /// Annex 1 rows, in order.
  final List<ScopeItem> scope;

  /// Annex 2 rows, in order.
  final List<PaymentMilestone> milestones;

  /// UTC epoch ms; 0 until first saved.
  final int createdAt;

  /// UTC epoch ms of the last save.
  final int updatedAt;

  /// Part of the demo set (cleared when the user saves the contract).
  final bool isDemo;

  /// Has a [parentId] and an `-An` number.
  bool get isAmendment => kind == ContractKind.amendment;

  /// Numbered in the QT series.
  bool get isQuote => series == TemplateKind.quote;

  /// Read-only: signed (or later) and not explicitly unlocked.
  bool get isLocked => status.locks && !unlocked;

  /// [totalMinor] as money.
  Money get total => Money(totalMinor, currency);

  /// A copy with the given fields replaced; nullable fields take a
  /// function so they can be cleared.
  Contract copyWith({
    String? id,
    String? clientId,
    String? number,
    TemplateKind? series,
    int? year,
    int? seq,
    int? amendmentNo,
    String? Function()? parentId,
    ContractKind? kind,
    String? templateName,
    String? title,
    String? projectName,
    String? projectSummary,
    String? preamble,
    String? closing,
    CalendarDate? issueDate,
    CalendarDate? Function()? startDate,
    CalendarDate? Function()? signedDate,
    CalendarDate? Function()? endDate,
    ContractStatus? status,
    String? jurisdiction,
    Currency? currency,
    int? totalMinor,
    Map<String, String>? vars,
    String? outOfScope,
    bool? unlocked,
    String? Function()? styleId,
    String? Function()? styleSnapshot,
    String? Function()? issueSnapshot,
    List<ContractEvent>? history,
    List<ContractClause>? clauses,
    List<ScopeItem>? scope,
    List<PaymentMilestone>? milestones,
    int? createdAt,
    int? updatedAt,
    bool? isDemo,
  }) => Contract(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    number: number ?? this.number,
    series: series ?? this.series,
    year: year ?? this.year,
    seq: seq ?? this.seq,
    amendmentNo: amendmentNo ?? this.amendmentNo,
    parentId: parentId != null ? parentId() : this.parentId,
    kind: kind ?? this.kind,
    templateName: templateName ?? this.templateName,
    title: title ?? this.title,
    projectName: projectName ?? this.projectName,
    projectSummary: projectSummary ?? this.projectSummary,
    preamble: preamble ?? this.preamble,
    closing: closing ?? this.closing,
    issueDate: issueDate ?? this.issueDate,
    startDate: startDate != null ? startDate() : this.startDate,
    signedDate: signedDate != null ? signedDate() : this.signedDate,
    endDate: endDate != null ? endDate() : this.endDate,
    status: status ?? this.status,
    jurisdiction: jurisdiction ?? this.jurisdiction,
    currency: currency ?? this.currency,
    totalMinor: totalMinor ?? this.totalMinor,
    vars: vars ?? this.vars,
    outOfScope: outOfScope ?? this.outOfScope,
    unlocked: unlocked ?? this.unlocked,
    styleId: styleId != null ? styleId() : this.styleId,
    styleSnapshot: styleSnapshot != null ? styleSnapshot() : this.styleSnapshot,
    issueSnapshot: issueSnapshot != null ? issueSnapshot() : this.issueSnapshot,
    history: history ?? this.history,
    clauses: clauses ?? this.clauses,
    scope: scope ?? this.scope,
    milestones: milestones ?? this.milestones,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDemo: isDemo ?? this.isDemo,
  );
}
