part of '../invoice_pdf.dart';

extension _Totals on _Builder {
  pw.Widget bottom() {
    final totals = inv.totals;
    final en = splitLines(inv.notesEn);
    final ar = splitLines(inv.notesAr);
    final multi = inv.sections.length > 1;
    pw.Widget line(String k, String v, {PdfColor? color}) => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: t(k, style: st(color: style.muted)),
          ),
          pw.SizedBox(width: 8),
          t(
            v,
            style: st(font: semi, color: color),
            align: endAlign,
          ),
        ],
      ),
    );

    final totalsBox = pw.Container(
      width: 236,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: style.border, width: 0.8),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.SizedBox(height: 6),
          if (multi)
            for (final (i, sec) in inv.sections.indexed)
              line(
                '${docNumber('${i + 1}')} · ${_sectionName(sec)}',
                docNumber(sec.subtotal.format()),
              ),
          if (inv.vatOn)
            line(
              '${label.vat} (${docNumber(formatBpAsPercent(inv.vatRateBp))}%)',
              docNumber(totals.vat.format(separator: '\n')),
            )
          else
            line(label.vat, label.vatNotApplicable, color: style.muted),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: style.ink,
              borderRadius: const pw.BorderRadius.only(
                bottomLeft: pw.Radius.circular(7),
                bottomRight: pw.Radius.circular(7),
              ),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(child: _totalLabel()),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    for (final m in totals.total.nonZero)
                      t(
                        docNumber(m.format()),
                        style: st(size: 13, font: bold, color: style.onInk),
                      ),
                    if (totals.total.isEmpty)
                      t(
                        docNumber('0'),
                        style: st(size: 13, font: bold, color: style.onInk),
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
                    blockLabel(label.notes, labelAr.notes),
                    pw.SizedBox(height: 6),
                  ],
                  if (en.isNotEmpty && !isArabic)
                    bullets(en, pw.TextDirection.ltr),
                  if (en.isNotEmpty && ar.isNotEmpty && !isArabic)
                    pw.SizedBox(height: 6),
                  if (ar.isNotEmpty && !isEnglish)
                    bullets(ar, pw.TextDirection.rtl),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                totalsBox,
                pw.SizedBox(height: 6),
                if (!isArabic)
                  t(
                    label.dueBy(docDate(inv.effectiveDueDate)),
                    style: st(font: semi),
                  ),
                if (!isEnglish) arabicDueLine(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// The label of the total: the language's own, with the Arabic one as a
  /// small secondary label in a bilingual document.
  pw.Widget _totalLabel() {
    if (!isBilingual) {
      return t(
        label.totalDue,
        style: st(size: 10, font: bold, color: style.onInk),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        t(
          label.totalDue,
          style: st(size: 10, font: bold, color: style.onInk),
        ),
        t(labelAr.totalDue, style: st(size: 8, color: style.onInkMuted)),
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
      docNumber('${d.day}'),
      formatArabicDate(d).split(' ')[1],
      docNumber('${d.year}'),
    ];
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Wrap(
        spacing: 2.5,
        children: [
          for (final w in words) t(w, style: st(size: 8.5, color: style.muted)),
        ],
      ),
    );
  }
}
