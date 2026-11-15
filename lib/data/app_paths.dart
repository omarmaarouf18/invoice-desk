import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Every on-disk location the app uses, derived from one data directory.
///
/// Overriding the data directory (env `INVOICE_DESK_DATA_DIR`, or a test)
/// moves the database, UI prefs and the default backup folder together, so
/// nothing is ever written next to the user's real data by accident.
class AppPaths {
  const AppPaths(this.dataDir);

  static const envOverride = 'INVOICE_DESK_DATA_DIR';
  static const dbFileName = 'invoice_desk.sqlite';

  final Directory dataDir;

  File get database => File(p.join(dataDir.path, dbFileName));
  File get uiPrefs => File(p.join(dataDir.path, 'ui_state.json'));

  /// Used when Settings has no backup folder.
  Directory get defaultBackupDir => Directory(p.join(dataDir.path, 'backups'));

  /// Backup folder from settings, else [defaultBackupDir].
  Directory backupDirFor(String? configured) =>
      configured != null && configured.trim().isNotEmpty
      ? Directory(configured)
      : defaultBackupDir;

  /// The env override when set, else the platform app-support directory.
  static Future<AppPaths> resolve({Map<String, String>? environment}) async {
    final env = environment ?? Platform.environment;
    final override = env[envOverride];
    final dir = override != null && override.trim().isNotEmpty
        ? Directory(override)
        : await getApplicationSupportDirectory();
    await dir.create(recursive: true);
    return AppPaths(dir);
  }
}
