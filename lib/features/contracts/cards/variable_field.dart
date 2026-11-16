part of '../contract_cards.dart';

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
        ContentTextField(
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
