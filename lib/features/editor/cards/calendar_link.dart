part of '../editor_cards.dart';

/// "مؤجَّلة من … إلى … — السبب" with the whole history, and the
/// "في التقويم" link that opens the calendar on this invoice's day.
class _CalendarStrip extends ConsumerWidget {
  const _CalendarStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final id = _watchInv(ref, (i) => i.id);
    final status = _watchInv(ref, (i) => i.status);
    final due = _watchInv(ref, (i) => i.dueDate);
    final paid = _watchInv(ref, (i) => i.paidDate);
    final history = [
      for (final p
          in ref.watch(postponementsProvider).value ?? const <Postponement>[])
        if (p.entityId == id && p.entityType == PostponedEntity.invoice) p,
    ];
    final muted = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: context.colors.muted);
    final latest = history.isEmpty ? null : history.last;
    final day = status == InvoiceStatus.paid && paid != null
        ? paid
        : latest?.toDate ?? due;
    final eventId = status == InvoiceStatus.paid
        ? 'invoice-paid-$id'
        : 'invoice-due-$id';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final p in history)
          Padding(
            key: ValueKey('postponed-${p.id}'),
            padding: const EdgeInsets.only(top: Space.xs),
            child: Text(
              [
                l.postponedFromTo(
                  formatDocDate(p.fromDate, context.docLanguage),
                  formatDocDate(p.toDate, context.docLanguage),
                ),
                if (p.reason.isNotEmpty) p.reason,
              ].join(' — '),
              style: p == latest ? null : muted,
            ),
          ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            key: const Key('in-calendar'),
            onPressed: () {
              ref.read(calendarProvider.notifier).focusEvent(day, eventId);
              ref.read(calendarModeProvider.notifier).set(true);
            },
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
            label: Text(l.inCalendar),
          ),
        ),
      ],
    );
  }
}
