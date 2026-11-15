import 'package:flutter/material.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

String contractStatusLabel(BuildContext context, ContractStatus s) {
  final l = context.l10n;
  return switch (s) {
    ContractStatus.draft => l.cStatusDraft,
    ContractStatus.sent => l.cStatusSent,
    ContractStatus.signed => l.cStatusSigned,
    ContractStatus.active => l.cStatusActive,
    ContractStatus.completed => l.cStatusCompleted,
    ContractStatus.cancelled => l.cStatusCancelled,
  };
}

String contractKindLabel(BuildContext context, ContractKind k) {
  final l = context.l10n;
  return switch (k) {
    ContractKind.contract => l.kindContract,
    ContractKind.quote => l.kindQuote,
    ContractKind.amendment => l.kindAmendment,
  };
}

/// Contract statuses reuse the invoice palette, so the sidebar reads as one
/// system: signed/active green, sent blue, cancelled red, completed grey.
DisplayStatus _palette(ContractStatus s) => switch (s) {
  ContractStatus.draft => DisplayStatus.draft,
  ContractStatus.sent => DisplayStatus.sent,
  ContractStatus.signed || ContractStatus.active => DisplayStatus.paid,
  ContractStatus.completed => DisplayStatus.voided,
  ContractStatus.cancelled => DisplayStatus.overdue,
};

/// Colour + text status pill, like the invoice one (never colour alone).
class ContractStatusChip extends StatelessWidget {
  const ContractStatusChip(this.status, {super.key, this.dense = false});
  final ContractStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final p = _palette(status);
    final fg = c.statusFg[p]!;
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: dense ? 6 : 8,
        vertical: dense ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: c.statusBg[p],
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status.locks)
            Icon(Icons.lock_outline, size: dense ? 10 : 12, color: fg)
          else
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
          const SizedBox(width: 5),
          Text(
            contractStatusLabel(context, status),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: fg, height: 1.3),
          ),
        ],
      ),
    );
  }
}

/// Amber for unresolved variables, in both themes.
({Color bg, Color fg}) missingColors(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
    ? (bg: const Color(0xFF4A3A0A), fg: const Color(0xFFFFD27A))
    : (bg: const Color(0xFFFFE8A3), fg: const Color(0xFF7A4A00));

/// Clause text with `{{variables}}` drawn as chips: teal when resolved
/// (showing the value), amber when missing (showing the name).
class VariableText extends StatelessWidget {
  const VariableText(
    this.text, {
    required this.resolver,
    super.key,
    this.style,
    this.maxLines,
  });

  final String text;
  final VariableResolver? resolver;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = style ?? theme.textTheme.bodyMedium!;
    final amber = missingColors(context);
    final spans = <InlineSpan>[];
    var at = 0;
    for (final m in variablePattern.allMatches(text)) {
      if (m.start > at) spans.add(TextSpan(text: text.substring(at, m.start)));
      final name = m.group(1)!;
      final value = resolver?.resolve(name);
      final missing = value == null;
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Tooltip(
            message: '{{$name}}',
            child: Container(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 1),
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 5,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: missing
                    ? amber.bg
                    : theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.7,
                      ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                missing ? name : value,
                style: base.copyWith(
                  fontSize: (base.fontSize ?? 14) - 1,
                  color: missing
                      ? amber.fg
                      : theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );
      at = m.end;
    }
    if (at < text.length) spans.add(TextSpan(text: text.substring(at)));
    return Text.rich(
      TextSpan(style: base, children: spans),
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
    );
  }
}

/// `{{` autocomplete: when the caret sits after an unclosed `{{`, offers
/// known variable names; picking one completes `{{name}}`.
class VariableAutocomplete {
  const VariableAutocomplete._();

  /// The partial name being typed, or null when not inside `{{…`.
  static String? partialAt(TextEditingValue v) {
    final caret = v.selection.baseOffset;
    if (caret < 0 || caret > v.text.length) return null;
    final before = v.text.substring(0, caret);
    final open = before.lastIndexOf('{{');
    if (open < 0) return null;
    final tail = before.substring(open + 2);
    if (tail.contains('}}') || tail.contains('\n')) return null;
    if (!RegExp(r'^\s*[A-Za-z0-9_.]*$').hasMatch(tail)) return null;
    return tail.trim();
  }

  static TextEditingValue complete(TextEditingValue v, String name) {
    final caret = v.selection.baseOffset;
    final open = v.text.substring(0, caret).lastIndexOf('{{');
    var after = v.text.substring(caret);
    // Swallow a closing `}}` that is already there.
    final close = RegExp(r'^[A-Za-z0-9_.]*\s*\}\}').firstMatch(after);
    if (close != null) after = after.substring(close.end);
    final insert = '{{$name}}';
    final text = v.text.substring(0, open) + insert + after;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: open + insert.length),
    );
  }
}

/// Small "اختياري" tag.
class OptionalTag extends StatelessWidget {
  const OptionalTag({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        context.l10n.optionalTag,
        style: theme.textTheme.labelSmall?.copyWith(
          color: context.colors.muted,
        ),
      ),
    );
  }
}
