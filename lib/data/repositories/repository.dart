import 'package:clock/clock.dart';

/// Shared by repositories: every DAO call runs under the injected [Clock],
/// so timestamps written by the data layer (createdAt, updatedAt,
/// deletedAt, purge cut-offs) follow the same clock as the UI and tests.
mixin ClockedRepository {
  /// The clock writes are stamped with; tests pass a fixed one.
  Clock get clock;

  /// Runs [body] with [clock] as the zone's clock.
  Future<T> at<T>(Future<T> Function() body) => withClock(clock, body);
}
