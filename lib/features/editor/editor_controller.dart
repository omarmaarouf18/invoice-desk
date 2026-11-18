import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/invoice_defaults.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/results.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:uuid/uuid.dart';

enum SaveStatus { saved, dirty, saving, invalid, error }

@immutable
class EditorState {
  const EditorState({
    this.invoice,
    this.isNew = false,
    this.status = SaveStatus.saved,
    this.issues = const {},
    this.revision = 0,
  });

  /// The open invoice (the edit buffer); null when nothing is open.
  final Invoice? invoice;

  /// Not yet in the database.
  final bool isNew;
  final SaveStatus status;
  final Set<InvoiceIssue> issues;

  /// Bumped on every edit; the preview and autosave key off it.
  final int revision;

  EditorState copyWith({
    Invoice? invoice,
    bool? isNew,
    SaveStatus? status,
    Set<InvoiceIssue>? issues,
    int? revision,
  }) => EditorState(
    invoice: invoice ?? this.invoice,
    isNew: isNew ?? this.isNew,
    status: status ?? this.status,
    issues: issues ?? this.issues,
    revision: revision ?? this.revision,
  );
}

const _uuid = Uuid();
String newId() => _uuid.v4();

/// Result of a one-shot action, for the view's snackbar.
sealed class ActionResult {
  const ActionResult();
}

class Created extends ActionResult {
  const Created(this.number);
  final String number;
}

class NothingToRenew extends ActionResult {
  const NothingToRenew(this.number);
  final String number;
}

class Done extends ActionResult {
  const Done(this.number);
  final String number;
}

class Failed extends ActionResult {
  const Failed();
}

/// The invoice editor ViewModel. Holds the edit buffer, autosaves 1.5 s
/// after the last edit, and owns the invoice-level actions.
class EditorController extends Notifier<EditorState> {
  static const autosaveDelay = Duration(milliseconds: 1500);

  Timer? _timer;
  Future<void>? _inFlight;

  @override
  EditorState build() {
    ref.onDispose(() => _timer?.cancel());
    return const EditorState();
  }

  CalendarDate get _today => todayFrom(ref);

  // ── Opening ─────────────────────────────────────────────────────────
  /// Opens [id] in the editor; [reveal] false keeps the calendar up
  /// (start-up restore).
  Future<void> open(String id, {bool reveal = true}) async {
    await ref.read(contractProvider.notifier).flush();
    if (state.invoice?.id == id) {
      ref
          .read(workspaceProvider.notifier)
          .show(Workspace.invoice, reveal: reveal);
      return;
    }
    await flush();
    final inv = await ref.read(invoiceRepositoryProvider).getById(id);
    if (!ref.mounted || inv == null) return;
    state = EditorState(invoice: inv, revision: state.revision + 1);
    ref.read(uiPrefsProvider).lastInvoiceId = id;
    ref
        .read(workspaceProvider.notifier)
        .show(Workspace.invoice, reveal: reveal);
  }

  void close() {
    _timer?.cancel();
    state = EditorState(revision: state.revision + 1);
  }

  Future<({String number, int year, int seq})> _nextNumber(int year) =>
      ref.read(invoiceRepositoryProvider).nextNumber(year);

  /// Opens a fresh draft (not saved until it has a client).
  Future<void> newInvoice({String? clientId}) async {
    await flush();
    await ref.read(contractProvider.notifier).flush();
    final settings = await ref.read(settingsRepositoryProvider).get();
    final today = _today;
    final next = await _nextNumber(today.year);
    final lang = await ref
        .read(invoiceRepositoryProvider)
        .resolveLanguage(clientId: clientId);
    if (!ref.mounted) return;
    state = EditorState(
      isNew: true,
      status: SaveStatus.dirty,
      revision: state.revision + 1,
      invoice: Invoice(
        id: newId(),
        clientId: clientId ?? '',
        language: lang,
        number: next.number,
        year: next.year,
        seq: next.seq,
        issueDate: today,
        dueDate: today.addDays(settings.defaultDueDays),
        notesEn: settings.notesEn,
        notesAr: settings.notesAr,
        vatOn: settings.defaultVatOn,
        vatRateBp: settings.defaultVatRateBp,
        sections: defaultSections(newId, currency: settings.defaultCurrency),
      ),
    );
    ref.read(workspaceProvider.notifier).show(Workspace.invoice);
    if (clientId != null) _schedule();
  }

  /// Sets the client; on a new invoice with no custom language chosen,
  /// adopts the client's preferred language if set (D7).
  void setClient(String id) {
    final client = ref
        .read(clientsProvider)
        .value
        ?.where((c) => c.id == id)
        .firstOrNull;
    final prefLang = client?.preferredLanguage;
    edit((inv) {
      if (state.isNew && prefLang != null) {
        return inv.copyWith(clientId: id, language: prefLang);
      }
      return inv.copyWith(clientId: id);
    });
  }

  /// Sets the document language of the invoice.
  void setLanguage(DocLanguage lang) =>
      edit((inv) => inv.copyWith(language: lang));

  // ── Editing ─────────────────────────────────────────────────────────
  void edit(Invoice Function(Invoice inv) change) {
    final inv = state.invoice;
    if (inv == null) return;
    state = state.copyWith(
      invoice: change(inv),
      status: SaveStatus.dirty,
      revision: state.revision + 1,
    );
    _schedule();
  }

  void setIssueDate(CalendarDate date) => edit((inv) {
    // Keep the due date in step when it was the default offset.
    final offset = inv.issueDate.daysUntil(inv.dueDate);
    return inv.copyWith(issueDate: date, dueDate: date.addDays(offset));
  });

  void setStatus(InvoiceStatus status) => edit(
    (inv) => inv.copyWith(
      status: status,
      paidDate: () =>
          status == InvoiceStatus.paid ? (inv.paidDate ?? _today) : null,
    ),
  );

  void editSection(
    String sectionId,
    InvoiceSection Function(InvoiceSection s) change,
  ) => edit(
    (inv) => inv.copyWith(
      sections: [
        for (final s in inv.sections) s.id == sectionId ? change(s) : s,
      ],
    ),
  );

  void editItem(
    String sectionId,
    String itemId,
    LineItem Function(LineItem i) change,
  ) => editSection(
    sectionId,
    (s) => s.copyWith(
      items: [for (final i in s.items) i.id == itemId ? change(i) : i],
    ),
  );

  /// Adds an empty row after [afterId] (or at the end). Returns its id.
  String addItem(String sectionId, {String? afterId}) {
    final item = LineItem(id: newId());
    editSection(sectionId, (s) {
      final list = [...s.items];
      final at = afterId == null
          ? list.length
          : list.indexWhere((i) => i.id == afterId) + 1;
      list.insert(at.clamp(0, list.length), item);
      return s.copyWith(items: list);
    });
    return item.id;
  }

  void removeItem(String sectionId, String itemId) => editSection(
    sectionId,
    (s) => s.copyWith(items: s.items.where((i) => i.id != itemId).toList()),
  );

  void reorderItem(String sectionId, int from, int to) =>
      editSection(sectionId, (s) {
        final list = [...s.items];
        final item = list.removeAt(from);
        list.insert(to.clamp(0, list.length), item);
        return s.copyWith(items: list);
      });

  void addSection() => edit(
    (inv) => inv.copyWith(
      sections: [
        ...inv.sections,
        InvoiceSection(
          id: newId(),
          currency: inv.sections.isEmpty
              ? Currency.egp
              : inv.sections.last.currency,
          items: [LineItem(id: newId())],
        ),
      ],
    ),
  );

  void removeSection(String sectionId) => edit(
    (inv) => inv.copyWith(
      sections: inv.sections.where((s) => s.id != sectionId).toList(),
    ),
  );

  // ── Saving ──────────────────────────────────────────────────────────
  void _schedule() {
    _timer?.cancel();
    _timer = Timer(autosaveDelay, () => unawaited(save()));
  }

  /// Saves now if there is anything to save (Ctrl+S, switching invoices).
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
    final inv = state.invoice;
    if (inv == null) return;
    final rev = state.revision;
    final repo = ref.read(invoiceRepositoryProvider);
    final taken = await repo.numberTaken(inv.number.trim(), exceptId: inv.id);
    final issues = validateInvoice(inv, numberTaken: (_, _) => taken);
    if (!ref.mounted) return;
    if (issues.isNotEmpty) {
      state = state.copyWith(status: SaveStatus.invalid, issues: issues);
      return;
    }
    state = state.copyWith(status: SaveStatus.saving, issues: const {});
    try {
      if (await repo.save(inv) is DuplicateNumber) {
        if (!ref.mounted) return;
        state = state.copyWith(
          status: SaveStatus.invalid,
          issues: {InvoiceIssue.duplicateNumber},
        );
        return;
      }
    } on Object catch (e, st) {
      debugPrint('save failed: $e\n$st');
      if (!ref.mounted) return;
      state = state.copyWith(status: SaveStatus.error);
      return;
    }
    if (!ref.mounted) return;
    ref.read(uiPrefsProvider).lastInvoiceId = inv.id;
    // Edits that arrived while saving stay dirty and get their own save.
    final changed = state.revision != rev;
    state = state.copyWith(
      isNew: false,
      status: changed ? SaveStatus.dirty : SaveStatus.saved,
    );
    if (changed) _schedule();
  }

  // ── Actions ─────────────────────────────────────────────────────────
  Future<Invoice?> _load(String id) async {
    if (state.invoice?.id == id) {
      await flush();
      return state.invoice;
    }
    return ref.read(invoiceRepositoryProvider).getById(id);
  }

  Future<ActionResult> _createFrom(
    Invoice src,
    List<InvoiceSection> sections, {
    required bool keepScope,
    required bool todayDates,
    CalendarDate? on,
  }) async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    final today = on ?? _today;
    final next = await _nextNumber(today.year);
    final terms = src.issueDate.daysUntil(src.dueDate);
    final copy = src.copyWith(
      id: newId(),
      number: next.number,
      year: next.year,
      seq: next.seq,
      status: InvoiceStatus.draft,
      paidDate: () => null,
      issueDate: todayDates ? today : src.issueDate,
      dueDate: todayDates
          ? today.addDays(terms > 0 ? terms : settings.defaultDueDays)
          : src.dueDate,
      scope: keepScope ? src.scope : src.scope.copyWith(enabled: false),
      sections: sections,
      createdAt: 0,
    );
    try {
      if (await ref.read(invoiceRepositoryProvider).save(copy) is! Saved) {
        return const Failed();
      }
    } on Object catch (e) {
      debugPrint('create failed: $e');
      return const Failed();
    }
    await open(copy.id);
    return Created(next.number);
  }

  Future<ActionResult> duplicate(String id) async {
    final src = await _load(id);
    if (src == null || src.clientId.isEmpty) return const Failed();
    return _createFrom(
      src,
      cloneSections(src.sections, newId),
      keepScope: true,
      todayDates: false,
    );
  }

  /// A renewal invoice of [id]'s recurring items, dated [on] (default
  /// today; the calendar passes the renewal day).
  Future<ActionResult> renew(String id, {CalendarDate? on}) async {
    final src = await _load(id);
    if (src == null || src.clientId.isEmpty) return const Failed();
    final sections = renewalSections(src.sections, newId);
    if (sections == null) return NothingToRenew(src.number);
    return _createFrom(
      src,
      sections,
      keepScope: false,
      todayDates: true,
      on: on,
    );
  }

  /// Paid on [on] (default today; the calendar passes the selected day).
  Future<ActionResult> markPaid(String id, {CalendarDate? on}) async {
    final date = on ?? _today;
    if (state.invoice?.id == id) {
      edit(
        (inv) => inv.copyWith(
          status: InvoiceStatus.paid,
          paidDate: () => date,
        ),
      );
      await save();
      return Done(state.invoice!.number);
    }
    final dao = ref.read(invoiceRepositoryProvider);
    final inv = await dao.getById(id);
    if (inv == null) return const Failed();
    await dao.markPaid(id, date);
    return Done(inv.number);
  }

  /// Undo of [markPaid]: sent again, no paid date.
  Future<void> markUnpaid(String id) async {
    if (state.invoice?.id == id) {
      setStatus(InvoiceStatus.sent);
      await save();
      return;
    }
    await ref.read(invoiceRepositoryProvider).markUnpaid(id);
  }

  /// Soft delete. Returns the number for the Undo snackbar.
  Future<String?> delete(String id) async {
    final dao = ref.read(invoiceRepositoryProvider);
    if (state.invoice?.id == id) {
      if (state.isNew) {
        close();
        return null;
      }
      await flush();
      close();
    }
    final inv = await dao.getById(id);
    await dao.softDelete(id);
    return inv?.number;
  }

  /// Saves and closes the open invoice when it belongs to [clientId], before
  /// that client is archived or deleted. An unsaved new invoice is dropped.
  Future<void> closeIfClient(String clientId) async {
    if (state.invoice?.clientId != clientId) return;
    if (!state.isNew) await flush();
    close();
  }

  Future<void> undoDelete(String id) async {
    await ref.read(invoiceRepositoryProvider).undoDelete(id);
    await open(id);
  }
}

final editorProvider = NotifierProvider<EditorController, EditorState>(
  EditorController.new,
);
