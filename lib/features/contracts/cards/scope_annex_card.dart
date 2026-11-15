part of '../contract_cards.dart';

class ScopeAnnexCard extends ConsumerWidget {
  const ScopeAnnexCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final rows = _watch(ref, (c) => c.scope);
    final outOfScope = _watch(ref, (c) => c.outOfScope);
    final locked = _locked(ref);
    final ctl = _ctl(ref);
    Widget head(String t, int flex) => Expanded(
      flex: flex,
      child: Text(t, style: theme.textTheme.labelMedium),
    );
    return PanelCard(
      title: l.cardScopeAnnex,
      icon: Icons.checklist_rtl,
      trailing: locked
          ? null
          : OutlinedButton.icon(
              key: const ValueKey('add-scope'),
              onPressed: ctl.addScope,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.addScopeRow),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: Space.xs,
              end: 40,
            ),
            child: Row(
              children: [
                head(l.scopePhase, 2),
                const SizedBox(width: Space.s),
                head(l.scopeItem, 3),
                const SizedBox(width: Space.s),
                head(l.scopeDescription, 5),
                const SizedBox(width: Space.s),
                head(l.scopeAcceptance, 4),
              ],
            ),
          ),
          for (final r in rows)
            _ScopeRow(key: ValueKey(r.id), row: r, locked: locked),
          _gap,
          SyncedTextField(
            label: l.outOfScope,
            hint: l.outOfScopeHint,
            value: outOfScope,
            readOnly: locked,
            minLines: 2,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => ctl.edit((c) => c.copyWith(outOfScope: v)),
          ),
        ],
      ),
    );
  }
}

class _ScopeRow extends ConsumerWidget {
  const _ScopeRow({required this.row, required this.locked, super.key});
  final ScopeItem row;
  final bool locked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ctl = _ctl(ref);
    Widget f(
      String v,
      int flex,
      ScopeItem Function(ScopeItem x, String v) set, {
      bool last = false,
    }) => Expanded(
      flex: flex,
      child: SyncedTextField(
        value: v,
        dense: true,
        readOnly: locked,
        maxLines: 3,
        minLines: 1,
        textInputAction: last ? TextInputAction.done : TextInputAction.next,
        // Same keyboard flow as invoice items: Enter in the last cell adds
        // a row after this one.
        onSubmitted: last && !locked
            ? (_) {
                ctl.addScope(afterId: row.id);
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => FocusScope.of(context).nextFocus(),
                );
              }
            : null,
        onChanged: (x) => ctl.editScope(row.id, (r) => set(r, x)),
      ),
    );
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          f(row.phase, 2, (r, v) => r.copyWith(phase: v)),
          const SizedBox(width: Space.s),
          f(row.item, 3, (r, v) => r.copyWith(item: v)),
          const SizedBox(width: Space.s),
          f(row.description, 5, (r, v) => r.copyWith(description: v)),
          const SizedBox(width: Space.s),
          f(row.acceptance, 4, (r, v) => r.copyWith(acceptance: v), last: true),
          SizedBox(
            width: 40,
            child: locked
                ? null
                : IconButton(
                    tooltip: l.deleteItem,
                    onPressed: () => ctl.removeScope(row.id),
                    icon: const Icon(Icons.close, size: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
