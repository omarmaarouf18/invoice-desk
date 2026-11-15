import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// "عقد جديد": client, template (as cards), title, project name.
Future<NewContractRequest?> showNewContractSheet(
  BuildContext context, {
  String? clientId,
}) => showDialog<NewContractRequest>(
  context: context,
  builder: (_) => _NewContractSheet(clientId: clientId),
);

class _NewContractSheet extends ConsumerStatefulWidget {
  const _NewContractSheet({this.clientId});
  final String? clientId;

  @override
  ConsumerState<_NewContractSheet> createState() => _NewContractSheetState();
}

class _NewContractSheetState extends ConsumerState<_NewContractSheet> {
  late String? _clientId = widget.clientId;
  String? _templateId;
  final _title = TextEditingController();
  final _project = TextEditingController();
  bool _tried = false;

  @override
  void dispose() {
    _title.dispose();
    _project.dispose();
    super.dispose();
  }

  void _submit(List<ClauseTemplate> templates) {
    final t = templates.where((x) => x.id == _templateId).firstOrNull;
    if (_clientId == null || t == null) {
      setState(() => _tried = true);
      return;
    }
    Navigator.of(context).pop(
      NewContractRequest(
        clientId: _clientId!,
        template: t,
        title: _title.text,
        projectName: _project.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final clients = [
      for (final c in ref.watch(clientsProvider).value ?? const <Client>[])
        if (!c.archived || c.id == _clientId) c,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final templates = [
      for (final t
          in ref.watch(libraryProvider).value ?? const <ClauseTemplate>[])
        if (!t.archived) t,
    ];
    _templateId ??= templates.firstOrNull?.id;

    return AlertDialog(
      title: Text(l.newContractTitle),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ClientField(
                clients: clients,
                clientId: _clientId,
                missing: _tried && _clientId == null,
                onSelected: (id) => setState(() => _clientId = id),
              ),
              const SizedBox(height: Space.m),
              Text(l.chooseTemplate, style: theme.textTheme.titleSmall),
              const SizedBox(height: Space.s),
              if (templates.isEmpty)
                Text(l.noTemplates, style: theme.textTheme.bodySmall)
              else
                _TemplatePicker(
                  templates: templates,
                  selectedId: _templateId,
                  onSelect: (id) => setState(() => _templateId = id),
                ),
              const SizedBox(height: Space.m),
              TextField(
                controller: _title,
                autofocus: widget.clientId != null,
                decoration: InputDecoration(
                  labelText: l.contractTitle,
                  hintText: l.contractTitleHint,
                ),
                onSubmitted: (_) => _submit(templates),
              ),
              const SizedBox(height: Space.m - 4),
              TextField(
                controller: _project,
                decoration: InputDecoration(labelText: l.projectName),
                onSubmitted: (_) => _submit(templates),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const ValueKey('create-contract'),
          onPressed: templates.isEmpty ? null : () => _submit(templates),
          child: Text(l.create),
        ),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.selected,
    required this.onTap,
  });

  final ClauseTemplate template;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final always = template.clauses.where((c) => !c.optional).length;
    final optional = template.clauses.length - always;
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(Space.radiusSmall),
        onTap: onTap,
        child: AnimatedContainer(
          duration: motion(context),
          width: 268,
          padding: const EdgeInsets.all(Space.m - 4),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primaryContainer.withValues(alpha: 0.5)
                : null,
            borderRadius: BorderRadius.circular(Space.radiusSmall),
            border: Border.all(
              color: selected ? scheme.primary : context.colors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    template.kind == TemplateKind.quote
                        ? Icons.request_quote_outlined
                        : Icons.gavel_outlined,
                    size: 18,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    child: Text(
                      template.name,
                      style: theme.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (selected)
                    Icon(Icons.check_circle, size: 18, color: scheme.primary),
                ],
              ),
              const SizedBox(height: Space.xs),
              Text(
                [
                  contractKindLabel(
                    context,
                    template.kind == TemplateKind.quote
                        ? ContractKind.quote
                        : ContractKind.contract,
                  ),
                  l.clauseCount(always),
                  if (optional > 0) '+$optional ${l.optionalTag}',
                ].join(' · '),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Template cards; one is always selected.
class _TemplatePicker extends StatelessWidget {
  const _TemplatePicker({
    required this.templates,
    required this.selectedId,
    required this.onSelect,
  });
  final List<ClauseTemplate> templates;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Space.s,
      runSpacing: Space.s,
      children: [
        for (final t in templates)
          _TemplateCard(
            template: t,
            selected: t.id == selectedId,
            onTap: () => onSelect(t.id),
          ),
      ],
    );
  }
}

class _ClientField extends StatelessWidget {
  const _ClientField({
    required this.clients,
    required this.clientId,
    required this.missing,
    required this.onSelected,
  });
  final List<Client> clients;
  final String? clientId;
  final bool missing;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return DropdownMenu<String>(
      key: const ValueKey('new-contract-client'),
      width: 560,
      initialSelection: clientId,
      enableFilter: true,
      requestFocusOnTap: true,
      label: Text(l.client),
      hintText: l.chooseClient,
      errorText: missing ? l.errMissingClient : null,
      menuHeight: 320,
      dropdownMenuEntries: [
        for (final c in clients) DropdownMenuEntry(value: c.id, label: c.name),
      ],
      onSelected: onSelected,
    );
  }
}
