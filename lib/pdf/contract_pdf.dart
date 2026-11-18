import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style_enums.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart' show PdfFonts;
import 'package:invoice_desk/pdf/labels.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';
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
    this.language = DocLanguage.ar,
  });

  final Contract contract;
  final Client? client;
  final Settings settings;

  /// The original, for an amendment.
  final Contract? parent;

  /// Document language (defaults to Arabic, until Phase 7 adds it to DB).
  final DocLanguage language;
}

/// The document heading: `عقد تطوير منصة`, `عرض سعر …`, `ملحق تعديل …`,
/// in [lang] (Arabic unless given).
String contractHeading(
  Contract c, {
  Contract? parent,
  DocLanguage lang = DocLanguage.ar,
}) {
  final l = DocLabels.of(lang);
  final title = c.title.trim();
  return switch (c.kind) {
    ContractKind.amendment =>
      '${l.amendmentOf(c.amendmentNo, parent?.number ?? c.number.replaceFirst(RegExp(r'-A\d+$'), ''))}'
          '${title.isEmpty ? '' : ': $title'}',
    ContractKind.quote => title.isEmpty ? l.quote : '${l.quote} $title',
    ContractKind.contract =>
      title.isEmpty ? l.contract : '${l.contract} $title',
  };
}

final _latinOnly = RegExp(r'^[\x00-\x7F\u2066-\u2069]*$');

/// Pure: contract data in, PDF bytes out. [style] is the resolved look;
/// [PdfStyle.classic] is the 0.4 look.
Future<Uint8List> buildContractPdf(
  ContractPdfData data,
  PdfFonts fonts, {
  PdfStyle style = PdfStyle.classic,
}) => buildContractDocument(data, fonts, style: style).save();

/// [onFooter] reports each page's footer (tests check every page has one).
pw.Document buildContractDocument(
  ContractPdfData data,
  PdfFonts fonts, {
  PdfStyle style = PdfStyle.classic,
  void Function(int page, int pages)? onFooter,
}) {
  final b = _Builder(data, fonts, style, onFooter: onFooter);
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
          if (style.showSignatureBoxes) ...[
            pw.SizedBox(height: 28),
            b.signatures(),
          ],
        ],
      ),
    );
}

class _Builder {
  _Builder(this.data, this.fonts, this.style, {this.onFooter})
    : c = data.contract,
      s = data.settings,
      resolver = VariableResolver(
        contract: data.contract,
        client: data.client,
        settings: data.settings,
      );

  final ContractPdfData data;
  final PdfFonts fonts;

  /// Colours and page geometry.
  final PdfStyle style;
  final void Function(int page, int pages)? onFooter;

  /// The contract's language (defaults to Arabic).
  DocLanguage get lang => data.language;

  /// Fixed labels in [lang].
  DocLabels get labels => DocLabels.of(lang);
  final Contract c;
  final Settings s;
  final VariableResolver resolver;

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
          fontSize: 10.5 * style.scale,
          color: style.ink,
          lineSpacing: 3,
        ),
      );

  pw.PageTheme get pageTheme => pw.PageTheme(
    pageFormat: style.paper,
    margin: style.contractMargin,
    textDirection: lang.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
    theme: theme,
    buildBackground: c.status == ContractStatus.draft ? _draftMark : null,
  );

  pw.Widget _draftMark(pw.Context context) => pw.FullPage(
    ignoreMargins: true,
    child: pw.Center(
      child: pw.Transform.rotateBox(
        angle: 0.6,
        child: pw.Text(
          labels.draft,
          textDirection: lang.isRtl
              ? pw.TextDirection.rtl
              : pw.TextDirection.ltr,
          style: pw.TextStyle(
            font: bold,
            fontFallback: fontFallback,
            fontSize: 120,
            color: style.watermark,
          ),
        ),
      ),
    ),
  );

  pw.TextStyle st({
    double size = 10.5,
    pw.Font? font,
    PdfColor? color,
    List<pw.Font>? fontFallback,
  }) => pw.TextStyle(
    font: font ?? fontRegular,
    fontBold: bold,
    fontFallback: fontFallback ?? this.fontFallback,
    fontSize: size * style.scale,
    color: color ?? style.ink,
  );

  /// `15 فبراير 2027` as two runs in an RTL row: the PDF's bidi pass drops
  /// the space before a trailing number when it is one string.
  pw.Widget date(CalendarDate d, pw.TextStyle style) =>
      s.dateFormat == DocDateFormat.numeric
      ? t(formatDocDateAs(d, lang, s.dateFormat), style: style)
      : lang.isRtl
      ? pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            t(formatArabicDayMonth(d), style: style),
            pw.SizedBox(width: (style.fontSize ?? 10) * 0.3),
            t('${d.year}', style: style),
          ],
        )
      : t(formatDocDate(d, lang), style: style);

  /// Plain text: Arabic (or mixed) runs RTL, pure Latin runs LTR.
  pw.Widget t(String text, {pw.TextStyle? style, pw.TextAlign? align}) =>
      pw.Text(
        text,
        style: style,
        textAlign: align,
        textDirection: _latinOnly.hasMatch(text)
            ? pw.TextDirection.ltr
            : (lang.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr),
      );

  /// Text with `{{variables}}` resolved; unresolved ones highlighted amber.
  pw.Widget rich(
    String text, {
    pw.TextStyle? style,
    pw.TextAlign? align,
  }) {
    final base = style ?? st();
    final defaultAlign = lang.isRtl ? pw.TextAlign.justify : pw.TextAlign.left;
    return pw.RichText(
      textDirection: lang.isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr,
      textAlign: align ?? defaultAlign,
      overflow: pw.TextOverflow.span,
      text: pw.TextSpan(
        style: base,
        children: [
          for (final seg in resolver.segments(text))
            pw.TextSpan(
              text: seg.text,
              style: seg.missing
                  ? base.copyWith(
                      color: this.style.onHighlight,
                      background: pw.BoxDecoration(
                        color: this.style.highlight,
                      ),
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

/// An annex amount in the settings' currency display (ADR-0014 freezes it
/// for signed contracts).
String contractMoney(int minor, Currency c, DocLanguage lang, Settings s) =>
    formatDocCurrency(minor, c, lang, s.currencyDisplay);
