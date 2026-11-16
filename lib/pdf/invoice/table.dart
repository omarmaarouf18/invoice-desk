part of '../invoice_pdf.dart';

extension _Table on _Builder {
  pw.Widget pill(BillingCycle c) {
    final (label, fg, bg) = switch (c) {
      BillingCycle.oneTime => (labelEn.oneTime, style.muted, style.neutralSoft),
      BillingCycle.monthly => (labelEn.monthly, style.info, style.infoSoft),
      BillingCycle.annual => (labelEn.annual, style.primary, style.primarySoft),
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
      style: st(size: 7.5, font: bold, color: style.muted, spacing: 0.6),
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
                  style: st(size: 11, font: bold, color: style.primary),
                ),
                if (title.isNotEmpty) t(title, style: st(size: 11, font: bold)),
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
            labelEn.amountsIn(sec.currency),
            style: st(size: 8, color: style.muted),
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
        border: pw.TableBorder(
          horizontalInside: pw.BorderSide(color: style.border, width: 0.6),
          bottom: pw.BorderSide(color: style.border, width: 0.6),
        ),
        children: [
          pw.TableRow(
            repeat: true,
            decoration: pw.BoxDecoration(color: style.surface),
            children: [
              headCell(labelEn.service),
              headCell(labelEn.description),
              headCell(labelEn.billing),
              headCell(labelEn.qty, right: true),
              headCell(labelEn.amount, right: true),
            ],
          ),
          for (final it in rows)
            pw.TableRow(
              children: [
                cell(t(it.service, style: st(font: semi))),
                cell(t(it.description, style: st(color: style.muted))),
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
                          style: st(size: 7.5, color: style.muted),
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
            t(labelEn.subtotal, style: st(color: style.muted)),
            pw.SizedBox(width: 16),
            t(sec.subtotal.format(), style: st(size: 10.5, font: bold)),
          ],
        ),
      ),
    ];
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
