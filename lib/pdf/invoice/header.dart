part of '../invoice_pdf.dart';

extension _Header on _Builder {
  pw.Widget header() {
    final contacts = [
      s.email,
      s.phone,
      s.website,
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final meta = <(String, String)>[
      (label.invoiceNo, inv.number),
      (label.issueDate, docDate(inv.issueDate)),
      (label.dueDate, docDate(inv.effectiveDueDate)),
      if (inv.contractRef.trim().isNotEmpty)
        (label.contractRef, inv.contractRef.trim()),
    ];
    pw.Widget? logoWidget;
    if (style.logoBytes != null) {
      logoWidget = pw.Container(
        constraints: pw.BoxConstraints(
          maxWidth: style.logoSize,
          maxHeight: style.logoSize,
        ),
        child: pw.Image(
          pw.MemoryImage(style.logoBytes!),
        ),
      );
    }

    final nameCol = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (logoWidget != null && style.logoPosition == LogoPosition.start) ...[
          logoWidget,
          pw.SizedBox(height: 8),
        ],
        t(s.name, style: st(size: 26, font: bold)),
        if (s.role.isNotEmpty && style.showRole) ...[
          pw.SizedBox(height: 2),
          t(
            s.role,
            style: st(size: 11, font: semi, color: style.primary),
          ),
        ],
        pw.SizedBox(height: 6),
        if (s.city.isNotEmpty && style.showCity)
          t(s.city, style: st(color: style.muted)),
        if (contacts.isNotEmpty && style.showContacts)
          t(contacts, style: st(color: style.muted)),
      ],
    );

    final metaCol = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        if (logoWidget != null && style.logoPosition == LogoPosition.end) ...[
          logoWidget,
          pw.SizedBox(height: 8),
        ],
        pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            t(label.invoice, style: st(size: 22, font: bold, spacing: 2)),
            if (isBilingual) ...[
              pw.SizedBox(width: 8),
              t(
                labelAr.invoice,
                style: st(size: 15, font: semi, color: style.muted),
              ),
            ],
          ],
        ),
        pw.SizedBox(height: 8),
        _metaTable(meta),
        if (inv.status == InvoiceStatus.paid && style.showPaidStamp) ...[
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
              '${label.paid} · ${docDate(inv.paidDate ?? inv.issueDate)}',
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
    );

    final content = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(child: nameCol),
        if (logoWidget != null &&
            style.logoPosition == LogoPosition.center) ...[
          pw.SizedBox(width: 16),
          logoWidget,
        ],
        pw.SizedBox(width: 24),
        metaCol,
      ],
    );

    if (style.headerStyle == HeaderStyle.band) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: pw.BoxDecoration(
          color: style.surface,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: content,
      );
    }

    return content;
  }

  /// The invoice number and the dates, as a two-column table. The columns
  /// swap in an Arabic page: the label is on the right, the value on the
  /// left.
  pw.Widget _metaTable(List<(String, String)> meta) => pw.Table(
    tableWidth: pw.TableWidth.min,
    children: [
      for (final (k, v) in meta)
        pw.TableRow(
          children: [
            if (isArabic) ...[
              _metaValue(v),
              _metaLabel(k),
            ] else ...[
              _metaLabel(k),
              _metaValue(v),
            ],
          ],
        ),
    ],
  );

  pw.Widget _metaLabel(String text) => pw.Padding(
    padding: const pw.EdgeInsetsDirectional.only(end: 14, bottom: 2),
    child: t(
      text,
      style: st(color: style.muted),
      align: startAlign,
    ),
  );

  pw.Widget _metaValue(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 2),
    child: t(
      text,
      style: st(font: semi),
      align: endAlign,
    ),
  );

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

  /// The payment methods the provider set. An empty list means the card is
  /// not printed at all: an empty card says nothing (B3).
  List<(String, String)> get _paymentMethods => [
    if (s.instapay.trim().isNotEmpty) ('InstaPay', s.instapay.trim()),
    if (s.wallet.trim().isNotEmpty) (label.wallet, s.wallet.trim()),
    if (s.bankIban.trim().isNotEmpty) (label.bankIban, s.bankIban.trim()),
  ];

  pw.Widget parties() {
    final c = data.client;
    final contactLine = [
      if (style.showContacts) ...[
        c?.phone ?? '',
        c?.email ?? '',
      ],
    ].where((e) => e.trim().isNotEmpty).join('  ·  ');
    final pay = _paymentMethods;
    final billedTo = card(
      blockLabel(label.billedTo, labelAr.billedTo),
      [
        t(c?.name ?? '—', style: st(size: 12, font: bold)),
        if ((c?.contact ?? '').trim().isNotEmpty)
          t(label.attn(c!.contact.trim()), style: st()),
        if (style.showCity && (c?.city ?? '').trim().isNotEmpty)
          t(c!.city.trim(), style: st(color: style.muted)),
        if (contactLine.isNotEmpty)
          t(contactLine, style: st(color: style.muted)),
      ],
    );
    if (pay.isEmpty || !style.showPaymentCard) return billedTo;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(child: billedTo),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: card(
            blockLabel(label.paymentDetails, labelAr.paymentDetails),
            [
              for (final (k, v) in pay)
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(
                      width: isArabic ? 85 : 64,
                      child: t(
                        k,
                        style: st(color: style.muted),
                        align: isArabic ? startAlign : null,
                      ),
                    ),
                    if (isArabic) pw.SizedBox(width: 8),
                    pw.Expanded(
                      child: t(
                        v,
                        style: st(font: semi),
                        // The value is written left to right (an account
                        // number, an e-mail): it is isolated from the
                        // Arabic around it.
                        dir: pw.TextDirection.ltr,
                        align: startAlign,
                      ),
                    ),
                  ],
                ),
              if (pay.isNotEmpty && style.showPleaseQuote) ...[
                pw.SizedBox(height: 4),
                t(
                  label.pleaseQuote(inv.number),
                  style: st(size: 8.5, color: style.muted),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
