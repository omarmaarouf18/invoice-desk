part of '../contract_pdf.dart';

extension _Footer on _Builder {
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
