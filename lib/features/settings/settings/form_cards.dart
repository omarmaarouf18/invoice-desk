part of '../settings_page.dart';

/// Applies one change to the settings draft (debounced save).
typedef SettingsUpdate = void Function(Settings Function(Settings s) f);

/// A settings text field bound to one value of the draft.
class _SettingField extends StatelessWidget {
  const _SettingField(
    this.update,
    this.label,
    this.value,
    this.set, {
    this.dir,
    this.minLines = 1,
    this.maxLines = 1,
    this.hint,
  });

  final SettingsUpdate update;
  final String label;
  final String value;
  final Settings Function(Settings s, String v) set;
  final TextDirection? dir;
  final int minLines;
  final int maxLines;
  final String? hint;

  @override
  Widget build(BuildContext context) => SyncedTextField(
    label: label,
    hint: hint,
    value: value,
    textDirection: dir,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: maxLines > 1 ? TextInputType.multiline : null,
    onChanged: (v) => update((x) => set(x, v)),
  );
}

class _SPair extends StatelessWidget {
  const _SPair(this.a, this.b);
  final Widget a;
  final Widget b;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: a),
      const SizedBox(width: Space.m - 4),
      Expanded(child: b),
    ],
  );
}

const _sgap = SizedBox(height: Space.m - 4);

class _SettingsHeader extends ConsumerWidget {
  const _SettingsHeader({required this.dirty});
  final bool dirty;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.settingsTitle, style: theme.textTheme.headlineSmall),
              Text(l.settingsSubtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Text(dirty ? l.saving : l.saved, style: theme.textTheme.bodySmall),
        const SizedBox(width: Space.m),
        OutlinedButton.icon(
          onPressed: () =>
              ref.read(workspaceProvider.notifier).show(Workspace.invoice),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text(l.back),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PanelCard(
      title: l.profile,
      icon: Icons.person_outline,
      child: Column(
        children: [
          _SPair(
            _SettingField(
              update,
              l.name,
              s.name,
              (x, v) => x.copyWith(name: v),
            ),
            _SettingField(
              update,
              l.role,
              s.role,
              (x, v) => x.copyWith(role: v),
            ),
          ),
          _sgap,
          _SPair(
            _SettingField(
              update,
              l.city,
              s.city,
              (x, v) => x.copyWith(city: v),
            ),
            _SettingField(
              update,
              l.website,
              s.website,
              (x, v) => x.copyWith(website: v),
              dir: TextDirection.ltr,
            ),
          ),
          _sgap,
          _SPair(
            _SettingField(
              update,
              l.email,
              s.email,
              (x, v) => x.copyWith(email: v),
              dir: TextDirection.ltr,
            ),
            _SettingField(
              update,
              l.phone,
              s.phone,
              (x, v) => x.copyWith(phone: v),
              dir: TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoicingCard extends StatelessWidget {
  const _InvoicingCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PanelCard(
      title: l.invoicing,
      icon: Icons.tag,
      child: _SPair(
        _SettingField(
          update,
          l.invoicePrefix,
          s.invoicePrefix,
          (x, v) => x.copyWith(
            invoicePrefix: v.trim().isEmpty ? x.invoicePrefix : v.trim(),
          ),
          dir: TextDirection.ltr,
          hint: l.prefixHint,
        ),
        _SettingField(
          update,
          l.defaultDueDays,
          '${s.defaultDueDays}',
          (x, v) {
            final d = parseIntInput(v);
            return d == null || d > 3650 ? x : x.copyWith(defaultDueDays: d);
          },
          dir: TextDirection.ltr,
        ),
      ),
    );
  }
}

class _ContractsSettingsCard extends ConsumerWidget {
  const _ContractsSettingsCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return PanelCard(
      title: l.contractsSettings,
      icon: Icons.gavel_outlined,
      trailing: FilledButton.tonalIcon(
        key: const ValueKey('open-library'),
        onPressed: () =>
            ref.read(workspaceProvider.notifier).show(Workspace.library),
        icon: const Icon(Icons.library_books_outlined, size: 18),
        label: Text(l.openLibrary),
      ),
      child: Column(
        children: [
          _SPair(
            _SettingField(
              update,
              l.legalName,
              s.legalName,
              (x, v) => x.copyWith(legalName: v),
            ),
            _SettingField(
              update,
              l.nationalIdOrRegistry,
              s.nationalIdOrRegistry,
              (x, v) => x.copyWith(nationalIdOrRegistry: v),
            ),
          ),
          _sgap,
          _SettingField(
            update,
            l.address,
            s.address,
            (x, v) => x.copyWith(address: v),
          ),
          _sgap,
          _SPair(
            _SettingField(
              update,
              l.contractPrefix,
              s.contractPrefix,
              (x, v) => x.copyWith(
                contractPrefix: v.trim().isEmpty ? x.contractPrefix : v.trim(),
              ),
              dir: TextDirection.ltr,
            ),
            _SettingField(
              update,
              l.quotePrefix,
              s.quotePrefix,
              (x, v) => x.copyWith(
                quotePrefix: v.trim().isEmpty ? x.quotePrefix : v.trim(),
              ),
              dir: TextDirection.ltr,
            ),
          ),
          _sgap,
          _SettingField(
            update,
            l.defaultJurisdiction,
            s.defaultJurisdiction,
            (x, v) => x.copyWith(defaultJurisdiction: v),
          ),
          _sgap,
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: s.contractWesternDigits,
            title: Text(l.westernDigits),
            onChanged: (v) => update(
              (x) => x.copyWith(contractWesternDigits: v),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PanelCard(
      title: l.payment,
      icon: Icons.account_balance_outlined,
      child: Column(
        children: [
          _SPair(
            _SettingField(
              update,
              l.instapay,
              s.instapay,
              (x, v) => x.copyWith(instapay: v),
              dir: TextDirection.ltr,
            ),
            _SettingField(
              update,
              l.wallet,
              s.wallet,
              (x, v) => x.copyWith(wallet: v),
              dir: TextDirection.ltr,
            ),
          ),
          _sgap,
          _SettingField(
            update,
            l.bankIban,
            s.bankIban,
            (x, v) => x.copyWith(bankIban: v),
            dir: TextDirection.ltr,
          ),
        ],
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.s, required this.update});
  final Settings s;
  final SettingsUpdate update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return PanelCard(
      title: l.defaultNotes,
      icon: Icons.notes_outlined,
      child: _SPair(
        _SettingField(
          update,
          l.notesEn,
          s.notesEn,
          (x, v) => x.copyWith(notesEn: v),
          dir: TextDirection.ltr,
          minLines: 4,
          maxLines: 10,
        ),
        _SettingField(
          update,
          l.notesAr,
          s.notesAr,
          (x, v) => x.copyWith(notesAr: v),
          dir: TextDirection.rtl,
          minLines: 4,
          maxLines: 10,
        ),
      ),
    );
  }
}
