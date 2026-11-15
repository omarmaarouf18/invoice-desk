import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sql;

/// What a backup file contains, read without touching the live DB.
class BackupInfo {
  const BackupInfo({
    required this.file,
    required this.userVersion,
    required this.invoiceCount,
    required this.clientCount,
    required this.modified,
  });

  final File file;
  final int userVersion;
  final int invoiceCount;
  final int clientCount;
  final DateTime modified;

  /// Backups from this or an older schema can be restored; columns added
  /// since then take their defaults.
  bool get isCompatible =>
      userVersion >= 1 && userVersion <= AppDatabase.currentSchemaVersion;
}

class BackupException implements Exception {
  const BackupException(this.message);
  final String message;
  @override
  String toString() => 'BackupException: $message';
}

final _backupName = RegExp(r'^invoice-desk-\d{4}-\d{2}-\d{2}\.sqlite$');

class BackupService {
  /// [clock] dates the backup files and `lastBackupAt`.
  BackupService(this._db, {required this.paths, this.clock = const Clock()});
  final AppDatabase _db;

  final Clock clock;

  /// Where the default backup folder comes from (follows the data dir).
  final AppPaths paths;

  /// `VACUUM INTO` a dated file in [dir], verify it reopens, keep the last
  /// [keep] backups. Returns the new file.
  Future<File> backupNow(Directory dir, {int keep = 30}) async {
    await dir.create(recursive: true);
    final today = CalendarDate.fromDateTime(clock.now());
    final target = await _writeVerified(
      File(p.join(dir.path, 'invoice-desk-${today.toIso()}.sqlite')),
    );
    await prune(dir, keep: keep);
    return target;
  }

  /// One-off backup before a destructive action, written to the configured
  /// backup folder as `before-<label>-<timestamp>.sqlite`. Not pruned.
  Future<File> backupBefore(String label) async {
    final s = await _db.settingsDao.get();
    final dir = paths.backupDirFor(s.backupDir);
    await dir.create(recursive: true);
    final now = clock.now();
    String two(int v) => v.toString().padLeft(2, '0');
    final stamp =
        '${CalendarDate.fromDateTime(now).toIso()}'
        '-${two(now.hour)}${two(now.minute)}${two(now.second)}';
    return _writeVerified(
      File(p.join(dir.path, 'before-$label-$stamp.sqlite')),
    );
  }

  /// Checkpoints the WAL, `VACUUM INTO`s a temp file, checks it reopens with
  /// every invoice, then moves it to [target].
  Future<File> _writeVerified(File target) async {
    // VACUUM INTO refuses to overwrite; write to a temp name then swap.
    final tmp = File('${target.path}.tmp');
    if (tmp.existsSync()) await tmp.delete();
    await _db.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    await _db.customStatement('VACUUM INTO ?', [tmp.path]);

    final info = inspect(tmp);
    final live = await _db.invoicesDao.getAll(includeDeleted: true);
    if (info.invoiceCount != live.length) {
      await tmp.delete();
      throw const BackupException('verification failed');
    }
    if (target.existsSync()) await target.delete();
    await tmp.rename(target.path);
    return target;
  }

  /// "نسخ احتياطي الآن": a backup into [dir], recorded as the last backup.
  Future<File> backupNowAndRecord(Directory dir) async {
    final file = await backupNow(dir);
    final s = await _db.settingsDao.get();
    await _db.settingsDao.save(
      s.copyWith(lastBackupAt: clock.now().toUtc().millisecondsSinceEpoch),
    );
    return file;
  }

  /// Runs a backup when the last one is older than 24 h. Returns the file
  /// written, or null when none was due.
  Future<File?> backupIfDue() async {
    final s = await _db.settingsDao.get();
    final nowMs = clock.now().toUtc().millisecondsSinceEpoch;
    final last = s.lastBackupAt;
    if (last != null &&
        nowMs - last < const Duration(hours: 24).inMilliseconds) {
      return null;
    }
    final dir = paths.backupDirFor(s.backupDir);
    final file = await backupNow(dir);
    await _db.settingsDao.save(s.copyWith(lastBackupAt: nowMs));
    return file;
  }

  Future<void> prune(Directory dir, {int keep = 30}) async {
    final files =
        dir
            .listSync()
            .whereType<File>()
            .where((f) => _backupName.hasMatch(p.basename(f.path)))
            .toList()
          ..sort((a, b) => p.basename(b.path).compareTo(p.basename(a.path)));
    for (final f in files.skip(keep)) {
      await f.delete();
    }
  }

  /// Opens [file] read-only and reports what it holds. Throws
  /// [BackupException] when it is not an Invoice Desk database.
  static BackupInfo inspect(File file) {
    sql.Database? raw;
    try {
      raw = sql.sqlite3.open(file.path, mode: sql.OpenMode.readOnly);
      final version =
          raw.select('PRAGMA user_version').first.values.first! as int;
      final inv =
          raw.select('SELECT COUNT(*) AS c FROM invoices').first['c'] as int;
      final cl =
          raw.select('SELECT COUNT(*) AS c FROM clients').first['c'] as int;
      return BackupInfo(
        file: file,
        userVersion: version,
        invoiceCount: inv,
        clientCount: cl,
        modified: file.lastModifiedSync(),
      );
    } on sql.SqliteException catch (e) {
      throw BackupException(e.message);
    } finally {
      raw?.close();
    }
  }

  /// Replaces all data with the contents of [file], in one transaction.
  /// A safety backup of the current data is written to [safetyDir] first.
  Future<void> restoreFrom(File file, {Directory? safetyDir}) async {
    final info = inspect(file);
    if (!info.isCompatible) {
      throw BackupException('unsupported version ${info.userVersion}');
    }
    if (safetyDir != null) {
      await safetyDir.create(recursive: true);
      final stamp = clock.now().millisecondsSinceEpoch;
      await _db.customStatement(
        'VACUUM INTO ?',
        [p.join(safetyDir.path, 'before-restore-$stamp.sqlite')],
      );
    }
    // Parents before children; deleted in reverse.
    const tables = [
      'settings',
      'clients',
      'invoices',
      'sections',
      'items',
      'clause_templates',
      'library_clauses',
      'contracts',
      'contract_clauses',
      'scope_items',
      'payment_milestones',
    ];
    // A v1/v2 backup has no library: keep the current one in that case.
    const library = {'clause_templates', 'library_clauses'};
    await _db.customStatement('ATTACH DATABASE ? AS bk', [file.path]);
    try {
      await _db.transaction(() async {
        Future<List<String>> backupColumns(String t) async => [
          for (final r
              in await _db
                  .customSelect(
                    'SELECT name FROM pragma_table_info(?, ?)',
                    variables: [Variable(t), const Variable('bk')],
                  )
                  .get())
            '"${r.read<String>('name')}"',
        ];
        final cols = {for (final t in tables) t: await backupColumns(t)};
        bool skip(String t) => library.contains(t) && cols[t]!.isEmpty;
        for (final t in tables.reversed) {
          if (!skip(t)) await _db.customStatement('DELETE FROM main.$t');
        }
        for (final t in tables) {
          // Named columns, so an older backup (fewer columns, fewer
          // tables) still loads; new columns take their defaults.
          if (cols[t]!.isEmpty) continue;
          final list = cols[t]!.join(', ');
          await _db.customStatement(
            'INSERT INTO main.$t ($list) SELECT $list FROM bk.$t',
          );
        }
      });
    } finally {
      await _db.customStatement('DETACH DATABASE bk');
    }
    _db.markAllUpdated();
  }
}

/// Start-up housekeeping: purge old soft-deletes, then the daily backup.
Future<File?> startupHousekeeping(AppDatabase db, AppPaths paths) async {
  await db.contractsDao.purgeDeleted();
  await db.invoicesDao.purgeDeleted();
  await db.clientsDao.purgeDeleted();
  return BackupService(db, paths: paths).backupIfDue();
}
