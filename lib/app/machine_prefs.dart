import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';

/// How tightly controls are packed.
enum UiDensity {
  /// Today's layout (the default).
  compact,

  /// More room around controls.
  comfortable,
}

/// The app's accent colour. [teal] is today's palette, exactly.
enum UiAccent {
  teal(Color(0xFF0F766E)),
  blue(Color(0xFF1D4ED8)),
  indigo(Color(0xFF4F46E5)),
  purple(Color(0xFF7E22CE)),
  rose(Color(0xFFBE123C)),
  amber(Color(0xFFB45309));

  const UiAccent(this.seed);

  /// The colour the scheme is built from.
  final Color seed;
}

/// What the window shows at start-up.
enum StartupView {
  /// The workspace as it was left (today's behaviour).
  last,

  /// Always the calendar.
  calendar,
}

/// Settings that belong to this machine, not to the data: kept in
/// `UiPrefs` (next to the database), never synced or backed up.
@immutable
class MachinePrefs {
  const MachinePrefs({
    this.density = UiDensity.compact,
    this.accent = UiAccent.teal,
    this.startupView = StartupView.last,
    this.pdfNamePattern = defaultPdfNamePattern,
    this.exportFolder,
    this.openAfterExport = false,
  });

  /// [json] read back; unknown or missing values are the defaults.
  factory MachinePrefs.fromJson(Map<String, Object?> json) {
    T pick<T extends Enum>(List<T> values, Object? v, T fallback) =>
        values.where((e) => e.name == v).firstOrNull ?? fallback;
    final pattern = json['pdfNamePattern'];
    final folder = json['exportFolder'];
    return MachinePrefs(
      density: pick(UiDensity.values, json['density'], UiDensity.compact),
      accent: pick(UiAccent.values, json['accent'], UiAccent.teal),
      startupView: pick(
        StartupView.values,
        json['startupView'],
        StartupView.last,
      ),
      pdfNamePattern: pattern is String && pattern.trim().isNotEmpty
          ? pattern
          : defaultPdfNamePattern,
      exportFolder: folder is String && folder.isNotEmpty ? folder : null,
      openAfterExport: json['openAfterExport'] == true,
    );
  }

  /// Today's file names: `OM-2026-0001 - Acme Studio.pdf`.
  static const defaultPdfNamePattern = '{NUMBER} - {CLIENT}';

  final UiDensity density;
  final UiAccent accent;
  final StartupView startupView;

  /// Suggested PDF file name: `{NUMBER}`, `{CLIENT}`, `{DATE}` (ISO).
  final String pdfNamePattern;

  /// Where the save dialog starts; null uses the last folder exported to.
  final String? exportFolder;

  /// Open the PDF once it is written.
  final bool openAfterExport;

  Map<String, Object?> toJson() => {
    'density': density.name,
    'accent': accent.name,
    'startupView': startupView.name,
    'pdfNamePattern': pdfNamePattern,
    'exportFolder': exportFolder,
    'openAfterExport': openAfterExport,
  };

  MachinePrefs copyWith({
    UiDensity? density,
    UiAccent? accent,
    StartupView? startupView,
    String? pdfNamePattern,
    String? Function()? exportFolder,
    bool? openAfterExport,
  }) => MachinePrefs(
    density: density ?? this.density,
    accent: accent ?? this.accent,
    startupView: startupView ?? this.startupView,
    pdfNamePattern: pdfNamePattern ?? this.pdfNamePattern,
    exportFolder: exportFolder != null ? exportFolder() : this.exportFolder,
    openAfterExport: openAfterExport ?? this.openAfterExport,
  );
}

/// [pattern] filled for one document, made safe as a file name (no path
/// separators or characters Windows refuses), without the extension.
String pdfFileName(
  String pattern, {
  required String number,
  required String client,
  required String date,
}) {
  final name = pattern
      .replaceAll('{NUMBER}', number)
      .replaceAll('{CLIENT}', client)
      .replaceAll('{DATE}', date)
      .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  // A pattern whose tokens were all empty still needs a name.
  return name.replaceAll(RegExp(r'^[\s-]+|[\s-]+$'), '').isEmpty
      ? number
      : name.replaceAll(RegExp(r'^[\s-]+|[\s-]+$'), '');
}

/// The machine prefs, saved to `UiPrefs` on every change.
class MachinePrefsNotifier extends Notifier<MachinePrefs> {
  @override
  MachinePrefs build() =>
      MachinePrefs.fromJson(ref.read(uiPrefsProvider).machine);

  void update(MachinePrefs Function(MachinePrefs p) change) {
    state = change(state);
    ref.read(uiPrefsProvider).machine = state.toJson();
  }
}

final machinePrefsProvider =
    NotifierProvider<MachinePrefsNotifier, MachinePrefs>(
      MachinePrefsNotifier.new,
    );
