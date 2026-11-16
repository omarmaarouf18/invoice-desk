import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/ics.dart';
import 'package:invoice_desk/domain/calendar/models.dart';

void main() {
  const d = CalendarDate(2026, 11, 15);
  final stamp = DateTime.utc(2026, 11, 15, 8, 30);
  final events = [
    const CalendarEvent(
      id: 'invoice-due-abc',
      type: CalendarEventType.due,
      date: d,
      title: 'INV-1',
    ),
    const CalendarEvent(
      id: 'reminder-r1',
      type: CalendarEventType.reminder,
      date: d,
      time: '09:05',
      title:
          'اتصال بالعميل؛ مخبز النيل، بخصوص الفاتورة المتأخرة منذ عشرة أيام كاملة',
    ),
    const CalendarEvent(
      id: 'invoice-paid-abc',
      type: CalendarEventType.paid,
      date: d,
    ),
  ];
  String build() => buildIcs(
    events,
    stamp: stamp,
    summary: (e) => e.title.isEmpty ? 'x' : e.title,
    description: (e) => 'line one\nline, two; \\ three',
  );

  test('structure, CRLF, all-day and timed events, paid left out', () {
    final ics = build();
    expect(ics, startsWith('BEGIN:VCALENDAR\r\nVERSION:2.0\r\n'));
    expect(ics, endsWith('END:VCALENDAR\r\n'));
    expect(ics.replaceAll('\r\n', ''), isNot(contains('\n')));
    expect('BEGIN:VEVENT'.allMatches(ics), hasLength(2));
    expect(ics, contains('DTSTART;VALUE=DATE:20261115\r\n'));
    expect(ics, contains('DTEND;VALUE=DATE:20261116\r\n'));
    expect(ics, contains('DTSTART:20261115T090500\r\n'));
    expect(ics, contains('DTSTAMP:20261115T083000Z\r\n'));
    expect(ics, isNot(contains('invoice-paid')));
  });

  test('TEXT escaping', () {
    expect(
      icsEscape('a,b;c\\d\ne'),
      r'a\,b\;c\\d\ne',
    );
    expect(build(), contains(r'DESCRIPTION:line one\nline\, two\; \\ three'));
  });

  test('lines fold at 75 octets without splitting UTF-8 Arabic', () {
    final ics = build();
    for (final line in ics.split('\r\n')) {
      expect(utf8.encode(line).length, lessThanOrEqualTo(75), reason: line);
    }
    // Unfolding gives the escaped summary back, valid UTF-8 throughout.
    final unfolded = ics.replaceAll('\r\n ', '');
    expect(unfolded, contains('SUMMARY:${icsEscape(events[1].title)}'));
    expect(utf8.decode(utf8.encode(ics)), ics);
  });

  test('UIDs are stable across exports (re-import updates)', () {
    final uids = RegExp('UID:(.*)').allMatches(build()).map((m) => m[1]);
    expect(uids, [
      'invoice-due-abc@$icsUidDomain',
      'reminder-r1@$icsUidDomain',
    ]);
    expect(RegExp('UID:(.*)').allMatches(build()).map((m) => m[1]), uids);
  });
}
