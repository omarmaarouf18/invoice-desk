part of '../contract_cards.dart';

class LockBanner extends ConsumerWidget {
  const LockBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final status = _watch(ref, (c) => c.status);
    final unlocked = _watch(ref, (c) => c.unlocked);
    final history = _watch(ref, (c) => c.history);
    if (!status.locks) return const SizedBox.shrink();
    final a = ContractActions(ref, context);
    final lastUnlock = history.lastWhere(
      (e) => e.event == 'unlock',
      orElse: () => const ContractEvent(at: 0, event: ''),
    );
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: Space.m),
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.m,
        Space.s + 4,
        Space.s,
        Space.s + 4,
      ),
      decoration: BoxDecoration(
        color: unlocked
            ? missingColors(context).bg
            : scheme.primaryContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(Space.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            unlocked ? Icons.lock_open_outlined : Icons.lock_outline,
            size: 20,
            color: unlocked
                ? missingColors(context).fg
                : scheme.onPrimaryContainer,
          ),
          const SizedBox(width: Space.m - 4),
          Expanded(
            child: Text(
              unlocked
                  ? l.unlockedBanner(
                      formatArabicDate(
                        CalendarDate.fromDateTime(eventTime(lastUnlock)),
                      ),
                    )
                  : l.lockedBanner,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: Space.s),
          FilledButton.tonalIcon(
            onPressed: () => unawaited(a.amendment()),
            icon: const Icon(Icons.note_add_outlined, size: 18),
            label: Text(l.createAmendment),
          ),
          const SizedBox(width: Space.s),
          if (unlocked)
            TextButton(onPressed: _ctl(ref).relock, child: Text(l.relock))
          else
            TextButton(
              key: const ValueKey('unlock-contract'),
              onPressed: () => unawaited(a.unlock()),
              child: Text(l.unlock),
            ),
        ],
      ),
    );
  }
}
