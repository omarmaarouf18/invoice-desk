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
    final theme = Theme.of(context);
    ref.listen(contractProvider.select((s) => s.focusTick), (_, _) {
      final name = ref.read(contractProvider).focusVariable;
      if (name != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _jump(name));
      }
    });
    final c = ref.watch(contractProvider.select((s) => s.contract))!;
    final resolver = ref.watch(openResolverProvider);
    final locked = c.isLocked;
    final used = usedVariables(c);
    final custom = used.where((v) => !isBuiltInVariable(v)).toList();
    final builtInMissing = [
      for (final v in used)
        if (isBuiltInVariable(v) && resolver?.resolve(v) == null) v,
    ];
    final amber = missingColors(context);
    final client = (ref.watch(clientsProvider).value ?? const <Client>[])
        .where((x) => x.id == c.clientId)
        .firstOrNull;

    String source(String v) => v.startsWith('client.')
        ? l.sourceClient
        : v.startsWith('provider.')
        ? l.sourceSettings
        : l.sourceContract;

    return PanelCard(
      title: l.cardVariables,
      icon: Icons.data_object,
      trailing: Text(
        l.variablesHelp,
        style: theme.textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (custom.isEmpty)
            Text(l.noCustomVariables, style: theme.textTheme.bodySmall),
          for (final v in custom)
            Padding(
              key: _key(v),
              padding: const EdgeInsetsDirectional.only(bottom: Space.s),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      v,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: resolver?.resolve(v) == null
                            ? amber.fg
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.m - 4),
                  Expanded(
                    child: SyncedTextField(
                      key: ValueKey('var-$v'),
                      value: c.vars[v] ?? '',
                      focusNode: _node(v),
                      readOnly: locked,
                      dense: true,
                      hint: '{{$v}}',
                      errorText: resolver?.resolve(v) == null ? '' : null,
                      onChanged: (x) => _ctl(ref).setVariable(v, x),
                    ),
                  ),
                ],
              ),
            ),
          for (final v in builtInMissing)
            Padding(
              key: _key(v),
              padding: const EdgeInsetsDirectional.only(bottom: Space.s),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      v,
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: amber.fg,
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.m - 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: Space.s + 4,
                        vertical: Space.s,
                      ),
                      decoration: BoxDecoration(
                        color: amber.bg,
                        borderRadius: BorderRadius.circular(
                          Space.radiusSmall,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.builtInMissing(source(v)),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: amber.fg,
                              ),
                            ),
                          ),
                          if (v.startsWith('client.') && client != null)
                            TextButton(
                              focusNode: _node(v),
                              onPressed: () => unawaited(
                                AppActions(ref, context).editClient(client),
                              ),
                              child: Text(l.editClientData),
                            )
                          else if (v.startsWith('provider.'))
                            TextButton(
                              focusNode: _node(v),
                              onPressed: () => ref
                                  .read(workspaceProvider.notifier)
                                  .show(Workspace.settings),
                              child: Text(l.openSettings),
                            )
                          else
                            Focus(focusNode: _node(v), child: const SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
