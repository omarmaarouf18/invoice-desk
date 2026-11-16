part of '../invoice_pdf.dart';

extension _Totals on _Builder {
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
                  'Due by ${formatInvoiceDate(inv.effectiveDueDate)}',
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
    final d = inv.effectiveDueDate;
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
}
