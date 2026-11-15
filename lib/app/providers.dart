import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/ui_prefs.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/trash_repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/trash.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Seams: overridden in bootstrap (and in tests).
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('override databaseProvider'),
);

final uiPrefsProvider = Provider<UiPrefs>(
  (ref) => throw UnimplementedError('override uiPrefsProvider'),
);

final appPathsProvider = Provider<AppPaths>(
  (ref) => throw UnimplementedError('override appPathsProvider'),
);

final clockProvider = Provider<Clock>((ref) => const Clock());

CalendarDate todayFrom(Ref ref) =>
    CalendarDate.fromDateTime(ref.read(clockProvider).now());

final todayProvider = Provider<CalendarDate>(todayFrom);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(databaseProvider),
    paths: ref.watch(appPathsProvider),
  ),
);

final trashRepositoryProvider = Provider<TrashRepository>(
  (ref) => TrashRepository(
    ref.watch(databaseProvider),
    ref.watch(backupServiceProvider),
  ),
);

/// "المحذوفات", newest deletion first.
final trashProvider = StreamProvider<List<TrashEntry>>(
  (ref) => ref.watch(trashRepositoryProvider).watch(),
);

final settingsProvider = StreamProvider<Settings>(
  (ref) => ref.watch(databaseProvider).settingsDao.watch(),
);

final clientsProvider = StreamProvider<List<Client>>(
  (ref) => ref.watch(databaseProvider).clientsDao.watchAll(),
);

final invoicesProvider = StreamProvider<List<Invoice>>(
  (ref) => ref.watch(databaseProvider).invoicesDao.watchAll(),
);

final contractsProvider = StreamProvider<List<Contract>>(
  (ref) => ref.watch(databaseProvider).contractsDao.watchAll(),
);

/// The clause library (Settings → مكتبة البنود).
final libraryProvider = StreamProvider<List<ClauseTemplate>>(
  (ref) => ref.watch(databaseProvider).libraryDao.watchAll(),
);

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
