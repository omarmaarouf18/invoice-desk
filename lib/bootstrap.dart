import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/account/account.dart';
import 'package:invoice_desk/app/app.dart';
import 'package:invoice_desk/app/desktop_notifier.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/app/ui_prefs.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/sync/sync.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:window_manager/window_manager.dart';

const _minSize = Size(1100, 720);

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (d) {
    FlutterError.presentError(d);
  };
  PlatformDispatcher.instance.onError = (e, st) {
    debugPrint('Uncaught: $e\n$st');
    return true;
  };

  final paths = await AppPaths.resolve();
  final prefs = await UiPrefs.load(paths.uiPrefs);

  await _setUpWindow(prefs);
  await _start(paths, prefs);
}

Future<void> _setUpWindow(UiPrefs prefs) async {
  await windowManager.ensureInitialized();
  final bounds = prefs.windowBounds;
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      title: 'Invoice Desk',
      minimumSize: _minSize,
      size: Size(1440, 900),
      center: true,
    ),
    () async {
      if (bounds != null &&
          bounds.width >= _minSize.width &&
          bounds.height >= _minSize.height) {
        await windowManager.setBounds(bounds);
      }
      await windowManager.show();
      await windowManager.focus();
    },
  );
}

Future<void> _start(AppPaths paths, UiPrefs prefs) async {
  final file = paths.database;
  AppDatabase? db;
  try {
    db = AppDatabase.file(file);
    await db.settingsDao.get(); // forces open + migrations + seed
  } on Object catch (e, st) {
    debugPrint('DB open failed: $e\n$st');
    await db?.close();
    runApp(
      _DbErrorApp(
        paths: paths,
        onRestored: () => unawaited(_start(paths, prefs)),
      ),
    );
    return;
  }

  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      // The desktop app is local-only; sync is a future add-on.
      accountServiceProvider.overrideWithValue(const LocalAccountService()),
      syncServiceProvider.overrideWithValue(const NoopSyncService()),
      uiPrefsProvider.overrideWithValue(prefs),
      appPathsProvider.overrideWithValue(paths),
      desktopNotifierProvider.overrideWithValue(const LinuxDesktopNotifier()),
    ],
  );
  windowManager.addListener(_WindowSaver(container, prefs));
  await windowManager.setPreventClose(true);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const InvoiceDeskApp(),
    ),
  );

  // Restore the last open invoice, then housekeeping off the first frame.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final last = prefs.lastInvoiceId;
    if (last != null) {
      unawaited(
        container.read(editorProvider.notifier).open(last, reveal: false),
      );
    }
    unawaited(_housekeeping(db!, paths));
  });
}

Future<void> _housekeeping(AppDatabase db, AppPaths paths) async {
  try {
    await startupHousekeeping(db, paths);
  } on Object catch (e) {
    debugPrint('housekeeping: $e');
  }
}

class _WindowSaver extends WindowListener {
  _WindowSaver(this.container, this.prefs);
  final ProviderContainer container;
  final UiPrefs prefs;

  Future<void> _saveBounds() async {
    if (await windowManager.isMaximized() ||
        await windowManager.isFullScreen()) {
      return;
    }
    prefs.windowBounds = await windowManager.getBounds();
  }

  @override
  void onWindowResized() => unawaited(_saveBounds());

  @override
  void onWindowMoved() => unawaited(_saveBounds());

  @override
  void onWindowClose() => unawaited(_close());

  Future<void> _close() async {
    try {
      await container.read(editorProvider.notifier).flush();
      await _saveBounds();
      await prefs.flush();
      await container.read(databaseProvider).close();
    } finally {
      await windowManager.destroy();
    }
  }
}

/// Shown when the database cannot be opened.
class _DbErrorApp extends StatelessWidget {
  const _DbErrorApp({required this.paths, required this.onRestored});
  final AppPaths paths;
  final VoidCallback onRestored;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: appLocale,
    supportedLocales: const [appLocale],
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    theme: buildTheme(Brightness.light),
    darkTheme: buildTheme(Brightness.dark),
    home: _DbErrorPage(paths: paths, onRestored: onRestored),
  );
}

class _DbErrorPage extends StatefulWidget {
  const _DbErrorPage({required this.paths, required this.onRestored});
  final AppPaths paths;
  final VoidCallback onRestored;

  @override
  State<_DbErrorPage> createState() => _DbErrorPageState();
}

class _DbErrorPageState extends State<_DbErrorPage> {
  String? _message;

  Future<void> _restore() async {
    final l = context.l10n;
    final dir = widget.paths.defaultBackupDir;
    final picked = await openFile(
      initialDirectory: dir.existsSync() ? dir.path : null,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'SQLite', extensions: ['sqlite', 'db']),
      ],
    );
    if (picked == null) return;
    try {
      final info = BackupService.inspect(File(picked.path));
      if (!info.isCompatible) throw const BackupException('version');
    } on BackupException {
      setState(() => _message = l.restoreBad);
      return;
    }
    // The live DB is closed here; keep the broken file aside, then swap.
    if (widget.paths.database.existsSync()) {
      await widget.paths.database.rename(
        '${widget.paths.database.path}.broken-${DateTime.now().millisecondsSinceEpoch}',
      );
    }
    for (final s in ['-wal', '-shm']) {
      final f = File('${widget.paths.database.path}$s');
      if (f.existsSync()) await f.delete();
    }
    await File(picked.path).copy(widget.paths.database.path);
    widget.onRestored();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.storage_outlined,
                size: 40,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: Space.m),
              Text(l.dbErrorTitle, style: theme.textTheme.headlineSmall),
              const SizedBox(height: Space.s),
              Text(l.dbErrorBody, textAlign: TextAlign.center),
              if (_message != null) ...[
                const SizedBox(height: Space.s),
                Text(
                  _message!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ],
              const SizedBox(height: Space.l),
              Wrap(
                spacing: Space.s,
                children: [
                  FilledButton.icon(
                    onPressed: () => unawaited(_restore()),
                    icon: const Icon(Icons.restore, size: 18),
                    label: Text(l.restore),
                  ),
                  OutlinedButton(
                    onPressed: widget.onRestored,
                    child: Text(l.retry),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
