import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/style_contrast.dart';

void main() {
  test('contrast ratio matches the WCAG reference values', () {
    expect(contrastRatio(0xFF000000, 0xFFFFFFFF), closeTo(21, 0.01));
    expect(contrastRatio(0xFFFFFFFF, 0xFFFFFFFF), 1);
    // #767676 on white is the well-known 4.54:1 grey.
    expect(contrastRatio(0xFF767676, 0xFFFFFFFF), closeTo(4.54, 0.01));
    // Order does not matter; alpha is ignored.
    expect(
      contrastRatio(0x00767676, 0xFFFFFFFF),
      contrastRatio(0xFFFFFFFF, 0xFF767676),
    );
  });

  test('every shipped preset passes, except the known Modern header', () {
    for (final p in DocPreset.values) {
      final pairs = contrastIssues(p.style).map((i) => i.pair);
      // Modern's muted grey on its pale-blue table header is 4.37:1. A
      // preset change alters existing drafts, so it waits for the owner
      // (docs/worklog/STY-02.md, open question 3).
      final known = p == DocPreset.modern
          ? [ContrastPair.mutedOnTableHeader]
          : <ContrastPair>[];
      expect(pairs, known, reason: p.id);
    }
  });

  test('faint muted text is reported with its ratio', () {
    const s = DocumentStyle(muted: 0xFFCCCCCC);
    final issues = contrastIssues(s);
    expect(issues.map((i) => i.pair), contains(ContrastPair.mutedOnPage));
    expect(issues.every((i) => i.ratio < minTextContrast), isTrue);
  });

  test('a band pair is only checked when the totals draw that band', () {
    const pale = 0xFFB0D0FF;
    expect(
      contrastIssues(
        const DocumentStyle(primary: pale, totalsStyle: TotalsStyle.solid),
      ).map((i) => i.pair),
      contains(ContrastPair.whiteOnPrimary),
    );
    expect(
      contrastIssues(
        const DocumentStyle(
          ink: pale,
          totalsStyle: TotalsStyle.plain,
        ),
      ).map((i) => i.pair),
      isNot(contains(ContrastPair.whiteOnInk)),
    );
  });
}
