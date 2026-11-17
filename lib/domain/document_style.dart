import 'dart:convert';
import 'package:invoice_desk/domain/document_style_enums.dart';
import 'package:meta/meta.dart';

export 'package:invoice_desk/domain/document_style_enums.dart';

/// Immutable styling configuration for documents (invoices, contracts, quotes).
///
/// Designed to be serializable to/from JSON for storage in `document_styles.json`
/// and document snapshot columns. Pure Dart with no Flutter or PDF dependencies.
@immutable
class DocumentStyle {
  /// Creates a style definition.
  const DocumentStyle({
    this.primary = 0xFF0F766E,
    this.accent = 0xFF0F766E,
    this.ink = 0xFF0F1B2D,
    this.muted = 0xFF5B6878,
    this.surface = 0xFFF3F6F9,
    this.tableHeaderBg = 0xFFF3F6F9,
    this.border = 0xFFDCE2EA,
    this.fontFamily = DocFontFamily.ibmPlexSansArabic,
    this.baseSize = 9.5,
    this.scale = 1,
    this.paper = DocPaper.a4,
    this.marginHorizontal = 40,
    this.marginTop = 34,
    this.marginBottom = 26,
    this.headerStyle = HeaderStyle.rule,
    this.logoAssetId,
    this.logoSize = 48,
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
    this.blockOrder = defaultBlockOrder,
    this.footerTextAr = '',
    this.footerTextEn = '',
  });

  /// Deserializes a JSON map into a [DocumentStyle].
  ///
  /// Safe against malformed, partial, or fuzzed inputs:
  /// - Missing keys fall back to defaults.
  /// - Numbers outside valid bounds are clamped.
  /// - Invalid color formats default safely.
  /// - Unknown enum values fallback to documented defaults.
  factory DocumentStyle.fromJson(Map<String, dynamic> json) {
    return DocumentStyle(
      primary: _parseColor(json['primary'], 0xFF0F766E),
      accent: _parseColor(json['accent'], 0xFF0F766E),
      ink: _parseColor(json['ink'], 0xFF0F1B2D),
      muted: _parseColor(json['muted'], 0xFF5B6878),
      surface: _parseColor(json['surface'], 0xFFF3F6F9),
      tableHeaderBg: _parseColor(json['tableHeaderBg'], 0xFFF3F6F9),
      border: _parseColor(json['border'], 0xFFDCE2EA),
      fontFamily: DocFontFamily.fromString(_string(json['fontFamily'])),
      baseSize: _clampDouble(json['baseSize'], 8, 14, 9.5),
      scale: _clampDouble(json['scale'], 0.8, 1.5, 1),
      paper: DocPaper.fromString(_string(json['paper'])),
      marginHorizontal: _clampDouble(json['marginHorizontal'], 15, 80, 40),
      marginTop: _clampDouble(json['marginTop'], 15, 80, 34),
      marginBottom: _clampDouble(json['marginBottom'], 15, 80, 26),
      headerStyle: HeaderStyle.fromString(_string(json['headerStyle'])),
      logoAssetId:
          json['logoAssetId'] is String &&
              (json['logoAssetId'] as String).isNotEmpty
          ? json['logoAssetId'] as String
          : null,
      logoSize: _clampDouble(json['logoSize'], 20, 120, 48),
      logoPosition: LogoPosition.fromString(_string(json['logoPosition'])),
      tableStyle: TableStyle.fromString(_string(json['tableStyle'])),
      totalsStyle: TotalsStyle.fromString(_string(json['totalsStyle'])),
      showRole: _bool(json['showRole']),
      showCity: _bool(json['showCity']),
      showContacts: _bool(json['showContacts']),
      showPaymentCard: _bool(json['showPaymentCard']),
      showNotes: _bool(json['showNotes']),
      showVatRow: _bool(json['showVatRow']),
      showPleaseQuote: _bool(json['showPleaseQuote']),
      showPageNumbers: _bool(json['showPageNumbers']),
      showSignatureBoxes: _bool(json['showSignatureBoxes']),
      showPaidStamp: _bool(json['showPaidStamp']),
      blockOrder: _parseBlockOrder(json['blockOrder']),
      footerTextAr: json['footerTextAr'] is String
          ? json['footerTextAr'] as String
          : '',
      footerTextEn: json['footerTextEn'] is String
          ? json['footerTextEn'] as String
          : '',
    );
  }

  /// Deserializes a raw JSON string into a [DocumentStyle].
  ///
  /// Never throws on invalid JSON; falls back to default style on parse errors.
  factory DocumentStyle.fromRawJson(String raw) {
    if (raw.trim().isEmpty) return const DocumentStyle();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return DocumentStyle.fromJson(decoded);
      }
    } on Object catch (_) {
      // Fuzz / corrupted input falls back to default style.
    }
    return const DocumentStyle();
  }

  /// Default block ordering for invoices and contracts.
  static const List<DocBlock> defaultBlockOrder = [
    DocBlock.header,
    DocBlock.parties,
    DocBlock.items,
    DocBlock.totals,
    DocBlock.notes,
    DocBlock.footer,
  ];

  /// Primary brand color (ARGB integer, e.g. 0xFF0F766E). Used for headers and highlights.
  final int primary;

  /// Accent color (ARGB integer). Used for status badges and secondary emphasis.
  final int accent;

  /// Main text color (ARGB integer, e.g. 0xFF0F1B2D).
  final int ink;

  /// Secondary muted text color (ARGB integer, e.g. 0xFF5B6878).
  final int muted;

  /// Neutral background surface color (ARGB integer, e.g. 0xFFF3F6F9).
  final int surface;

  /// Line item table header background color (ARGB integer).
  final int tableHeaderBg;

  /// Border and divider line color (ARGB integer, e.g. 0xFFDCE2EA).
  final int border;

  /// Font family used for body and heading text.
  final DocFontFamily fontFamily;

  /// Base font size in points (clamped between 8.0 and 14.0 pt).
  final double baseSize;

  /// Scale multiplier for line height and text elements (clamped between 0.8 and 1.5).
  final double scale;

  /// Paper size (A4 or Letter).
  final DocPaper paper;

  /// Left and right page margins in points (clamped between 15.0 and 80.0 pt).
  final double marginHorizontal;

  /// Top page margin in points (clamped between 15.0 and 80.0 pt).
  final double marginTop;

  /// Bottom page margin in points (clamped between 15.0 and 80.0 pt).
  final double marginBottom;

  /// Visual presentation style of the header.
  final HeaderStyle headerStyle;

  /// SHA-256 hash reference to a stored `document_assets` image, or null if no logo.
  final String? logoAssetId;

  /// Logo box display height/width limit in points (clamped between 20.0 and 120.0 pt).
  final double logoSize;

  /// Placement of the logo in the header.
  final LogoPosition logoPosition;

  /// Styling of the items table.
  final TableStyle tableStyle;

  /// Styling of the totals and payment summary box.
  final TotalsStyle totalsStyle;

  /// Whether to render the issuer role / title under their name.
  final bool showRole;

  /// Whether to display issuer / client city locations.
  final bool showCity;

  /// Whether to print issuer / client contact details (email, phone, website).
  final bool showContacts;

  /// Whether to print the payment details card.
  final bool showPaymentCard;

  /// Whether to print notes and terms blocks.
  final bool showNotes;

  /// Whether to print the VAT row when VAT is not applicable.
  final bool showVatRow;

  /// Whether to print the "Please quote invoice number" payment hint.
  final bool showPleaseQuote;

  /// Whether to display page numbers in the footer.
  final bool showPageNumbers;

  /// Whether to render contract signature boxes.
  final bool showSignatureBoxes;

  /// Whether to print the "PAID" stamp when an invoice is fully paid.
  final bool showPaidStamp;

  /// Ordered list of structural blocks for document layout.
  final List<DocBlock> blockOrder;

  /// Custom Arabic footer text printed across all pages.
  final String footerTextAr;

  /// Custom English footer text printed across all pages.
  final String footerTextEn;

  /// Serializes this style definition to a JSON map.
  Map<String, dynamic> toJson() => {
    'primary': _colorHex(primary),
    'accent': _colorHex(accent),
    'ink': _colorHex(ink),
    'muted': _colorHex(muted),
    'surface': _colorHex(surface),
    'tableHeaderBg': _colorHex(tableHeaderBg),
    'border': _colorHex(border),
    'fontFamily': fontFamily.name,
    'baseSize': baseSize,
    'scale': scale,
    'paper': paper.name,
    'marginHorizontal': marginHorizontal,
    'marginTop': marginTop,
    'marginBottom': marginBottom,
    'headerStyle': headerStyle.name,
    if (logoAssetId != null) 'logoAssetId': logoAssetId,
    'logoSize': logoSize,
    'logoPosition': logoPosition.name,
    'tableStyle': tableStyle.name,
    'totalsStyle': totalsStyle.name,
    'showRole': showRole,
    'showCity': showCity,
    'showContacts': showContacts,
    'showPaymentCard': showPaymentCard,
    'showNotes': showNotes,
    'showVatRow': showVatRow,
    'showPleaseQuote': showPleaseQuote,
    'showPageNumbers': showPageNumbers,
    'showSignatureBoxes': showSignatureBoxes,
    'showPaidStamp': showPaidStamp,
    'blockOrder': [for (final b in blockOrder) b.name],
    if (footerTextAr.isNotEmpty) 'footerTextAr': footerTextAr,
    if (footerTextEn.isNotEmpty) 'footerTextEn': footerTextEn,
  };

  /// Serializes this style definition to a JSON string.
  String toRawJson() => jsonEncode(toJson());

  /// Returns a copy of this style with selected fields updated.
  DocumentStyle copyWith({
    int? primary,
    int? accent,
    int? ink,
    int? muted,
    int? surface,
    int? tableHeaderBg,
    int? border,
    DocFontFamily? fontFamily,
    double? baseSize,
    double? scale,
    DocPaper? paper,
    double? marginHorizontal,
    double? marginTop,
    double? marginBottom,
    HeaderStyle? headerStyle,
    String? logoAssetId,
    bool clearLogoAssetId = false,
    double? logoSize,
    LogoPosition? logoPosition,
    TableStyle? tableStyle,
    TotalsStyle? totalsStyle,
    bool? showRole,
    bool? showCity,
    bool? showContacts,
    bool? showPaymentCard,
    bool? showNotes,
    bool? showVatRow,
    bool? showPleaseQuote,
    bool? showPageNumbers,
    bool? showSignatureBoxes,
    bool? showPaidStamp,
    List<DocBlock>? blockOrder,
    String? footerTextAr,
    String? footerTextEn,
  }) {
    return DocumentStyle(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      surface: surface ?? this.surface,
      tableHeaderBg: tableHeaderBg ?? this.tableHeaderBg,
      border: border ?? this.border,
      fontFamily: fontFamily ?? this.fontFamily,
      baseSize: baseSize ?? this.baseSize,
      scale: scale ?? this.scale,
      paper: paper ?? this.paper,
      marginHorizontal: marginHorizontal ?? this.marginHorizontal,
      marginTop: marginTop ?? this.marginTop,
      marginBottom: marginBottom ?? this.marginBottom,
      headerStyle: headerStyle ?? this.headerStyle,
      logoAssetId: clearLogoAssetId ? null : (logoAssetId ?? this.logoAssetId),
      logoSize: logoSize ?? this.logoSize,
      logoPosition: logoPosition ?? this.logoPosition,
      tableStyle: tableStyle ?? this.tableStyle,
      totalsStyle: totalsStyle ?? this.totalsStyle,
      showRole: showRole ?? this.showRole,
      showCity: showCity ?? this.showCity,
      showContacts: showContacts ?? this.showContacts,
      showPaymentCard: showPaymentCard ?? this.showPaymentCard,
      showNotes: showNotes ?? this.showNotes,
      showVatRow: showVatRow ?? this.showVatRow,
      showPleaseQuote: showPleaseQuote ?? this.showPleaseQuote,
      showPageNumbers: showPageNumbers ?? this.showPageNumbers,
      showSignatureBoxes: showSignatureBoxes ?? this.showSignatureBoxes,
      showPaidStamp: showPaidStamp ?? this.showPaidStamp,
      blockOrder: blockOrder ?? this.blockOrder,
      footerTextAr: footerTextAr ?? this.footerTextAr,
      footerTextEn: footerTextEn ?? this.footerTextEn,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentStyle &&
          runtimeType == other.runtimeType &&
          primary == other.primary &&
          accent == other.accent &&
          ink == other.ink &&
          muted == other.muted &&
          surface == other.surface &&
          tableHeaderBg == other.tableHeaderBg &&
          border == other.border &&
          fontFamily == other.fontFamily &&
          baseSize == other.baseSize &&
          scale == other.scale &&
          paper == other.paper &&
          marginHorizontal == other.marginHorizontal &&
          marginTop == other.marginTop &&
          marginBottom == other.marginBottom &&
          headerStyle == other.headerStyle &&
          logoAssetId == other.logoAssetId &&
          logoSize == other.logoSize &&
          logoPosition == other.logoPosition &&
          tableStyle == other.tableStyle &&
          totalsStyle == other.totalsStyle &&
          showRole == other.showRole &&
          showCity == other.showCity &&
          showContacts == other.showContacts &&
          showPaymentCard == other.showPaymentCard &&
          showNotes == other.showNotes &&
          showVatRow == other.showVatRow &&
          showPleaseQuote == other.showPleaseQuote &&
          showPageNumbers == other.showPageNumbers &&
          showSignatureBoxes == other.showSignatureBoxes &&
          showPaidStamp == other.showPaidStamp &&
          _listEquals(blockOrder, other.blockOrder) &&
          footerTextAr == other.footerTextAr &&
          footerTextEn == other.footerTextEn;

  @override
  int get hashCode => Object.hashAll([
    primary,
    accent,
    ink,
    muted,
    surface,
    tableHeaderBg,
    border,
    fontFamily,
    baseSize,
    scale,
    paper,
    marginHorizontal,
    marginTop,
    marginBottom,
    headerStyle,
    logoAssetId,
    logoSize,
    logoPosition,
    tableStyle,
    totalsStyle,
    showRole,
    showCity,
    showContacts,
    showPaymentCard,
    showNotes,
    showVatRow,
    showPleaseQuote,
    showPageNumbers,
    showSignatureBoxes,
    showPaidStamp,
    Object.hashAll(blockOrder),
    footerTextAr,
    footerTextEn,
  ]);
}

String _colorHex(int color) =>
    '#${(color & 0xFFFFFFFF).toRadixString(16).padLeft(8, '0').toUpperCase()}';

/// [v] when it is a string, else null (the enum's default): a hand-edited
/// or fuzzed file may put any JSON type here.
String? _string(Object? v) => v is String ? v : null;

/// [v] when it is a bool, else true (every toggle defaults to shown).
bool _bool(Object? v) => v is! bool || v;

int _parseColor(dynamic v, int fallback) {
  if (v is int) return v | 0xFF000000;
  if (v is String) {
    final clean = v.trim().replaceFirst('#', '').replaceFirst('0x', '');
    if (clean.length == 6) {
      final val = int.tryParse(clean, radix: 16);
      if (val != null) return 0xFF000000 | val;
    } else if (clean.length == 8) {
      final val = int.tryParse(clean, radix: 16);
      if (val != null) return val;
    }
  }
  return fallback;
}

double _clampDouble(dynamic v, double min, double max, double fallback) {
  if (v is num && !v.isNaN && !v.isInfinite) {
    return v.toDouble().clamp(min, max);
  }
  return fallback;
}

List<DocBlock> _parseBlockOrder(dynamic v) {
  if (v is! List) return DocumentStyle.defaultBlockOrder;
  final seen = <DocBlock>{};
  final blocks = <DocBlock>[];
  for (final item in v) {
    final b = DocBlock.fromString(item?.toString());
    if (b != null && seen.add(b)) {
      blocks.add(b);
    }
  }
  return blocks.isEmpty ? DocumentStyle.defaultBlockOrder : blocks;
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
