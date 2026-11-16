import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/text_direction.dart';

String statusLabel(BuildContext context, DisplayStatus s) {
  final l = context.l10n;
  return switch (s) {
    DisplayStatus.draft => l.statusDraft,
    DisplayStatus.sent => l.statusSent,
    DisplayStatus.overdue => l.statusOverdue,
    DisplayStatus.paid => l.statusPaid,
    DisplayStatus.voided => l.statusVoid,
  };
}

/// Colour + text status pill (never colour alone).
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key, this.dense = false});
  final DisplayStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = c.statusFg[status]!;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: dense ? 6 : 8,
        vertical: dense ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: c.statusBg[status],
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            statusLabel(context, status),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: fg, height: 1.3),
          ),
        ],
      ),
    );
  }
}

/// A titled card on the 8 px grid with a 12 px radius and 1 px border.
class PanelCard extends StatelessWidget {
  const PanelCard({
    required this.title,
    required this.child,
    super.key,
    this.trailing,
    this.icon,
  });

  final String title;
  final Widget child;
  final Widget? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          Space.m,
          Space.s + 4,
          Space.m,
          Space.m,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The header keeps its height, but grows when the text is
            // large so the title is not cut in half.
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 36),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: Space.s),
                  ],
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  ?trailing,
                ],
              ),
            ),
            const SizedBox(height: Space.s),
            child,
          ],
        ),
      ),
    );
  }
}

/// Text field that owns its controller, reports every change, and only
/// accepts an external value while it is not focused (so typing is never
/// clobbered by the round trip through state).
class SyncedTextField extends StatefulWidget {
  const SyncedTextField({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.formatOnBlur,
    this.inputFormatters,
    this.style,
    this.dense = false,
    this.textInputAction,
    this.readOnly = false,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final int? maxLines;
  final int? minLines;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  /// Pretty form shown while unfocused (e.g. thousands separators).
  final String Function(String raw)? formatOnBlur;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final bool dense;
  final TextInputAction? textInputAction;

  /// Locked documents: selectable, not editable.
  final bool readOnly;

  @override
  State<SyncedTextField> createState() => _SyncedTextFieldState();
}

class _SyncedTextFieldState extends State<SyncedTextField> {
  late final TextEditingController _c;
  FocusNode? _ownFocus;
  FocusNode get _focus => widget.focusNode ?? (_ownFocus ??= FocusNode());

  String _display(String v) => !_focus.hasFocus && widget.formatOnBlur != null
      ? widget.formatOnBlur!(v)
      : v;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: _display(widget.value));
    _focus.addListener(_onFocus);
  }

  void _onFocus() {
    if (widget.formatOnBlur == null) return;
    final text = _focus.hasFocus
        ? widget.value
        : widget.formatOnBlur!(widget.value);
    if (_c.text != text) {
      _c.value = TextEditingValue(
        text: text,
        selection: _focus.hasFocus
            ? TextSelection(baseOffset: 0, extentOffset: text.length)
            : TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void didUpdateWidget(SyncedTextField old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownFocus)?.removeListener(_onFocus);
      _focus.addListener(_onFocus);
    }
    if (!_focus.hasFocus) {
      final text = _display(widget.value);
      if (_c.text != text) _c.text = text;
    }
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _ownFocus?.dispose();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentTextField(
      controller: _c,
      focusNode: _focus,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      style: widget.style,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        isDense: true,
        contentPadding: widget.dense
            ? const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 9)
            : null,
      ),
    );
  }
}

/// Text with every case/digit-insensitive occurrence of [query] highlighted.
class HighlightText extends StatelessWidget {
  const HighlightText(
    this.text, {
    required this.query,
    super.key,
    this.style,
    this.textDirection,
    this.maxLines = 1,
  });

  final String text;
  final String query;
  final TextStyle? style;
  final TextDirection? textDirection;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final q = foldForSearch(query.trim());
    final folded = foldForSearch(text);
    // Folding can change length (diacritics); highlight only when it did not.
    if (q.isEmpty || folded.length != text.length || !folded.contains(q)) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        textDirection: textDirection,
      );
    }
    final spans = <TextSpan>[];
    var start = 0;
    final bg = context.colors.highlight;
    while (true) {
      final i = folded.indexOf(q, start);
      if (i < 0) break;
      if (i > start) spans.add(TextSpan(text: text.substring(start, i)));
      spans.add(
        TextSpan(
          text: text.substring(i, i + q.length),
          style: TextStyle(backgroundColor: bg),
        ),
      );
      start = i + q.length;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
    return Text.rich(
      TextSpan(style: style, children: spans),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textDirection: textDirection,
    );
  }
}

/// Isolated LTR run inside RTL text (numbers, emails, IBANs).
class Ltr extends StatelessWidget {
  const Ltr(this.text, {super.key, this.style});
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: style, textDirection: TextDirection.ltr);
}

/// Duration honouring the platform's reduce-motion setting.
Duration motion(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context) ? Duration.zero : Space.motion;

/// The icon that follows the reading direction.
///
/// Material's mirrored icons (`chevron_left`, `arrow_back`, …) are mirrored
/// by Flutter itself. Icons that exist in a left-to-right and a
/// right-to-left variant are not, so they are picked here.
IconData directionalIcon(
  BuildContext context,
  IconData ltr,
  IconData rtl,
) => Directionality.of(context) == TextDirection.rtl ? rtl : ltr;
