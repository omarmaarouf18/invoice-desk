part of '../invoice_pdf.dart';

extension _ScopePage on _Builder {
  List<pw.Widget> scopePage() {
    final sc = inv.scope;
    pw.TextStyle ar({double size = 10, pw.Font? font, PdfColor? color}) =>
        st(size: size, font: font, color: color);
    pw.Widget heading(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: t(
        text,
        style: ar(size: 11, font: bold, color: style.primary),
        dir: pw.TextDirection.rtl,
      ),
    );
    pw.Widget listCard(String title, String lines) => pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: style.surface,
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
        pw.Container(height: 0.8, color: style.ink),
        pw.SizedBox(height: 4),
        t(
          label,
          style: ar(size: 9, color: style.muted),
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
              labelAr.scopeTitle,
              style: ar(size: 22, font: bold),
              dir: pw.TextDirection.rtl,
            ),
          ),
          t(
            inv.number,
            style: ar(color: style.muted),
            dir: pw.TextDirection.ltr,
          ),
        ],
      ),
      if (sc.title.trim().isNotEmpty) ...[
        pw.SizedBox(height: 4),
        t(
          sc.title.trim(),
          style: ar(size: 13, font: semi, color: style.primary),
        ),
      ],
      pw.SizedBox(height: 12),
      pw.Container(height: 2, color: style.ink),
      pw.SizedBox(height: 16),
      if (sc.overview.trim().isNotEmpty) ...[
        heading(labelAr.scopeOverview),
        t(sc.overview.trim(), style: ar(size: 9.5), dir: pw.TextDirection.rtl),
        pw.SizedBox(height: 16),
      ],
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(child: listCard(labelAr.scopeDone, sc.done)),
          pw.SizedBox(width: 12),
          pw.Expanded(child: listCard(labelAr.scopeDelivered, sc.delivered)),
        ],
      ),
      if (sc.warranty.trim().isNotEmpty) ...[
        pw.SizedBox(height: 16),
        heading(labelAr.scopeWarranty),
        t(sc.warranty.trim(), style: ar(size: 9.5), dir: pw.TextDirection.rtl),
      ],
      pw.SizedBox(height: 32),
      pw.Row(
        children: [
          pw.Expanded(child: signature(labelAr.providerSignature(s.name))),
          pw.SizedBox(width: 40),
          pw.Expanded(
            child: signature(labelAr.clientSignature(data.client?.name ?? '')),
          ),
        ],
      ),
    ];
  }
}
