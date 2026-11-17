part of '../invoice_pdf.dart';

extension _ScopePage on _Builder {
  /// The scope page follows the document: an Arabic one for an Arabic
  /// invoice, an English one for an English invoice. A bilingual invoice
  /// keeps the Arabic page it has always had, so the invoices that exist
  /// do not change.
  List<pw.Widget> scopePage() {
    final sc = inv.scope;
    final rtl = scopeDir == pw.TextDirection.rtl;
    final labels = rtl ? labelAr : label;
    pw.TextStyle doc({double size = 10, pw.Font? font, PdfColor? color}) =>
        st(size: size, font: font, color: color);
    pw.Widget heading(String text) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: t(
        text,
        style: doc(size: 11, font: bold, color: style.primary),
        dir: scopeDir,
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
          bullets(splitLines(lines), scopeDir),
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
          style: doc(size: 9, color: style.muted),
          dir: scopeDir,
        ),
      ],
    );

    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Expanded(
            child: t(
              labels.scopeTitle,
              style: doc(size: 22, font: bold),
              dir: scopeDir,
            ),
          ),
          t(
            inv.number,
            style: doc(color: style.muted),
            dir: pw.TextDirection.ltr,
          ),
        ],
      ),
      if (sc.title.trim().isNotEmpty) ...[
        pw.SizedBox(height: 4),
        t(
          sc.title.trim(),
          style: doc(size: 13, font: semi, color: style.primary),
        ),
      ],
      pw.SizedBox(height: 12),
      pw.Container(height: 2, color: style.ink),
      pw.SizedBox(height: 16),
      if (sc.overview.trim().isNotEmpty) ...[
        heading(labels.scopeOverview),
        t(
          sc.overview.trim(),
          style: doc(size: 9.5),
          dir: scopeDir,
        ),
        pw.SizedBox(height: 16),
      ],
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(child: listCard(labels.scopeDone, sc.done)),
          pw.SizedBox(width: 12),
          pw.Expanded(child: listCard(labels.scopeDelivered, sc.delivered)),
        ],
      ),
      if (sc.warranty.trim().isNotEmpty) ...[
        pw.SizedBox(height: 16),
        heading(labels.scopeWarranty),
        t(
          sc.warranty.trim(),
          style: doc(size: 9.5),
          dir: scopeDir,
        ),
      ],
      pw.SizedBox(height: 32),
      pw.Row(
        children: [
          pw.Expanded(child: signature(labels.providerSignature(s.name))),
          pw.SizedBox(width: 40),
          pw.Expanded(
            child: signature(labels.clientSignature(data.client?.name ?? '')),
          ),
        ],
      ),
    ];
  }
}
