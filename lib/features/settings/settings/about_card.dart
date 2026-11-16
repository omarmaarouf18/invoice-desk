part of '../settings_page.dart';

class _AboutCard extends ConsumerWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final version = ref.watch(appVersionProvider).value ?? '…';
    final dataDir = ref.watch(appPathsProvider).dataDir.path;
    return PanelCard(
      title: l.about,
      icon: Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(l.appTitle, style: theme.textTheme.titleMedium),
              const SizedBox(width: Space.s),
              Text(
                l.aboutVersion(version),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          Text(l.aboutBody, style: theme.textTheme.bodySmall),
          Text(l.notTaxInvoice, style: theme.textTheme.bodySmall),
          const SizedBox(height: Space.s),
          Text(l.aboutDataDir, style: theme.textTheme.labelSmall),
          SelectableText(
            dataDir,
            textDirection: TextDirection.ltr,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
