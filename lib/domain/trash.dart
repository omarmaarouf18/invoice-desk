import 'package:meta/meta.dart';

/// How long soft-deleted rows stay in "المحذوفات" before the start-up purge
/// removes them for good.
const trashRetention = Duration(days: 30);

/// What kind of row a trash entry is.
enum TrashKind {
  /// A client (restoring it restores its batch).
  client,

  /// An invoice with its sections and items.
  invoice,

  /// A contract with its parts and the amendments deleted with it.
  contract,
}

/// One soft-deleted row, as "المحذوفات" lists it.
@immutable
class TrashEntry {
  /// Creates an entry; [deletedAt] is UTC epoch milliseconds.
  const TrashEntry({
    required this.kind,
    required this.id,
    required this.label,
    required this.deletedAt,
    this.clientId,
    this.clientName = '',
    this.clientDeleted = false,
  });

  /// Which table the row is in.
  final TrashKind kind;

  /// The row's id.
  final String id;

  /// Client name, or the invoice/contract number; also what the user types
  /// to confirm a permanent delete.
  final String label;

  /// UTC epoch milliseconds; also the batch stamp: rows deleted together
  /// (a client "with all its documents") share it.
  final int deletedAt;

  /// Owner of an invoice or contract; null for clients.
  final String? clientId;

  /// Owner's display name, for "لـ …"; empty for clients.
  final String clientName;

  /// The owner is in the trash too: restoring this row needs the client
  /// back first (the database refuses a live document under a deleted
  /// client).
  final bool clientDeleted;
}

/// Whole days left before [deletedAt] (UTC ms) is purged, counted up and
/// never negative: deleted a minute ago → 30, due today → 0.
int daysUntilPurge(
  int deletedAt,
  DateTime now, {
  Duration retention = trashRetention,
}) {
  final left =
      deletedAt + retention.inMilliseconds - now.toUtc().millisecondsSinceEpoch;
  if (left <= 0) return 0;
  const day = Duration.millisecondsPerDay;
  return (left + day - 1) ~/ day;
}

/// Result of restoring a trash entry.
sealed class RestoreResult {
  const RestoreResult();
}

/// Restored; [count] rows came back (a client's batch counts every row).
class Restored extends RestoreResult {
  /// [count] rows came back.
  const Restored(this.count);

  /// Including the client when it was restored too.
  final int count;
}

/// The document's client is deleted; ask, then restore with the client.
class NeedsClient extends RestoreResult {
  /// [clientName] is the deleted owner.
  const NeedsClient(this.clientName);

  /// Shown in the confirmation.
  final String clientName;
}

/// Nothing to restore (already restored or purged).
class NotInTrash extends RestoreResult {
  /// Nothing happened.
  const NotInTrash();
}
