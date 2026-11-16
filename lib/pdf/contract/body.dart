part of '../contract_pdf.dart';

/// About 18 lines of body text: far less than a page, so a heading plus
/// its first block always fits on a fresh page.
const _keepWithHeadingMaxChars = 1500;

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

  pw.Widget paragraph(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: rich(text),
  );

  pw.Widget subItem(int i, String item) => pw.Padding(
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
  );

  /// Sub-items [from] onwards, with the block's bottom spacing.
  pw.Widget subItems(List<String> items, {int from = 0}) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        for (var i = from; i < items.length; i++) subItem(i, items[i]),
      ],
    ),
  );

  List<pw.Widget> body(String text) => [
    for (final block in parseBody(text))
      switch (block) {
        ParagraphBlock(:final text) => paragraph(text),
        SubItemsBlock(:final items) => subItems(items),
      },
  ];

  /// [head] followed by [text]'s blocks, with the heading kept on the same
  /// page as the first paragraph (or first sub-item), so a page never ends
  /// with a heading.
  ///
  /// The group can't span pages, so a first block longer than
  /// [_keepWithHeadingMaxChars] is left splittable instead: a page taller
  /// than the group would make the export fail.
  List<pw.Widget> section(pw.Widget head, String text) {
    final blocks = parseBody(text);
    if (blocks.isEmpty) return [head];
    pw.Widget group(List<pw.Widget> children) => pw.Inseparable(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: children,
      ),
    );
    final rest = [
      for (final b in blocks.skip(1))
        switch (b) {
          ParagraphBlock(:final text) => paragraph(text),
          SubItemsBlock(:final items) => subItems(items),
        },
    ];
    return switch (blocks.first) {
      ParagraphBlock(:final text)
          when text.length <= _keepWithHeadingMaxChars =>
        [
          group([head, paragraph(text)]),
          ...rest,
        ],
      SubItemsBlock(:final items)
          when items.first.length <= _keepWithHeadingMaxChars =>
        [
          group([
            head,
            subItem(0, items.first),
            if (items.length == 1) pw.SizedBox(height: 6),
          ]),
          if (items.length > 1) subItems(items, from: 1),
          ...rest,
        ],
      _ => [head, ...body(text)],
    };
  }

  List<pw.Widget> preamble() => c.preamble.trim().isEmpty
      ? const []
      : section(heading(labels.preamble, top: 0), c.preamble);

  List<pw.Widget> clauses() {
    final enabled = c.clauses.where((x) => x.enabled).toList();
    return [
      for (final (i, cl) in enabled.indexed)
        ...section(
          heading(
            cl.title.trim().isEmpty
                ? clauseHeading(i + 1, lang)
                : clauseHeadingWithTitle(i + 1, cl.title, lang),
          ),
          cl.body,
        ),
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
