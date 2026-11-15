part of '../contract_controller.dart';

/// Resolver for the open contract, rebuilt when it, the client or the
/// settings change.
final openResolverProvider = Provider<VariableResolver?>((ref) {
  final c = ref.watch(contractProvider.select((s) => s.contract));
  if (c == null) return null;
  final clients = ref.watch(clientsProvider).value ?? const <Client>[];
  final settings = ref.watch(settingsProvider).value ?? const Settings();
  return VariableResolver(
    contract: c,
    client: clients.where((x) => x.id == c.clientId).firstOrNull,
    settings: settings,
  );
});

/// Missing variables of the open contract, in document order.
final openMissingProvider = Provider<List<String>>(
  (ref) => ref.watch(openResolverProvider)?.missing() ?? const [],
);

/// Clock-free helper for tests and the history list.
DateTime eventTime(ContractEvent e) =>
    DateTime.fromMillisecondsSinceEpoch(e.at, isUtc: true).toLocal();

/// A milestone's money, for the UI.
Money milestoneMoney(Contract c, int index) =>
    Money(milestoneAmounts(c.totalMinor, c.milestones)[index], c.currency);
