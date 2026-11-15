import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// A previously used service, for autocomplete.
class ServiceSuggestion {
  const ServiceSuggestion(this.item, this.currency);
  final LineItem item;
  final Currency currency;
}

/// Distinct services from all invoices, most recently updated first.
final serviceHistoryProvider = Provider<List<ServiceSuggestion>>((ref) {
  final invoices = [...?ref.watch(invoicesProvider).value]
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  final seen = <String>{};
  final out = <ServiceSuggestion>[];
  for (final inv in invoices) {
    for (final s in inv.sections) {
      for (final i in s.items) {
        final key = foldForSearch(i.service.trim());
        if (key.isEmpty || !seen.add(key)) continue;
        out.add(ServiceSuggestion(i, s.currency));
      }
    }
  }
  return out;
});

String cycleLabel(BuildContext context, BillingCycle c) => switch (c) {
  BillingCycle.oneTime => context.l10n.cycleOneTime,
  BillingCycle.monthly => context.l10n.cycleMonthly,
  BillingCycle.annual => context.l10n.cycleAnnual,
};

String _rawMoney(int minor) => minor % Currency.minorFactor == 0
    ? '${minor ~/ Currency.minorFactor}'
    : (minor / Currency.minorFactor).toStringAsFixed(2);

class SectionsCard extends ConsumerWidget {
  const SectionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ids = ref.watch(
      editorProvider.select(
        (s) => s.invoice?.sections.map((e) => e.id).join(',') ?? '',
      ),
    );
    return PanelCard(
      title: l.cardSections,
      icon: Icons.view_list_outlined,
      trailing: TextButton.icon(
        onPressed: ref.read(editorProvider.notifier).addSection,
        icon: const Icon(Icons.add, size: 18),
        label: Text(l.addSection),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, id)
              in ids.split(',').where((e) => e.isNotEmpty).indexed) ...[
            if (i > 0) const SizedBox(height: Space.m),
            _SectionEditor(key: ValueKey(id), sectionId: id, index: i + 1),
          ],
        ],
      ),
    );
  }
}

class _SectionEditor extends ConsumerStatefulWidget {
  const _SectionEditor({
    required this.sectionId,
    required this.index,
    super.key,
  });
  final String sectionId;
  final int index;

  @override
  ConsumerState<_SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends ConsumerState<_SectionEditor> {
  /// Row whose service field should take focus when it first builds.
  String? _focusItem;

  InvoiceSection? _section(EditorState s) =>
      s.invoice?.sections.where((e) => e.id == widget.sectionId).firstOrNull;

  void _addAfter(String? afterId) {
    final id = ref
        .read(editorProvider.notifier)
        .addItem(widget.sectionId, afterId: afterId);
    setState(() => _focusItem = id);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final section = ref.watch(editorProvider.select(_section));
    if (section == null) return const SizedBox.shrink();
    final ctl = ref.read(editorProvider.notifier);
    final c = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(Space.radius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Space.m - 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 10,
                    end: Space.s,
                  ),
                  child: Text(
                    '${widget.index}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SyncedTextField(
                    label: l.sectionTitleEn,
                    value: section.titleEn,
                    textDirection: TextDirection.ltr,
                    onChanged: (v) => ctl.editSection(
                      section.id,
                      (s) => s.copyWith(titleEn: v),
                    ),
                  ),
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  flex: 3,
                  child: SyncedTextField(
                    label: l.sectionTitleAr,
                    value: section.titleAr,
                    textDirection: TextDirection.rtl,
                    onChanged: (v) => ctl.editSection(
                      section.id,
                      (s) => s.copyWith(titleAr: v),
                    ),
                  ),
                ),
                const SizedBox(width: Space.s),
                SizedBox(
                  width: 104,
                  child: DropdownButtonFormField<Currency>(
                    initialValue: section.currency,
                    decoration: InputDecoration(labelText: l.currency),
                    items: [
                      for (final cur in Currency.values)
                        DropdownMenuItem(value: cur, child: Text(cur.code)),
                    ],
                    onChanged: (cur) {
                      if (cur != null) {
                        ctl.editSection(
                          section.id,
                          (s) => s.copyWith(currency: cur),
                        );
                      }
                    },
                  ),
                ),
                IconButton(
                  tooltip: l.deleteSection,
                  onPressed: () => ctl.removeSection(section.id),
                  icon: const Icon(Icons.delete_outline, size: 20),
                ),
              ],
            ),
            const SizedBox(height: Space.s + 4),
            const _HeaderRow(),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              itemCount: section.items.length,
              onReorderItem: (from, to) =>
                  ctl.reorderItem(section.id, from, to),
              itemBuilder: (context, i) {
                final item = section.items[i];
                final focus = item.id == _focusItem;
                if (focus) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _focusItem = null,
                  );
                }
                return _ItemRow(
                  key: ValueKey(item.id),
                  index: i,
                  sectionId: section.id,
                  item: item,
                  currency: section.currency,
                  autofocus: focus,
                  isLast: i == section.items.length - 1,
                  onEnterAtEnd: () => _addAfter(item.id),
                );
              },
            ),
            const SizedBox(height: Space.s),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _addAfter(section.items.lastOrNull?.id),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.addItem),
                ),
                const Spacer(),
                Text(
                  l.subtotal,
                  style: theme.textTheme.bodyMedium?.copyWith(color: c.muted),
                ),
                const SizedBox(width: Space.m),
                Text(
                  section.subtotal.format(),
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(width: Space.s),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Column widths shared by header and rows.
const _wHandle = 28.0;
const _wCycle = 112.0;
const _wQty = 64.0;
const _wPrice = 112.0;
const _wTotal = 108.0;
const _wDelete = 36.0;
const _gap = SizedBox(width: Space.xs + 2);

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final st = Theme.of(context).textTheme.labelSmall;
    Widget h(String t, {TextAlign align = TextAlign.start}) =>
        Text(t, style: st, textAlign: align);
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: Space.xs),
        child: Row(
          children: [
            const SizedBox(width: _wHandle),
            Expanded(flex: 3, child: h(l.colService)),
            _gap,
            Expanded(flex: 4, child: h(l.colDescription)),
            _gap,
            SizedBox(width: _wCycle, child: h(l.colCycle)),
            _gap,
            SizedBox(width: _wQty, child: h(l.colQty)),
            _gap,
            SizedBox(width: _wPrice, child: h(l.colUnitPrice)),
            _gap,
            SizedBox(
              width: _wTotal,
              child: h(l.colLineTotal, align: TextAlign.end),
            ),
            const SizedBox(width: _wDelete),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends ConsumerWidget {
  const _ItemRow({
    required this.index,
    required this.sectionId,
    required this.item,
    required this.currency,
    required this.autofocus,
    required this.isLast,
    required this.onEnterAtEnd,
    super.key,
  });

  final int index;
  final String sectionId;
  final LineItem item;
  final Currency currency;
  final bool autofocus;
  final bool isLast;
  final VoidCallback onEnterAtEnd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final ctl = ref.read(editorProvider.notifier);
    void set(LineItem Function(LineItem i) f) =>
        ctl.editItem(sectionId, item.id, f);

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.xs + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _wHandle,
            height: 40,
            child: ReorderableDragStartListener(
              index: index,
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: Tooltip(
                  message: l.dragToReorder,
                  child: Icon(
                    Icons.drag_indicator,
                    size: 18,
                    color: context.colors.muted,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _ServiceField(
              item: item,
              currency: currency,
              autofocus: autofocus,
              onChanged: (v) => set((i) => i.copyWith(service: v)),
              onPicked: (s) => set(
                (i) => i.copyWith(
                  service: s.item.service,
                  cycle: s.item.cycle,
                  description: i.description.isEmpty
                      ? s.item.description
                      : i.description,
                  unitPriceMinor: s.currency == currency
                      ? s.item.unitPriceMinor
                      : i.unitPriceMinor,
                ),
              ),
            ),
          ),
          _gap,
          Expanded(
            flex: 4,
            child: SyncedTextField(
              dense: true,
              hint: l.colDescription,
              value: item.description,
              textInputAction: TextInputAction.next,
              onChanged: (v) => set((i) => i.copyWith(description: v)),
            ),
          ),
          _gap,
          SizedBox(
            width: _wCycle,
            child: DropdownButtonFormField<BillingCycle>(
              key: ValueKey(item.cycle),
              initialValue: item.cycle,
              decoration: const InputDecoration(
                contentPadding: EdgeInsetsDirectional.symmetric(
                  horizontal: 8,
                  vertical: 9,
                ),
              ),
              items: [
                for (final c in BillingCycle.values)
                  DropdownMenuItem(
                    value: c,
                    child: Text(cycleLabel(context, c)),
                  ),
              ],
              onChanged: (c) {
                if (c != null) set((i) => i.copyWith(cycle: c));
              },
            ),
          ),
          _gap,
          SizedBox(
            width: _wQty,
            child: _NumberField(
              value: '${item.qty}',
              parse: parseIntInput,
              error: l.errQty,
              onValid: (v) => set((i) => i.copyWith(qty: v)),
            ),
          ),
          _gap,
          SizedBox(
            width: _wPrice,
            child: _NumberField(
              value: _rawMoney(item.unitPriceMinor),
              parse: parseMoneyInput,
              error: l.errAmount,
              formatOnBlur: (raw) {
                final m = parseMoneyInput(raw);
                return m == null ? raw : formatAmount(m, currency);
              },
              onValid: (v) => set((i) => i.copyWith(unitPriceMinor: v)),
              onSubmitted: isLast ? onEnterAtEnd : null,
            ),
          ),
          _gap,
          SizedBox(
            width: _wTotal,
            height: 40,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                formatAmount(item.lineMinor, currency),
                textDirection: TextDirection.ltr,
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          SizedBox(
            width: _wDelete,
            child: IconButton(
              tooltip: l.deleteItem,
              visualDensity: VisualDensity.compact,
              onPressed: () => ctl.removeItem(sectionId, item.id),
              icon: Icon(Icons.close, size: 18, color: context.colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Numeric cell: LTR, accepts Arabic-Indic digits, flags bad input inline.
class _NumberField extends StatefulWidget {
  const _NumberField({
    required this.value,
    required this.parse,
    required this.error,
    required this.onValid,
    this.formatOnBlur,
    this.onSubmitted,
  });

  final String value;
  final int? Function(String) parse;
  final String error;
  final ValueChanged<int> onValid;
  final String Function(String raw)? formatOnBlur;
  final VoidCallback? onSubmitted;

  @override
  State<_NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<_NumberField> {
  bool _bad = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _bad ? widget.error : '',
      child: SyncedTextField(
        dense: true,
        value: widget.value,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.end,
        formatOnBlur: _bad ? null : widget.formatOnBlur,
        errorText: _bad ? '' : null,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textInputAction: widget.onSubmitted == null
            ? TextInputAction.next
            : TextInputAction.done,
        onSubmitted: widget.onSubmitted == null
            ? null
            : (_) => widget.onSubmitted!(),
        onChanged: (v) {
          final parsed = widget.parse(v);
          if (_bad != (parsed == null)) setState(() => _bad = parsed == null);
          if (parsed != null) widget.onValid(parsed);
        },
      ),
    );
  }
}

class _ServiceField extends ConsumerStatefulWidget {
  const _ServiceField({
    required this.item,
    required this.currency,
    required this.autofocus,
    required this.onChanged,
    required this.onPicked,
  });

  final LineItem item;
  final Currency currency;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<ServiceSuggestion> onPicked;

  @override
  ConsumerState<_ServiceField> createState() => _ServiceFieldState();
}

class _ServiceFieldState extends ConsumerState<_ServiceField> {
  late final _controller = TextEditingController(text: widget.item.service);
  final _focus = FocusNode();

  @override
  void didUpdateWidget(_ServiceField old) {
    super.didUpdateWidget(old);
    if (!_focus.hasFocus && _controller.text != widget.item.service) {
      _controller.text = widget.item.service;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return RawAutocomplete<ServiceSuggestion>(
      textEditingController: _controller,
      focusNode: _focus,
      displayStringForOption: (s) => s.item.service,
      optionsBuilder: (value) {
        final q = foldForSearch(value.text.trim());
        if (q.isEmpty) return const [];
        return ref
            .read(serviceHistoryProvider)
            .where((s) {
              final f = foldForSearch(s.item.service);
              return f.contains(q) && f != q;
            })
            .take(6);
      },
      onSelected: (s) {
        widget.onPicked(s);
        _focus.nextFocus();
      },
      fieldViewBuilder: (context, controller, focus, onSubmit) => TextField(
        controller: controller,
        focusNode: focus,
        autofocus: widget.autofocus,
        textInputAction: TextInputAction.next,
        onChanged: widget.onChanged,
        onSubmitted: (_) => onSubmit(),
        decoration: InputDecoration(
          hintText: l.colService,
          isDense: true,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
        ),
      ),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: AlignmentDirectional.topStart,
        child: Material(
          elevation: 2,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Space.radiusSmall),
            side: BorderSide(color: context.colors.border),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360, maxHeight: 260),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: Space.xs),
              children: [
                for (final (i, s) in options.indexed)
                  Builder(
                    builder: (context) {
                      final highlighted =
                          AutocompleteHighlightedOption.of(context) == i;
                      return InkWell(
                        onTap: () => onSelected(s),
                        child: Container(
                          color: highlighted
                              ? theme.colorScheme.primaryContainer
                              : null,
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: Space.m - 4,
                            vertical: Space.s,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s.item.service,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(width: Space.s),
                              Text(
                                '${cycleLabel(context, s.item.cycle)} · ',
                                style: theme.textTheme.bodySmall,
                              ),
                              Text(
                                formatMoney(s.item.unitPriceMinor, s.currency),
                                textDirection: TextDirection.ltr,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
