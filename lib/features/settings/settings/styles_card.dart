part of '../settings_page.dart';

/// Default styles and the way into «تصميم المستندات». Phase 6 moves this
/// into the Document styles section of the new settings navigation.
class _StylesSettingsCard extends ConsumerWidget {
  const _StylesSettingsCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PanelCard(
      title: l.stylesSettings,
      icon: Icons.palette_outlined,
      trailing: FilledButton.tonalIcon(
        key: const ValueKey('open-styles'),
        onPressed: () =>
            ref.read(workspaceProvider.notifier).show(Workspace.styles),
        icon: const Icon(Icons.brush_outlined, size: 18),
        label: Text(l.openStyleEditor),
      ),
      child: _SPair(
        DocStylePicker(
          label: l.defaultInvoiceStyle,
          value: s.defaultInvoiceStyleId ?? DocPreset.classic.id,
          onChanged: (id) =>
              update((x) => x.copyWith(defaultInvoiceStyleId: () => id)),
        ),
        DocStylePicker(
          label: l.defaultContractStyle,
          value: s.defaultContractStyleId ?? DocPreset.classic.id,
          onChanged: (id) =>
              update((x) => x.copyWith(defaultContractStyleId: () => id)),
        ),
      ),
    );
  }
}
