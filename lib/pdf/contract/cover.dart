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
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
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
                      style: st(size: 11.5, font: semi, color: _teal),
                      align: pw.TextAlign.right,
                    ),
                  ],
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: pw.BoxDecoration(
                color: _tealBg,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  t(
                    c.number,
                    style: st(font: bold, color: _teal),
                  ),
                  date(c.issueDate, st(size: 9, color: _teal)),
                ],
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Container(height: 2, color: _ink),
        pw.SizedBox(height: 14),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: party('الطرف الأول (مقدم الخدمة)', [
                (null, provider),
                ('رقم قومي / سجل تجاري', s.nationalIdOrRegistry),
                ('العنوان', s.address),
                ('البريد الإلكتروني', s.email),
                ('الهاتف', s.phone),
              ]),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: party('الطرف الثاني (العميل)', [
                (null, clientName),
                ('سجل تجاري / رقم قومي', cl?.registryNo ?? ''),
                ('العنوان', cl?.address ?? ''),
                ('يمثله', rep),
                ('البريد الإلكتروني', cl?.email ?? ''),
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
      color: _soft,
      borderRadius: pw.BorderRadius.circular(8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        t(
          label,
          style: st(size: 9, font: semi, color: _teal),
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
                        t('$k: ', style: st(size: 9, color: _muted)),
                        pw.Expanded(child: t(v.trim(), style: st(size: 9.5))),
                      ],
                    ),
                  ),
      ],
    ),
  );
}
