import 'package:flutter/material.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// Colour, icon and text label of an event type. Status colours match the
/// sidebar's chips: amber due, red overdue, green paid, grey draft/done;
/// violet postponed, teal contracts.
@immutable
class EventStyle {
  const EventStyle(this.fg, this.bg, this.icon);
  final Color fg;
  final Color bg;
  final IconData icon;
}

const _violet = (Color(0xFF6D28D9), Color(0xFFEDE9FE));
const _violetDark = (Color(0xFFC4B5FD), Color(0xFF2E1F4F));
const _teal = (Color(0xFF0F766E), Color(0xFFD5F5F1));
const _tealDark = (Color(0xFF5EEAD4), Color(0xFF0D3B37));
const _blue = (Color(0xFF1D4ED8), Color(0xFFDBEAFE));
const _blueDark = (Color(0xFF93C5FD), Color(0xFF172E55));
const _slate = (Color(0xFF334155), Color(0xFFE2E8F0));
const _slateDark = (Color(0xFFCBD5E1), Color(0xFF263244));

EventStyle eventStyle(BuildContext context, CalendarEvent e) {
  final c = context.colors;
  final dark = Theme.of(context).brightness == Brightness.dark;
  EventStyle status(DisplayStatus s, IconData i) =>
      EventStyle(c.statusFg[s]!, c.statusBg[s]!, i);
  EventStyle pair((Color, Color) light, (Color, Color) night, IconData i) {
    final p = dark ? night : light;
    return EventStyle(p.$1, p.$2, i);
  }

  if (e.done) return status(DisplayStatus.draft, Icons.check_circle_outline);
  return switch (e.type) {
    CalendarEventType.due => status(DisplayStatus.sent, Icons.schedule),
    CalendarEventType.overdue || CalendarEventType.overdueRollup => status(
      DisplayStatus.overdue,
      Icons.error_outline,
    ),
    CalendarEventType.paid => status(DisplayStatus.paid, Icons.check_circle),
    CalendarEventType.postponed => pair(
      _violet,
      _violetDark,
      Icons.update,
    ),
    CalendarEventType.milestone when e.isLate => status(
      DisplayStatus.overdue,
      Icons.flag_outlined,
    ),
    CalendarEventType.milestone => pair(_teal, _tealDark, Icons.flag_outlined),
    CalendarEventType.renewal => pair(_blue, _blueDark, Icons.autorenew),
    CalendarEventType.contractStart => pair(
      _teal,
      _tealDark,
      Icons.play_arrow_outlined,
    ),
    CalendarEventType.contractEnd => pair(
      _teal,
      _tealDark,
      Icons.stop_circle_outlined,
    ),
    CalendarEventType.warrantyEnd => pair(
      _teal,
      _tealDark,
      Icons.verified_user_outlined,
    ),
    CalendarEventType.reminder => pair(
      _slate,
      _slateDark,
      Icons.notifications_none,
    ),
  };
}

String eventTypeLabel(BuildContext context, CalendarEventType t) {
  final l = context.l10n;
  return switch (t) {
    CalendarEventType.due => l.evDue,
    CalendarEventType.overdue => l.evOverdue,
    CalendarEventType.overdueRollup => l.evOverdueRollup,
    CalendarEventType.paid => l.evPaid,
    CalendarEventType.postponed => l.evPostponed,
    CalendarEventType.milestone => l.evMilestone,
    CalendarEventType.renewal => l.evRenewal,
    CalendarEventType.contractStart => l.evContractStart,
    CalendarEventType.contractEnd => l.evContractEnd,
    CalendarEventType.warrantyEnd => l.evWarrantyEnd,
    CalendarEventType.reminder => l.evReminder,
  };
}

/// One-line text of an event: `number · client · total`, `service ·
/// amount`, the contract title or the reminder text.
String eventTitle(BuildContext context, CalendarEvent e) {
  final l = context.l10n;
  final amount = e.amounts.map((m) => m.format()).join(' + ');
  final parts = switch (e.type) {
    CalendarEventType.overdueRollup => [l.overdueRollup(e.count), amount],
    CalendarEventType.reminder => [
      if (e.time != null) e.time!,
      e.title,
      e.clientName,
    ],
    CalendarEventType.contractStart ||
    CalendarEventType.contractEnd ||
    CalendarEventType.warrantyEnd => [e.title, e.clientName],
    _ => [e.title, e.clientName, amount],
  };
  return parts.where((p) => p.isNotEmpty).join(' · ');
}

/// The muted second line in the day panel and agenda.
String eventDetail(BuildContext context, CalendarEvent e) {
  final l = context.l10n;
  final bits = <String>[
    eventTypeLabel(context, e.type),
    if (e.daysOverdue > 0) l.daysOverdue(e.daysOverdue),
    if (e.reason.isNotEmpty) e.reason,
  ];
  return bits.join(' · ');
}

/// `14 نوفمبر`, for struck-through original dates.
String shortDate(BuildContext context, CalendarDate d) =>
    formatDocDayMonth(d, context.docLanguage);

/// Weekday name for ISO weekday [w] (1 = Monday).
String weekdayName(BuildContext context, int w) {
  final l = context.l10n;
  return [
    l.wdMon,
    l.wdTue,
    l.wdWed,
    l.wdThu,
    l.wdFri,
    l.wdSat,
    l.wdSun,
  ][w - 1];
}
