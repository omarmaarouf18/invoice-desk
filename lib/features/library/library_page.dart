import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/repositories/library_repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart' show newId;
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

part 'library/template_widgets.dart';

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
      await ref.read(libraryRepositoryProvider).saveTemplate(t);
      setState(() => _selected = t.id);
    }

    return Padding(
      padding: const EdgeInsets.all(Space.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _LibraryHeader(),
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
                _TemplateList(
                  templates: templates,
                  selectedId: selected?.id,
                  onSelect: (id) => setState(() => _selected = id),
                  onAdd: () => unawaited(addTemplate()),
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
  late final LibraryRepository _dao = ref.read(libraryRepositoryProvider);

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
    return ListView(
      children: [
        _TemplateFields(
          t: _t,
          dirty: _dirty,
          update: _update,
          onDelete: () => unawaited(_delete()),
        ),
        const SizedBox(height: Space.m),
        PanelCard(
          title: l.cardClauses,
          icon: directionalIcon(
            context,
            Icons.format_list_numbered,
            Icons.format_list_numbered_rtl,
          ),
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
                _LibraryClauseRow(
                  i: i,
                  c: c,
                  edit: _editClause,
                  onDelete: () => _update(
                    (t) => t.copyWith(
                      clauses: t.clauses.where((x) => x.id != c.id).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
