import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/repositories/settings_repository.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

part 'settings/appearance_card.dart';
part 'settings/backup_card.dart';
part 'settings/about_card.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return switch (settings) {
      AsyncData(:final value) => _SettingsForm(initial: value),
      AsyncError() => Center(child: Text(context.l10n.dbErrorTitle)),
      _ => const SizedBox.shrink(),
    };
  }
}

class _SettingsForm extends ConsumerStatefulWidget {
  const _SettingsForm({required this.initial});
  final Settings initial;

  @override
  ConsumerState<_SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends ConsumerState<_SettingsForm> {
  late Settings _draft = widget.initial;
  Timer? _timer;
  bool _dirty = false;
  // Captured while ref is valid; also used from dispose.
  late final SettingsRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = ref.read(settingsRepositoryProvider);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (_dirty) unawaited(_persist());
    super.dispose();
  }

  @override
  void didUpdateWidget(_SettingsForm old) {
    super.didUpdateWidget(old);
    // External changes (restore, backup timestamp) win when nothing is pending.
    if (!_dirty) _draft = widget.initial;
  }

  void _update(Settings Function(Settings s) f) {
    setState(() {
      _draft = f(_draft);
      _dirty = true;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 600), () => unawaited(_save()));
  }

  // Backup bookkeeping is owned by the backup service; save() keeps it.
  Future<void> _persist() => _repo.save(_draft);

  Future<void> _save() async {
    _timer?.cancel();
    await _persist();
    if (mounted) setState(() => _dirty = false);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = _draft;
    Widget f(
      String label,
      String value,
      Settings Function(Settings s, String v) set, {
      TextDirection? dir,
      int minLines = 1,
      int maxLines = 1,
      String? hint,
    }) => SyncedTextField(
      label: label,
      hint: hint,
      value: value,
      textDirection: dir,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: maxLines > 1 ? TextInputType.multiline : null,
      onChanged: (v) => _update((x) => set(x, v)),
    );
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: Space.m - 4),
        Expanded(child: b),
      ],
    );
    const gap = SizedBox(height: Space.m - 4);
    const cardGap = SizedBox(height: Space.m);

    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          Space.l,
          Space.l,
          Space.l,
          Space.xl * 2,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.settingsTitle,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            l.settingsSubtitle,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _dirty ? l.saving : l.saved,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: Space.m),
                    OutlinedButton.icon(
                      onPressed: () => ref
                          .read(workspaceProvider.notifier)
                          .show(Workspace.invoice),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: Text(l.back),
                    ),
                  ],
                ),
                const SizedBox(height: Space.l),
                PanelCard(
                  title: l.profile,
                  icon: Icons.person_outline,
                  child: Column(
                    children: [
                      pair(
                        f(l.name, s.name, (x, v) => x.copyWith(name: v)),
                        f(l.role, s.role, (x, v) => x.copyWith(role: v)),
                      ),
                      gap,
                      pair(
                        f(l.city, s.city, (x, v) => x.copyWith(city: v)),
                        f(
                          l.website,
                          s.website,
                          (x, v) => x.copyWith(website: v),
                          dir: TextDirection.ltr,
                        ),
                      ),
                      gap,
                      pair(
                        f(
                          l.email,
                          s.email,
                          (x, v) => x.copyWith(email: v),
                          dir: TextDirection.ltr,
                        ),
                        f(
                          l.phone,
                          s.phone,
                          (x, v) => x.copyWith(phone: v),
                          dir: TextDirection.ltr,
                        ),
                      ),
                    ],
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.invoicing,
                  icon: Icons.tag,
                  child: pair(
                    f(
                      l.invoicePrefix,
                      s.invoicePrefix,
                      (x, v) => x.copyWith(
                        invoicePrefix: v.trim().isEmpty
                            ? x.invoicePrefix
                            : v.trim(),
                      ),
                      dir: TextDirection.ltr,
                      hint: l.prefixHint,
                    ),
                    f(
                      l.defaultDueDays,
                      '${s.defaultDueDays}',
                      (x, v) {
                        final d = parseIntInput(v);
                        return d == null || d > 3650
                            ? x
                            : x.copyWith(defaultDueDays: d);
                      },
                      dir: TextDirection.ltr,
                    ),
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.contractsSettings,
                  icon: Icons.gavel_outlined,
                  trailing: FilledButton.tonalIcon(
                    key: const ValueKey('open-library'),
                    onPressed: () => ref
                        .read(workspaceProvider.notifier)
                        .show(Workspace.library),
                    icon: const Icon(Icons.library_books_outlined, size: 18),
                    label: Text(l.openLibrary),
                  ),
                  child: Column(
                    children: [
                      pair(
                        f(
                          l.legalName,
                          s.legalName,
                          (x, v) => x.copyWith(legalName: v),
                        ),
                        f(
                          l.nationalIdOrRegistry,
                          s.nationalIdOrRegistry,
                          (x, v) => x.copyWith(nationalIdOrRegistry: v),
                        ),
                      ),
                      gap,
                      f(
                        l.address,
                        s.address,
                        (x, v) => x.copyWith(address: v),
                      ),
                      gap,
                      pair(
                        f(
                          l.contractPrefix,
                          s.contractPrefix,
                          (x, v) => x.copyWith(
                            contractPrefix: v.trim().isEmpty
                                ? x.contractPrefix
                                : v.trim(),
                          ),
                          dir: TextDirection.ltr,
                        ),
                        f(
                          l.quotePrefix,
                          s.quotePrefix,
                          (x, v) => x.copyWith(
                            quotePrefix: v.trim().isEmpty
                                ? x.quotePrefix
                                : v.trim(),
                          ),
                          dir: TextDirection.ltr,
                        ),
                      ),
                      gap,
                      f(
                        l.defaultJurisdiction,
                        s.defaultJurisdiction,
                        (x, v) => x.copyWith(defaultJurisdiction: v),
                      ),
                      gap,
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: s.contractWesternDigits,
                        title: Text(l.westernDigits),
                        onChanged: (v) => _update(
                          (x) => x.copyWith(contractWesternDigits: v),
                        ),
                      ),
                    ],
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.payment,
                  icon: Icons.account_balance_outlined,
                  child: Column(
                    children: [
                      pair(
                        f(
                          l.instapay,
                          s.instapay,
                          (x, v) => x.copyWith(instapay: v),
                          dir: TextDirection.ltr,
                        ),
                        f(
                          l.wallet,
                          s.wallet,
                          (x, v) => x.copyWith(wallet: v),
                          dir: TextDirection.ltr,
                        ),
                      ),
                      gap,
                      f(
                        l.bankIban,
                        s.bankIban,
                        (x, v) => x.copyWith(bankIban: v),
                        dir: TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
                cardGap,
                PanelCard(
                  title: l.defaultNotes,
                  icon: Icons.notes_outlined,
                  child: pair(
                    f(
                      l.notesEn,
                      s.notesEn,
                      (x, v) => x.copyWith(notesEn: v),
                      dir: TextDirection.ltr,
                      minLines: 4,
                      maxLines: 10,
                    ),
                    f(
                      l.notesAr,
                      s.notesAr,
                      (x, v) => x.copyWith(notesAr: v),
                      dir: TextDirection.rtl,
                      minLines: 4,
                      maxLines: 10,
                    ),
                  ),
                ),
                cardGap,
                const _AppearanceCard(),
                cardGap,
                _BackupCard(
                  settings: s,
                  onDirChanged: (d) => _update((x) => x.copyWith(backupDir: d)),
                ),
                cardGap,
                const _AboutCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
