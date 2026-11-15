import 'package:flutter/material.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart' show newId;
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// Create or edit a client. Returns the edited client, or null on cancel.
/// When editing, [onDelete] adds a "حذف العميل" button; it closes the dialog
/// and then runs.
Future<Client?> showClientDialog(
  BuildContext context, {
  Client? client,
  VoidCallback? onDelete,
}) => showDialog<Client>(
  context: context,
  builder: (_) => _ClientDialog(client: client, onDelete: onDelete),
);

class _ClientDialog extends StatefulWidget {
  const _ClientDialog({this.client, this.onDelete});
  final Client? client;
  final VoidCallback? onDelete;

  @override
  State<_ClientDialog> createState() => _ClientDialogState();
}

class _ClientDialogState extends State<_ClientDialog> {
  late final _name = TextEditingController(text: widget.client?.name);
  late final _contact = TextEditingController(text: widget.client?.contact);
  late final _city = TextEditingController(text: widget.client?.city);
  late final _phone = TextEditingController(text: widget.client?.phone);
  late final _email = TextEditingController(text: widget.client?.email);
  bool _showError = false;

  @override
  void dispose() {
    for (final c in [_name, _contact, _city, _phone, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().isEmpty) {
      setState(() => _showError = true);
      return;
    }
    final base = widget.client ?? Client(id: newId(), name: '');
    Navigator.of(context).pop(
      base.copyWith(
        name: _name.text.trim(),
        contact: _contact.text.trim(),
        city: _city.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget field(
      TextEditingController c,
      String label, {
      bool autofocus = false,
      String? error,
      TextDirection? dir,
      TextInputType? type,
    }) => Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.m - 4),
      child: TextField(
        controller: c,
        autofocus: autofocus,
        textDirection: dir,
        keyboardType: type,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) => _submit(),
        onChanged: error == null
            ? null
            : (_) => setState(() => _showError = false),
        decoration: InputDecoration(labelText: label, errorText: error),
      ),
    );

    return AlertDialog(
      title: Text(
        widget.client == null ? l.clientDialogNew : l.clientDialogEdit,
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            field(
              _name,
              l.clientName,
              autofocus: true,
              error: _showError ? l.errClientName : null,
            ),
            field(_contact, l.clientContact),
            field(_city, l.clientCity),
            Row(
              children: [
                Expanded(
                  child: field(
                    _phone,
                    l.clientPhone,
                    dir: TextDirection.ltr,
                    type: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: Space.s + 4),
                Expanded(
                  child: field(
                    _email,
                    l.clientEmail,
                    dir: TextDirection.ltr,
                    type: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (widget.client != null && widget.onDelete != null)
          TextButton.icon(
            key: const ValueKey('client-dialog-delete'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDelete!();
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: Text(l.menuDeleteClient),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.save)),
      ],
    );
  }
}
