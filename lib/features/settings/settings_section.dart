import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';

/// The sections of Settings, in navigation order (brief, Phase 6).
enum SettingsSection {
  general(Icons.tune),
  profile(Icons.person_outline),
  invoices(Icons.receipt_long_outlined),
  contracts(Icons.gavel_outlined),
  payment(Icons.payments_outlined),
  styles(Icons.palette_outlined),
  calendar(Icons.calendar_month_outlined),
  data(Icons.backup_outlined),
  sync(Icons.cloud_outlined),
  about(Icons.info_outline);

  const SettingsSection(this.icon);

  /// The navigation icon.
  final IconData icon;
}

/// The section Settings shows, remembered per machine.
class SettingsSectionNotifier extends Notifier<SettingsSection> {
  @override
  SettingsSection build() {
    final saved = ref.read(uiPrefsProvider).settingsSection;
    return SettingsSection.values.where((s) => s.name == saved).firstOrNull ??
        SettingsSection.general;
  }

  void set(SettingsSection s) {
    if (state == s) return;
    state = s;
    ref.read(uiPrefsProvider).settingsSection = s.name;
  }
}

final settingsSectionProvider =
    NotifierProvider<SettingsSectionNotifier, SettingsSection>(
      SettingsSectionNotifier.new,
    );

/// Opens Settings at [section] (e.g. Payment from the "add a payment
/// method" warning).
void openSettings(WidgetRef ref, SettingsSection section) {
  ref.read(settingsSectionProvider.notifier).set(section);
  ref.read(workspaceProvider.notifier).show(Workspace.settings);
}
