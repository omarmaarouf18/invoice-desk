import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

/// Every calendar event whose date falls in [range], derived from [data]
/// on the local civil day of [clock]. Pure: nothing is stored, the same
/// inputs always give the same list, sorted by day then type.
///
/// The overdue rollup is placed on today (when today is in [range]) and
/// counts every overdue invoice, wherever its due date is.
List<CalendarEvent> calendarEvents(
  DateRange range,
  CalendarData data,
  Clock clock,
) {
  final today = CalendarDate.fromDateTime(clock.now());
  final b = _Builder(data, today);
  final all = [
    ...b.invoiceEvents(range),
    ...b.renewals(range),
    ...b.contractEvents(),
    ...b.reminders(),
  ];
  final out = [
    for (final e in all)
      if (range.contains(e.date)) e,
  ];
  final rollup = b.rollup(all);
  if (rollup != null && range.contains(today)) out.add(rollup);
  return out..sort(compareEvents);
}

/// Day, then type order, then time, then title.
int compareEvents(CalendarEvent a, CalendarEvent b) {
  final d = a.date.compareTo(b.date);
  if (d != 0) return d;
  final t = a.type.index.compareTo(b.type.index);
  if (t != 0) return t;
  final tm = (a.time ?? '').compareTo(b.time ?? '');
  if (tm != 0) return tm;
  return a.title.compareTo(b.title);
}

/// Months in a warranty text such as "ضمان 3 أشهر" or "6 months";
/// null when there is none.
int? warrantyMonthsIn(String text) {
  final m = RegExp(
    r'(\d+)\s*(شهر|أشهر|اشهر|شهور|month)',
    caseSensitive: false,
  ).firstMatch(normalizeDigits(text));
  return m == null ? null : int.parse(m.group(1)!);
}

/// Service names compared for renewals: trimmed, case- and
/// letter-variant-insensitive.
String _serviceKey(String s) => foldForSearch(s.trim());

class _Builder {
  _Builder(this.data, this.today)
    : clients = {for (final c in data.clients) c.id: c.name},
      invoices = {for (final i in data.invoices) i.id: i},
      latest = latestPostponements(data.postponements);

  final CalendarData data;
  final CalendarDate today;
  final Map<String, String> clients;
  final Map<String, Invoice> invoices;
  final Map<String, Postponement> latest;

  String _client(String? id) => id == null ? '' : clients[id] ?? '';

  Iterable<CalendarEvent> invoiceEvents(DateRange range) sync* {
    for (final inv in data.invoices) {
      final total = inv.totals.total.nonZero;
      final base = (
        client: _client(inv.clientId),
        id: 'invoice-due-${inv.id}',
      );
      switch (inv.status) {
        case InvoiceStatus.sent:
          final p = latest[inv.id];
          final eff = p?.toDate ?? inv.dueDate;
          final late = eff.isBefore(today);
          yield CalendarEvent(
            id: base.id,
            type: late
                ? CalendarEventType.overdue
                : p != null
                ? CalendarEventType.postponed
                : CalendarEventType.due,
            date: eff,
            title: inv.number,
            originalDate: p == null ? null : inv.dueDate,
            reason: p?.reason ?? '',
            clientId: inv.clientId,
            clientName: base.client,
            amounts: total,
            invoiceId: inv.id,
            daysOverdue: late ? eff.daysUntil(today) : 0,
            isLate: late,
          );
          yield* _warranty(inv);
        case InvoiceStatus.paid:
          final paid = inv.paidDate;
          if (paid != null) {
            yield CalendarEvent(
              id: 'invoice-paid-${inv.id}',
              type: CalendarEventType.paid,
              date: paid,
              title: inv.number,
              clientId: inv.clientId,
              clientName: base.client,
              amounts: total,
              invoiceId: inv.id,
            );
          }
          yield* _warranty(inv);
        case InvoiceStatus.draft || InvoiceStatus.voided:
          break;
      }
    }
  }

  Iterable<CalendarEvent> _warranty(Invoice inv) sync* {
    if (!inv.scope.enabled) return;
    final months = warrantyMonthsIn(inv.scope.warranty);
    if (months == null || months <= 0) return;
    yield CalendarEvent(
      id: 'warranty-invoice-${inv.id}',
      type: CalendarEventType.warrantyEnd,
      date: (inv.paidDate ?? inv.issueDate).addMonths(months),
      title: inv.scope.title.isEmpty ? inv.number : inv.scope.title,
      clientId: inv.clientId,
      clientName: _client(inv.clientId),
      invoiceId: inv.id,
    );
  }

  /// Recurring items of paid invoices renew every month / year from the
  /// issue date until a later invoice of the same client bills the same
  /// service as a recurring item (the renewal invoice).
  Iterable<CalendarEvent> renewals(DateRange range) sync* {
    final renewedLater = _renewedLater();
    for (final inv in data.invoices) {
      if (inv.status != InvoiceStatus.paid) continue;
      final renewed = renewedLater[inv.id] ?? const <String>{};
      // date → (services, per-currency amounts)
      final byDate = <CalendarDate, (List<String>, MoneyBag)>{};
      for (final s in inv.sections) {
        for (final it in s.items) {
          if (!it.cycle.isRecurring) continue;
          if (renewed.contains(_serviceKey(it.service))) continue;
          final step = it.cycle == BillingCycle.monthly ? 1 : 12;
          for (var n = 1; ; n++) {
            final d = inv.issueDate.addMonths(n * step);
            if (range.end.isBefore(d)) break;
            if (d.isBefore(range.start)) continue;
            final e = byDate.putIfAbsent(d, () => (<String>[], MoneyBag()));
            if (!e.$1.contains(it.service)) e.$1.add(it.service);
            e.$2.add(Money(it.lineMinor, s.currency));
          }
        }
      }
      for (final MapEntry(key: d, value: (names, bag)) in byDate.entries) {
        yield CalendarEvent(
          id: 'renewal-${inv.id}-${d.toIso()}',
          type: CalendarEventType.renewal,
          date: d,
          title: names.join('، '),
          clientId: inv.clientId,
          clientName: _client(inv.clientId),
          amounts: bag.nonZero,
          invoiceId: inv.id,
        );
      }
    }
  }

  /// Per invoice: the recurring services billed by later (non-void)
  /// invoices of the same client. Linear per client: walk the client's
  /// invoices from the latest issue date back, collecting services.
  Map<String, Set<String>> _renewedLater() {
    final byClient = groupBy(
      data.invoices.where(
        (i) => i.status != InvoiceStatus.voided && i.clientId.isNotEmpty,
      ),
      (i) => i.clientId,
    );
    final out = <String, Set<String>>{};
    for (final list in byClient.values) {
      final byDate = groupBy(list, (i) => i.issueDate);
      final dates = byDate.keys.toList()..sort((a, b) => b.compareTo(a));
      var later = <String>{};
      for (final d in dates) {
        final group = byDate[d]!;
        for (final i in group) {
          out[i.id] = later;
        }
        later = {
          ...later,
          for (final i in group)
            for (final s in i.sections)
              for (final it in s.items)
                if (it.cycle.isRecurring) _serviceKey(it.service),
        };
      }
    }
    return out;
  }

  Iterable<CalendarEvent> contractEvents() sync* {
    for (final c in data.contracts) {
      if (c.isQuote ||
          c.status == ContractStatus.draft ||
          c.status == ContractStatus.cancelled) {
        continue;
      }
      final client = _client(c.clientId);
      final title = c.title.isEmpty ? c.number : c.title;
      CalendarEvent dated(String key, CalendarEventType t, CalendarDate d) =>
          CalendarEvent(
            id: '$key-${c.id}',
            type: t,
            date: d,
            title: title,
            clientId: c.clientId,
            clientName: client,
            contractId: c.id,
          );
      if (c.startDate case final d?) {
        yield dated('contract-start', CalendarEventType.contractStart, d);
      }
      if (c.endDate case final d?) {
        yield dated('contract-end', CalendarEventType.contractEnd, d);
        final months = int.tryParse(
          normalizeDigits(c.vars['warrantyMonths'] ?? ''),
        );
        if (months != null && months > 0) {
          yield dated(
            'warranty-contract',
            CalendarEventType.warrantyEnd,
            d.addMonths(months),
          );
        }
      }
      if (c.status == ContractStatus.signed ||
          c.status == ContractStatus.active) {
        yield* _milestones(c, client);
      }
    }
  }

  /// Dated milestones that no sent or paid invoice covers yet (once it is
  /// invoiced and sent, the invoice's own event takes over).
  Iterable<CalendarEvent> _milestones(Contract c, String client) sync* {
    final amounts = milestoneAmounts(c.totalMinor, c.milestones);
    for (final (i, m) in c.milestones.indexed) {
      final due = m.dueDate;
      if (due == null) continue;
      final inv = m.invoiceId == null ? null : invoices[m.invoiceId];
      if (inv != null &&
          (inv.status == InvoiceStatus.sent ||
              inv.status == InvoiceStatus.paid)) {
        continue;
      }
      final p = latest[m.id];
      final eff = p?.toDate ?? due;
      final late = eff.isBefore(today);
      yield CalendarEvent(
        id: 'milestone-${m.id}',
        type: p != null && !late
            ? CalendarEventType.postponed
            : CalendarEventType.milestone,
        date: eff,
        title: m.label.isEmpty ? c.number : m.label,
        originalDate: p == null ? null : due,
        reason: p?.reason ?? '',
        clientId: c.clientId,
        clientName: client,
        amounts: [
          if (amounts[i] > 0) Money(amounts[i], c.currency),
        ],
        contractId: c.id,
        milestoneId: m.id,
        invoiceId: inv?.id,
        daysOverdue: late ? eff.daysUntil(today) : 0,
        isLate: late,
      );
    }
  }

  Iterable<CalendarEvent> reminders() sync* {
    for (final r in data.reminders) {
      yield CalendarEvent(
        id: 'reminder-${r.id}',
        type: CalendarEventType.reminder,
        date: r.date,
        time: r.time,
        title: r.text,
        clientId: r.clientId,
        clientName: _client(r.clientId),
        reminderId: r.id,
        invoiceId: r.linkType == ReminderLink.invoice ? r.linkId : null,
        contractId: r.linkType == ReminderLink.contract ? r.linkId : null,
        done: r.isDone,
      );
    }
  }

  CalendarEvent? rollup(List<CalendarEvent> all) {
    final overdue = all.where((e) => e.type == CalendarEventType.overdue);
    if (overdue.isEmpty) return null;
    final bag = MoneyBag();
    for (final e in overdue) {
      e.amounts.forEach(bag.add);
    }
    return CalendarEvent(
      id: 'overdue-rollup-${today.toIso()}',
      type: CalendarEventType.overdueRollup,
      date: today,
      amounts: bag.nonZero,
      count: overdue.length,
      isLate: true,
    );
  }
}
