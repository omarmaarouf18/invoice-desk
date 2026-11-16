part of '../settings_page.dart';

/// The UI language: Arabic, English or the system language.
///
/// The choice is per machine (UiPrefs), not per document, and the whole app
/// follows it live: the locale, the reading direction and every string.
class _GeneralCard extends ConsumerWidget {
  const _GeneralCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final choice = ref.watch(uiLanguageProvider);
    return PanelCard(
      title: l.general,
      icon: Icons.tune,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.uiLanguage, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: Space.s),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: SegmentedButton<UiLanguage>(
              key: const ValueKey('ui-language'),
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: UiLanguage.system,
                  label: Text(l.uiLanguageSystem),
                  icon: const Icon(Icons.language, size: 16),
                ),
                ButtonSegment(
                  value: UiLanguage.ar,
                  label: Text(l.uiLanguageAr),
                ),
                ButtonSegment(
                  value: UiLanguage.en,
                  label: Text(l.uiLanguageEn),
                ),
              ],
              selected: {choice},
              onSelectionChanged: (s) =>
                  ref.read(uiLanguageProvider.notifier).set(s.first),
            ),
          ),
          const SizedBox(height: Space.s),
          Text(
            l.uiLanguageHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.colors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
