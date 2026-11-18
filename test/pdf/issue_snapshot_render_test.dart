import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/contract_repository.dart';
import 'package:invoice_desk/data/repositories/invoice_repository.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/pdf_render.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/pdf_golden.dart';
import '../helpers/sample_documents.dart';

/// ADR-0014: once a document is paid or signed, later edits to the
/// profile, payment details, client or document formats never change how
/// it prints. A draft follows them.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final fonts = loadPdfFonts();
  late AppDatabase db;
  late StyleRepository styles;
  late InvoiceRepository invoices;
  late ContractRepository contracts;

  setUp(() async {
    db = AppDatabase.memory();
    final clock = Clock.fixed(DateTime.utc(2026, 11, 18, 12));
    styles = StyleRepository(db, clock: clock);
    invoices = InvoiceRepository(db, styles: styles, clock: clock);
    contracts = ContractRepository(db, styles: styles, clock: clock);
    await db.settingsDao.save(sampleInvoiceSettings);
    await db.clientsDao.upsert(acme);
  });
  tearDown(() => db.close());

  /// Everything that prints and lives outside the document, changed.
  Future<void> changeEverything() async {
    final s = await db.settingsDao.get();
    await db.settingsDao.save(
      s.copyWith(
        name: 'Renamed Studio',
        address: 'New Street 9',
        bankIban: 'EG99NEW',
        instapay: 'new@instapay',
        taxRegistrationNo: '999-999-999',
        dateFormat: DocDateFormat.numeric,
        currencyDisplay: CurrencyDisplay.local,
        docDigitStyle: DigitStyle.arabicIndic,
      ),
    );
    await db.clientsDao.upsert(acme.copyWith(name: 'Renamed Client'));
  }

  Future<String> invoiceDump(Invoice inv) async {
    final data = InvoicePdfData(
      invoice: inv,
      client: (await db.clientsDao.getAll()).single,
      settings: await db.settingsDao.get(),
    );
    return pdfContentDump(await renderInvoicePdf(styles, data, fonts));
  }

  Invoice draft() => sampleInvoice(
    language: DocLanguage.ar,
    status: InvoiceStatus.draft,
  );

  test('a paid invoice prints the same after everything changes', () async {
    await invoices.save(draft());
    await invoices.markPaid(draft().id, const CalendarDate(2026, 11, 18));
    final paid = (await invoices.getById(draft().id))!;
    expect(paid.issueSnapshot, isNotNull);
    final before = await invoiceDump(paid);

    await changeEverything();
    expect(await invoiceDump(paid), before);
    // The editor's stale copy (no snapshot) prints the same too.
    expect(
      await invoiceDump(paid.copyWith(issueSnapshot: () => null)),
      before,
    );
  });

  test('a sent invoice keeps its snapshot through later saves', () async {
    await invoices.save(draft().copyWith(status: InvoiceStatus.sent));
    final sent = (await invoices.getById(draft().id))!;
    final before = await invoiceDump(sent);
    await changeEverything();
    // A save from a copy taken before the first save must not re-freeze.
    await invoices.save(draft().copyWith(status: InvoiceStatus.sent));
    final again = (await invoices.getById(draft().id))!;
    expect(again.issueSnapshot, sent.issueSnapshot);
    expect(await invoiceDump(again), before);
  });

  test('a draft follows the changes', () async {
    await invoices.save(draft());
    final d = (await invoices.getById(draft().id))!;
    expect(d.issueSnapshot, isNull);
    final before = await invoiceDump(d);
    await changeEverything();
    final after = await invoiceDump(d);
    expect(after, isNot(before));
  });

  test('an invoice sent before v8 keeps rendering from live data', () async {
    // Written as v7 left it: sent, a style snapshot, no issue snapshot.
    await db.invoicesDao.saveInvoice(
      draft().copyWith(
        status: InvoiceStatus.sent,
        styleSnapshot: () => '{}',
      ),
    );
    final legacy = (await invoices.getById(draft().id))!;
    final before = await invoiceDump(legacy);
    await changeEverything();
    // Re-saving it does not freeze today's data either.
    await invoices.save(legacy);
    final saved = (await invoices.getById(draft().id))!;
    expect(saved.issueSnapshot, isNull);
    expect(await invoiceDump(saved), isNot(before));
  });

  test('a signed contract prints the same after everything changes', () async {
    final signed = acmeContract(status: ContractStatus.signed);
    await contracts.save(signed);
    final stored = (await contracts.getById(signed.id))!;
    expect(stored.issueSnapshot, isNotNull);
    Future<String> dump() async => pdfContentDump(
      await renderContractPdf(
        styles,
        ContractPdfData(
          contract: stored,
          client: (await db.clientsDao.getAll()).single,
          settings: await db.settingsDao.get(),
        ),
        fonts,
      ),
    );
    final before = await dump();
    await changeEverything();
    expect(await dump(), before);
  });
}
