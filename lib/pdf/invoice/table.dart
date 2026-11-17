part of '../invoice_pdf.dart';

extension _Table on _Builder {
  pw.Widget pill(BillingCycle c) {
    final (text, fg, bg) = switch (c) {
      BillingCycle.oneTime => (label.oneTime, style.muted, style.neutralSoft),
      BillingCycle.monthly => (label.monthly, style.info, style.infoSoft),
      BillingCycle.annual => (label.annual, style.primary, style.primarySoft),
    };
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: t(
        text,
        style: st(size: 7.5, font: semi, color: fg),
      ),
    );
  }

  pw.Widget cell(pw.Widget child, {bool end = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4.5),
    child: end
        ? pw.Align(alignment: pw.AlignmentDirectional.topEnd, child: child)
        : child,
  );

  pw.Widget headCell(String text, {bool end = false}) => cell(
    t(
      text,
      style: st(size: 7.5, font: bold, color: style.muted, spacing: 0.6),
    ),
    end: end,
  );

  String amount(int minor, Currency c) =>
      docNumber(formatAmount(minor, c, forceDecimals: true));

  /// The title of a section: the language's own, with the other one as a
  /// small secondary title in a bilingual document.
  (String, String) _sectionTitle(InvoiceSection sec) {
    final en = sec.titleEn.trim();
    final ar = sec.titleAr.trim();
    if (isBilingual) return (en, ar);
    if (isArabic) return (ar.isEmpty ? en : ar, '');
    return (en.isEmpty ? ar : en, '');
  }

  /// The name of a section in the totals: the language's own title, or the
  /// currency when it has none.
  String _sectionName(InvoiceSection sec) {
    final title = _sectionTitle(sec).$1.trim();
    return title.isEmpty ? sec.currency.code : title;
  }

  List<pw.Widget> section(int n, InvoiceSection sec) {
    final rows = sec.items.where((i) => !i.isBlank).toList();
    final (title, titleAr) = _sectionTitle(sec);
    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: isArabic
                ? pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      t(
                        docNumber('$n'),
                        style: st(size: 11, font: bold, color: style.primary),
                      ),
                      t(
                        digits == DigitStyle.arabicIndic ? ' – ' : '  ·  ',
                        style: st(size: 11, color: style.muted),
                      ),
                      if (title.isNotEmpty)
                        t(title, style: st(size: 11, font: bold)),
                    ],
                  )
                : pw.Wrap(
                    crossAxisAlignment: pw.WrapCrossAlignment.end,
                    children: [
                      t(
                        '${docNumber('$n')}  ·  ',
                        style: st(size: 11, font: bold, color: style.primary),
                      ),
                      if (title.isNotEmpty)
                        t(title, style: st(size: 11, font: bold)),
                      if (title.isNotEmpty && titleAr.isNotEmpty)
                        t('  ·  ', style: st(size: 11, color: style.muted)),
                      if (titleAr.isNotEmpty)
                        t(
                          titleAr,
                          style: st(size: 10.5, font: semi, color: style.muted),
                        ),
                    ],
                  ),
          ),
          t(
            label.amountsIn(sec.currency),
            style: st(size: 8, color: style.muted),
          ),
        ],
      ),
      pw.SizedBox(height: 6),
      _itemsTable(rows, sec),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            t(label.subtotal, style: st(color: style.muted)),
            pw.SizedBox(width: 16),
            t(
              docNumber(sec.subtotal.format()),
              style: st(size: 10.5, font: bold),
            ),
          ],
        ),
      ),
    ];
  }

  /// The items table. The columns are read from the right in an Arabic
  /// page: the service comes first, the amount last.
  pw.Widget _itemsTable(List<LineItem> rows, InvoiceSection sec) {
    pw.Widget serviceCell(LineItem it) => cell(
      t(it.service, style: st(font: semi)),
    );
    pw.Widget descriptionCell(LineItem it) => cell(
      t(it.description, style: st(color: style.muted)),
    );
    pw.Widget billingCell(LineItem it) => cell(pill(it.cycle));
    pw.Widget qtyCell(LineItem it) => cell(
      t(docNumber('${it.qty}'), style: st()),
      end: true,
    );
    pw.Widget amountCell(LineItem it) => cell(
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          t(
            amount(it.lineMinor, sec.currency),
            style: st(font: semi),
          ),
          if (it.qty != 1)
            t(
              docNumber(
                '${it.qty} × ${amount(it.unitPriceMinor, sec.currency)}',
              ),
              style: st(size: 7.5, color: style.muted),
            ),
        ],
      ),
      end: true,
    );

    pw.Widget head(String text, {bool end = false}) => headCell(text, end: end);

    final headRow = pw.TableRow(
      repeat: true,
      decoration: pw.BoxDecoration(color: style.surface),
      children: isArabic
          ? [
              head(label.amount, end: true),
              head(label.qty, end: true),
              head(label.billing),
              head(label.description),
              head(label.service),
            ]
          : [
              head(label.service),
              head(label.description),
              head(label.billing),
              head(label.qty, end: true),
              head(label.amount, end: true),
            ],
    );

    final bodyRows = [
      for (final it in rows)
        pw.TableRow(
          children: isArabic
              ? [
                  amountCell(it),
                  qtyCell(it),
                  billingCell(it),
                  descriptionCell(it),
                  serviceCell(it),
                ]
              : [
                  serviceCell(it),
                  descriptionCell(it),
                  billingCell(it),
                  qtyCell(it),
                  amountCell(it),
                ],
        ),
    ];

    return pw.Table(
      columnWidths: isArabic
          ? const {
              0: pw.FixedColumnWidth(84),
              1: pw.FixedColumnWidth(34),
              2: pw.FixedColumnWidth(62),
              3: pw.FlexColumnWidth(3.6),
              4: pw.FlexColumnWidth(2.6),
            }
          : const {
              0: pw.FlexColumnWidth(2.6),
              1: pw.FlexColumnWidth(3.6),
              2: pw.FixedColumnWidth(62),
              3: pw.FixedColumnWidth(34),
              4: pw.FixedColumnWidth(84),
            },
      border: pw.TableBorder(
        horizontalInside: pw.BorderSide(color: style.border, width: 0.6),
        bottom: pw.BorderSide(color: style.border, width: 0.6),
      ),
      children: [headRow, ...bodyRows],
    );
  }

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
                    decoration: pw.BoxDecoration(
                      color: style.primary,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: t(
                    l,
                    style: st(size: 8, color: style.muted),
                    dir: dir,
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}
