part of '../contract_pdf.dart';

extension _Signatures on _Builder {
  pw.Widget signatures() {
    final cl = data.client;
    pw.Widget column(String side, String name, String title) => pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: _border, width: 0.8),
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            t(
              side,
              style: st(size: 10, font: bold, color: _teal),
            ),
            pw.SizedBox(height: 8),
            line('الاسم', name),
            line('الصفة', title),
            line('التوقيع', ''),
            line('التاريخ', ''),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                t('الختم', style: st(size: 9, color: _muted)),
                pw.SizedBox(width: 8),
                pw.Container(
                  width: 70,
                  height: 46,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _border, width: 0.8),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        t('التوقيعات', style: st(size: 12, font: bold)),
        pw.SizedBox(height: 8),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            column(
              'الطرف الأول',
              s.legalName.trim().isEmpty ? s.name : s.legalName,
              s.role,
            ),
            pw.SizedBox(width: 14),
            column(
              'الطرف الثاني',
              (cl?.representative.trim().isNotEmpty ?? false)
                  ? cl!.representative
                  : (cl?.legalName.trim().isNotEmpty ?? false)
                  ? cl!.legalName
                  : cl?.name ?? '',
              cl?.representativeTitle ?? '',
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget line(String label, String value) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 8),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.SizedBox(
          width: 46,
          child: t(label, style: st(size: 9, color: _muted)),
        ),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 2),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: _border, width: 0.8),
              ),
            ),
            child: t(
              value.trim().isEmpty ? ' ' : value.trim(),
              style: st(size: 10, font: semi),
            ),
          ),
        ),
      ],
    ),
  );
}
