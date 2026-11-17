import 'package:flutter/material.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart' show newId;
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/text_direction.dart';

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
  late final _legalName = TextEditingController(text: widget.client?.legalName);
  late final _registry = TextEditingController(text: widget.client?.registryNo);
  late final _address = TextEditingController(text: widget.client?.address);
  late final _rep = TextEditingController(text: widget.client?.representative);
  late final _repTitle = TextEditingController(
    text: widget.client?.representativeTitle,
  );
  late DocLanguage? _preferredLanguage = widget.client?.preferredLanguage;
  bool _showError = false;

  @override
  void dispose() {
    for (final c in [
      _name,
      _contact,
      _city,
      _phone,
      _email,
      _legalName,
      _registry,
      _address,
      _rep,
      _repTitle,
    ]) {
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
        legalName: _legalName.text.trim(),
        registryNo: _registry.text.trim(),
        address: _address.text.trim(),
        representative: _rep.text.trim(),
        representativeTitle: _repTitle.text.trim(),
        preferredLanguage: _preferredLanguage,
      ),
    );
  }

  _Field field(
    TextEditingController c,
    String label, {
    bool autofocus = false,
    String? error,
    TextDirection? dir,
    TextInputType? type,
  }) => _Field(
    controller: c,
    label: label,
    autofocus: autofocus,
    error: error,
    dir: dir,
    type: type,
    onSubmitted: _submit,
    onChanged: error == null ? null : () => setState(() => _showError = false),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(
        widget.client == null ? l.clientDialogNew : l.clientDialogEdit,
      ),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
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
              _Row(
                field(
                  _phone,
                  l.clientPhone,
                  dir: TextDirection.ltr,
                  type: TextInputType.phone,
                ),
                field(
                  _email,
                  l.clientEmail,
                  dir: TextDirection.ltr,
                  type: TextInputType.emailAddress,
                ),
              ),
              _LanguageField(
                value: _preferredLanguage,
                onChanged: (v) => setState(() => _preferredLanguage = v),
              ),
              _LegalSection(
                expanded:
                    (widget.client?.legalName.isNotEmpty ?? false) ||
                    (widget.client?.representative.isNotEmpty ?? false),
                children: [
                  field(_legalName, l.legalName),
                  field(_registry, l.clientRegistry),
                  field(_address, l.address),
                  _Row(
                    field(_rep, l.clientRepresentative),
                    field(_repTitle, l.clientRepresentativeTitle),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.client != null && widget.onDelete != null)
          _DeleteButton(onDelete: widget.onDelete!),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.save)),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.onSubmitted,
    this.autofocus = false,
    this.error,
    this.dir,
    this.type,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onSubmitted;
  final bool autofocus;
  final String? error;
  final TextDirection? dir;
  final TextInputType? type;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: Space.m - 4),
    child: ContentTextField(
      controller: controller,
      autofocus: autofocus,
      textDirection: dir,
      keyboardType: type,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) => onSubmitted(),
      onChanged: onChanged == null ? null : (_) => onChanged!(),
      decoration: InputDecoration(labelText: label, errorText: error),
    ),
  );
}

class _Row extends StatelessWidget {
  const _Row(this.a, this.b);
  final Widget a;
  final Widget b;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: a),
      const SizedBox(width: Space.s + 4),
      Expanded(child: b),
    ],
  );
}

/// "البيانات القانونية (للعقود)": collapsed unless already filled in.
class _LegalSection extends StatelessWidget {
  const _LegalSection({required this.expanded, required this.children});
  final bool expanded;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      key: const ValueKey('client-legal'),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      initiallyExpanded: expanded,
      title: Text(
        context.l10n.clientLegal,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      children: children,
    ),
  );
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onDelete});
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    key: const ValueKey('client-dialog-delete'),
    style: TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.error,
    ),
    onPressed: () {
      Navigator.of(context).pop();
      onDelete();
    },
    icon: const Icon(Icons.delete_outline, size: 18),
    label: Text(context.l10n.menuDeleteClient),
  );
}

class _LanguageField extends StatelessWidget {
  const _LanguageField({required this.value, required this.onChanged});
  final DocLanguage? value;
  final ValueChanged<DocLanguage?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.m - 4),
      child: DropdownButtonFormField<DocLanguage?>(
        key: const ValueKey('client-preferred-language'),
        initialValue: value,
        decoration: InputDecoration(labelText: l.clientPreferredLanguage),
        items: [
          DropdownMenuItem(
            child: Text(l.clientPreferredLanguageDefault),
          ),
          DropdownMenuItem(
            value: DocLanguage.ar,
            child: Text(l.docLanguageAr),
          ),
          DropdownMenuItem(
            value: DocLanguage.bilingual,
            child: Text(l.docLanguageBilingual),
          ),
          DropdownMenuItem(
            value: DocLanguage.en,
            child: Text(l.docLanguageEn),
          ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
