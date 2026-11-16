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
          pageTheme: b.pageTheme(pw.TextDirection.ltr),
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
        pageTheme: b.pageTheme(pw.TextDirection.rtl),
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
      s = data.settings;

  final InvoicePdfData data;
  final PdfFonts fonts;

  /// Colours and page geometry.
  final PdfStyle style;

  /// Main labels (an invoice is bilingual until document languages land).
  DocLabels get labelEn => DocLabels.en;

  /// Secondary Arabic labels and the Arabic scope page.
  DocLabels get labelAr => DocLabels.ar;
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
