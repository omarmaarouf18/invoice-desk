import 'dart:convert';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/models.dart';

/// Domain of every exported UID; with the event's stable id it makes
/// re-imports update events instead of duplicating them.
const icsUidDomain = 'invoice-desk.local';

/// Event types exported to .ics: due dates (also overdue / postponed),
/// milestones, renewals, contract dates and reminders.
const Set<CalendarEventType> exportedTypes = {
  CalendarEventType.due,
  CalendarEventType.overdue,
  CalendarEventType.postponed,
  CalendarEventType.milestone,
  CalendarEventType.renewal,
  CalendarEventType.contractStart,
  CalendarEventType.contractEnd,
  CalendarEventType.warrantyEnd,
  CalendarEventType.reminder,
};

/// An RFC 5545 calendar of [events] (those of [exportedTypes]). Lines end
/// in CRLF and are folded at 75 octets without splitting a UTF-8
/// character. [summary] and [description] give each event's text;
/// [stamp] is DTSTAMP (UTC).
String buildIcs(
  Iterable<CalendarEvent> events, {
  required DateTime stamp,
  required String Function(CalendarEvent) summary,
  String Function(CalendarEvent)? description,
  String calendarName = 'Invoice Desk',
}) {
  final lines = <String>[
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//Invoice Desk//Calendar//AR',
    'CALSCALE:GREGORIAN',
    'METHOD:PUBLISH',
    'X-WR-CALNAME:${icsEscape(calendarName)}',
  ];
  final dtstamp = _utc(stamp.toUtc());
  for (final e in events) {
    if (!exportedTypes.contains(e.type)) continue;
    lines
      ..add('BEGIN:VEVENT')
      ..add('UID:${e.id}@$icsUidDomain')
      ..add('DTSTAMP:$dtstamp');
    final time = _parseTime(e.time);
    if (time == null) {
      lines
        ..add('DTSTART;VALUE=DATE:${_date(e.date)}')
        ..add('DTEND;VALUE=DATE:${_date(e.date.addDays(1))}');
    } else {
      lines
        ..add('DTSTART:${_date(e.date)}T${time}00')
        ..add('DURATION:PT30M');
    }
    lines.add('SUMMARY:${icsEscape(summary(e))}');
    final desc = description?.call(e) ?? '';
    if (desc.isNotEmpty) lines.add('DESCRIPTION:${icsEscape(desc)}');
    if (e.done) lines.add('STATUS:CANCELLED');
    lines
      ..add('TRANSP:TRANSPARENT')
      ..add('END:VEVENT');
  }
  lines.add('END:VCALENDAR');
  return '${lines.map(foldIcsLine).join('\r\n')}\r\n';
}

/// TEXT escaping (RFC 5545 §3.3.11): backslash, semicolon, comma and
/// newlines.
String icsEscape(String s) => s
    .replaceAll(r'\', r'\\')
    .replaceAll(';', r'\;')
    .replaceAll(',', r'\,')
    .replaceAll('\r\n', r'\n')
    .replaceAll('\n', r'\n');

/// Folds [line] into chunks of at most 75 octets (UTF-8), continuation
/// chunks prefixed with a space (RFC 5545 §3.1).
String foldIcsLine(String line) {
  if (utf8.encode(line).length <= 75) return line;
  final out = StringBuffer();
  var octets = 0;
  var limit = 75;
  for (final rune in line.runes) {
    final ch = String.fromCharCode(rune);
    final n = utf8.encode(ch).length;
    if (octets + n > limit) {
      out.write('\r\n ');
      octets = 0;
      limit = 74; // the leading space counts
    }
    out.write(ch);
    octets += n;
  }
  return out.toString();
}

String _date(CalendarDate d) => d.toIso().replaceAll('-', '');

String _utc(DateTime t) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${t.year.toString().padLeft(4, '0')}${two(t.month)}${two(t.day)}'
      'T${two(t.hour)}${two(t.minute)}${two(t.second)}Z';
}

/// `HH:MM` → `HHMM`; null when absent or malformed.
String? _parseTime(String? t) {
  final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(t ?? '');
  if (m == null) return null;
  final h = int.parse(m.group(1)!);
  final min = int.parse(m.group(2)!);
  if (h > 23 || min > 59) return null;
  return '${h.toString().padLeft(2, '0')}${m.group(2)}';
}
