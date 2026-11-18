import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:path/path.dart' as p;

import '../drift/app_db/generated/schema.dart';
import '../drift/app_db/migration_test.dart' show insertV1Data;
import '../helpers/legacy_seed.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final verifier = SchemaVerifier(GeneratedHelper());

  for (final version in [1, 2, 3, 4, 5, 6, 7]) {
    test('a v$version backup restores into the current schema', () async {
      final dir = await Directory.systemTemp.createTemp('bk');
      addTearDown(() => dir.delete(recursive: true));
      final schema = await verifier.schemaAt(version);
      insertV1Data(schema.rawDatabase);
      final file = File(p.join(dir.path, 'old-v$version.sqlite'));
      schema.rawDatabase
        ..execute('PRAGMA user_version = $version')
        ..execute('VACUUM INTO ?', [file.path]);

      final info = BackupService.inspect(file);
      expect(info.userVersion, version);
      expect(info.isCompatible, isTrue);

      // A current DB with its own library (and a contract that the
      // restore replaces).
      final db = AppDatabase.memory(seeder: legacySeed);
      addTearDown(db.close);
      final templates = await db.libraryDao.getAll();
      expect(templates, hasLength(2));

      await BackupService(db, paths: AppPaths(dir)).restoreFrom(file);
      expect(
        (await db.clientsDao.getAll()).map((c) => c.name),
        containsAll(['Sample Academy', 'Empty Co']),
      );
      expect((await db.invoicesDao.getAll()).single.number, 'OM-2026-0001');
      expect((await db.settingsDao.get()).contractPrefix, 'CT');
      expect(await db.contractsDao.getAll(), isEmpty);
      // v1/v2 backups have no library tables, so the current library stays;
      // a v3 backup has its own (empty here) library, which replaces it.
      expect(await db.libraryDao.getAll(), hasLength(version < 3 ? 2 : 0));
      // Restored rows are sync-ready and this device keeps its id.
      final device = await db
          .customSelect('SELECT device_id FROM settings')
          .getSingle();
      expect(device.read<String>('device_id'), hasLength(36));
    });
  }
}
