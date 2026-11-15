import 'package:intl/intl.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:meta/meta.dart';

/// Supported invoice currencies. All use two minor digits.
enum Currency {
  /// Egyptian pound; printed as `22,000 EGP`.
  egp('EGP', symbol: null),

  /// US dollar; printed as `$255.50`.
  usd('USD', symbol: r'$'),

  /// Saudi riyal; printed with its code.
  sar('SAR', symbol: null),

  /// UAE dirham; printed with its code.
  aed('AED', symbol: null),

  /// Euro; printed as `€90.00`.
  eur('EUR', symbol: '€');

  const Currency(this.code, {required this.symbol});

  /// ISO 4217 code, also the stored value.
  final String code;

  /// Prefix symbol; when null the ISO code is used as a suffix.
  final String? symbol;

  /// Digits after the decimal point; every supported currency has two.
  static const int minorDigits = 2;

  /// Minor units per major unit (piastres per pound, cents per dollar).
  static const int minorFactor = 100;

  /// The currency for a stored ISO [code]; throws on an unknown code
  /// (the schema's CHECK constraint makes that a corrupt database).
  static Currency fromCode(String code) =>
      Currency.values.firstWhere((c) => c.code == code);
}

@immutable
/// An amount in integer minor units (piastres / cents). Never a double.
class Money implements Comparable<Money> {
  /// [minor] is in hundredths of the [currency]; it may be negative.
  const Money(this.minor, this.currency);

  /// Nothing, in [currency].
  const Money.zero(this.currency) : minor = 0;

  /// Hundredths of the currency (2500 = 25.00). Integer, so sums are exact.
  final int minor;

  /// What [minor] counts.
  final Currency currency;

  /// True for exactly 0; negative amounts are not zero.
  bool get isZero => minor == 0;

  /// Sum of two amounts in the same currency (asserted in debug builds).
  Money operator +(Money other) {
    assert(other.currency == currency, 'currency mismatch');
    return Money(minor + other.minor, currency);
  }

  /// This amount [qty] times, e.g. a line total from its unit price.
  Money times(int qty) => Money(minor * qty, currency);

  /// VAT on this amount at [rateBp] basis points (1400 = 14%), rounded half-up.
  Money vat(int rateBp) => Money(applyBasisPoints(minor, rateBp), currency);

  @override
  int compareTo(Money other) => minor.compareTo(other.minor);

  @override
  bool operator ==(Object other) =>
      other is Money && other.minor == minor && other.currency == currency;

  @override
  int get hashCode => Object.hash(minor, currency);

  /// `22,000 EGP`, `$255.50`.
  String format() => formatMoney(minor, currency);

  @override
  String toString() => format();
}

/// Half-up rounding of `minor × bp / 10000` in pure integer math.
int applyBasisPoints(int minor, int bp) {
  final product = minor * bp;
  final sign = product < 0 ? -1 : 1;
  return sign * ((product.abs() + 5000) ~/ 10000);
}

final NumberFormat _grouped = NumberFormat('#,##0', 'en_US');
final NumberFormat _grouped2 = NumberFormat('#,##0.00', 'en_US');

/// Formats just the number: `22,000`, `255.50`. Decimals are shown when the
/// currency has a symbol (USD/EUR) or the amount has a fractional part.
String formatAmount(
  int minor,
  Currency currency, {
  bool forceDecimals = false,
}) {
  final hasFraction = minor % Currency.minorFactor != 0;
  final decimals = forceDecimals || hasFraction || currency.symbol != null;
  final value = minor / Currency.minorFactor;
  return decimals
      ? _grouped2.format(value)
      : _grouped.format(minor ~/ Currency.minorFactor);
}

/// [minor] with grouping and the currency: `22,000 EGP`, `-$5.00`.
String formatMoney(int minor, Currency currency) {
  final n = formatAmount(minor.abs(), currency);
  final sign = minor < 0 ? '-' : '';
  final symbol = currency.symbol;
  return symbol != null ? '$sign$symbol$n' : '$sign$n ${currency.code}';
}

/// Per-currency totals, kept apart. Order follows first appearance.
class MoneyBag {
  /// Starts from [amounts] (minor units per currency), copied.
  MoneyBag([Map<Currency, int>? amounts]) : _amounts = {...?amounts};

  final Map<Currency, int> _amounts;

  /// Adds [m] to its currency's running total.
  void add(Money m) =>
      _amounts[m.currency] = (_amounts[m.currency] ?? 0) + m.minor;

  /// Adds every currency of [other].
  void addBag(MoneyBag other) => other.entries.forEach(add);

  /// One [Money] per currency seen, zero totals included, in first-seen
  /// order.
  List<Money> get entries => [
    for (final e in _amounts.entries) Money(e.value, e.key),
  ];

  /// Non-zero entries only.
  List<Money> get nonZero => entries.where((m) => !m.isZero).toList();

  /// Total in [c], in minor units; 0 when never added.
  int of(Currency c) => _amounts[c] ?? 0;

  /// No currency has a non-zero total.
  bool get isEmpty => nonZero.isEmpty;

  /// `22,000 EGP + $255.50`; never sums across currencies.
  String format({String separator = ' + ', String empty = '0'}) {
    final list = nonZero;
    if (list.isEmpty) return empty;
    return list.map((m) => m.format()).join(separator);
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, value comparison for tests
  bool operator ==(Object other) =>
      other is MoneyBag && Currency.values.every((c) => other.of(c) == of(c));

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, see ==
  int get hashCode => Object.hashAll(Currency.values.map(of));

  @override
  String toString() => format();
}

/// Parses user money input into minor units. Accepts Arabic-Indic digits,
/// thousands separators and either `.` or `٫` as the decimal point.
/// Returns null when the text is not a valid non-negative amount.
int? parseMoneyInput(String input) {
  var s = normalizeDigits(input).trim();
  s = s.replaceAll(RegExp(r'[,\s٬]'), '').replaceAll('٫', '.');
  if (s.isEmpty) return 0;
  final match = RegExp(r'^(\d+)(?:\.(\d{0,2}))?$').firstMatch(s);
  if (match == null) return null;
  final whole = int.parse(match.group(1)!);
  final frac = (match.group(2) ?? '').padRight(2, '0');
  return whole * Currency.minorFactor + int.parse(frac);
}

/// Parses an integer quantity (non-negative). Null when invalid.
int? parseIntInput(String input) {
  final s = normalizeDigits(input).trim().replaceAll(RegExp(r'[,\s٬]'), '');
  if (s.isEmpty) return 0;
  if (!RegExp(r'^\d+$').hasMatch(s)) return null;
  return int.parse(s);
}

/// Parses a percentage like `14` or `14.5` into basis points.
int? parsePercentToBp(String input) {
  final minor = parseMoneyInput(input);
  return minor; // same shape: 2 decimals → ×100
}

/// Basis points as a percent string: 1400 → `14`, 1250 → `12.5`.
String formatBpAsPercent(int bp) {
  if (bp % 100 == 0) return '${bp ~/ 100}';
  return (bp / 100).toStringAsFixed(2).replaceFirst(RegExp(r'0$'), '');
}
