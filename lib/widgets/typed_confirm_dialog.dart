import 'package:flutter/material.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/text_direction.dart';

/// A destructive confirmation: the button stays disabled until [expected]
/// is typed exactly (surrounding spaces ignored). True when confirmed.
Future<bool> showTypedConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String expected,
  required String confirmLabel,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => _TypedConfirm(
        title: title,
        body: body,
        expected: expected,
        confirmLabel: confirmLabel,
      ),
    ) ??
    false;

class _TypedConfirm extends StatefulWidget {
  const _TypedConfirm({
    required this.title,
    required this.body,
    required this.expected,
    required this.confirmLabel,
  });

  final String title;
  final String body;
  final String expected;
  final String confirmLabel;

  @override
  State<_TypedConfirm> createState() => _TypedConfirmState();
}

class _TypedConfirmState extends State<_TypedConfirm> {
  final _typed = TextEditingController();

  bool get _matches => _typed.text.trim() == widget.expected.trim();

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  void _confirm() {
    if (_matches) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.body),
            const SizedBox(height: Space.s + 4),
            ContentTextField(
              key: const ValueKey('typed-confirm'),
              controller: _typed,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _confirm(),
              decoration: InputDecoration(hintText: widget.expected),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('typed-confirm-button'),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          onPressed: _matches ? _confirm : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
