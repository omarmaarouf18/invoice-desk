import 'dart:io';

import 'package:clock/clock.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/data/repositories/repository.dart';

/// What "حذف البيانات التجريبية" did.
class DemoRemoval {
  /// Counts of hard-deleted rows, plus the safety backup.
  const DemoRemoval({
    required this.backup,
    required this.invoices,
    required this.contracts,
    required this.clients,
    required this.reminders,
    this.keptClients = 0,
  });

  /// The `before-remove-demo-…` backup written first.
  final File backup;

  /// Demo invoices deleted.
  final int invoices;

  /// Demo contracts deleted (amendments included).
  final int contracts;

  /// Demo clients deleted.
  final int clients;

  /// Demo reminders deleted.
  final int reminders;

  /// Demo clients kept because an adopted (edited) document still uses
  /// them; they are real from now on.
  final int keptClients;
}

/// Settings → "البيانات التجريبية": adds the demo set on demand and removes
/// exactly the rows flagged `is_demo`, never anything else.
class DemoRepository with ClockedRepository {
  /// Wraps [_db]; removal backs up through [_backups] first.
  DemoRepository(this._db, this._backups, {this.clock = const Clock()});
  final AppDatabase _db;
  final BackupService _backups;
  @override
  final Clock clock;

  static const _count =
      'SELECT (SELECT COUNT(*) FROM clients WHERE is_demo = 1) + '
      '(SELECT COUNT(*) FROM invoices WHERE is_demo = 1) + '
      '(SELECT COUNT(*) FROM contracts WHERE is_demo = 1) + '
      '(SELECT COUNT(*) FROM reminders WHERE is_demo = 1) AS n';

  /// Whether any demo row exists, live.
  Stream<bool> watchHasDemo() => _db
      .customSelect(
        _count,
        readsFrom: {_db.clients, _db.invoices, _db.contracts, _db.reminders},
      )
      .watchSingle()
      .map((r) => r.read<int>('n') > 0);

  /// Whether any demo row exists.
  Future<bool> hasDemo() async =>
      (await _db.customSelect(_count).getSingle()).read<int>('n') > 0;

  /// Seeds the demo set dated around today; false (and nothing written)
  /// while demo rows already exist.
  Future<bool> addDemo() => at(() async {
    if (await hasDemo()) return false;
    await seedDemo(_db, clock: clock);
    return true;
  });

  /// Backs up, then hard-deletes every `is_demo` row and what hangs off
  /// it only: their sections, items, clauses, milestones (cascades) and
  /// postponements. A demo client that an adopted document still uses is
  /// kept and becomes real.
  Future<DemoRemoval> removeDemo() => at(() async {
    final backup = await _backups.backupBefore('remove-demo');
    late DemoRemoval result;
    await _db.transaction(() async {
      Future<int> run(String sql) => _db.customUpdate(
        sql,
        updates: {
          _db.clients,
          _db.invoices,
          _db.contracts,
          _db.reminders,
          _db.postponements,
          _db.paymentMilestones,
        },
      );
      await run(
        'DELETE FROM postponements WHERE '
        "(entity_type = 'invoice' AND entity_id IN "
        '(SELECT id FROM invoices WHERE is_demo = 1)) OR '
        "(entity_type = 'milestone' AND entity_id IN "
        '(SELECT m.id FROM payment_milestones m JOIN contracts c '
        'ON c.id = m.contract_id WHERE c.is_demo = 1))',
      );
      final reminders = await run('DELETE FROM reminders WHERE is_demo = 1');
      // Amendments of a demo original go with it (ON DELETE CASCADE).
      final contracts = await run('DELETE FROM contracts WHERE is_demo = 1');
      final invoices = await run('DELETE FROM invoices WHERE is_demo = 1');
      const used =
          'EXISTS (SELECT 1 FROM invoices i WHERE i.client_id = clients.id) '
          'OR EXISTS (SELECT 1 FROM contracts k '
          'WHERE k.client_id = clients.id)';
      final clients = await run(
        'DELETE FROM clients WHERE is_demo = 1 AND NOT ($used)',
      );
      final now = clock.now().toUtc().millisecondsSinceEpoch;
      final kept = await _db.customUpdate(
        // `now` is an int, safe to inline.
        'UPDATE clients SET is_demo = 0, updated_at = $now WHERE is_demo = 1',
        updates: {_db.clients},
      );
      result = DemoRemoval(
        backup: backup,
        invoices: invoices,
        contracts: contracts,
        clients: clients,
        reminders: reminders,
        keptClients: kept,
      );
    });
    return result;
  });
}
