part of '../contract_pdf.dart';

extension _AnnexTables on _Builder {
  pw.Widget annexTitle(String text, String sub) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      t(text, style: st(size: 16, font: bold)),
      t(sub, style: st(size: 9, color: style.muted)),
      pw.SizedBox(height: 8),
      pw.Container(height: 2, color: style.ink),
      pw.SizedBox(height: 12),
    ],
  );

  pw.Widget cell(pw.Widget child, {bool end = false}) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    child: end
        ? pw.Align(alignment: pw.Alignment.centerLeft, child: child)
        : child,
  );

  pw.Widget headCell(String text, {bool end = false}) => cell(
    t(
      text,
      style: st(size: 8.5, font: bold, color: style.muted),
    ),
    end: end,
  );

  pw.Table table({
    required Map<int, pw.TableColumnWidth> widths,
    required List<pw.Widget> head,
    required List<List<pw.Widget>> rows,
  }) {
    final headDecoration = pw.BoxDecoration(
      color: style.tableStyle == TableStyle.plain
          ? style.surface
          : style.tableHeaderBg,
    );
    final border = switch (style.tableStyle) {
      TableStyle.bordered => pw.TableBorder.all(
        color: style.border,
        width: 0.8,
      ),
      _ => pw.TableBorder(
        horizontalInside: pw.BorderSide(color: style.border, width: 0.6),
        bottom: pw.BorderSide(color: style.border, width: 0.6),
      ),
    };
    return pw.Table(
      columnWidths: widths,
      border: border,
      children: [
        pw.TableRow(
          repeat: true,
          decoration: headDecoration,
          children: head,
        ),
        for (final (i, r) in rows.indexed)
          pw.TableRow(
            decoration: style.tableStyle == TableStyle.striped && i.isOdd
                ? pw.BoxDecoration(color: style.surface)
                : null,
            children: r,
          ),
      ],
    );
  }

  List<pw.Widget> scopeAnnex() {
    final rows = c.scope.where((x) => !x.isBlank).toList();
    final out = splitLines(c.outOfScope);
    pw.Widget txt(String v, {PdfColor? color, pw.Font? font}) => rich(
      v,
      style: st(size: 9.5, color: color, font: font),
      align: pw.TextAlign.right,
    );
    return [
      annexTitle(labels.scopeAnnex, labels.integralPartOf(c.number)),
      if (rows.isEmpty)
        t(labels.noScopeYet, style: st(color: style.muted))
      else
        table(
          widths: const {
            0: pw.FixedColumnWidth(26),
            1: pw.FlexColumnWidth(1.3),
            2: pw.FlexColumnWidth(1.8),
            3: pw.FlexColumnWidth(3),
            4: pw.FlexColumnWidth(2.4),
          },
          head: [
            headCell('#'),
            headCell(labels.phase),
            headCell(labels.item),
            headCell(labels.description),
            headCell(labels.acceptance),
          ],
          rows: [
            for (final (i, r) in rows.indexed)
              [
                cell(t('${i + 1}', style: st(size: 9, color: style.muted))),
                cell(txt(r.phase, color: style.primary, font: semi)),
                cell(txt(r.item, font: semi)),
                cell(txt(r.description, color: style.muted)),
                cell(txt(r.acceptance)),
              ],
          ],
        ),
      if (out.isNotEmpty) ...[
        heading(labels.outOfScope, top: 18),
        for (final line in out)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 4,
                  height: 4,
                  margin: const pw.EdgeInsets.only(top: 7, left: 8),
                  decoration: pw.BoxDecoration(
                    color: style.muted,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(child: rich(line, style: st(size: 10))),
              ],
            ),
          ),
      ],
    ];
  }

  List<pw.Widget> paymentAnnex() {
    final check = checkMilestones(c);
    String pct(PaymentMilestone m, int amount) {
      if (m.percentBp != null && m.amountMinor == null) {
        return '${formatBpAsPercent(m.percentBp!)}%';
      }
      if (c.totalMinor == 0) return '—';
      final bp = (amount * 10000 / c.totalMinor).round();
      return '${formatBpAsPercent(bp)}%';
    }

    return [
      annexTitle(labels.paymentAnnex, labels.integralPartOf(c.number)),
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: pw.BoxDecoration(
          color: style.primarySoft,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Row(
          children: [
            pw.Expanded(
              child: t(
                labels.totalFee,
                style: st(size: 11, font: semi, color: style.primary),
              ),
            ),
            t(
              formatContractMoney(c.totalMinor, c.currency),
              style: st(size: 14, font: bold, color: style.primary),
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 14),
      if (c.milestones.isNotEmpty)
        table(
          widths: const {
            0: pw.FixedColumnWidth(26),
            1: pw.FlexColumnWidth(2.2),
            2: pw.FixedColumnWidth(48),
            3: pw.FixedColumnWidth(92),
            4: pw.FlexColumnWidth(2.4),
            5: pw.FixedColumnWidth(70),
          },
          head: [
            headCell('#'),
            headCell(labels.payment),
            headCell(labels.percent),
            headCell(labels.amount, end: true),
            headCell(labels.trigger),
            headCell(labels.date),
          ],
          rows: [
            for (final (i, m) in c.milestones.indexed)
              [
                cell(t('${i + 1}', style: st(size: 9, color: style.muted))),
                cell(
                  rich(
                    m.label,
                    style: st(size: 9.5, font: semi),
                    align: pw.TextAlign.right,
                  ),
                ),
                cell(t(pct(m, check.amounts[i]), style: st(size: 9.5))),
                cell(
                  t(
                    contractMoney(check.amounts[i], c.currency, lang, s),
                    style: st(size: 9.5, font: semi),
                  ),
                  end: true,
                ),
                cell(
                  rich(
                    m.trigger,
                    style: st(size: 9.5, color: style.muted),
                    align: pw.TextAlign.right,
                  ),
                ),
                cell(
                  m.dueDate == null
                      ? t('—', style: st(size: 9))
                      : date(m.dueDate!, st(size: 9)),
                ),
              ],
            [
              cell(t('')),
              cell(t(labels.total, style: st(size: 9.5, font: bold))),
              cell(t('')),
              cell(
                t(
                  contractMoney(check.sum, c.currency, lang, s),
                  style: st(size: 9.5, font: bold),
                ),
                end: true,
              ),
              cell(t('')),
              cell(t('')),
            ],
          ],
        ),
    ];
  }
}
