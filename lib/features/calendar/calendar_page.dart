import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/calendar/calendar_header.dart';
import 'package:invoice_desk/features/calendar/day_panel.dart';
import 'package:invoice_desk/features/calendar/list_views.dart';
import 'package:invoice_desk/features/calendar/month_view.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// "التقويم": a derived view of due dates, payments, milestones, renewals,
/// contract dates and reminders, with the day panel beside it.
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  static const panelWidth = 360.0;

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  final _focus = FocusNode(debugLabel: 'calendar');

  @override
  void initState() {
    super.initState();
    // Take the keyboard when the calendar appears (the shell holds focus,
    // so autofocus alone would not).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  /// Arrows move the day (RTL: left is the next day), PageUp/PageDown the
  /// month, T today, M/W/A the view, Enter opens the day panel, Esc closes
  /// it.
  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isAltPressed) {
      return KeyEventResult.ignored;
    }
    final ctl = ref.read(calendarProvider.notifier);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final k = e.logicalKey;
    void Function()? act;
    if (k == LogicalKeyboardKey.arrowLeft) {
      act = () => ctl.moveDays(rtl ? 1 : -1);
    } else if (k == LogicalKeyboardKey.arrowRight) {
      act = () => ctl.moveDays(rtl ? -1 : 1);
    } else if (k == LogicalKeyboardKey.arrowUp) {
      act = () => ctl.moveDays(-7);
    } else if (k == LogicalKeyboardKey.arrowDown) {
      act = () => ctl.moveDays(7);
    } else if (k == LogicalKeyboardKey.pageUp) {
      act = () => ctl.page(-1);
    } else if (k == LogicalKeyboardKey.pageDown) {
      act = () => ctl.page(1);
    } else if (k == LogicalKeyboardKey.keyT) {
      act = ctl.goToday;
    } else if (k == LogicalKeyboardKey.keyM) {
      act = () => ctl.setView(CalendarView.month);
    } else if (k == LogicalKeyboardKey.keyW) {
      act = () => ctl.setView(CalendarView.week);
    } else if (k == LogicalKeyboardKey.keyA) {
      act = () => ctl.setView(CalendarView.agenda);
    } else if (k == LogicalKeyboardKey.enter ||
        k == LogicalKeyboardKey.numpadEnter) {
      act = ctl.openPanel;
    } else if (k == LogicalKeyboardKey.escape &&
        ref.read(calendarProvider).panelOpen) {
      act = () => ctl.openPanel(open: false);
    }
    if (act == null) return KeyEventResult.ignored;
    act();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(calendarProvider);
    final body = switch (s.view) {
      CalendarView.month => const MonthView(),
      CalendarView.week => const WeekView(),
      CalendarView.agenda => const AgendaView(),
    };
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => _focus.requestFocus(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.m,
                  Space.s,
                  Space.m,
                  Space.s,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CalendarToolbar(),
                    const SizedBox(height: Space.s),
                    const SummaryStrip(),
                    const SizedBox(height: Space.xs),
                    const FilterRow(),
                    Expanded(child: body),
                    Text(
                      context.l10n.calendarShortcuts,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.colors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (s.panelOpen) ...[
              const VerticalDivider(width: 1),
              const SizedBox(
                width: CalendarPage.panelWidth,
                child: DayPanel(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
