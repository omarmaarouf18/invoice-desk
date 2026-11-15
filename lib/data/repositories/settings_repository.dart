import 'package:clock/clock.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/models.dart';

/// The single settings row (profile, numbering, contract defaults).
class SettingsRepository with ClockedRepository {
  /// Creates the repository over [_db]; writes are stamped by [clock].
  SettingsRepository(this._db, {this.clock = const Clock()});
  final AppDatabase _db;
  @override
  final Clock clock;

  /// Emits on every change; defaults until the row exists.
  Stream<Settings> watch() => _db.settingsDao.watch();

  Future<Settings> get() => _db.settingsDao.get();

  /// Saves everything except backup bookkeeping, which the backup service
  /// owns: the stored `lastBackupAt` is kept.
  Future<void> save(Settings s) => at(() async {
    final current = await _db.settingsDao.get();
    await _db.settingsDao.save(s.copyWith(lastBackupAt: current.lastBackupAt));
  });

  /// Saves exactly [s], backup bookkeeping included (backup service only).
  Future<void> saveAll(Settings s) => at(() => _db.settingsDao.save(s));
}
