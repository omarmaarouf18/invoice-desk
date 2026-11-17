part of '../invoice_pdf.dart';

extension _Footer on _Builder {
  pw.Widget footer(pw.Context context) {
    final customFooter = isArabic
        ? (style.footerTextAr.isNotEmpty
              ? style.footerTextAr
              : style.footerTextEn)
        : (style.footerTextEn.isNotEmpty
              ? style.footerTextEn
              : style.footerTextAr);
    final left = [
      s.name,
      s.website,
      if (customFooter.isNotEmpty) customFooter,
    ].where((e) => e.trim().isNotEmpty).join(' · ');
    return pw.Directionality(
      textDirection: dir,
      child: pw.Container(
        margin: const pw.EdgeInsets.only(top: 12),
        padding: const pw.EdgeInsets.only(top: 6),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            top: pw.BorderSide(color: style.border, width: 0.6),
          ),
        ),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: t(
                left,
                style: st(size: 7.5, color: style.muted),
                align: isArabic ? startAlign : null,
              ),
            ),
            if (style.showPageNumbers)
              t(
                '${inv.number}  ·  ${label.pageOf(docNumber('${context.pageNumber}'), docNumber('${context.pagesCount}'))}',
                style: st(size: 7.5, color: style.muted),
              )
            else
              t(
                inv.number,
                style: st(size: 7.5, color: style.muted),
              ),
          ],
        ),
      ),
    );
  }
}
