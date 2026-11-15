part of '../sections_editor.dart';

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
            _SectionHeader(
              section: section,
              index: widget.index,
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
            _SectionFooter(
              section: section,
              onAdd: () => _addAfter(section.items.lastOrNull?.id),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section number, bilingual title, currency and delete.
class _SectionHeader extends ConsumerWidget {
  const _SectionHeader({required this.section, required this.index});
  final InvoiceSection section;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctl = ref.read(editorProvider.notifier);
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 10,
            end: Space.s,
          ),
          child: Text(
            '$index',
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
    );
  }
}

/// "+ بند" and the section subtotal.
class _SectionFooter extends StatelessWidget {
  const _SectionFooter({required this.section, required this.onAdd});
  final InvoiceSection section;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 18),
          label: Text(l.addItem),
        ),
        const Spacer(),
        Text(
          l.subtotal,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.muted,
          ),
        ),
        const SizedBox(width: Space.m),
        Text(
          section.subtotal.format(),
          textDirection: TextDirection.ltr,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(width: Space.s),
      ],
    );
  }
}
