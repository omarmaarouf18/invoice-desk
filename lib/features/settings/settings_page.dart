import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/daos/settings_dao.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return switch (settings) {
      AsyncData(:final value) => _SettingsForm(initial: value),
      AsyncError() => Center(child: Text(context.l10n.dbErrorTitle)),
      _ => const SizedBox.shrink(),
    };
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.initial});
  final Settings initial;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late Settings _draft = widget.initial;
  Timer? _timer;
  bool _dirty = false;
  // Captured while ref is valid; also used from dispose.
  late final SettingsDao _dao;

  @override
  void initState() {
    super.initState();
    _dao = ref.read(databaseProvider).settingsDao;
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_dirty) unawaited(_persist());
    super.dispose();
  }

  @override
  void didUpdateWidget(_SettingsForm old) {
    super.didUpdateWidget(old);
    // External changes (restore, backup timestamp) win when nothing is pending.
    if (!_dirty) _draft = widget.initial;
  }

  void _update(Settings Function(Settings s) f) {
    setState(() {
      _draft = f(_draft);
      _dirty = true;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 600), () => unawaited(_save()));
  }

  Future<void> _persist() async {
    final current = await _dao.get();
    // Backup bookkeeping is owned by the backup service.
    await _dao.save(_draft.copyWith(lastBackupAt: current.lastBackupAt));
  }

  Future<void> _save() async {
    _timer?.cancel();
    await _persist();
    if (mounted) setState(() => _dirty = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = _draft;
    Widget f(
      String label,
      String value,
      Settings Function(Settings s, String v) set, {
      TextDirection? dir,
      int minLines = 1,
      int maxLines = 1,
      String? hint,
    }) => SyncedTextField(
      label: label,
      hint: hint,
      value: value,
      textDirection: dir,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: maxLines > 1 ? TextInputType.multiline : null,
      onChanged: (v) => _update((x) => set(x, v)),
    );
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: Space.m - 4),
        Expanded(child: b),
      ],
    );
    const gap = SizedBox(height: Space.m - 4);
    const cardGap = SizedBox(height: Space.m);

    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          Space.l,
          Space.l,
          Space.l,
          Space.xl * 2,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.settingsTitle,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            l.settingsSubtitle,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _dirty ? l.saving : l.saved,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: Space.m),
                    OutlinedButton.icon(
                      onPressed: () => ref
                          .read(workspaceProvider.notifier)
                          .show(Workspace.invoice),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: Text(l.back),
                    ),
                  ],
                ),
                const SizedBox(height: Space.l),
                PanelCard(
                  title: l.profile,
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      pair(
                        f(l.name, s.name, (x, v) => x.copyWith(name: v)),
                        f(l.role, s.role, (x, v) => x.copyWith(role: v)),
                      ),
                      gap,
                      pair(
                        f(l.city, s.city, (x, v) => x.copyWith(city: v)),
                        f(
                          l.website,
                          s.website,
                          (x, v) => x.copyWith(website: v),
                          dir: TextDirection.ltr,
                        ),
                      ),
                      gap,
                      pair(
                        f(
                          l.email,
                          s.email,
                          (x, v) => x.copyWith(email: v),
                          dir: TextDirection.ltr,
                        ),
                        f(
                          l.phone,
                          s.phone,
                          (x, v) => x.copyWith(phone: v),
                          dir: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.invoicing,
                  icon: Icons.tag,
                  child: pair(
                    f(
                      l.invoicePrefix,
                      s.invoicePrefix,
                      (x, v) => x.copyWith(
                        invoicePrefix: v.trim().isEmpty
                            ? x.invoicePrefix
                            : v.trim(),
                      ),
                      dir: TextDirection.ltr,
                      hint: l.prefixHint,
                    ),
                    f(
                      l.defaultDueDays,
                      '${s.defaultDueDays}',
                      (x, v) {
                        final d = parseIntInput(v);
                        return d == null || d > 3650
                            ? x
                            : x.copyWith(defaultDueDays: d);
                      },
                      dir: TextDirection.ltr,
                    ),
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.payment,
                  icon: Icons.account_balance_outlined,
                  child: Column(
                    children: [
                      pair(
                        f(
                          l.instapay,
                          s.instapay,
                          (x, v) => x.copyWith(instapay: v),
                          dir: TextDirection.ltr,
                        ),
                        f(
                          l.wallet,
                          s.wallet,
                          (x, v) => x.copyWith(wallet: v),
                          dir: TextDirection.ltr,
                        ),
                      ),
                      gap,
                      f(
                        l.bankIban,
                        s.bankIban,
                        (x, v) => x.copyWith(bankIban: v),
                        dir: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.defaultNotes,
                  icon: Icons.notes_outlined,
                  child: pair(
                    f(
                      l.notesEn,
                      s.notesEn,
                      (x, v) => x.copyWith(notesEn: v),
                      dir: TextDirection.ltr,
                      minLines: 4,
                      maxLines: 10,
                    ),
                    f(
                      l.notesAr,
                      s.notesAr,
                      (x, v) => x.copyWith(notesAr: v),
                      dir: TextDirection.rtl,
                      minLines: 4,
                      maxLines: 10,
                    ),
                  ),
                ),
                cardGap,
                const _AppearanceCard(),
                cardGap,
                _BackupCard(
                  settings: s,
                  onDirChanged: (d) => _update((x) => x.copyWith(backupDir: d)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppearanceCard extends ConsumerWidget {
  const _AppearanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final mode = ref.watch(themeModeProvider);
    return PanelCard(
      title: l.appearance,
      icon: Icons.palette_outlined,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: SegmentedButton<ThemeMode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: ThemeMode.system,
              label: Text(l.themeSystem),
              icon: const Icon(Icons.brightness_auto_outlined, size: 16),
            ),
            ButtonSegment(
              value: ThemeMode.light,
              label: Text(l.themeLight),
              icon: const Icon(Icons.light_mode_outlined, size: 16),
            ),
            ButtonSegment(
              value: ThemeMode.dark,
              label: Text(l.themeDark),
              icon: const Icon(Icons.dark_mode_outlined, size: 16),
            ),
          ],
          selected: {mode},
          onSelectionChanged: (s) =>
              ref.read(themeModeProvider.notifier).set(s.first),
        ),
      ),
    );
  }
}

class _BackupCard extends ConsumerStatefulWidget {
  const _BackupCard({required this.settings, required this.onDirChanged});
  final Settings settings;
  final ValueChanged<String> onDirChanged;

  @override
  ConsumerState<_BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends ConsumerState<_BackupCard> {
  bool _busy = false;

  String get _dir =>
      ref.read(appPathsProvider).backupDirFor(widget.settings.backupDir).path;

  Future<void> _run(Future<void> Function() job) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await job();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backupNow() async {
    final l = context.l10n;
    final dir = _dir;
    try {
      await ref.read(backupServiceProvider).backupNow(Directory(dir));
      final dao = ref.read(databaseProvider).settingsDao;
      final s = await dao.get();
      await dao.save(
        s.copyWith(
          lastBackupAt: ref
              .read(clockProvider)
              .now()
              .toUtc()
              .millisecondsSinceEpoch,
        ),
      );
      showSnack(
        l.backupDone,
        actions: [(l.openFolder, () => openPath(dir))],
      );
    } on Object catch (e) {
      debugPrint('backup failed: $e');
      showSnack(l.backupFailed);
    }
  }

  Future<void> _restore() async {
    final l = context.l10n;
    final file = await openFile(
      initialDirectory: _dir,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'SQLite', extensions: ['sqlite', 'db']),
      ],
    );
    if (file == null || !mounted) return;
    final BackupInfo info;
    try {
      info = BackupService.inspect(File(file.path));
      if (!info.isCompatible) throw const BackupException('version');
    } on BackupException {
      showSnack(l.restoreBad);
      return;
    }
    final date = formatArabicDate(CalendarDate.fromDateTime(info.modified));
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.restoreConfirmTitle),
        content: Text(
          l.restoreConfirmBody(date, info.invoiceCount, info.clientCount),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.restoreAction),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final dir = _dir;
    await ref
        .read(backupServiceProvider)
        .restoreFrom(
          File(file.path),
          safetyDir: Directory(dir),
        );
    showSnack(l.restoreDone);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final last = widget.settings.lastBackupAt;
    final lastText = last == null
        ? l.never
        : l.lastBackup(
            formatArabicDate(
              CalendarDate.fromDateTime(
                DateTime.fromMillisecondsSinceEpoch(last),
              ),
            ),
          );
    final actions = AppActions(ref, context);
    return PanelCard(
      title: l.backup,
      icon: Icons.backup_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            decoration: InputDecoration(labelText: l.backupDir),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _dir,
                    textDirection: TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final d = await getDirectoryPath(initialDirectory: _dir);
                    if (d != null) widget.onDirChanged(d);
                  },
                  child: Text(l.chooseFolder),
                ),
              ],
            ),
          ),
          const SizedBox(height: Space.s),
          Text('$lastText · ${l.backupAuto}', style: theme.textTheme.bodySmall),
          const SizedBox(height: Space.m - 4),
          Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : () => unawaited(_run(_backupNow)),
                icon: const Icon(Icons.save_alt, size: 18),
                label: Text(l.backupNow),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : () => unawaited(_run(_restore)),
                icon: const Icon(Icons.restore, size: 18),
                label: Text(l.restore),
              ),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => unawaited(_run(actions.exportCsv)),
                icon: const Icon(Icons.table_view_outlined, size: 18),
                label: Text(l.exportCsv),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
