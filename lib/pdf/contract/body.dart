part of '../contract_pdf.dart';

extension _Body on _Builder {
  String _digits(int n) => subItemLabel(n, western: s.contractWesternDigits);

  pw.Widget heading(String text, {double top = 14}) => pw.Padding(
    padding: pw.EdgeInsets.only(top: top, bottom: 6),
    child: rich(
      text,
      style: st(size: 12, font: bold, color: style.primary),
      align: pw.TextAlign.right,
    ),
  );

  List<pw.Widget> body(String text) => [
    for (final block in parseBody(text))
      switch (block) {
        ParagraphBlock(:final text) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: rich(text),
        ),
        SubItemsBlock(:final items) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              for (final (i, item) in items.indexed)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 22,
                        child: t(
                          _digits(i + 1),
                          style: st(font: semi, color: style.primary),
                        ),
                      ),
                      pw.Expanded(child: rich(item)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      },
  ];

  List<pw.Widget> preamble() => c.preamble.trim().isEmpty
      ? const []
      : [heading(labels.preamble, top: 0), ...body(c.preamble)];

  List<pw.Widget> clauses() {
    final enabled = c.clauses.where((x) => x.enabled).toList();
    return [
      for (final (i, cl) in enabled.indexed) ...[
        heading(
          cl.title.trim().isEmpty
              ? clauseHeading(i + 1, lang)
              : clauseHeadingWithTitle(i + 1, cl.title, lang),
        ),
        ...body(cl.body),
      ],
    ];
  }

  List<pw.Widget> closing() => c.closing.trim().isEmpty
      ? const []
      : [
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border(
                right: pw.BorderSide(color: style.primary, width: 2),
              ),
            ),
            child: rich(c.closing, style: st(font: semi)),
          ),
        ];
}
