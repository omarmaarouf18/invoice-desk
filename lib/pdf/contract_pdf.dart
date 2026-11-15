import 'dart:typed_data';

import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart' show PdfFonts;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
          // IBM Plex Sans Arabic's space is narrow without OpenType kerning;
          // this multiple of it reads like the app's spacing.
          wordSpacing: 2,
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

  String _digits(int n) => subItemLabel(n, western: s.contractWesternDigits);

  // ── Cover ────────────────────────────────────────────────────────────
  pw.Widget cover() {
    final provider = s.legalName.trim().isEmpty ? s.name : s.legalName;
    final cl = data.client;
    final clientName = cl == null
        ? ''
        : (cl.legalName.trim().isEmpty ? cl.name : cl.legalName);
    final rep = cl == null
        ? ''
        : [
            cl.representative.trim(),
            cl.representativeTitle.trim(),
          ].where((e) => e.isNotEmpty).join(' — ');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  rich(
                    contractHeading(c, parent: data.parent),
                    style: st(size: 20, font: bold),
                    align: pw.TextAlign.right,
                  ),
                  if (c.projectName.trim().isNotEmpty) ...[
                    pw.SizedBox(height: 2),
                    rich(
                      c.projectName,
                      style: st(size: 11.5, font: semi, color: _teal),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _tealBg,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  t(
                    c.number,
                    style: st(font: bold, color: _teal),
                  ),
                  date(c.issueDate, st(size: 9, color: _teal)),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Container(height: 2, color: _ink),
        pw.SizedBox(height: 14),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: party('الطرف الأول (مقدم الخدمة)', [
                (null, provider),
                ('رقم قومي / سجل تجاري', s.nationalIdOrRegistry),
                ('العنوان', s.address),
                ('البريد الإلكتروني', s.email),
                ('الهاتف', s.phone),
              ]),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: party('الطرف الثاني (العميل)', [
                (null, clientName),
                ('سجل تجاري / رقم قومي', cl?.registryNo ?? ''),
                ('العنوان', cl?.address ?? ''),
                ('يمثله', rep),
                ('البريد الإلكتروني', cl?.email ?? ''),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  /// A party card; empty lines are omitted.
  pw.Widget party(String label, List<(String?, String)> lines) => pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: _soft,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        t(
          label,
          style: st(size: 9, font: semi, color: _teal),
        ),
        pw.SizedBox(height: 6),
        for (final (k, v) in lines)
          if (v.trim().isNotEmpty)
            k == null
                ? t(v.trim(), style: st(size: 11.5, font: bold))
                : pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        t('$k: ', style: st(size: 9, color: _muted)),
                        pw.Expanded(child: t(v.trim(), style: st(size: 9.5))),
                      ],
                    ),
                  ),
      ],
    ),
  );

  // ── Body ─────────────────────────────────────────────────────────────
  pw.Widget heading(String text, {double top = 14}) => pw.Padding(
    padding: pw.EdgeInsets.only(top: top, bottom: 6),
    child: rich(
      text,
      style: st(size: 12, font: bold, color: _teal),
      align: pw.TextAlign.right,
    ),
  );

  List<pw.Widget> body(String text) => [
    for (final block in parseBody(text))
      switch (block) {
        ParagraphBlock(:final text) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: rich(text),
        ),
        SubItemsBlock(:final items) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              for (final (i, item) in items.indexed)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 22,
                        child: t(
                          _digits(i + 1),
                          style: st(font: semi, color: _teal),
                        ),
                      ),
                      pw.Expanded(child: rich(item)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      },
  ];

  List<pw.Widget> preamble() => c.preamble.trim().isEmpty
      ? const []
      : [heading('تمهيد', top: 0), ...body(c.preamble)];

  List<pw.Widget> clauses() {
    final enabled = c.clauses.where((x) => x.enabled).toList();
    return [
      for (final (i, cl) in enabled.indexed) ...[
        heading(
          cl.title.trim().isEmpty
              ? 'البند ${arabicOrdinal(i + 1)}'
              : 'البند ${arabicOrdinal(i + 1)}: ${cl.title.trim()}',
        ),
        ...body(cl.body),
      ],
    ];
  }

  List<pw.Widget> closing() => c.closing.trim().isEmpty
      ? const []
      : [
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(right: pw.BorderSide(color: _teal, width: 2)),
            ),
            child: rich(c.closing, style: st(font: semi)),
          ),
        ];

  // ── Annexes ──────────────────────────────────────────────────────────
  pw.Widget annexTitle(String text, String sub) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      t(text, style: st(size: 16, font: bold)),
      t(sub, style: st(size: 9, color: _muted)),
      pw.SizedBox(height: 8),
      pw.Container(height: 2, color: _ink),
      pw.SizedBox(height: 12),
    ],
  );

  pw.Widget cell(pw.Widget child, {bool end = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    child: end
        ? pw.Align(alignment: pw.Alignment.centerLeft, child: child)
        : child,
  );

  pw.Widget headCell(String text, {bool end = false}) => cell(
    t(
      text,
      style: st(size: 8.5, font: bold, color: _muted),
    ),
    end: end,
  );

  pw.Table table({
    required Map<int, pw.TableColumnWidth> widths,
    required List<pw.Widget> head,
    required List<List<pw.Widget>> rows,
  }) => pw.Table(
    columnWidths: widths,
    border: const pw.TableBorder(
      horizontalInside: pw.BorderSide(color: _border, width: 0.6),
      bottom: pw.BorderSide(color: _border, width: 0.6),
    ),
    children: [
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(color: _soft),
        children: head,
      ),
      for (final r in rows) pw.TableRow(children: r),
    ],
  );

  List<pw.Widget> scopeAnnex() {
    final rows = c.scope.where((x) => !x.isBlank).toList();
    final out = splitLines(c.outOfScope);
    pw.Widget txt(String v, {PdfColor color = _ink, pw.Font? font}) => rich(
      v,
      style: st(size: 9.5, color: color, font: font),
      align: pw.TextAlign.right,
    );
    return [
      annexTitle('ملحق (1) نطاق العمل', 'جزء لا يتجزأ من ${c.number}'),
      if (rows.isEmpty)
        t('لم تُحدد بنود النطاق بعد.', style: st(color: _muted))
      else
        table(
          widths: const {
            0: pw.FixedColumnWidth(26),
            1: pw.FlexColumnWidth(1.3),
            2: pw.FlexColumnWidth(1.8),
            3: pw.FlexColumnWidth(3),
            4: pw.FlexColumnWidth(2.4),
          },
          head: [
            headCell('#'),
            headCell('المرحلة'),
            headCell('البند'),
            headCell('الوصف'),
            headCell('معيار القبول'),
          ],
          rows: [
            for (final (i, r) in rows.indexed)
              [
                cell(t('${i + 1}', style: st(size: 9, color: _muted))),
                cell(txt(r.phase, color: _teal, font: semi)),
                cell(txt(r.item, font: semi)),
                cell(txt(r.description, color: _muted)),
                cell(txt(r.acceptance)),
              ],
          ],
        ),
      if (out.isNotEmpty) ...[
        heading('خارج النطاق', top: 18),
        for (final line in out)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 4,
                  height: 4,
                  margin: const pw.EdgeInsets.only(top: 7, left: 8),
                  decoration: const pw.BoxDecoration(
                    color: _muted,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(child: rich(line, style: st(size: 10))),
              ],
            ),
          ),
      ],
    ];
  }

  List<pw.Widget> paymentAnnex() {
    final check = checkMilestones(c);
    String pct(PaymentMilestone m, int amount) {
      if (m.percentBp != null && m.amountMinor == null) {
        return '${formatBpAsPercent(m.percentBp!)}%';
      }
      if (c.totalMinor == 0) return '—';
      final bp = (amount * 10000 / c.totalMinor).round();
      return '${formatBpAsPercent(bp)}%';
    }

    return [
      annexTitle('ملحق (2) المقابل والدفعات', 'جزء لا يتجزأ من ${c.number}'),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: pw.BoxDecoration(
          color: _tealBg,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: t(
                'إجمالي المقابل',
                style: st(size: 11, font: semi, color: _teal),
              ),
            ),
            t(
              formatContractMoney(c.totalMinor, c.currency),
              style: st(size: 14, font: bold, color: _teal),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 14),
      if (c.milestones.isNotEmpty)
        table(
          widths: const {
            0: pw.FixedColumnWidth(26),
            1: pw.FlexColumnWidth(2.2),
            2: pw.FixedColumnWidth(48),
            3: pw.FixedColumnWidth(92),
            4: pw.FlexColumnWidth(2.4),
            5: pw.FixedColumnWidth(70),
          },
          head: [
            headCell('#'),
            headCell('الدفعة'),
            headCell('النسبة'),
            headCell('المبلغ', end: true),
            headCell('الاستحقاق'),
            headCell('التاريخ'),
          ],
          rows: [
            for (final (i, m) in c.milestones.indexed)
              [
                cell(t('${i + 1}', style: st(size: 9, color: _muted))),
                cell(
                  rich(
                    m.label,
                    style: st(size: 9.5, font: semi),
                    align: pw.TextAlign.right,
                  ),
                ),
                cell(t(pct(m, check.amounts[i]), style: st(size: 9.5))),
                cell(
                  t(
                    formatMoney(check.amounts[i], c.currency),
                    style: st(size: 9.5, font: semi),
                  ),
                  end: true,
                ),
                cell(
                  rich(
                    m.trigger,
                    style: st(size: 9.5, color: _muted),
                    align: pw.TextAlign.right,
                  ),
                ),
                cell(
                  m.dueDate == null
                      ? t('—', style: st(size: 9))
                      : date(m.dueDate!, st(size: 9)),
                ),
              ],
            [
              cell(t('')),
              cell(t('الإجمالي', style: st(size: 9.5, font: bold))),
              cell(t('')),
              cell(
                t(
                  formatMoney(check.sum, c.currency),
                  style: st(size: 9.5, font: bold),
                ),
                end: true,
              ),
              cell(t('')),
              cell(t('')),
            ],
          ],
        ),
    ];
  }

  // ── Signatures and footer ────────────────────────────────────────────
  pw.Widget signatures() {
    final cl = data.client;
    pw.Widget column(String side, String name, String title) => pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: _border, width: 0.8),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            t(
              side,
              style: st(size: 10, font: bold, color: _teal),
            ),
            pw.SizedBox(height: 8),
            line('الاسم', name),
            line('الصفة', title),
            line('التوقيع', ''),
            line('التاريخ', ''),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                t('الختم', style: st(size: 9, color: _muted)),
                pw.SizedBox(width: 8),
                pw.Container(
                  width: 70,
                  height: 46,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _border, width: 0.8),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        t('التوقيعات', style: st(size: 12, font: bold)),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            column(
              'الطرف الأول',
              s.legalName.trim().isEmpty ? s.name : s.legalName,
              s.role,
            ),
            pw.SizedBox(width: 14),
            column(
              'الطرف الثاني',
              (cl?.representative.trim().isNotEmpty ?? false)
                  ? cl!.representative
                  : (cl?.legalName.trim().isNotEmpty ?? false)
                  ? cl!.legalName
                  : cl?.name ?? '',
              cl?.representativeTitle ?? '',
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget line(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.SizedBox(
          width: 46,
          child: t(label, style: st(size: 9, color: _muted)),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 2),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: _border, width: 0.8),
              ),
            ),
            child: t(
              value.trim().isEmpty ? ' ' : value.trim(),
              style: st(size: 10, font: semi),
            ),
          ),
        ),
      ],
    ),
  );

  pw.Widget footer(pw.Context context) {
    onFooter?.call(context.pageNumber, context.pagesCount);
    pw.Widget initials(String label) => pw.Column(
      children: [
        pw.Container(
          width: 52,
          height: 22,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: _border, width: 0.8),
            borderRadius: pw.BorderRadius.circular(3),
          ),
        ),
        pw.SizedBox(height: 2),
        t(label, style: st(size: 6.5, color: _muted)),
      ],
    );
    final page = s.contractWesternDigits
        ? '${context.pageNumber}'
        : arabicIndicDigits('${context.pageNumber}');
    final pages = s.contractWesternDigits
        ? '${context.pagesCount}'
        : arabicIndicDigits('${context.pagesCount}');
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 12),
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _border, width: 0.6)),
      ),
      child: pw.Row(
        children: [
          initials('توقيع الطرف الأول'),
          pw.SizedBox(width: 6),
          initials('توقيع الطرف الثاني'),
          pw.Spacer(),
          t('صفحة $page من $pages', style: st(size: 8, color: _muted)),
          pw.SizedBox(width: 12),
          t(
            c.number,
            style: st(size: 8, font: semi, color: _muted),
          ),
        ],
      ),
    );
  }
}

/// Money in the PDF's annex columns (Western digits, as on invoices).
String contractAmount(Money m) => formatMoney(m.minor, m.currency);
