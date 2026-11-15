import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
          // IBM Plex Sans Arabic's space is narrow without OpenType kerning;
          // without this, Arabic words run together.
          wordSpacing: 2,
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
  pw.Widget header() {
    final contacts = [
      s.email,
      s.phone,
      s.website,
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final meta = <(String, String)>[
      ('Invoice No.', inv.number),
      ('Issue date', formatInvoiceDate(inv.issueDate)),
      ('Due date', formatInvoiceDate(inv.dueDate)),
      if (inv.contractRef.trim().isNotEmpty)
        ('Contract ref.', inv.contractRef.trim()),
    ];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              t(s.name, style: st(size: 26, font: bold)),
              if (s.role.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                t(
                  s.role,
                  style: st(size: 11, font: semi, color: _teal),
                ),
              ],
              pw.SizedBox(height: 6),
              if (s.city.isNotEmpty) t(s.city, style: st(color: _muted)),
              if (contacts.isNotEmpty) t(contacts, style: st(color: _muted)),
            ],
          ),
        ),
        pw.SizedBox(width: 24),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                t('INVOICE', style: st(size: 22, font: bold, spacing: 2)),
                pw.SizedBox(width: 8),
                t(
                  'فاتورة',
                  style: st(size: 15, font: semi, color: _muted),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              tableWidth: pw.TableWidth.min,
              children: [
                for (final (k, v) in meta)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 14, bottom: 2),
                        child: t(k, style: st(color: _muted)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: t(
                          v,
                          style: st(font: semi),
                          align: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (inv.status == InvoiceStatus.paid) ...[
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(
                  color: _greenBg,
                  border: pw.Border.all(color: _green, width: 1.2),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: t(
                  'PAID · ${formatInvoiceDate(inv.paidDate ?? inv.issueDate)}',
                  style: st(size: 10, font: bold, color: _green, spacing: 1),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ── Billed to / payment details ───────────────────────────────────────
  pw.Widget card(pw.Widget label, List<pw.Widget> lines) => pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _soft,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [label, pw.SizedBox(height: 6), ...lines],
    ),
  );

  pw.Widget parties() {
    final c = data.client;
    final contactLine = [
      c?.phone ?? '',
      c?.email ?? '',
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final pay = <(String, String)>[
      if (s.instapay.trim().isNotEmpty) ('InstaPay', s.instapay.trim()),
      if (s.wallet.trim().isNotEmpty) ('Wallet', s.wallet.trim()),
      if (s.bankIban.trim().isNotEmpty) ('Bank / IBAN', s.bankIban.trim()),
    ];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: card(bilingualLabel('BILLED TO', 'العميل'), [
            t(c?.name ?? '—', style: st(size: 12, font: bold)),
            if ((c?.contact ?? '').trim().isNotEmpty)
              t('Attn: ${c!.contact.trim()}', style: st()),
            if ((c?.city ?? '').trim().isNotEmpty)
              t(c!.city.trim(), style: st(color: _muted)),
            if (contactLine.isNotEmpty)
              t(contactLine, style: st(color: _muted)),
          ]),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: card(bilingualLabel('PAYMENT DETAILS', 'بيانات الدفع'), [
            for (final (k, v) in pay)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 64,
                    child: t(k, style: st(color: _muted)),
                  ),
                  pw.Expanded(
                    child: t(
                      v,
                      style: st(font: semi),
                      dir: pw.TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            if (pay.isNotEmpty) pw.SizedBox(height: 4),
            t(
              'Please quote ${inv.number}',
              style: st(size: 8.5, color: _muted),
            ),
          ]),
        ),
      ],
    );
  }

  // ── Sections ──────────────────────────────────────────────────────────
  pw.Widget pill(BillingCycle c) {
    final (label, fg, bg) = switch (c) {
      BillingCycle.oneTime => ('One-time', _muted, _greyBg),
      BillingCycle.monthly => ('Monthly', _blue, _blueBg),
      BillingCycle.annual => ('Annual', _teal, _tealBg),
    };
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: t(
        label,
        style: st(size: 7.5, font: semi, color: fg),
      ),
    );
  }

  pw.Widget cell(pw.Widget child, {bool right = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
    child: right
        ? pw.Align(alignment: pw.Alignment.topRight, child: child)
        : child,
  );

  pw.Widget headCell(String text, {bool right = false}) => cell(
    t(
      text,
      style: st(size: 7.5, font: bold, color: _muted, spacing: 0.6),
    ),
    right: right,
  );

  String amount(int minor, Currency c) =>
      formatAmount(minor, c, forceDecimals: true);

  List<pw.Widget> section(int n, InvoiceSection sec) {
    final rows = sec.items.where((i) => !i.isBlank).toList();
    final title = sec.titleEn.trim();
    final titleAr = sec.titleAr.trim();
    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: pw.Wrap(
              crossAxisAlignment: pw.WrapCrossAlignment.end,
              children: [
                t(
                  '$n  ·  ',
                  style: st(size: 11, font: bold, color: _teal),
                ),
                if (title.isNotEmpty) t(title, style: st(size: 11, font: bold)),
                if (title.isNotEmpty && titleAr.isNotEmpty)
                  t('  ·  ', style: st(size: 11, color: _muted)),
                if (titleAr.isNotEmpty)
                  t(
                    titleAr,
                    style: st(size: 10.5, font: semi, color: _muted),
                  ),
              ],
            ),
          ),
          t(
            'Amounts in ${sec.currency.code}',
            style: st(size: 8, color: _muted),
          ),
        ],
      ),
      pw.SizedBox(height: 6),
      pw.Table(
        columnWidths: const {
          0: pw.FlexColumnWidth(2.6),
          1: pw.FlexColumnWidth(3.6),
          2: pw.FixedColumnWidth(62),
          3: pw.FixedColumnWidth(34),
          4: pw.FixedColumnWidth(84),
        },
        border: const pw.TableBorder(
          horizontalInside: pw.BorderSide(color: _border, width: 0.6),
          bottom: pw.BorderSide(color: _border, width: 0.6),
        ),
        children: [
          pw.TableRow(
            repeat: true,
            decoration: const pw.BoxDecoration(color: _soft),
            children: [
              headCell('SERVICE'),
              headCell('DESCRIPTION'),
              headCell('BILLING'),
              headCell('QTY', right: true),
              headCell('AMOUNT', right: true),
            ],
          ),
          for (final it in rows)
            pw.TableRow(
              children: [
                cell(t(it.service, style: st(font: semi))),
                cell(t(it.description, style: st(color: _muted))),
                cell(pill(it.cycle)),
                cell(t('${it.qty}', style: st()), right: true),
                cell(
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      t(
                        amount(it.lineMinor, sec.currency),
                        style: st(font: semi),
                      ),
                      if (it.qty != 1)
                        t(
                          '${it.qty} × ${amount(it.unitPriceMinor, sec.currency)}',
                          style: st(size: 7.5, color: _muted),
                        ),
                    ],
                  ),
                  right: true,
                ),
              ],
            ),
        ],
      ),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            t('Subtotal', style: st(color: _muted)),
            pw.SizedBox(width: 16),
            t(sec.subtotal.format(), style: st(size: 10.5, font: bold)),
          ],
        ),
      ),
    ];
  }

  // ── Notes + totals ────────────────────────────────────────────────────
  pw.Widget bullets(List<String> lines, pw.TextDirection dir) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      for (final l in lines)
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 1.5),
          child: pw.Directionality(
            textDirection: dir,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsetsDirectional.only(top: 4, end: 6),
                  child: pw.Container(
                    width: 3,
                    height: 3,
                    decoration: const pw.BoxDecoration(
                      color: _teal,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: t(
                    l,
                    style: st(size: 8, color: _muted),
                    dir: dir,
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );

  pw.Widget bottom() {
    final totals = inv.totals;
    final en = splitLines(inv.notesEn);
    final ar = splitLines(inv.notesAr);
    final multi = inv.sections.length > 1;
    pw.Widget line(String k, String v, {PdfColor color = _ink}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: t(k, style: st(color: _muted)),
          ),
          pw.SizedBox(width: 8),
          t(
            v,
            style: st(font: semi, color: color),
            align: pw.TextAlign.right,
          ),
        ],
      ),
    );

    final totalsBox = pw.Container(
      width: 236,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.8),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.SizedBox(height: 6),
          if (multi)
            for (final (i, sec) in inv.sections.indexed)
              line(
                '${i + 1} · ${sec.titleEn.trim().isEmpty ? sec.currency.code : sec.titleEn.trim()}',
                sec.subtotal.format(),
              ),
          if (inv.vatOn)
            line(
              'VAT (${formatBpAsPercent(inv.vatRateBp)}%)',
              totals.vat.format(separator: '\n'),
            )
          else
            line('VAT', 'Not applicable', color: _muted),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: const pw.BoxDecoration(
              color: _ink,
              borderRadius: pw.BorderRadius.only(
                bottomLeft: pw.Radius.circular(7),
                bottomRight: pw.Radius.circular(7),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      t(
                        'Total due',
                        style: st(size: 10, font: bold, color: PdfColors.white),
                      ),
                      t(
                        'الإجمالي المستحق',
                        style: st(
                          size: 8,
                          color: const PdfColor.fromInt(0xFFB8C2CF),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    for (final m in totals.total.nonZero)
                      t(
                        m.format(),
                        style: st(size: 13, font: bold, color: PdfColors.white),
                      ),
                    if (totals.total.isEmpty)
                      t(
                        '0',
                        style: st(size: 13, font: bold, color: PdfColors.white),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  if (en.isNotEmpty || ar.isNotEmpty) ...[
                    bilingualLabel('NOTES', 'ملاحظات'),
                    pw.SizedBox(height: 6),
                  ],
                  if (en.isNotEmpty) bullets(en, pw.TextDirection.ltr),
                  if (en.isNotEmpty && ar.isNotEmpty) pw.SizedBox(height: 6),
                  if (ar.isNotEmpty) bullets(ar, pw.TextDirection.rtl),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                totalsBox,
                pw.SizedBox(height: 6),
                t(
                  'Due by ${formatInvoiceDate(inv.dueDate)}',
                  style: st(font: semi),
                ),
                arabicDueLine(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// `مستحقة السداد في 14 أكتوبر 2026`, laid out word by word so the
  /// trailing Western-digit year keeps its spacing in RTL.
  pw.Widget arabicDueLine() {
    final d = inv.dueDate;
    final words = [
      'مستحقة',
      'السداد',
      'في',
      '${d.day}',
      formatArabicDate(d).split(' ')[1],
      '${d.year}',
    ];
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Wrap(
        spacing: 2.5,
        children: [
          for (final w in words) t(w, style: st(size: 8.5, color: _muted)),
        ],
      ),
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────
  pw.Widget footer(pw.Context context) {
    final left = [
      s.name,
      s.website,
    ].where((e) => e.trim().isNotEmpty).join(' · ');
    return pw.Directionality(
      textDirection: pw.TextDirection.ltr,
      child: pw.Container(
        margin: const pw.EdgeInsets.only(top: 12),
        padding: const pw.EdgeInsets.only(top: 6),
        decoration: const pw.BoxDecoration(
          border: pw.Border(top: pw.BorderSide(color: _border, width: 0.6)),
        ),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: t(left, style: st(size: 7.5, color: _muted)),
            ),
            t(
              '${inv.number}  ·  Page ${context.pageNumber} of ${context.pagesCount}',
              style: st(size: 7.5, color: _muted),
            ),
          ],
        ),
      ),
    );
  }

  // ── Scope page (RTL) ──────────────────────────────────────────────────
  List<pw.Widget> scopePage() {
    final sc = inv.scope;
    pw.TextStyle ar({double size = 10, pw.Font? font, PdfColor color = _ink}) =>
        st(size: size, font: font, color: color);
    pw.Widget heading(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: t(
        text,
        style: ar(size: 11, font: bold, color: _teal),
        dir: pw.TextDirection.rtl,
      ),
    );
    pw.Widget listCard(String title, String lines) => pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _soft,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          heading(title),
          bullets(splitLines(lines), pw.TextDirection.rtl),
        ],
      ),
    );
    pw.Widget signature(String label) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 36),
        pw.Container(height: 0.8, color: _ink),
        pw.SizedBox(height: 4),
        t(
          label,
          style: ar(size: 9, color: _muted),
          dir: pw.TextDirection.rtl,
        ),
      ],
    );

    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: t(
              'نطاق المشروع',
              style: ar(size: 22, font: bold),
              dir: pw.TextDirection.rtl,
            ),
          ),
          t(
            inv.number,
            style: ar(color: _muted),
            dir: pw.TextDirection.ltr,
          ),
        ],
      ),
      if (sc.title.trim().isNotEmpty) ...[
        pw.SizedBox(height: 4),
        t(
          sc.title.trim(),
          style: ar(size: 13, font: semi, color: _teal),
        ),
      ],
      pw.SizedBox(height: 12),
      pw.Container(height: 2, color: _ink),
      pw.SizedBox(height: 16),
      if (sc.overview.trim().isNotEmpty) ...[
        heading('نظرة عامة'),
        t(sc.overview.trim(), style: ar(size: 9.5), dir: pw.TextDirection.rtl),
        pw.SizedBox(height: 16),
      ],
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(child: listCard('ما تم تنفيذه', sc.done)),
          pw.SizedBox(width: 12),
          pw.Expanded(child: listCard('ما يستلمه العميل', sc.delivered)),
        ],
      ),
      if (sc.warranty.trim().isNotEmpty) ...[
        pw.SizedBox(height: 16),
        heading('الضمان والدعم'),
        t(sc.warranty.trim(), style: ar(size: 9.5), dir: pw.TextDirection.rtl),
      ],
      pw.SizedBox(height: 32),
      pw.Row(
        children: [
          pw.Expanded(child: signature('توقيع مقدم الخدمة — ${s.name}')),
          pw.SizedBox(width: 40),
          pw.Expanded(
            child: signature('توقيع العميل — ${data.client?.name ?? ''}'),
          ),
        ],
      ),
    ];
  }
}
