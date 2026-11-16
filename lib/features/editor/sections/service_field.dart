part of '../sections_editor.dart';

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
      fieldViewBuilder: (context, controller, focus, onSubmit) =>
          ContentTextField(
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
                  _SuggestionTile(
                    i: i,
                    s: s,
                    onSelected: onSelected,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One remembered service: name, cycle and last price.
class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.i,
    required this.s,
    required this.onSelected,
  });
  final int i;
  final ServiceSuggestion s;
  final AutocompleteOnSelected<ServiceSuggestion> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(
      builder: (context) {
        final highlighted = AutocompleteHighlightedOption.of(context) == i;
        return InkWell(
          onTap: () => onSelected(s),
          child: Container(
            color: highlighted ? theme.colorScheme.primaryContainer : null,
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
    );
  }
}
