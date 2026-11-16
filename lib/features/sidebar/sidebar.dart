import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/contracts/contract_actions.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/sidebar/sidebar_model.dart';
import 'package:invoice_desk/features/sidebar/sidebar_providers.dart';
import 'package:invoice_desk/features/trash/trash_view.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

part 'sidebar/search_field.dart';
part 'sidebar/filter_bar.dart';
part 'sidebar/client_list.dart';
part 'sidebar/client_group_tile.dart';
part 'sidebar/document_rows.dart';

/// Two document buttons share the sidebar width; tighter padding keeps
/// "فاتورة جديدة" on one line.
final _compact = ButtonStyle(
  padding: WidgetStateProperty.all(
    const EdgeInsetsDirectional.symmetric(horizontal: 12),
  ),
);

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarHeader(),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: Space.m),
            child: _SearchField(),
          ),
          SizedBox(height: Space.s + 4),
          _NewDocumentButtons(),
          SizedBox(height: Space.s + 4),
          _FilterChips(),
          SizedBox(height: Space.s),
          _SummaryStrip(),
          Divider(),
          Expanded(child: _ClientList()),
        ],
      ),
    );
  }
}

/// App title, new client, and the profile (settings) toggle.
class _SidebarHeader extends ConsumerWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = AppActions(ref, context);
    final onSettings = ref.watch(workspaceProvider) == Workspace.settings;
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.m,
        Space.m,
        Space.s,
        Space.s,
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: Space.s),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                l.sidebarTitle,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          IconButton(
            tooltip: '${l.newClient} (Ctrl+Shift+N)',
            onPressed: () => unawaited(actions.newClient()),
            icon: const Icon(Icons.person_add_alt, size: 20),
          ),
          Tooltip(
            message: l.myProfile,
            child: TextButton.icon(
              style: onSettings
                  ? TextButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                    )
                  : null,
              onPressed: () => ref
                  .read(workspaceProvider.notifier)
                  .show(
                    onSettings ? Workspace.invoice : Workspace.settings,
                  ),
              icon: const Icon(Icons.person_outline, size: 18),
              label: Text(l.myProfile),
            ),
          ),
        ],
      ),
    );
  }
}

/// "فاتورة جديدة" and "عقد جديد".
class _NewDocumentButtons extends ConsumerWidget {
  const _NewDocumentButtons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = AppActions(ref, context);
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.m),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: '${l.newInvoice} (Ctrl+N)',
              child: FilledButton.icon(
                style: _compact,
                onPressed: actions.newInvoice,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.newInvoice),
              ),
            ),
          ),
          const SizedBox(width: Space.s),
          Expanded(
            child: Tooltip(
              message: '${l.newContract} (Ctrl+Shift+K)',
              child: FilledButton.tonalIcon(
                key: const ValueKey('sidebar-new-contract'),
                style: _compact,
                onPressed: () => unawaited(
                  ContractActions(ref, context).newContract(),
                ),
                icon: const Icon(Icons.gavel_outlined, size: 18),
                label: Text(l.newContract),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
