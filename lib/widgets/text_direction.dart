import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A letter, the only thing that decides the direction of a text.
final _letter = RegExp(r'\p{L}', unicode: true);

/// The letters that are read from the right.
final _rtlLetter = RegExp(
  r'[\p{Script=Hebrew}\p{Script=Arabic}\p{Script=Syriac}\p{Script=Thaana}'
  r'\p{Script=Nko}\p{Script=Samaritan}\p{Script=Mandaic}]',
  unicode: true,
);

/// The direction of the first strong character in [text].
///
/// Null when the text has no strong character: it is empty, or it holds
/// only digits, punctuation and spaces. A number never decides, so
/// "12 invoices" is read from the left and "١٢ فاتورة" from the right
/// because of the word after the number, not because of the number.
TextDirection? directionOfText(String text) {
  for (final match in _letter.allMatches(text)) {
    return _rtlLetter.hasMatch(match.group(0)!)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
  return null;
}

/// A text field that is read in the direction of its content.
///
/// The direction is taken from the first strong character of the text and
/// falls back to the interface direction while the text is empty. An
/// explicit [textDirection] wins, for the fields that hold a number, a
/// code, a date or a time.
///
/// The field is also scrolled to the start of its text, so a value written
/// in the other direction is shown from its beginning and not from its
/// end: an Arabic line in an English screen used to be cut at its first
/// word, because the paragraph was laid out from the left.
class ContentTextField extends StatefulWidget {
  const ContentTextField({
    required this.controller,
    super.key,
    this.focusNode,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.decoration,
    this.style,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;

  /// An explicit direction; it wins over the content.
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final InputDecoration? decoration;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<ContentTextField> createState() => _ContentTextFieldState();
}

class _ContentTextFieldState extends State<ContentTextField> {
  final ScrollController _scroll = ScrollController();

  /// Whether the field (or something inside it) has the focus.
  bool _focused = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// The direction the text is read in.
  TextDirection _direction(BuildContext context, String text) =>
      widget.textDirection ??
      directionOfText(text) ??
      Directionality.of(context);

  /// Puts the start of the text in view.
  ///
  /// A right-to-left text is laid out from the right, so its start is at
  /// the far end of the scroll; a left-to-right one starts at the near
  /// end. While the field has the focus the caret rules, and the view is
  /// left where it is.
  void _scrollToStart(TextDirection direction) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _focused || !_scroll.hasClients) return;
      final position = _scroll.position;
      final target = direction == TextDirection.rtl
          ? position.maxScrollExtent
          : 0.0;
      if ((position.pixels - target).abs() > 0.5) _scroll.jumpTo(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder: (context, value, _) {
        final direction = _direction(context, value.text);
        _scrollToStart(direction);
        return Focus(
          // The node only watches: the field itself takes the focus.
          canRequestFocus: false,
          onFocusChange: (focused) => _focused = focused,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            textDirection: direction,
            textAlign: widget.textAlign,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            inputFormatters: widget.inputFormatters,
            style: widget.style,
            scrollController: _scroll,
            decoration: widget.decoration,
          ),
        );
      },
    );
  }
}
