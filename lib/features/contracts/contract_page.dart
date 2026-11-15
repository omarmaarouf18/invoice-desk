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
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/theme/app_theme.dart';
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
    final missing = ref.watch(openMissingProvider);
    final a = ContractActions(ref, context);
    final preview = ref.watch(previewTabProvider);
    final amber = missingColors(context);
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
            TextButton(
              onPressed: () => unawaited(a.open(parent.id)),
              child: Text(l.amendmentOf(parent.number)),
            ),
          ],
          const SizedBox(width: Space.m),
          SaveIndicator(status: st.status),
          const SizedBox(width: Space.m),
          if (missing.isNotEmpty)
            Tooltip(
              message: missing.join('، '),
              child: ActionChip(
                key: const ValueKey('missing-variables'),
                backgroundColor: amber.bg,
                side: BorderSide.none,
                avatar: Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: amber.fg,
                ),
                label: Text(
                  l.missingVariables(missing.length),
                  style: theme.textTheme.labelMedium?.copyWith(color: amber.fg),
                ),
                onPressed: () => ref
                    .read(contractProvider.notifier)
                    .focusFirstMissing(missing),
              ),
            ),
          const Spacer(),
          if (!wide) ...[
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: false,
                  label: Tooltip(message: 'Ctrl+1', child: Text(l.tabEdit)),
                  icon: const Icon(Icons.edit_outlined, size: 16),
                ),
                ButtonSegment(
                  value: true,
                  label: Tooltip(message: 'Ctrl+2', child: Text(l.tabPreview)),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                ),
              ],
              selected: {preview},
              onSelectionChanged: (s) =>
                  ref.read(previewTabProvider.notifier).set(s.first),
            ),
            const SizedBox(width: Space.s + 4),
          ],
          Tooltip(
            message: '${l.save} (Ctrl+S)',
            child: OutlinedButton(
              onPressed: () =>
                  unawaited(ref.read(contractProvider.notifier).flush()),
              child: Text(l.save),
            ),
          ),
          const SizedBox(width: Space.s),
          Tooltip(
            message: '${l.exportPdfLong} (Ctrl+E)',
            child: FilledButton.icon(
              onPressed: () => unawaited(a.exportPdf()),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: Text(l.exportPdf),
            ),
          ),
          const SizedBox(width: Space.xs),
          MenuAnchor(
            builder: (context, controller, _) => IconButton(
              key: const ValueKey('contract-more'),
              tooltip: l.more,
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
              icon: const Icon(Icons.more_horiz),
            ),
            menuChildren: [
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
              MenuItemButton(
                leadingIcon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
                onPressed: () => unawaited(a.delete()),
                child: Text(
                  l.menuDelete,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
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
    setState(() => _build = (_) => buildContractPdf(data, fonts));
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
      ..listen(pdfFontsProvider, (_, _) => _schedule());
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PdfPreview(
        build: build,
        useActions: false,
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        maxPageWidth: 820,
        padding: const EdgeInsets.all(Space.l),
        previewPageMargin: const EdgeInsets.only(bottom: Space.m),
        scrollViewDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
        ),
        pdfPreviewPageDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: context.colors.border),
        ),
        loadingWidget: const SizedBox.shrink(),
      ),
    );
  }
}
