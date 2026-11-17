part of '../contract_pdf.dart';

extension _Cover on _Builder {
  pw.Widget cover() {
    final provider = s.legalName.trim().isEmpty ? s.name : s.legalName;
    final cl = data.client;
    final clientName = cl == null
        ? ''
        : (cl.legalName.trim().isEmpty ? cl.name : cl.legalName);
    final rep = cl == null
        ? ''
        : [
            cl.representative.trim(),
            cl.representativeTitle.trim(),
          ].where((e) => e.isNotEmpty).join(' — ');
    pw.Widget? logoWidget;
    if (style.logoBytes != null) {
      logoWidget = pw.Container(
        constraints: pw.BoxConstraints(
          maxWidth: style.logoSize,
          maxHeight: style.logoSize,
        ),
        child: pw.Image(pw.MemoryImage(style.logoBytes!)),
      );
    }

    final topRow = pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (logoWidget != null && style.logoPosition == LogoPosition.start) ...[
          logoWidget,
          pw.SizedBox(width: 14),
        ],
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              rich(
                contractHeading(c, parent: data.parent),
                style: st(size: 20, font: bold),
                align: pw.TextAlign.right,
              ),
              if (c.projectName.trim().isNotEmpty) ...[
                pw.SizedBox(height: 2),
                rich(
                  c.projectName,
                  style: st(size: 11.5, font: semi, color: style.primary),
                  align: pw.TextAlign.right,
                ),
              ],
            ],
          ),
        ),
        if (logoWidget != null &&
            style.logoPosition == LogoPosition.center) ...[
          pw.SizedBox(width: 14),
          logoWidget,
        ],
        pw.SizedBox(width: 16),
        if (logoWidget != null && style.logoPosition == LogoPosition.end) ...[
          logoWidget,
          pw.SizedBox(width: 14),
        ],
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: pw.BoxDecoration(
            color: style.primarySoft,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              t(
                c.number,
                style: st(font: bold, color: style.primary),
              ),
              date(c.issueDate, st(size: 9, color: style.primary)),
            ],
          ),
        ),
      ],
    );

    final headerBox = style.headerStyle == HeaderStyle.band
        ? pw.Container(
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: pw.BoxDecoration(
              color: style.surface,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: topRow,
          )
        : topRow;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        headerBox,
        if (style.headerStyle == HeaderStyle.rule) ...[
          pw.SizedBox(height: 12),
          pw.Container(height: 2, color: style.ink),
          pw.SizedBox(height: 14),
        ] else if (style.headerStyle == HeaderStyle.band) ...[
          pw.SizedBox(height: 16),
        ] else ...[
          pw.SizedBox(height: 14),
        ],
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: party(labels.firstPartyProvider, [
                (null, provider),
                (labels.providerIdOrRegistry, s.nationalIdOrRegistry),
                (labels.address, s.address),
                (labels.email, s.email),
                (labels.phone, s.phone),
              ]),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: party(labels.secondPartyClient, [
                (null, clientName),
                (labels.clientRegistryOrId, cl?.registryNo ?? ''),
                (labels.address, cl?.address ?? ''),
                (labels.representedBy, rep),
                (labels.email, cl?.email ?? ''),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  /// A party card; empty lines are omitted.
  pw.Widget party(String label, List<(String?, String)> lines) => pw.Container(
    padding: const pw.EdgeInsets.all(12),
    decoration: pw.BoxDecoration(
      color: style.surface,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        t(
          label,
          style: st(size: 9, font: semi, color: style.primary),
        ),
        pw.SizedBox(height: 6),
        for (final (k, v) in lines)
          if (v.trim().isNotEmpty)
            k == null
                ? t(v.trim(), style: st(size: 11.5, font: bold))
                : pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        t('$k: ', style: st(size: 9, color: style.muted)),
                        pw.Expanded(child: t(v.trim(), style: st(size: 9.5))),
                      ],
                    ),
                  ),
      ],
    ),
  );
}
