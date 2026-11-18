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
            child: t(
              k,
              style: st(color: style.muted),
              align: isArabic ? startAlign : null,
            ),
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

    final isPlainTotals = style.totalsStyle == TotalsStyle.plain;
    final totalsBox = pw.Container(
      width: 236,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: style.border,
          width: isPlainTotals ? 0.6 : 0.8,
        ),
        borderRadius: pw.BorderRadius.circular(isPlainTotals ? 6 : 8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.SizedBox(height: 6),
          if (multi)
            for (final (i, sec) in inv.sections.indexed)
              line(
                isArabic && digits == DigitStyle.arabicIndic
                    ? '${docNumber('${i + 1}')} – ${_sectionName(sec)}'
                    : '${docNumber('${i + 1}')} · ${_sectionName(sec)}',
                money(sec.subtotal),
              ),
          if (inv.vatOn)
            line(
              '${label.vat} (${docNumber(formatBpAsPercent(inv.vatRateBp))}%)',
              moneyBag(totals.vat, separator: '\n'),
            )
          else if (style.showVatRow)
            line(label.vat, label.vatNotApplicable, color: style.muted),
          pw.SizedBox(height: 6),
          if (isPlainTotals) pw.Container(height: 0.6, color: style.border),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: pw.BoxDecoration(
              color: isPlainTotals
                  ? null
                  : style.totalsStyle == TotalsStyle.solid
                  ? style.primary
                  : style.ink,
              borderRadius: isPlainTotals
                  ? null
                  : const pw.BorderRadius.only(
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
                        money(m),
                        style: st(
                          size: 13,
                          font: bold,
                          color: isPlainTotals ? style.ink : style.onInk,
                        ),
                      ),
                    if (totals.total.isEmpty)
                      t(
                        docNumber('0'),
                        style: st(
                          size: 13,
                          font: bold,
                          color: isPlainTotals ? style.ink : style.onInk,
                        ),
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
                  if (style.showNotes &&
                      style.blockOrder.contains(DocBlock.notes)) ...[
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
    final isPlainTotals = style.totalsStyle == TotalsStyle.plain;
    final fg = isPlainTotals ? style.ink : style.onInk;
    final fgMuted = isPlainTotals ? style.muted : style.onInkMuted;
    if (!isBilingual) {
      return t(
        label.totalDue,
        style: st(size: 10, font: bold, color: fg),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        t(
          label.totalDue,
          style: st(size: 10, font: bold, color: fg),
        ),
        t(labelAr.totalDue, style: st(size: 8, color: fgMuted)),
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
      if (s.dateFormat == DocDateFormat.numeric)
        // One LTR run: `14/10/2026` (digits per the document).
        formatDocDateAs(d, DocLanguage.ar, s.dateFormat, digits: digits)
      else ...[
        docNumber('${d.day}'),
        formatArabicDate(d).split(' ')[1],
        docNumber('${d.year}'),
      ],
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
