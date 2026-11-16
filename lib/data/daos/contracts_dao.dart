import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/daos/library_dao.dart' show decodeStringMap;
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/domain/contract_models.dart';

part 'contracts_dao.g.dart';
part 'contracts/children_sync.dart';

/// Thrown when saving a contract whose number is already used.
class DuplicateContractNumber implements Exception {
  const DuplicateContractNumber(this.number);
  final String number;
  @override
  String toString() => 'DuplicateContractNumber($number)';
}

/// Thrown when deleting a contract that has linked invoices.
class ContractHasInvoices implements Exception {
  const ContractHasInvoices(this.count);
  final int count;
}

/// Owns the contract aggregate: contract + clauses + scope + milestones.
@DriftAccessor(
  tables: [Contracts, ContractClauses, ScopeItems, PaymentMilestones, Invoices],
)
class ContractsDao extends DatabaseAccessor<AppDatabase>
    with _$ContractsDaoMixin {
  ContractsDao(super.attachedDatabase);

  int _now() => clock.now().toUtc().millisecondsSinceEpoch;

  /// Every live contract, fully loaded. Re-emits on any related change.
  Stream<List<Contract>> watchAll() => customSelect(
    // Drift shares watch streams by SQL text: each aggregate needs its own
    // query, or it inherits another stream's table set.
    'SELECT 1 AS contracts_tick',
    readsFrom: {contracts, contractClauses, scopeItems, paymentMilestones},
  ).watch().asyncMap((_) => getAll());

  Future<List<Contract>> getAll({bool includeDeleted = false}) async {
    final q = select(contracts);
    if (!includeDeleted) q.where((c) => c.deletedAt.isNull());
    final rows = await q.get();
    final cl = groupBy(
      await (select(contractClauses)
            ..where((x) => x.deletedAt.isNull())
            ..orderBy([(x) => OrderingTerm.asc(x.position)]))
          .get(),
      (r) => r.contractId,
    );
    final sc = groupBy(
      await (select(scopeItems)
            ..where((x) => x.deletedAt.isNull())
            ..orderBy([(x) => OrderingTerm.asc(x.position)]))
          .get(),
      (r) => r.contractId,
    );
    final ms = groupBy(
      await (select(paymentMilestones)
            ..where((x) => x.deletedAt.isNull())
            ..orderBy([(x) => OrderingTerm.asc(x.position)]))
          .get(),
      (r) => r.contractId,
    );
    return [
      for (final r in rows)
        _toModel(
          r,
          cl[r.id] ?? const [],
          sc[r.id] ?? const [],
          ms[r.id] ?? const [],
        ),
    ];
  }

  Future<Contract?> getById(String id) async {
    final r = await (select(
      contracts,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    if (r == null) return null;
    final cl =
        await (select(contractClauses)
              ..where((x) => x.contractId.equals(id) & x.deletedAt.isNull())
              ..orderBy([(x) => OrderingTerm.asc(x.position)]))
            .get();
    final sc =
        await (select(scopeItems)
              ..where((x) => x.contractId.equals(id) & x.deletedAt.isNull())
              ..orderBy([(x) => OrderingTerm.asc(x.position)]))
            .get();
    final ms =
        await (select(paymentMilestones)
              ..where((x) => x.contractId.equals(id) & x.deletedAt.isNull())
              ..orderBy([(x) => OrderingTerm.asc(x.position)]))
            .get();
    return _toModel(r, cl, sc, ms);
  }

  /// Next sequence in a series for [year] (deleted ones count).
  Future<int> nextSeqFor(TemplateKind series, int year) async {
    final m = contracts.seq.max();
    final q = selectOnly(contracts)
      ..addColumns([m])
      ..where(
        contracts.series.equals(series.dbValue) &
            contracts.year.equals(year) &
            contracts.amendmentNo.equals(0) &
            // The demo set numbers itself apart (DEMO-…, seq 9001+).
            contracts.number.like('DEMO-%').not(),
      );
    return ((await q.getSingle()).read(m) ?? 0) + 1;
  }

  /// Next amendment number for [parentId].
  Future<int> nextAmendmentNo(String parentId) async {
    final m = contracts.amendmentNo.max();
    final q = selectOnly(contracts)
      ..addColumns([m])
      ..where(contracts.parentId.equals(parentId));
    return ((await q.getSingle()).read(m) ?? 0) + 1;
  }

  Future<bool> numberTaken(String number, {String? exceptId}) async {
    final q = select(contracts)..where((c) => c.number.equals(number.trim()));
    if (exceptId != null) q.where((c) => c.id.equals(exceptId).not());
    return (await q.get()).isNotEmpty;
  }

  /// Saves the whole aggregate atomically. Throws [DuplicateContractNumber].
  Future<void> saveContract(Contract c) => transaction(() async {
    final number = c.number.trim();
    final clash =
        await (select(contracts)..where(
              (x) =>
                  (x.number.equals(number) |
                      (x.series.equals(c.series.dbValue) &
                          x.year.equals(c.year) &
                          x.seq.equals(c.seq) &
                          x.amendmentNo.equals(c.amendmentNo))) &
                  x.id.equals(c.id).not(),
            ))
            .get();
    if (clash.isNotEmpty) throw DuplicateContractNumber(number);

    final now = _now();
    await into(contracts).insertOnConflictUpdate(
      ContractsCompanion.insert(
        id: c.id,
        clientId: c.clientId,
        number: number,
        series: c.series.dbValue,
        year: c.year,
        seq: c.seq,
        amendmentNo: Value(c.amendmentNo),
        parentId: Value(c.parentId),
        kind: c.kind.dbValue,
        templateName: Value(c.templateName),
        title: Value(c.title),
        projectName: Value(c.projectName),
        projectSummary: Value(c.projectSummary),
        preamble: Value(c.preamble),
        closing: Value(c.closing),
        issueDate: c.issueDate.toIso(),
        startDate: Value(c.startDate?.toIso()),
        signedDate: Value(c.signedDate?.toIso()),
        endDate: Value(c.endDate?.toIso()),
        status: c.status.dbValue,
        jurisdiction: Value(c.jurisdiction),
        currency: c.currency.code,
        totalMinor: Value(c.totalMinor),
        vars: Value(jsonEncode(c.vars)),
        outOfScope: Value(c.outOfScope),
        unlocked: Value(c.unlocked),
        history: Value(
          jsonEncode([for (final e in c.history) e.toJson()]),
        ),
        isDemo: Value(c.isDemo),
        createdAt: c.createdAt == 0 ? now : c.createdAt,
        updatedAt: now,
      ),
    );
    await _syncChildren(c, now);
  });

  /// Links a milestone to an invoice (after "إنشاء فاتورة").
  Future<void> linkMilestone(String milestoneId, String invoiceId) =>
      transaction(() async {
        await (update(
          paymentMilestones,
        )..where((m) => m.id.equals(milestoneId))).write(
          PaymentMilestonesCompanion(
            invoiceId: Value(invoiceId),
            updatedAt: Value(_now()),
          ),
        );
      });

  /// Live invoices linked to [c]: by milestone or by `contractRef`.
  Future<int> countLinkedInvoices(Contract c) async {
    final ids = {
      for (final m in c.milestones)
        if (m.invoiceId != null) m.invoiceId!,
    };
    final rows =
        await (select(invoices)..where(
              (i) =>
                  i.deletedAt.isNull() &
                  (i.contractRef.equals(c.number) | i.id.isIn(ids)),
            ))
            .get();
    return rows.length;
  }

  /// Soft delete with its amendments (same timestamp). Refused with
  /// [ContractHasInvoices] when invoices are linked. Returns the stamp.
  Future<int> softDelete(String id) => transaction(() async {
    final c = await getById(id);
    if (c == null) return 0;
    final linked = await countLinkedInvoices(c);
    if (linked > 0) throw ContractHasInvoices(linked);
    final stamp = _now();
    await (update(contracts)..where(
          (x) =>
              (x.id.equals(id) | x.parentId.equals(id)) & x.deletedAt.isNull(),
        ))
        .write(
          ContractsCompanion(deletedAt: Value(stamp), updatedAt: Value(stamp)),
        );
    return stamp;
  });

  Future<void> undoDelete(String id, int stamp) => transaction(() async {
    await (update(contracts)..where(
          (x) =>
              (x.id.equals(id) | x.parentId.equals(id)) &
              x.deletedAt.equals(stamp),
        ))
        .write(
          ContractsCompanion(
            deletedAt: const Value(null),
            updatedAt: Value(_now()),
          ),
        );
  });

  /// Hard-deletes contracts soft-deleted more than [age] ago, and clause,
  /// scope and milestone tombstones of the same age.
  // TODO(sync): once sync exists, keep tombstones that were never pushed.
  Future<int> purgeDeleted({Duration age = const Duration(days: 30)}) =>
      transaction(() async {
        final cutoff = _now() - age.inMilliseconds;
        await (delete(
          contractClauses,
        )..where((x) => x.deletedAt.isSmallerThanValue(cutoff))).go();
        await (delete(
          scopeItems,
        )..where((x) => x.deletedAt.isSmallerThanValue(cutoff))).go();
        await (delete(
          paymentMilestones,
        )..where((x) => x.deletedAt.isSmallerThanValue(cutoff))).go();
        return (delete(
          contracts,
        )..where((c) => c.deletedAt.isSmallerThanValue(cutoff))).go();
      });

  Contract _toModel(
    ContractRow r,
    List<ContractClauseRow> cl,
    List<ScopeItemRow> sc,
    List<MilestoneRow> ms,
  ) => Contract(
    id: r.id,
    clientId: r.clientId,
    number: r.number,
    series: TemplateKind.fromDb(r.series),
    year: r.year,
    seq: r.seq,
    amendmentNo: r.amendmentNo,
    parentId: r.parentId,
    kind: ContractKind.fromDb(r.kind),
    templateName: r.templateName,
    title: r.title,
    projectName: r.projectName,
    projectSummary: r.projectSummary,
    preamble: r.preamble,
    closing: r.closing,
    issueDate: CalendarDate.parse(r.issueDate),
    startDate: CalendarDate.tryParse(r.startDate),
    signedDate: CalendarDate.tryParse(r.signedDate),
    endDate: CalendarDate.tryParse(r.endDate),
    status: ContractStatus.fromDb(r.status),
    jurisdiction: r.jurisdiction,
    currency: Currency.fromCode(r.currency),
    totalMinor: r.totalMinor,
    vars: decodeStringMap(r.vars),
    outOfScope: r.outOfScope,
    unlocked: r.unlocked,
    history: _decodeHistory(r.history),
    clauses: [
      for (final x in cl)
        ContractClause(
          id: x.id,
          title: x.title,
          body: x.body,
          enabled: x.enabled,
          optional: x.optional,
          fromLibraryClauseId: x.fromLibraryClauseId,
        ),
    ],
    scope: [
      for (final x in sc)
        ScopeItem(
          id: x.id,
          phase: x.phase,
          item: x.item,
          description: x.description,
          acceptance: x.acceptance,
        ),
    ],
    milestones: [
      for (final x in ms)
        PaymentMilestone(
          id: x.id,
          label: x.label,
          percentBp: x.percentBp,
          amountMinor: x.amountMinor,
          trigger: x.trigger,
          dueDate: CalendarDate.tryParse(x.dueDate),
          invoiceId: x.invoiceId,
        ),
    ],
    isDemo: r.isDemo,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  static List<ContractEvent> _decodeHistory(String json) {
    try {
      final v = jsonDecode(json);
      if (v is List) {
        return [
          for (final e in v)
            if (e is Map && e['at'] is int && e['event'] is String)
              ContractEvent(at: e['at'] as int, event: e['event'] as String),
        ];
      }
    } on FormatException {
      // fall through
    }
    return const [];
  }
}
