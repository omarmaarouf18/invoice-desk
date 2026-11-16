import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/summary.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/calendar/calendar_actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/calendar/event_style.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// Navigation, title, view switch and export.
class CalendarToolbar extends ConsumerWidget {
  const CalendarToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final s = ref.watch(calendarProvider);
    final range = ref.watch(visibleRangeProvider);
    final ctl = ref.read(calendarProvider.notifier);
    final title = switch (s.view) {
      CalendarView.month => formatArabicMonthYear(s.selected),
      CalendarView.week =>
        '${formatArabicDayMonth(range.start)} – ${formatArabicDate(range.end)}',
      CalendarView.agenda => l.viewAgenda,
    };
    return Row(
      children: [
        IconButton(
          tooltip: l.previous,
          icon: const Icon(Icons.chevron_right),
          onPressed: () => ctl.page(-1),
        ),
        IconButton(
          tooltip: l.next,
          icon: const Icon(Icons.chevron_left),
          onPressed: () => ctl.page(1),
        ),
        TextButton(onPressed: ctl.goToday, child: Text('${l.today} (T)')),
        const SizedBox(width: Space.s),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (s.view == CalendarView.agenda)
          FilterChip(
            label: Text(l.showPast),
            selected: s.showPast,
            onSelected: (v) => ctl.setShowPast(show: v),
          ),
        const SizedBox(width: Space.s),
        SegmentedButton<CalendarView>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(value: CalendarView.month, label: Text(l.viewMonth)),
            ButtonSegment(value: CalendarView.week, label: Text(l.viewWeek)),
            ButtonSegment(
              value: CalendarView.agenda,
              label: Text(l.viewAgenda),
            ),
          ],
          selected: {s.view},
          onSelectionChanged: (v) => ctl.setView(v.first),
        ),
        const SizedBox(width: Space.s),
        _ExportMenu(),
      ],
    );
  }
}

class _ExportMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final a = CalendarActions(ref, context);
    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          onPressed: () => unawaited(a.exportIcs(future: false)),
          child: Text(l.exportIcsVisible),
        ),
        MenuItemButton(
          onPressed: () => unawaited(a.exportIcs(future: true)),
          child: Text(l.exportIcsFuture),
        ),
      ],
      builder: (context, c, _) => OutlinedButton.icon(
        onPressed: () => c.isOpen ? c.close() : c.open(),
        icon: const Icon(Icons.ios_share, size: 18),
        label: Text(l.exportIcs),
      ),
    );
  }
}

/// متوقع تحصيله / تم تحصيله / متأخر for the visible month, per currency;
/// clicking one filters the view to it.
class SummaryStrip extends ConsumerWidget {
  const SummaryStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sum = ref.watch(monthSummaryProvider);
    final types = ref.watch(calendarProvider.select((s) => s.filter.types));
    final c = context.colors;
    String label(SummaryKind k) => switch (k) {
      SummaryKind.expected => l.summaryExpected,
      SummaryKind.collected => l.summaryCollected,
      SummaryKind.overdue => l.summaryLate,
    };
    Color color(SummaryKind k) => switch (k) {
      SummaryKind.expected => c.statusFg[DisplayStatus.sent]!,
      SummaryKind.collected => c.statusFg[DisplayStatus.paid]!,
      SummaryKind.overdue => c.statusFg[DisplayStatus.overdue]!,
    };
    return Row(
      children: [
        for (final k in SummaryKind.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Space.s),
              child: _SummaryTile(
                key: ValueKey('summary-${k.name}'),
                label: label(k),
                value: sum[k]!.format(empty: '—'),
                color: color(k),
                selected: types.isNotEmpty && types.containsAll(k.types),
                onTap: () =>
                    ref.read(calendarProvider.notifier).toggleSummary(k),
              ),
            ),
          ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
    required this.selected,
    required this.onTap,
    super.key,
  });
  final String label;
  final String value;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: context.colors.subtle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Space.radiusSmall),
        side: BorderSide(
          color: selected ? color : context.colors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Space.radiusSmall),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Space.m - 4,
            vertical: Space.s,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Client, event type and currency filters.
class FilterRow extends ConsumerWidget {
  const FilterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final f = ref.watch(calendarProvider.select((s) => s.filter));
    final clients = ref.watch(clientsProvider).value ?? const [];
    final ctl = ref.read(calendarProvider.notifier);
    final types = CalendarEventType.values
        .where((t) => t != CalendarEventType.overdueRollup)
        .toList();
    Widget box<T>(
      String hint,
      T? value,
      List<(T?, String)> items,
      void Function(T?) onChanged,
    ) => DropdownButton<T?>(
      value: value,
      hint: Text(hint),
      underline: const SizedBox.shrink(),
      items: [
        for (final (v, label) in items)
          DropdownMenuItem(value: v, child: Text(label)),
      ],
      onChanged: onChanged,
    );
    return Wrap(
      spacing: Space.m,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        box<String>(
          l.filterClient,
          f.clientId,
          [
            (null, l.allClients),
            for (final c in clients) (c.id, c.name),
          ],
          (v) => ctl.setFilter(f.copyWith(clientId: () => v)),
        ),
        box<CalendarEventType>(
          l.filterType,
          f.types.length == 1 ? f.types.first : null,
          [
            (null, l.allTypes),
            for (final t in types) (t, eventTypeLabel(context, t)),
          ],
          (v) => ctl.setFilter(f.copyWith(types: v == null ? {} : {v})),
        ),
        box<Currency>(
          l.filterCurrency,
          f.currency,
          [
            (null, l.allCurrencies),
            for (final c in Currency.values) (c, c.code),
          ],
          (v) => ctl.setFilter(f.copyWith(currency: () => v)),
        ),
        if (!f.isEmpty)
          TextButton(
            onPressed: () => ctl.setFilter(const CalendarFilter()),
            child: Text(l.clearFilters),
          ),
      ],
    );
  }
}
