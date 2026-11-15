import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

enum SidebarFilter { all, unpaid, overdue, paid, drafts }

class ClientGroup {
  const ClientGroup({
    required this.client,
    required this.invoices,
    required this.invoiceCount,
    required this.unpaidCount,
  });

  final Client client;

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
  String? keepClientId,
}) {
  final q = foldForSearch(query.trim());
  final byClient = <String, List<Invoice>>{};
  final unpaid = MoneyBag();
  var overdue = 0;
  for (final i in invoices) {
    (byClient[i.clientId] ??= []).add(i);
    if (i.isUnpaid) unpaid.addBag(i.totals.total);
    if (i.isOverdue(today)) overdue++;
  }

  bool hit(String s) => q.isNotEmpty && foldForSearch(s).contains(q);

  final groups = <ClientGroup>[];
  final sorted = [...clients]..sort((a, b) => compareNames(a.name, b.name));
  for (final c in sorted) {
    final all = byClient[c.id] ?? const <Invoice>[];
    if (c.archived && all.isEmpty && c.id != keepClientId) continue;
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
    final include =
        filter == SidebarFilter.all && q.isEmpty ||
        (shown.isNotEmpty || (filter == SidebarFilter.all && clientHit));
    if (!include) continue;
    groups.add(
      ClientGroup(
        client: c,
        invoices: shown,
        invoiceCount: all.length,
        unpaidCount: all.where((i) => i.isUnpaid).length,
      ),
    );
  }
  return SidebarData(
    groups: groups,
    summary: SidebarSummary(unpaid: unpaid, overdueCount: overdue),
  );
}
