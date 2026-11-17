import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/contract_repository.dart';
import 'package:invoice_desk/data/repositories/invoice_repository.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_enums.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/legacy_seed.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late StyleRepository styles;
  late InvoiceRepository invoices;
  late ContractRepository contracts;

  setUp(() {
    db = AppDatabase.memory(seeder: legacySeed);
    styles = StyleRepository(db);
    invoices = InvoiceRepository(db, styles: styles);
    contracts = ContractRepository(db, styles: styles);
  });

  tearDown(() => db.close());

  // Valid image fixture bytes
  final validPng = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
  ]);

  final validJpeg = Uint8List.fromList([
    0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, // JPEG SOI + APP0
  ]);

  group('Asset validation and storage', () {
    test('rejects assets larger than 1 MB', () async {
      final oversized = Uint8List(1024 * 1024 + 1);
      // Valid PNG header on oversized payload
      oversized.setRange(0, 8, [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]);

      expect(
        () => styles.saveAsset(bytes: oversized),
        throwsA(isA<InvalidAssetException>()),
      );
    });

    test('rejects non-PNG and non-JPEG assets', () async {
      final textFile = Uint8List.fromList(utf8.encode('Hello World!'));

      expect(
        () => styles.saveAsset(bytes: textFile),
        throwsA(isA<InvalidAssetException>()),
      );
    });

    test('stores valid PNG and computes correct sha256 hash', () async {
      final expectedHash = sha256.convert(validPng).toString();
      final hash = await styles.saveAsset(bytes: validPng);

      expect(hash, expectedHash);
      final fetched = await styles.getAsset(hash);
      expect(fetched, validPng);
    });

    test('stores valid JPEG and deduplicates identical uploads', () async {
      final expectedHash = sha256.convert(validJpeg).toString();
      final hash1 = await styles.saveAsset(bytes: validJpeg);
      final hash2 = await styles.saveAsset(bytes: validJpeg);

      expect(hash1, expectedHash);
      expect(hash2, expectedHash);
      final fetched = await styles.getAsset(expectedHash);
      expect(fetched, validJpeg);
    });

    test('getAsset returns null for missing asset', () async {
      expect(await styles.getAsset('non-existent-hash'), isNull);
    });
  });

  group('Asset usage and purging', () {
    test('purges unreferenced assets and retains referenced ones', () async {
      final hashA = await styles.saveAsset(bytes: validPng);
      final hashB = await styles.saveAsset(bytes: validJpeg);

      expect(await styles.isAssetInUse(hashA), isFalse);
      expect(await styles.isAssetInUse(hashB), isFalse);

      // Create a style referencing hashA
      await styles.saveUserStyle(
        CustomStyle(
          id: 'style-with-logo',
          name: 'With Logo',
          style: DocumentStyle(logoAssetId: hashA),
        ),
      );

      expect(await styles.isAssetInUse(hashA), isTrue);
      expect(await styles.isAssetInUse(hashB), isFalse);

      final purged = await styles.purgeUnusedAssets();
      expect(purged, 1);

      expect(await styles.getAsset(hashA), isNotNull);
      expect(await styles.getAsset(hashB), isNull);
    });
  });

  group('Style resolution hierarchy', () {
    test('resolves classic preset as ultimate fallback', () async {
      final resolved = await styles.resolveStyle();
      expect(resolved.primary, DocPreset.classic.style.primary);
      expect(resolved.fontFamily, DocFontFamily.ibmPlexSansArabic);
    });

    test('resolves preset by preset ID directly', () async {
      final resolvedModern = await styles.resolveStyle(styleId: 'preset_modern');
      expect(resolvedModern.primary, DocPreset.modern.style.primary);

      final resolvedBold = await styles.resolveStyle(styleId: 'bold');
      expect(resolvedBold.primary, DocPreset.bold.style.primary);
    });

    test('resolves global settings default when doc and client have no preference', () async {
      final currentSettings = await db.settingsDao.get();
      await db.settingsDao.save(
        currentSettings.copyWith(
          defaultInvoiceStyleId: () => 'preset_minimal',
          defaultContractStyleId: () => 'preset_bold',
        ),
      );

      final invStyle = await styles.resolveStyle(isContract: false);
      expect(invStyle.primary, DocPreset.minimal.style.primary);

      final contractStyle = await styles.resolveStyle(isContract: true);
      expect(contractStyle.primary, DocPreset.bold.style.primary);
    });

    test('client style preference overrides global settings default', () async {
      final currentSettings = await db.settingsDao.get();
      await db.settingsDao.save(
        currentSettings.copyWith(defaultInvoiceStyleId: () => 'preset_minimal'),
      );

      final client = (await db.clientsDao.getAll()).first;
      await db.clientsDao.upsert(client.copyWith(styleId: 'preset_bold'));

      final resolved = await styles.resolveStyle(clientId: client.id);
      expect(resolved.primary, DocPreset.bold.style.primary);
    });

    test('document style ID overrides client and global settings', () async {
      final client = (await db.clientsDao.getAll()).first;
      await db.clientsDao.upsert(client.copyWith(styleId: 'preset_bold'));

      final resolved = await styles.resolveStyle(
        clientId: client.id,
        styleId: 'preset_modern',
      );
      expect(resolved.primary, DocPreset.modern.style.primary);
    });

    test('document snapshot overrides all other configuration', () async {
      const frozenStyle = DocumentStyle(primary: 0xFF123456);

      final resolved = await styles.resolveStyle(
        clientId: 'any-client',
        styleId: 'preset_bold',
        snapshotJson: frozenStyle.toRawJson(),
      );
      expect(resolved.primary, 0xFF123456);
    });
  });

  group('Document snapshotting and logo immutability', () {
    test('draft invoice does not snapshot style; sent invoice snapshots resolved style', () async {
      final client = (await db.clientsDao.getAll()).first;
      await db.clientsDao.upsert(client.copyWith(styleId: 'preset_modern'));

      final draftInv = Invoice(
        id: 'inv-test-1',
        clientId: client.id,
        number: 'OM-2026-9001',
        year: 2026,
        seq: 9001,
        issueDate: const CalendarDate(2026, 11, 1),
        dueDate: const CalendarDate(2026, 12, 1),
        status: InvoiceStatus.draft,
      );

      await invoices.save(draftInv);
      var fetched = await invoices.getById('inv-test-1');
      expect(fetched?.styleSnapshot, isNull);

      // Save as sent -> style is snapshotted
      await invoices.save(draftInv.copyWith(status: InvoiceStatus.sent));
      fetched = await invoices.getById('inv-test-1');
      expect(fetched?.styleSnapshot, isNotNull);

      final parsed = DocumentStyle.fromRawJson(fetched!.styleSnapshot!);
      expect(parsed.primary, DocPreset.modern.style.primary);
    });

    test('markPaid snapshots style in the same transaction if not already frozen', () async {
      final client = (await db.clientsDao.getAll()).first;
      await db.clientsDao.upsert(client.copyWith(styleId: 'preset_bold'));

      final draftInv = Invoice(
        id: 'inv-test-2',
        clientId: client.id,
        number: 'OM-2026-9002',
        year: 2026,
        seq: 9002,
        issueDate: const CalendarDate(2026, 11, 1),
        dueDate: const CalendarDate(2026, 12, 1),
        status: InvoiceStatus.draft,
      );
      await invoices.save(draftInv);

      await invoices.markPaid('inv-test-2', const CalendarDate(2026, 11, 15));
      final paidInv = await invoices.getById('inv-test-2');
      expect(paidInv?.status, InvoiceStatus.paid);
      expect(paidInv?.paidDate, const CalendarDate(2026, 11, 15));
      expect(paidInv?.styleSnapshot, isNotNull);

      final parsed = DocumentStyle.fromRawJson(paidInv!.styleSnapshot!);
      expect(parsed.primary, DocPreset.bold.style.primary);
    });

    test('contract snapshots style when saved as signed', () async {
      final client = (await db.clientsDao.getAll()).first;
      await db.clientsDao.upsert(client.copyWith(styleId: 'preset_minimal'));

      final contract = Contract(
        id: 'ct-test-1',
        clientId: client.id,
        number: 'CT-2026-9001',
        year: 2026,
        seq: 9001,
        issueDate: const CalendarDate(2026, 11, 1),
        status: ContractStatus.signed,
      );

      await contracts.save(contract);
      final fetched = await contracts.getById('ct-test-1');
      expect(fetched?.styleSnapshot, isNotNull);

      final parsed = DocumentStyle.fromRawJson(fetched!.styleSnapshot!);
      expect(parsed.primary, DocPreset.minimal.style.primary);
    });

    test('changing logo and client style after payment leaves paid invoice style and logo unchanged', () async {
      // 1. Upload logo A and create custom style with logo A
      final logoA = await styles.saveAsset(bytes: validPng);
      await styles.saveUserStyle(
        CustomStyle(
          id: 'client-custom-style',
          name: 'Client Style',
          style: DocumentStyle(
            primary: 0xFF00AAFF,
            logoAssetId: logoA,
          ),
        ),
      );

      final client = (await db.clientsDao.getAll()).first;
      await db.clientsDao.upsert(client.copyWith(styleId: 'client-custom-style'));

      // 2. Create invoice and mark it paid -> snapshots style with logo A
      final invoice = Invoice(
        id: 'inv-frozen-logo',
        clientId: client.id,
        number: 'OM-2026-9003',
        year: 2026,
        seq: 9003,
        issueDate: const CalendarDate(2026, 11, 1),
        dueDate: const CalendarDate(2026, 12, 1),
        status: InvoiceStatus.sent,
      );
      await invoices.save(invoice);
      await invoices.markPaid('inv-frozen-logo', const CalendarDate(2026, 11, 10));

      // 3. User uploads logo B and updates custom style and client to logo B
      final logoB = await styles.saveAsset(bytes: validJpeg);
      await styles.saveUserStyle(
        CustomStyle(
          id: 'client-custom-style',
          name: 'Client Style V2',
          style: DocumentStyle(
            primary: 0xFFFF5500,
            logoAssetId: logoB,
          ),
        ),
      );

      // 4. Resolving for the paid invoice yields the frozen snapshot with logo A!
      final paidInv = (await invoices.getById('inv-frozen-logo'))!;
      final resolvedPaidStyle = await styles.resolveForInvoice(paidInv);

      expect(resolvedPaidStyle.primary, 0xFF00AAFF);
      expect(resolvedPaidStyle.logoAssetId, logoA);

      // 5. Logo A is still referenced by the paid invoice and cannot be purged
      expect(await styles.isAssetInUse(logoA), isTrue);
      final purged = await styles.purgeUnusedAssets();
      expect(purged, 0);
      expect(await styles.getAsset(logoA), isNotNull);
    });
  });

  group('Custom style CRUD', () {
    test('saves, reads, soft-deletes and restores a custom style', () async {
      const custom = CustomStyle(
        id: 'custom-style-1',
        name: 'Brand Style',
        style: DocumentStyle(primary: 0xFF445566),
      );

      await styles.saveUserStyle(custom);
      var fetched = await styles.getUserStyleById('custom-style-1');
      expect(fetched?.name, 'Brand Style');
      expect(fetched?.style.primary, 0xFF445566);

      var list = await styles.getUserStyles();
      expect(list.any((s) => s.id == 'custom-style-1'), isTrue);

      // Soft delete
      await styles.softDeleteUserStyle('custom-style-1');
      list = await styles.getUserStyles();
      expect(list.any((s) => s.id == 'custom-style-1'), isFalse);
      expect(await styles.getUserStyleById('custom-style-1'), isNull);

      // Undo delete
      await styles.undoDeleteUserStyle('custom-style-1');
      list = await styles.getUserStyles();
      expect(list.any((s) => s.id == 'custom-style-1'), isTrue);
    });
  });
}
