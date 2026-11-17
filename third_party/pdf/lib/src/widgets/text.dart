/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:math' as math;

import 'package:meta/meta.dart';

import '../../pdf.dart';
import '../pdf/font/arabic.dart' as arabic;
import '../pdf/font/bidi_utils.dart' as bidi;
import '../pdf/options.dart';
import 'annotations.dart';
import 'basic.dart';
import 'document.dart';
import 'geometry.dart';
import 'image.dart';
import 'image_provider.dart';
import 'multi_page.dart';
import 'placeholders.dart';
import 'text_style.dart';
import 'theme.dart';
import 'widget.dart';

enum TextAlign { left, right, start, end, center, justify }

enum TextDirection { ltr, rtl }

/// How overflowing text should be handled.
enum TextOverflow {
  /// Clip the overflowing text to fix its container.
  clip,

  /// Render overflowing text outside of its container.
  visible,

  /// Span to the next page when possible.
  span,
}

abstract class _Span {
  _Span(this.style);

  final TextStyle style;

  var offset = PdfPoint.zero;

  double get left;

  double get top;

  double get width;

  /// Horizontal space the span occupies in the line (pen advance).
  double get advanceWidth => width;

  double get height;

  @override
  String toString() {
    return 'Span "offset:$offset';
  }

  void debugPaint(
    Context context,
    double textScaleFactor,
    PdfRect? globalBox,
  ) {}

  void paint(
    Context context,
    TextStyle style,
    double textScaleFactor,
    PdfPoint point,
  );
}

class _TextDecoration {
  _TextDecoration(this.style, this.annotation, this.startSpan, this.endSpan)
    : assert(startSpan <= endSpan);

  static const double _space = -0.15;

  final TextStyle style;

  final AnnotationBuilder? annotation;

  final int startSpan;

  final int endSpan;

  PdfRect? _box;

  PdfRect? _getBox(List<_Span> spans) {
    if (_box != null) {
      return _box;
    }

    final x1 = spans[startSpan].offset.x + spans[startSpan].left;
    final x2 =
        spans[endSpan].offset.x + spans[endSpan].left + spans[endSpan].width;
    var y1 = spans[startSpan].offset.y + spans[startSpan].top;
    var y2 = y1 + spans[startSpan].height;

    for (var n = startSpan + 1; n <= endSpan; n++) {
      final ny1 = spans[n].offset.y + spans[n].top;
      final ny2 = ny1 + spans[n].height;
      y1 = math.min(y1, ny1);
      y2 = math.max(y2, ny2);
    }

    _box = PdfRect.fromLBRT(x1, y1, x2, y2);
    return _box;
  }

  _TextDecoration copyWith({int? endSpan}) =>
      _TextDecoration(style, annotation, startSpan, endSpan ?? this.endSpan);

  void backgroundPaint(
    Context context,
    double textScaleFactor,
    PdfRect? globalBox,
    List<_Span> spans,
  ) {
    final box = _getBox(spans);

    if (annotation != null) {
      final spanBox = PdfRect(
        globalBox!.left + box!.left,
        globalBox.top + box.bottom,
        box.width,
        box.height,
      );
      annotation!.build(context, spanBox);
    }

    if (style.background != null) {
      final boundingBox = PdfRect(
        globalBox!.left + box!.left,
        globalBox.top + box.bottom,
        box.width,
        box.height,
      );
      style.background!.paint(context, boundingBox);
      context.canvas.setFillColor(style.color);
    }
  }

  void foregroundPaint(
    Context context,
    double textScaleFactor,
    PdfRect? globalBox,
    List<_Span> spans,
  ) {
    if (style.decoration == null) {
      return;
    }

    final box = _getBox(spans);

    final font = style.font!.getFont(context);
    final space =
        _space * style.fontSize! * textScaleFactor * style.decorationThickness!;

    context.canvas
      ..setStrokeColor(style.decorationColor ?? style.color)
      ..setLineWidth(
        style.decorationThickness! * style.fontSize! * textScaleFactor * 0.05,
      );

    if (style.decoration!.contains(TextDecoration.underline)) {
      final base = -font.descent * style.fontSize! * textScaleFactor / 2;
      final l = box!.left;
      final r = box.right;
      final x = globalBox!.left;
      context.canvas.drawLine(
        x + l,
        globalBox.top + box.bottom + base,
        x + r,
        globalBox.top + box.bottom + base,
      );
      if (style.decorationStyle == TextDecorationStyle.double) {
        context.canvas.drawLine(
          globalBox.left + box.left,
          globalBox.top + box.bottom + base + space,
          globalBox.left + box.right,
          globalBox.top + box.bottom + base + space,
        );
      }
      context.canvas.strokePath();
    }

    if (style.decoration!.contains(TextDecoration.overline)) {
      final base = style.fontSize! * textScaleFactor;
      context.canvas.drawLine(
        globalBox!.left + box!.left,
        globalBox.top + box.bottom + base,
        globalBox.left + box.right,
        globalBox.top + box.bottom + base,
      );
      if (style.decorationStyle == TextDecorationStyle.double) {
        context.canvas.drawLine(
          globalBox.left + box.left,
          globalBox.top + box.bottom + base - space,
          globalBox.left + box.right,
          globalBox.top + box.bottom + base - space,
        );
      }
      context.canvas.strokePath();
    }

    if (style.decoration!.contains(TextDecoration.lineThrough)) {
      final base = (1 - font.descent) * style.fontSize! * textScaleFactor / 2;
      context.canvas.drawLine(
        globalBox!.left + box!.left,
        globalBox.top + box.bottom + base,
        globalBox.left + box.right,
        globalBox.top + box.bottom + base,
      );
      if (style.decorationStyle == TextDecorationStyle.double) {
        context.canvas.drawLine(
          globalBox.left + box.left,
          globalBox.top + box.bottom + base + space,
          globalBox.left + box.right,
          globalBox.top + box.bottom + base + space,
        );
      }
      context.canvas.strokePath();
    }
  }

  void debugPaint(
    Context context,
    double textScaleFactor,
    PdfRect globalBox,
    List<_Span> spans,
  ) {
    final box = _getBox(spans)!;

    context.canvas
      ..setLineWidth(.5)
      ..drawRect(
        globalBox.left + box.left,
        globalBox.top + box.bottom,
        box.width,
        box.height,
      )
      ..setStrokeColor(PdfColors.yellow)
      ..strokePath();
  }
}

class _WordRun {
  _WordRun(this.text, this.font, this.metrics, this.style);

  final String text;
  final PdfFont font;
  final PdfFontMetrics metrics;
  final TextStyle style;
}

class _Word extends _Span {
  _Word(this.text, TextStyle style, this.metrics, {this.runs}) : super(style);

  final String text;

  final PdfFontMetrics metrics;

  final List<_WordRun>? runs;

  @override
  double get left => metrics.left;

  @override
  double get top => metrics.descent;

  @override
  double get width => metrics.width;

  @override
  double get advanceWidth => metrics.advanceWidth;

  @override
  double get height => metrics.maxHeight;

  @override
  String toString() {
    return 'Word "$text" offset:$offset metrics:$metrics style:$style';
  }

  @override
  void paint(
    Context context,
    TextStyle style,
    double textScaleFactor,
    PdfPoint point,
  ) {
    if (runs == null || runs!.isEmpty) {
      context.canvas.drawString(
        style.font!.getFont(context),
        style.fontSize! * textScaleFactor,
        text,
        point.x + offset.x,
        point.y + offset.y,
        mode: style.renderingMode ?? PdfTextRenderingMode.fill,
        charSpace: style.letterSpacing ?? 0,
      );
    } else {
      var dx = 0.0;
      for (final run in runs!) {
        context.canvas.drawString(
          run.font,
          run.style.fontSize! * textScaleFactor,
          run.text,
          point.x + offset.x + dx,
          point.y + offset.y,
          mode: run.style.renderingMode ?? PdfTextRenderingMode.fill,
          charSpace: run.style.letterSpacing ?? 0,
        );
        dx += run.metrics.advanceWidth + (run.style.letterSpacing ?? 0);
      }
    }
  }

  @override
  void debugPaint(Context context, double textScaleFactor, PdfRect? globalBox) {
    const deb = 5;

    context.canvas
      ..setLineWidth(.5)
      ..drawRect(
        globalBox!.left + offset.x + metrics.left,
        globalBox.top + offset.y + metrics.top,
        metrics.width,
        metrics.height,
      )
      ..setStrokeColor(PdfColors.orange)
      ..strokePath()
      ..drawLine(
        globalBox.left + offset.x - deb,
        globalBox.top + offset.y,
        globalBox.left + offset.x + metrics.right + deb,
        globalBox.top + offset.y,
      )
      ..setStrokeColor(PdfColors.deepPurple)
      ..strokePath();
  }
}

class _WidgetSpan extends _Span {
  _WidgetSpan(this.widget, TextStyle style, this.baseline) : super(style);

  final Widget widget;

  final double baseline;

  @override
  double get left => 0;

  @override
  double get top => 0;

  @override
  double get width => widget.box!.width;

  @override
  double get height => widget.box!.height;

  @override
  PdfPoint get offset => widget.box!.offset;

  @override
  set offset(PdfPoint value) {
    widget.box = PdfRect.fromPoints(value, widget.box!.size);
  }

  @override
  String toString() {
    return 'Widget "$widget" offset:$offset';
  }

  @override
  void paint(
    Context context,
    TextStyle? style,
    double textScaleFactor,
    PdfPoint point,
  ) {
    widget.box = PdfRect.fromPoints(
      PdfPoint(point.x + widget.box!.offset.x, point.y + widget.box!.offset.y),
      widget.box!.size,
    );
    widget.paint(context);
  }

  @override
  void debugPaint(Context context, double textScaleFactor, PdfRect? globalBox) {
    const deb = 5;

    context.canvas
      ..setLineWidth(.5)
      ..drawRect(
        globalBox!.left + offset.x,
        globalBox.top + offset.y,
        width,
        height,
      )
      ..setStrokeColor(PdfColors.orange)
      ..strokePath()
      ..drawLine(
        globalBox.left + offset.x - deb,
        globalBox.top + offset.y - baseline,
        globalBox.left + offset.x + width + deb,
        globalBox.top + offset.y - baseline,
      )
      ..setStrokeColor(PdfColors.deepPurple)
      ..strokePath();
  }
}

typedef VisitorCallback =
    bool Function(
      InlineSpan span,
      TextStyle? parentStyle,
      AnnotationBuilder? annotation,
    );

@immutable
abstract class InlineSpan {
  const InlineSpan({this.style, required this.baseline, this.annotation});

  final TextStyle? style;

  final double baseline;

  final AnnotationBuilder? annotation;

  InlineSpan copyWith({
    TextStyle? style,
    double? baseline,
    AnnotationBuilder? annotation,
  });

  String toPlainText() {
    final buffer = StringBuffer();
    visitChildren(
      (InlineSpan span, TextStyle? style, AnnotationBuilder? annotation) {
        if (span is TextSpan) {
          buffer.write(span.text);
        }
        return true;
      },
      null,
      null,
    );
    return buffer.toString();
  }

  bool visitChildren(
    VisitorCallback visitor,
    TextStyle? parentStyle,
    AnnotationBuilder? annotation,
  );
}

class WidgetSpan extends InlineSpan {
  /// Creates a [WidgetSpan] with the given values.
  const WidgetSpan({
    required this.child,
    double baseline = 0,
    TextStyle? style,
    AnnotationBuilder? annotation,
  }) : super(style: style, baseline: baseline, annotation: annotation);

  /// The widget to embed inline within text.
  final Widget child;

  @override
  InlineSpan copyWith({
    TextStyle? style,
    double? baseline,
    AnnotationBuilder? annotation,
  }) => WidgetSpan(
    child: child,
    style: style ?? this.style,
    baseline: baseline ?? this.baseline,
    annotation: annotation ?? this.annotation,
  );

  /// Calls `visitor` on this [WidgetSpan]. There are no children spans to walk.
  @override
  bool visitChildren(
    VisitorCallback visitor,
    TextStyle? parentStyle,
    AnnotationBuilder? annotation,
  ) {
    final _style = parentStyle?.merge(style);
    final _a = this.annotation ?? annotation;

    return visitor(this, _style, _a);
  }
}

class TextSpan extends InlineSpan {
  const TextSpan({
    TextStyle? style,
    this.text,
    double baseline = 0,
    this.children,
    AnnotationBuilder? annotation,
  }) : super(style: style, baseline: baseline, annotation: annotation);

  final String? text;

  final List<InlineSpan>? children;

  @override
  InlineSpan copyWith({
    TextStyle? style,
    double? baseline,
    AnnotationBuilder? annotation,
  }) => TextSpan(
    style: style ?? this.style,
    text: text,
    baseline: baseline ?? this.baseline,
    children: children,
    annotation: annotation ?? this.annotation,
  );

  @override
  bool visitChildren(
    VisitorCallback visitor,
    TextStyle? parentStyle,
    AnnotationBuilder? annotation,
  ) {
    final _style = parentStyle?.merge(style);
    final _annotation = this.annotation ?? annotation;

    if (text != null) {
      if (!visitor(this, _style, _annotation)) {
        return false;
      }
    }
    if (children != null) {
      for (final child in children!) {
        if (!child.visitChildren(visitor, _style, _annotation)) {
          return false;
        }
      }
    }
    return true;
  }
}

class _Line {
  const _Line(
    this.parent,
    this.firstSpan,
    this.countSpan,
    this.baseline,
    this.wordsWidth,
    this.textDirection,
    this.justify,
  );

  final RichText parent;

  final int firstSpan;
  final int countSpan;

  int get lastSpan => firstSpan + countSpan;

  TextAlign get textAlign => parent._textAlign;

  final double baseline;

  final double wordsWidth;

  final TextDirection textDirection;

  final bool justify;

  double get height {
    final list = parent._spans.sublist(firstSpan, lastSpan);
    return list.isEmpty
        ? 0
        : list.reduce((a, b) => a.height > b.height ? a : b).height;
  }

  @override
  String toString() =>
      '$runtimeType $firstSpan-$lastSpan baseline: $baseline width:$wordsWidth';

  void realign(double totalWidth) {
    final spans = parent._spans.sublist(firstSpan, lastSpan);
    final isRTL = textDirection == TextDirection.rtl;

    var delta = 0.0;
    switch (textAlign) {
      case TextAlign.left:
        delta = isRTL ? wordsWidth : 0;
        break;
      case TextAlign.right:
        delta = isRTL ? totalWidth : totalWidth - wordsWidth;
        break;
      case TextAlign.start:
        delta = isRTL ? totalWidth : 0;
        break;
      case TextAlign.end:
        delta = isRTL ? wordsWidth : totalWidth - wordsWidth;
        break;
      case TextAlign.center:
        delta = (totalWidth - wordsWidth) / 2.0;
        if (isRTL) {
          delta += wordsWidth;
        }
        break;
      case TextAlign.justify:
        delta = isRTL ? totalWidth : 0;
        if (!justify) {
          break;
        }

        final gap = (totalWidth - wordsWidth) / (spans.length - 1);
        var x = 0.0;
        for (final span in spans) {
          span.offset = PdfPoint(
            isRTL
                ? delta - x - (span.offset.x + span.advanceWidth)
                : span.offset.x + x,
            span.offset.y - baseline,
          );
          x += gap;
        }

        return;
    }

    if (isRTL) {
      for (final span in spans) {
        span.offset = PdfPoint(
          delta - (span.offset.x + span.advanceWidth),
          span.offset.y - baseline,
        );
      }
      return;
    }

    for (final span in spans) {
      span.offset = span.offset.translate(delta, -baseline);
    }
  }
}

class RichTextContext extends WidgetContext {
  var startOffset = 0.0;
  var endOffset = 0.0;
  var spanStart = 0;
  var spanEnd = 0;

  @override
  void apply(RichTextContext other) {
    startOffset = other.startOffset;
    endOffset = other.endOffset;
    spanStart = other.spanStart;
    spanEnd = other.spanEnd;
  }

  @override
  WidgetContext clone() {
    return RichTextContext()..apply(this);
  }

  @override
  String toString() =>
      '$runtimeType Offset: $startOffset -> $endOffset  Span: $spanStart -> $spanEnd';
}

typedef Hyphenation = List<String> Function(String word);

/// Signature of a function that splits a line of text into words that may be
/// wrapped independently.
///
/// By default, lines are split at whitespace, which means that scripts without
/// word separators (Chinese, Japanese, Korean...) are treated as a single
/// word and can only be broken by the hard-splitting fallback, without any
/// line breaking rule (no prohibition of closing punctuation at the beginning
/// of a line, etc.).
///
/// Providing a custom splitter enables script-aware line wrapping, for
/// instance breaking between CJK characters, or implementing the Unicode Line
/// Breaking Algorithm (UAX #14):
///
/// ```dart
/// RichText(
///   text: TextSpan(
///     text: '你好，世界',
///     // Each CJK character may wrap independently. Spaces are not inserted
///     // between the words, so the space width must be cleared.
///     style: TextStyle(font: myCjkFont, wordSpacing: 0),
///   ),
///   lineSplitter: (line) => line.split(''),
/// );
/// ```
///
/// Whitespace runs must be returned the same way [String.split] does (as empty
/// strings) when they are expected to keep their width, so that the default
/// behavior is preserved for mixed content.
typedef LineSplitter = List<String> Function(String line);

class RichText extends Widget with SpanningWidget {
  RichText({
    required this.text,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.tightBounds = false,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.overflow = TextOverflow.visible,
    this.hyphenation,
    this.lineSplitter,
  });

  static bool debug = false;

  final InlineSpan text;

  final TextAlign? textAlign;

  late TextAlign _textAlign;

  final TextDirection? textDirection;

  final double textScaleFactor;

  final bool? softWrap;

  final bool tightBounds;

  final int? maxLines;

  final List<_Span> _spans = <_Span>[];

  final List<_TextDecoration> _decorations = <_TextDecoration>[];

  final _context = RichTextContext();

  final TextOverflow? overflow;

  var _mustClip = false;

  List<InlineSpan>? _preprocessed;

  final Hyphenation? hyphenation;

  /// A custom function to split lines of text into words that may be wrapped
  /// independently. When `null` (the default), lines are split at whitespace.
  ///
  /// See [LineSplitter] for details and for an example enabling CJK wrapping.
  final LineSplitter? lineSplitter;

  void _appendDecoration(bool append, _TextDecoration td) {
    if (append && _decorations.isNotEmpty) {
      final last = _decorations.last;
      if (last.style == td.style && last.annotation == td.annotation) {
        _decorations[_decorations.length - 1] = last.copyWith(
          endSpan: td.endSpan,
        );
        return;
      }
    }
    _decorations.add(td);
  }

  InlineSpan _addEmoji({
    required TtfBitmapInfo bitmap,
    double baseline = 0,
    required TextStyle style,
    AnnotationBuilder? annotation,
  }) {
    final metrics = bitmap.metrics * style.fontSize!;

    return WidgetSpan(
      child: SizedBox(
        height: style.fontSize,
        child: Image(MemoryImage(bitmap.data)),
      ),
      style: style,
      baseline: baseline + metrics.ascent + metrics.descent - metrics.height,
      annotation: annotation,
    );
  }

  InlineSpan _addText({
    required List<int> text,
    int start = 0,
    int? end,
    double baseline = 0,
    required TextStyle style,
    AnnotationBuilder? annotation,
  }) {
    return TextSpan(
      text: String.fromCharCodes(text, start, end),
      style: style,
      baseline: baseline,
      annotation: annotation,
    );
  }

  InlineSpan _addPlaceholder({
    double baseline = 0,
    required TextStyle style,
    AnnotationBuilder? annotation,
  }) {
    return WidgetSpan(
      child: SizedBox(
        height: style.fontSize,
        width: style.fontSize! / 2,
        child: Placeholder(color: style.color!, strokeWidth: 1),
      ),
      style: style,
      baseline: baseline,
      annotation: annotation,
    );
  }

  /// Pre-processes spans by flattening the InlineSpan tree.
  /// Character-level font fallback is handled at word level to maintain
  /// paragraph context for bidirectional text and avoid inverted span order.
  List<InlineSpan> _preProcessSpans(Context context) {
    final theme = Theme.of(context);
    final defaultStyle = theme.defaultTextStyle;
    final spans = <InlineSpan>[];

    text.visitChildren(
      (InlineSpan span, TextStyle? style, AnnotationBuilder? annotation) {
        if (span is! TextSpan) {
          spans.add(span.copyWith(style: style, annotation: annotation));
          return true;
        }
        if (span.text == null) {
          return true;
        }
        spans.add(span.copyWith(style: style, annotation: annotation));
        return true;
      },
      defaultStyle,
      null,
    );

    return spans;
  }

  _Word _createWord(
    String word,
    TextStyle style,
    Context context,
    double textScaleFactor,
  ) {
    final primaryFont = style.font!.getFont(context);
    final letterSpacingScaled =
        style.letterSpacing! / (style.fontSize! * textScaleFactor);

    if (style.fontFallback.isEmpty) {
      final metrics =
          primaryFont.stringMetrics(
            word,
            letterSpacing: letterSpacingScaled,
          ) *
          (style.fontSize! * textScaleFactor);
      return _Word(word, style, metrics);
    }

    final hasLatin = RegExp(r'[a-zA-Z]').hasMatch(word);
    final primaryLacksLatin = !primaryFont.isRuneSupported(0x0041);

    PdfFont? latinFallbackFont;
    TextStyle? latinFallbackStyle;
    if (hasLatin && primaryLacksLatin) {
      for (final fb in style.fontFallback) {
        final fbFont = fb.getFont(context);
        if (fbFont.isRuneSupported(0x0041)) {
          latinFallbackFont = fbFont;
          latinFallbackStyle = style.copyWith(
            font: fb,
            fontNormal: fb,
            fontBold: fb,
            fontBoldItalic: fb,
            fontItalic: fb,
          );
          break;
        }
      }
    }

    final runes = word.runes.toList();
    var allPrimary = true;
    final runeFonts = <PdfFont>[];
    final runeStyles = <TextStyle>[];

    for (final rune in runes) {
      if (hasLatin &&
          primaryLacksLatin &&
          rune >= 0x20 &&
          rune <= 0x7E &&
          latinFallbackFont != null) {
        allPrimary = false;
        runeFonts.add(latinFallbackFont);
        runeStyles.add(latinFallbackStyle!);
        continue;
      }

      if (primaryFont.isRuneSupported(rune)) {
        runeFonts.add(primaryFont);
        runeStyles.add(style);
      } else {
        allPrimary = false;
        PdfFont? chosenFont;
        TextStyle? chosenStyle;
        for (final fb in style.fontFallback) {
          final fbFont = fb.getFont(context);
          if (fbFont.isRuneSupported(rune)) {
            chosenFont = fbFont;
            chosenStyle = style.copyWith(
              font: fb,
              fontNormal: fb,
              fontBold: fb,
              fontBoldItalic: fb,
              fontItalic: fb,
            );
            break;
          }
        }
        runeFonts.add(chosenFont ?? primaryFont);
        runeStyles.add(chosenStyle ?? style);
      }
    }

    if (allPrimary) {
      final metrics =
          primaryFont.stringMetrics(
            word,
            letterSpacing: letterSpacingScaled,
          ) *
          (style.fontSize! * textScaleFactor);
      return _Word(word, style, metrics);
    }

    final runs = <_WordRun>[];
    var runRunes = <int>[];
    var currentFont = runeFonts.first;
    var currentStyle = runeStyles.first;

    for (var i = 0; i < runes.length; i++) {
      if (runeFonts[i] == currentFont && runeStyles[i] == currentStyle) {
        runRunes.add(runes[i]);
      } else {
        final runText = String.fromCharCodes(runRunes);
        final runMetrics =
            currentFont.stringMetrics(
              runText,
              letterSpacing: letterSpacingScaled,
            ) *
            (currentStyle.fontSize! * textScaleFactor);
        runs.add(_WordRun(runText, currentFont, runMetrics, currentStyle));

        runRunes = [runes[i]];
        currentFont = runeFonts[i];
        currentStyle = runeStyles[i];
      }
    }
    if (runRunes.isNotEmpty) {
      final runText = String.fromCharCodes(runRunes);
      final runMetrics =
          currentFont.stringMetrics(
            runText,
            letterSpacing: letterSpacingScaled,
          ) *
          (currentStyle.fontSize! * textScaleFactor);
      runs.add(_WordRun(runText, currentFont, runMetrics, currentStyle));
    }

    final combinedMetrics = PdfFontMetrics.append(
      runs.map((r) => r.metrics),
      letterSpacing: style.letterSpacing ?? 0,
    );

    return _Word(word, style, combinedMetrics, runs: runs);
  }

  @override
  void layout(
    Context context,
    BoxConstraints constraints, {
    bool parentUsesSize = false,
  }) {
    _spans.clear();
    _decorations.clear();

    final theme = Theme.of(context);
    final _softWrap = softWrap ?? theme.softWrap;
    final _maxLines = maxLines ?? theme.maxLines;
    final _textDirection = textDirection ?? Directionality.of(context);
    _textAlign = textAlign ?? theme.textAlign ?? TextAlign.start;

    final _overflow = this.overflow ?? theme.overflow;

    final constraintWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : constraints.constrainWidth();
    final constraintHeight = constraints.hasBoundedHeight
        ? constraints.maxHeight
        : constraints.constrainHeight();

    var offsetX = 0.0;
    var offsetY = _context.startOffset;

    var top = 0.0;
    var bottom = 0.0;

    final lines = <_Line>[];
    var spanCount = 0;
    var spanStart = 0;
    var overflow = false;

    _preprocessed ??= _preProcessSpans(context);

    void _buildLines() {
      for (final span in _preprocessed!) {
        final style = span.style;
        final annotation = span.annotation;

        if (span is TextSpan) {
          if (span.text == null) {
            continue;
          }

          final font = style!.font!.getFont(context);

          final space =
              font.stringMetrics(' ') * (style.fontSize! * textScaleFactor);

          final spanLines =
              (useArabic && _textDirection == TextDirection.rtl
                      ? arabic.convert(span.text!)
                      : useBidi && _textDirection == TextDirection.rtl
                      ? bidi.logicalToVisual(span.text!)
                      : span.text)!
                  .split('\n');

          for (var line = 0; line < spanLines.length; line++) {
            final words =
                lineSplitter?.call(spanLines[line]) ??
                spanLines[line].split(RegExp(r'\s'));
            for (var index = 0; index < words.length; index++) {
              final word = words[index];

              if (word.isEmpty) {
                offsetX +=
                    space.advanceWidth * style.wordSpacing! +
                    style.letterSpacing!;
                continue;
              }

              final wd = _createWord(word, style, context, textScaleFactor);
              final metrics = wd.metrics;

              if (_softWrap &&
                  offsetX + metrics.width > constraintWidth + 0.00001) {
                if (hyphenation != null) {
                  final syllables = hyphenation!(word);
                  if (syllables.length > 1) {
                    var fits = '';
                    for (var syllable in syllables) {
                      if (offsetX +
                              ((font.stringMetrics(
                                        '$fits$syllable-',
                                        letterSpacing:
                                            style.letterSpacing! /
                                            (style.fontSize! * textScaleFactor),
                                      ) *
                                      (style.fontSize! * textScaleFactor))
                                  .width) >
                          constraintWidth + 0.00001) {
                        break;
                      }
                      fits += syllable;
                    }
                    if (fits.isNotEmpty) {
                      words[index] = '$fits-';
                      words.insert(index + 1, word.substring(fits.length));
                      index--;
                      continue;
                    }
                  }
                }

                if (spanCount > 0 && metrics.width <= constraintWidth) {
                  overflow = true;
                  lines.add(
                    _Line(
                      this,
                      spanStart,
                      spanCount,
                      bottom,
                      offsetX -
                          space.advanceWidth * style.wordSpacing! -
                          style.letterSpacing!,
                      _textDirection,
                      true,
                    ),
                  );

                  spanStart += spanCount;
                  spanCount = 0;

                  offsetX = 0.0;
                  offsetY += bottom - top;
                  top = 0;
                  bottom = 0;

                  if (_maxLines != null && lines.length >= _maxLines) {
                    return;
                  }

                  if (offsetY > constraintHeight) {
                    return;
                  }

                  offsetY += style.lineSpacing! * textScaleFactor;
                } else {
                  // One word Overflow, try to split it.
                  final pos = _splitWord(word, font, style, constraintWidth);

                  if (pos < word.length) {
                    words[index] = word.substring(0, pos);
                    words.insert(index + 1, word.substring(pos));

                    // Try again
                    index--;
                    continue;
                  }
                }
              }

              final baseline = span.baseline * textScaleFactor;
              final mt = tightBounds ? metrics.top : metrics.descent;
              final mb = tightBounds ? metrics.bottom : metrics.ascent;
              top = math.min(top, mt + baseline);
              bottom = math.max(bottom, mb + baseline);

              wd.offset = PdfPoint(offsetX, -offsetY + baseline);
              _spans.add(wd);
              spanCount++;

              _appendDecoration(
                spanCount > 1,
                _TextDecoration(
                  style,
                  annotation,
                  _spans.length - 1,
                  _spans.length - 1,
                ),
              );

              offsetX +=
                  metrics.advanceWidth +
                  space.advanceWidth * style.wordSpacing! +
                  style.letterSpacing!;
            }

            if (line < spanLines.length - 1) {
              lines.add(
                _Line(
                  this,
                  spanStart,
                  spanCount,
                  bottom,
                  offsetX -
                      space.advanceWidth * style.wordSpacing! -
                      style.letterSpacing!,
                  _textDirection,
                  false,
                ),
              );

              spanStart += spanCount;

              offsetX = 0.0;
              if (spanCount > 0) {
                offsetY += bottom - top;
              } else {
                offsetY +=
                    font.emptyLineHeight * style.fontSize! * textScaleFactor;
              }
              top = 0;
              bottom = 0;
              spanCount = 0;

              if (_maxLines != null && lines.length >= _maxLines) {
                return;
              }

              if (offsetY > constraintHeight) {
                return;
              }

              offsetY += style.lineSpacing! * textScaleFactor;
            }
          }

          offsetX -=
              space.advanceWidth * style.wordSpacing! - style.letterSpacing!;
        } else if (span is WidgetSpan) {
          span.child.layout(
            context,
            BoxConstraints(
              maxWidth: constraintWidth,
              maxHeight: constraintHeight,
            ),
          );
          final ws = _WidgetSpan(span.child, style!, span.baseline);

          if (offsetX + ws.width > constraintWidth && spanCount > 0) {
            overflow = true;
            lines.add(
              _Line(
                this,
                spanStart,
                spanCount,
                bottom,
                offsetX,
                _textDirection,
                true,
              ),
            );

            spanStart += spanCount;
            spanCount = 0;

            if (_maxLines != null && lines.length > _maxLines) {
              return;
            }

            offsetX = 0.0;
            offsetY += bottom - top;
            top = 0;
            bottom = 0;

            if (offsetY > constraintHeight) {
              return;
            }

            offsetY += style.lineSpacing! * textScaleFactor;
          }

          final baseline = span.baseline * textScaleFactor;
          top = math.min(top, baseline);
          bottom = math.max(bottom, ws.height + baseline);

          ws.offset = PdfPoint(offsetX, -offsetY + baseline);
          _spans.add(ws);
          spanCount++;

          _appendDecoration(
            spanCount > 1,
            _TextDecoration(
              style,
              annotation,
              _spans.length - 1,
              _spans.length - 1,
            ),
          );

          offsetX += ws.left + ws.width;
        }
      }
    }

    _buildLines();

    if (spanCount > 0) {
      lines.add(
        _Line(
          this,
          spanStart,
          spanCount,
          bottom,
          offsetX,
          _textDirection,
          false,
        ),
      );
      offsetY += bottom - top;
    }

    assert(!overflow || constraintWidth.isFinite);
    var width = overflow ? constraintWidth : constraints.minWidth;

    if (lines.isNotEmpty) {
      if (!overflow) {
        // Calculate the final width
        for (final line in lines) {
          width = math.max(width, line.wordsWidth);
        }
      }

      // Realign all the lines
      for (final line in lines) {
        line.realign(width);
      }
    }

    box = PdfRect(
      0,
      0,
      constraints.constrainWidth(width),
      constraints.constrainHeight(offsetY),
    );

    _context
      ..endOffset = offsetY - _context.startOffset
      ..spanEnd = _spans.length;

    if (_overflow != TextOverflow.span) {
      if (_overflow != TextOverflow.visible) {
        _mustClip = true;
      }
      return;
    }

    if (offsetY > constraintHeight + 0.0001) {
      _context.spanEnd -= lines.last.countSpan;
      _context.endOffset -= lines.last.height;
    }

    for (var index = 0; index < _decorations.length; index++) {
      final decoration = _decorations[index];
      if (decoration.startSpan >= _context.spanEnd ||
          decoration.endSpan < _context.spanStart) {
        _decorations.removeAt(index);
        index--;
      }
    }
  }

  @override
  void debugPaint(Context context) {
    context.canvas
      ..setStrokeColor(PdfColors.blue)
      ..setLineWidth(1)
      ..drawRect(
        box!.left,
        box!.bottom,
        box!.width == double.infinity ? 1000 : box!.width,
        box!.height == double.infinity ? 1000 : box!.height,
      )
      ..strokePath();
  }

  @override
  void paint(Context context) {
    super.paint(context);
    TextStyle? currentStyle;
    PdfColor? currentColor;

    if (_mustClip) {
      context.canvas
        ..saveContext()
        ..drawBox(box!)
        ..clipPath();
    }

    for (final decoration in _decorations) {
      assert(() {
        if (Document.debug && RichText.debug) {
          decoration.debugPaint(context, textScaleFactor, box!, _spans);
        }
        return true;
      }());

      decoration.backgroundPaint(context, textScaleFactor, box, _spans);
    }

    for (final span in _spans.sublist(_context.spanStart, _context.spanEnd)) {
      assert(() {
        if (Document.debug && RichText.debug) {
          span.debugPaint(context, textScaleFactor, box);
        }
        return true;
      }());

      if (span.style != currentStyle) {
        currentStyle = span.style;
        if (currentStyle.color != currentColor) {
          currentColor = currentStyle.color;
          context.canvas.setFillColor(currentColor);
        }
      }

      span.paint(
        context,
        currentStyle!,
        textScaleFactor,
        PdfPoint(box!.left, box!.top),
      );
    }

    for (final decoration in _decorations) {
      decoration.foregroundPaint(context, textScaleFactor, box, _spans);
    }

    if (_mustClip) {
      context.canvas.restoreContext();
    }
  }

  int _splitWord(String word, PdfFont font, TextStyle style, double maxWidth) {
    var low = 0;
    var high = word.length;
    var pos = (low + high) ~/ 2;

    while (low + 1 < high) {
      final metrics =
          font.stringMetrics(
            word.substring(0, pos),
            letterSpacing:
                style.letterSpacing! / (style.fontSize! * textScaleFactor),
          ) *
          (style.fontSize! * textScaleFactor);

      if (metrics.width > maxWidth) {
        high = pos;
      } else {
        low = pos;
      }

      pos = (low + high) ~/ 2;
    }

    return math.max(1, pos);
  }

  @override
  bool get canSpan => overflow == TextOverflow.span;

  @override
  bool get hasMoreWidgets => canSpan;

  @override
  void restoreContext(RichTextContext context) {
    _context.spanStart = context.spanEnd;
    _context.startOffset = -context.endOffset;
  }

  @override
  WidgetContext saveContext() {
    return _context;
  }
}

class Text extends RichText {
  Text(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    TextDirection? textDirection,
    bool? softWrap,
    bool tightBounds = false,
    double textScaleFactor = 1.0,
    int? maxLines,
    TextOverflow? overflow,
    Hyphenation? hyphenation,
    LineSplitter? lineSplitter,
  }) : super(
         text: TextSpan(text: text, style: style),
         textAlign: textAlign,
         softWrap: softWrap,
         tightBounds: tightBounds,
         textDirection: textDirection,
         textScaleFactor: textScaleFactor,
         maxLines: maxLines,
         overflow: overflow,
         hyphenation: hyphenation,
         lineSplitter: lineSplitter,
       );
}
