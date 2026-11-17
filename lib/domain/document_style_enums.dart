/// Font families bundled with Invoice Desk for document rendering.
enum DocFontFamily {
  /// IBM Plex Sans Arabic: modern sans-serif with full Arabic and Latin glyphs.
  ibmPlexSansArabic,

  /// Noto Naskh Arabic: traditional Arabic naskh calligraphy with IBM Plex fallback for Latin.
  notoNaskhArabic;

  /// Parses a font family name case-insensitively, defaulting to [ibmPlexSansArabic].
  static DocFontFamily fromString(String? v) => switch (v?.toLowerCase()) {
    'notonaskharabic' ||
    'noto_naskh_arabic' ||
    'naskh' => DocFontFamily.notoNaskhArabic,
    _ => DocFontFamily.ibmPlexSansArabic,
  };
}

/// Paper dimensions for generated PDF documents.
enum DocPaper {
  /// Standard ISO 216 A4 (210 × 297 mm, 595.28 × 841.89 pt).
  a4,

  /// Standard North American Letter (8.5 × 11 in, 612 × 792 pt).
  letter;

  /// Parses a paper format, defaulting to [a4].
  static DocPaper fromString(String? v) => switch (v?.toLowerCase()) {
    'letter' => DocPaper.letter,
    _ => DocPaper.a4,
  };
}

/// Visual presentation of the invoice and contract header block.
enum HeaderStyle {
  /// Solid background band spanning page margins.
  band,

  /// Clean baseline rule below header information.
  rule,

  /// Minimalist header with no divider line or band.
  none;

  /// Parses header style, defaulting to [rule].
  static HeaderStyle fromString(String? v) => switch (v?.toLowerCase()) {
    'band' => HeaderStyle.band,
    'none' => HeaderStyle.none,
    _ => HeaderStyle.rule,
  };
}

/// Placement of the logo image within the document header.
enum LogoPosition {
  /// Positioned at reading start (right in RTL, left in LTR).
  start,

  /// Positioned at reading end (left in RTL, right in LTR).
  end,

  /// Centered horizontally in the header block.
  center;

  /// Parses logo position, defaulting to [start].
  static LogoPosition fromString(String? v) => switch (v?.toLowerCase()) {
    'end' => LogoPosition.end,
    'center' => LogoPosition.center,
    _ => LogoPosition.start,
  };
}

/// Line item table layout styling.
enum TableStyle {
  /// Clean rows with light horizontal dividing rules.
  plain,

  /// Alternating shaded background rows for readability on long tables.
  striped,

  /// Explicit border grid enclosing table cells.
  bordered;

  /// Parses table style, defaulting to [plain].
  static TableStyle fromString(String? v) => switch (v?.toLowerCase()) {
    'striped' => TableStyle.striped,
    'bordered' => TableStyle.bordered,
    _ => TableStyle.plain,
  };
}

/// Styling of the totals and payment summary box.
enum TotalsStyle {
  /// Rounded box with subtle hairline border and solid total banner.
  outlined,

  /// Filled background container with inverted or contrasting text.
  solid,

  /// Light, minimal summary without solid dark fills; total rendered in dark ink.
  plain;

  /// Parses totals style, defaulting to [outlined].
  static TotalsStyle fromString(String? v) => switch (v?.toLowerCase()) {
    'solid' => TotalsStyle.solid,
    'plain' || 'minimal' || 'light' => TotalsStyle.plain,
    _ => TotalsStyle.outlined,
  };
}

/// Recognised structural blocks composing a document page.
enum DocBlock {
  /// Document title, number, logo, and dates.
  header,

  /// Freelancer (issuer) and client details.
  parties,

  /// Itemized line items table and subtotal summaries.
  items,

  /// Subtotals, VAT, deductions, and total amount due.
  totals,

  /// Document notes, payment instructions, and terms.
  notes,

  /// Page numbers and custom footer notes.
  footer;

  /// Parses a block identifier, returning null if unrecognized.
  static DocBlock? fromString(String? v) => switch (v?.toLowerCase()) {
    'header' => DocBlock.header,
    'parties' => DocBlock.parties,
    'items' => DocBlock.items,
    'totals' => DocBlock.totals,
    'notes' => DocBlock.notes,
    'footer' => DocBlock.footer,
    _ => null,
  };
}
