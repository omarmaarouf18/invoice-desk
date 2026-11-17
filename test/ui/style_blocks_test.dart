import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/styles/blocks_group.dart';

void main() {
  final blank = DocPreset.blank.style;

  test('hidden blocks follow the printed ones in the list', () {
    expect(allBlocksInOrder(blank), [
      DocBlock.header,
      DocBlock.parties,
      DocBlock.items,
      DocBlock.totals,
      DocBlock.notes,
      DocBlock.footer,
    ]);
  });

  test('showing notes adds the block and the toggle together', () {
    final s = withBlock(blank, DocBlock.notes, shown: true);
    expect(s.blockOrder.last, DocBlock.notes);
    expect(s.showNotes, isTrue);
    expect(blockShown(s, DocBlock.notes), isTrue);
    final off = withBlock(s, DocBlock.notes, shown: false);
    expect(off.blockOrder, blank.blockOrder);
    expect(off.showNotes, isFalse);
  });

  test('required blocks cannot be hidden', () {
    for (final b in requiredBlocks) {
      expect(withBlock(blank, b, shown: false), blank);
    }
  });

  test('moving reorders only the printed blocks', () {
    // Parties (index 1) to the end of the list (final index 5).
    final s = withBlockMoved(blank, 1, 5);
    expect(s.blockOrder, [
      DocBlock.header,
      DocBlock.items,
      DocBlock.totals,
      DocBlock.parties,
    ]);
    // Moving a hidden block changes nothing printed.
    expect(withBlockMoved(blank, 5, 0).blockOrder, blank.blockOrder);
  });
}
