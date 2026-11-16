import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/events.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/summary.dart';
import 'package:invoice_desk/features/calendar/calendar_actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/calendar/event_style.dart';
import 'package:invoice_desk/features/calendar/list_views.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// The events of a day (filters applied), today's overdue rollup expanded
/// into its invoices, each with its actions; "+ تذكير" at the bottom.
List<CalendarEvent> _dayEvents(WidgetRef ref, CalendarDate day) {
  final events = ref.watch(eventsByDayProvider)[day] ?? const [];
  if (!events.any((e) => e.type == CalendarEventType.overdueRollup)) {
    return events;
  }
  // Every overdue invoice, wherever its date is.
  final data = ref.watch(calendarDataProvider);
  if (data == null) return events;
  final today = ref.watch(todayProvider);
  final overdue = calendarEvents(
    DateRange(today.addDays(-3650), today),
    data,
    ref.watch(clockProvider),
  ).where((e) => e.type == CalendarEventType.overdue && e.date != day);
  return [...events, ...overdue];
}

class DayPanel extends ConsumerWidget {
  const DayPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(calendarProvider);
    final day = s.selected;
    final events = _dayEvents(ref, day);
    final l = context.l10n;
    final theme = Theme.of(context);
    final actions = CalendarActions(ref, context);
    final total = dueTotal(events);
    return Material(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              Space.m,
              Space.s,
              Space.xs,
              Space.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${weekdayName(context, day.weekday)} '
                    '${formatArabicDate(day)}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l.cancel,
                  icon: const Icon(Icons.close),
                  onPressed: () => ref
                      .read(calendarProvider.notifier)
                      .openPanel(open: false),
                ),
              ],
            ),
          ),
          if (!total.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.m),
              child: Text(
                '${l.dayTotal}: ${total.format()}',
                style: theme.textTheme.labelMedium,
              ),
            ),
          const Divider(),
          Expanded(
            child: events.isEmpty
                ? Center(child: Text(l.dayEmpty))
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: Space.s),
                    children: [
                      for (final e in events)
                        if (e.type != CalendarEventType.overdueRollup)
                          _PanelEvent(
                            event: e,
                            day: day,
                            selected: e.id == s.selectedEventId,
                          ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(Space.s),
            child: OutlinedButton(
              key: const Key('add-reminder'),
              onPressed: () => unawaited(actions.addReminder(day)),
              child: Text(l.addReminder),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelEvent extends ConsumerWidget {
  const _PanelEvent({
    required this.event,
    required this.day,
    required this.selected,
  });
  final CalendarEvent event;
  final CalendarDate day;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = CalendarActions(ref, context);
    final l = context.l10n;
    final e = event;
    void go(Future<void> Function() f) => unawaited(f());
    final t = e.type;
    final onInvoice = e.milestoneId == null && e.invoiceId != null;
    final buttons = <(String, String, VoidCallback)>[
      if ((t == CalendarEventType.due ||
              t == CalendarEventType.overdue ||
              t == CalendarEventType.postponed) &&
          onInvoice) ...[
        ('actOpen', l.actOpen, () => go(() => a.openInvoice(e.invoiceId!))),
        ('actMarkPaid', l.actMarkPaid, () => go(() => a.markPaid(e, day))),
        ('actPostpone', l.actPostpone, () => go(() => a.postpone(e))),
        (
          'actCopyReminder',
          l.actCopyReminder,
          () => go(() => a.copyReminder(e)),
        ),
      ] else if (e.milestoneId != null) ...[
        (
          'actCreateInvoice',
          l.actCreateInvoice,
          () => go(() => a.invoiceMilestone(e)),
        ),
        ('actPostpone', l.actPostpone, () => go(() => a.postpone(e))),
        (
          'actOpenContract',
          l.actOpenContract,
          () => go(() => a.openContract(e.contractId!)),
        ),
      ] else if (t == CalendarEventType.renewal) ...[
        ('actRenewInvoice', l.actRenewInvoice, () => go(() => a.renew(e))),
        ('actOpen', l.actOpen, () => go(() => a.openInvoice(e.invoiceId!))),
      ] else if (t == CalendarEventType.reminder) ...[
        ('actEdit', l.actEdit, () => go(() => a.editReminder(e))),
        (
          'actDone',
          e.done ? l.actReopen : l.actMarkDone,
          () => go(() => a.toggleDone(e)),
        ),
        ('actDelete', l.actDelete, () => go(() => a.deleteReminder(e))),
      ] else if (e.contractId != null)
        (
          'actOpenContract',
          l.actOpenContract,
          () => go(() => a.openContract(e.contractId!)),
        )
      else if (e.invoiceId != null)
        ('actOpen', l.actOpen, () => go(() => a.openInvoice(e.invoiceId!))),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EventRow(event: e, selected: selected),
          if (e.date != day)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 56),
              child: Text(
                formatArabicDate(e.date),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 48),
            child: Wrap(
              spacing: Space.xs,
              children: [
                for (final (name, label, onTap) in buttons)
                  TextButton(
                    key: ValueKey('${e.id}:$name'),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onPressed: onTap,
                    child: Text(label),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
