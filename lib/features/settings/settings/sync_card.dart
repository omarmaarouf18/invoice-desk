part of '../settings_page.dart';

/// "المزامنة السحابية": status only. No buttons until sync exists.
class _SyncCard extends ConsumerWidget {
  const _SyncCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final status = ref.watch(syncStatusProvider).value;
    final off = status == null || status is SyncDisabled;
    return PanelCard(
      title: l.cloudSync,
      icon: Icons.cloud_off_outlined,
      trailing: Container(
        key: const ValueKey('sync-status'),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: Space.s,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: context.colors.subtle,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          off ? l.cloudSyncOff : l.cloudSyncOn,
          style: theme.textTheme.labelMedium?.copyWith(
            color: context.colors.muted,
          ),
        ),
      ),
      child: Text(l.cloudSyncBody, style: theme.textTheme.bodySmall),
    );
  }
}
