import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style_enums.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/labels.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
part 'invoice/header.dart';
part 'invoice/table.dart';
part 'invoice/totals.dart';
part 'invoice/footer.dart';
part 'invoice/scope_page.dart';

/// Bundled fonts as PDF fonts (IBM Plex Sans Arabic and Noto Naskh Arabic).
class PdfFonts {
  PdfFonts({
    required this.regular,
    required this.semiBold,
    required this.bold,
    this.naskhRegular,
    this.naskhSemiBold,
    this.naskhBold,
  });

  factory PdfFonts.fromBytes({
    required ByteData regular,
    required ByteData semiBold,
    required ByteData bold,
    ByteData? naskhRegular,
    ByteData? naskhSemiBold,
    ByteData? naskhBold,
  }) => PdfFonts(
    regular: pw.Font.ttf(regular),
    semiBold: pw.Font.ttf(semiBold),
    bold: pw.Font.ttf(bold),
    naskhRegular: naskhRegular != null ? pw.Font.ttf(naskhRegular) : null,
    naskhSemiBold: naskhSemiBold != null ? pw.Font.ttf(naskhSemiBold) : null,
    naskhBold: naskhBold != null ? pw.Font.ttf(naskhBold) : null,
  );

  final pw.Font regular;
  final pw.Font semiBold;
  final pw.Font bold;
  final pw.Font? naskhRegular;
  final pw.Font? naskhSemiBold;
  final pw.Font? naskhBold;

  pw.Font fontRegular(DocFontFamily family) =>
      family == DocFontFamily.notoNaskhArabic && naskhRegular != null
      ? naskhRegular!
      : regular;

  pw.Font fontSemiBold(DocFontFamily family) =>
      family == DocFontFamily.notoNaskhArabic && naskhSemiBold != null
      ? naskhSemiBold!
      : semiBold;

  pw.Font fontBold(DocFontFamily family) =>
      family == DocFontFamily.notoNaskhArabic && naskhBold != null
      ? naskhBold!
      : bold;

  List<pw.Font> fallbackFor(DocFontFamily family) =>
      family == DocFontFamily.notoNaskhArabic ? [regular] : const [];
}

class InvoicePdfData {
  const InvoicePdfData({
    required this.invoice,
    required this.client,
    required this.settings,
  });

  final Invoice invoice;
  final Client? client;
  final Settings settings;
}

final _arabic = RegExp(
  r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]',
);
bool _hasArabic(String s) => _arabic.hasMatch(s);

pw.TextDirection _dirOf(String s) =>
    _hasArabic(s) ? pw.TextDirection.rtl : pw.TextDirection.ltr;

/// Pure: invoice data in, PDF bytes out. [style] is the resolved look;
/// [PdfStyle.classic] is the 0.4 look.
Future<Uint8List> buildInvoicePdf(
  InvoicePdfData data,
  PdfFonts fonts, {
  PdfStyle style = PdfStyle.classic,
}) => buildInvoiceDocument(data, fonts, style: style).save();

pw.Document buildInvoiceDocument(
  InvoicePdfData data,
  PdfFonts fonts, {
  PdfStyle style = PdfStyle.classic,
}) {
  final b = _Builder(data, fonts, style);
  final doc =
      pw.Document(
        title: data.invoice.number,
        author: data.settings.name,
        creator: 'Invoice Desk',
        theme: b.theme,
      )..addPage(
        pw.MultiPage(
          pageTheme: b.pageTheme(b.dir),
          footer: b.footer,
          build: (_) => [
            if (style.blockOrder.contains(DocBlock.header)) ...[
              b.header(),
              if (style.headerStyle == HeaderStyle.rule) ...[
                pw.SizedBox(height: 12),
                pw.Container(height: 2, color: style.ink),
                pw.SizedBox(height: 14),
              ] else if (style.headerStyle == HeaderStyle.band) ...[
                pw.SizedBox(height: 16),
              ] else ...[
                pw.SizedBox(height: 14),
              ],
            ],
            if (style.blockOrder.contains(DocBlock.parties)) ...[
              b.parties(),
              pw.SizedBox(height: 16),
            ],
            if (style.blockOrder.contains(DocBlock.items)) ...[
              for (final (i, s) in data.invoice.sections.indexed) ...[
                ...b.section(i + 1, s),
                pw.SizedBox(height: 8),
              ],
            ],
            if (style.blockOrder.contains(DocBlock.totals)) b.bottom(),
          ],
        ),
      );
  if (data.invoice.scope.enabled) {
    doc.addPage(
      pw.MultiPage(
        pageTheme: b.pageTheme(b.scopeDir),
        footer: b.footer,
        build: (_) => b.scopePage(),
      ),
    );
  }
  return doc;
}

class _Builder {
  _Builder(this.data, this.fonts, this.style)
    : inv = data.invoice,
      s = data.settings,
      lang = data.invoice.language;

  final InvoicePdfData data;
  final PdfFonts fonts;

  /// Colours and page geometry.
  final PdfStyle style;

  /// The language the document is written in: the page, the labels and the
  /// dates follow it, and it has nothing to do with the language of the
  /// interface (ADR-0011).
  final DocLanguage lang;

  /// The labels of the document's language; English for a bilingual one.
  DocLabels get label => DocLabels.of(lang);

  /// The Arabic labels: the main ones of an Arabic invoice, the small
  /// secondary ones of a bilingual one.
  DocLabels get labelAr => DocLabels.ar;

  /// The reading direction of the page.
  pw.TextDirection get dir =>
      lang.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;

  /// The direction of the scope page: an Arabic one for an Arabic or a
  /// bilingual invoice, an English one for an English invoice.
  pw.TextDirection get scopeDir =>
      lang == DocLanguage.en ? pw.TextDirection.ltr : pw.TextDirection.rtl;

  /// The digits of the Arabic text.
  DigitStyle get digits => s.docDigitStyle;

  /// The document prints the Arabic secondary labels.
  bool get isBilingual => lang == DocLanguage.bilingual;

  /// The document is written in Arabic only.
  bool get isArabic => lang == DocLanguage.ar;

  /// The document is written in English only.
  bool get isEnglish => lang == DocLanguage.en;

  /// A label hugs the reading start: the left of an English page, the
  /// right of an Arabic one.
  pw.TextAlign get startAlign =>
      lang.isRtl ? pw.TextAlign.right : pw.TextAlign.start;

  /// A value hugs the reading end.
  pw.TextAlign get endAlign =>
      lang.isRtl ? pw.TextAlign.left : pw.TextAlign.right;

  final Invoice inv;
  final Settings s;

  pw.Font get fontRegular => fonts.fontRegular(style.fontFamily);
  pw.Font get semi => fonts.fontSemiBold(style.fontFamily);
  pw.Font get bold => fonts.fontBold(style.fontFamily);
  List<pw.Font> get fontFallback => fonts.fallbackFor(style.fontFamily);

  pw.ThemeData get theme =>
      pw.ThemeData.withFont(
        base: fontRegular,
        bold: bold,
        fontFallback: fontFallback,
      ).copyWith(
        defaultTextStyle: pw.TextStyle(
          font: fontRegular,
          fontBold: bold,
          fontFallback: fontFallback,
          fontSize: style.baseSize * style.scale,
          color: style.ink,
          lineSpacing: style.lineSpacing,
        ),
      );

  pw.PageTheme pageTheme(pw.TextDirection dir) => pw.PageTheme(
    pageFormat: style.paper,
    margin: style.invoiceMargin,
    textDirection: dir,
    theme: theme,
  );

  pw.TextStyle st({
    double size = 9.5,
    pw.Font? font,
    PdfColor? color,
    double? spacing,
    List<pw.Font>? fontFallback,
  }) => pw.TextStyle(
    font: font ?? fontRegular,
    fontBold: bold,
    fontFallback: fontFallback ?? this.fontFallback,
    fontSize: size * style.scale,
    color: color ?? style.ink,
    letterSpacing: spacing,
  );

  /// Text that picks its own direction (Arabic → RTL).
  ///
  /// Letter spacing (tracking) is for Latin runs only: spacing out Arabic
  /// glyphs breaks the cursive joins, so any run that holds Arabic is
  /// drawn with a letter spacing of 0 whatever [style] asks for.
  pw.Widget t(
    String text, {
    pw.TextStyle? style,
    pw.TextAlign? align,
    pw.TextDirection? dir,
  }) => pw.Text(
    text,
    style: _hasArabic(text) && (style?.letterSpacing ?? 0) != 0
        ? style!.copyWith(letterSpacing: 0)
        : style,
    textAlign: align,
    textDirection: dir ?? _dirOf(text),
  );

  /// The label of a block: the language's own, with the Arabic one as a
  /// small secondary label in a bilingual document.
  pw.Widget blockLabel(String en, String ar, {PdfColor? color}) {
    final c = color ?? style.muted;
    if (isBilingual) return bilingualLabel(en, ar, color: c);
    return isArabic
        ? t(
            ar,
            style: st(size: 8, font: semi, color: c),
          )
        : t(
            en,
            style: st(size: 7.5, font: bold, color: c, spacing: 0.8),
          );
  }

  /// The date as the document prints it: the Arabic date and the
  /// configured digits in an Arabic document, the English one otherwise.
  String docDate(CalendarDate d) =>
      formatDocDateAs(d, lang, s.dateFormat, digits: digits);

  /// An amount as the document prints it (currency display, then digits).
  String money(Money m) => docNumber(
    formatDocCurrency(m.minor, m.currency, lang, s.currencyDisplay),
  );

  /// Per-currency totals, each as [money] prints it.
  String moneyBag(MoneyBag b, {String separator = ' + '}) => docNumber(
    formatDocCurrencyBag(b, lang, s.currencyDisplay, separator: separator),
  );

  /// A number in the document's digits: the Arabic text uses the
  /// configured style, the English text always uses Western digits.
  String docNumber(String text) =>
      isArabic ? applyDigitStyle(text, digits) : text;

  /// Latin label + Arabic label, e.g. `BILLED TO · العميل`.
  pw.Widget bilingualLabel(String en, String ar, {PdfColor? color}) {
    final c = color ?? style.muted;
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        t(
          en,
          style: st(size: 7.5, font: bold, color: c, spacing: 0.8),
        ),
        t('  ·  ', style: st(size: 7.5, color: c)),
        t(
          ar,
          style: st(size: 8, font: semi, color: c),
        ),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────────────────
  // ── Billed to / payment details ───────────────────────────────────────
  // ── Sections ──────────────────────────────────────────────────────────
  // ── Notes + totals ────────────────────────────────────────────────────
  // ── Footer ────────────────────────────────────────────────────────────
  // ── Scope page (RTL) ──────────────────────────────────────────────────
}
