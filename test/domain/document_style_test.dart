import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/document_style.dart';

void main() {
  group('DocumentStyle value object', () {
    test('default constructor provides expected defaults', () {
      const style = DocumentStyle();
      expect(style.primary, 0xFF0F766E);
      expect(style.accent, 0xFF0F766E);
      expect(style.ink, 0xFF0F1B2D);
      expect(style.fontFamily, DocFontFamily.ibmPlexSansArabic);
      expect(style.baseSize, 9.5);
      expect(style.scale, 1.0);
      expect(style.paper, DocPaper.a4);
      expect(style.headerStyle, HeaderStyle.rule);
      expect(style.logoAssetId, isNull);
      expect(style.showRole, isTrue);
      expect(style.blockOrder, DocumentStyle.defaultBlockOrder);
    });

    test('toJson and fromJson round-trip faithfully', () {
      const original = DocumentStyle(
        primary: 0xFF1E3A8A,
        accent: 0xFF3B82F6,
        ink: 0xFF111827,
        muted: 0xFF6B7280,
        surface: 0xFFF9FAFB,
        tableHeaderBg: 0xFFEFF6FF,
        border: 0xFFE5E7EB,
        fontFamily: DocFontFamily.notoNaskhArabic,
        baseSize: 10,
        scale: 1.1,
        paper: DocPaper.letter,
        marginHorizontal: 36,
        marginTop: 30,
        marginBottom: 24,
        headerStyle: HeaderStyle.band,
        logoAssetId: 'a1b2c3d4e5f6',
        logoSize: 64,
        logoPosition: LogoPosition.end,
        tableStyle: TableStyle.striped,
        totalsStyle: TotalsStyle.solid,
        showRole: false,
        showContacts: false,
        showNotes: false,
        showVatRow: false,
        showPageNumbers: false,
        showPaidStamp: false,
        blockOrder: [
          DocBlock.header,
          DocBlock.items,
          DocBlock.totals,
          DocBlock.parties,
          DocBlock.notes,
          DocBlock.footer,
        ],
        footerTextAr: 'شكراً لتعاملكم معنا',
        footerTextEn: 'Thank you for your business',
      );

      final json = original.toJson();
      final restored = DocumentStyle.fromJson(json);

      expect(restored, equals(original));
      expect(restored.hashCode, equals(original.hashCode));
      expect(restored.primary, 0xFF1E3A8A);
      expect(restored.fontFamily, DocFontFamily.notoNaskhArabic);
      expect(restored.logoAssetId, 'a1b2c3d4e5f6');
      expect(restored.blockOrder[1], DocBlock.items);
    });

    test('fromRawJson round-trips through string', () {
      const style = DocumentStyle(
        primary: 0xFF2563EB,
        fontFamily: DocFontFamily.notoNaskhArabic,
        logoAssetId: 'hash123',
      );
      final raw = style.toRawJson();
      final restored = DocumentStyle.fromRawJson(raw);
      expect(restored, equals(style));
    });

    test('copyWith updates fields and clears logo', () {
      const style = DocumentStyle(logoAssetId: 'logo_old');
      final updated = style.copyWith(
        primary: 0xFFDC2626,
        clearLogoAssetId: true,
        fontFamily: DocFontFamily.notoNaskhArabic,
      );

      expect(updated.primary, 0xFFDC2626);
      expect(updated.logoAssetId, isNull);
      expect(updated.fontFamily, DocFontFamily.notoNaskhArabic);
      expect(updated.baseSize, style.baseSize);
    });

    group('fuzz & robustness', () {
      test('garbage or malformed JSON never throws', () {
        expect(DocumentStyle.fromRawJson(''), equals(const DocumentStyle()));
        expect(
          DocumentStyle.fromRawJson('{invalid: json'),
          equals(const DocumentStyle()),
        );
        expect(DocumentStyle.fromRawJson('[]'), equals(const DocumentStyle()));
        expect(
          DocumentStyle.fromRawJson('12345'),
          equals(const DocumentStyle()),
        );
        expect(
          DocumentStyle.fromRawJson('null'),
          equals(const DocumentStyle()),
        );
      });

      test('out-of-bounds numbers are clamped to valid ranges', () {
        final clamped = DocumentStyle.fromJson(const {
          'baseSize': 999.0,
          'scale': 0.01,
          'marginHorizontal': -50.0,
          'marginTop': 500.0,
          'marginBottom': double.nan,
          'logoSize': double.infinity,
        });

        expect(clamped.baseSize, 14.0);
        expect(clamped.scale, 0.8);
        expect(clamped.marginHorizontal, 15.0);
        expect(clamped.marginTop, 80.0);
        expect(clamped.marginBottom, 26.0); // NaN falls back to default
        expect(clamped.logoSize, 48.0); // Infinity falls back to default
      });

      test('invalid color values fall back cleanly', () {
        final parsed = DocumentStyle.fromJson(const {
          'primary': 'not-a-color',
          'accent': '#123',
          'ink': 12345,
          'muted': '#AABBCC',
        });

        expect(parsed.primary, 0xFF0F766E); // Default
        expect(parsed.accent, 0xFF0F766E); // Default
        expect(parsed.ink, 12345 | 0xFF000000); // Int with alpha
        expect(parsed.muted, 0xFFAABBCC); // Valid 6-hex
      });

      test('unknown enum values fall back safely', () {
        final parsed = DocumentStyle.fromJson(const {
          'fontFamily': 'unknown_font',
          'paper': 'legal',
          'headerStyle': 'diagonal',
          'logoPosition': 'floating',
          'tableStyle': 'dots',
          'totalsStyle': 'neon',
        });

        expect(parsed.fontFamily, DocFontFamily.ibmPlexSansArabic);
        expect(parsed.paper, DocPaper.a4);
        expect(parsed.headerStyle, HeaderStyle.rule);
        expect(parsed.logoPosition, LogoPosition.start);
        expect(parsed.tableStyle, TableStyle.plain);
        expect(parsed.totalsStyle, TotalsStyle.outlined);
      });

      test('corrupted blockOrder sanitizes duplicates and invalid entries', () {
        final parsed = DocumentStyle.fromJson(const {
          'blockOrder': ['header', 'invalid', 'header', 'totals', 123, 'notes'],
        });

        expect(parsed.blockOrder, [
          DocBlock.header,
          DocBlock.totals,
          DocBlock.notes,
        ]);

        final emptyBlocks = DocumentStyle.fromJson(const {
          'blockOrder': ['unknown', 'bogus'],
        });
        expect(emptyBlocks.blockOrder, DocumentStyle.defaultBlockOrder);
      });

      test('random fuzz map never throws', () {
        final rng = Random(42);
        for (var i = 0; i < 200; i++) {
          final map = <String, dynamic>{
            'primary': rng.nextBool()
                ? rng.nextInt(0xFFFFFF)
                : 'rnd_${rng.nextInt(100)}',
            'baseSize': rng.nextDouble() * 100 - 50,
            'scale': rng.nextDouble() * 10,
            'paper': 'paper_${rng.nextInt(5)}',
            'headerStyle': 'hdr_${rng.nextInt(5)}',
            'blockOrder': [
              for (var j = 0; j < rng.nextInt(10); j++)
                'blk_${rng.nextInt(10)}',
            ],
            'logoSize': rng.nextBool() ? double.nan : rng.nextDouble() * 200,
          };
          expect(() => DocumentStyle.fromJson(map), returnsNormally);
        }
      });
    });
  });
}
