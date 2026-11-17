part of '../contract_cards.dart';

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
    ref.listen(contractProvider.select((s) => s.focusTick), (_, _) {
      final name = ref.read(contractProvider).focusVariable;
      if (name != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _jump(name));
      }
    });
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final resolver = ref.watch(openResolverProvider);
    final used = usedVariables(c);
    final custom = used.where((v) => !isBuiltInVariable(v)).toList();
    final builtInMissing = [
      for (final v in used)
        if (isBuiltInVariable(v) && resolver?.resolve(v) == null) v,
    ];
    return PanelCard(
      title: l.cardVariables,
      icon: Icons.data_object,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The help text lives in the card, not in its header: in
          // English it is a full sentence and would not fit there.
          Text(
            l.variablesHelp,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: Space.s),
          if (custom.isEmpty)
            Text(
              l.noCustomVariables,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          for (final v in custom)
            _CustomVariableRow(
              key: _key(v),
              name: v,
              value: c.vars[v] ?? '',
              missing: resolver?.resolve(v) == null,
              locked: c.isLocked,
              focusNode: _node(v),
            ),
          for (final v in builtInMissing)
            _BuiltInMissingRow(
              key: _key(v),
              name: v,
              clientId: c.clientId,
              focusNode: _node(v),
            ),
        ],
      ),
    );
  }
}

/// The variable's name, right-aligned in a fixed column, amber if missing.
class _VariableName extends StatelessWidget {
  const _VariableName(this.name, {required this.missing});
  final String name;
  final bool missing;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 200,
    child: Text(
      name,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: missing
            ? missingColors(context).fg
            : Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

/// A per-contract variable with its value field.
class _CustomVariableRow extends ConsumerWidget {
  const _CustomVariableRow({
    required this.name,
    required this.value,
    required this.missing,
    required this.locked,
    required this.focusNode,
    super.key,
  });

  final String name;
  final String value;
  final bool missing;
  final bool locked;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsetsDirectional.only(bottom: Space.s),
    child: Row(
      children: [
        _VariableName(name, missing: missing),
        const SizedBox(width: Space.m - 4),
        Expanded(
          child: SyncedTextField(
            key: ValueKey('var-$name'),
            value: value,
            focusNode: focusNode,
            readOnly: locked,
            dense: true,
            hint: '{{$name}}',
            errorText: missing ? '' : null,
            onChanged: (x) => _ctl(ref).setVariable(name, x),
          ),
        ),
      ],
    ),
  );
}

/// A missing built-in (client, settings or contract data) with a shortcut
/// to where it is filled in.
class _BuiltInMissingRow extends ConsumerWidget {
  const _BuiltInMissingRow({
    required this.name,
    required this.clientId,
    required this.focusNode,
    super.key,
  });

  final String name;
  final String clientId;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final amber = missingColors(context);
    final source = name.startsWith('client.')
        ? l.sourceClient
        : name.startsWith('provider.')
        ? l.sourceSettings
        : l.sourceContract;
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: Space.s),
      child: Row(
        children: [
          _VariableName(name, missing: true),
          const SizedBox(width: Space.m - 4),
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: Space.s + 4,
                vertical: Space.s,
              ),
              decoration: BoxDecoration(
                color: amber.bg,
                borderRadius: BorderRadius.circular(Space.radiusSmall),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l.builtInMissing(source),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: amber.fg),
                    ),
                  ),
                  _FixButton(name: name, clientId: clientId, focus: focusNode),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FixButton extends ConsumerWidget {
  const _FixButton({
    required this.name,
    required this.clientId,
    required this.focus,
  });

  final String name;
  final String clientId;
  final FocusNode focus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final client = (ref.watch(clientsProvider).value ?? const <Client>[])
        .where((x) => x.id == clientId)
        .firstOrNull;
    if (name.startsWith('client.') && client != null) {
      return TextButton(
        focusNode: focus,
        onPressed: () => unawaited(AppActions(ref, context).editClient(client)),
        child: Text(l.editClientData),
      );
    }
    if (name.startsWith('provider.')) {
      return TextButton(
        focusNode: focus,
        onPressed: () => openSettings(ref, SettingsSection.contracts),
        child: Text(l.openSettings),
      );
    }
    return Focus(focusNode: focus, child: const SizedBox());
  }
}
