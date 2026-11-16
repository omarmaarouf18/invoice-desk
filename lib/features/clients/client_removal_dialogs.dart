import 'package:flutter/material.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/text_direction.dart';

enum ClientRemoval { archive, deleteAll }

/// Asked when the client still has live invoices. Archive is the default.
Future<ClientRemoval?> showClientHasInvoicesDialog(
  BuildContext context, {
  required Client client,
  required int invoiceCount,
  required MoneyBag unpaid,
  int contractCount = 0,
}) => showDialog<ClientRemoval>(
  context: context,
  builder: (context) {
    final l = context.l10n;
    final error = Theme.of(context).colorScheme.error;
    return AlertDialog(
      title: Text(l.clientHasInvoicesTitle(client.name)),
      content: SizedBox(
        width: 440,
        child: Text(
          contractCount == 0
              ? l.clientHasInvoicesBody(
                  l.invoiceCount(invoiceCount),
                  unpaid.format(),
                )
              : l.clientHasDocumentsBody(
                  l.invoiceCount(invoiceCount),
                  l.contractCount(contractCount),
                  unpaid.format(),
                ),
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('delete-client-and-invoices'),
          style: TextButton.styleFrom(foregroundColor: error),
          onPressed: () => Navigator.of(context).pop(ClientRemoval.deleteAll),
          child: Text(l.deleteClientAndInvoices),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const ValueKey('archive-client'),
          autofocus: true,
          onPressed: () => Navigator.of(context).pop(ClientRemoval.archive),
          child: Text(l.archiveRecommended),
        ),
      ],
    );
  },
);

/// The destructive step: the button stays disabled until the client's name
/// is typed exactly (surrounding spaces ignored). True when confirmed.
Future<bool> showConfirmDeleteAllDialog(
  BuildContext context, {
  required Client client,
  required int invoiceCount,
  int contractCount = 0,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDeleteAll(
        client: client,
        invoiceCount: invoiceCount,
        contractCount: contractCount,
      ),
    ) ??
    false;

class _ConfirmDeleteAll extends StatefulWidget {
  const _ConfirmDeleteAll({
    required this.client,
    required this.invoiceCount,
    required this.contractCount,
  });
  final Client client;
  final int invoiceCount;
  final int contractCount;

  @override
  State<_ConfirmDeleteAll> createState() => _ConfirmDeleteAllState();
}

class _ConfirmDeleteAllState extends State<_ConfirmDeleteAll> {
  final _typed = TextEditingController();

  bool get _matches => _typed.text.trim() == widget.client.name.trim();

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
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(l.confirmDeleteAllTitle(widget.client.name)),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.contractCount == 0
                  ? l.confirmDeleteAllBody(l.invoiceCount(widget.invoiceCount))
                  : l.confirmDeleteDocumentsBody(
                      l.andJoin(
                        l.invoiceCount(widget.invoiceCount),
                        l.contractCount(widget.contractCount),
                      ),
                    ),
            ),
            const SizedBox(height: Space.s + 4),
            ContentTextField(
              key: const ValueKey('confirm-client-name'),
              controller: _typed,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _confirm(),
              decoration: InputDecoration(
                labelText: l.clientName,
                hintText: widget.client.name,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l.cancel),
        ),
        FilledButton(
          key: const ValueKey('confirm-delete-all'),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.error,
            foregroundColor: scheme.onError,
          ),
          onPressed: _matches ? _confirm : null,
          child: Text(l.deleteClientAndInvoices),
        ),
      ],
    );
  }
}
