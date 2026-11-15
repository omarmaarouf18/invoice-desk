import 'package:meta/meta.dart';

/// What the (future) sync engine is doing. The UI may show it; nothing
/// local ever waits on it.
sealed class SyncStatus {
  const SyncStatus();
}

/// Sync is not set up (today, always).
class SyncDisabled extends SyncStatus {
  /// Sync is off.
  const SyncDisabled();
}

/// Set up and up to date.
class SyncIdle extends SyncStatus {
  /// Nothing pending.
  const SyncIdle();
}

/// Pushing or pulling.
class SyncSyncing extends SyncStatus {
  /// A push or pull is running.
  const SyncSyncing();
}

/// The last attempt failed; local data is untouched and the outbox keeps
/// every change for the next attempt.
@immutable
class SyncError extends SyncStatus {
  /// [code] is a stable, machine-readable reason (`offline`, `auth`, …).
  const SyncError(this.code);

  /// Machine-readable reason, mapped to a message by the UI.
  final String code;
}

/// A record changed on two devices and the rule (last writer wins, signed
/// contracts immutable) needs the user's attention.
class SyncConflict extends SyncStatus {
  /// At least one conflict is waiting.
  const SyncConflict();
}

/// Moves outbox changes to the encrypted service and remote changes back
/// (design: docs/adr/0010-end-to-end-encrypted-sync.md).
abstract interface class SyncService {
  /// Sends pending outbox entries. Never throws for network problems: it
  /// reports them through [status].
  Future<void> push();

  /// Fetches and applies remote changes.
  Future<void> pull();

  /// The current status, then every change.
  Stream<SyncStatus> get status;
}

/// The desktop default: does nothing, always [SyncDisabled].
class NoopSyncService implements SyncService {
  /// Creates the no-op service.
  const NoopSyncService();

  @override
  Future<void> push() async {}

  @override
  Future<void> pull() async {}

  @override
  Stream<SyncStatus> get status => Stream.value(const SyncDisabled());
}
