part of '../contract_cards.dart';

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
