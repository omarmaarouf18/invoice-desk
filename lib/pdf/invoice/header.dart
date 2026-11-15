part of '../invoice_pdf.dart';

extension _Header on _Builder {
  pw.Widget header() {
    final contacts = [
      s.email,
      s.phone,
      s.website,
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final meta = <(String, String)>[
      ('Invoice No.', inv.number),
      ('Issue date', formatInvoiceDate(inv.issueDate)),
      ('Due date', formatInvoiceDate(inv.dueDate)),
      if (inv.contractRef.trim().isNotEmpty)
        ('Contract ref.', inv.contractRef.trim()),
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
                  style: st(size: 11, font: semi, color: _teal),
                ),
              ],
              pw.SizedBox(height: 6),
              if (s.city.isNotEmpty) t(s.city, style: st(color: _muted)),
              if (contacts.isNotEmpty) t(contacts, style: st(color: _muted)),
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
                t('INVOICE', style: st(size: 22, font: bold, spacing: 2)),
                pw.SizedBox(width: 8),
                t(
                  'فاتورة',
                  style: st(size: 15, font: semi, color: _muted),
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
                        child: t(k, style: st(color: _muted)),
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
                  color: _greenBg,
                  border: pw.Border.all(color: _green, width: 1.2),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: t(
                  'PAID · ${formatInvoiceDate(inv.paidDate ?? inv.issueDate)}',
                  style: st(size: 10, font: bold, color: _green, spacing: 1),
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
      color: _soft,
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
      if (s.wallet.trim().isNotEmpty) ('Wallet', s.wallet.trim()),
      if (s.bankIban.trim().isNotEmpty) ('Bank / IBAN', s.bankIban.trim()),
    ];
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: card(bilingualLabel('BILLED TO', 'العميل'), [
            t(c?.name ?? '—', style: st(size: 12, font: bold)),
            if ((c?.contact ?? '').trim().isNotEmpty)
              t('Attn: ${c!.contact.trim()}', style: st()),
            if ((c?.city ?? '').trim().isNotEmpty)
              t(c!.city.trim(), style: st(color: _muted)),
            if (contactLine.isNotEmpty)
              t(contactLine, style: st(color: _muted)),
          ]),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: card(bilingualLabel('PAYMENT DETAILS', 'بيانات الدفع'), [
            for (final (k, v) in pay)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 64,
                    child: t(k, style: st(color: _muted)),
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
              'Please quote ${inv.number}',
              style: st(size: 8.5, color: _muted),
            ),
          ]),
        ),
      ],
    );
  }
}
