part of '../settings_page.dart';

/// The navigation label of [s].
String _sectionTitle(AppLocalizations l, SettingsSection s) => switch (s) {
  SettingsSection.general => l.general,
  SettingsSection.profile => l.profile,
  SettingsSection.invoices => l.settingsInvoices,
  SettingsSection.contracts => l.contractsSettings,
  SettingsSection.payment => l.payment,
  SettingsSection.styles => l.stylesSettings,
  SettingsSection.calendar => l.calendar,
  SettingsSection.data => l.settingsData,
  SettingsSection.sync => l.cloudSync,
  SettingsSection.about => l.about,
};

/// What search matches in [s]: its title and the labels of its controls,
/// in the UI language.
List<String> _sectionKeywords(AppLocalizations l, SettingsSection s) => [
  _sectionTitle(l, s),
  ...switch (s) {
    SettingsSection.general => [
      l.uiLanguage,
      l.appearance,
      l.themeDark,
      l.themeLight,
    ],
    SettingsSection.profile => [
      l.name,
      l.role,
      l.city,
      l.email,
      l.phone,
      l.website,
    ],
    SettingsSection.invoices => [
      l.invoicing,
      l.invoicePrefix,
      l.defaultDueDays,
      l.defaultDocLanguage,
      l.docDigitStyle,
      l.defaultNotes,
    ],
    SettingsSection.contracts => [
      l.legalName,
      l.nationalIdOrRegistry,
      l.address,
      l.contractPrefix,
      l.quotePrefix,
      l.defaultJurisdiction,
      l.openLibrary,
    ],
    SettingsSection.payment => [l.instapay, l.wallet, l.bankIban],
    SettingsSection.styles => [
      l.defaultInvoiceStyle,
      l.defaultContractStyle,
      l.openStyleEditor,
    ],
    SettingsSection.calendar => [l.weekStart, l.notifyOnStart],
    SettingsSection.data => [
      l.backup,
      l.backupDir,
      l.restore,
      l.exportCsv,
      l.demoData,
    ],
    SettingsSection.sync => [l.cloudSyncBody],
    SettingsSection.about => [l.aboutDataDir, l.appTitle],
  },
];

/// The sections whose keywords contain [query] (case-insensitive).
List<SettingsSection> _matching(AppLocalizations l, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return SettingsSection.values;
  return [
    for (final s in SettingsSection.values)
      if (_sectionKeywords(l, s).any((k) => k.toLowerCase().contains(q))) s,
  ];
}

/// The start column: search, then the sections.
class _SettingsNav extends ConsumerStatefulWidget {
  const _SettingsNav();

  @override
  ConsumerState<_SettingsNav> createState() => _SettingsNavState();
}

class _SettingsNavState extends ConsumerState<_SettingsNav> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final selected = ref.watch(settingsSectionProvider);
    final shown = _matching(l, _query);
    final notifier = ref.read(settingsSectionProvider.notifier);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(Space.s),
            child: TextField(
              key: const ValueKey('settings-search'),
              decoration: InputDecoration(
                hintText: l.settingsSearchHint,
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _query = v),
              onSubmitted: (_) {
                if (shown.isNotEmpty) notifier.set(shown.first);
              },
            ),
          ),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.all(Space.m),
              child: Text(
                l.settingsNoMatch,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: Space.s),
              children: [
                for (final s in shown)
                  ListTile(
                    key: ValueKey('settings-section-${s.name}'),
                    dense: true,
                    selected: s == selected,
                    selectedTileColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Space.radiusSmall),
                    ),
                    leading: Icon(s.icon, size: 20),
                    title: HighlightText(_sectionTitle(l, s), query: _query),
                    onTap: () => notifier.set(s),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
