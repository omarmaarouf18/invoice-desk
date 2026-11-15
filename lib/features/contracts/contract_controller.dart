import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/repositories/contract_repository.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/results.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart'
    show SaveStatus, editorProvider, newId;

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

/// Default payment schedules, by kind.
List<PaymentMilestone> defaultMilestones(TemplateKind kind) => switch (kind) {
  TemplateKind.contract => [
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة المقدمة',
      percentBp: 3000,
      trigger: 'عند التوقيع',
    ),
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة الثانية',
      percentBp: 4000,
      trigger: 'عند قبول المرحلة 1',
    ),
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة الأخيرة',
      percentBp: 3000,
      trigger: 'عند التسليم النهائي',
    ),
  ],
  TemplateKind.quote => [
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة المقدمة',
      percentBp: 5000,
      trigger: 'عند الموافقة على العرض',
    ),
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة الأخيرة',
      percentBp: 5000,
      trigger: 'عند التسليم',
    ),
  ],
};

/// The contract editor ViewModel: edit buffer, autosave 1.5 s after the
/// last edit, locking, and the contract-level actions.
class ContractController extends Notifier<ContractEditorState> {
  static const autosaveDelay = Duration(milliseconds: 1500);

  Timer? _timer;
  Future<void>? _inFlight;

  @override
  ContractEditorState build() {
    ref.onDispose(() => _timer?.cancel());
    return const ContractEditorState();
  }

  ContractRepository get _dao => ref.read(contractRepositoryProvider);
  CalendarDate get _today => todayFrom(ref);
  int get _nowMs =>
      ref.read(clockProvider).now().toUtc().millisecondsSinceEpoch;

  // ── Opening ─────────────────────────────────────────────────────────
  Future<void> open(String id) async {
    if (state.contract?.id != id) {
      await flush();
      final c = await _dao.getById(id);
      if (!ref.mounted || c == null) return;
      state = ContractEditorState(contract: c, revision: state.revision + 1);
    }
    await ref.read(editorProvider.notifier).flush();
    ref.read(workspaceProvider.notifier).show(Workspace.contract);
  }

  void close() {
    _timer?.cancel();
    state = ContractEditorState(revision: state.revision + 1);
  }

  Future<({int year, int seq, String number})> _nextNumber(
    TemplateKind series,
  ) async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    final year = _today.year;
    final seq = await _dao.nextSeqFor(series, year);
    final prefix = series == TemplateKind.quote
        ? settings.quotePrefix
        : settings.contractPrefix;
    return (
      year: year,
      seq: seq,
      number: formatContractNumber(prefix, year, seq),
    );
  }

  /// Creates a contract from a template (a snapshot of its clauses), saves
  /// it and opens it.
  Future<Contract> create(NewContractRequest r) async {
    await flush();
    final settings = await ref.read(settingsRepositoryProvider).get();
    final t = r.template;
    final n = await _nextNumber(t.kind);
    final c = Contract(
      id: newId(),
      clientId: r.clientId,
      number: n.number,
      series: t.kind,
      year: n.year,
      seq: n.seq,
      kind: t.kind == TemplateKind.quote
          ? ContractKind.quote
          : ContractKind.contract,
      templateName: t.name,
      title: r.title.trim(),
      projectName: r.projectName.trim(),
      preamble: t.preamble,
      closing: t.closing,
      issueDate: _today,
      jurisdiction: settings.defaultJurisdiction,
      vars: {...t.varDefaults},
      clauses: clausesFromTemplate(t, newId),
      scope: [ScopeItem(id: newId())],
      milestones: defaultMilestones(t.kind),
    );
    await _dao.save(c);
    await open(c.id);
    return c;
  }

  // ── Editing ─────────────────────────────────────────────────────────
  /// Applies [change]. A locked contract only accepts [allowLocked] edits
  /// (status and dates), never clauses, annexes or variables.
  void edit(
    Contract Function(Contract c) change, {
    bool allowLocked = false,
  }) {
    final c = state.contract;
    if (c == null) return;
    if (c.isLocked && !allowLocked) return;
    state = state.copyWith(
      contract: change(c),
      status: SaveStatus.dirty,
      revision: state.revision + 1,
    );
    _schedule();
  }

  void setVariable(String name, String value) =>
      edit((c) => c.copyWith(vars: {...c.vars, name: value}));

  /// "N متغيرات ناقصة" → the variables panel focuses the first one.
  void focusFirstMissing(List<String> missing) {
    if (missing.isEmpty) return;
    state = state.copyWith(
      focusVariable: missing.first,
      focusTick: state.focusTick + 1,
    );
  }

  /// Blocks moving past draft while variables are unresolved.
  StatusChange setStatus(ContractStatus s, {required List<String> missing}) {
    final c = state.contract;
    if (c == null || c.status == s) return const StatusChanged();
    if (s.needsResolvedVariables && missing.isNotEmpty) {
      return StatusBlocked(missing);
    }
    edit(
      (c) => c.copyWith(
        status: s,
        signedDate: () => s == ContractStatus.signed
            ? (c.signedDate ?? _today)
            : c.signedDate,
        // Signing (again) re-locks a contract that was unlocked.
        unlocked: c.unlocked && !(s.locks && !c.status.locks),
        history: [
          ...c.history,
          ContractEvent(at: _nowMs, event: 'status:${s.dbValue}'),
        ],
      ),
      allowLocked: true,
    );
    return const StatusChanged();
  }

  /// "إلغاء القفل", after the user confirmed. Logged in the history.
  void unlock() => edit(
    (c) => c.copyWith(
      unlocked: true,
      history: [
        ...c.history,
        ContractEvent(at: _nowMs, event: 'unlock'),
      ],
    ),
    allowLocked: true,
  );

  void relock() => edit(
    (c) => c.copyWith(
      unlocked: false,
      history: [
        ...c.history,
        ContractEvent(at: _nowMs, event: 'relock'),
      ],
    ),
    allowLocked: true,
  );

  // Clauses
  void editClause(String id, ContractClause Function(ContractClause x) f) =>
      edit(
        (c) => c.copyWith(
          clauses: [for (final x in c.clauses) x.id == id ? f(x) : x],
        ),
      );

  void reorderClause(int from, int to) => edit((c) {
    final list = [...c.clauses];
    final x = list.removeAt(from);
    list.insert(to.clamp(0, list.length), x);
    return c.copyWith(clauses: list);
  });

  /// Adds a clause after [afterId] (or at the end). Returns its id.
  String addClause({LibraryClause? from, String? afterId}) {
    final x = ContractClause(
      id: newId(),
      title: from?.title ?? '',
      body: from?.body ?? '',
      optional: from?.optional ?? false,
      fromLibraryClauseId: from?.id,
    );
    edit((c) {
      final list = [...c.clauses];
      final at = afterId == null
          ? list.length
          : list.indexWhere((y) => y.id == afterId) + 1;
      list.insert(at.clamp(0, list.length), x);
      return c.copyWith(clauses: list);
    });
    return x.id;
  }

  void duplicateClause(String id) => edit((c) {
    final list = [...c.clauses];
    final i = list.indexWhere((x) => x.id == id);
    if (i < 0) return c;
    list.insert(i + 1, list[i].copyWith(id: newId()));
    return c.copyWith(clauses: list);
  });

  void removeClause(String id) => edit(
    (c) => c.copyWith(clauses: c.clauses.where((x) => x.id != id).toList()),
  );

  /// "استرجاع النص من المكتبة": the library's current wording replaces the
  /// contract's snapshot (after the user saw the diff).
  void restoreClause(String id, LibraryClause from) => editClause(
    id,
    (x) => x.copyWith(title: from.title, body: from.body),
  );

  // Scope (annex 1)
  void editScope(String id, ScopeItem Function(ScopeItem x) f) => edit(
    (c) => c.copyWith(scope: [for (final x in c.scope) x.id == id ? f(x) : x]),
  );

  String addScope({String? afterId}) {
    final x = ScopeItem(id: newId());
    edit((c) {
      final list = [...c.scope];
      final at = afterId == null
          ? list.length
          : list.indexWhere((y) => y.id == afterId) + 1;
      list.insert(at.clamp(0, list.length), x);
      return c.copyWith(scope: list);
    });
    return x.id;
  }

  void removeScope(String id) => edit(
    (c) => c.copyWith(scope: c.scope.where((x) => x.id != id).toList()),
  );

  // Milestones (annex 2)
  void editMilestone(
    String id,
    PaymentMilestone Function(PaymentMilestone x) f,
  ) => edit(
    (c) => c.copyWith(
      milestones: [for (final x in c.milestones) x.id == id ? f(x) : x],
    ),
  );

  void addMilestone() => edit(
    (c) => c.copyWith(
      milestones: [
        ...c.milestones,
        PaymentMilestone(id: newId()),
      ],
    ),
  );

  void removeMilestone(String id) => edit(
    (c) => c.copyWith(
      milestones: c.milestones.where((x) => x.id != id).toList(),
    ),
  );

  // ── Saving ──────────────────────────────────────────────────────────
  void _schedule() {
    _timer?.cancel();
    _timer = Timer(autosaveDelay, () => unawaited(save()));
  }

  Future<void> flush() async {
    _timer?.cancel();
    if (_inFlight != null) await _inFlight;
    if (state.status == SaveStatus.dirty) await save();
  }

  Future<void> save() {
    _timer?.cancel();
    final run = _save();
    _inFlight = run;
    return run.whenComplete(() => _inFlight = null);
  }

  Future<void> _save() async {
    final c = state.contract;
    if (c == null) return;
    final rev = state.revision;
    final taken = await _dao.numberTaken(c.number, exceptId: c.id);
    final issues = validateContract(c, numberTaken: taken);
    if (!ref.mounted) return;
    if (issues.isNotEmpty) {
      state = state.copyWith(status: SaveStatus.invalid, issues: issues);
      return;
    }
    state = state.copyWith(status: SaveStatus.saving, issues: const {});
    try {
      if (await _dao.save(c) is DuplicateNumber) {
        if (!ref.mounted) return;
        state = state.copyWith(
          status: SaveStatus.invalid,
          issues: {ContractIssue.duplicateNumber},
        );
        return;
      }
    } on Object catch (e, st) {
      debugPrint('contract save failed: $e\n$st');
      if (!ref.mounted) return;
      state = state.copyWith(status: SaveStatus.error);
      return;
    }
    if (!ref.mounted) return;
    final changed = state.revision != rev;
    state = state.copyWith(
      status: changed ? SaveStatus.dirty : SaveStatus.saved,
    );
    if (changed) _schedule();
  }

  // ── Actions ─────────────────────────────────────────────────────────
  Future<Contract?> _load(String id) async {
    if (state.contract?.id == id) {
      await flush();
      return state.contract;
    }
    return _dao.getById(id);
  }

  /// "تكرار كعقد جديد": same content, next number, back to draft.
  Future<Contract?> duplicate(String id) async {
    final src = await _load(id);
    if (src == null || src.isAmendment) return null;
    final n = await _nextNumber(src.series);
    final copy = cloneContractParts(src, newId).copyWith(
      id: newId(),
      number: n.number,
      year: n.year,
      seq: n.seq,
      status: ContractStatus.draft,
      issueDate: _today,
      signedDate: () => null,
      unlocked: false,
      history: const [],
      createdAt: 0,
    );
    await _dao.save(copy);
    await open(copy.id);
    return copy;
  }

  /// "ملحق تعديل": a new document linked to [parentId], numbered
  /// `<parent>-A<n>`, with its own clauses and annexes.
  Future<Contract?> createAmendment(
    String parentId, {
    required String Function(String number, String date) preamble,
    required String clauseTitle,
  }) async {
    final parent = await _load(parentId);
    if (parent == null) return null;
    final root = parent.isAmendment && parent.parentId != null
        ? await _dao.getById(parent.parentId!)
        : parent;
    if (root == null) return null;
    final no = await _dao.nextAmendmentNo(root.id);
    final settings = await ref.read(settingsRepositoryProvider).get();
    final prefix = root.series == TemplateKind.quote
        ? settings.quotePrefix
        : settings.contractPrefix;
    final a = Contract(
      id: newId(),
      clientId: root.clientId,
      number: formatContractNumber(
        root.number.startsWith('$prefix-')
            ? prefix
            : root.number.split('-').first,
        root.year,
        root.seq,
        amendmentNo: no,
      ),
      series: root.series,
      year: root.year,
      seq: root.seq,
      amendmentNo: no,
      parentId: root.id,
      kind: ContractKind.amendment,
      templateName: root.templateName,
      title: root.title,
      projectName: root.projectName,
      projectSummary: root.projectSummary,
      preamble: preamble(root.number, formatArabicDate(root.issueDate)),
      issueDate: _today,
      jurisdiction: root.jurisdiction,
      currency: root.currency,
      vars: {...root.vars},
      clauses: [ContractClause(id: newId(), title: clauseTitle)],
    );
    await _dao.save(a);
    await open(a.id);
    return a;
  }

  /// Creates a draft invoice for a milestone and links it. Returns the
  /// invoice number, or null when the milestone has no amount.
  Future<String?> createInvoiceFromMilestone(String milestoneId) async {
    await flush();
    final c = state.contract;
    if (c == null) return null;
    final i = c.milestones.indexWhere((m) => m.id == milestoneId);
    if (i < 0) return null;
    final amount = milestoneAmounts(c.totalMinor, c.milestones)[i];
    if (amount <= 0) return null;
    final m = c.milestones[i];
    final invoices = ref.read(invoiceRepositoryProvider);
    final settings = await ref.read(settingsRepositoryProvider).get();
    final today = _today;
    final seq = await invoices.nextSeqFor(today.year);
    final number = formatInvoiceNumber(settings.invoicePrefix, today.year, seq);
    final label = m.label.trim().isEmpty ? c.number : m.label.trim();
    final inv = Invoice(
      id: newId(),
      clientId: c.clientId,
      number: number,
      year: today.year,
      seq: seq,
      issueDate: today,
      dueDate: m.dueDate ?? today.addDays(settings.defaultDueDays),
      contractRef: c.number,
      notesEn: settings.notesEn,
      notesAr: settings.notesAr,
      sections: [
        InvoiceSection(
          id: newId(),
          currency: c.currency,
          titleAr: c.projectName,
          items: [
            LineItem(
              id: newId(),
              service: label,
              description: [
                c.projectName.trim(),
                m.trigger.trim(),
              ].where((e) => e.isNotEmpty).join(' — '),
              unitPriceMinor: amount,
            ),
          ],
        ),
      ],
    );
    if (await invoices.save(inv) is! Saved) return null;
    await _dao.linkMilestone(m.id, inv.id);
    if (!ref.mounted) return number;
    // Keep the buffer in step without marking it dirty.
    final current = state.contract;
    if (current?.id == c.id) {
      state = state.copyWith(
        contract: current!.copyWith(
          milestones: [
            for (final x in current.milestones)
              x.id == m.id ? x.copyWith(invoiceId: () => inv.id) : x,
          ],
        ),
        revision: state.revision + 1,
      );
    }
    return number;
  }

  /// Soft delete (with amendments); [HasLinkedInvoices] while invoices
  /// point at it.
  Future<DeleteResult> delete(String id) async {
    await _load(id);
    final r = await _dao.softDelete(id);
    if (r is Deleted &&
        (state.contract?.id == id || state.contract?.parentId == id)) {
      close();
    }
    return r;
  }

  Future<void> undoDelete(String id, int stamp) async {
    await _dao.undoDelete(id, stamp);
    await open(id);
  }

  /// Saves and closes the open contract when it belongs to [clientId].
  Future<void> closeIfClient(String clientId) async {
    if (state.contract?.clientId != clientId) return;
    await flush();
    close();
  }
}

final contractProvider =
    NotifierProvider<ContractController, ContractEditorState>(
      ContractController.new,
    );

/// Resolver for the open contract, rebuilt when it, the client or the
/// settings change.
final openResolverProvider = Provider<VariableResolver?>((ref) {
  final c = ref.watch(contractProvider.select((s) => s.contract));
  if (c == null) return null;
  final clients = ref.watch(clientsProvider).value ?? const <Client>[];
  final settings = ref.watch(settingsProvider).value ?? const Settings();
  return VariableResolver(
    contract: c,
    client: clients.where((x) => x.id == c.clientId).firstOrNull,
    settings: settings,
  );
});

/// Missing variables of the open contract, in document order.
final openMissingProvider = Provider<List<String>>(
  (ref) => ref.watch(openResolverProvider)?.missing() ?? const [],
);

/// Clock-free helper for tests and the history list.
DateTime eventTime(ContractEvent e) =>
    DateTime.fromMillisecondsSinceEpoch(e.at, isUtc: true).toLocal();

/// A milestone's money, for the UI.
Money milestoneMoney(Contract c, int index) =>
    Money(milestoneAmounts(c.totalMinor, c.milestones)[index], c.currency);
