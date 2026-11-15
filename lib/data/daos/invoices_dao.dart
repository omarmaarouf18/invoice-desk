import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/tables.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

part 'invoices_dao.g.dart';

/// Thrown when saving an invoice whose number (or year/seq) is already used.
class DuplicateInvoiceNumber implements Exception {
  const DuplicateInvoiceNumber(this.number);
  final String number;
  @override
  String toString() => 'DuplicateInvoiceNumber($number)';
}

/// Owns the invoice aggregate: invoices + sections + items.
@DriftAccessor(tables: [Invoices, Sections, Items])
class InvoicesDao extends DatabaseAccessor<AppDatabase>
    with _$InvoicesDaoMixin {
  InvoicesDao(super.attachedDatabase);

  int _now() => clock.now().toUtc().millisecondsSinceEpoch;

  /// Every live (not soft-deleted) invoice, fully loaded. Re-emits on any
  /// change to invoices, sections or items.
  Stream<List<Invoice>> watchAll() => customSelect(
    // Drift shares watch streams by SQL text: each aggregate needs its own
    // query, or it inherits another stream's table set.
    'SELECT 1 AS invoices_tick',
    readsFrom: {invoices, sections, items},
  ).watch().asyncMap((_) => getAll());

  Future<List<Invoice>> getAll({bool includeDeleted = false}) async {
    final q = select(invoices);
    if (!includeDeleted) q.where((i) => i.deletedAt.isNull());
    final invRows = await q.get();
    final secRows =
        await (select(sections)
              ..where((s) => s.deletedAt.isNull())
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();
    final itemRows =
        await (select(items)
              ..where((i) => i.deletedAt.isNull())
              ..orderBy([(i) => OrderingTerm.asc(i.position)]))
            .get();
    final itemsBySection = groupBy(itemRows, (r) => r.sectionId);
    final sectionsByInvoice = groupBy(secRows, (r) => r.invoiceId);
    return [
      for (final r in invRows)
        _toModel(
          r,
          [
            for (final s in sectionsByInvoice[r.id] ?? const <SectionRow>[])
              _sectionToModel(s, itemsBySection[s.id] ?? const []),
          ],
        ),
    ];
  }

  Future<Invoice?> getById(String id) async {
    final r = await (select(
      invoices,
    )..where((i) => i.id.equals(id))).getSingleOrNull();
    if (r == null) return null;
    final secRows =
        await (select(sections)
              ..where((s) => s.invoiceId.equals(id) & s.deletedAt.isNull())
              ..orderBy([(s) => OrderingTerm.asc(s.position)]))
            .get();
    final out = <InvoiceSection>[];
    for (final s in secRows) {
      final itemRows =
          await (select(items)
                ..where((i) => i.sectionId.equals(s.id) & i.deletedAt.isNull())
                ..orderBy([(i) => OrderingTerm.asc(i.position)]))
              .get();
      out.add(_sectionToModel(s, itemRows));
    }
    return _toModel(r, out);
  }

  /// Year/seq pairs in use, soft-deleted invoices included.
  Future<List<({int year, int seq})>> usedSequences() async {
    final rows = await (selectOnly(
      invoices,
    )..addColumns([invoices.year, invoices.seq])).get();
    return [
      for (final r in rows)
        (year: r.read(invoices.year)!, seq: r.read(invoices.seq)!),
    ];
  }

  Future<int> nextSeqFor(int year) async =>
      nextSeq(await usedSequences(), year);

  Future<bool> numberTaken(String number, {String? exceptId}) async {
    final q = select(invoices)..where((i) => i.number.equals(number.trim()));
    if (exceptId != null) q.where((i) => i.id.equals(exceptId).not());
    return (await q.get()).isNotEmpty;
  }

  /// Saves the whole aggregate atomically: invoice row, then sections and
  /// items are replaced. Throws [DuplicateInvoiceNumber].
  Future<void> saveInvoice(Invoice inv) => transaction(() async {
    final number = inv.number.trim();
    final parsed = parseInvoiceNumber(number);
    var year = parsed?.year ?? inv.issueDate.year;
    var seq = parsed?.seq ?? inv.seq;

    final clash =
        await (select(invoices)..where(
              (i) =>
                  (i.number.equals(number) |
                      (i.year.equals(year) & i.seq.equals(seq))) &
                  i.id.equals(inv.id).not(),
            ))
            .get();
    if (clash.any((c) => c.number == number)) {
      throw DuplicateInvoiceNumber(number);
    }
    if (clash.isNotEmpty) {
      if (parsed != null) throw DuplicateInvoiceNumber(number);
      // Free-form number: give it an unused sequence for its year.
      year = inv.issueDate.year;
      seq = await nextSeqFor(year);
    }

    final now = _now();
    await into(invoices).insertOnConflictUpdate(
      InvoicesCompanion.insert(
        id: inv.id,
        clientId: inv.clientId,
        number: number,
        year: year,
        seq: seq,
        issueDate: inv.issueDate.toIso(),
        dueDate: inv.dueDate.toIso(),
        paidDate: Value(inv.paidDate?.toIso()),
        status: inv.status.dbValue,
        contractRef: Value(inv.contractRef.trim()),
        vatOn: Value(inv.vatOn),
        vatRateBp: Value(inv.vatRateBp),
        notesEn: Value(inv.notesEn),
        notesAr: Value(inv.notesAr),
        scopeOn: Value(inv.scope.enabled),
        scopeTitle: Value(inv.scope.title),
        scopeOverview: Value(inv.scope.overview),
        scopeDone: Value(inv.scope.done),
        scopeDelivered: Value(inv.scope.delivered),
        scopeWarranty: Value(inv.scope.warranty),
        createdAt: inv.createdAt == 0 ? now : inv.createdAt,
        updatedAt: now,
      ),
    );
    await _syncChildren(inv, now);
  });

  /// Upserts the sections and items that changed and tombstones the ones
  /// that were removed (v4: no hard deletes before purge, so a future sync
  /// sees every change). Unchanged rows are not written, so their `rev`
  /// doesn't move.
  Future<void> _syncChildren(Invoice inv, int now) async {
    final oldSections = {
      for (final r in await (select(
        sections,
      )..where((s) => s.invoiceId.equals(inv.id))).get())
        r.id: r,
    };
    final oldItems = {
      for (final r in await (select(
        items,
      )..where((i) => i.sectionId.isIn(oldSections.keys))).get())
        r.id: r,
    };
    final keepSections = {for (final s in inv.sections) s.id};
    final keepItems = {
      for (final s in inv.sections)
        for (final i in s.items) i.id,
    };
    for (final r in oldItems.values) {
      if (!keepItems.contains(r.id) && r.deletedAt == null) {
        await (update(items)..where((i) => i.id.equals(r.id))).write(
          ItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
    }
    for (final r in oldSections.values) {
      if (!keepSections.contains(r.id) && r.deletedAt == null) {
        await (update(sections)..where((x) => x.id.equals(r.id))).write(
          SectionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
    }
    for (final (si, s) in inv.sections.indexed) {
      final old = oldSections[s.id];
      final same =
          old != null &&
          old.deletedAt == null &&
          old.position == si &&
          old.titleEn == s.titleEn &&
          old.titleAr == s.titleAr &&
          old.currency == s.currency.code;
      if (!same) {
        await into(sections).insertOnConflictUpdate(
          SectionsCompanion.insert(
            id: s.id,
            invoiceId: inv.id,
            position: si,
            titleEn: Value(s.titleEn),
            titleAr: Value(s.titleAr),
            currency: s.currency.code,
            updatedAt: Value(now),
            deletedAt: const Value(null),
          ),
        );
      }
      for (final (ii, it) in s.items.indexed) {
        final o = oldItems[it.id];
        final sameItem =
            o != null &&
            o.deletedAt == null &&
            o.sectionId == s.id &&
            o.position == ii &&
            o.service == it.service &&
            o.description == it.description &&
            o.cycle == it.cycle.dbValue &&
            o.qty == it.qty &&
            o.unitPriceMinor == it.unitPriceMinor;
        if (sameItem) continue;
        await into(items).insertOnConflictUpdate(
          ItemsCompanion.insert(
            id: it.id,
            sectionId: s.id,
            position: ii,
            service: Value(it.service),
            description: Value(it.description),
            cycle: it.cycle.dbValue,
            qty: it.qty,
            unitPriceMinor: it.unitPriceMinor,
            updatedAt: Value(now),
            deletedAt: const Value(null),
          ),
        );
      }
    }
  }

  Future<void> softDelete(String id) => transaction(() async {
    await (update(invoices)..where((i) => i.id.equals(id))).write(
      InvoicesCompanion(deletedAt: Value(_now()), updatedAt: Value(_now())),
    );
  });

  Future<void> undoDelete(String id) => transaction(() async {
    await (update(invoices)..where((i) => i.id.equals(id))).write(
      InvoicesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  });

  /// Hard-deletes invoices soft-deleted more than [age] ago, and section
  /// and item tombstones of the same age.
  // TODO(sync): once sync exists, keep tombstones that were never pushed.
  Future<int> purgeDeleted({Duration age = const Duration(days: 30)}) =>
      transaction(() async {
        final cutoff = _now() - age.inMilliseconds;
        await (delete(
          items,
        )..where((i) => i.deletedAt.isSmallerThanValue(cutoff))).go();
        await (delete(
          sections,
        )..where((x) => x.deletedAt.isSmallerThanValue(cutoff))).go();
        return (delete(
          invoices,
        )..where((i) => i.deletedAt.isSmallerThanValue(cutoff))).go();
      });

  Future<void> markPaid(String id, CalendarDate date) => transaction(() async {
    await (update(invoices)..where((i) => i.id.equals(id))).write(
      InvoicesCompanion(
        status: const Value('paid'),
        paidDate: Value(date.toIso()),
        updatedAt: Value(_now()),
      ),
    );
  });

  Future<int> countLive() async {
    final c = invoices.id.count();
    final q = selectOnly(invoices)
      ..addColumns([c])
      ..where(invoices.deletedAt.isNull());
    return (await q.getSingle()).read(c)!;
  }

  Invoice _toModel(InvoiceRow r, List<InvoiceSection> secs) => Invoice(
    id: r.id,
    clientId: r.clientId,
    number: r.number,
    year: r.year,
    seq: r.seq,
    issueDate: CalendarDate.parse(r.issueDate),
    dueDate: CalendarDate.parse(r.dueDate),
    paidDate: CalendarDate.tryParse(r.paidDate),
    status: InvoiceStatus.fromDb(r.status),
    contractRef: r.contractRef,
    vatOn: r.vatOn,
    vatRateBp: r.vatRateBp,
    notesEn: r.notesEn,
    notesAr: r.notesAr,
    scope: ScopePage(
      enabled: r.scopeOn,
      title: r.scopeTitle,
      overview: r.scopeOverview,
      done: r.scopeDone,
      delivered: r.scopeDelivered,
      warranty: r.scopeWarranty,
    ),
    sections: secs,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  InvoiceSection _sectionToModel(SectionRow s, List<ItemRow> rows) =>
      InvoiceSection(
        id: s.id,
        titleEn: s.titleEn,
        titleAr: s.titleAr,
        currency: Currency.fromCode(s.currency),
        items: [
          for (final i in rows)
            LineItem(
              id: i.id,
              service: i.service,
              description: i.description,
              cycle: BillingCycle.fromDb(i.cycle),
              qty: i.qty,
              unitPriceMinor: i.unitPriceMinor,
            ),
        ],
      );
}
