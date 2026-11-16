import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart' show PdfFonts;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
part 'contract/body.dart';
part 'contract/cover.dart';
part 'contract/annex_tables.dart';
part 'contract/signatures.dart';
part 'contract/footer.dart';

class ContractPdfData {
  const ContractPdfData({
    required this.contract,
    required this.client,
    required this.settings,
    this.parent,
  });

  final Contract contract;
  final Client? client;
  final Settings settings;

  /// The original, for an amendment.
  final Contract? parent;
}

/// `CT-2026-0001 - Acme Studio.pdf`
String contractFileName(Contract c, Client? client) {
  final name = (client?.name ?? '')
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
      .trim();
  return name.isEmpty ? '${c.number}.pdf' : '${c.number} - $name.pdf';
}

/// The document heading: `عقد تطوير منصة`, `عرض سعر …`, `ملحق تعديل …`.
String contractHeading(Contract c, {Contract? parent}) {
  final title = c.title.trim();
  return switch (c.kind) {
    ContractKind.amendment =>
      'ملحق تعديل رقم ${c.amendmentNo} '
          'للعقد ${parent?.number ?? c.number.replaceFirst(RegExp(r'-A\d+$'), '')}'
          '${title.isEmpty ? '' : ': $title'}',
    ContractKind.quote => title.isEmpty ? 'عرض سعر' : 'عرض سعر $title',
    ContractKind.contract => title.isEmpty ? 'عقد' : 'عقد $title',
  };
}

// Palette: the invoice's, plus amber for unresolved variables.
const _ink = PdfColor.fromInt(0xFF0F1B2D);
const _teal = PdfColor.fromInt(0xFF0F766E);
const _tealBg = PdfColor.fromInt(0xFFD6F1EE);
const _muted = PdfColor.fromInt(0xFF5B6878);
const _soft = PdfColor.fromInt(0xFFF3F6F9);
const _border = PdfColor.fromInt(0xFFDCE2EA);
const _amberBg = PdfColor.fromInt(0xFFFFE8A3);
const _amberFg = PdfColor.fromInt(0xFF7A4A00);

/// Pale teal, drawn behind the content (the PDF engine ignores colour
/// alpha, so transparency would print solid).
const _watermark = PdfColor.fromInt(0xFFE4F1EF);

final _latinOnly = RegExp(r'^[\x00-\x7F\u2066-\u2069]*$');

/// Pure: contract data in, PDF bytes out.
Future<Uint8List> buildContractPdf(ContractPdfData data, PdfFonts fonts) =>
    buildContractDocument(data, fonts).save();

/// [onFooter] reports each page's footer (tests check every page has one).
pw.Document buildContractDocument(
  ContractPdfData data,
  PdfFonts fonts, {
  void Function(int page, int pages)? onFooter,
}) {
  final b = _Builder(data, fonts, onFooter: onFooter);
  final c = data.contract;
  return pw.Document(
      title: c.number,
      author: data.settings.legalName.trim().isEmpty
          ? data.settings.name
          : data.settings.legalName,
      creator: 'Invoice Desk',
      theme: b.theme,
    )
    ..addPage(
      pw.MultiPage(
        pageTheme: b.pageTheme,
        footer: b.footer,
        build: (_) => [
          b.cover(),
          pw.SizedBox(height: 18),
          ...b.preamble(),
          ...b.clauses(),
          ...b.closing(),
        ],
      ),
    )
    ..addPage(
      pw.MultiPage(
        pageTheme: b.pageTheme,
        footer: b.footer,
        build: (_) => b.scopeAnnex(),
      ),
    )
    ..addPage(
      pw.MultiPage(
        pageTheme: b.pageTheme,
        footer: b.footer,
        build: (_) => [
          ...b.paymentAnnex(),
          pw.SizedBox(height: 28),
          b.signatures(),
        ],
      ),
    );
}

class _Builder {
  _Builder(this.data, this.fonts, {this.onFooter})
    : c = data.contract,
      s = data.settings,
      resolver = VariableResolver(
        contract: data.contract,
        client: data.client,
        settings: data.settings,
      );

  final ContractPdfData data;
  final PdfFonts fonts;
  final void Function(int page, int pages)? onFooter;
  final Contract c;
  final Settings s;
  final VariableResolver resolver;

  pw.ThemeData get theme =>
      pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold).copyWith(
        defaultTextStyle: pw.TextStyle(
          font: fonts.regular,
          fontBold: fonts.bold,
          fontSize: 10.5,
          color: _ink,
          lineSpacing: 3,
        ),
      );

  pw.PageTheme get pageTheme => pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.fromLTRB(52, 44, 52, 30),
    textDirection: pw.TextDirection.rtl,
    theme: theme,
    buildBackground: c.status == ContractStatus.draft ? _draftMark : null,
  );

  pw.Widget _draftMark(pw.Context context) => pw.FullPage(
    ignoreMargins: true,
    child: pw.Center(
      child: pw.Transform.rotateBox(
        angle: 0.6,
        child: pw.Text(
          'مسودة',
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: 120,
            color: _watermark,
          ),
        ),
      ),
    ),
  );

  pw.TextStyle st({
    double size = 10.5,
    pw.Font? font,
    PdfColor color = _ink,
    double? wordSpacing,
  }) => pw.TextStyle(
    font: font ?? fonts.regular,
    fontSize: size,
    color: color,
    wordSpacing: wordSpacing,
  );

  /// `15 فبراير 2027` as two runs in an RTL row: the PDF's bidi pass drops
  /// the space before a trailing number when it is one string.
  pw.Widget date(CalendarDate d, pw.TextStyle style) => pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      t(formatArabicDayMonth(d), style: style),
      pw.SizedBox(width: (style.fontSize ?? 10) * 0.3),
      t('${d.year}', style: style),
    ],
  );

  pw.Font get semi => fonts.semiBold;
  pw.Font get bold => fonts.bold;

  /// Plain text: Arabic (or mixed) runs RTL, pure Latin runs LTR.
  pw.Widget t(String text, {pw.TextStyle? style, pw.TextAlign? align}) =>
      pw.Text(
        text,
        style: style,
        textAlign: align,
        textDirection: _latinOnly.hasMatch(text)
            ? pw.TextDirection.ltr
            : pw.TextDirection.rtl,
      );

  /// Text with `{{variables}}` resolved; unresolved ones highlighted amber.
  pw.Widget rich(
    String text, {
    pw.TextStyle? style,
    pw.TextAlign align = pw.TextAlign.justify,
  }) {
    final base = style ?? st();
    return pw.RichText(
      textDirection: pw.TextDirection.rtl,
      textAlign: align,
      overflow: pw.TextOverflow.span,
      text: pw.TextSpan(
        style: base,
        children: [
          for (final seg in resolver.segments(text))
            pw.TextSpan(
              text: seg.text,
              style: seg.missing
                  ? base.copyWith(
                      color: _amberFg,
                      background: const pw.BoxDecoration(color: _amberBg),
                    )
                  : null,
            ),
        ],
      ),
    );
  }

  // ── Cover ────────────────────────────────────────────────────────────
  // ── Body ─────────────────────────────────────────────────────────────
  // ── Annexes ──────────────────────────────────────────────────────────
  // ── Signatures and footer ────────────────────────────────────────────
}

/// Money in the PDF's annex columns (Western digits, as on invoices).
String contractAmount(Money m) => formatMoney(m.minor, m.currency);
