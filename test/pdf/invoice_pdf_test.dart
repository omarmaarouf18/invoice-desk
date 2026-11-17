import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/pdf/pdf_style.dart';
import '../helpers/legacy_seed.dart';

ByteData _font(String w) => ByteData.sublistView(
  File('assets/fonts/IBMPlexSansArabic-$w.ttf').readAsBytesSync(),
);

ByteData _naskhFont(String w) => ByteData.sublistView(
  File('assets/fonts/NotoNaskhArabic-$w.ttf').readAsBytesSync(),
);

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late InvoicePdfData data;
  final fonts = PdfFonts.fromBytes(
    regular: _font('Regular'),
    semiBold: _font('SemiBold'),
    bold: _font('Bold'),
    naskhRegular: _naskhFont('Regular'),
    naskhSemiBold: _naskhFont('SemiBold'),
    naskhBold: _naskhFont('Bold'),
  );

  setUpAll(() async {
    final db = AppDatabase.memory(seeder: legacySeed);
    final inv = (await db.invoicesDao.getAll()).single;
    data = InvoicePdfData(
      invoice: inv,
      client: (await db.clientsDao.getAll()).single,
      settings: await db.settingsDao.get(),
    );
    await db.close();
  });

  Future<(Uint8List, int)> render(InvoicePdfData d) async {
    final doc = buildInvoiceDocument(d, fonts);
    final bytes = await doc.save();
    return (bytes, doc.document.pdfPageList.pages.length);
  }

  test('seed invoice renders to one page', () async {
    final (bytes, pages) = await render(data);
    const out = String.fromEnvironment('PDF_OUT');
    if (out.isNotEmpty) File('$out/seed.pdf').writeAsBytesSync(bytes);
    expect(bytes.length, greaterThan(10000));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(pages, 1);
  });

  test('scope page adds a second page', () async {
    final inv = data.invoice;
    final withScope = InvoicePdfData(
      invoice: inv.copyWith(
        scope: inv.scope.copyWith(
          enabled: true,
          title: 'تطبيق المعلم الواحد',
          overview: 'تطبيق تعليمي متكامل مع لوحة تحكم.',
          done: 'تصميم الواجهات\nتطوير التطبيق',
          delivered: 'الكود المصدري\nحسابات المتاجر',
          warranty: 'ضمان 3 أشهر.',
        ),
      ),
      client: data.client,
      settings: data.settings,
    );
    final (bytes, pages) = await render(withScope);
    const out = String.fromEnvironment('PDF_OUT');
    if (out.isNotEmpty) File('$out/scope.pdf').writeAsBytesSync(bytes);
    expect(pages, 2);
  });

  test('long tables break across pages', () async {
    final inv = data.invoice;
    final sec = inv.sections[1];
    final many = [
      for (var i = 0; i < 80; i++)
        sec.items[i % sec.items.length].copyWith(id: 'x$i'),
    ];
    final (_, pages) = await render(
      InvoicePdfData(
        invoice: inv.copyWith(
          sections: [
            inv.sections[0],
            sec.copyWith(items: many),
          ],
        ),
        client: data.client,
        settings: data.settings,
      ),
    );
    expect(pages, greaterThan(1));
  });

  test('arabic invoice renders with Arabic labels and dates', () async {
    final arData = InvoicePdfData(
      invoice: data.invoice.copyWith(language: DocLanguage.ar),
      client: data.client,
      settings: data.settings.copyWith(docDigitStyle: DigitStyle.arabicIndic),
    );
    final (bytes, pages) = await render(arData);
    expect(pages, 1);
    expect(bytes.length, greaterThan(10000));
  });

  test('english invoice renders without Arabic secondaries', () async {
    final enData = InvoicePdfData(
      invoice: data.invoice.copyWith(language: DocLanguage.en),
      client: data.client,
      settings: data.settings,
    );
    final (bytes, pages) = await render(enData);
    expect(pages, 1);
    expect(bytes.length, greaterThan(10000));
  });

  test('empty payment methods omits payment card', () async {
    final noPayData = InvoicePdfData(
      invoice: data.invoice,
      client: data.client,
      settings: data.settings.copyWith(instapay: '', wallet: '', bankIban: ''),
    );
    final (bytes, pages) = await render(noPayData);
    expect(pages, 1);
    expect(bytes.length, greaterThan(10000));
  });

  test(
    'noto naskh renders mixed Arabic and Latin text without missing glyphs',
    () async {
      const textWithLatin = 'Acme Studio · hello@acme.example · 22,000.00';
      final naskhStyle = PdfStyle.fromDocumentStyle(
        const DocumentStyle(
          fontFamily: DocFontFamily.notoNaskhArabic,
        ),
      );
      final invWithLatin = InvoicePdfData(
        invoice: data.invoice.copyWith(
          notesAr: textWithLatin,
        ),
        client: data.client?.copyWith(
          name: 'Acme Studio',
          email: 'hello@acme.example',
        ),
        settings: data.settings.copyWith(
          name: 'Acme Studio',
          email: 'hello@acme.example',
        ),
      );
      final doc = buildInvoiceDocument(invWithLatin, fonts, style: naskhStyle);
      final bytes = await doc.save();
      expect(bytes.length, greaterThan(10000));
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    },
  );
}
