import 'package:meta/meta.dart';

/// Who the user is to the (future) sync service. The desktop app never
/// gates anything on this: every feature works in every state.
sealed class AccountState {
  const AccountState();
}

/// No account: the default, and all the desktop app needs.
class LocalOnly extends AccountState {
  /// The only state today.
  const LocalOnly();
}

/// Signed in to the sync service without an active subscription.
@immutable
class SignedIn extends AccountState {
  /// Signed in as [email].
  const SignedIn(this.email);

  /// The account's sign-in address; never sent anywhere by the app today.
  final String email;
}

/// An active sync subscription.
@immutable
class Subscribed extends AccountState {
  /// [plan] is the service's plan id; [expiresAt] is when it lapses
  /// unless renewed.
  const Subscribed({required this.plan, required this.expiresAt});

  /// Opaque plan id from the service (e.g. `sync-monthly`).
  final String plan;

  /// When the subscription ends unless renewed (UTC).
  final DateTime expiresAt;
}

/// The subscription lapsed: sync stops, local use is unaffected.
class Expired extends AccountState {
  /// A lapsed subscription.
  const Expired();
}

/// Source of [AccountState]. Bootstrap wires [LocalAccountService]; a
/// future implementation talks to the sync service.
abstract interface class AccountService {
  /// The state right now.
  AccountState get current;

  /// [current], then every change.
  Stream<AccountState> watch();
}

/// The desktop default: always [LocalOnly], no network.
class LocalAccountService implements AccountService {
  /// Creates the local-only service.
  const LocalAccountService();

  @override
  AccountState get current => const LocalOnly();

  @override
  Stream<AccountState> watch() => Stream.value(current);
}
