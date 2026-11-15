part of '../sidebar.dart';

class _ClientList extends ConsumerWidget {
  const _ClientList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (ref.watch(sidebarFilterProvider) == SidebarFilter.trash) {
      return const TrashList();
    }
    final data = ref.watch(sidebarDataProvider);
    final query = ref.watch(searchQueryProvider);
    return switch (data) {
      AsyncData(:final value) when value.groups.isEmpty => _EmptyList(
        query: query,
      ),
      AsyncData(:final value) => Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsetsDirectional.only(
            top: Space.xs,
            bottom: Space.l,
          ),
          itemCount: value.groups.length,
          itemBuilder: (context, i) => _ClientGroupTile(
            key: ValueKey(value.groups[i].client.id),
            group: value.groups[i],
            query: query,
          ),
        ),
      ),
      AsyncError() => Center(child: Text(l.dbErrorTitle)),
      _ => const Center(
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    };
  }
}

class _EmptyList extends ConsumerWidget {
  const _EmptyList({required this.query});
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final hasQuery = query.trim().isNotEmpty;
    final filtered = ref.watch(sidebarFilterProvider) != SidebarFilter.all;
    return Padding(
      padding: const EdgeInsets.all(Space.l),
      child: Column(
        children: [
          const SizedBox(height: Space.l),
          Icon(
            hasQuery ? Icons.search_off : Icons.inbox_outlined,
            size: 32,
            color: context.colors.muted,
          ),
          const SizedBox(height: Space.s),
          Text(
            hasQuery
                ? l.noResults(query.trim())
                : (filtered ? l.noInvoicesForClient : l.noClientsYet),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.colors.muted,
            ),
            textAlign: TextAlign.center,
          ),
          if (hasQuery || filtered) ...[
            const SizedBox(height: Space.s),
            TextButton(
              onPressed: () {
                ref.read(searchQueryProvider.notifier).set('');
                ref.read(sidebarFilterProvider.notifier).set(SidebarFilter.all);
              },
              child: Text(l.clearSearch),
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> _menu(
  BuildContext context,
  Offset position,
  List<(String, IconData, VoidCallback)> items,
) async {
  final overlay = Overlay.of(context).context.findRenderObject()! as RenderBox;
  final selected = await showMenu<int>(
    context: context,
    position: RelativeRect.fromRect(
      position & const Size(1, 1),
      Offset.zero & overlay.size,
    ),
    items: [
      for (final (i, (label, icon, _)) in items.indexed)
        PopupMenuItem(
          value: i,
          height: 36,
          child: Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: Space.s + 4),
              Text(label),
            ],
          ),
        ),
    ],
  );
  if (selected != null) items[selected].$3();
}
