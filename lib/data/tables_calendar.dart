// The column getters read like the other tables' (drift sees a recursive
// getter, the lint does not).
// ignore_for_file: recursive_getters
// The calendar's own tables (schema v5): the history of moved due dates and
// the manual reminders. They live apart from the document tables so that
// both files stay readable.
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/tables.dart';

/// History of moved due dates (invoice or milestone); the latest row by
/// createdAt is the effective date, the original is never overwritten.
@DataClassName('PostponementRow')
@TableIndex(name: 'postponements_entity', columns: {#entityId})
class Postponements extends Table with SyncRev {
  TextColumn get id => text()();
  TextColumn get entityType =>
      text().check(entityType.isIn(const ['invoice', 'milestone']))();

  /// Not a foreign key: one column, two tables.
  TextColumn get entityId => text()();
  TextColumn get fromDate => text()();
  TextColumn get toDate => text()();
  TextColumn get reason => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

/// A manual calendar reminder (optional time, client and document).
@DataClassName('ReminderRow')
@TableIndex(name: 'reminders_date', columns: {#date})
class Reminders extends Table with SyncRev {
  TextColumn get id => text()();
  TextColumn get date => text()();

  /// `HH:MM`, 24-hour; null for an all-day reminder.
  TextColumn get time => text().nullable()();
  TextColumn get body =>
      text().named('text').check(body.trim().length.isBiggerThanValue(0))();
  TextColumn get clientId => text().nullable().references(
    Clients,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// `invoice` or `contract`, with [entityId]; both null when unlinked.
  TextColumn get entityType => text().nullable().check(
    entityType.isIn(const ['invoice', 'contract']),
  )();
  TextColumn get entityId => text().nullable()();
  IntColumn get doneAt => integer().nullable()();
  IntColumn get deletedAt => integer().nullable()();
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}
