import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// Watches one slice of the open invoice. The selector tolerates the
/// invoice closing (the card is then disposed before it rebuilds).
T _watchInv<T>(WidgetRef ref, T Function(Invoice i) pick) {
  final v = ref.watch(
    editorProvider.select(
      (s) => s.invoice == null ? null : (pick(s.invoice!),),
    ),
  );
  return v!.$1;
}

EditorController _ctl(WidgetRef ref) => ref.read(editorProvider.notifier);

/// Two fields side by side on the 8 px grid.
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

// ── بيانات الفاتورة ──────────────────────────────────────────────────────
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
          _Pair(
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
          ),
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
        child: Text(formatArabicDate(value)),
      ),
    );
  }
}

// ── الإجماليات والضريبة ─────────────────────────────────────────────────
class TotalsCard extends ConsumerWidget {
  const TotalsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final vatOn = _watchInv(ref, (i) => i.vatOn);
    final rate = _watchInv(ref, (i) => i.vatRateBp);
    final totals = _watchInv(ref, (i) => i.totals.total);
    final inv = ref.read(editorProvider).invoice!;
    final t = inv.totals;
    final due = _watchInv(ref, (i) => i.dueDate);
    final ctl = _ctl(ref);

    Widget row(String k, String v, {TextStyle? style}) => Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.muted,
              ),
            ),
          ),
          Text(
            v,
            textDirection: TextDirection.ltr,
            style: style ?? theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );

    return PanelCard(
      title: l.cardTotals,
      icon: Icons.calculate_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Switch(
                value: vatOn,
                onChanged: (v) => ctl.edit((i) => i.copyWith(vatOn: v)),
              ),
              const SizedBox(width: Space.s),
              Expanded(child: Text(l.vat, style: theme.textTheme.bodyLarge)),
              SizedBox(
                width: 120,
                child: _RateField(
                  bp: rate,
                  enabled: vatOn,
                  onChanged: (bp) => ctl.edit((i) => i.copyWith(vatRateBp: bp)),
                ),
              ),
            ],
          ),
          const SizedBox(height: Space.s),
          const Divider(),
          const SizedBox(height: Space.s),
          row(l.subtotal, t.subtotal.format()),
          if (vatOn)
            row(
              '${l.vatLine} (${formatBpAsPercent(rate)}%)',
              t.vat.format(),
            ),
          const SizedBox(height: Space.s),
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: Space.m,
              vertical: Space.m - 4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.inverseSurface,
              borderRadius: BorderRadius.circular(Space.radiusSmall),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.totalDue,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                      Text(
                        l.dueBy(formatArabicDate(due)),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onInverseSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (final m in totals.nonZero)
                      Text(
                        m.format(),
                        textDirection: TextDirection.ltr,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                    if (totals.isEmpty)
                      Text(
                        '0',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RateField extends StatefulWidget {
  const _RateField({
    required this.bp,
    required this.enabled,
    required this.onChanged,
  });
  final int bp;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  State<_RateField> createState() => _RateFieldState();
}

class _RateFieldState extends State<_RateField> {
  bool _bad = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return IgnorePointer(
      ignoring: !widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: SyncedTextField(
          label: l.vatRate,
          value: formatBpAsPercent(widget.bp),
          textDirection: TextDirection.ltr,
          errorText: _bad ? l.errRate : null,
          onChanged: (v) {
            final bp = parsePercentToBp(v);
            final ok = bp != null && bp <= 10000;
            setState(() => _bad = !ok);
            if (ok) widget.onChanged(bp);
          },
        ),
      ),
    );
  }
}

// ── ملاحظات ─────────────────────────────────────────────────────────────
class NotesCard extends ConsumerWidget {
  const NotesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final en = _watchInv(ref, (i) => i.notesEn);
    final ar = _watchInv(ref, (i) => i.notesAr);
    final ctl = _ctl(ref);
    return PanelCard(
      title: l.cardNotes,
      icon: Icons.notes_outlined,
      child: _Pair(
        SyncedTextField(
          label: l.notesEn,
          value: en,
          minLines: 4,
          maxLines: 10,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.multiline,
          onChanged: (v) => ctl.edit((i) => i.copyWith(notesEn: v)),
        ),
        SyncedTextField(
          label: l.notesAr,
          value: ar,
          minLines: 4,
          maxLines: 10,
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.multiline,
          onChanged: (v) => ctl.edit((i) => i.copyWith(notesAr: v)),
        ),
      ),
    );
  }
}

// ── صفحة نطاق المشروع ───────────────────────────────────────────────────
class ScopeCard extends ConsumerWidget {
  const ScopeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sc = _watchInv(ref, (i) => i.scope);
    final ctl = _ctl(ref);
    void set(ScopePage Function(ScopePage s) f) =>
        ctl.edit((i) => i.copyWith(scope: f(i.scope)));
    const gap = SizedBox(height: Space.m - 4);
    return PanelCard(
      title: l.cardScope,
      icon: Icons.assignment_outlined,
      trailing: Switch(
        value: sc.enabled,
        onChanged: (v) => set((s) => s.copyWith(enabled: v)),
      ),
      child: AnimatedSize(
        duration: motion(context),
        alignment: AlignmentDirectional.topStart,
        child: !sc.enabled
            ? Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l.scopeToggle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            : Column(
                children: [
                  SyncedTextField(
                    label: l.scopeTitle,
                    value: sc.title,
                    onChanged: (v) => set((s) => s.copyWith(title: v)),
                  ),
                  gap,
                  SyncedTextField(
                    label: l.scopeOverview,
                    value: sc.overview,
                    minLines: 2,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    onChanged: (v) => set((s) => s.copyWith(overview: v)),
                  ),
                  gap,
                  _Pair(
                    SyncedTextField(
                      label: l.scopeDone,
                      value: sc.done,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      onChanged: (v) => set((s) => s.copyWith(done: v)),
                    ),
                    SyncedTextField(
                      label: l.scopeDelivered,
                      value: sc.delivered,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      onChanged: (v) => set((s) => s.copyWith(delivered: v)),
                    ),
                  ),
                  gap,
                  SyncedTextField(
                    label: l.scopeWarranty,
                    value: sc.warranty,
                    minLines: 2,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    onChanged: (v) => set((s) => s.copyWith(warranty: v)),
                  ),
                ],
              ),
      ),
    );
  }
}
