import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';

void main() {
  group('DocPreset', () {
    test('defines 6 distinct presets with unique stable IDs', () {
      expect(DocPreset.values, hasLength(6));
      final ids = DocPreset.values.map((p) => p.id).toSet();
      expect(ids, hasLength(6));
      expect(
        ids,
        containsAll([
          'preset_classic',
          'preset_modern',
          'preset_minimal',
          'preset_bold',
          'preset_formal',
          'preset_blank',
        ]),
      );
    });

    test('fromId resolves known IDs and falls back to classic', () {
      expect(DocPreset.fromId('preset_classic'), DocPreset.classic);
      expect(DocPreset.fromId('preset_modern'), DocPreset.modern);
      expect(DocPreset.fromId('preset_minimal'), DocPreset.minimal);
      expect(DocPreset.fromId('preset_bold'), DocPreset.bold);
      expect(DocPreset.fromId('preset_formal'), DocPreset.formal);
      expect(DocPreset.fromId('preset_blank'), DocPreset.blank);
      expect(DocPreset.fromId('modern'), DocPreset.modern);
      expect(DocPreset.fromId('formal'), DocPreset.formal);
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

    test('modern preset uses modern IBM Plex Sans Arabic font', () {
      expect(
        DocPreset.modern.style.fontFamily,
        DocFontFamily.ibmPlexSansArabic,
      );
      expect(DocPreset.modern.style.tableStyle, TableStyle.striped);
      expect(DocPreset.modern.style.totalsStyle, TotalsStyle.solid);
    });

    test(
      'bold preset uses IBM Plex Sans Arabic font and framed bordered table',
      () {
        expect(
          DocPreset.bold.style.fontFamily,
          DocFontFamily.ibmPlexSansArabic,
        );
        expect(DocPreset.bold.style.tableStyle, TableStyle.bordered);
        expect(DocPreset.bold.style.headerStyle, HeaderStyle.band);
        expect(DocPreset.bold.style.primary, 0xFF991B1B);
      },
    );

    test(
      'formal preset uses classical Noto Naskh Arabic font with navy rule layout',
      () {
        expect(
          DocPreset.formal.style.fontFamily,
          DocFontFamily.notoNaskhArabic,
        );
        expect(DocPreset.formal.style.primary, 0xFF1E3A5F);
        expect(DocPreset.formal.style.headerStyle, HeaderStyle.rule);
        expect(DocPreset.formal.style.tableStyle, TableStyle.plain);
        expect(DocPreset.formal.style.totalsStyle, TotalsStyle.outlined);
      },
    );

    test(
      'minimal has pure white surface, light totals style, muted text with sufficient contrast, and no header rule',
      () {
        expect(DocPreset.minimal.style.tableStyle, TableStyle.plain);
        expect(DocPreset.minimal.style.headerStyle, HeaderStyle.none);
        expect(DocPreset.minimal.style.totalsStyle, TotalsStyle.plain);
        expect(DocPreset.minimal.style.surface, 0xFFFFFFFF);
        expect(DocPreset.minimal.style.muted, 0xFF6B7280);
      },
    );
  });
}
