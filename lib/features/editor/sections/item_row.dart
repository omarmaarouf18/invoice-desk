part of '../sections_editor.dart';

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
    final ctl = ref.read(editorProvider.notifier);
    void set(LineItem Function(LineItem i) f) =>
        ctl.editItem(sectionId, item.id, f);

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.xs + 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DragHandle(
            index: index,
          ),
          _ServiceCell(
            item: item,
            currency: currency,
            autofocus: autofocus,
            set: set,
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
          _CycleCell(
            item: item,
            set: set,
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
          _LineTotal(
            item: item,
            currency: currency,
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

/// Grab handle that reorders the row.
class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SizedBox(
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
    );
  }
}

/// Billing cycle (مرة واحدة / شهري / سنوي).
class _CycleCell extends StatelessWidget {
  const _CycleCell({required this.item, required this.set});
  final LineItem item;
  final void Function(LineItem Function(LineItem i) f) set;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

/// qty × unit price, read-only.
class _LineTotal extends StatelessWidget {
  const _LineTotal({required this.item, required this.currency});
  final LineItem item;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
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
    );
  }
}

/// Service with suggestions; picking one fills cycle, description and
/// (same currency only) the price.
class _ServiceCell extends StatelessWidget {
  const _ServiceCell({
    required this.item,
    required this.currency,
    required this.autofocus,
    required this.set,
  });
  final LineItem item;
  final Currency currency;
  final bool autofocus;
  final void Function(LineItem Function(LineItem i) f) set;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
