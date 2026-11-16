import 'package:clock/clock.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/daos/calendar_dao.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:uuid/uuid.dart';

/// The calendar's stored half: the postponement history and reminders.
/// Everything else on the calendar is derived (see `calendarEvents`).
class CalendarRepository with ClockedRepository {
  /// Wraps [_db]; writes are stamped with [clock].
  CalendarRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  CalendarDao get _dao => _db.calendarDao;

  /// The whole (live) postponement history, oldest first.
  Stream<List<Postponement>> watchPostponements() => _dao.watchPostponements();

  /// One entity's history, oldest first.
  Future<List<Postponement>> historyOf(String entityId) =>
      _dao.postponementsOf(entityId);

  /// Live reminders, by date and time.
  Stream<List<Reminder>> watchReminders() => _dao.watchReminders();

  /// Appends a move of [entityId]'s due date from [from] to [to]; returns
  /// the new row's id (for undo).
  Future<String> postpone({
    required PostponedEntity type,
    required String entityId,
    required CalendarDate from,
    required CalendarDate to,
    String reason = '',
  }) => at(() async {
    final id = const Uuid().v4();
    await _dao.addPostponement(
      Postponement(
        id: id,
        entityType: type,
        entityId: entityId,
        fromDate: from,
        toDate: to,
        reason: reason,
      ),
    );
    return id;
  });

  /// Undo of [postpone].
  Future<void> undoPostpone(String id) => at(() => _dao.removePostponement(id));

  /// Inserts or updates (also revives a deleted one, for undo).
  Future<void> saveReminder(Reminder r) => at(() => _dao.saveReminder(r));

  /// The reminder with [id], deleted or not.
  Future<Reminder?> reminderById(String id) => _dao.reminderById(id);

  /// Marks [r] done (or open again with [done] false).
  Future<void> setDone(Reminder r, {required bool done}) => at(
    () => _dao.saveReminder(
      r.copyWith(
        doneAt: () => done ? clock.now().toUtc().millisecondsSinceEpoch : null,
      ),
    ),
  );

  /// Tombstones the reminder; [saveReminder] with it undoes this.
  Future<void> deleteReminder(String id) => at(() => _dao.deleteReminder(id));

  /// Purges old tombstones and orphaned postponements.
  Future<void> purge() => at(_dao.purge);
}
