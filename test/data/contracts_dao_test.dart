import 'package:clock/clock.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/daos/contracts_dao.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/sidebar/sidebar_model.dart';

import '../helpers/contract_fixtures.dart';
import '../helpers/legacy_seed.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Client client;
  late ClauseTemplate templateA;

  setUp(() async {
    db = AppDatabase.memory(seeder: legacySeed);
    client = (await db.clientsDao.getAll()).single;
    templateA = (await db.libraryDao.getAll()).firstWhere(
      (t) => t.name == developmentTemplateName,
    );
  });
  tearDown(() => db.close());

  Contract fromTemplate(
    ClauseTemplate t, {
    String id = 'k1',
    String number = 'CT-2026-0001',
    int seq = 1,
    TemplateKind series = TemplateKind.contract,
  }) => Contract(
    id: id,
    clientId: client.id,
    number: number,
    series: series,
    year: 2026,
    seq: seq,
    issueDate: const CalendarDate(2026, 11, 15),
    templateName: t.name,
    preamble: t.preamble,
    vars: t.varDefaults,
    clauses: clausesFromTemplate(t, fixtureId),
    scope: [ScopeItem(id: '$id-sc1', item: 'لوحة التحكم')],
    milestones: [
      PaymentMilestone(id: '$id-ms1', label: 'مقدم', percentBp: 5000),
      PaymentMilestone(id: '$id-ms2', label: 'نهائي', percentBp: 5000),
    ],
    totalMinor: 1000000,
  );

  test('the aggregate round-trips', () async {
    final c = fromTemplate(templateA);
    await db.contractsDao.saveContract(c);
    final back = (await db.contractsDao.getById('k1'))!;
    expect(back.clauses, hasLength(14));
    expect(back.clauses.where((x) => !x.enabled), hasLength(4));
    expect(back.vars['durationWeeks'], '10');
    expect(back.scope.single.item, 'لوحة التحكم');
    expect(back.milestones.map((m) => m.percentBp), [5000, 5000]);
    expect(back.clauses.first.fromLibraryClauseId, templateA.clauses.first.id);
  });

  test(
    'snapshot: editing the library leaves existing contracts alone',
    () async {
      await db.contractsDao.saveContract(fromTemplate(templateA));
      final first = templateA.clauses.first;
      await db.libraryDao.updateClauseText(
        first.id,
        title: 'موضوع العقد (معدّل)',
        body: 'نص جديد',
      );
      final c = (await db.contractsDao.getById('k1'))!;
      expect(c.clauses.first.title, 'موضوع العقد');
      expect(c.clauses.first.body, first.body);
      // …and the library has the new wording for "restore from library".
      final lib = (await db.libraryDao.clauseById(first.id))!;
      expect(lib.body, 'نص جديد');
    },
  );

  test('numbering per series; amendments share the original seq', () async {
    expect(await db.contractsDao.nextSeqFor(TemplateKind.contract, 2026), 1);
    await db.contractsDao.saveContract(fromTemplate(templateA));
    await db.contractsDao.saveContract(
      fromTemplate(
        templateA,
        id: 'q1',
        number: 'QT-2026-0001',
        series: TemplateKind.quote,
      ),
    );
    expect(await db.contractsDao.nextSeqFor(TemplateKind.contract, 2026), 2);
    expect(await db.contractsDao.nextSeqFor(TemplateKind.quote, 2026), 2);
    expect(await db.contractsDao.nextAmendmentNo('k1'), 1);
    final a1 = fromTemplate(templateA, id: 'a1', number: 'CT-2026-0001-A1')
        .copyWith(
          kind: ContractKind.amendment,
          parentId: () => 'k1',
          amendmentNo: 1,
        );
    await db.contractsDao.saveContract(a1);
    expect(await db.contractsDao.nextAmendmentNo('k1'), 2);
    // Amendments don't advance the series.
    expect(await db.contractsDao.nextSeqFor(TemplateKind.contract, 2026), 2);
    await expectLater(
      db.contractsDao.saveContract(
        fromTemplate(templateA, id: 'dup'),
      ),
      throwsA(isA<DuplicateContractNumber>()),
    );
  });

  test('delete is refused with linked invoices; plain delete undoes', () async {
    await db.contractsDao.saveContract(fromTemplate(templateA));
    final stamp = await db.contractsDao.softDelete('k1');
    expect(await db.contractsDao.getAll(), isEmpty);
    await db.contractsDao.undoDelete('k1', stamp);
    expect(await db.contractsDao.getAll(), hasLength(1));

    final inv = (await db.invoicesDao.getAll()).single;
    await db.contractsDao.linkMilestone('k1-ms1', inv.id);
    await expectLater(
      db.contractsDao.softDelete('k1'),
      throwsA(isA<ContractHasInvoices>()),
    );
  });

  test('purging a linked invoice clears the milestone link', () async {
    await db.contractsDao.saveContract(fromTemplate(templateA));
    final inv = (await db.invoicesDao.getAll()).single;
    await db.contractsDao.linkMilestone('k1-ms1', inv.id);
    final t0 = DateTime(2026, 11, 15);
    await withClock(Clock.fixed(t0), () => db.invoicesDao.softDelete(inv.id));
    await withClock(
      Clock.fixed(t0.add(const Duration(days: 31))),
      db.invoicesDao.purgeDeleted,
    );
    final c = (await db.contractsDao.getById('k1'))!;
    expect(c.milestones.first.invoiceId, isNull);
  });

  test('client rules count contracts', () async {
    const other = Client(id: 'beta', name: 'Beta');
    await db.clientsDao.upsert(other);
    await db.contractsDao.saveContract(
      fromTemplate(templateA).copyWith(clientId: 'beta'),
    );
    expect(await db.clientsDao.countLiveContracts('beta'), 1);
    expect(await db.clientsDao.countLiveInvoices('beta'), 0);
    // A live contract blocks the plain soft delete…
    await expectLater(db.clientsDao.softDelete('beta'), throwsA(anything));
    // …and the FK blocks a raw delete.
    await expectLater(
      db.customStatement("DELETE FROM clients WHERE id = 'beta'"),
      throwsA(anything),
    );
    // Delete with documents takes contracts along, and undo brings them back.
    final stamp = await db.clientsDao.softDeleteWithDocuments('beta');
    expect(await db.contractsDao.getAll(), isEmpty);
    await db.clientsDao.undoDeleteWithDocuments('beta', stamp);
    expect(await db.contractsDao.getAll(), hasLength(1));

    // Archiving hides the client's contracts from the sidebar.
    await db.clientsDao.setArchived('beta', archived: true);
    SidebarData run(SidebarFilter f, [String q = '']) => buildSidebar(
      clients: [client, other.copyWith(archived: true)],
      invoices: const [],
      contracts: [fromTemplate(templateA).copyWith(clientId: 'beta')],
      query: q,
      filter: f,
      today: const CalendarDate(2026, 11, 15),
    );
    expect(run(SidebarFilter.all).groups.map((g) => g.client.id), [client.id]);
    expect(run(SidebarFilter.all, 'CT-2026').groups, isEmpty);
    expect(
      run(SidebarFilter.archived).groups.single.contracts.single.contract.id,
      'k1',
    );
  });

  test('sidebar: search by number, title, project; "عقود سارية"', () {
    final base = fromTemplate(templateA).copyWith(
      title: 'تطوير منصة',
      projectName: 'منصة أكمي',
    );
    final signed = base.copyWith(
      id: 'k2',
      number: 'CT-2026-0002',
      seq: 2,
      status: ContractStatus.signed,
      title: 'استضافة',
      projectName: 'خوادم',
    );
    final amendment = base.copyWith(
      id: 'a1',
      number: 'CT-2026-0002-A1',
      seq: 2,
      amendmentNo: 1,
      parentId: () => 'k2',
      kind: ContractKind.amendment,
    );
    SidebarData run(SidebarFilter f, [String q = '']) => buildSidebar(
      clients: [client],
      invoices: const [],
      contracts: [base, signed, amendment],
      query: q,
      filter: f,
      today: const CalendarDate(2026, 11, 15),
    );
    final all = run(SidebarFilter.all).groups.single.contracts;
    // Newest first; amendments right under their original.
    expect(all.map((e) => (e.contract.number, e.depth)), [
      ('CT-2026-0002', 0),
      ('CT-2026-0002-A1', 1),
      ('CT-2026-0001', 0),
    ]);
    expect(
      run(SidebarFilter.all, '0001').groups.single.contracts.single.contract.id,
      'k1',
    );
    expect(
      run(SidebarFilter.all, 'خوادم').groups.single.contracts.first.contract.id,
      'k2',
    );
    expect(run(SidebarFilter.all, 'تطوير').groups.single.contracts, isNotEmpty);
    final inForce = run(SidebarFilter.contractsInForce).groups.single;
    expect(inForce.contracts.map((e) => e.contract.id), ['k2', 'a1']);
    expect(inForce.invoices, isEmpty);
    expect(run(SidebarFilter.unpaid).groups, isEmpty);
  });

  test(
    'streams re-emit for contracts and the library, alongside invoices',
    () async {
      // Regression: drift shares watch streams by SQL text, so identical
      // "SELECT 1" queries used to hide contract/library changes.
      final invoices = db.invoicesDao.watchAll();
      final contracts = db.contractsDao.watchAll();
      final library = db.libraryDao.watchAll();
      final seenInvoices = <int>[];
      final seenContracts = <int>[];
      final seenTemplates = <int>[];
      final subs = [
        invoices.listen((v) => seenInvoices.add(v.length)),
        contracts.listen((v) => seenContracts.add(v.length)),
        library.listen((v) => seenTemplates.add(v.length)),
      ];
      await pumpEventQueue();
      await db.contractsDao.saveContract(fromTemplate(templateA));
      await db.libraryDao.deleteTemplate(templateA.id);
      await pumpEventQueue();
      for (final s in subs) {
        await s.cancel();
      }
      expect(seenInvoices.first, 1);
      expect(seenContracts.last, 1);
      expect(seenTemplates.last, 1);
    },
  );
}
