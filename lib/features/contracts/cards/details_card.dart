part of '../contract_cards.dart';

class ContractDetailsCard extends ConsumerWidget {
  const ContractDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locked = _locked(ref);
    final kind = _watch(ref, (c) => c.kind);
    final hasHistory = _watch(ref, (c) => c.history.isNotEmpty);
    return PanelCard(
      title: l.cardContractDetails,
      icon: Icons.gavel_outlined,
      trailing: Text(
        contractKindLabel(context, kind),
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: context.colors.muted),
      ),
      child: Column(
        children: [
          _ContractClientPicker(enabled: !locked),
          _gap,
          const _NumberAndStatus(),
          _gap,
          const _TitleFields(),
          _gap,
          const _ContractDates(),
          _gap,
          SyncedTextField(
            label: l.jurisdiction,
            value: _watch(ref, (c) => c.jurisdiction),
            readOnly: locked,
            onChanged: (v) =>
                _ctl(ref).edit((c) => c.copyWith(jurisdiction: v)),
          ),
          if (hasHistory) ...[_gap, const _HistoryList()],
          const _ContractCalendarLink(),
        ],
      ),
    );
  }
}

class _NumberAndStatus extends ConsumerWidget {
  const _NumberAndStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final issues = ref.watch(contractProvider.select((s) => s.issues));
    final status = _watch(ref, (c) => c.status);
    final numberError = issues.contains(ContractIssue.duplicateNumber)
        ? l.errDuplicateNumber
        : issues.contains(ContractIssue.emptyNumber)
        ? l.errEmptyNumber
        : null;
    return _Pair(
      SyncedTextField(
        label: l.contractNumber,
        value: _watch(ref, (c) => c.number),
        readOnly: _locked(ref),
        textDirection: TextDirection.ltr,
        errorText: numberError,
        onChanged: (v) => _ctl(ref).edit((c) => c.copyWith(number: v.trim())),
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
          if (s != null) ContractActions(ref, context).setStatus(s);
        },
      ),
    );
  }
}

class _TitleFields extends ConsumerWidget {
  const _TitleFields();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final locked = _locked(ref);
    final ctl = _ctl(ref);
    return Column(
      children: [
        _Pair(
          SyncedTextField(
            label: l.contractTitle,
            hint: l.contractTitleHint,
            value: _watch(ref, (c) => c.title),
            readOnly: locked,
            onChanged: (v) => ctl.edit((c) => c.copyWith(title: v)),
          ),
          SyncedTextField(
            label: l.projectName,
            value: _watch(ref, (c) => c.projectName),
            readOnly: locked,
            onChanged: (v) => ctl.edit((c) => c.copyWith(projectName: v)),
          ),
        ),
        _gap,
        SyncedTextField(
          label: l.projectSummary,
          value: _watch(ref, (c) => c.projectSummary),
          readOnly: locked,
          minLines: 2,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          onChanged: (v) => ctl.edit((c) => c.copyWith(projectSummary: v)),
        ),
      ],
    );
  }
}

/// Issue date follows the lock; signed/start/end stay editable on a signed
/// contract (they record what happened to it).
class _ContractDates extends ConsumerWidget {
  const _ContractDates();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ctl = _ctl(ref);
    void date(Contract Function(Contract c) f) =>
        ctl.edit(f, allowLocked: true);
    return Column(
      children: [
        _Pair(
          IgnorePointer(
            ignoring: _locked(ref),
            child: DateField(
              label: l.issueDate,
              value: _watch(ref, (c) => c.issueDate),
              onChanged: (d) => ctl.edit((c) => c.copyWith(issueDate: d)),
            ),
          ),
          OptionalDateField(
            label: l.signedDate,
            value: _watch(ref, (c) => c.signedDate),
            onChanged: (d) => date((c) => c.copyWith(signedDate: () => d)),
          ),
        ),
        _gap,
        _Pair(
          OptionalDateField(
            label: l.startDate,
            value: _watch(ref, (c) => c.startDate),
            onChanged: (d) => date((c) => c.copyWith(startDate: () => d)),
          ),
          OptionalDateField(
            label: l.endDate,
            value: _watch(ref, (c) => c.endDate),
            onChanged: (d) => date((c) => c.copyWith(endDate: () => d)),
          ),
        ),
      ],
    );
  }
}

/// "سجل العقد": the last six events, newest first.
class _HistoryList extends ConsumerWidget {
  const _HistoryList();

  static String _label(BuildContext context, ContractEvent e) {
    final l = context.l10n;
    if (e.event == 'unlock') return l.historyUnlock;
    if (e.event == 'relock') return l.historyRelock;
    if (e.event.startsWith('status:')) {
      final s = ContractStatus.fromDb(e.event.substring(7));
      return l.historyStatus(contractStatusLabel(context, s));
    }
    return e.event;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final history = _watch(ref, (c) => c.history);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.history, style: theme.textTheme.labelLarge),
        const SizedBox(height: Space.xs),
        for (final e in history.reversed.take(6))
          Text(
            '${formatArabicDate(CalendarDate.fromDateTime(eventTime(e)))} · '
            '${_label(context, e)}',
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
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
