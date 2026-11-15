part of '../settings_page.dart';

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
