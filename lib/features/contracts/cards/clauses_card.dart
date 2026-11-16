part of '../contract_cards.dart';

class ClausesCard extends ConsumerWidget {
  const ClausesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ids = _watch(ref, (c) => [for (final x in c.clauses) x.id]);
    final locked = _locked(ref);
    final a = ContractActions(ref, context);
    return PanelCard(
      title: l.cardClauses,
      icon: directionalIcon(
        context,
        Icons.format_list_numbered,
        Icons.format_list_numbered_rtl,
      ),
      trailing: locked
          ? null
          : MenuAnchor(
              builder: (context, controller, _) => OutlinedButton.icon(
                key: const ValueKey('add-clause'),
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.addClause),
              ),
              menuChildren: [
                MenuItemButton(
                  leadingIcon: const Icon(Icons.short_text, size: 18),
                  onPressed: () => _ctl(ref).addClause(),
                  child: Text(l.addBlankClause),
                ),
                MenuItemButton(
                  leadingIcon: const Icon(
                    Icons.library_books_outlined,
                    size: 18,
                  ),
                  onPressed: () => unawaited(a.addFromLibrary()),
                  child: Text(l.addFromLibrary),
                ),
              ],
            ),
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        buildDefaultDragHandles: false,
        onReorderItem: (from, to) {
          if (!locked) _ctl(ref).reorderClause(from, to);
        },
        children: [
          for (final (i, id) in ids.indexed)
            _ClauseTile(key: ValueKey(id), id: id, index: i),
        ],
      ),
    );
  }
}

class _ClauseTile extends ConsumerStatefulWidget {
  const _ClauseTile({required this.id, required this.index, super.key});
  final String id;
  final int index;

  @override
  ConsumerState<_ClauseTile> createState() => _ClauseTileState();
}

class _ClauseTileState extends ConsumerState<_ClauseTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final x = c.clauses.where((y) => y.id == widget.id).firstOrNull;
    if (x == null) return const SizedBox.shrink();
    final enabledBefore = c.clauses
        .take(widget.index)
        .where((y) => y.enabled)
        .length;
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: Space.s),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(Space.radiusSmall),
        color: x.enabled ? null : context.colors.subtle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ClauseHeader(
            clause: x,
            index: widget.index,
            number: enabledBefore + 1,
            locked: c.isLocked,
            open: _open,
            onToggle: () => setState(() => _open = !_open),
          ),
          if (!_open && x.body.trim().isNotEmpty) _ClausePreview(clause: x),
          if (_open) _ClauseEditor(clause: x, locked: c.isLocked),
        ],
      ),
    );
  }
}

/// Drag handle, "البند الأول", title, enabled switch, menu, chevron.
class _ClauseHeader extends ConsumerWidget {
  const _ClauseHeader({
    required this.clause,
    required this.index,
    required this.number,
    required this.locked,
    required this.open,
    required this.onToggle,
  });

  final ContractClause clause;
  final int index;

  /// Position among enabled clauses (what the PDF prints).
  final int number;
  final bool locked;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final x = clause;
    final muted = context.colors.muted;
    return InkWell(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
        child: Row(
          children: [
            if (!locked)
              ReorderableDragStartListener(
                index: index,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.drag_indicator, size: 18, color: muted),
                ),
              )
            else
              const SizedBox(width: Space.s),
            SizedBox(
              width: 112,
              child: Text(
                x.enabled ? clauseHeading(number, context.docLanguage) : '—',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: x.enabled ? theme.colorScheme.primary : muted,
                ),
              ),
            ),
            Expanded(child: _ClauseTitle(clause: x)),
            Tooltip(
              message: l.clauseEnabled,
              child: Switch(
                value: x.enabled,
                onChanged: locked
                    ? null
                    : (v) => _ctl(
                        ref,
                      ).editClause(x.id, (y) => y.copyWith(enabled: v)),
              ),
            ),
            _ClauseMenu(clause: x, locked: locked),
            Icon(
              open ? Icons.expand_less : Icons.expand_more,
              size: 20,
              color: muted,
            ),
            const SizedBox(width: Space.xs),
          ],
        ),
      ),
    );
  }
}

class _ClauseTitle extends ConsumerWidget {
  const _ClauseTitle({required this.clause});
  final ContractClause clause;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final x = clause;
    return Row(
      children: [
        Flexible(
          child: VariableText(
            x.title.isEmpty ? context.l10n.clauseTitle : x.title,
            resolver: ref.watch(openResolverProvider),
            maxLines: 1,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: x.enabled ? null : context.colors.muted,
            ),
          ),
        ),
        if (x.optional) ...[
          const SizedBox(width: Space.s),
          const OptionalTag(),
        ],
      ],
    );
  }
}

/// Restore / save to library, duplicate, delete.
class _ClauseMenu extends ConsumerWidget {
  const _ClauseMenu({required this.clause, required this.locked});
  final ContractClause clause;
  final bool locked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final x = clause;
    final a = ContractActions(ref, context);
    final ctl = _ctl(ref);
    return MenuAnchor(
      builder: (context, controller, _) => IconButton(
        tooltip: l.more,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        icon: const Icon(Icons.more_vert, size: 18),
      ),
      menuChildren: [
        if (x.fromLibraryClauseId != null) ...[
          MenuItemButton(
            leadingIcon: const Icon(Icons.history, size: 18),
            onPressed: locked ? null : () => unawaited(a.restoreClause(x)),
            child: Text(l.restoreFromLibrary),
          ),
          MenuItemButton(
            leadingIcon: const Icon(Icons.upload_outlined, size: 18),
            onPressed: () => unawaited(a.saveClauseToLibrary(x)),
            child: Text(l.saveToLibrary),
          ),
        ],
        MenuItemButton(
          leadingIcon: const Icon(Icons.copy_outlined, size: 18),
          onPressed: locked ? null : () => ctl.duplicateClause(x.id),
          child: Text(l.duplicateClause),
        ),
        MenuItemButton(
          leadingIcon: Icon(
            Icons.delete_outline,
            size: 18,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: locked ? null : () => ctl.removeClause(x.id),
          child: Text(l.deleteClause),
        ),
      ],
    );
  }
}

/// Collapsed: the body on two lines, sub-item markers dropped.
class _ClausePreview extends ConsumerWidget {
  const _ClausePreview({required this.clause});
  final ContractClause clause;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(
      Space.l + 4,
      0,
      Space.m,
      Space.s + 2,
    ),
    child: VariableText(
      clause.body
          .split('\n')
          .map((l) => l.replaceFirst(RegExp(r'^\s*[-–•]\s+'), ''))
          .where((l) => l.trim().isNotEmpty)
          .join('  ·  '),
      resolver: ref.watch(openResolverProvider),
      maxLines: 2,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: clause.enabled ? null : context.colors.muted,
      ),
    ),
  );
}

/// Expanded: title and body fields with `{{` autocomplete; read-only text
/// when locked.
class _ClauseEditor extends ConsumerWidget {
  const _ClauseEditor({required this.clause, required this.locked});
  final ContractClause clause;
  final bool locked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final x = clause;
    final resolver = ref.watch(openResolverProvider);
    final ctl = _ctl(ref);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        Space.m,
        Space.xs,
        Space.m,
        Space.m,
      ),
      child: locked
          ? VariableText(x.body, resolver: resolver)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _VariableField(
                  key: ValueKey('title-${x.id}'),
                  label: l.clauseTitle,
                  value: x.title,
                  onChanged: (v) =>
                      ctl.editClause(x.id, (y) => y.copyWith(title: v)),
                ),
                _gap,
                _VariableField(
                  key: ValueKey('body-${x.id}'),
                  label: l.clauseBody,
                  helper: l.clauseBodyHelp,
                  value: x.body,
                  multiline: true,
                  onChanged: (v) =>
                      ctl.editClause(x.id, (y) => y.copyWith(body: v)),
                ),
                if (x.body.contains('{{')) ...[
                  _gap,
                  VariableText(
                    x.body,
                    resolver: resolver,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
    );
  }
}
