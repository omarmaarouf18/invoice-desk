part of '../contract_models.dart';

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
