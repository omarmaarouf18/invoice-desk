import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/contracts/contract_actions.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/features/editor/editor_cards.dart' show DateField;
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// Watches one slice of the open contract (tolerates it closing).
T _watch<T>(WidgetRef ref, T Function(Contract c) pick) {
  final v = ref.watch(
    contractProvider.select(
      (s) => s.contract == null ? null : (pick(s.contract!),),
    ),
  );
  return v!.$1;
}

ContractController _ctl(WidgetRef ref) => ref.read(contractProvider.notifier);

bool _locked(WidgetRef ref) => _watch(ref, (c) => c.isLocked);

class _Pair extends StatelessWidget {
  const _Pair(this.a, this.b);
  final Widget a;
  final Widget b;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: a),
      const SizedBox(width: Space.m - 4),
      Expanded(child: b),
    ],
  );
}

const _gap = SizedBox(height: Space.m - 4);

/// A date that may be empty, with a clear button.
class OptionalDateField extends ConsumerWidget {
  const OptionalDateField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.enabled = true,
  });

  final String label;
  final CalendarDate? value;
  final ValueChanged<CalendarDate?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final today = ref.watch(todayProvider);
    Future<void> pick() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: (value ?? today).toDateTime(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) onChanged(CalendarDate.fromDateTime(picked));
    }

    return InkWell(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      onTap: enabled ? () => unawaited(pick()) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          suffixIcon: value != null && enabled
              ? IconButton(
                  tooltip: l.clearDate,
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.calendar_today_outlined, size: 16),
        ),
        child: Text(value == null ? '—' : formatArabicDate(value!)),
      ),
    );
  }
}

// ── Lock banner ──────────────────────────────────────────────────────────
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

// ── بيانات العقد ─────────────────────────────────────────────────────────
class ContractDetailsCard extends ConsumerWidget {
  const ContractDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final issues = ref.watch(contractProvider.select((s) => s.issues));
    final locked = _locked(ref);
    final number = _watch(ref, (c) => c.number);
    final title = _watch(ref, (c) => c.title);
    final project = _watch(ref, (c) => c.projectName);
    final summary = _watch(ref, (c) => c.projectSummary);
    final issue = _watch(ref, (c) => c.issueDate);
    final start = _watch(ref, (c) => c.startDate);
    final end = _watch(ref, (c) => c.endDate);
    final signed = _watch(ref, (c) => c.signedDate);
    final status = _watch(ref, (c) => c.status);
    final jurisdiction = _watch(ref, (c) => c.jurisdiction);
    final kind = _watch(ref, (c) => c.kind);
    final history = _watch(ref, (c) => c.history);
    final ctl = _ctl(ref);
    final a = ContractActions(ref, context);

    String? numberError;
    if (issues.contains(ContractIssue.emptyNumber)) {
      numberError = l.errEmptyNumber;
    }
    if (issues.contains(ContractIssue.duplicateNumber)) {
      numberError = l.errDuplicateNumber;
    }

    return PanelCard(
      title: l.cardContractDetails,
      icon: Icons.gavel_outlined,
      trailing: Text(
        contractKindLabel(context, kind),
        style: theme.textTheme.labelMedium?.copyWith(
          color: context.colors.muted,
        ),
      ),
      child: Column(
        children: [
          _ContractClientPicker(enabled: !locked),
          _gap,
          _Pair(
            SyncedTextField(
              label: l.contractNumber,
              value: number,
              readOnly: locked,
              textDirection: TextDirection.ltr,
              errorText: numberError,
              onChanged: (v) => ctl.edit((c) => c.copyWith(number: v.trim())),
            ),
            DropdownButtonFormField<ContractStatus>(
              key: ValueKey('cstatus-$status'),
              initialValue: status,
              decoration: InputDecoration(labelText: l.status),
              items: [
                for (final s in ContractStatus.values)
                  DropdownMenuItem(
                    value: s,
                    child: Text(contractStatusLabel(context, s)),
                  ),
              ],
              onChanged: (s) {
                if (s != null) a.setStatus(s);
              },
            ),
          ),
          _gap,
          _Pair(
            SyncedTextField(
              label: l.contractTitle,
              hint: l.contractTitleHint,
              value: title,
              readOnly: locked,
              onChanged: (v) => ctl.edit((c) => c.copyWith(title: v)),
            ),
            SyncedTextField(
              label: l.projectName,
              value: project,
              readOnly: locked,
              onChanged: (v) => ctl.edit((c) => c.copyWith(projectName: v)),
            ),
          ),
          _gap,
          SyncedTextField(
            label: l.projectSummary,
            value: summary,
            readOnly: locked,
            minLines: 2,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            onChanged: (v) => ctl.edit((c) => c.copyWith(projectSummary: v)),
          ),
          _gap,
          _Pair(
            IgnorePointer(
              ignoring: locked,
              child: DateField(
                label: l.issueDate,
                value: issue,
                onChanged: (d) => ctl.edit((c) => c.copyWith(issueDate: d)),
              ),
            ),
            OptionalDateField(
              label: l.signedDate,
              value: signed,
              onChanged: (d) => ctl.edit(
                (c) => c.copyWith(signedDate: () => d),
                allowLocked: true,
              ),
            ),
          ),
          _gap,
          _Pair(
            OptionalDateField(
              label: l.startDate,
              value: start,
              onChanged: (d) => ctl.edit(
                (c) => c.copyWith(startDate: () => d),
                allowLocked: true,
              ),
            ),
            OptionalDateField(
              label: l.endDate,
              value: end,
              onChanged: (d) => ctl.edit(
                (c) => c.copyWith(endDate: () => d),
                allowLocked: true,
              ),
            ),
          ),
          _gap,
          SyncedTextField(
            label: l.jurisdiction,
            value: jurisdiction,
            readOnly: locked,
            onChanged: (v) => ctl.edit((c) => c.copyWith(jurisdiction: v)),
          ),
          if (history.isNotEmpty) ...[
            _gap,
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(l.history, style: theme.textTheme.labelLarge),
            ),
            const SizedBox(height: Space.xs),
            for (final e in history.reversed.take(6))
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  '${formatArabicDate(CalendarDate.fromDateTime(eventTime(e)))} · '
                  '${_eventLabel(context, e)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _eventLabel(BuildContext context, ContractEvent e) {
    final l = context.l10n;
    if (e.event == 'unlock') return l.historyUnlock;
    if (e.event == 'relock') return l.historyRelock;
    if (e.event.startsWith('status:')) {
      final s = ContractStatus.fromDb(e.event.substring(7));
      return l.historyStatus(contractStatusLabel(context, s));
    }
    return e.event;
  }
}

class _ContractClientPicker extends ConsumerWidget {
  const _ContractClientPicker({required this.enabled});
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final clientId = _watch(ref, (c) => c.clientId);
    final clients = ref.watch(clientsProvider).value ?? const <Client>[];
    final visible = [
      for (final c in clients)
        if (!c.archived || c.id == clientId) c,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    final client = clients.where((c) => c.id == clientId).firstOrNull;
    return LayoutBuilder(
      builder: (context, box) => Row(
        children: [
          Expanded(
            child: DropdownMenu<String>(
              key: ValueKey('cclient-$clientId-${visible.length}'),
              width: box.maxWidth - 190,
              enabled: enabled,
              initialSelection: clientId,
              enableFilter: true,
              requestFocusOnTap: true,
              label: Text(l.client),
              menuHeight: 320,
              dropdownMenuEntries: [
                for (final c in visible)
                  DropdownMenuEntry(value: c.id, label: c.name),
              ],
              onSelected: (id) {
                if (id != null) {
                  _ctl(ref).edit((c) => c.copyWith(clientId: id));
                }
              },
            ),
          ),
          const SizedBox(width: Space.s),
          SizedBox(
            height: 40,
            child: OutlinedButton.icon(
              onPressed: client == null
                  ? null
                  : () =>
                        unawaited(AppActions(ref, context).editClient(client)),
              icon: const Icon(Icons.badge_outlined, size: 18),
              label: Text(l.editClientData),
            ),
          ),
        ],
      ),
    );
  }
}

// ── المتغيرات ────────────────────────────────────────────────────────────
class VariablesCard extends ConsumerStatefulWidget {
  const VariablesCard({super.key});

  @override
  ConsumerState<VariablesCard> createState() => _VariablesCardState();
}

class _VariablesCardState extends ConsumerState<VariablesCard> {
  final _keys = <String, GlobalKey>{};
  final _focus = <String, FocusNode>{};

  @override
  void dispose() {
    for (final f in _focus.values) {
      f.dispose();
    }
    super.dispose();
  }

  FocusNode _node(String name) =>
      _focus.putIfAbsent(name, () => FocusNode(debugLabel: 'var:$name'));
  GlobalKey _key(String name) => _keys.putIfAbsent(name, GlobalKey.new);

  void _jump(String name) {
    final ctx = _key(name).currentContext;
    if (ctx == null) return;
    unawaited(
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.3,
        duration: const Duration(milliseconds: 250),
      ),
    );
    _node(name).requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    ref.listen(contractProvider.select((s) => s.focusTick), (_, _) {
      final name = ref.read(contractProvider).focusVariable;
      if (name != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _jump(name));
      }
    });
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final resolver = ref.watch(openResolverProvider);
    final locked = c.isLocked;
    final used = usedVariables(c);
    final custom = used.where((v) => !isBuiltInVariable(v)).toList();
    final builtInMissing = [
      for (final v in used)
        if (isBuiltInVariable(v) && resolver?.resolve(v) == null) v,
    ];
    final amber = missingColors(context);
    final client = (ref.watch(clientsProvider).value ?? const <Client>[])
        .where((x) => x.id == c.clientId)
        .firstOrNull;

    String source(String v) => v.startsWith('client.')
        ? l.sourceClient
        : v.startsWith('provider.')
        ? l.sourceSettings
        : l.sourceContract;

    return PanelCard(
      title: l.cardVariables,
      icon: Icons.data_object,
      trailing: Text(
        l.variablesHelp,
        style: theme.textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (custom.isEmpty)
            Text(l.noCustomVariables, style: theme.textTheme.bodySmall),
          for (final v in custom)
            Padding(
              key: _key(v),
              padding: const EdgeInsetsDirectional.only(bottom: Space.s),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      v,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: resolver?.resolve(v) == null
                            ? amber.fg
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.m - 4),
                  Expanded(
                    child: SyncedTextField(
                      key: ValueKey('var-$v'),
                      value: c.vars[v] ?? '',
                      focusNode: _node(v),
                      readOnly: locked,
                      dense: true,
                      hint: '{{$v}}',
                      errorText: resolver?.resolve(v) == null ? '' : null,
                      onChanged: (x) => _ctl(ref).setVariable(v, x),
                    ),
                  ),
                ],
              ),
            ),
          for (final v in builtInMissing)
            Padding(
              key: _key(v),
              padding: const EdgeInsetsDirectional.only(bottom: Space.s),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      v,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: amber.fg,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.m - 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: Space.s + 4,
                        vertical: Space.s,
                      ),
                      decoration: BoxDecoration(
                        color: amber.bg,
                        borderRadius: BorderRadius.circular(
                          Space.radiusSmall,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.builtInMissing(source(v)),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: amber.fg,
                              ),
                            ),
                          ),
                          if (v.startsWith('client.') && client != null)
                            TextButton(
                              focusNode: _node(v),
                              onPressed: () => unawaited(
                                AppActions(ref, context).editClient(client),
                              ),
                              child: Text(l.editClientData),
                            )
                          else if (v.startsWith('provider.'))
                            TextButton(
                              focusNode: _node(v),
                              onPressed: () => ref
                                  .read(workspaceProvider.notifier)
                                  .show(Workspace.settings),
                              child: Text(l.openSettings),
                            )
                          else
                            Focus(focusNode: _node(v), child: const SizedBox()),
                        ],
                      ),
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

// ── البنود ───────────────────────────────────────────────────────────────
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
      icon: Icons.format_list_numbered_rtl,
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
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final x = c.clauses.where((y) => y.id == widget.id).firstOrNull;
    if (x == null) return const SizedBox.shrink();
    final locked = c.isLocked;
    final resolver = ref.watch(openResolverProvider);
    final enabledBefore = c.clauses
        .take(widget.index)
        .where((y) => y.enabled)
        .length;
    final ordinal = x.enabled
        ? 'البند ${arabicOrdinal(enabledBefore + 1)}'
        : '—';
    final a = ContractActions(ref, context);
    final ctl = _ctl(ref);
    final muted = context.colors.muted;

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
          InkWell(
            borderRadius: BorderRadius.circular(Space.radiusSmall),
            onTap: () => setState(() => _open = !_open),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
              child: Row(
                children: [
                  if (!locked)
                    ReorderableDragStartListener(
                      index: widget.index,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.drag_indicator,
                          size: 18,
                          color: muted,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: Space.s),
                  SizedBox(
                    width: 112,
                    child: Text(
                      ordinal,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: x.enabled ? theme.colorScheme.primary : muted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: VariableText(
                            x.title.isEmpty ? l.clauseTitle : x.title,
                            resolver: resolver,
                            maxLines: 1,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: x.enabled ? null : muted,
                            ),
                          ),
                        ),
                        if (x.optional) ...[
                          const SizedBox(width: Space.s),
                          const OptionalTag(),
                        ],
                      ],
                    ),
                  ),
                  Tooltip(
                    message: l.clauseEnabled,
                    child: Switch(
                      value: x.enabled,
                      onChanged: locked
                          ? null
                          : (v) => ctl.editClause(
                              x.id,
                              (y) => y.copyWith(enabled: v),
                            ),
                    ),
                  ),
                  MenuAnchor(
                    builder: (context, controller, _) => IconButton(
                      tooltip: l.more,
                      onPressed: () => controller.isOpen
                          ? controller.close()
                          : controller.open(),
                      icon: const Icon(Icons.more_vert, size: 18),
                    ),
                    menuChildren: [
                      if (x.fromLibraryClauseId != null) ...[
                        MenuItemButton(
                          leadingIcon: const Icon(Icons.history, size: 18),
                          onPressed: locked
                              ? null
                              : () => unawaited(a.restoreClause(x)),
                          child: Text(l.restoreFromLibrary),
                        ),
                        MenuItemButton(
                          leadingIcon: const Icon(
                            Icons.upload_outlined,
                            size: 18,
                          ),
                          onPressed: () => unawaited(a.saveClauseToLibrary(x)),
                          child: Text(l.saveToLibrary),
                        ),
                      ],
                      MenuItemButton(
                        leadingIcon: const Icon(Icons.copy_outlined, size: 18),
                        onPressed: locked
                            ? null
                            : () => ctl.duplicateClause(x.id),
                        child: Text(l.duplicateClause),
                      ),
                      MenuItemButton(
                        leadingIcon: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: locked ? null : () => ctl.removeClause(x.id),
                        child: Text(l.deleteClause),
                      ),
                    ],
                  ),
                  Icon(
                    _open ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: muted,
                  ),
                  const SizedBox(width: Space.xs),
                ],
              ),
            ),
          ),
          if (!_open && x.body.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                Space.l + 4,
                0,
                Space.m,
                Space.s + 2,
              ),
              child: VariableText(
                // One line: sub-item markers dropped, items joined.
                x.body
                    .split('\n')
                    .map((l) => l.replaceFirst(RegExp(r'^\s*[-–•]\s+'), ''))
                    .where((l) => l.trim().isNotEmpty)
                    .join('  ·  '),
                resolver: resolver,
                maxLines: 2,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: x.enabled ? null : muted,
                ),
              ),
            ),
          if (_open)
            Padding(
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
                          onChanged: (v) => ctl.editClause(
                            x.id,
                            (y) => y.copyWith(title: v),
                          ),
                        ),
                        _gap,
                        _VariableField(
                          key: ValueKey('body-${x.id}'),
                          label: l.clauseBody,
                          helper: l.clauseBodyHelp,
                          value: x.body,
                          multiline: true,
                          onChanged: (v) => ctl.editClause(
                            x.id,
                            (y) => y.copyWith(body: v),
                          ),
                        ),
                        if (x.body.contains('{{')) ...[
                          _gap,
                          VariableText(
                            x.body,
                            resolver: resolver,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

/// Text field with the `{{` variable autocomplete (suggestions under it).
class _VariableField extends ConsumerStatefulWidget {
  const _VariableField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.helper,
    this.multiline = false,
  });

  final String label;
  final String? helper;
  final String value;
  final bool multiline;
  final ValueChanged<String> onChanged;

  @override
  ConsumerState<_VariableField> createState() => _VariableFieldState();
}

class _VariableFieldState extends ConsumerState<_VariableField> {
  late final _c = TextEditingController(text: widget.value);
  final _focus = FocusNode();
  String? _partial;

  @override
  void initState() {
    super.initState();
    _c.addListener(_onEdit);
  }

  @override
  void didUpdateWidget(_VariableField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && _c.text != widget.value) _c.text = widget.value;
  }

  @override
  void dispose() {
    _c.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onEdit() {
    final p = VariableAutocomplete.partialAt(_c.value);
    if (p != _partial) setState(() => _partial = p);
  }

  void _pick(String name) {
    _c.value = VariableAutocomplete.complete(_c.value, name);
    widget.onChanged(_c.text);
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = ref.watch(contractProvider.select((s) => s.contract));
    final known = <String>{
      ...builtInVariables,
      ...?c?.vars.keys,
    };
    final p = _partial?.toLowerCase();
    final matches = p == null
        ? const <String>[]
        : known.where((k) => k.toLowerCase().contains(p)).take(10).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _c,
          focusNode: _focus,
          minLines: widget.multiline ? 3 : 1,
          maxLines: widget.multiline ? 14 : 1,
          keyboardType: widget.multiline ? TextInputType.multiline : null,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helper,
            isDense: true,
          ),
        ),
        if (matches.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(top: Space.xs),
            child: Wrap(
              spacing: Space.xs,
              runSpacing: Space.xs,
              children: [
                for (final m in matches)
                  ActionChip(
                    key: ValueKey('suggest-$m'),
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      m,
                      textDirection: TextDirection.ltr,
                      style: theme.textTheme.labelSmall,
                    ),
                    onPressed: () => _pick(m),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── ملحق (1) نطاق العمل ──────────────────────────────────────────────────
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

// ── ملحق (2) المقابل والدفعات ───────────────────────────────────────────
String _rawMoney(int minor) => minor % Currency.minorFactor == 0
    ? '${minor ~/ Currency.minorFactor}'
    : (minor / Currency.minorFactor).toStringAsFixed(2);

/// `30%` → percent; `25000` → fixed amount; empty → neither.
({int? bp, int? minor})? parseShare(String input) {
  final s = input.trim();
  if (s.isEmpty) return (bp: null, minor: null);
  if (s.endsWith('%') || s.endsWith('٪')) {
    final bp = parsePercentToBp(s.substring(0, s.length - 1));
    if (bp == null || bp > 10000) return null;
    return (bp: bp, minor: null);
  }
  final m = parseMoneyInput(s);
  return m == null ? null : (bp: null, minor: m);
}

String shareText(PaymentMilestone m) => m.amountMinor != null
    ? _rawMoney(m.amountMinor!)
    : m.percentBp != null
    ? '${formatBpAsPercent(m.percentBp!)}%'
    : '';

class PaymentAnnexCard extends ConsumerWidget {
  const PaymentAnnexCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final locked = c.isLocked;
    final ctl = _ctl(ref);
    final check = checkMilestones(c);
    final invoices = ref.watch(invoicesProvider).value ?? const <Invoice>[];
    final byId = {for (final i in invoices) i.id: i};
    final amber = missingColors(context);
    final today = ref.watch(todayProvider);
    final a = ContractActions(ref, context);

    Widget head(String t, int flex) => Expanded(
      flex: flex,
      child: Text(t, style: theme.textTheme.labelMedium),
    );

    final balanced = check.balanced && c.milestones.isNotEmpty;
    final pctOff =
        check.percentSumBp != 0 &&
        check.percentSumBp != 10000 &&
        c.milestones.every((m) => m.amountMinor == null);

    return PanelCard(
      title: l.cardPaymentAnnex,
      icon: Icons.payments_outlined,
      trailing: locked
          ? null
          : OutlinedButton.icon(
              key: const ValueKey('add-milestone'),
              onPressed: ctl.addMilestone,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l.addMilestone),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SyncedTextField(
                  key: const ValueKey('contract-total'),
                  label: l.contractTotal,
                  value: _rawMoney(c.totalMinor),
                  readOnly: locked,
                  textDirection: TextDirection.ltr,
                  formatOnBlur: (raw) {
                    final m = parseMoneyInput(raw);
                    return m == null ? raw : formatAmount(m, c.currency);
                  },
                  onChanged: (v) {
                    final m = parseMoneyInput(v);
                    if (m != null) ctl.edit((x) => x.copyWith(totalMinor: m));
                  },
                ),
              ),
              const SizedBox(width: Space.m - 4),
              SizedBox(
                width: 140,
                child: DropdownButtonFormField<Currency>(
                  key: ValueKey('ccur-${c.currency}'),
                  initialValue: c.currency,
                  decoration: InputDecoration(labelText: l.currency),
                  items: [
                    for (final x in Currency.values)
                      DropdownMenuItem(value: x, child: Text(x.code)),
                  ],
                  onChanged: locked
                      ? null
                      : (x) {
                          if (x != null) {
                            ctl.edit((y) => y.copyWith(currency: x));
                          }
                        },
                ),
              ),
              const SizedBox(width: Space.m),
              Expanded(
                flex: 4,
                child: Text(
                  formatContractMoney(c.totalMinor, c.currency),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.m),
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
            child: Row(
              children: [
                head(l.milestoneLabel, 4),
                const SizedBox(width: Space.s),
                head(l.milestoneShare, 2),
                const SizedBox(width: Space.s),
                head(l.milestoneTrigger, 4),
                const SizedBox(width: Space.s),
                head(l.milestoneDue, 3),
                const SizedBox(width: Space.s),
                head(l.milestoneAmount, 3),
                const SizedBox(width: 172),
              ],
            ),
          ),
          for (final (i, m) in c.milestones.indexed)
            Padding(
              key: ValueKey(m.id),
              padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: SyncedTextField(
                      value: m.label,
                      dense: true,
                      readOnly: locked,
                      onChanged: (v) =>
                          ctl.editMilestone(m.id, (x) => x.copyWith(label: v)),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 2,
                    child: SyncedTextField(
                      value: shareText(m),
                      dense: true,
                      readOnly: locked,
                      hint: l.milestoneShareHint,
                      textDirection: TextDirection.ltr,
                      onChanged: (v) {
                        final s = parseShare(v);
                        if (s == null) return;
                        ctl.editMilestone(
                          m.id,
                          (x) => x.copyWith(
                            percentBp: () => s.bp,
                            amountMinor: () => s.minor,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 4,
                    child: SyncedTextField(
                      value: m.trigger,
                      dense: true,
                      readOnly: locked,
                      hint: l.milestoneTriggerHint,
                      onChanged: (v) => ctl.editMilestone(
                        m.id,
                        (x) => x.copyWith(trigger: v),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 3,
                    child: OptionalDateField(
                      label: '',
                      value: m.dueDate,
                      enabled: !locked,
                      onChanged: (d) => ctl.editMilestone(
                        m.id,
                        (x) => x.copyWith(dueDate: () => d),
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.s),
                  Expanded(
                    flex: 3,
                    child: Text(
                      formatMoney(check.amounts[i], c.currency),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(
                    width: 132,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: _MilestoneInvoice(
                        milestone: m,
                        invoice: byId[m.invoiceId],
                        today: today,
                        onCreate: () => unawaited(a.createInvoice(m)),
                        onOpen: (id) => unawaited(a.openInvoice(id)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: locked
                        ? null
                        : IconButton(
                            tooltip: l.deleteItem,
                            onPressed: () => ctl.removeMilestone(m.id),
                            icon: const Icon(Icons.close, size: 16),
                          ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: Space.s),
          Container(
            key: const ValueKey('milestone-check'),
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Space.m - 4,
              vertical: Space.s,
            ),
            decoration: BoxDecoration(
              color: balanced && !pctOff ? context.colors.subtle : amber.bg,
              borderRadius: BorderRadius.circular(Space.radiusSmall),
            ),
            child: Row(
              children: [
                Icon(
                  balanced && !pctOff
                      ? Icons.check_circle_outline
                      : Icons.warning_amber_rounded,
                  size: 18,
                  color: balanced && !pctOff
                      ? theme.colorScheme.primary
                      : amber.fg,
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  child: Text(
                    pctOff
                        ? l.milestonesPercentOff(
                            formatBpAsPercent(check.percentSumBp),
                          )
                        : balanced
                        ? l.milestonesBalanced
                        : l.milestonesOff(
                            formatMoney(check.sum, c.currency),
                            formatMoney(check.total, c.currency),
                            formatMoney(check.difference, c.currency),
                          ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: balanced && !pctOff ? null : amber.fg,
                    ),
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

class _MilestoneInvoice extends StatelessWidget {
  const _MilestoneInvoice({
    required this.milestone,
    required this.invoice,
    required this.today,
    required this.onCreate,
    required this.onOpen,
  });

  final PaymentMilestone milestone;
  final Invoice? invoice;
  final CalendarDate today;
  final VoidCallback onCreate;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final inv = invoice;
    if (inv == null) {
      return TextButton.icon(
        key: ValueKey('create-invoice-${milestone.id}'),
        onPressed: onCreate,
        icon: const Icon(Icons.receipt_long_outlined, size: 16),
        label: Text(context.l10n.createInvoice),
      );
    }
    return InkWell(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      onTap: () => onOpen(inv.id),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              inv.number,
              textDirection: TextDirection.ltr,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
            StatusChip(inv.displayStatus(today), dense: true),
          ],
        ),
      ),
    );
  }
}

// ── الفواتير المرتبطة ────────────────────────────────────────────────────
class LinkedInvoicesCard extends ConsumerWidget {
  const LinkedInvoicesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final number = _watch(ref, (c) => c.number);
    final linkedIds = _watch(
      ref,
      (c) => {
        for (final m in c.milestones)
          if (m.invoiceId != null) m.invoiceId!,
      },
    );
    final today = ref.watch(todayProvider);
    final invoices = [
      for (final i in ref.watch(invoicesProvider).value ?? const <Invoice>[])
        if (i.contractRef.trim() == number || linkedIds.contains(i.id)) i,
    ]..sort((a, b) => a.issueDate.compareTo(b.issueDate));
    final a = ContractActions(ref, context);
    return PanelCard(
      title: l.cardLinkedInvoices,
      icon: Icons.receipt_long_outlined,
      child: invoices.isEmpty
          ? Text(l.noLinkedInvoices, style: theme.textTheme.bodySmall)
          : Column(
              children: [
                for (final i in invoices)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onTap: () => unawaited(a.openInvoice(i.id)),
                    title: Row(
                      children: [
                        Text(i.number, textDirection: TextDirection.ltr),
                        const SizedBox(width: Space.s),
                        StatusChip(i.displayStatus(today), dense: true),
                        const Spacer(),
                        Text(
                          i.totals.total.format(),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    subtitle: Text(formatArabicDate(i.issueDate)),
                  ),
              ],
            ),
    );
  }
}

/// Keeps `services.dart` imported for the shortcut constants in the page.
const contractSaveShortcut = SingleActivator(
  LogicalKeyboardKey.keyS,
  control: true,
);
