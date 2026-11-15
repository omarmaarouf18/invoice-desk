part of '../sidebar.dart';

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  final _c = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _c.dispose();
    super.dispose();
  }

  void _changed(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      if (mounted) ref.read(searchQueryProvider.notifier).set(v);
    });
    setState(() {});
  }

  void _clear() {
    _debounce?.cancel();
    _c.clear();
    ref.read(searchQueryProvider.notifier).set('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Cleared from elsewhere (e.g. the "no results" button).
    ref.listen(searchQueryProvider, (_, q) {
      if (q.isEmpty && _c.text.isNotEmpty) _c.clear();
    });
    final l = context.l10n;
    final focus = ref.watch(searchFocusProvider);
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _clear},
      child: TextField(
        controller: _c,
        focusNode: focus,
        onChanged: _changed,
        decoration: InputDecoration(
          hintText: l.searchHint,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _c.text.isEmpty
              ? const Padding(
                  padding: EdgeInsetsDirectional.only(end: Space.s),
                  child: Center(
                    widthFactor: 1,
                    child: _KeyHint(label: 'Ctrl K'),
                  ),
                )
              : IconButton(
                  tooltip: '${l.clearSearch} (Esc)',
                  onPressed: _clear,
                  icon: const Icon(Icons.close, size: 18),
                ),
        ),
      ),
    );
  }
}

class _KeyHint extends StatelessWidget {
  const _KeyHint({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 6,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    ),
  );
}
