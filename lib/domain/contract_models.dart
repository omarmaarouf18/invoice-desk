import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:meta/meta.dart';

enum TemplateKind {
  contract('contract'),
  quote('quote');

  const TemplateKind(this.dbValue);
  final String dbValue;

  static TemplateKind fromDb(String v) =>
      TemplateKind.values.firstWhere((k) => k.dbValue == v);
}

enum ContractKind {
  contract('contract'),
  quote('quote'),
  amendment('amendment');

  const ContractKind(this.dbValue);
  final String dbValue;

  static ContractKind fromDb(String v) =>
      ContractKind.values.firstWhere((k) => k.dbValue == v);
}

enum ContractStatus {
  draft('draft'),
  sent('sent'),
  signed('signed'),
  active('active'),
  completed('completed'),
  cancelled('cancelled');

  const ContractStatus(this.dbValue);
  final String dbValue;

  /// Signed, active and completed documents are read-only (unless unlocked).
  bool get locks => this == signed || this == active || this == completed;

  /// "عقود سارية".
  bool get isInForce => this == signed || this == active;

  /// Moving to these needs every variable resolved.
  bool get needsResolvedVariables => this != draft && this != cancelled;

  static ContractStatus fromDb(String v) =>
      ContractStatus.values.firstWhere((s) => s.dbValue == v);
}

@immutable
class LibraryClause {
  const LibraryClause({
    required this.id,
    this.title = '',
    this.body = '',
    this.optional = false,
    this.enabledByDefault = true,
  });

  final String id;
  final String title;
  final String body;
  final bool optional;
  final bool enabledByDefault;

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
class ClauseTemplate {
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

  final String id;
  final String name;
  final TemplateKind kind;
  final bool archived;
  final String preamble;
  final String closing;
  final Map<String, String> varDefaults;
  final List<LibraryClause> clauses;

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

@immutable
class ContractClause {
  const ContractClause({
    required this.id,
    this.title = '',
    this.body = '',
    this.enabled = true,
    this.optional = false,
    this.fromLibraryClauseId,
  });

  final String id;
  final String title;
  final String body;
  final bool enabled;
  final bool optional;
  final String? fromLibraryClauseId;

  ContractClause copyWith({
    String? id,
    String? title,
    String? body,
    bool? enabled,
    bool? optional,
    String? Function()? fromLibraryClauseId,
  }) => ContractClause(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    enabled: enabled ?? this.enabled,
    optional: optional ?? this.optional,
    fromLibraryClauseId: fromLibraryClauseId != null
        ? fromLibraryClauseId()
        : this.fromLibraryClauseId,
  );
}

@immutable
class ScopeItem {
  const ScopeItem({
    required this.id,
    this.phase = '',
    this.item = '',
    this.description = '',
    this.acceptance = '',
  });

  final String id;
  final String phase;
  final String item;
  final String description;
  final String acceptance;

  bool get isBlank =>
      phase.trim().isEmpty &&
      item.trim().isEmpty &&
      description.trim().isEmpty &&
      acceptance.trim().isEmpty;

  ScopeItem copyWith({
    String? id,
    String? phase,
    String? item,
    String? description,
    String? acceptance,
  }) => ScopeItem(
    id: id ?? this.id,
    phase: phase ?? this.phase,
    item: item ?? this.item,
    description: description ?? this.description,
    acceptance: acceptance ?? this.acceptance,
  );
}

@immutable
class PaymentMilestone {
  const PaymentMilestone({
    required this.id,
    this.label = '',
    this.percentBp,
    this.amountMinor,
    this.trigger = '',
    this.dueDate,
    this.invoiceId,
  });

  final String id;
  final String label;

  /// Share of the total in basis points (2500 = 25%). Used when
  /// [amountMinor] is null.
  final int? percentBp;

  /// A fixed amount; wins over [percentBp].
  final int? amountMinor;
  final String trigger;
  final CalendarDate? dueDate;
  final String? invoiceId;

  bool get isFixed => amountMinor != null;

  PaymentMilestone copyWith({
    String? id,
    String? label,
    int? Function()? percentBp,
    int? Function()? amountMinor,
    String? trigger,
    CalendarDate? Function()? dueDate,
    String? Function()? invoiceId,
  }) => PaymentMilestone(
    id: id ?? this.id,
    label: label ?? this.label,
    percentBp: percentBp != null ? percentBp() : this.percentBp,
    amountMinor: amountMinor != null ? amountMinor() : this.amountMinor,
    trigger: trigger ?? this.trigger,
    dueDate: dueDate != null ? dueDate() : this.dueDate,
    invoiceId: invoiceId != null ? invoiceId() : this.invoiceId,
  );
}

@immutable
class ContractEvent {
  const ContractEvent({required this.at, required this.event});

  /// UTC epoch milliseconds.
  final int at;

  /// `unlock`, `status:signed`, …
  final String event;

  Map<String, Object> toJson() => {'at': at, 'event': event};
}

@immutable
class Contract {
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
    this.history = const [],
    this.clauses = const [],
    this.scope = const [],
    this.milestones = const [],
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  final String id;
  final String clientId;
  final String number;
  final TemplateKind series;
  final int year;
  final int seq;
  final int amendmentNo;
  final String? parentId;
  final ContractKind kind;
  final String templateName;
  final String title;
  final String projectName;
  final String projectSummary;
  final String preamble;
  final String closing;
  final CalendarDate issueDate;
  final CalendarDate? startDate;
  final CalendarDate? signedDate;
  final CalendarDate? endDate;
  final ContractStatus status;
  final String jurisdiction;
  final Currency currency;
  final int totalMinor;
  final Map<String, String> vars;

  /// One entry per line.
  final String outOfScope;
  final bool unlocked;
  final List<ContractEvent> history;
  final List<ContractClause> clauses;
  final List<ScopeItem> scope;
  final List<PaymentMilestone> milestones;
  final int createdAt;
  final int updatedAt;

  bool get isAmendment => kind == ContractKind.amendment;
  bool get isQuote => series == TemplateKind.quote;

  /// Read-only: signed (or later) and not explicitly unlocked.
  bool get isLocked => status.locks && !unlocked;

  Money get total => Money(totalMinor, currency);

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
    List<ContractEvent>? history,
    List<ContractClause>? clauses,
    List<ScopeItem>? scope,
    List<PaymentMilestone>? milestones,
    int? createdAt,
    int? updatedAt,
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
    history: history ?? this.history,
    clauses: clauses ?? this.clauses,
    scope: scope ?? this.scope,
    milestones: milestones ?? this.milestones,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
