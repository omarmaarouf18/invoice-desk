import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

/// [archived] shows only archived clients (and all their documents); every
/// other filter hides them. [contractsInForce] shows signed/active
/// contracts only; the invoice filters show invoices only.
enum SidebarFilter {
  all,
  unpaid,
  overdue,
  paid,
  drafts,
  contractsInForce,
  archived,
}

/// A contract row; amendments sit under their original ([depth] 1).
class ContractEntry {
  const ContractEntry(this.contract, {this.depth = 0});
  final Contract contract;
  final int depth;
}

class ClientGroup {
  const ClientGroup({
    required this.client,
    required this.invoices,
    required this.invoiceCount,
    required this.unpaidCount,
    this.contracts = const [],
    this.contractCount = 0,
  });

  final Client client;

  /// Contracts shown under the client (filtered), originals newest first,
  /// each followed by its amendments.
  final List<ContractEntry> contracts;
  final int contractCount;

  /// Invoices shown under the client (filtered), newest first.
  final List<Invoice> invoices;

  /// Counts over all of the client's invoices, regardless of filter.
  final int invoiceCount;
  final int unpaidCount;
}

class SidebarSummary {
  const SidebarSummary({required this.unpaid, required this.overdueCount});
  final MoneyBag unpaid;
  final int overdueCount;
}

class SidebarData {
  const SidebarData({required this.groups, required this.summary});
  final List<ClientGroup> groups;
  final SidebarSummary summary;
}

bool matchesFilter(Invoice i, SidebarFilter f, CalendarDate today) =>
    switch (f) {
      SidebarFilter.all => true,
      SidebarFilter.unpaid => i.isUnpaid,
      SidebarFilter.overdue => i.isOverdue(today),
      SidebarFilter.paid => i.status == InvoiceStatus.paid,
      SidebarFilter.drafts => i.status == InvoiceStatus.draft,
      SidebarFilter.archived => true,
      SidebarFilter.contractsInForce => false,
    };

bool _contractMatches(Contract c, SidebarFilter f, Contract? parent) =>
    switch (f) {
      SidebarFilter.all || SidebarFilter.archived => true,
      SidebarFilter.contractsInForce =>
        c.status.isInForce || (parent?.status.isInForce ?? false),
      _ => false,
    };

/// Arabic-aware A→Z ordering key.
int compareNames(String a, String b) =>
    foldForSearch(a).compareTo(foldForSearch(b));

SidebarData buildSidebar({
  required List<Client> clients,
  required List<Invoice> invoices,
  required String query,
  required SidebarFilter filter,
  required CalendarDate today,
  List<Contract> contracts = const [],
  String? keepClientId,
}) {
  final q = foldForSearch(query.trim());
  final archivedIds = {
    for (final c in clients)
      if (c.archived) c.id,
  };
  final byClient = <String, List<Invoice>>{};
  final unpaid = MoneyBag();
  var overdue = 0;
  for (final i in invoices) {
    (byClient[i.clientId] ??= []).add(i);
    // The summary covers what the list can show outside the archive.
    if (archivedIds.contains(i.clientId)) continue;
    if (i.isUnpaid) unpaid.addBag(i.totals.total);
    if (i.isOverdue(today)) overdue++;
  }
  final browsing =
      filter == SidebarFilter.all || filter == SidebarFilter.archived;
  final contractsByClient = <String, List<Contract>>{};
  for (final c in contracts) {
    (contractsByClient[c.clientId] ??= []).add(c);
  }

  bool hit(String s) => q.isNotEmpty && foldForSearch(s).contains(q);

  final groups = <ClientGroup>[];
  final sorted = [...clients]..sort((a, b) => compareNames(a.name, b.name));
  for (final c in sorted) {
    final all = byClient[c.id] ?? const <Invoice>[];
    final inArchive = filter == SidebarFilter.archived;
    // Archived clients only appear under the archive filter (or while one
    // of their invoices is open).
    if (inArchive ? !c.archived : c.archived && c.id != keepClientId) {
      continue;
    }
    final clientHit =
        q.isEmpty || hit(c.name) || hit(c.contact) || hit(c.phone);
    final shown =
        [
          for (final i in all)
            if (matchesFilter(i, filter, today) &&
                (clientHit || hit(i.number) || hit(i.contractRef)))
              i,
        ]..sort((a, b) {
          final d = b.issueDate.compareTo(a.issueDate);
          return d != 0 ? d : b.seq.compareTo(a.seq);
        });
    final allContracts = contractsByClient[c.id] ?? const <Contract>[];
    final byId = {for (final k in allContracts) k.id: k};
    bool contractHit(Contract k) =>
        clientHit || hit(k.number) || hit(k.title) || hit(k.projectName);
    final originals = allContracts.where((k) => k.parentId == null).toList()
      ..sort((a, b) {
        final d = b.issueDate.compareTo(a.issueDate);
        return d != 0 ? d : b.number.compareTo(a.number);
      });
    final shownContracts = <ContractEntry>[];
    for (final o in originals) {
      final amendments = allContracts.where((k) => k.parentId == o.id).toList()
        ..sort((a, b) => a.amendmentNo.compareTo(b.amendmentNo));
      // A hit on an amendment keeps its original visible (and vice versa).
      if (![o, ...amendments].any(contractHit)) continue;
      if (_contractMatches(o, filter, null)) {
        shownContracts.add(ContractEntry(o));
      }
      for (final a in amendments) {
        if (_contractMatches(a, filter, o)) {
          shownContracts.add(ContractEntry(a, depth: 1));
        }
      }
    }
    // Amendments whose original is gone (deleted separately) still show.
    for (final a in allContracts) {
      if (a.parentId != null &&
          !byId.containsKey(a.parentId) &&
          contractHit(a) &&
          _contractMatches(a, filter, null)) {
        shownContracts.add(ContractEntry(a));
      }
    }
    final include =
        browsing && q.isEmpty ||
        shown.isNotEmpty ||
        shownContracts.isNotEmpty ||
        (browsing && clientHit);
    if (!include) continue;
    groups.add(
      ClientGroup(
        client: c,
        invoices: shown,
        invoiceCount: all.length,
        unpaidCount: all.where((i) => i.isUnpaid).length,
        contracts: shownContracts,
        contractCount: allContracts.length,
      ),
    );
  }
  return SidebarData(
    groups: groups,
    summary: SidebarSummary(unpaid: unpaid, overdueCount: overdue),
  );
}
