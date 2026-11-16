import 'package:collection/collection.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:meta/meta.dart';

/// The month header's three figures.
enum SummaryKind {
  /// متوقع تحصيله: due, postponed, milestones and renewals.
  expected({
    CalendarEventType.due,
    CalendarEventType.postponed,
    CalendarEventType.milestone,
    CalendarEventType.renewal,
  }),

  /// تم تحصيله: paid.
  collected({CalendarEventType.paid}),

  /// متأخر: overdue invoices and late milestones.
  overdue({CalendarEventType.overdue, CalendarEventType.overdueRollup});

  const SummaryKind(this.types);

  /// The event types it sums (and filters to when clicked).
  final Set<CalendarEventType> types;

  /// [e] counts towards this figure.
  bool counts(CalendarEvent e) => switch (this) {
    // A late milestone is money owed, not money expected.
    SummaryKind.expected => types.contains(e.type) && !e.isLate,
    SummaryKind.collected => types.contains(e.type),
    SummaryKind.overdue =>
      e.type == CalendarEventType.overdue ||
          (e.type == CalendarEventType.milestone && e.isLate),
  };
}

@immutable
/// What the calendar shows; null / empty means "all".
class CalendarFilter {
  /// No filter.
  const CalendarFilter({
    this.clientId,
    this.types = const {},
    this.currency,
    this.query = '',
  });

  /// Only this client's events.
  final String? clientId;

  /// Only these types; empty = all.
  final Set<CalendarEventType> types;

  /// Only events with an amount in this currency.
  final Currency? currency;

  /// Search text (number, client, title, reason), folded like the sidebar.
  final String query;

  /// Nothing is filtered.
  bool get isEmpty =>
      clientId == null && types.isEmpty && currency == null && query.isEmpty;

  /// [e] passes every set criterion.
  bool accepts(CalendarEvent e) {
    if (clientId != null && e.clientId != clientId) return false;
    if (types.isNotEmpty && !types.contains(e.type)) {
      // The overdue figure also covers late milestones.
      final lateMilestone =
          e.type == CalendarEventType.milestone &&
          e.isLate &&
          types.contains(CalendarEventType.overdue);
      if (!lateMilestone) return false;
    }
    if (currency != null && !e.amounts.any((m) => m.currency == currency)) {
      return false;
    }
    if (query.trim().isNotEmpty) {
      final q = foldForSearch(query.trim());
      final hay = foldForSearch(
        '${e.title} ${e.clientName} ${e.reason} '
        '${e.amounts.map((m) => m.format()).join(' ')}',
      );
      if (!q.split(RegExp(r'\s+')).every(hay.contains)) return false;
    }
    return true;
  }

  /// A copy with the given fields replaced; nullable fields take a
  /// function so they can be cleared.
  CalendarFilter copyWith({
    String? Function()? clientId,
    Set<CalendarEventType>? types,
    Currency? Function()? currency,
    String? query,
  }) => CalendarFilter(
    clientId: clientId != null ? clientId() : this.clientId,
    types: types ?? this.types,
    currency: currency != null ? currency() : this.currency,
    query: query ?? this.query,
  );
}

/// Events grouped by day, in order.
Map<CalendarDate, List<CalendarEvent>> eventsByDay(
  Iterable<CalendarEvent> events,
) => groupBy(events, (e) => e.date);

/// What is due on a day per currency: receivable events (not the rollup,
/// which repeats the overdue ones).
MoneyBag dueTotal(Iterable<CalendarEvent> dayEvents) {
  final bag = MoneyBag();
  for (final e in dayEvents) {
    if (e.type.isReceivable) e.amounts.forEach(bag.add);
  }
  return bag;
}

/// The month header: one per-currency total per [SummaryKind], over the
/// days of [month] only (not the grid's spill-over days).
Map<SummaryKind, MoneyBag> monthSummary(
  Iterable<CalendarEvent> events,
  CalendarDate month,
) {
  final first = month.firstOfMonth;
  final last = CalendarDate(month.year, month.month, month.daysInMonth);
  final out = {for (final k in SummaryKind.values) k: MoneyBag()};
  for (final e in events) {
    if (!e.date.isWithin(first, last)) continue;
    for (final k in SummaryKind.values) {
      if (k.counts(e)) e.amounts.forEach(out[k]!.add);
    }
  }
  return out;
}

/// The "today" banner's counts: invoices due today and overdue ones (late
/// milestones included).
({int due, int overdue}) todayCounts(
  Iterable<CalendarEvent> events,
  CalendarDate today,
) {
  var due = 0;
  var overdue = 0;
  for (final e in events) {
    if (e.type == CalendarEventType.overdue ||
        (e.type == CalendarEventType.milestone && e.isLate)) {
      overdue++;
    } else if (e.date == today && e.type.isReceivable) {
      due++;
    }
  }
  return (due: due, overdue: overdue);
}
