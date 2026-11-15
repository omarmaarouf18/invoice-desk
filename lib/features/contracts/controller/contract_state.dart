part of '../contract_controller.dart';

@immutable
class ContractEditorState {
  const ContractEditorState({
    this.contract,
    this.status = SaveStatus.saved,
    this.issues = const {},
    this.revision = 0,
    this.focusVariable,
    this.focusTick = 0,
  });

  /// The open contract (the edit buffer); null when nothing is open.
  final Contract? contract;
  final SaveStatus status;
  final Set<ContractIssue> issues;

  /// Bumped on every edit; the preview and autosave key off it.
  final int revision;

  /// Set by "N متغيرات ناقصة": the variables panel focuses this one.
  final String? focusVariable;
  final int focusTick;

  ContractEditorState copyWith({
    Contract? contract,
    SaveStatus? status,
    Set<ContractIssue>? issues,
    int? revision,
    String? focusVariable,
    int? focusTick,
  }) => ContractEditorState(
    contract: contract ?? this.contract,
    status: status ?? this.status,
    issues: issues ?? this.issues,
    revision: revision ?? this.revision,
    focusVariable: focusVariable ?? this.focusVariable,
    focusTick: focusTick ?? this.focusTick,
  );
}

/// Outcome of a status change.
sealed class StatusChange {
  const StatusChange();
}

class StatusChanged extends StatusChange {
  const StatusChanged();
}

/// Moving past draft needs every variable resolved.
class StatusBlocked extends StatusChange {
  const StatusBlocked(this.missing);
  final List<String> missing;
}

/// What a new contract starts from (the "عقد جديد" sheet).
class NewContractRequest {
  const NewContractRequest({
    required this.clientId,
    required this.template,
    this.title = '',
    this.projectName = '',
  });

  final String clientId;
  final ClauseTemplate template;
  final String title;
  final String projectName;
}
