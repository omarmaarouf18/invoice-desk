part of '../editor_cards.dart';

class DetailsCard extends ConsumerWidget {
  const DetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final issues = ref.watch(editorProvider.select((s) => s.issues));
    final number = _watchInv(ref, (i) => i.number);
    final issue = _watchInv(ref, (i) => i.issueDate);
    final due = _watchInv(ref, (i) => i.dueDate);
    final contract = _watchInv(ref, (i) => i.contractRef);
    final status = _watchInv(ref, (i) => i.status);
    final paid = _watchInv(ref, (i) => i.paidDate);
    final ctl = _ctl(ref);

    String? numberError;
    if (issues.contains(InvoiceIssue.emptyNumber)) {
      numberError = l.errEmptyNumber;
    }
    if (issues.contains(InvoiceIssue.duplicateNumber)) {
      numberError = l.errDuplicateNumber;
    }

    return PanelCard(
      title: l.cardDetails,
      icon: Icons.description_outlined,
      child: Column(
        children: [
          const _ClientPicker(),
          const SizedBox(height: Space.m - 4),
          _Pair(
            SyncedTextField(
              label: l.invoiceNumber,
              value: number,
              textDirection: TextDirection.ltr,
              errorText: numberError,
              textInputAction: TextInputAction.next,
              onChanged: (v) => ctl.edit((i) => i.copyWith(number: v.trim())),
            ),
            SyncedTextField(
              label: l.contractRef,
              value: contract,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.next,
              onChanged: (v) => ctl.edit((i) => i.copyWith(contractRef: v)),
            ),
          ),
          const SizedBox(height: Space.m - 4),
          _Pair(
            DateField(
              label: l.issueDate,
              value: issue,
              onChanged: ctl.setIssueDate,
            ),
            DateField(
              label: l.dueDate,
              value: due,
              onChanged: (d) => ctl.edit((i) => i.copyWith(dueDate: d)),
            ),
          ),
          const SizedBox(height: Space.m - 4),
          _StatusAndPaid(
            status: status,
            paid: paid,
            issue: issue,
          ),
          const _CalendarStrip(),
        ],
      ),
    );
  }
}

class _ClientPicker extends ConsumerWidget {
  const _ClientPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final clientId = _watchInv(ref, (i) => i.clientId);
    final missing = ref.watch(
      editorProvider.select(
        (s) => s.issues.contains(InvoiceIssue.missingClient),
      ),
    );
    final clients = ref.watch(clientsProvider).value ?? const <Client>[];
    final visible = [
      for (final c in clients)
        if (!c.archived || c.id == clientId) c,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    Future<void> createInline() async {
      final c = await AppActions(ref, context).newClient();
      if (c != null) _ctl(ref).edit((i) => i.copyWith(clientId: c.id));
    }

    return LayoutBuilder(
      builder: (context, box) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DropdownMenu<String>(
              key: ValueKey('client-$clientId-${visible.length}'),
              width: box.maxWidth - 140,
              initialSelection: clientId.isEmpty ? null : clientId,
              enableFilter: true,
              requestFocusOnTap: true,
              label: Text(l.client),
              hintText: l.chooseClient,
              errorText: missing ? l.errMissingClient : null,
              menuHeight: 320,
              dropdownMenuEntries: [
                for (final c in visible)
                  DropdownMenuEntry(value: c.id, label: c.name),
              ],
              onSelected: (id) {
                if (id != null) _ctl(ref).edit((i) => i.copyWith(clientId: id));
              },
            ),
          ),
          const SizedBox(width: Space.s),
          SizedBox(
            height: 40,
            child: Tooltip(
              message: '${l.newClient} (Ctrl+Shift+N)',
              child: OutlinedButton.icon(
                onPressed: () => unawaited(createInline()),
                icon: const Icon(Icons.person_add_alt, size: 18),
                label: Text(l.newClient),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A date shown with its Arabic month name; Enter/Space/click opens the
/// picker (which also allows typing).
class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final CalendarDate value;
  final ValueChanged<CalendarDate> onChanged;

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) onChanged(CalendarDate.fromDateTime(picked));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      onTap: () => unawaited(_pick(context)),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 16),
        ),
        child: Text(formatDocDate(value, context.docLanguage)),
      ),
    );
  }
}

/// Status, and the paid date once it is paid.
class _StatusAndPaid extends ConsumerWidget {
  const _StatusAndPaid({
    required this.status,
    required this.paid,
    required this.issue,
  });
  final InvoiceStatus status;
  final CalendarDate? paid;
  final CalendarDate issue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = _ctl(ref);
    final l = context.l10n;
    return _Pair(
      DropdownButtonFormField<InvoiceStatus>(
        key: ValueKey(status),
        initialValue: status,
        decoration: InputDecoration(labelText: l.status),
        items: [
          for (final s in InvoiceStatus.values)
            DropdownMenuItem(
              value: s,
              child: Text(
                statusLabel(context, switch (s) {
                  InvoiceStatus.draft => DisplayStatus.draft,
                  InvoiceStatus.sent => DisplayStatus.sent,
                  InvoiceStatus.paid => DisplayStatus.paid,
                  InvoiceStatus.voided => DisplayStatus.voided,
                }),
              ),
            ),
        ],
        onChanged: (s) {
          if (s != null) ctl.setStatus(s);
        },
      ),
      AnimatedSwitcher(
        duration: motion(context),
        child: status == InvoiceStatus.paid
            ? DateField(
                label: l.paidDate,
                value: paid ?? issue,
                onChanged: (d) =>
                    ctl.edit((i) => i.copyWith(paidDate: () => d)),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
