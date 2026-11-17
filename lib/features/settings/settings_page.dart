import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/repositories/settings_repository.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/sync/sync.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';
import 'package:path/path.dart' as p;

part 'settings/about_card.dart';
part 'settings/appearance_card.dart';
part 'settings/backup_card.dart';
part 'settings/calendar_cards.dart';
part 'settings/form_cards.dart';
part 'settings/general_card.dart';
part 'settings/sync_card.dart';

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
    final s = _draft;
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
                _SettingsHeader(dirty: _dirty),
                const SizedBox(height: Space.l),
                const _GeneralCard(),
                cardGap,
                _ProfileCard(s: s, update: _update),
                cardGap,
                _InvoicingCard(s: s, update: _update),
                cardGap,
                _ContractsSettingsCard(s: s, update: _update),
                cardGap,
                _PaymentCard(s: s, update: _update),
                cardGap,
                _NotesCard(s: s, update: _update),
                cardGap,
                const _AppearanceCard(),
                cardGap,
                const _CalendarCard(),
                cardGap,
                const _DemoCard(),
                cardGap,
                _BackupCard(
                  settings: s,
                  onDirChanged: (d) => _update((x) => x.copyWith(backupDir: d)),
                ),
                cardGap,
                const _SyncCard(),
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
