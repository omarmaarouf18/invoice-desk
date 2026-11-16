import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
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

// Palette (matches the app's light theme).
const _ink = PdfColor.fromInt(0xFF0F1B2D);
const _teal = PdfColor.fromInt(0xFF0F766E);
const _muted = PdfColor.fromInt(0xFF5B6878);
const _soft = PdfColor.fromInt(0xFFF3F6F9);
const _border = PdfColor.fromInt(0xFFDCE2EA);
const _green = PdfColor.fromInt(0xFF067647);
const _greenBg = PdfColor.fromInt(0xFFDCFAE6);
const _blue = PdfColor.fromInt(0xFF1D4ED8);
const _blueBg = PdfColor.fromInt(0xFFE0EAFF);
const _tealBg = PdfColor.fromInt(0xFFD6F1EE);
const _greyBg = PdfColor.fromInt(0xFFEEF1F5);

final _arabic = RegExp(
  r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]',
);
bool _hasArabic(String s) => _arabic.hasMatch(s);

pw.TextDirection _dirOf(String s) =>
    _hasArabic(s) ? pw.TextDirection.rtl : pw.TextDirection.ltr;

/// Pure: invoice data in, PDF bytes out.
Future<Uint8List> buildInvoicePdf(InvoicePdfData data, PdfFonts fonts) =>
    buildInvoiceDocument(data, fonts).save();

pw.Document buildInvoiceDocument(InvoicePdfData data, PdfFonts fonts) {
  final b = _Builder(data, fonts);
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
            pw.Container(height: 2, color: _ink),
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
  _Builder(this.data, this.fonts) : inv = data.invoice, s = data.settings;

  final InvoicePdfData data;
  final PdfFonts fonts;
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
          color: _ink,
          lineSpacing: 1.5,
        ),
      );

  pw.PageTheme pageTheme(pw.TextDirection dir) => pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(40, 34, 40, 26),
    textDirection: dir,
    theme: theme,
  );

  pw.TextStyle st({
    double size = 9.5,
    pw.Font? font,
    PdfColor color = _ink,
    double? spacing,
  }) => pw.TextStyle(
    font: font ?? fonts.regular,
    fontSize: size,
    color: color,
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
  pw.Widget bilingualLabel(String en, String ar, {PdfColor color = _muted}) =>
      pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          t(
            en,
            style: st(size: 7.5, font: bold, color: color, spacing: 0.8),
          ),
          t('  ·  ', style: st(size: 7.5, color: color)),
          t(
            ar,
            style: st(size: 8, font: semi, color: color),
          ),
        ],
      );

  // ── Header ────────────────────────────────────────────────────────────
  // ── Billed to / payment details ───────────────────────────────────────
  // ── Sections ──────────────────────────────────────────────────────────
  // ── Notes + totals ────────────────────────────────────────────────────
  // ── Footer ────────────────────────────────────────────────────────────
  // ── Scope page (RTL) ──────────────────────────────────────────────────
}
