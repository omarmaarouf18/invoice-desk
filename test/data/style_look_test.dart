import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/invoice_repository.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/legacy_seed.dart';

/// `StyleRepository.lookFor*`: what a document prints with, and when that
/// look is frozen (ADR-0012, AGENTS rule 8).
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late StyleRepository styles;
  late InvoiceRepository invoices;
  final now = DateTime.utc(2026, 11, 17, 12);

  setUp(() {
    db = AppDatabase.memory(seeder: legacySeed);
    styles = StyleRepository(db, clock: Clock(() => now));
    invoices = InvoiceRepository(db, styles: styles, clock: Clock(() => now));
  });

  tearDown(() => db.close());

  Future<Client> client() async => (await db.clientsDao.getAll()).first;

  Invoice invoice(String clientId, {InvoiceStatus? status}) => Invoice(
    id: 'inv-look',
    clientId: clientId,
    number: 'OM-2026-9101',
    year: 2026,
    seq: 9101,
    issueDate: const CalendarDate(2026, 11, 1),
    dueDate: const CalendarDate(2026, 12, 1),
    status: status ?? InvoiceStatus.draft,
  );

  Future<void> setDefault(String id) async {
    final s = await db.settingsDao.get();
    await db.settingsDao.save(
      s.copyWith(
        defaultInvoiceStyleId: () => id,
        defaultContractStyleId: () => id,
      ),
    );
  }

  test('a preset id resolves for every preset, Formal included', () async {
    for (final p in DocPreset.values) {
      final s = await styles.resolveStyle(styleId: p.id);
      expect(s, p.style, reason: p.id);
    }
  });

  test('a draft follows the live chain and is not locked', () async {
    final c = await client();
    await invoices.save(invoice(c.id));
    await setDefault(DocPreset.modern.id);
    final look = await styles.lookForInvoice(invoice(c.id));
    expect(look.style, DocPreset.modern.style);
    expect(look.locked, isFalse);
  });

  test('a sent invoice from before styles stays Classic and locked', () async {
    final c = await client();
    // Written the way v1–v6 (and old backups) left it: sent, no snapshot.
    await db.invoicesDao.saveInvoice(
      invoice(c.id, status: InvoiceStatus.sent),
    );
    await setDefault(DocPreset.bold.id);

    final look = await styles.lookForInvoice(
      invoice(c.id, status: InvoiceStatus.sent),
    );
    expect(look.style, DocPreset.classic.style);
    expect(look.locked, isTrue);

    // Re-saving it freezes Classic, not the new default.
    await invoices.save(invoice(c.id, status: InvoiceStatus.sent));
    final stored = await invoices.getById('inv-look');
    expect(
      DocumentStyle.fromRawJson(stored!.styleSnapshot!),
      DocPreset.classic.style,
    );
  });

  test('the stored snapshot wins over a stale editor copy', () async {
    final c = await client();
    await db.clientsDao.upsert(c.copyWith(styleId: DocPreset.formal.id));
    await invoices.save(invoice(c.id, status: InvoiceStatus.sent));
    await db.clientsDao.upsert(c.copyWith(styleId: DocPreset.bold.id));

    // The editor still holds the copy from before the save (no snapshot).
    final look = await styles.lookForInvoice(
      invoice(c.id, status: InvoiceStatus.sent),
    );
    expect(look.style, DocPreset.formal.style);
    expect(look.locked, isTrue);
  });

  test('marking a draft sent in the editor previews the live style', () async {
    final c = await client();
    await invoices.save(invoice(c.id));
    await setDefault(DocPreset.minimal.id);
    final look = await styles.lookForInvoice(
      invoice(c.id, status: InvoiceStatus.sent),
    );
    expect(look.style, DocPreset.minimal.style);
    expect(look.locked, isFalse);
  });

  test('a signed contract from before styles stays Classic', () async {
    await db.clientsDao.upsert(acme);
    final signed = acmeContract(status: ContractStatus.signed);
    await db.contractsDao.saveContract(signed);
    await setDefault(DocPreset.modern.id);

    final look = await styles.lookForContract(signed);
    expect(look.style, DocPreset.classic.style);
    expect(look.locked, isTrue);
  });

  test('the logo bytes come with the look', () async {
    final png = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 0x0D, //
    ]);
    final id = await styles.saveAsset(bytes: png);
    final look = await styles.lookForStyle(DocumentStyle(logoAssetId: id));
    expect(look.logo, png);
    final noLogo = await styles.lookForInvoice(
      invoice((await client()).id),
      withLogo: false,
    );
    expect(noLogo.logo, isNull);
  });
}
