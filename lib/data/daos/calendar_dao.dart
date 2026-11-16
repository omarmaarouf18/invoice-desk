import 'package:clock/clock.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/tables_calendar.dart';
import 'package:invoice_desk/domain/calendar/models.dart';

part 'calendar_dao.g.dart';

/// The calendar's two stored tables: the postponement history and manual
/// reminders. Everything else on the calendar is derived.
@DriftAccessor(tables: [Postponements, Reminders])
class CalendarDao extends DatabaseAccessor<AppDatabase>
    with _$CalendarDaoMixin {
  CalendarDao(super.attachedDatabase);

  int _now() => clock.now().toUtc().millisecondsSinceEpoch;

  // ── Postponements ────────────────────────────────────────────────────

  Stream<List<Postponement>> watchPostponements() =>
      (select(postponements)
            ..where((p) => p.deletedAt.isNull())
            ..orderBy([
              (p) => OrderingTerm.asc(p.createdAt),
              (p) => OrderingTerm.asc(p.id),
            ]))
          .watch()
          .map((rows) => rows.map(_postponement).toList());

  Future<List<Postponement>> postponementsOf(String entityId) async =>
      (await (select(postponements)
                ..where(
                  (p) => p.entityId.equals(entityId) & p.deletedAt.isNull(),
                )
                ..orderBy([
                  (p) => OrderingTerm.asc(p.createdAt),
                  (p) => OrderingTerm.asc(p.id),
                ]))
              .get())
          .map(_postponement)
          .toList();

  Future<List<Postponement>> allPostponements() async =>
      (await (select(postponements)
                ..where((p) => p.deletedAt.isNull())
                ..orderBy([(p) => OrderingTerm.asc(p.createdAt)]))
              .get())
          .map(_postponement)
          .toList();

  /// Appends a move; the history is never rewritten.
  Future<void> addPostponement(Postponement p) => transaction(() async {
    final now = _now();
    await into(postponements).insert(
      PostponementsCompanion.insert(
        id: p.id,
        entityType: p.entityType.dbValue,
        entityId: p.entityId,
        fromDate: p.fromDate.toIso(),
        toDate: p.toDate.toIso(),
        reason: Value(p.reason.trim()),
        createdAt: p.createdAt == 0 ? now : p.createdAt,
        updatedAt: now,
      ),
    );
  });

  /// Undo of [addPostponement]: tombstones the row (sync sees it).
  Future<void> removePostponement(String id) => transaction(() async {
    final now = _now();
    await (update(postponements)..where((p) => p.id.equals(id))).write(
      PostponementsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  });

  Postponement _postponement(PostponementRow r) => Postponement(
    id: r.id,
    entityType: PostponedEntity.fromDb(r.entityType),
    entityId: r.entityId,
    fromDate: CalendarDate.parse(r.fromDate),
    toDate: CalendarDate.parse(r.toDate),
    reason: r.reason,
    createdAt: r.createdAt,
  );

  // ── Reminders ────────────────────────────────────────────────────────

  Stream<List<Reminder>> watchReminders() =>
      (select(reminders)
            ..where((r) => r.deletedAt.isNull())
            ..orderBy([
              (r) => OrderingTerm.asc(r.date),
              (r) => OrderingTerm.asc(r.time),
            ]))
          .watch()
          .map((rows) => rows.map(_reminder).toList());

  Future<List<Reminder>> allReminders() async => (await (select(
    reminders,
  )..where((r) => r.deletedAt.isNull())).get()).map(_reminder).toList();

  Future<Reminder?> reminderById(String id) async {
    final r = await (select(
      reminders,
    )..where((x) => x.id.equals(id))).getSingleOrNull();
    return r == null ? null : _reminder(r);
  }

  /// Inserts or updates; also revives a deleted one (undo).
  Future<void> saveReminder(Reminder r) => transaction(() async {
    final now = _now();
    final existing = await (select(
      reminders,
    )..where((x) => x.id.equals(r.id))).getSingleOrNull();
    await into(reminders).insertOnConflictUpdate(
      RemindersCompanion.insert(
        id: r.id,
        date: r.date.toIso(),
        time: Value(r.time),
        body: r.text.trim(),
        clientId: Value(r.clientId),
        entityType: Value(r.linkType?.dbValue),
        entityId: Value(r.linkId),
        doneAt: Value(r.doneAt),
        deletedAt: const Value(null),
        isDemo: Value(r.isDemo),
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
      ),
    );
  });

  Future<void> deleteReminder(String id) => transaction(() async {
    final now = _now();
    await (update(reminders)..where((r) => r.id.equals(id))).write(
      RemindersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  });

  /// Hard-deletes tombstones older than [age] and postponements whose
  /// invoice or milestone no longer exists.
  Future<void> purge({Duration age = const Duration(days: 30)}) =>
      transaction(() async {
        final cutoff = _now() - age.inMilliseconds;
        await (delete(
          reminders,
        )..where((r) => r.deletedAt.isSmallerThanValue(cutoff))).go();
        await (delete(
          postponements,
        )..where((p) => p.deletedAt.isSmallerThanValue(cutoff))).go();
        await customStatement(
          'DELETE FROM postponements WHERE '
          "(entity_type = 'invoice' AND entity_id NOT IN "
          '(SELECT id FROM invoices)) OR '
          "(entity_type = 'milestone' AND entity_id NOT IN "
          '(SELECT id FROM payment_milestones))',
        );
      });

  Reminder _reminder(ReminderRow r) => Reminder(
    id: r.id,
    date: CalendarDate.parse(r.date),
    time: r.time,
    text: r.body,
    clientId: r.clientId,
    linkType: ReminderLink.fromDb(r.entityType),
    linkId: r.entityId,
    doneAt: r.doneAt,
    isDemo: r.isDemo,
  );
}
