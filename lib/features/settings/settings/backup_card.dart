part of '../settings_page.dart';

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
      await ref.read(backupServiceProvider).backupNowAndRecord(Directory(dir));
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
