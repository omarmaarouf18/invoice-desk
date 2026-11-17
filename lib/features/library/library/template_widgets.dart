part of '../library_page.dart';

/// Title, subtitle and "رجوع" to settings.
class _LibraryHeader extends ConsumerWidget {
  const _LibraryHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.libraryTitle, style: theme.textTheme.headlineSmall),
              Text(l.librarySubtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => openSettings(ref, SettingsSection.contracts),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text(l.back),
        ),
      ],
    );
  }
}

/// The templates, and "قالب جديد".
class _TemplateList extends StatelessWidget {
  const _TemplateList({
    required this.templates,
    required this.selectedId,
    required this.onSelect,
    required this.onAdd,
  });
  final List<ClauseTemplate> templates;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SizedBox(
      width: 260,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (final t in templates)
                    ListTile(
                      selected: t.id == selectedId,
                      leading: Icon(
                        t.kind == TemplateKind.quote
                            ? Icons.request_quote_outlined
                            : Icons.gavel_outlined,
                        size: 18,
                      ),
                      title: Text(t.name),
                      subtitle: Text(
                        l.clauseCount(t.clauses.length),
                      ),
                      onTap: () => onSelect(t.id),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(Space.s),
              child: OutlinedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l.newTemplate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Name, kind, preamble, closing line and variable defaults.
class _TemplateFields extends StatelessWidget {
  const _TemplateFields({
    required this.t,
    required this.dirty,
    required this.update,
    required this.onDelete,
  });
  final ClauseTemplate t;
  final bool dirty;
  final void Function(ClauseTemplate Function(ClauseTemplate t) f) update;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return PanelCard(
      title: t.name,
      icon: Icons.description_outlined,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            dirty ? l.saving : l.saved,
            style: theme.textTheme.bodySmall,
          ),
          IconButton(
            tooltip: l.deleteTemplate,
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _NameAndKind(
            t: t,
            update: update,
          ),
          _gap,
          SyncedTextField(
            label: l.preamble,
            value: t.preamble,
            minLines: 3,
            maxLines: 10,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => update((t) => t.copyWith(preamble: v)),
          ),
          _gap,
          SyncedTextField(
            label: l.closingLine,
            value: t.closing,
            minLines: 1,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => update((t) => t.copyWith(closing: v)),
          ),
          _gap,
          SyncedTextField(
            label: l.templateDefaults,
            hint: l.templateDefaultsHint,
            value: _TemplateEditorState._defaultsText(t.varDefaults),
            textDirection: TextDirection.ltr,
            minLines: 3,
            maxLines: 12,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => update(
              (t) => t.copyWith(
                varDefaults: _TemplateEditorState._parseDefaults(v),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One library clause: drag, title, optional/default flags, body.
class _LibraryClauseRow extends StatelessWidget {
  const _LibraryClauseRow({
    required this.i,
    required this.c,
    required this.edit,
    required this.onDelete,
  });
  final int i;
  final LibraryClause c;
  final void Function(String id, LibraryClause Function(LibraryClause c) f)
  edit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      key: ValueKey(c.id),
      margin: const EdgeInsetsDirectional.only(bottom: Space.s),
      padding: const EdgeInsets.all(Space.s),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(Space.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: i,
                child: Icon(
                  Icons.drag_indicator,
                  size: 18,
                  color: context.colors.muted,
                ),
              ),
              const SizedBox(width: Space.s),
              Expanded(
                child: SyncedTextField(
                  value: c.title,
                  hint: l.clauseTitle,
                  dense: true,
                  onChanged: (v) => edit(
                    c.id,
                    (x) => x.copyWith(title: v),
                  ),
                ),
              ),
              const SizedBox(width: Space.s),
              FilterChip(
                label: Text(l.optionalTag),
                selected: c.optional,
                onSelected: (v) => edit(
                  c.id,
                  (x) => x.copyWith(
                    optional: v,
                    enabledByDefault: !v || x.enabledByDefault,
                  ),
                ),
              ),
              const SizedBox(width: Space.xs),
              FilterChip(
                label: Text(l.enabledByDefault),
                selected: c.enabledByDefault,
                onSelected: (v) => edit(
                  c.id,
                  (x) => x.copyWith(enabledByDefault: v),
                ),
              ),
              IconButton(
                tooltip: l.deleteClause,
                onPressed: onDelete,
                icon: const Icon(Icons.close, size: 16),
              ),
            ],
          ),
          const SizedBox(height: Space.xs),
          SyncedTextField(
            value: c.body,
            hint: l.clauseBody,
            minLines: 2,
            maxLines: 12,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => edit(c.id, (x) => x.copyWith(body: v)),
          ),
        ],
      ),
    );
  }
}

const _gap = SizedBox(height: Space.m - 4);

class _NameAndKind extends StatelessWidget {
  const _NameAndKind({required this.t, required this.update});
  final ClauseTemplate t;
  final void Function(ClauseTemplate Function(ClauseTemplate t) f) update;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      children: [
        Expanded(
          child: SyncedTextField(
            label: l.templateName,
            value: t.name,
            onChanged: (v) => update(
              (t) => t.copyWith(name: v.trim().isEmpty ? t.name : v),
            ),
          ),
        ),
        const SizedBox(width: Space.m - 4),
        SegmentedButton<TemplateKind>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: TemplateKind.contract,
              label: Text(l.kindContract),
            ),
            ButtonSegment(
              value: TemplateKind.quote,
              label: Text(l.kindQuote),
            ),
          ],
          selected: {t.kind},
          onSelectionChanged: (s) => update((t) => t.copyWith(kind: s.first)),
        ),
      ],
    );
  }
}
