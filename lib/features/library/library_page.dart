import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/daos/library_dao.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart' show newId;
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// Settings → مكتبة البنود: templates on the start side, the selected
/// template's preamble, defaults and clauses beside it. Autosaves.
class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final templates =
        ref.watch(libraryProvider).value ?? const <ClauseTemplate>[];
    final selected =
        templates.where((t) => t.id == _selected).firstOrNull ??
        templates.firstOrNull;

    Future<void> addTemplate() async {
      final t = ClauseTemplate(
        id: newId(),
        name: l.newTemplate,
        clauses: [LibraryClause(id: newId())],
      );
      await ref.read(databaseProvider).libraryDao.saveTemplate(t);
      setState(() => _selected = t.id);
    }

    return Padding(
      padding: const EdgeInsets.all(Space.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
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
                onPressed: () => ref
                    .read(workspaceProvider.notifier)
                    .show(Workspace.settings),
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: Text(l.back),
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          Text(
            l.draftNotLegalAdvice,
            style: theme.textTheme.bodySmall?.copyWith(
              color: missingColors(context).fg,
            ),
          ),
          const SizedBox(height: Space.m),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
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
                                  selected: t.id == selected?.id,
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
                                  onTap: () => setState(() => _selected = t.id),
                                ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.all(Space.s),
                          child: OutlinedButton.icon(
                            onPressed: () => unawaited(addTemplate()),
                            icon: const Icon(Icons.add, size: 18),
                            label: Text(l.newTemplate),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: Space.m),
                Expanded(
                  child: selected == null
                      ? Center(child: Text(l.pickTemplateToEdit))
                      : _TemplateEditor(
                          key: ValueKey(selected.id),
                          initial: selected,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateEditor extends ConsumerStatefulWidget {
  const _TemplateEditor({required this.initial, super.key});
  final ClauseTemplate initial;

  @override
  ConsumerState<_TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<_TemplateEditor> {
  late ClauseTemplate _t = widget.initial;
  Timer? _timer;
  bool _dirty = false;
  late final LibraryDao _dao = ref.read(databaseProvider).libraryDao;

  @override
  void dispose() {
    _timer?.cancel();
    if (_dirty) unawaited(_dao.saveTemplate(_t));
    super.dispose();
  }

  void _update(ClauseTemplate Function(ClauseTemplate t) f) {
    setState(() {
      _t = f(_t);
      _dirty = true;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 700), () async {
      await _dao.saveTemplate(_t);
      if (mounted) setState(() => _dirty = false);
    });
  }

  void _editClause(String id, LibraryClause Function(LibraryClause c) f) =>
      _update(
        (t) => t.copyWith(
          clauses: [for (final c in t.clauses) c.id == id ? f(c) : c],
        ),
      );

  static String _defaultsText(Map<String, String> m) =>
      m.entries.map((e) => '${e.key}=${e.value}').join('\n');

  static Map<String, String> _parseDefaults(String text) => {
    for (final line in text.split('\n'))
      if (line.contains('='))
        line.substring(0, line.indexOf('=')).trim(): line
            .substring(line.indexOf('=') + 1)
            .trim(),
  }..removeWhere((k, _) => k.isEmpty);

  Future<void> _delete() async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteTemplate),
        content: Text(l.deleteTemplateBody(_t.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.deleteTemplate),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    _timer?.cancel();
    _dirty = false;
    await _dao.deleteTemplate(_t.id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const gap = SizedBox(height: Space.m - 4);
    return ListView(
      children: [
        PanelCard(
          title: _t.name,
          icon: Icons.description_outlined,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _dirty ? l.saving : l.saved,
                style: theme.textTheme.bodySmall,
              ),
              IconButton(
                tooltip: l.deleteTemplate,
                onPressed: () => unawaited(_delete()),
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
              Row(
                children: [
                  Expanded(
                    child: SyncedTextField(
                      label: l.templateName,
                      value: _t.name,
                      onChanged: (v) => _update(
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
                    selected: {_t.kind},
                    onSelectionChanged: (s) =>
                        _update((t) => t.copyWith(kind: s.first)),
                  ),
                ],
              ),
              gap,
              SyncedTextField(
                label: l.preamble,
                value: _t.preamble,
                minLines: 3,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                onChanged: (v) => _update((t) => t.copyWith(preamble: v)),
              ),
              gap,
              SyncedTextField(
                label: l.closingLine,
                value: _t.closing,
                minLines: 1,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                onChanged: (v) => _update((t) => t.copyWith(closing: v)),
              ),
              gap,
              SyncedTextField(
                label: l.templateDefaults,
                hint: l.templateDefaultsHint,
                value: _defaultsText(_t.varDefaults),
                textDirection: TextDirection.ltr,
                minLines: 3,
                maxLines: 12,
                keyboardType: TextInputType.multiline,
                onChanged: (v) =>
                    _update((t) => t.copyWith(varDefaults: _parseDefaults(v))),
              ),
            ],
          ),
        ),
        const SizedBox(height: Space.m),
        PanelCard(
          title: l.cardClauses,
          icon: Icons.format_list_numbered_rtl,
          trailing: OutlinedButton.icon(
            onPressed: () => _update(
              (t) => t.copyWith(
                clauses: [
                  ...t.clauses,
                  LibraryClause(id: newId()),
                ],
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: Text(l.addClause),
          ),
          child: ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorderItem: (from, to) => _update((t) {
              final list = [...t.clauses];
              final c = list.removeAt(from);
              list.insert(to.clamp(0, list.length), c);
              return t.copyWith(clauses: list);
            }),
            children: [
              for (final (i, c) in _t.clauses.indexed)
                Container(
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
                              onChanged: (v) => _editClause(
                                c.id,
                                (x) => x.copyWith(title: v),
                              ),
                            ),
                          ),
                          const SizedBox(width: Space.s),
                          FilterChip(
                            label: Text(l.optionalTag),
                            selected: c.optional,
                            onSelected: (v) => _editClause(
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
                            onSelected: (v) => _editClause(
                              c.id,
                              (x) => x.copyWith(enabledByDefault: v),
                            ),
                          ),
                          IconButton(
                            tooltip: l.deleteClause,
                            onPressed: () => _update(
                              (t) => t.copyWith(
                                clauses: t.clauses
                                    .where((x) => x.id != c.id)
                                    .toList(),
                              ),
                            ),
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
                        onChanged: (v) =>
                            _editClause(c.id, (x) => x.copyWith(body: v)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
