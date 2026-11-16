import 'package:invoice_desk/core/digits.dart';
import 'package:meta/meta.dart';

@immutable
/// A local calendar day with no time or zone. Stored as `YYYY-MM-DD`.
class CalendarDate implements Comparable<CalendarDate> {
  /// Creates a date; [month] is 1–12. Not validated: use [tryParse] for input.
  const CalendarDate(this.year, this.month, this.day);

  /// The local calendar day of [dt]; the time and zone are dropped.
  factory CalendarDate.fromDateTime(DateTime dt) =>
      CalendarDate(dt.year, dt.month, dt.day);

  /// Parses `YYYY-MM-DD` (Arabic-Indic digits allowed). Throws on bad input.
  factory CalendarDate.parse(String iso) {
    final d = tryParse(iso);
    if (d == null) throw FormatException('Bad date', iso);
    return d;
  }

  /// Parses `YYYY-MM-DD` (Arabic-Indic digits allowed); null for anything
  /// else, including impossible days such as `2026-02-30`.
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

  /// Four-digit year.
  final int year;

  /// 1 = January.
  final int month;

  /// Day of the month, from 1.
  final int day;

  /// Local midnight of this day, for date pickers.
  DateTime toDateTime() => DateTime(year, month, day);

  /// This day moved by [days] (negative goes back); month and year roll
  /// over, computed in UTC so daylight saving never shifts it.
  CalendarDate addDays(int days) =>
      CalendarDate.fromDateTime(DateTime.utc(year, month, day + days));

  /// Whole days from this day to [other]; negative when [other] is earlier.
  int daysUntil(CalendarDate other) => DateTime.utc(
    other.year,
    other.month,
    other.day,
  ).difference(DateTime.utc(year, month, day)).inDays;

  /// This day moved by [months]; the day is clamped to the target month's
  /// length (31 Jan + 1 month = 28 or 29 Feb).
  CalendarDate addMonths(int months) {
    final index = year * 12 + (month - 1) + months;
    final y = index ~/ 12;
    final m = index % 12 + 1;
    final last = DateTime.utc(y, m + 1, 0).day;
    return CalendarDate(y, m, day > last ? last : day);
  }

  /// ISO weekday: 1 = Monday … 7 = Sunday.
  int get weekday => DateTime.utc(year, month, day).weekday;

  /// The first day of this month.
  CalendarDate get firstOfMonth => CalendarDate(year, month, 1);

  /// Days in this month.
  int get daysInMonth => DateTime.utc(year, month + 1, 0).day;

  /// Not before [start] and not after [end].
  bool isWithin(CalendarDate start, CalendarDate end) =>
      compareTo(start) >= 0 && compareTo(end) <= 0;

  /// `YYYY-MM-DD`, the storage format (sorts as text).
  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  /// Strictly earlier than [other]; the same day is not before.
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
