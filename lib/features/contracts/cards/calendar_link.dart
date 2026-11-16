part of '../contract_cards.dart';

/// "في التقويم": the contract's next dated event (an open milestone from
/// today on, else its end, start or issue date), selected in the calendar.
class _ContractCalendarLink extends ConsumerWidget {
  const _ContractCalendarLink();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(contractProvider.select((s) => s.contract));
    if (c == null) return const SizedBox.shrink();
    final today = ref.watch(todayProvider);
    final open = [
      for (final m in c.milestones)
        if (m.dueDate != null &&
            m.invoiceId == null &&
            !m.dueDate!.isBefore(today))
          m,
    ]..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
    final (CalendarDate day, String id) = open.isNotEmpty
        ? (open.first.dueDate!, 'milestone-${open.first.id}')
        : c.endDate != null
        ? (c.endDate!, 'contract-end-${c.id}')
        : c.startDate != null
        ? (c.startDate!, 'contract-start-${c.id}')
        : (c.issueDate, '');
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        key: const Key('contract-in-calendar'),
        onPressed: () {
          ref.read(calendarProvider.notifier).focusEvent(day, id);
          ref.read(calendarModeProvider.notifier).set(true);
        },
        icon: const Icon(Icons.calendar_month_outlined, size: 18),
        label: Text(context.l10n.inCalendar),
      ),
    );
  }
}
