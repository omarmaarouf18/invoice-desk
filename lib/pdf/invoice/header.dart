part of '../invoice_pdf.dart';

extension _Header on _Builder {
  pw.Widget header() {
    final contacts = [
      s.email,
      s.phone,
      s.website,
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final meta = <(String, String)>[
      (labelEn.invoiceNo, inv.number),
      (labelEn.issueDate, formatDocDate(inv.issueDate, DocLanguage.en)),
      (labelEn.dueDate, formatDocDate(inv.effectiveDueDate, DocLanguage.en)),
      if (inv.contractRef.trim().isNotEmpty)
        (labelEn.contractRef, inv.contractRef.trim()),
    ];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              t(s.name, style: st(size: 26, font: bold)),
              if (s.role.isNotEmpty) ...[
                pw.SizedBox(height: 2),
                t(
                  s.role,
                  style: st(size: 11, font: semi, color: style.primary),
                ),
              ],
              pw.SizedBox(height: 6),
              if (s.city.isNotEmpty) t(s.city, style: st(color: style.muted)),
              if (contacts.isNotEmpty)
                t(contacts, style: st(color: style.muted)),
            ],
          ),
        ),
        pw.SizedBox(width: 24),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                t(labelEn.invoice, style: st(size: 22, font: bold, spacing: 2)),
                pw.SizedBox(width: 8),
                t(
                  labelAr.invoice,
                  style: st(size: 15, font: semi, color: style.muted),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              tableWidth: pw.TableWidth.min,
              children: [
                for (final (k, v) in meta)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 14, bottom: 2),
                        child: t(k, style: st(color: style.muted)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: t(
                          v,
                          style: st(font: semi),
                          align: pw.TextAlign.right,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (inv.status == InvoiceStatus.paid) ...[
              pw.SizedBox(height: 8),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: pw.BoxDecoration(
                  color: style.successSoft,
                  border: pw.Border.all(color: style.success, width: 1.2),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: t(
                  '${labelEn.paid} · ${formatDocDate(inv.paidDate ?? inv.issueDate, DocLanguage.en)}',
                  style: st(
                    size: 10,
                    font: bold,
                    color: style.success,
                    spacing: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  pw.Widget card(pw.Widget label, List<pw.Widget> lines) => pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: style.surface,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [label, pw.SizedBox(height: 6), ...lines],
    ),
  );

  pw.Widget parties() {
    final c = data.client;
    final contactLine = [
      c?.phone ?? '',
      c?.email ?? '',
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final pay = <(String, String)>[
      if (s.instapay.trim().isNotEmpty) ('InstaPay', s.instapay.trim()),
      if (s.wallet.trim().isNotEmpty) (labelEn.wallet, s.wallet.trim()),
      if (s.bankIban.trim().isNotEmpty) (labelEn.bankIban, s.bankIban.trim()),
    ];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: card(bilingualLabel(labelEn.billedTo, labelAr.billedTo), [
            t(c?.name ?? '—', style: st(size: 12, font: bold)),
            if ((c?.contact ?? '').trim().isNotEmpty)
              t(labelEn.attn(c!.contact.trim()), style: st()),
            if ((c?.city ?? '').trim().isNotEmpty)
              t(c!.city.trim(), style: st(color: style.muted)),
            if (contactLine.isNotEmpty)
              t(contactLine, style: st(color: style.muted)),
          ]),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: card(
            bilingualLabel(labelEn.paymentDetails, labelAr.paymentDetails),
            [
              for (final (k, v) in pay)
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: 64,
                      child: t(k, style: st(color: style.muted)),
                    ),
                    pw.Expanded(
                      child: t(
                        v,
                        style: st(font: semi),
                        dir: pw.TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
              if (pay.isNotEmpty) pw.SizedBox(height: 4),
              t(
                labelEn.pleaseQuote(inv.number),
                style: st(size: 8.5, color: style.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
