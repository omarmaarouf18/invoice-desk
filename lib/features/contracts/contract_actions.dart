import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/data/daos/contracts_dao.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/features/contracts/new_contract_sheet.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:path/path.dart' as p;

/// User-facing contract actions, shared by the top bar, menus and shortcuts.
class ContractActions {
  ContractActions(this.ref, this.context);
  final WidgetRef ref;
  final BuildContext context;

  AppLocalizations get l => context.l10n;
  ContractController get ctl => ref.read(contractProvider.notifier);
  String? get currentId => ref.read(contractProvider).contract?.id;

  /// "عقد جديد" (Ctrl+Shift+K).
  Future<void> newContract({String? clientId}) async {
    final req = await showNewContractSheet(context, clientId: clientId);
    if (req == null) return;
    await ref.read(editorProvider.notifier).flush();
    await ctl.create(req);
  }

  Future<void> open(String id) => ctl.open(id);

  /// Status change; blocked (with a message) while variables are missing.
  void setStatus(ContractStatus s) {
    final r = ctl.setStatus(s, missing: ref.read(openMissingProvider));
    if (r is StatusBlocked) {
      showSnack(
        l.statusBlocked(
          contractStatusLabel(context, s),
          l.missingVariables(r.missing.length),
        ),
        actions: [
          (l.cardVariables, () => ctl.focusFirstMissing(r.missing)),
        ],
      );
    }
  }

  Future<void> unlock() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.unlockTitle),
        content: SizedBox(width: 440, child: Text(l.unlockBody)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            key: const ValueKey('confirm-unlock'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.unlock),
          ),
        ],
      ),
    );
    if (ok ?? false) ctl.unlock();
  }

  Future<void> amendment([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return;
    final l = this.l;
    final a = await ctl.createAmendment(
      target,
      preamble: l.amendmentPreamble,
      clauseTitle: l.amendmentClauseTitle,
    );
    if (a != null) showSnack(l.amendmentCreated(a.number));
  }

  Future<void> duplicate([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return;
    final l = this.l;
    final c = await ctl.duplicate(target);
    if (c != null) showSnack(l.contractDuplicated(c.number));
  }

  /// Soft delete with Undo; refused (with a dialog offering "ملغي") when
  /// invoices are linked.
  Future<void> delete([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return;
    final l = this.l;
    final ctl = this.ctl;
    try {
      final r = await ctl.delete(target);
      if (r == null) return;
      showSnack(
        l.contractDeleted(r.number),
        duration: const Duration(seconds: 8),
        actions: [(l.undo, () => unawaited(ctl.undoDelete(target, r.stamp)))],
      );
    } on ContractHasInvoices catch (e) {
      if (!context.mounted) return;
      final c = await ref.read(databaseProvider).contractsDao.getById(target);
      if (c == null || !context.mounted) return;
      final cancel = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.contractHasInvoicesTitle(c.number)),
          content: SizedBox(
            width: 440,
            child: Text(l.contractHasInvoicesBody(l.invoiceCount(e.count))),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.cancel),
            ),
            if (c.status != ContractStatus.cancelled)
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l.cancelContract),
              ),
          ],
        ),
      );
      if (cancel ?? false) {
        await ctl.open(target);
        setStatus(ContractStatus.cancelled);
      }
    }
  }

  Future<void> createInvoice(PaymentMilestone m) async {
    final l = this.l;
    final number = await ctl.createInvoiceFromMilestone(m.id);
    if (number == null) return showSnack(l.milestoneNeedsAmount);
    showSnack(
      l.invoiceCreatedFromMilestone(number, m.label),
      actions: [(l.menuOpen, () => unawaited(_openInvoiceNumber(number)))],
    );
  }

  Future<void> _openInvoiceNumber(String number) async {
    final all = await ref.read(databaseProvider).invoicesDao.getAll();
    final inv = all.where((i) => i.number == number).firstOrNull;
    if (inv != null) await openInvoice(inv.id);
  }

  Future<void> openInvoice(String id) async {
    await ctl.flush();
    await ref.read(editorProvider.notifier).open(id);
  }

  // ── Clause library round trips ─────────────────────────────────────
  Future<void> restoreClause(ContractClause x) async {
    final l = this.l;
    final libId = x.fromLibraryClauseId;
    final lib = libId == null
        ? null
        : await ref.read(databaseProvider).libraryDao.clauseById(libId);
    if (lib == null) return showSnack(l.restoreMissing);
    if (lib.title == x.title && lib.body == x.body) {
      return showSnack(l.restoreSame);
    }
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _DiffDialog(
        before: '${x.title}\n${x.body}',
        after: '${lib.title}\n${lib.body}',
      ),
    );
    if (ok ?? false) ctl.restoreClause(x.id, lib);
  }

  Future<void> saveClauseToLibrary(ContractClause x) async {
    final l = this.l;
    final libId = x.fromLibraryClauseId;
    if (libId == null) return showSnack(l.restoreMissing);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.saveToLibraryTitle),
        content: SizedBox(
          width: 440,
          child: Text(l.saveToLibraryBody(x.title)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            key: const ValueKey('confirm-save-to-library'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.saveToLibrary),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    await ref
        .read(databaseProvider)
        .libraryDao
        .updateClauseText(libId, title: x.title, body: x.body);
    showSnack(l.savedToLibrary);
  }

  /// "+ بند" → "من المكتبة…": a searchable picker over every template.
  Future<void> addFromLibrary({String? afterId}) async {
    final picked = await showDialog<LibraryClause>(
      context: context,
      builder: (_) => const _LibraryPicker(),
    );
    if (picked != null) ctl.addClause(from: picked, afterId: afterId);
  }

  Future<void> exportPdf() async {
    final l = this.l;
    final c = ref.read(contractProvider).contract;
    if (c == null) return showSnack(l.nothingOpen);
    await ctl.flush();
    final db = ref.read(databaseProvider);
    final client = (await db.clientsDao.getAll())
        .where((x) => x.id == c.clientId)
        .firstOrNull;
    final settings = await db.settingsDao.get();
    final parent = c.parentId == null
        ? null
        : await db.contractsDao.getById(c.parentId!);
    final fonts = await ref.read(pdfFontsProvider.future);
    final prefs = ref.read(uiPrefsProvider);
    final location = await getSaveLocation(
      suggestedName: contractFileName(c, client),
      initialDirectory: prefs.lastExportDir,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'PDF', extensions: ['pdf']),
      ],
    );
    if (location == null) return;
    var path = location.path;
    if (!path.toLowerCase().endsWith('.pdf')) path = '$path.pdf';
    try {
      final bytes = await buildContractPdf(
        ContractPdfData(
          contract: c,
          client: client,
          settings: settings,
          parent: parent,
        ),
        fonts,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    } on Object catch (e) {
      debugPrint('contract export failed: $e');
      return showSnack(l.exportFailed);
    }
    prefs.lastExportDir = p.dirname(path);
    showSnack(
      l.exportedPdf(p.basename(path)),
      duration: const Duration(seconds: 8),
      actions: [
        (l.openFile, () => openPath(path)),
        (l.openFolder, () => openPath(p.dirname(path))),
      ],
    );
  }
}

class _DiffDialog extends StatelessWidget {
  const _DiffDialog({required this.before, required this.after});
  final String before;
  final String after;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final err = theme.colorScheme.error;
    final ok = context.colors.statusFg.values.first;
    return AlertDialog(
      title: Text(l.restoreTitle),
      content: SizedBox(
        width: 620,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.restoreBody, style: theme.textTheme.bodySmall),
            const SizedBox(height: Space.s),
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.border),
                  borderRadius: BorderRadius.circular(Space.radiusSmall),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Space.s),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (op, line) in lineDiff(before, after))
                        Container(
                          color: switch (op) {
                            DiffOp.removed => err.withValues(alpha: 0.10),
                            DiffOp.added => ok.withValues(alpha: 0.12),
                            DiffOp.same => null,
                          },
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Text(
                            '${switch (op) {
                              DiffOp.removed => '−',
                              DiffOp.added => '+',
                              DiffOp.same => ' ',
                            }} $line',
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: op == DiffOp.removed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
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
          key: const ValueKey('confirm-restore'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l.restoreConfirm),
        ),
      ],
    );
  }
}

class _LibraryPicker extends ConsumerStatefulWidget {
  const _LibraryPicker();

  @override
  ConsumerState<_LibraryPicker> createState() => _LibraryPickerState();
}

class _LibraryPickerState extends ConsumerState<_LibraryPicker> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final q = foldForSearch(_q.trim());
    final templates =
        ref.watch(libraryProvider).value ?? const <ClauseTemplate>[];
    final rows = [
      for (final t in templates)
        for (final c in t.clauses)
          if (q.isEmpty ||
              foldForSearch(c.title).contains(q) ||
              foldForSearch(c.body).contains(q))
            (t, c),
    ];
    return AlertDialog(
      title: Text(l.pickLibraryClause),
      content: SizedBox(
        width: 600,
        height: 460,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, size: 18),
                hintText: l.searchClauses,
              ),
              onChanged: (v) => setState(() => _q = v),
            ),
            const SizedBox(height: Space.s),
            Expanded(
              child: ListView.separated(
                itemCount: rows.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final (t, c) = rows[i];
                  return ListTile(
                    dense: true,
                    title: Row(
                      children: [
                        Flexible(child: Text(c.title)),
                        if (c.optional) ...[
                          const SizedBox(width: Space.s),
                          const OptionalTag(),
                        ],
                      ],
                    ),
                    subtitle: Text(
                      '${t.name} · ${c.body.replaceAll('\n', ' ')}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    onTap: () => Navigator.of(context).pop(c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
      ],
    );
  }
}
