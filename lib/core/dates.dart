import 'package:flutter/foundation.dart';
import 'package:invoice_desk/core/digits.dart';

@immutable
/// A local calendar day with no time or zone. Stored as `YYYY-MM-DD`.
class CalendarDate implements Comparable<CalendarDate> {
  const CalendarDate(this.year, this.month, this.day);

  factory CalendarDate.fromDateTime(DateTime dt) =>
      CalendarDate(dt.year, dt.month, dt.day);

  /// Parses `YYYY-MM-DD` (Arabic-Indic digits allowed). Throws on bad input.
  factory CalendarDate.parse(String iso) {
    final d = tryParse(iso);
    if (d == null) throw FormatException('Bad date', iso);
    return d;
  }

  static CalendarDate? tryParse(String? iso) {
    if (iso == null) return null;
    final m = RegExp(
      r'^(\d{4})-(\d{1,2})-(\d{1,2})$',
    ).firstMatch(normalizeDigits(iso.trim()));
    if (m == null) return null;
    final y = int.parse(m.group(1)!);
    final mo = int.parse(m.group(2)!);
    final d = int.parse(m.group(3)!);
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
    final dt = DateTime.utc(y, mo, d);
    if (dt.month != mo) return null;
    return CalendarDate(y, mo, d);
  }

  final int year;
  final int month;
  final int day;

  DateTime toDateTime() => DateTime(year, month, day);

  CalendarDate addDays(int days) =>
      CalendarDate.fromDateTime(DateTime.utc(year, month, day + days));

  int daysUntil(CalendarDate other) => DateTime.utc(
    other.year,
    other.month,
    other.day,
  ).difference(DateTime.utc(year, month, day)).inDays;

  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  bool isBefore(CalendarDate other) => compareTo(other) < 0;

  @override
  int compareTo(CalendarDate other) => year != other.year
      ? year.compareTo(other.year)
      : month != other.month
      ? month.compareTo(other.month)
      : day.compareTo(other.day);

  @override
  bool operator ==(Object other) =>
      other is CalendarDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}

const _arabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];

const _englishMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// `14 سبتمبر 2026` — Western digits, Arabic month name.
String formatArabicDate(CalendarDate d) =>
    '${d.day} ${_arabicMonths[d.month - 1]} ${d.year}';

/// `14 سبتمبر` — used in dense lists.
String formatArabicDayMonth(CalendarDate d) =>
    '${d.day} ${_arabicMonths[d.month - 1]}';

/// `14 Sep 2026` — used on the invoice.
String formatInvoiceDate(CalendarDate d) =>
    '${d.day} ${_englishMonths[d.month - 1]} ${d.year}';
