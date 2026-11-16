import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:path/path.dart' as p;

/// Snapshot of a directory tree: path → modified time.
Map<String, DateTime> _snapshot(Directory d) => !d.existsSync()
    ? const {}
    : {
        for (final f in d.listSync(recursive: true).whereType<File>())
          f.path: f.lastModifiedSync(),
      };

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test(
    'data-dir override moves database, prefs and the startup backup',
    () async {
      final tmp = await Directory.systemTemp.createTemp('idesk-data');
      addTearDown(() => tmp.delete(recursive: true));
      final home = Platform.environment['HOME'] ?? '';
      final documents = Directory(p.join(home, 'Documents'));
      final before = _snapshot(documents);

      final paths = await AppPaths.resolve(
        environment: {AppPaths.envOverride: tmp.path},
      );
      expect(paths.dataDir.path, tmp.path);
      expect(p.isWithin(tmp.path, paths.database.path), isTrue);
      expect(p.isWithin(tmp.path, paths.uiPrefs.path), isTrue);
      expect(p.isWithin(tmp.path, paths.defaultBackupDir.path), isTrue);

      final db = AppDatabase.file(paths.database);
      addTearDown(db.close);
      await db.settingsDao.get(); // open + seed, as on a first launch

      final backup = await startupHousekeeping(db, paths);
      expect(backup, isNotNull);
      expect(p.isWithin(tmp.path, backup!.path), isTrue);
      expect(backup.existsSync(), isTrue);
      expect(BackupService.inspect(backup).invoiceCount, 14); // the demo set

      // Second start the same day: not due again.
      expect(await startupHousekeeping(db, paths), isNull);

      // Nothing was written under ~/Documents.
      expect(_snapshot(documents), before);
      expect(
        Directory(p.join(documents.path, 'Invoice Desk Backups')).existsSync(),
        before.keys.any((k) => k.contains('Invoice Desk Backups')),
      );
    },
  );

  test('a backup folder chosen in settings wins over the default', () {
    final paths = AppPaths(Directory('/data'));
    expect(paths.backupDirFor(null).path, '/data/backups');
    expect(paths.backupDirFor('  ').path, '/data/backups');
    expect(paths.backupDirFor('/mnt/usb').path, '/mnt/usb');
  });
}
