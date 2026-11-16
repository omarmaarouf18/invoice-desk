import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/pdf_golden.dart';

void main() {
  final fonts = loadPdfFonts();

  /// Inflated content streams, where the drawing operators live.
  String operators(List<int> bytes) {
    final raw = latin1.decode(bytes);
    final out = StringBuffer();
    for (final m in RegExp(
      r'stream\r?\n(.*?)\r?\nendstream',
      dotAll: true,
    ).allMatches(raw)) {
      try {
        out.writeln(latin1.decode(zlib.decode(latin1.encode(m.group(1)!))));
      } on FormatException {
        // not a deflate stream
      }
    }
    return out.toString();
  }

  /// Renders [c]; returns (pages, pages that got a footer, operators).
  Future<(int, Set<int>, String)> render(Contract c) async {
    final footers = <int>{};
    final doc = buildContractDocument(
      ContractPdfData(contract: c, client: acme, settings: sampleSettings),
      fonts,
      onFooter: (page, _) => footers.add(page),
    );
    final bytes = await doc.save();
    return (doc.document.pdfPageList.pages.length, footers, operators(bytes));
  }

  test('sample contract (written to docs/ when SAMPLE_PDF is set)', () async {
    final bytes = await buildContractPdf(
      ContractPdfData(
        contract: acmeContract(),
        client: acme,
        settings: sampleSettings,
      ),
      fonts,
    );
    const out = String.fromEnvironment('SAMPLE_PDF');
    if (out.isNotEmpty) File(out).writeAsBytesSync(bytes);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  test(
    'template A with optional clauses off and on; footer on every page',
    () async {
      final (off, offFooters, _) = await render(acmeContract());
      final (on, onFooters, _) = await render(acmeContract(optionalOn: true));
      // Clauses, then annex 1, then annex 2 + signatures, each on new pages.
      expect(off, 4);
      expect(on, greaterThanOrEqualTo(off));
      expect(offFooters, {for (var p = 1; p <= off; p++) p});
      expect(onFooters, {for (var p = 1; p <= on; p++) p});
    },
  );

  test(
    'unresolved variables are highlighted amber; resolved ones are not',
    () async {
      // 0xFFE8A3 → "1 0.9098 0.63922 rg" as a fill colour.
      final amber = RegExp(r'\b1 0\.9098\d* 0\.6392\d* rg');
      final (_, _, clean) = await render(acmeContract());
      expect(amber.hasMatch(clean), isFalse);
      final missing = acmeContract().copyWith(vars: const {});
      final (_, _, marked) = await render(missing);
      expect(amber.hasMatch(marked), isTrue);
    },
  );

  test('drafts get the "مسودة" watermark', () async {
    // The watermark is the only thing drawn in pale teal 0xE4F1EF.
    final pale = RegExp(r'0\.89412 0\.9451 0\.93725 rg');
    final (_, _, sent) = await render(acmeContract());
    final (draftPages, _, draft) = await render(
      acmeContract(status: ContractStatus.draft),
    );
    expect(pale.allMatches(draft).length, draftPages);
    expect(pale.hasMatch(sent), isFalse);
  });

  test('no page ends with a clause heading', () async {
    // Body text is 10.5 pt, clause headings 12 pt, the footer under 9 pt.
    // Shifting the preamble moves every page break, so headings land at
    // many different page ends.
    final base = acmeContract(optionalOn: true);
    for (var extra = 0; extra < 12; extra++) {
      final c = base.copyWith(
        preamble:
            '${base.preamble}${' وذلك وفقًا لما يلي من بنود.' * (extra * 3)}',
      );
      final bytes = await buildContractPdf(
        ContractPdfData(contract: c, client: acme, settings: sampleSettings),
        fonts,
      );
      final pages = pdfContentDump(bytes).split('%% content stream').skip(1);
      for (final (i, page) in pages.indexed) {
        final sizes = [
          for (final m in RegExp(r'/F\d+ ([\d.]+) Tf').allMatches(page))
            double.parse(m[1]!),
        ].where((s) => s >= 9).toList();
        if (sizes.isEmpty) continue;
        expect(
          sizes.last,
          isNot(12),
          reason: 'variant $extra: page ${i + 1} ends with a heading',
        );
      }
    }
  });
}
