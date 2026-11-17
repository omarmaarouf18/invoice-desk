import 'package:flutter/material.dart';
import 'package:invoice_desk/domain/document_style.dart';

/// A miniature page that shows a style at a glance: its header treatment,
/// accent, table and totals. Drawn with Flutter, never a PDF raster, so a
/// list of them costs nothing. Purely decorative for screen readers: the
/// style's name always sits next to it.
class StyleThumbnail extends StatelessWidget {
  const StyleThumbnail({required this.style, super.key, this.width = 40});

  final DocumentStyle style;

  /// The page width; the height follows the A4 ratio.
  final double width;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: width,
      height: width * 1.414,
      child: CustomPaint(painter: _PagePainter(style)),
    ),
  );
}

class _PagePainter extends CustomPainter {
  _PagePainter(this.s);
  final DocumentStyle s;

  Color _c(int argb) => Color(argb | 0xFF000000);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final u = w / 20; // one grid unit
    final page = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(u * 0.6),
    );
    canvas
      ..drawRRect(page, Paint()..color = Colors.white)
      ..drawRRect(
        page,
        Paint()
          ..style = PaintingStyle.stroke
          ..color = _c(s.border),
      );

    // Header.
    final top = u * 2;
    if (s.headerStyle == HeaderStyle.band) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          u * 1.5,
          top,
          w - u * 1.5,
          top + u * 4,
          Radius.circular(u * 0.5),
        ),
        Paint()..color = _c(s.surface),
      );
    }
    final bar = Paint()..color = _c(s.ink);
    canvas
      ..drawRect(Rect.fromLTWH(u * 2.5, top + u, u * 7, u * 1.2), bar)
      ..drawRect(
        Rect.fromLTWH(u * 2.5, top + u * 2.6, u * 4.5, u * 0.8),
        Paint()..color = _c(s.primary),
      );
    if (s.headerStyle == HeaderStyle.rule) {
      canvas.drawRect(
        Rect.fromLTWH(u * 1.5, top + u * 4.6, w - u * 3, u * 0.35),
        Paint()..color = _c(s.primary),
      );
    }

    // Table: a header row and three item rows.
    final tableTop = top + u * 7;
    final rowH = u * 1.6;
    canvas.drawRect(
      Rect.fromLTWH(u * 1.5, tableTop, w - u * 3, rowH),
      Paint()..color = _c(s.tableHeaderBg),
    );
    for (var i = 1; i <= 3; i++) {
      final y = tableTop + rowH * i;
      final row = Rect.fromLTWH(u * 1.5, y, w - u * 3, rowH);
      if (s.tableStyle == TableStyle.striped && i.isEven) {
        canvas.drawRect(row, Paint()..color = _c(s.surface));
      }
      if (s.tableStyle == TableStyle.bordered) {
        canvas.drawRect(
          row,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = u * 0.15
            ..color = _c(s.border),
        );
      }
      canvas.drawRect(
        Rect.fromLTWH(u * 2.5, y + rowH * 0.4, u * 6, u * 0.6),
        Paint()..color = _c(s.muted),
      );
    }

    // Totals box at the end of the line.
    final totalsTop = tableTop + rowH * 4 + u * 1.5;
    final box = Rect.fromLTWH(w - u * 9.5, totalsTop, u * 8, u * 3);
    switch (s.totalsStyle) {
      case TotalsStyle.solid:
        canvas.drawRect(box, Paint()..color = _c(s.primary));
      case TotalsStyle.outlined:
        canvas.drawRect(box, Paint()..color = _c(s.ink));
      case TotalsStyle.plain:
        canvas.drawRect(
          Rect.fromLTWH(box.left, box.top, box.width, u * 0.3),
          Paint()..color = _c(s.border),
        );
        canvas.drawRect(
          Rect.fromLTWH(box.left + u, box.top + u, u * 6, u),
          Paint()..color = _c(s.ink),
        );
    }
    if (s.showNotes && s.blockOrder.contains(DocBlock.notes)) {
      canvas.drawRect(
        Rect.fromLTWH(u * 2.5, totalsTop + u * 5, u * 10, u * 0.6),
        Paint()..color = _c(s.border),
      );
    }
  }

  @override
  bool shouldRepaint(_PagePainter old) => old.s != s;
}
