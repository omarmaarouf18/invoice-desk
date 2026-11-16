import 'package:meta/meta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// The resolved look of a PDF, as the invoice and contract builders read it.
///
/// Phase 1 holds the palette and page geometry of the one built-in look,
/// [classic], which reproduces 0.4's output exactly (locked by the PDF
/// goldens). Document styles (ADR-0012) will resolve to this class, so the
/// builders never read raw constants again.
@immutable
class PdfStyle {
  /// A style; every colour is opaque (the PDF engine ignores alpha).
  const PdfStyle({
    required this.ink,
    required this.primary,
    required this.primarySoft,
    required this.muted,
    required this.surface,
    required this.border,
    required this.onInk,
    required this.onInkMuted,
    required this.success,
    required this.successSoft,
    required this.info,
    required this.infoSoft,
    required this.neutralSoft,
    required this.highlight,
    required this.onHighlight,
    required this.watermark,
    this.paper = PdfPageFormat.a4,
    this.invoiceMargin = const pw.EdgeInsets.fromLTRB(40, 34, 40, 26),
    this.contractMargin = const pw.EdgeInsets.fromLTRB(52, 44, 52, 30),
  });

  /// Body text and strong rules.
  final PdfColor ink;

  /// Accent: role line, section numbers, headings.
  final PdfColor primary;

  /// Pale accent background (annual pill, contract number box).
  final PdfColor primarySoft;

  /// Secondary text.
  final PdfColor muted;

  /// Card and table-header background.
  final PdfColor surface;

  /// Hairlines and table rules.
  final PdfColor border;

  /// Text on an [ink] background (the total-due band).
  final PdfColor onInk;

  /// Secondary text on an [ink] background.
  final PdfColor onInkMuted;

  /// Paid stamp.
  final PdfColor success;
  final PdfColor successSoft;

  /// Monthly pill.
  final PdfColor info;
  final PdfColor infoSoft;

  /// One-time pill.
  final PdfColor neutralSoft;

  /// Unresolved contract variables (background and text).
  final PdfColor highlight;
  final PdfColor onHighlight;

  /// The draft watermark, drawn behind the content.
  final PdfColor watermark;

  /// Page size.
  final PdfPageFormat paper;

  /// Page margins in points (1/72 in).
  final pw.EdgeInsets invoiceMargin;
  final pw.EdgeInsets contractMargin;

  /// The look of every document before document styles: the app's light
  /// palette (ink navy, teal accent).
  static const classic = PdfStyle(
    ink: PdfColor.fromInt(0xFF0F1B2D),
    primary: PdfColor.fromInt(0xFF0F766E),
    primarySoft: PdfColor.fromInt(0xFFD6F1EE),
    muted: PdfColor.fromInt(0xFF5B6878),
    surface: PdfColor.fromInt(0xFFF3F6F9),
    border: PdfColor.fromInt(0xFFDCE2EA),
    onInk: PdfColors.white,
    onInkMuted: PdfColor.fromInt(0xFFB8C2CF),
    success: PdfColor.fromInt(0xFF067647),
    successSoft: PdfColor.fromInt(0xFFDCFAE6),
    info: PdfColor.fromInt(0xFF1D4ED8),
    infoSoft: PdfColor.fromInt(0xFFE0EAFF),
    neutralSoft: PdfColor.fromInt(0xFFEEF1F5),
    highlight: PdfColor.fromInt(0xFFFFE8A3),
    onHighlight: PdfColor.fromInt(0xFF7A4A00),
    watermark: PdfColor.fromInt(0xFFE4F1EF),
  );
}
