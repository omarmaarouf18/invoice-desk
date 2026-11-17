import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/contracts/contract_actions.dart';
import 'package:invoice_desk/features/contracts/contract_cards.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/features/editor/editor_page.dart'
    show SaveIndicator, sideBySideWidth;
import 'package:invoice_desk/features/pdf_render.dart';
import 'package:invoice_desk/features/preview/pdf_pages_view.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/editor_chrome.dart';
import 'package:printing/printing.dart';

/// The contract editor: same shell as the invoice editor (autosave, edit /
/// preview tabs, live PDF beside it when wide).
class ContractPage extends ConsumerWidget {
  const ContractPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(contractProvider.select((s) => s.contract?.id));
    if (id == null) return const SizedBox.shrink();
    final wide = MediaQuery.sizeOf(context).width >= sideBySideWidth;
    final preview = ref.watch(previewTabProvider);
    final body = _Body(key: ValueKey(id));
    return Column(
      children: [
        _TopBar(wide: wide),
        const Divider(),
        Expanded(
          child: wide
              ? Row(
                  children: [
                    Expanded(flex: 11, child: body),
                    const VerticalDivider(width: 1),
                    const Expanded(flex: 8, child: ContractPreviewPane()),
                  ],
                )
              : IndexedStack(
                  index: preview ? 1 : 0,
                  children: [
                    body,
                    if (preview)
                      const ContractPreviewPane()
                    else
                      const SizedBox(),
                  ],
                ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.l,
            Space.l,
            Space.l,
            Space.xl * 2,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LockBanner(),
                  ContractDetailsCard(),
                  SizedBox(height: Space.m),
                  VariablesCard(),
                  SizedBox(height: Space.m),
                  ClausesCard(),
                  SizedBox(height: Space.m),
                  ScopeAnnexCard(),
                  SizedBox(height: Space.m),
                  PaymentAnnexCard(),
                  SizedBox(height: Space.m),
                  LinkedInvoicesCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.wide});
  final bool wide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final st = ref.watch(contractProvider);
    final c = st.contract!;
    final a = ContractActions(ref, context);
    final parent = c.parentId == null
        ? null
        : (ref.watch(contractsProvider).value ?? const <Contract>[])
              .where((x) => x.id == c.parentId)
              .firstOrNull;
    return Container(
      height: 64,
      color: theme.colorScheme.surface,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Space.l),
      child: Row(
        children: [
          Flexible(
            child: Text(
              c.number.isEmpty ? '—' : c.number,
              textDirection: TextDirection.ltr,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: Space.s + 4),
          ContractStatusChip(c.status),
          if (parent != null) ...[
            const SizedBox(width: Space.s),
            Flexible(
              child: TextButton(
                onPressed: () => unawaited(a.open(parent.id)),
                child: Text(
                  l.amendmentOf(parent.number),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
          const SizedBox(width: Space.m),
          SaveIndicator(status: st.status),
          const SizedBox(width: Space.m),
          const _MissingChip(),
          const Spacer(),
          if (!wide) ...[
            const EditPreviewTabs(),
            const SizedBox(width: Space.s + 4),
          ],
          SaveExportButtons(
            onSave: () =>
                unawaited(ref.read(contractProvider.notifier).flush()),
            onExport: () => unawaited(a.exportPdf()),
          ),
          const SizedBox(width: Space.xs),
          _ContractMenu(contract: c),
        ],
      ),
    );
  }
}

/// "N متغيرات ناقصة": jumps to the first missing variable.
class _MissingChip extends ConsumerWidget {
  const _MissingChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missing = ref.watch(openMissingProvider);
    if (missing.isEmpty) return const SizedBox.shrink();
    final amber = missingColors(context);
    return Tooltip(
      message: missing.join('، '),
      child: ActionChip(
        key: const ValueKey('missing-variables'),
        backgroundColor: amber.bg,
        side: BorderSide.none,
        avatar: Icon(Icons.warning_amber_rounded, size: 16, color: amber.fg),
        label: Text(
          context.l10n.missingVariables(missing.length),
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: amber.fg),
        ),
        onPressed: () =>
            ref.read(contractProvider.notifier).focusFirstMissing(missing),
      ),
    );
  }
}

class _ContractMenu extends ConsumerWidget {
  const _ContractMenu({required this.contract});
  final Contract contract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = contract;
    final a = ContractActions(ref, context);
    return MoreMenu(
      children: [
        if (!c.isAmendment)
          MenuItemButton(
            leadingIcon: const Icon(Icons.copy_outlined, size: 18),
            shortcut: const SingleActivator(
              LogicalKeyboardKey.keyD,
              control: true,
            ),
            onPressed: () => unawaited(a.duplicate()),
            child: Text(l.duplicateContract),
          ),
        MenuItemButton(
          leadingIcon: const Icon(Icons.note_add_outlined, size: 18),
          onPressed: () => unawaited(a.amendment()),
          child: Text(l.createAmendment),
        ),
        if (c.status.locks)
          MenuItemButton(
            leadingIcon: Icon(
              c.unlocked ? Icons.lock_outline : Icons.lock_open_outlined,
              size: 18,
            ),
            onPressed: c.unlocked
                ? ref.read(contractProvider.notifier).relock
                : () => unawaited(a.unlock()),
            child: Text(c.unlocked ? l.relock : l.unlock),
          ),
        const Divider(),
        DeleteMenuItem(onPressed: () => unawaited(a.delete())),
      ],
    );
  }
}

/// The real contract PDF, re-rendered 300 ms after the last edit.
class ContractPreviewPane extends ConsumerStatefulWidget {
  const ContractPreviewPane({super.key});

  @override
  ConsumerState<ContractPreviewPane> createState() =>
      _ContractPreviewPaneState();
}

class _ContractPreviewPaneState extends ConsumerState<ContractPreviewPane> {
  static const _debounce = Duration(milliseconds: 300);

  Timer? _timer;
  LayoutCallback? _build;

  @override
  void initState() {
    super.initState();
    _snapshot();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _snapshot() {
    final c = ref.read(contractProvider).contract;
    final settings = ref.read(settingsProvider).value;
    final fonts = ref.read(pdfFontsProvider).value;
    if (c == null || settings == null || fonts == null) return;
    final clients = ref.read(clientsProvider).value ?? const <Client>[];
    final contracts = ref.read(contractsProvider).value ?? const <Contract>[];
    final data = ContractPdfData(
      contract: c,
      client: clients.where((x) => x.id == c.clientId).firstOrNull,
      settings: settings,
      parent: contracts.where((x) => x.id == c.parentId).firstOrNull,
    );
    final styles = ref.read(styleRepositoryProvider);
    setState(() => _build = (_) => renderContractPdf(styles, data, fonts));
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(_debounce, () {
      if (mounted) _snapshot();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(
        contractProvider.select((s) => s.revision),
        (_, _) => _schedule(),
      )
      ..listen(settingsProvider, (_, _) => _schedule())
      ..listen(clientsProvider, (_, _) => _schedule())
      ..listen(pdfFontsProvider, (_, _) => _schedule())
      ..listen(userStylesProvider, (_, _) => _schedule());
    final theme = Theme.of(context);
    final build = _build;
    if (build == null) {
      return Center(
        child: Text(
          context.l10n.previewLoading,
          style: theme.textTheme.bodySmall,
        ),
      );
    }
    return PdfPagesView(render: build);
  }
}
