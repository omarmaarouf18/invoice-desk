import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

void main() {
  test("the default pattern is today's numbering", () {
    for (final (y, n) in [(2026, 1), (2026, 42), (2027, 12345)]) {
      expect(
        formatNumberPattern(
          Settings.defaultNumberPattern,
          prefix: 'OM',
          year: y,
          seq: n,
        ),
        formatInvoiceNumber('OM', y, n),
      );
    }
  });

  test('tokens fill in; other text is kept', () {
    String f(String p) =>
        formatNumberPattern(p, prefix: 'AS', year: 2026, seq: 7);
    expect(f('{PREFIX}/{YY}/{SEQ:3}'), 'AS/26/007');
    expect(f('INV-{SEQ}'), 'INV-7');
    expect(f('{YYYY}{SEQ:5}'), '202600007');
  });

  test('a pattern needs a sequence, and a year when it resets yearly', () {
    expect(
      checkNumberPattern('{PREFIX}-{YYYY}', yearlyReset: false),
      NumberPatternProblem.noSequence,
    );
    expect(
      checkNumberPattern('{PREFIX}-{SEQ:4}', yearlyReset: true),
      NumberPatternProblem.noYearWithReset,
    );
    expect(checkNumberPattern('{PREFIX}-{SEQ:4}', yearlyReset: false), null);
    expect(checkNumberPattern('{YY}-{SEQ}', yearlyReset: true), null);
  });

  test('without yearly reset the sequence runs across years', () {
    final used = [(year: 2025, seq: 9), (year: 2026, seq: 2)];
    expect(nextSeq(used, 2026), 3);
    expect(nextSeq(used, 2026, yearlyReset: false), 10);
    expect(nextSeq(used, 2027), 1);
  });

  test('an unusable saved pattern falls back to the default', () {
    const s = Settings(
      invoiceNumberPattern: '{PREFIX}-only',
    );
    expect(invoiceNumberFor(s, 2026, 5), 'OM-2026-0005');
  });
}
