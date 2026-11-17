import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/trash.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/typed_confirm_dialog.dart';
import 'package:path/path.dart' as p;

/// "المحذوفات" in the sidebar: every soft-deleted client, invoice and
/// contract with restore and permanent delete.
class TrashList extends ConsumerWidget {
  const TrashList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final entries = ref.watch(trashProvider).value ?? const <TrashEntry>[];
    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Space.l),
        child: Column(
          children: [
            Icon(Icons.delete_outline, size: 32, color: context.colors.muted),
            const SizedBox(height: Space.s),
            Text(l.trashEmptyState, style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            Space.m,
            Space.xs,
            Space.m,
            Space.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l.trashItems(entries.length),
                  style: theme.textTheme.labelMedium,
                ),
              ),
              TextButton.icon(
                key: const ValueKey('empty-trash'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                onPressed: () =>
                    unawaited(TrashActions(ref, context).empty(entries.length)),
                icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                label: Text(l.trashEmpty),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.only(bottom: Space.l),
            itemCount: entries.length,
            itemBuilder: (context, i) =>
                TrashRow(key: ValueKey(entries[i].id), entry: entries[i]),
          ),
        ),
      ],
    );
  }
}

class TrashRow extends ConsumerWidget {
  const TrashRow({required this.entry, super.key});
  final TrashEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final now = ref.watch(clockProvider).now();
    final e = entry;
    final deleted = CalendarDate.fromDateTime(
      DateTime.fromMillisecondsSinceEpoch(e.deletedAt, isUtc: true).toLocal(),
    );
    final days = daysUntilPurge(e.deletedAt, now);
    final a = TrashActions(ref, context);
    final muted = context.colors.muted;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(Space.s + 4, 2, Space.s, 2),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(Space.s, 6, 2, 6),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(Space.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(
              switch (e.kind) {
                TrashKind.client => Icons.person_outline,
                TrashKind.invoice => Icons.receipt_long_outlined,
                TrashKind.contract => Icons.gavel_outlined,
                TrashKind.style => Icons.palette_outlined,
              },
              size: 18,
              color: muted,
            ),
            const SizedBox(width: Space.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.label,
                    style: theme.textTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (e.kind != TrashKind.client && e.clientName.isNotEmpty)
                    Text(
                      [
                        l.trashOfClient(e.clientName),
                        if (e.clientDeleted) l.trashClientDeleted,
                      ].join(' · '),
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    '${l.trashDeletedOn(formatDocDayMonth(deleted, context.docLanguage))} · '
                    '${l.trashPurgeIn(days)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
            IconButton(
              key: ValueKey('restore-${e.id}'),
              tooltip: l.trashRestore,
              onPressed: () => unawaited(a.restore(e)),
              icon: const Icon(Icons.restore, size: 18),
            ),
            IconButton(
              key: ValueKey('purge-${e.id}'),
              tooltip: l.trashPurge,
              onPressed: () => unawaited(a.purge(e)),
              icon: Icon(
                Icons.delete_forever_outlined,
                size: 18,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Restore and permanent-delete flows, with their dialogs.
class TrashActions {
  TrashActions(this.ref, this.context);
  final WidgetRef ref;
  final BuildContext context;

  Future<void> restore(TrashEntry e) async {
    final l = context.l10n;
    final repo = ref.read(trashRepositoryProvider);
    var r = await repo.restore(e);
    if (r is NeedsClient) {
      final clientName = r.clientName;
      if (!context.mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.trashNeedsClientTitle(clientName)),
          content: SizedBox(
            width: 440,
            child: Text(l.trashNeedsClientBody(e.label)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l.cancel),
            ),
            FilledButton(
              key: const ValueKey('restore-with-client'),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l.trashRestoreBoth),
            ),
          ],
        ),
      );
      if (!(ok ?? false)) return;
      r = await repo.restore(e, withClient: true);
    }
    if (r is Restored) {
      showSnack(
        r.count == 1 ? l.trashRestored(e.label) : l.trashRestoredCount(r.count),
      );
    }
  }

  Future<void> purge(TrashEntry e) async {
    final l = context.l10n;
    final ok = await showTypedConfirmDialog(
      context,
      title: l.trashPurgeTitle(e.label),
      body: e.kind == TrashKind.client
          ? l.trashPurgeClientBody(e.label)
          : l.trashPurgeBody(e.label),
      expected: e.label,
      confirmLabel: l.trashPurge,
    );
    if (!ok) return;
    try {
      final file = await ref.read(trashRepositoryProvider).purge(e);
      showSnack(l.trashPurged(p.basename(file.path)));
    } on Object catch (err) {
      debugPrint('purge failed: $err');
      showSnack(l.trashPurgeFailed);
    }
  }

  Future<void> empty(int count) async {
    final l = context.l10n;
    final ok = await showTypedConfirmDialog(
      context,
      title: l.trashEmptyTitle,
      body: l.trashEmptyBody(l.trashItems(count)),
      expected: l.trashEmptyWord,
      confirmLabel: l.trashEmpty,
    );
    if (!ok) return;
    try {
      final file = await ref.read(trashRepositoryProvider).empty();
      showSnack(l.trashPurged(p.basename(file.path)));
    } on Object catch (err) {
      debugPrint('empty trash failed: $err');
      showSnack(l.trashPurgeFailed);
    }
  }
}
