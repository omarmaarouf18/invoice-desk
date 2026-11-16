import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/summary.dart';
import 'package:invoice_desk/features/calendar/calendar_actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/calendar/event_chip.dart';
import 'package:invoice_desk/features/calendar/event_style.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// 6 × 7 grid: date, up to three chips, "+N", and what is due that day per
/// currency. Today is outlined, weekends tinted, days of other months
/// dimmed. Chips can be dropped on another day (postpone).
class MonthView extends ConsumerWidget {
  const MonthView({super.key});

  static const maxChips = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(visibleRangeProvider);
    final ws = ref.watch(weekStartProvider);
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Space.xs),
                  child: Text(
                    weekdayName(
                      context,
                      ws.weekOf(range.start).addDays(i).weekday,
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: context.colors.muted,
                    ),
                  ),
                ),
              ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              for (var w = 0; w < 6; w++)
                Expanded(
                  child: Row(
                    children: [
                      for (var d = 0; d < 7; d++)
                        Expanded(
                          child: DayCell(day: range.start.addDays(w * 7 + d)),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One day of the month grid; also a drop target.
class DayCell extends ConsumerWidget {
  const DayCell({required this.day, super.key});
  final CalendarDate day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events =
        ref.watch(eventsByDayProvider.select((m) => m[day])) ?? const [];
    final s = ref.watch(calendarProvider);
    final today = ref.watch(todayProvider);
    final c = context.colors;
    final theme = Theme.of(context);
    final inMonth = day.month == s.selected.month;
    final ctl = ref.read(calendarProvider.notifier);
    final actions = CalendarActions(ref, context);
    return DragTarget<CalendarEvent>(
      onWillAcceptWithDetails: (d) => d.data.date != day,
      onAcceptWithDetails: (d) => unawaited(actions.dropOn(d.data, day)),
      builder: (context, candidates, _) => InkWell(
        key: ValueKey('day-${day.toIso()}'),
        onTap: () => ctl.select(day, open: true),
        child: Container(
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.all(Space.xs),
          decoration: BoxDecoration(
            color: candidates.isNotEmpty
                ? theme.colorScheme.primaryContainer
                : WeekStart.isWeekend(day)
                ? c.subtle
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(Space.radiusSmall / 2),
            border: Border.all(
              color: day == today
                  ? theme.colorScheme.primary
                  : day == s.selected
                  ? theme.colorScheme.outline
                  : c.border,
              width: day == today || day == s.selected ? 2 : 1,
            ),
          ),
          child: Opacity(
            opacity: inMonth ? 1 : 0.45,
            child: _CellBody(day: day, events: events, selected: s),
          ),
        ),
      ),
    );
  }
}

class _CellBody extends ConsumerWidget {
  const _CellBody({
    required this.day,
    required this.events,
    required this.selected,
  });
  final CalendarDate day;
  final List<CalendarEvent> events;
  final CalendarState selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final total = dueTotal(events);
    final shown = events.take(MonthView.maxChips).toList();
    final more = events.length - shown.length;
    final ctl = ref.read(calendarProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              '${day.day}',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (!total.isEmpty)
              Flexible(
                child: Text(
                  total.format(separator: ' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.colors.muted,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 2),
        for (final e in shown)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: EventChip(
              e,
              selected: e.id == selected.selectedEventId,
              onTap: () => ctl.select(day, open: true),
            ),
          ),
        if (more > 0)
          Text(
            context.l10n.moreEvents(more),
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.colors.muted,
            ),
          ),
      ],
    );
  }
}
