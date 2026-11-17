import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/legacy_seed.dart';

/// Deleting a style that documents or clients use: how many are told, and
/// where they fall back to (ADR-0012: document → client → default →
/// Classic).
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late StyleRepository styles;
  late Client client;

  setUp(() async {
    db = AppDatabase.memory(seeder: legacySeed);
    styles = StyleRepository(
      db,
      clock: Clock.fixed(DateTime.utc(2026, 11, 17, 12)),
    );
    client = (await db.clientsDao.getAll()).first;
  });
  tearDown(() => db.close());

  Invoice invoice(String id, int seq, {String? styleId, InvoiceStatus? st}) =>
      Invoice(
        id: id,
        clientId: client.id,
        number: 'OM-2026-${9200 + seq}',
        year: 2026,
        seq: 9200 + seq,
        issueDate: const CalendarDate(2026, 11, 1),
        dueDate: const CalendarDate(2026, 12, 1),
        status: st ?? InvoiceStatus.draft,
        styleId: styleId,
      );

  Future<void> setDefault(String? id) async {
    final s = await db.settingsDao.get();
    await db.settingsDao.save(s.copyWith(defaultInvoiceStyleId: () => id));
  }

  test('counts unfrozen drafts and clients, not frozen or trashed', () async {
    await styles.duplicateStyle(id: 'u', name: 'Mine', presetId: 'modern');
    await db.invoicesDao.saveInvoice(invoice('d1', 1, styleId: 'u'));
    await db.invoicesDao.saveInvoice(invoice('d2', 2, styleId: 'u'));
    // Sent with a snapshot: its look is frozen, so it does not count.
    await db.invoicesDao.saveInvoice(
      invoice('s1', 3, styleId: 'u', st: InvoiceStatus.sent).copyWith(
        styleSnapshot: DocPreset.modern.style.toRawJson,
      ),
    );
    await db.invoicesDao.saveInvoice(invoice('t1', 4, styleId: 'u'));
    await db.invoicesDao.softDelete('t1');
    await db.clientsDao.upsert(client.copyWith(styleId: 'u'));

    final usage = await styles.styleUsage('u');
    expect(usage.drafts, 2);
    expect(usage.clients, 1);
    expect(usage.isUsed, isTrue);
    expect((await styles.styleUsage('other')).isUsed, isFalse);
  });

  test(
    'a deleted style falls back to client, then default, then Classic',
    () async {
      await styles.duplicateStyle(id: 'u', name: 'Mine', presetId: 'modern');
      final draft = invoice('d1', 1, styleId: 'u');
      await db.invoicesDao.saveInvoice(draft);
      expect(
        (await styles.lookForInvoice(draft)).style,
        DocPreset.modern.style,
      );

      await styles.softDeleteUserStyle('u');
      await db.clientsDao.upsert(client.copyWith(styleId: DocPreset.bold.id));
      await setDefault(DocPreset.minimal.id);
      expect((await styles.lookForInvoice(draft)).style, DocPreset.bold.style);

      await db.clientsDao.upsert(client.copyWith(styleId: null));
      expect(
        (await styles.lookForInvoice(draft)).style,
        DocPreset.minimal.style,
      );

      await setDefault('u'); // The default itself points at the deleted style.
      expect((await styles.lookForInvoice(draft)).style, const DocumentStyle());
      expect(const DocumentStyle(), DocPreset.classic.style);

      // Undo brings the look back.
      await styles.undoDeleteUserStyle('u');
      expect(
        (await styles.lookForInvoice(draft)).style,
        DocPreset.modern.style,
      );
    },
  );

  test('a frozen document keeps the deleted style it was sent with', () async {
    await styles.duplicateStyle(id: 'u', name: 'Mine', presetId: 'formal');
    final sent = invoice(
      's1',
      1,
      styleId: 'u',
      st: InvoiceStatus.sent,
    ).copyWith(styleSnapshot: DocPreset.formal.style.toRawJson);
    await db.invoicesDao.saveInvoice(sent);
    await styles.softDeleteUserStyle('u');
    final look = await styles.lookForInvoice(sent);
    expect(look.style, DocPreset.formal.style);
    expect(look.locked, isTrue);
  });
}
