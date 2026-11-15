import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/account/account.dart';
import 'package:invoice_desk/app/ui_prefs.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/providers.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/sync/sync.dart';
import 'package:package_info_plus/package_info_plus.dart';

export 'package:invoice_desk/data/providers.dart';

final uiPrefsProvider = Provider<UiPrefs>(
  (ref) => throw UnimplementedError('override uiPrefsProvider'),
);

/// Seam: who the user is to the future sync service. Bootstrap wires
/// [LocalAccountService]; nothing in the UI is ever gated on it.
final accountServiceProvider = Provider<AccountService>(
  (ref) => throw UnimplementedError('override accountServiceProvider'),
);

/// Seam: the future encrypted sync. Bootstrap wires [NoopSyncService].
final syncServiceProvider = Provider<SyncService>(
  (ref) => throw UnimplementedError('override syncServiceProvider'),
);

final syncStatusProvider = StreamProvider<SyncStatus>(
  (ref) => ref.watch(syncServiceProvider).status,
);

CalendarDate todayFrom(Ref ref) =>
    CalendarDate.fromDateTime(ref.read(clockProvider).now());

final todayProvider = Provider<CalendarDate>(todayFrom);

/// Fonts for the PDF, loaded once from bundled assets.
final pdfFontsProvider = FutureProvider<PdfFonts>((ref) async {
  Future<ByteData> f(String w) =>
      rootBundle.load('assets/fonts/IBMPlexSansArabic-$w.ttf');
  return PdfFonts.fromBytes(
    regular: await f('Regular'),
    semiBold: await f('SemiBold'),
    bold: await f('Bold'),
  );
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.read(uiPrefsProvider).themeMode;

  void set(ThemeMode mode) {
    state = mode;
    ref.read(uiPrefsProvider).themeMode = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// What the main pane shows. Invoice and contract editors keep their own
/// buffers; switching between them flushes the one being left.
enum Workspace { invoice, contract, settings, library }

class WorkspaceNotifier extends Notifier<Workspace> {
  @override
  Workspace build() => Workspace.invoice;
  void show(Workspace w) => state = w;
}

final workspaceProvider = NotifierProvider<WorkspaceNotifier, Workspace>(
  WorkspaceNotifier.new,
);

/// Edit vs preview tab (used when the window is too narrow for both).
class PreviewTabNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  // ignore: avoid_positional_boolean_parameters, simple toggle
  void set(bool preview) => state = preview;
}

final previewTabProvider = NotifierProvider<PreviewTabNotifier, bool>(
  PreviewTabNotifier.new,
);

/// `0.1.0 (1)` from the build (pubspec version / --build-name).
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.buildNumber.isEmpty
      ? info.version
      : '${info.version} (${info.buildNumber})';
});
