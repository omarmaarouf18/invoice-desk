part of '../settings_page.dart';

/// Density, accent colour and start-up view: this computer only.
class _ThisMachineCard extends ConsumerWidget {
  const _ThisMachineCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = ref.watch(machinePrefsProvider);
    final set = ref.read(machinePrefsProvider.notifier).update;
    final label = Theme.of(context).textTheme.labelLarge;
    return PanelCard(
      title: l.thisMachineTitle,
      icon: Icons.computer_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.densityLabel, style: label),
          const SizedBox(height: Space.xs),
          SegmentedButton<UiDensity>(
            key: const ValueKey('ui-density'),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: UiDensity.compact,
                label: Text(l.densityCompact),
              ),
              ButtonSegment(
                value: UiDensity.comfortable,
                label: Text(l.densityComfortable),
              ),
            ],
            selected: {p.density},
            onSelectionChanged: (v) => set((x) => x.copyWith(density: v.first)),
          ),
          const SizedBox(height: Space.m),
          Text(l.accentLabel, style: label),
          const SizedBox(height: Space.xs),
          _AccentChoices(selected: p.accent),
          const SizedBox(height: Space.m),
          Text(l.startupViewLabel, style: label),
          const SizedBox(height: Space.xs),
          SegmentedButton<StartupView>(
            key: const ValueKey('startup-view'),
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: StartupView.last,
                label: Text(l.startupLast),
              ),
              ButtonSegment(
                value: StartupView.calendar,
                label: Text(l.startupCalendar),
              ),
            ],
            selected: {p.startupView},
            onSelectionChanged: (v) =>
                set((x) => x.copyWith(startupView: v.first)),
          ),
          const SizedBox(height: Space.s),
          Text(
            l.thisMachineHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AccentChoices extends ConsumerWidget {
  const _AccentChoices({required this.selected});
  final UiAccent selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    String name(UiAccent a) => switch (a) {
      UiAccent.teal => l.accentTeal,
      UiAccent.blue => l.accentBlue,
      UiAccent.indigo => l.accentIndigo,
      UiAccent.purple => l.accentPurple,
      UiAccent.rose => l.accentRose,
      UiAccent.amber => l.accentAmber,
    };
    return Wrap(
      spacing: Space.s,
      runSpacing: Space.s,
      children: [
        for (final a in UiAccent.values)
          ChoiceChip(
            key: ValueKey('accent-${a.name}'),
            avatar: CircleAvatar(backgroundColor: a.seed, radius: 8),
            label: Text(name(a)),
            selected: a == selected,
            onSelected: (_) => ref
                .read(machinePrefsProvider.notifier)
                .update((x) => x.copyWith(accent: a)),
          ),
      ],
    );
  }
}

/// Suggested file name, export folder and "open after export".
class _PdfExportCard extends ConsumerWidget {
  const _PdfExportCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = ref.watch(machinePrefsProvider);
    final set = ref.read(machinePrefsProvider.notifier).update;
    final example = pdfFileName(
      p.pdfNamePattern,
      number: 'OM-2026-0001',
      client: 'Acme Studio',
      date: '2026-09-14',
    );
    Future<void> chooseFolder() async {
      final dir = await getDirectoryPath(initialDirectory: p.exportFolder);
      if (dir != null) set((x) => x.copyWith(exportFolder: () => dir));
    }

    return PanelCard(
      title: l.pdfExportTitle,
      icon: Icons.picture_as_pdf_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SyncedTextField(
            key: const ValueKey('pdf-name-pattern'),
            label: l.pdfNamePattern,
            value: p.pdfNamePattern,
            textDirection: TextDirection.ltr,
            hint: l.pdfNamePatternHint('{NUMBER}', '{CLIENT}', '{DATE}'),
            onChanged: (v) => set((x) => x.copyWith(pdfNamePattern: v)),
          ),
          const SizedBox(height: Space.xs),
          Text(
            l.pdfNamePreview('$example.pdf'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: Space.m),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.exportFolder,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Ltr(p.exportFolder ?? l.exportFolderLast),
                  ],
                ),
              ),
              if (p.exportFolder != null)
                TextButton(
                  onPressed: () =>
                      set((x) => x.copyWith(exportFolder: () => null)),
                  child: Text(l.exportFolderClear),
                ),
              OutlinedButton(
                onPressed: () => unawaited(chooseFolder()),
                child: Text(l.chooseFolder),
              ),
            ],
          ),
          SwitchListTile(
            key: const ValueKey('open-after-export'),
            contentPadding: EdgeInsets.zero,
            title: Text(l.openAfterExport),
            value: p.openAfterExport,
            onChanged: (v) => set((x) => x.copyWith(openAfterExport: v)),
          ),
        ],
      ),
    );
  }
}

/// Every global shortcut, from the same table the shell binds.
class _ShortcutsCard extends StatelessWidget {
  const _ShortcutsCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String what(AppShortcut s) => switch (s) {
      AppShortcut.newInvoice => l.scNewInvoice,
      AppShortcut.newClient => l.scNewClient,
      AppShortcut.newContract => l.scNewContract,
      AppShortcut.toggleCalendar => l.scToggleCalendar,
      AppShortcut.search => l.scSearch,
      AppShortcut.find => l.scFind,
      AppShortcut.save => l.scSave,
      AppShortcut.exportPdf => l.scExportPdf,
      AppShortcut.duplicate => l.scDuplicate,
      AppShortcut.renew => l.scRenew,
      AppShortcut.editTab => l.scEditTab,
      AppShortcut.previewTab => l.scPreviewTab,
    };
    return PanelCard(
      title: l.shortcutsTitle,
      icon: Icons.keyboard_outlined,
      child: Column(
        children: [
          for (final s in AppShortcut.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              child: Row(
                children: [
                  Expanded(child: Text(what(s))),
                  Ltr(s.keys, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
