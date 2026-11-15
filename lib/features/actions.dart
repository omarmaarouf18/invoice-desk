import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/clients/client_dialog.dart';
import 'package:invoice_desk/features/clients/client_removal_dialogs.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

/// App-wide messenger so snackbars work from shortcuts and menus.
final messengerKey = GlobalKey<ScaffoldMessengerState>();

void showSnack(
  String message, {
  List<(String, VoidCallback)> actions = const [],
  Duration duration = const Duration(seconds: 4),
}) {
  final m = messengerKey.currentState;
  if (m == null) return;
  m
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: duration,
        content: Row(
          children: [
            Expanded(child: Text(message)),
            for (final (label, onTap) in actions.skip(1))
              TextButton(
                onPressed: () {
                  m.hideCurrentSnackBar();
                  onTap();
                },
                child: Text(label),
              ),
          ],
        ),
        action: actions.isEmpty
            ? null
            : SnackBarAction(
                label: actions.first.$1,
                onPressed: actions.first.$2,
              ),
      ),
    );
}

void openPath(String path) =>
    unawaited(launchUrl(Uri.file(path)).catchError((Object _) => false));

/// All user-facing invoice actions, shared by the top bar, context menus
/// and keyboard shortcuts.
class AppActions {
  AppActions(this.ref, this.context);
  final WidgetRef ref;
  final BuildContext context;

  AppLocalizations get l => context.l10n;
  EditorController get editor => ref.read(editorProvider.notifier);
  String? get currentId => ref.read(editorProvider).invoice?.id;

  void newInvoice({String? clientId}) =>
      unawaited(editor.newInvoice(clientId: clientId));

  Future<Client?> newClient() async {
    final client = await showClientDialog(context);
    if (client == null) return null;
    await ref.read(databaseProvider).clientsDao.upsert(client);
    return client;
  }

  Future<void> editClient(Client c) async {
    final updated = await showClientDialog(
      context,
      client: c,
      onDelete: () => unawaited(deleteClient(c)),
    );
    if (updated == null) return;
    await ref.read(databaseProvider).clientsDao.upsert(updated);
  }

  Future<void> setArchived(Client c, {required bool archived}) => archived
      ? archiveClient(c)
      : ref
            .read(databaseProvider)
            .clientsDao
            .setArchived(c.id, archived: false);

  /// Hides the client and their invoices from the list and search.
  Future<void> archiveClient(Client c) async {
    // Read everything up front: the tile this runs from goes away.
    final l = this.l;
    final dao = ref.read(databaseProvider).clientsDao;
    await editor.closeIfClient(c.id);
    await ref.read(contractProvider.notifier).closeIfClient(c.id);
    await dao.setArchived(c.id, archived: true);
    showSnack(
      l.clientArchivedSnack(c.name),
      duration: const Duration(seconds: 8),
      actions: [
        (l.undo, () => unawaited(dao.setArchived(c.id, archived: false))),
      ],
    );
  }

  /// No live invoices: soft delete with Undo. Otherwise ask: archive
  /// (default) or, after typing the name and a backup, delete everything.
  Future<void> deleteClient(Client c) async {
    final l = this.l;
    final db = ref.read(databaseProvider);
    final dao = db.clientsDao;
    final ed = editor;
    final ced = ref.read(contractProvider.notifier);
    final backups = ref.read(backupServiceProvider);
    final count = await dao.countLiveInvoices(c.id);
    final contracts = await dao.countLiveContracts(c.id);

    if (count == 0 && contracts == 0) {
      await ed.closeIfClient(c.id);
      await ced.closeIfClient(c.id);
      try {
        await dao.softDelete(c.id);
      } on Object catch (e) {
        debugPrint('client delete failed: $e');
        return showSnack(l.clientDeleteFailed);
      }
      return showSnack(
        l.clientDeleted(c.name),
        duration: const Duration(seconds: 8),
        actions: [(l.undo, () => unawaited(dao.undoDelete(c.id)))],
      );
    }

    final unpaid = MoneyBag();
    for (final i in await db.invoicesDao.getAll()) {
      if (i.clientId == c.id && i.isUnpaid) unpaid.addBag(i.totals.total);
    }
    if (!context.mounted) return;
    final choice = await showClientHasInvoicesDialog(
      context,
      client: c,
      invoiceCount: count,
      contractCount: contracts,
      unpaid: unpaid,
    );
    switch (choice) {
      case null:
        return;
      case ClientRemoval.archive:
        return archiveClient(c);
      case ClientRemoval.deleteAll:
        if (!context.mounted) return;
        final confirmed = await showConfirmDeleteAllDialog(
          context,
          client: c,
          invoiceCount: count,
          contractCount: contracts,
        );
        if (!confirmed) return;
        await ed.closeIfClient(c.id);
        await ced.closeIfClient(c.id);
        try {
          await backups.backupBefore('delete-client');
        } on Object catch (e) {
          debugPrint('pre-delete backup failed: $e');
          return showSnack(l.deleteBackupFailed);
        }
        final int stamp;
        try {
          stamp = await dao.softDeleteWithDocuments(c.id);
        } on Object catch (e) {
          debugPrint('client delete failed: $e');
          return showSnack(l.clientDeleteFailed);
        }
        showSnack(
          contracts == 0
              ? l.clientDeletedWithInvoices(c.name, l.invoiceCount(count))
              : l.clientDeletedWithDocuments(
                  c.name,
                  l.andJoin(l.invoiceCount(count), l.contractCount(contracts)),
                ),
          duration: const Duration(seconds: 8),
          actions: [
            (
              l.undo,
              () => unawaited(dao.undoDeleteWithDocuments(c.id, stamp)),
            ),
          ],
        );
    }
  }

  void save() => unawaited(editor.flush());

  void _report(ActionResult r) {
    switch (r) {
      case Created(:final number):
        showSnack(l.duplicated(number));
      case NothingToRenew(:final number):
        showSnack(l.renewNone(number));
      case Done(:final number):
        showSnack(l.markedPaid(number));
      case Failed():
        showSnack(l.nothingOpen);
    }
  }

  Future<void> duplicate([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return showSnack(l.nothingOpen);
    _report(await editor.duplicate(target));
  }

  Future<void> renew([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return showSnack(l.nothingOpen);
    final r = await editor.renew(target);
    if (r is Created) return showSnack(l.renewCreated(r.number));
    _report(r);
  }

  Future<void> markPaid([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return showSnack(l.nothingOpen);
    _report(await editor.markPaid(target));
  }

  Future<void> delete([String? id]) async {
    final target = id ?? currentId;
    if (target == null) return;
    final l = this.l;
    final editor = this.editor;
    final number = await editor.delete(target);
    if (number == null) return;
    showSnack(
      l.deleted(number),
      duration: const Duration(seconds: 8),
      actions: [(l.undo, () => unawaited(editor.undoDelete(target)))],
    );
  }

  Future<void> open(String id) => editor.open(id);

  Future<void> exportPdf() async {
    final inv = ref.read(editorProvider).invoice;
    if (inv == null) return showSnack(l.nothingOpen);
    await editor.flush();
    final db = ref.read(databaseProvider);
    final clients = await db.clientsDao.getAll();
    final client = clients.where((c) => c.id == inv.clientId).firstOrNull;
    final settings = await db.settingsDao.get();
    final fonts = await ref.read(pdfFontsProvider.future);
    final prefs = ref.read(uiPrefsProvider);
    final location = await getSaveLocation(
      suggestedName: invoiceFileName(inv, client),
      initialDirectory: prefs.lastExportDir,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'PDF', extensions: ['pdf']),
      ],
    );
    if (location == null) return;
    var path = location.path;
    if (!path.toLowerCase().endsWith('.pdf')) path = '$path.pdf';
    try {
      final bytes = await buildInvoicePdf(
        InvoicePdfData(invoice: inv, client: client, settings: settings),
        fonts,
      );
      await File(path).writeAsBytes(bytes, flush: true);
    } on Object catch (e) {
      debugPrint('export failed: $e');
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

  Future<void> exportCsv() async {
    final db = ref.read(databaseProvider);
    final invoices = await db.invoicesDao.getAll();
    final clients = {
      for (final c in await db.clientsDao.getAll()) c.id: c.name,
    };
    final location = await getSaveLocation(
      suggestedName: 'invoices.csv',
      initialDirectory: ref.read(uiPrefsProvider).lastExportDir,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'CSV', extensions: ['csv']),
      ],
    );
    if (location == null) return;
    final csv = invoicesCsv(invoices, clients);
    await File(location.path).writeAsString(csv, flush: true);
    showSnack(
      l.csvDone(p.basename(location.path)),
      actions: [(l.openFolder, () => openPath(p.dirname(location.path)))],
    );
  }
}

/// Accountant CSV: one row per invoice, totals per currency in columns.
String invoicesCsv(List<Invoice> invoices, Map<String, String> clientNames) {
  String q(String v) => '"${v.replaceAll('"', '""')}"';
  final sorted = [...invoices]..sort((a, b) => a.number.compareTo(b.number));
  final header = [
    'number',
    'client',
    'issue_date',
    'due_date',
    'paid_date',
    'status',
    for (final c in Currency.values) 'total_${c.code}',
  ];
  final rows = [
    for (final i in sorted)
      [
        q(i.number),
        q(clientNames[i.clientId] ?? ''),
        i.issueDate.toIso(),
        i.dueDate.toIso(),
        i.paidDate?.toIso() ?? '',
        i.status.dbValue,
        for (final c in Currency.values)
          i.totals.total.of(c) == 0
              ? ''
              : formatAmount(
                  i.totals.total.of(c),
                  c,
                  forceDecimals: true,
                ).replaceAll(',', ''),
      ].join(','),
  ];
  // BOM so spreadsheet apps read Arabic names as UTF-8.
  return '\uFEFF${[header.join(','), ...rows].join('\r\n')}\r\n';
}
