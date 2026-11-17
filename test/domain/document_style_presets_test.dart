import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';

void main() {
  group('DocPreset', () {
    test('defines 5 distinct presets with unique stable IDs', () {
      expect(DocPreset.values, hasLength(5));
      final ids = DocPreset.values.map((p) => p.id).toSet();
      expect(ids, hasLength(5));
      expect(
        ids,
        containsAll([
          'preset_classic',
          'preset_modern',
          'preset_minimal',
          'preset_bold',
          'preset_blank',
        ]),
      );
    });

    test('fromId resolves known IDs and falls back to classic', () {
      expect(DocPreset.fromId('preset_classic'), DocPreset.classic);
      expect(DocPreset.fromId('preset_modern'), DocPreset.modern);
      expect(DocPreset.fromId('preset_minimal'), DocPreset.minimal);
      expect(DocPreset.fromId('preset_bold'), DocPreset.bold);
      expect(DocPreset.fromId('preset_blank'), DocPreset.blank);
      expect(DocPreset.fromId('modern'), DocPreset.modern);
      expect(DocPreset.fromId('unknown'), DocPreset.classic);
      expect(DocPreset.fromId(null), DocPreset.classic);
    });

    test('blank preset has only essential blocks and toggles disabled', () {
      final blank = DocPreset.blank.style;
      expect(blank.blockOrder, [
        DocBlock.header,
        DocBlock.parties,
        DocBlock.items,
        DocBlock.totals,
      ]);
      expect(blank.showRole, isFalse);
      expect(blank.showCity, isFalse);
      expect(blank.showContacts, isFalse);
      expect(blank.showNotes, isFalse);
      expect(blank.showPaymentCard, isFalse);
      expect(blank.showPaidStamp, isTrue);
    });

    test('modern preset uses Noto Naskh Arabic font', () {
      expect(DocPreset.modern.style.fontFamily, DocFontFamily.notoNaskhArabic);
      expect(DocPreset.modern.style.tableStyle, TableStyle.striped);
      expect(DocPreset.modern.style.totalsStyle, TotalsStyle.solid);
    });

    test(
      'minimal and bold are clearly distinct in colors and table styles',
      () {
        expect(DocPreset.minimal.style.tableStyle, TableStyle.plain);
        expect(DocPreset.minimal.style.headerStyle, HeaderStyle.none);

        expect(DocPreset.bold.style.tableStyle, TableStyle.bordered);
        expect(DocPreset.bold.style.headerStyle, HeaderStyle.band);
        expect(DocPreset.bold.style.primary, 0xFF991B1B);
      },
    );
  });
}
