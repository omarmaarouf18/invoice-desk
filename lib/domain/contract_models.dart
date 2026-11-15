import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:meta/meta.dart';

/// What a library template produces, and a contract's numbering series.
enum TemplateKind {
  /// A full contract, numbered CT-….
  contract('contract'),

  /// A quote with terms, numbered QT-….
  quote('quote');

  const TemplateKind(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static TemplateKind fromDb(String v) =>
      TemplateKind.values.firstWhere((k) => k.dbValue == v);
}

/// What kind of document a contract row is.
enum ContractKind {
  /// A contract from a contract template.
  contract('contract'),

  /// A quote from a quote template.
  quote('quote'),

  /// A change to a signed original, numbered `<original>-A<n>`.
  amendment('amendment');

  const ContractKind(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static ContractKind fromDb(String v) =>
      ContractKind.values.firstWhere((k) => k.dbValue == v);
}

/// Lifecycle of a contract. Past draft needs every variable resolved.
enum ContractStatus {
  /// Being written; the PDF carries a "مسودة" watermark.
  draft('draft'),

  /// Sent to the client for signature.
  sent('sent'),

  /// Signed; locks the document.
  signed('signed'),

  /// In force (work under way); still locked.
  active('active'),

  /// Delivered and closed; still locked.
  completed('completed'),

  /// Called off; also how a contract with invoices is retired.
  cancelled('cancelled');

  const ContractStatus(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Signed, active and completed documents are read-only (unless unlocked).
  bool get locks => this == signed || this == active || this == completed;

  /// "عقود سارية".
  bool get isInForce => this == signed || this == active;

  /// Moving to these needs every variable resolved.
  bool get needsResolvedVariables => this != draft && this != cancelled;

  /// Inverse of [dbValue]; throws on unknown values.
  static ContractStatus fromDb(String v) =>
      ContractStatus.values.firstWhere((s) => s.dbValue == v);
}

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

@immutable
/// A clause inside a contract: a snapshot, edited freely.
class ContractClause {
  /// A contract clause; ids are UUIDs.
  const ContractClause({
    required this.id,
    this.title = '',
    this.body = '',
    this.enabled = true,
    this.optional = false,
    this.fromLibraryClauseId,
  });

  /// Stable UUID.
  final String id;

  /// Heading; may hold `{{variables}}`.
  final String title;

  /// Text; `- ` lines become sub-items.
  final String body;

  /// Disabled clauses are skipped in the PDF and numbering closes up.
  final bool enabled;

  /// Came from an optional library clause ("اختياري" tag).
  final bool optional;

  /// The library clause it was copied from, for restore/save; not a
  /// foreign key, so it survives library edits and deletions.
  final String? fromLibraryClauseId;

  /// A copy with the given fields replaced; pass a function to null
  /// [fromLibraryClauseId].
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
/// A row of annex 1 (scope of work).
class ScopeItem {
  /// A scope row; ids are UUIDs.
  const ScopeItem({
    required this.id,
    this.phase = '',
    this.item = '',
    this.description = '',
    this.acceptance = '',
  });

  /// Stable UUID.
  final String id;

  /// e.g. "المرحلة 1".
  final String phase;

  /// What is delivered.
  final String item;

  /// Details of the item.
  final String description;

  /// How the client accepts it.
  final String acceptance;

  /// Every cell empty; blank rows are not printed.
  bool get isBlank =>
      phase.trim().isEmpty &&
      item.trim().isEmpty &&
      description.trim().isEmpty &&
      acceptance.trim().isEmpty;

  /// A copy with the given fields replaced.
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
/// A row of annex 2: one payment, by share or fixed amount.
class PaymentMilestone {
  /// A milestone; ids are UUIDs.
  const PaymentMilestone({
    required this.id,
    this.label = '',
    this.percentBp,
    this.amountMinor,
    this.trigger = '',
    this.dueDate,
    this.invoiceId,
  });

  /// Stable UUID.
  final String id;

  /// e.g. "الدفعة المقدمة"; becomes the invoice's service line.
  final String label;

  /// Share of the total in basis points (2500 = 25%). Used when
  /// [amountMinor] is null.
  final int? percentBp;

  /// A fixed amount; wins over [percentBp].
  final int? amountMinor;

  /// When it falls due, in words ("عند التوقيع").
  final String trigger;

  /// Optional date; also the invoice's due date.
  final CalendarDate? dueDate;

  /// The invoice created for it; null after that invoice is purged.
  final String? invoiceId;

  /// Uses [amountMinor] rather than a share of the total.
  bool get isFixed => amountMinor != null;

  /// A copy with the given fields replaced; nullable fields take a
  /// function so they can be cleared.
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
/// One entry of a contract's history (unlocks, status changes).
class ContractEvent {
  /// [at] is UTC epoch ms.
  const ContractEvent({required this.at, required this.event});

  /// UTC epoch milliseconds.
  final int at;

  /// `unlock`, `status:signed`, …
  final String event;

  /// Stored form inside the contract's `history` JSON.
  Map<String, Object> toJson() => {'at': at, 'event': event};
}

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
    this.history = const [],
    this.clauses = const [],
    this.scope = const [],
    this.milestones = const [],
    this.createdAt = 0,
    this.updatedAt = 0,
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
