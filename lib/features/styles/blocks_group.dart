import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/features/styles/inspector_controls.dart';
import 'package:invoice_desk/features/styles/style_inspector.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// The blocks a document always prints (what Blank keeps).
const Set<DocBlock> requiredBlocks = {
  DocBlock.header,
  DocBlock.items,
  DocBlock.totals,
};

/// Every block in display order: the printed ones in [DocumentStyle.blockOrder],
/// then the hidden ones in their default order.
List<DocBlock> allBlocksInOrder(DocumentStyle s) => [
  ...s.blockOrder,
  for (final b in DocumentStyle.defaultBlockOrder)
    if (!s.blockOrder.contains(b)) b,
];

/// Whether [b] prints. Notes need both the block and the notes toggle.
bool blockShown(DocumentStyle s, DocBlock b) =>
    s.blockOrder.contains(b) && (b != DocBlock.notes || s.showNotes);

/// [s] with [b] printed or hidden, keeping the order of the others. The
/// notes toggle follows the notes block so the two never disagree.
DocumentStyle withBlock(DocumentStyle s, DocBlock b, {required bool shown}) {
  if (requiredBlocks.contains(b)) return s;
  final order = [
    for (final x in allBlocksInOrder(s))
      if (x == b ? shown : s.blockOrder.contains(x)) x,
  ];
  return s.copyWith(
    blockOrder: order,
    showNotes: b == DocBlock.notes ? shown : s.showNotes,
  );
}

/// [s] with the block at [from] (in [allBlocksInOrder]) moved to [to],
/// where [to] is the final index (`onReorderItem`'s convention).
DocumentStyle withBlockMoved(DocumentStyle s, int from, int to) {
  final all = allBlocksInOrder(s);
  final moved = all.removeAt(from);
  all.insert(to.clamp(0, all.length), moved);
  return s.copyWith(
    blockOrder: [
      for (final x in all)
        if (s.blockOrder.contains(x)) x,
    ],
  );
}

class BlocksGroup extends ConsumerWidget {
  const BlocksGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    final all = allBlocksInOrder(s);
    return PanelCard(
      title: l.styleGroupBlocks,
      icon: Icons.view_agenda_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.blocksHint, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: Space.xs),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            buildDefaultDragHandles: false,
            onReorderItem: (from, to) {
              edit?.call((x) => withBlockMoved(x, from, to));
            },
            children: [
              for (final (i, b) in all.indexed)
                _BlockTile(
                  key: ValueKey('block-${b.name}'),
                  block: b,
                  index: i,
                  shown: blockShown(s, b),
                  onChanged: edit == null || requiredBlocks.contains(b)
                      ? null
                      : (v) => edit((x) => withBlock(x, b, shown: v)),
                ),
            ],
          ),
          _BlockToggles(style: s, edit: edit),
        ],
      ),
    );
  }
}

class _BlockTile extends StatelessWidget {
  const _BlockTile({
    required this.block,
    required this.index,
    required this.shown,
    required this.onChanged,
    super.key,
  });

  final DocBlock block;
  final int index;
  final bool shown;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final name = switch (block) {
      DocBlock.header => l.blockHeader,
      DocBlock.parties => l.blockParties,
      DocBlock.items => l.blockItems,
      DocBlock.totals => l.blockTotals,
      DocBlock.notes => l.blockNotes,
      DocBlock.footer => l.blockFooter,
    };
    final change = onChanged;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: shown,
        onChanged: change == null ? null : (v) => change(v ?? false),
      ),
      title: Text(name),
      subtitle: requiredBlocks.contains(block) ? Text(l.blockRequired) : null,
      trailing: ReorderableDragStartListener(
        index: index,
        child: const Icon(Icons.drag_handle),
      ),
    );
  }
}

class _BlockToggles extends StatelessWidget {
  const _BlockToggles({required this.style, required this.edit});
  final DocumentStyle style;
  final StyleEdit? edit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = style;
    final e = edit;
    return Column(
      children: [
        ToggleRow(
          label: l.showPaymentCard,
          value: s.showPaymentCard,
          onChanged: e == null
              ? null
              : (v) => e((x) => x.copyWith(showPaymentCard: v)),
        ),
        ToggleRow(
          label: l.showPleaseQuote,
          value: s.showPleaseQuote,
          onChanged: e == null
              ? null
              : (v) => e((x) => x.copyWith(showPleaseQuote: v)),
        ),
        ToggleRow(
          label: l.showPageNumbers,
          value: s.showPageNumbers,
          onChanged: e == null
              ? null
              : (v) => e((x) => x.copyWith(showPageNumbers: v)),
        ),
        ToggleRow(
          label: l.showSignatureBoxes,
          value: s.showSignatureBoxes,
          onChanged: e == null
              ? null
              : (v) => e((x) => x.copyWith(showSignatureBoxes: v)),
        ),
      ],
    );
  }
}
