import 'dart:typed_data';

import 'package:invoice_desk/domain/document_style.dart';
import 'package:meta/meta.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// The resolved look of a PDF, as the invoice and contract builders read it.
///
/// Phase 1 holds the palette and page geometry of the built-in look,
/// [classic], which reproduces 0.4's output exactly (locked by the PDF
/// goldens). Document styles (ADR-0012) resolve to this class.
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
    this.tableHeaderBg = const PdfColor.fromInt(0xFFF3F6F9),
    this.accent = const PdfColor.fromInt(0xFF0D9488),
    this.paper = PdfPageFormat.a4,
    this.invoiceMargin = const pw.EdgeInsets.fromLTRB(40, 34, 40, 26),
    this.contractMargin = const pw.EdgeInsets.fromLTRB(52, 44, 52, 30),
    this.fontFamily = DocFontFamily.ibmPlexSansArabic,
    this.baseSize = 9.5,
    this.scale = 1.0,
    this.lineSpacing = 1.5,
    this.headerStyle = HeaderStyle.rule,
    this.logoBytes,
    this.logoSize = 48.0,
    this.logoPosition = LogoPosition.start,
    this.tableStyle = TableStyle.plain,
    this.totalsStyle = TotalsStyle.outlined,
    this.showRole = true,
    this.showCity = true,
    this.showContacts = true,
    this.showPaymentCard = true,
    this.showNotes = true,
    this.showVatRow = true,
    this.showPleaseQuote = true,
    this.showPageNumbers = true,
    this.showSignatureBoxes = true,
    this.showPaidStamp = true,
    this.blockOrder = DocumentStyle.defaultBlockOrder,
    this.footerTextAr = '',
    this.footerTextEn = '',
  });

  /// Resolves a [DocumentStyle] domain object into a [PdfStyle] ready for PDF rendering.
  factory PdfStyle.fromDocumentStyle(DocumentStyle s, {Uint8List? logoBytes}) {
    if (s == const DocumentStyle() && logoBytes == null) {
      return PdfStyle.classic;
    }

    final paperFormat = s.paper == DocPaper.letter
        ? PdfPageFormat.letter
        : PdfPageFormat.a4;

    final invMargin = pw.EdgeInsets.fromLTRB(
      s.marginHorizontal,
      s.marginTop,
      s.marginHorizontal,
      s.marginBottom,
    );

    final contractMargin = pw.EdgeInsets.fromLTRB(
      s.marginHorizontal + 12,
      s.marginTop + 10,
      s.marginHorizontal + 12,
      s.marginBottom + 4,
    );

    final primary = PdfColor.fromInt(s.primary);
    final primarySoft = _blendWithWhite(s.primary, 0.15);
    final ink = PdfColor.fromInt(s.ink);
    final muted = PdfColor.fromInt(s.muted);
    final surface = PdfColor.fromInt(s.surface);
    final tableHeaderBg = PdfColor.fromInt(s.tableHeaderBg);
    final border = PdfColor.fromInt(s.border);
    final accent = PdfColor.fromInt(s.accent);

    return PdfStyle(
      ink: ink,
      primary: primary,
      primarySoft: primarySoft,
      muted: muted,
      surface: surface,
      border: border,
      tableHeaderBg: tableHeaderBg,
      accent: accent,
      onInk: PdfColors.white,
      onInkMuted: _blendWithWhite(s.ink, 0.3),
      success: const PdfColor.fromInt(0xFF067647),
      successSoft: const PdfColor.fromInt(0xFFDCFAE6),
      info: const PdfColor.fromInt(0xFF1D4ED8),
      infoSoft: const PdfColor.fromInt(0xFFE0EAFF),
      neutralSoft: const PdfColor.fromInt(0xFFEEF1F5),
      highlight: const PdfColor.fromInt(0xFFFFE8A3),
      onHighlight: const PdfColor.fromInt(0xFF7A4A00),
      watermark: primarySoft,
      paper: paperFormat,
      invoiceMargin: invMargin,
      contractMargin: contractMargin,
      fontFamily: s.fontFamily,
      baseSize: s.baseSize,
      scale: s.scale,
      headerStyle: s.headerStyle,
      logoBytes: logoBytes,
      logoSize: s.logoSize,
      logoPosition: s.logoPosition,
      tableStyle: s.tableStyle,
      totalsStyle: s.totalsStyle,
      showRole: s.showRole,
      showCity: s.showCity,
      showContacts: s.showContacts,
      showPaymentCard: s.showPaymentCard,
      showNotes: s.showNotes,
      showVatRow: s.showVatRow,
      showPleaseQuote: s.showPleaseQuote,
      showPageNumbers: s.showPageNumbers,
      showSignatureBoxes: s.showSignatureBoxes,
      showPaidStamp: s.showPaidStamp,
      blockOrder: s.blockOrder,
      footerTextAr: s.footerTextAr,
      footerTextEn: s.footerTextEn,
    );
  }

  static PdfColor _blendWithWhite(int colorHex, double factor) {
    final r = (colorHex >> 16) & 0xFF;
    final g = (colorHex >> 8) & 0xFF;
    final b = colorHex & 0xFF;
    final blendedR = (r * factor + 255 * (1 - factor)).round().clamp(0, 255);
    final blendedG = (g * factor + 255 * (1 - factor)).round().clamp(0, 255);
    final blendedB = (b * factor + 255 * (1 - factor)).round().clamp(0, 255);
    return PdfColor.fromInt(
      (0xFF << 24) | (blendedR << 16) | (blendedG << 8) | blendedB,
    );
  }

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

  /// Table header background color.
  final PdfColor tableHeaderBg;

  /// Accent color for badges and emphasis.
  final PdfColor accent;

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

  /// Font family (IBM Plex or Noto Naskh).
  final DocFontFamily fontFamily;

  /// Base font size in points.
  final double baseSize;

  /// Scale multiplier.
  final double scale;

  /// Text line spacing.
  final double lineSpacing;

  /// Visual presentation of header.
  final HeaderStyle headerStyle;

  /// Binary bytes of the logo image, if any.
  final Uint8List? logoBytes;

  /// Max logo box dimension.
  final double logoSize;

  /// Logo alignment in header.
  final LogoPosition logoPosition;

  /// Line item table layout styling.
  final TableStyle tableStyle;

  /// Totals and payment summary box styling.
  final TotalsStyle totalsStyle;

  /// Section visibility toggles.
  final bool showRole;
  final bool showCity;
  final bool showContacts;
  final bool showPaymentCard;
  final bool showNotes;
  final bool showVatRow;
  final bool showPleaseQuote;
  final bool showPageNumbers;
  final bool showSignatureBoxes;
  final bool showPaidStamp;

  /// Structural block order.
  final List<DocBlock> blockOrder;

  /// Custom footer notes.
  final String footerTextAr;
  final String footerTextEn;

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
