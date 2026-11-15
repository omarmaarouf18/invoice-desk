part of '../contracts_dao.dart';

extension _ChildrenSync on ContractsDao {
  /// Upserts changed clauses, scope rows and milestones and tombstones the
  /// removed ones (v4: no hard deletes before purge). Unchanged rows are not
  /// written.
  Future<void> _syncChildren(Contract c, int now) async {
    bool same(List<Object?> a, List<Object?> b) =>
        const ListEquality<Object?>().equals(a, b);

    final oldCl = {
      for (final r in await (select(
        contractClauses,
      )..where((x) => x.contractId.equals(c.id))).get())
        r.id: r,
    };
    for (final r in oldCl.values) {
      if (r.deletedAt == null && !c.clauses.any((x) => x.id == r.id)) {
        await (update(contractClauses)..where((x) => x.id.equals(r.id))).write(
          ContractClausesCompanion(
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }
    }
    for (final (i, x) in c.clauses.indexed) {
      final o = oldCl[x.id];
      if (o != null &&
          o.deletedAt == null &&
          same(
            [
              o.position,
              o.title,
              o.body,
              o.enabled,
              o.optional,
              o.fromLibraryClauseId,
            ],
            [i, x.title, x.body, x.enabled, x.optional, x.fromLibraryClauseId],
          )) {
        continue;
      }
      await into(contractClauses).insertOnConflictUpdate(
        ContractClausesCompanion.insert(
          id: x.id,
          contractId: c.id,
          position: i,
          title: Value(x.title),
          body: Value(x.body),
          enabled: Value(x.enabled),
          optional: Value(x.optional),
          fromLibraryClauseId: Value(x.fromLibraryClauseId),
          updatedAt: Value(now),
          deletedAt: const Value(null),
        ),
      );
    }

    final oldSc = {
      for (final r in await (select(
        scopeItems,
      )..where((x) => x.contractId.equals(c.id))).get())
        r.id: r,
    };
    for (final r in oldSc.values) {
      if (r.deletedAt == null && !c.scope.any((x) => x.id == r.id)) {
        await (update(scopeItems)..where((x) => x.id.equals(r.id))).write(
          ScopeItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
    }
    for (final (i, x) in c.scope.indexed) {
      final o = oldSc[x.id];
      if (o != null &&
          o.deletedAt == null &&
          same(
            [o.position, o.phase, o.item, o.description, o.acceptance],
            [i, x.phase, x.item, x.description, x.acceptance],
          )) {
        continue;
      }
      await into(scopeItems).insertOnConflictUpdate(
        ScopeItemsCompanion.insert(
          id: x.id,
          contractId: c.id,
          position: i,
          phase: Value(x.phase),
          item: Value(x.item),
          description: Value(x.description),
          acceptance: Value(x.acceptance),
          updatedAt: Value(now),
          deletedAt: const Value(null),
        ),
      );
    }

    final oldMs = {
      for (final r in await (select(
        paymentMilestones,
      )..where((x) => x.contractId.equals(c.id))).get())
        r.id: r,
    };
    for (final r in oldMs.values) {
      if (r.deletedAt == null && !c.milestones.any((x) => x.id == r.id)) {
        await (update(
          paymentMilestones,
        )..where((x) => x.id.equals(r.id))).write(
          PaymentMilestonesCompanion(
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
      }
    }
    for (final (i, x) in c.milestones.indexed) {
      // A milestone may point at an invoice that was purged since.
      final inv = x.invoiceId == null
          ? null
          : await (select(
              invoices,
            )..where((v) => v.id.equals(x.invoiceId!))).getSingleOrNull();
      final o = oldMs[x.id];
      if (o != null &&
          o.deletedAt == null &&
          same(
            [
              o.position,
              o.label,
              o.percentBp,
              o.amountMinor,
              o.trigger,
              o.dueDate,
              o.invoiceId,
            ],
            [
              i,
              x.label,
              x.percentBp,
              x.amountMinor,
              x.trigger,
              x.dueDate?.toIso(),
              inv?.id,
            ],
          )) {
        continue;
      }
      await into(paymentMilestones).insertOnConflictUpdate(
        PaymentMilestonesCompanion.insert(
          id: x.id,
          contractId: c.id,
          position: i,
          label: Value(x.label),
          percentBp: Value(x.percentBp),
          amountMinor: Value(x.amountMinor),
          trigger: Value(x.trigger),
          dueDate: Value(x.dueDate?.toIso()),
          invoiceId: Value(inv?.id),
          updatedAt: Value(now),
          deletedAt: const Value(null),
        ),
      );
    }
  }
}
