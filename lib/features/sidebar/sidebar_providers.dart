import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/sidebar/sidebar_model.dart';

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void set(String q) => state = q;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

class SidebarFilterNotifier extends Notifier<SidebarFilter> {
  @override
  SidebarFilter build() => SidebarFilter.all;
  void set(SidebarFilter f) => state = f;
}

final sidebarFilterProvider =
    NotifierProvider<SidebarFilterNotifier, SidebarFilter>(
      SidebarFilterNotifier.new,
    );

/// Client ids the user expanded or collapsed explicitly.
class ExpandedClientsNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => const {};
  void set(String clientId, {required bool expanded}) =>
      state = {...state, clientId: expanded};
}

final expandedClientsProvider =
    NotifierProvider<ExpandedClientsNotifier, Map<String, bool>>(
      ExpandedClientsNotifier.new,
    );

final searchFocusProvider = Provider<FocusNode>((ref) {
  final node = FocusNode(debugLabel: 'search');
  ref.onDispose(node.dispose);
  return node;
});

/// Client id of the open document (kept expanded and visible).
final activeClientIdProvider = Provider<String?>((ref) {
  final ws = ref.watch(workspaceProvider);
  final id = ws == Workspace.contract
      ? ref.watch(contractProvider.select((s) => s.contract?.clientId))
      : ref.watch(editorProvider.select((s) => s.invoice?.clientId));
  return id == null || id.isEmpty ? null : id;
});

final sidebarDataProvider = Provider<AsyncValue<SidebarData>>((ref) {
  final clients = ref.watch(clientsProvider);
  final invoices = ref.watch(invoicesProvider);
  final contracts = ref.watch(contractsProvider);
  final query = ref.watch(searchQueryProvider);
  final filter = ref.watch(sidebarFilterProvider);
  final today = ref.watch(todayProvider);
  final keep = ref.watch(activeClientIdProvider);
  if (clients.hasError) return AsyncError(clients.error!, clients.stackTrace!);
  if (invoices.hasError) {
    return AsyncError(invoices.error!, invoices.stackTrace!);
  }
  final c = clients.value;
  final i = invoices.value;
  if (c == null || i == null) return const AsyncLoading();
  return AsyncData(
    buildSidebar(
      clients: c,
      invoices: i,
      query: query,
      filter: filter,
      today: today,
      contracts: contracts.value ?? const [],
      keepClientId: keep,
    ),
  );
});
