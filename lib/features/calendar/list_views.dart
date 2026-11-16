import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/summary.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/features/calendar/calendar_actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/calendar/event_chip.dart';
import 'package:invoice_desk/features/calendar/event_style.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// Seven columns with every event of the day (timed reminders show their
/// time first); columns are drop targets.
class WeekView extends ConsumerWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(visibleRangeProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(child: _WeekColumn(day: range.start.addDays(i))),
      ],
    );
  }
}

class _WeekColumn extends ConsumerWidget {
  const _WeekColumn({required this.day});
  final CalendarDate day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsByDayProvider)[day] ?? const [];
    final today = ref.watch(todayProvider);
    final selected = ref.watch(calendarProvider);
    final theme = Theme.of(context);
    final ctl = ref.read(calendarProvider.notifier);
    final actions = CalendarActions(ref, context);
    return DragTarget<CalendarEvent>(
      onWillAcceptWithDetails: (d) => d.data.date != day,
      onAcceptWithDetails: (d) => unawaited(actions.dropOn(d.data, day)),
      builder: (context, candidates, _) => InkWell(
        key: ValueKey('week-${day.toIso()}'),
        onTap: () => ctl.select(day, open: true),
        child: Container(
          margin: const EdgeInsets.all(1),
          padding: const EdgeInsets.all(Space.xs),
          decoration: BoxDecoration(
            color: candidates.isNotEmpty
                ? theme.colorScheme.primaryContainer
                : WeekStart.isWeekend(day)
                ? context.colors.subtle
                : theme.colorScheme.surface,
            border: Border.all(
              color: day == today
                  ? theme.colorScheme.primary
                  : context.colors.border,
              width: day == today ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(Space.radiusSmall / 2),
          ),
          child: ListView(
            children: [
              Text(
                '${weekdayName(context, day.weekday)} ${day.day}',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: Space.xs),
              for (final e in events)
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: EventChip(
                    e,
                    selected: e.id == selected.selectedEventId,
                    onTap: () => ctl.select(day, open: true),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Days from today forward (optionally the past too), grouped: the view
/// for "what do I need to collect".
class AgendaView extends ConsumerWidget {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final byDay = ref.watch(eventsByDayProvider);
    final days = byDay.keys.toList()..sort();
    final l = context.l10n;
    if (days.isEmpty) {
      return Center(
        child: Text(
          l.agendaEmpty,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: Space.s),
      itemCount: days.length,
      itemBuilder: (context, i) =>
          _AgendaDay(day: days[i], events: byDay[days[i]]!),
    );
  }
}

class _AgendaDay extends ConsumerWidget {
  const _AgendaDay({required this.day, required this.events});
  final CalendarDate day;
  final List<CalendarEvent> events;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final today = ref.watch(todayProvider);
    final total = dueTotal(events);
    final ctl = ref.read(calendarProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '${weekdayName(context, day.weekday)} '
                '${formatDocDate(day, context.docLanguage)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: day == today ? theme.colorScheme.primary : null,
                ),
              ),
              const Spacer(),
              if (!total.isEmpty)
                Text(
                  total.format(),
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.labelMedium,
                ),
            ],
          ),
          const Divider(height: Space.s),
          for (final e in events)
            EventRow(event: e, onTap: () => ctl.select(day, open: true)),
        ],
      ),
    );
  }
}

/// Icon, title, detail line and (for postponements) the struck-through
/// original date. Used by the agenda and the day panel.
class EventRow extends StatelessWidget {
  const EventRow({
    required this.event,
    super.key,
    this.onTap,
    this.selected = false,
    this.trailing,
  });
  final CalendarEvent event;
  final VoidCallback? onTap;
  final bool selected;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final s = eventStyle(context, event);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: context.colors.muted,
    );
    final original = event.originalDate;
    return Material(
      color: selected ? s.bg : Colors.transparent,
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      child: ListTile(
        dense: true,
        onTap: onTap,
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: s.bg,
          child: Icon(s.icon, size: 16, color: s.fg),
        ),
        title: Text(
          eventTitle(context, event),
          style: event.done
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text.rich(
          TextSpan(
            style: muted,
            children: [
              TextSpan(text: eventDetail(context, event)),
              if (original != null) ...[
                const TextSpan(text: ' · '),
                TextSpan(
                  text: shortDate(context, original),
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                TextSpan(
                  text: ' ← ${shortDate(context, event.date)}',
                ),
              ],
            ],
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
