import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/invoice_repository.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/legacy_seed.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late InvoiceRepository repo;

  setUp(() {
    db = AppDatabase.memory(seeder: legacySeed);
    repo = InvoiceRepository(db);
  });
  tearDown(() => db.close());

  test(
    'D7: resolveLanguage follows client preference then global settings',
    () async {
      // 1. Without client -> global default (initially ar)
      expect(await repo.resolveLanguage(), DocLanguage.ar);
      expect(await repo.resolveLanguage(clientId: ''), DocLanguage.ar);

      // 2. With client that has no preference -> global default
      final client = (await db.clientsDao.getAll()).single;
      expect(client.preferredLanguage, isNull);
      expect(await repo.resolveLanguage(clientId: client.id), DocLanguage.ar);

      // 3. Update global default to bilingual -> resolves to bilingual
      final settings = await db.settingsDao.get();
      await db.settingsDao.save(
        settings.copyWith(defaultDocLanguage: DocLanguage.bilingual),
      );
      expect(await repo.resolveLanguage(), DocLanguage.bilingual);
      expect(
        await repo.resolveLanguage(clientId: client.id),
        DocLanguage.bilingual,
      );

      // 4. Update client's preferred language to English -> resolves to English
      await db.clientsDao.upsert(
        client.copyWith(preferredLanguage: DocLanguage.en),
      );
      expect(await repo.resolveLanguage(clientId: client.id), DocLanguage.en);

      // 5. Another client with Arabic preference -> resolves to Arabic
      await db.clientsDao.upsert(
        const Client(
          id: 'client-ar',
          name: 'Arabic Client',
          preferredLanguage: DocLanguage.ar,
        ),
      );
      expect(await repo.resolveLanguage(clientId: 'client-ar'), DocLanguage.ar);
    },
  );
}
