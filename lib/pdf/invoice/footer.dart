part of '../invoice_pdf.dart';

extension _Footer on _Builder {
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
}
