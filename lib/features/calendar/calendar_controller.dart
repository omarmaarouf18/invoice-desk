import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/events.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/summary.dart';
import 'package:invoice_desk/features/sidebar/sidebar_providers.dart';

/// Month grid, week columns or the agenda list.
enum CalendarView { month, week, agenda }

/// The calendar screen's state: what is shown and what is selected.
@immutable
class CalendarState {
  const CalendarState({
    required this.view,
    required this.selected,
    this.filter = const CalendarFilter(),
    this.showPast = false,
    this.selectedEventId,
    this.panelOpen = false,
  });

  final CalendarView view;

  /// The selected day; also decides the visible month / week.
  final CalendarDate selected;

  /// Client, type and currency filters (the text comes from the sidebar's
  /// search box).
  final CalendarFilter filter;

  /// Agenda: include days before today.
  final bool showPast;

  /// Highlighted event (opened from an editor's "في التقويم").
  final String? selectedEventId;

  /// The day panel is open.
  final bool panelOpen;

  CalendarState copyWith({
    CalendarView? view,
    CalendarDate? selected,
    CalendarFilter? filter,
    bool? showPast,
    String? Function()? selectedEventId,
    bool? panelOpen,
  }) => CalendarState(
    view: view ?? this.view,
    selected: selected ?? this.selected,
    filter: filter ?? this.filter,
    showPast: showPast ?? this.showPast,
    selectedEventId: selectedEventId != null
        ? selectedEventId()
        : this.selectedEventId,
    panelOpen: panelOpen ?? this.panelOpen,
  );
}

class CalendarController extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    final prefs = ref.read(uiPrefsProvider);
    return CalendarState(
      view: CalendarView.values.firstWhere(
        (v) => v.name == prefs.calendarView,
        orElse: () => CalendarView.month,
      ),
      selected: todayFrom(ref),
    );
  }

  void setView(CalendarView v) {
    state = state.copyWith(view: v);
    ref.read(uiPrefsProvider).calendarView = v.name;
  }

  /// Selects [d]; [open] also opens the day panel.
  void select(CalendarDate d, {bool open = false}) => state = state.copyWith(
    selected: d,
    panelOpen: open || state.panelOpen,
    selectedEventId: () => null,
  );

  void moveDays(int n) => select(state.selected.addDays(n));

  /// PageUp / PageDown, and the header's arrows.
  void page(int dir) => switch (state.view) {
    CalendarView.month => select(state.selected.addMonths(dir)),
    CalendarView.week || CalendarView.agenda => moveDays(7 * dir),
  };

  void goToday() => select(todayFrom(ref));

  void openPanel({bool open = true}) => state = state.copyWith(panelOpen: open);

  void setFilter(CalendarFilter f) => state = state.copyWith(filter: f);

  void toggleSummary(SummaryKind k) => setFilter(
    state.filter.copyWith(
      types: setEquals(state.filter.types, k.types) ? {} : k.types,
    ),
  );

  void setShowPast({required bool show}) =>
      state = state.copyWith(showPast: show);

  /// "في التقويم": the day of [eventId], highlighted, panel open.
  void focusEvent(CalendarDate d, String eventId) => state = state.copyWith(
    selected: d,
    selectedEventId: () => eventId,
    panelOpen: true,
  );
}

final calendarProvider = NotifierProvider<CalendarController, CalendarState>(
  CalendarController.new,
);

/// Week start from the prefs; changed in Settings.
class WeekStartNotifier extends Notifier<WeekStart> {
  @override
  WeekStart build() => WeekStart.values.firstWhere(
    (w) => w.name == ref.read(uiPrefsProvider).weekStart,
    orElse: () => WeekStart.saturday,
  );

  void set(WeekStart w) {
    state = w;
    ref.read(uiPrefsProvider).weekStart = w.name;
  }
}

final weekStartProvider = NotifierProvider<WeekStartNotifier, WeekStart>(
  WeekStartNotifier.new,
);

/// The live inputs of `calendarEvents`; null while loading.
final calendarDataProvider = Provider<CalendarData?>((ref) {
  final inv = ref.watch(invoicesProvider).value;
  final con = ref.watch(contractsProvider).value;
  final cli = ref.watch(clientsProvider).value;
  final pp = ref.watch(postponementsProvider).value;
  final rem = ref.watch(remindersProvider).value;
  if (inv == null || con == null || cli == null || pp == null || rem == null) {
    return null;
  }
  // Archived clients leave the calendar like they leave the sidebar.
  final hidden = {
    for (final c in cli)
      if (c.archived) c.id,
  };
  return CalendarData(
    invoices: [
      for (final i in inv)
        if (!hidden.contains(i.clientId)) i,
    ],
    contracts: [
      for (final c in con)
        if (!hidden.contains(c.clientId)) c,
    ],
    clients: cli,
    postponements: pp,
    reminders: rem,
  );
});

/// The days the current view shows.
final visibleRangeProvider = Provider<DateRange>((ref) {
  final s = ref.watch(calendarProvider);
  final ws = ref.watch(weekStartProvider);
  final today = ref.watch(todayProvider);
  return switch (s.view) {
    CalendarView.month => ws.monthGrid(s.selected),
    CalendarView.week => ws.week(s.selected),
    CalendarView.agenda => DateRange(
      s.showPast ? today.addDays(-90) : today,
      today.addDays(120),
    ),
  };
});

/// Events of the visible range, unfiltered (header summary, banner).
final rangeEventsProvider = Provider<List<CalendarEvent>>((ref) {
  final data = ref.watch(calendarDataProvider);
  if (data == null) return const [];
  return calendarEvents(
    ref.watch(visibleRangeProvider),
    data,
    ref.watch(clockProvider),
  );
});

/// What the grid / list shows: the filter plus the sidebar's search text.
final visibleEventsProvider = Provider<List<CalendarEvent>>((ref) {
  final filter = ref
      .watch(calendarProvider.select((s) => s.filter))
      .copyWith(query: ref.watch(searchQueryProvider));
  final all = ref.watch(rangeEventsProvider);
  return filter.isEmpty ? all : all.where(filter.accepts).toList();
});

/// Visible events by day.
final eventsByDayProvider = Provider<Map<CalendarDate, List<CalendarEvent>>>(
  (ref) => eventsByDay(ref.watch(visibleEventsProvider)),
);

/// The month header figures for the selected month.
final monthSummaryProvider = Provider<Map<SummaryKind, MoneyBag>>(
  (ref) => monthSummary(
    ref.watch(visibleEventsProvider),
    ref.watch(calendarProvider.select((s) => s.selected)),
  ),
);

/// Today's figures for the banner and the start-up notification: due
/// today and overdue, wherever their dates are.
final todayCountsProvider = Provider<({int due, int overdue})?>((ref) {
  final data = ref.watch(calendarDataProvider);
  if (data == null) return null;
  final today = ref.watch(todayProvider);
  final events = calendarEvents(
    DateRange(today, today),
    data,
    ref.watch(clockProvider),
  );
  final rollup = events.where(
    (e) => e.type == CalendarEventType.overdueRollup,
  );
  return (
    due: todayCounts(events, today).due,
    overdue: rollup.isEmpty ? 0 : rollup.first.count,
  );
});
