import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';
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

/// Bundled IBM Plex Sans Arabic, as PDF fonts.
class PdfFonts {
  PdfFonts({required this.regular, required this.semiBold, required this.bold});

  factory PdfFonts.fromBytes({
    required ByteData regular,
    required ByteData semiBold,
    required ByteData bold,
  }) => PdfFonts(
    regular: pw.Font.ttf(regular),
    semiBold: pw.Font.ttf(semiBold),
    bold: pw.Font.ttf(bold),
  );

  final pw.Font regular;
  final pw.Font semiBold;
  final pw.Font bold;
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

/// `OM-2026-0001 - EL METR Academy.pdf`
String invoiceFileName(Invoice invoice, Client? client) {
  final name = (client?.name ?? '')
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
      .trim();
  return name.isEmpty
      ? '${invoice.number}.pdf'
      : '${invoice.number} - $name.pdf';
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
            b.header(),
            pw.SizedBox(height: 12),
            pw.Container(height: 2, color: style.ink),
            pw.SizedBox(height: 14),
            b.parties(),
            pw.SizedBox(height: 16),
            for (final (i, s) in data.invoice.sections.indexed) ...[
              ...b.section(i + 1, s),
              pw.SizedBox(height: 8),
            ],
            b.bottom(),
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

  pw.ThemeData get theme =>
      pw.ThemeData.withFont(
        base: fonts.regular,
        bold: fonts.bold,
      ).copyWith(
        defaultTextStyle: pw.TextStyle(
          font: fonts.regular,
          fontBold: fonts.bold,
          fontSize: 9.5,
          color: style.ink,
          lineSpacing: 1.5,
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
  }) => pw.TextStyle(
    font: font ?? fonts.regular,
    fontSize: size,
    color: color ?? style.ink,
    letterSpacing: spacing,
  );

  pw.Font get semi => fonts.semiBold;
  pw.Font get bold => fonts.bold;

  /// Text that picks its own direction (Arabic → RTL).
  pw.Widget t(
    String text, {
    pw.TextStyle? style,
    pw.TextAlign? align,
    pw.TextDirection? dir,
  }) => pw.Text(
    text,
    style: style,
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
  String docDate(CalendarDate d) => formatDocDate(d, lang, digits: digits);

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
