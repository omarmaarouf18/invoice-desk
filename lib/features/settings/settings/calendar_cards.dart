part of '../settings_page.dart';

/// "التقويم": week start and the optional start-up notification.
class _CalendarCard extends ConsumerWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ws = ref.watch(weekStartProvider);
    final notify = ref.watch(notifyOnStartProvider);
    return PanelCard(
      title: l.calendar,
      icon: Icons.calendar_month_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(l.weekStart)),
              SegmentedButton<WeekStart>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: WeekStart.saturday,
                    label: Text(l.weekdaySaturday),
                  ),
                  ButtonSegment(
                    value: WeekStart.sunday,
                    label: Text(l.weekdaySunday),
                  ),
                  ButtonSegment(
                    value: WeekStart.monday,
                    label: Text(l.weekdayMonday),
                  ),
                ],
                selected: {ws},
                onSelectionChanged: (v) =>
                    ref.read(weekStartProvider.notifier).set(v.first),
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l.notifyOnStart),
            subtitle: Text(l.notifyOnStartBody),
            value: notify,
            onChanged: ref.read(notifyOnStartProvider.notifier).set,
          ),
        ],
      ),
    );
  }
}

/// "البيانات التجريبية": add the demo set (only when none is there) or
/// remove it (backup first; only demo rows).
class _DemoCard extends ConsumerWidget {
  const _DemoCard();

  Future<void> _remove(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.demoRemoveTitle),
        content: Text(l.demoRemoveBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l.cancel),
          ),
          FilledButton(
            key: const Key('confirm-remove-demo'),
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.demoRemove),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      final r = await ref.read(demoRepositoryProvider).removeDemo();
      final n = r.invoices + r.contracts + r.clients + r.reminders;
      showSnack(
        l.demoRemoved(n),
        actions: [(l.openFolder, () => openPath(p.dirname(r.backup.path)))],
      );
    } on Object {
      showSnack(l.deleteBackupFailed);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final has = ref.watch(hasDemoProvider).value;
    return PanelCard(
      title: l.demoData,
      icon: Icons.science_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.demoBody, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Space.s),
          if (has == false)
            FilledButton.tonal(
              key: const Key('add-demo'),
              onPressed: () async {
                if (await ref.read(demoRepositoryProvider).addDemo()) {
                  showSnack(l.demoAdded);
                }
              },
              child: Text(l.demoAdd),
            )
          else if (has == true)
            OutlinedButton(
              key: const Key('remove-demo'),
              onPressed: () => unawaited(_remove(context, ref)),
              child: Text(l.demoRemove),
            ),
        ],
      ),
    );
  }
}
