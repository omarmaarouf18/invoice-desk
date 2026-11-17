import 'dart:math' as math;

import 'package:invoice_desk/domain/document_style.dart';
import 'package:meta/meta.dart';

/// The minimum contrast ratio for body text (WCAG 2.x, level AA). Document
/// labels are 7.5–9.5 pt, so the large-text 3:1 allowance never applies.
const minTextContrast = 4.5;

/// The WCAG contrast ratio of two opaque ARGB colours, from 1 (identical)
/// to 21 (black on white). Alpha is ignored: the PDF engine draws every
/// colour opaque.
double contrastRatio(int a, int b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final hi = math.max(la, lb);
  final lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

double _luminance(int argb) {
  double channel(int shift) {
    final c = ((argb >> shift) & 0xFF) / 255;
    return c <= 0.03928
        ? c / 12.92
        : math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel(16) + 0.7152 * channel(8) + 0.0722 * channel(0);
}

/// A text colour and the background it is printed on.
enum ContrastPair {
  /// Body text on the white page.
  inkOnPage,

  /// Secondary text (dates, contacts) on the white page.
  mutedOnPage,

  /// Headings and the role line on the white page.
  primaryOnPage,

  /// Text inside the header band and cards.
  inkOnSurface,

  /// Secondary text inside the header band and cards.
  mutedOnSurface,

  /// Table header labels.
  mutedOnTableHeader,

  /// White "total due" text on the ink band (outlined totals).
  whiteOnInk,

  /// White "total due" text on the primary band (solid totals).
  whiteOnPrimary,
}

/// One of a style's colour pairs that is too faint to read.
@immutable
class ContrastIssue {
  /// An issue; `ratio` is below [minTextContrast].
  const ContrastIssue(this.pair, this.ratio);

  /// Which text on which background.
  final ContrastPair pair;

  /// The measured ratio, e.g. 3.2 for 3.2:1.
  final double ratio;
}

const _white = 0xFFFFFFFF;

/// Every text/background pair [style] actually prints that falls below
/// [minTextContrast]. A band pair is only checked when the totals style
/// draws that band (plain totals print ink on the page instead).
List<ContrastIssue> contrastIssues(DocumentStyle style) {
  final pairs = <ContrastPair, (int, int)>{
    ContrastPair.inkOnPage: (style.ink, _white),
    ContrastPair.mutedOnPage: (style.muted, _white),
    ContrastPair.primaryOnPage: (style.primary, _white),
    ContrastPair.inkOnSurface: (style.ink, style.surface),
    ContrastPair.mutedOnSurface: (style.muted, style.surface),
    ContrastPair.mutedOnTableHeader: (style.muted, style.tableHeaderBg),
    if (style.totalsStyle == TotalsStyle.outlined)
      ContrastPair.whiteOnInk: (_white, style.ink),
    if (style.totalsStyle == TotalsStyle.solid)
      ContrastPair.whiteOnPrimary: (_white, style.primary),
  };
  return [
    for (final MapEntry(key: pair, value: (fg, bg)) in pairs.entries)
      if (contrastRatio(fg, bg) case final r when r < minTextContrast)
        ContrastIssue(pair, r),
  ];
}
