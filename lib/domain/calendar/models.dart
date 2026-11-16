import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:meta/meta.dart';

/// What a postponement moves.
enum PostponedEntity {
  /// An invoice's due date.
  invoice('invoice'),

  /// A contract payment milestone's due date.
  milestone('milestone');

  const PostponedEntity(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static PostponedEntity fromDb(String v) =>
      PostponedEntity.values.firstWhere((e) => e.dbValue == v);
}

@immutable
/// One move of a due date. Rows are a history: the latest one (by
/// [createdAt]) is the effective date, the original stays on the entity.
class Postponement {
  /// A postponement; ids are UUIDs.
  const Postponement({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.fromDate,
    required this.toDate,
    this.reason = '',
    this.createdAt = 0,
  });

  /// Stable UUID.
  final String id;

  /// Invoice or milestone.
  final PostponedEntity entityType;

  /// The invoice's or milestone's id.
  final String entityId;

  /// The due date before this move.
  final CalendarDate fromDate;

  /// The new due date.
  final CalendarDate toDate;

  /// Why it moved; shown under the event.
  final String reason;

  /// UTC epoch ms; orders the history.
  final int createdAt;
}

/// The latest postponement per entity id; ties on [Postponement.createdAt]
/// go to the later row in [all].
Map<String, Postponement> latestPostponements(Iterable<Postponement> all) {
  final out = <String, Postponement>{};
  for (final p in all) {
    final cur = out[p.entityId];
    if (cur == null || p.createdAt >= cur.createdAt) out[p.entityId] = p;
  }
  return out;
}

/// What a reminder is about, besides its client.
enum ReminderLink {
  /// An invoice.
  invoice('invoice'),

  /// A contract.
  contract('contract');

  const ReminderLink(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; null for null or unknown values.
  static ReminderLink? fromDb(String? v) =>
      ReminderLink.values.where((e) => e.dbValue == v).firstOrNull;
}

@immutable
/// A manual calendar entry.
class Reminder {
  /// A reminder; ids are UUIDs.
  const Reminder({
    required this.id,
    required this.date,
    required this.text,
    this.time,
    this.clientId,
    this.linkType,
    this.linkId,
    this.doneAt,
    this.isDemo = false,
  });

  /// Stable UUID.
  final String id;

  /// The day it is for.
  final CalendarDate date;

  /// `HH:MM` (24-hour); null for all day.
  final String? time;

  /// What to do; never empty.
  final String text;

  /// Optional client.
  final String? clientId;

  /// Optional linked document type, with [linkId].
  final ReminderLink? linkType;

  /// The linked invoice's or contract's id.
  final String? linkId;

  /// UTC epoch ms when marked done; null while open.
  final int? doneAt;

  /// Part of the demo set.
  final bool isDemo;

  /// Marked done.
  bool get isDone => doneAt != null;

  /// A copy with the given fields replaced; nullable fields take a
  /// function so they can be cleared.
  Reminder copyWith({
    CalendarDate? date,
    String? Function()? time,
    String? text,
    String? Function()? clientId,
    int? Function()? doneAt,
  }) => Reminder(
    id: id,
    date: date ?? this.date,
    time: time != null ? time() : this.time,
    text: text ?? this.text,
    clientId: clientId != null ? clientId() : this.clientId,
    linkType: linkType,
    linkId: linkId,
    doneAt: doneAt != null ? doneAt() : this.doneAt,
    isDemo: isDemo,
  );
}

/// The kinds of calendar events. Order is the order within a day.
enum CalendarEventType {
  /// Sent invoice past its effective due date.
  overdue,

  /// Today only: every overdue invoice rolled into one line.
  overdueRollup,

  /// Sent invoice due on this day.
  due,

  /// Invoice or milestone moved to this day.
  postponed,

  /// Contract payment milestone due, not invoiced yet.
  milestone,

  /// Recurring items of a paid invoice renew.
  renewal,

  /// Manual reminder.
  reminder,

  /// Invoice paid on this day.
  paid,

  /// Contract starts.
  contractStart,

  /// Contract ends.
  contractEnd,

  /// Warranty of a contract or an invoice's scope ends.
  warrantyEnd;

  /// Counts towards what is due on a day (day totals, "متوقع تحصيله").
  bool get isReceivable =>
      this == due ||
      this == overdue ||
      this == postponed ||
      this == milestone ||
      this == renewal;

  /// Can be dragged to another day (= postpone or move).
  bool get isMovable =>
      this == due ||
      this == overdue ||
      this == postponed ||
      this == milestone ||
      this == reminder;
}

@immutable
/// One derived calendar entry. Never stored; recomputed from the data.
class CalendarEvent {
  /// An event; [id] is stable across recomputations (and ICS exports).
  const CalendarEvent({
    required this.id,
    required this.type,
    required this.date,
    this.title = '',
    this.time,
    this.originalDate,
    this.reason = '',
    this.clientId,
    this.clientName = '',
    this.amounts = const [],
    this.invoiceId,
    this.contractId,
    this.milestoneId,
    this.reminderId,
    this.daysOverdue = 0,
    this.isLate = false,
    this.done = false,
    this.count = 0,
  });

  /// Stable id, e.g. `invoice-due-<uuid>`; also the ICS UID's local part.
  final String id;

  /// Kind of event.
  final CalendarEventType type;

  /// The (effective) day.
  final CalendarDate date;

  /// Invoice or contract number, service names, contract title or
  /// reminder text.
  final String title;

  /// `HH:MM` for timed reminders.
  final String? time;

  /// The original due date of a postponed entity (shown struck through).
  final CalendarDate? originalDate;

  /// Postponement reason.
  final String reason;

  /// The client, when there is one.
  final String? clientId;

  /// The client's display name.
  final String clientName;

  /// Per-currency amounts; never summed across currencies.
  final List<Money> amounts;

  /// Source invoice.
  final String? invoiceId;

  /// Source contract.
  final String? contractId;

  /// Source milestone.
  final String? milestoneId;

  /// Source reminder.
  final String? reminderId;

  /// Days past the effective due date (overdue only).
  final int daysOverdue;

  /// Past its date and still unpaid (overdue, late milestone).
  final bool isLate;

  /// Reminder marked done.
  final bool done;

  /// How many invoices a rollup stands for.
  final int count;
}

@immutable
/// A closed range of days.
class DateRange {
  /// [start] to [end], both included.
  const DateRange(this.start, this.end);

  /// First day.
  final CalendarDate start;

  /// Last day (included).
  final CalendarDate end;

  /// [d] falls inside.
  bool contains(CalendarDate d) => d.isWithin(start, end);
}

@immutable
/// Everything `calendarEvents` derives from. Deleted rows are left out by
/// the caller.
class CalendarData {
  /// The snapshot.
  const CalendarData({
    this.invoices = const [],
    this.contracts = const [],
    this.clients = const [],
    this.postponements = const [],
    this.reminders = const [],
  });

  /// Live invoices.
  final List<Invoice> invoices;

  /// Live contracts.
  final List<Contract> contracts;

  /// Live clients (names for labels).
  final List<Client> clients;

  /// The whole postponement history.
  final List<Postponement> postponements;

  /// Live reminders.
  final List<Reminder> reminders;
}

/// The first day of the week shown in month and week views.
enum WeekStart {
  /// السبت (default).
  saturday(DateTime.saturday),

  /// الأحد.
  sunday(DateTime.sunday),

  /// الإثنين.
  monday(DateTime.monday);

  const WeekStart(this.isoWeekday);

  /// ISO weekday (1 = Monday … 7 = Sunday).
  final int isoWeekday;

  /// The start of the week containing [d].
  CalendarDate weekOf(CalendarDate d) =>
      d.addDays(-((d.weekday - isoWeekday + 7) % 7));

  /// The 42 days (6 × 7) of the month grid that shows [month].
  DateRange monthGrid(CalendarDate month) {
    final start = weekOf(month.firstOfMonth);
    return DateRange(start, start.addDays(41));
  }

  /// The 7 days of the week containing [d].
  DateRange week(CalendarDate d) {
    final start = weekOf(d);
    return DateRange(start, start.addDays(6));
  }

  /// Friday and Saturday (the Egyptian weekend) are tinted.
  static bool isWeekend(CalendarDate d) =>
      d.weekday == DateTime.friday || d.weekday == DateTime.saturday;
}
