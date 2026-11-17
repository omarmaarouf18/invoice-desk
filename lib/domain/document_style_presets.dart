import 'package:invoice_desk/domain/document_style.dart';

/// The 6 built-in style presets provided with Invoice Desk.
///
/// Presets have stable read-only IDs (`preset_classic`, `preset_modern`, etc.).
/// Users cannot overwrite presets; they can duplicate them into customizable
/// user styles.
enum DocPreset {
  /// Today's look: balanced teal accent, slate dividers, navy ink.
  classic(
    id: 'preset_classic',
    nameAr: 'كلاسيكي',
    nameEn: 'Classic',
    style: DocumentStyle(),
  ),

  /// Contemporary layout with royal indigo accent, alternating striped table,
  /// solid totals box, and modern IBM Plex Sans Arabic typography.
  modern(
    id: 'preset_modern',
    nameAr: 'عصري',
    nameEn: 'Modern',
    style: DocumentStyle(
      primary: 0xFF1D4ED8,
      accent: 0xFF2563EB,
      ink: 0xFF111827,
      muted: 0xFF475569,
      surface: 0xFFF8FAFC,
      tableHeaderBg: 0xFFEFF6FF,
      border: 0xFFCBD5E1,
      marginTop: 32,
      headerStyle: HeaderStyle.band,
      tableStyle: TableStyle.striped,
      totalsStyle: TotalsStyle.solid,
    ),
  ),

  /// Clean, light, high-whitespace aesthetic with charcoal ink, rule-free header,
  /// no card backgrounds, light totals block, and generous page margins.
  minimal(
    id: 'preset_minimal',
    nameAr: 'بسيط',
    nameEn: 'Minimal',
    style: DocumentStyle(
      primary: 0xFF374151,
      accent: 0xFF4B5563,
      ink: 0xFF1F2937,
      muted: 0xFF6B7280,
      surface: 0xFFFFFFFF,
      tableHeaderBg: 0xFFFFFFFF,
      border: 0xFFE5E7EB,
      baseSize: 9,
      marginHorizontal: 48,
      marginTop: 44,
      marginBottom: 36,
      headerStyle: HeaderStyle.none,
      totalsStyle: TotalsStyle.plain,
    ),
  ),

  /// High-contrast executive layout with bold crimson accent, framed bordered table,
  /// and solid totals banner.
  bold(
    id: 'preset_bold',
    nameAr: 'بارز',
    nameEn: 'Bold',
    style: DocumentStyle(
      primary: 0xFF991B1B,
      accent: 0xFFB91C1C,
      ink: 0xFF09090B,
      muted: 0xFF52525B,
      surface: 0xFFF4F4F5,
      tableHeaderBg: 0xFFFEE2E2,
      border: 0xFFA1A1AA,
      baseSize: 10,
      marginHorizontal: 38,
      marginTop: 32,
      headerStyle: HeaderStyle.band,
      tableStyle: TableStyle.bordered,
      totalsStyle: TotalsStyle.solid,
    ),
  ),

  /// Traditional formal layout with deep navy accent, rule header, plain table,
  /// outlined totals, and classical Noto Naskh Arabic typography.
  formal(
    id: 'preset_formal',
    nameAr: 'رسمي',
    nameEn: 'Formal',
    style: DocumentStyle(
      primary: 0xFF1E3A5F,
      accent: 0xFF2563EB,
      ink: 0xFF0F172A,
      muted: 0xFF475569,
      surface: 0xFFF8FAFC,
      tableHeaderBg: 0xFFF1F5F9,
      border: 0xFFCBD5E1,
      fontFamily: DocFontFamily.notoNaskhArabic,
      baseSize: 10,
    ),
  ),

  /// Stripped-down layout showing only the essential blocks (header with name/number,
  /// items table, totals).
  blank(
    id: 'preset_blank',
    nameAr: 'أساسي',
    nameEn: 'Blank',
    style: DocumentStyle(
      surface: 0xFFFFFFFF,
      tableHeaderBg: 0xFFF9FAFB,
      border: 0xFFE5E7EB,
      headerStyle: HeaderStyle.none,
      showRole: false,
      showCity: false,
      showContacts: false,
      showPaymentCard: false,
      showNotes: false,
      showVatRow: false,
      showPleaseQuote: false,
      showPageNumbers: false,
      showSignatureBoxes: false,
      blockOrder: [
        DocBlock.header,
        DocBlock.parties,
        DocBlock.items,
        DocBlock.totals,
      ],
    ),
  );

  const DocPreset({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.style,
  });

  /// Stable unique ID used in the database and style resolution.
  final String id;

  /// Arabic localized display label.
  final String nameAr;

  /// English localized display label.
  final String nameEn;

  /// The preset's immutable style definition.
  final DocumentStyle style;

  /// Finds a preset by its stable ID, defaulting to [classic] if unrecognized.
  static DocPreset fromId(String? id) => switch (id) {
    'preset_modern' || 'modern' => DocPreset.modern,
    'preset_minimal' || 'minimal' => DocPreset.minimal,
    'preset_bold' || 'bold' => DocPreset.bold,
    'preset_formal' || 'formal' => DocPreset.formal,
    'preset_blank' || 'blank' => DocPreset.blank,
    _ => DocPreset.classic,
  };
}
