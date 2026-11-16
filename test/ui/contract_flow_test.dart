import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/results.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/sidebar/sidebar.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  late AppDatabase db;
  late ProviderContainer c;
  late Client client;

  ContractController ctl() => c.read(contractProvider.notifier);
  Contract open() => c.read(contractProvider).contract!;

  Future<void> start(WidgetTester tester) async {
    db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(db.close);
    client = (await drive(tester, db.clientsDao.getAll)).single;
    c = await pumpShell(tester, db);
  }

  Future<ClauseTemplate> template(WidgetTester tester, String name) async =>
      (await drive(tester, db.libraryDao.getAll)).firstWhere(
        (t) => t.name == name,
      );

  Future<Contract> create(WidgetTester tester) async {
    final t = await template(tester, developmentTemplateName);
    final k = await drive(
      tester,
      () => ctl().create(
        NewContractRequest(
          clientId: client.id,
          template: t,
          title: 'تطوير منصة',
          projectName: 'منصة المتر',
        ),
      ),
    );
    await settle(tester);
    return k;
  }

  /// Gives the seed client its legal details and the contract a total, so
  /// nothing is missing.
  Future<void> fillEverything(WidgetTester tester) async {
    await drive(
      tester,
      () => db.clientsDao.upsert(
        client.copyWith(
          legalName: 'أكاديمية المتر',
          representative: 'أحمد علي',
          representativeTitle: 'المدير',
        ),
      ),
    );
    ctl().edit((k) => k.copyWith(totalMinor: 1000000));
    await settle(tester);
  }

  /// Lets the pending autosave run before the tree is torn down.
  Future<void> finish(WidgetTester tester) async {
    await tester.pump(ContractController.autosaveDelay);
    await settle(tester);
  }

  Future<void> tap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle(tester);
  }

  testWidgets('new contract from the client menu opens the editor', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('Sample Academy'), buttons: kSecondaryButton);
    await settle(tester);
    await tester.tap(find.text('عقد جديد').last);
    await settle(tester);
    expect(find.text(developmentTemplateName), findsOneWidget);
    expect(find.text(quoteTemplateName), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextField, 'عنوان العقد'),
      'تطوير منصة',
    );
    await tap(tester, find.byKey(const ValueKey('create-contract')));

    expect(c.read(workspaceProvider), Workspace.contract);
    expect(open().number, 'CT-2026-0001');
    expect(open().clauses, hasLength(14));
    expect(find.text('CT-2026-0001'), findsWidgets);
    final saved = await drive(tester, db.contractsDao.getAll);
    expect(saved.single.title, 'تطوير منصة');
  });

  testWidgets('quote template numbers QT-…', (tester) async {
    await start(tester);
    final t = await template(tester, quoteTemplateName);
    await drive(
      tester,
      () => ctl().create(NewContractRequest(clientId: client.id, template: t)),
    );
    await settle(tester);
    expect(open().number, 'QT-2026-0001');
    expect(open().kind, ContractKind.quote);
    expect(open().closing, contains('قبولًا لما ورد فيه'));
  });

  testWidgets('missing variables block sent/signed; the chip jumps to them', (
    tester,
  ) async {
    await start(tester);
    await create(tester);
    final missing = c.read(openMissingProvider);
    expect(missing, [
      'client.representative',
      'client.representativeTitle',
      'total',
    ]);
    expect(find.text('3 متغيرات ناقصة'), findsOneWidget);

    final r = ctl().setStatus(ContractStatus.sent, missing: missing);
    expect(r, isA<StatusBlocked>());
    expect(open().status, ContractStatus.draft);
    expect(
      ctl().setStatus(ContractStatus.signed, missing: missing),
      isA<StatusBlocked>(),
    );

    await tester.tap(find.byKey(const ValueKey('missing-variables')));
    await settle(tester);
    expect(c.read(contractProvider).focusVariable, 'client.representative');

    await fillEverything(tester);
    expect(c.read(openMissingProvider), isEmpty);
    expect(find.text('3 متغيرات ناقصة'), findsNothing);
    expect(
      ctl().setStatus(ContractStatus.sent, missing: const []),
      isA<StatusChanged>(),
    );
    expect(open().status, ContractStatus.sent);
    await finish(tester);
  });

  testWidgets('signed is read-only; amendment links to the original', (
    tester,
  ) async {
    await start(tester);
    final k = await create(tester);
    await fillEverything(tester);
    ctl().setStatus(ContractStatus.signed, missing: const []);
    await settle(tester);
    expect(open().isLocked, isTrue);
    expect(open().signedDate, isNotNull);
    expect(find.textContaining('للقراءة فقط'), findsOneWidget);

    // Clauses, annexes and variables don't change.
    ctl()
      ..edit((x) => x.copyWith(title: 'محاولة'))
      ..setVariable('durationWeeks', '99')
      ..removeClause(open().clauses.first.id)
      ..addMilestone();
    expect(open().title, 'تطوير منصة');
    expect(open().vars['durationWeeks'], '10');
    expect(open().clauses, hasLength(14));
    expect(open().milestones, hasLength(3));

    await tap(tester, find.widgetWithText(FilledButton, 'ملحق تعديل'));
    final a = open();
    expect(a.number, 'CT-2026-0001-A1');
    expect(a.parentId, k.id);
    expect(a.kind, ContractKind.amendment);
    expect(a.isLocked, isFalse);
    expect(a.preamble, contains('CT-2026-0001'));
    expect(find.text('ملحق للعقد CT-2026-0001'), findsOneWidget);
    // The sidebar shows it under the original.
    expect(find.text('CT-2026-0001-A1'), findsWidgets);

    // "إلغاء القفل" asks first and is logged.
    await drive(tester, () => ctl().open(k.id));
    await settle(tester);
    await tap(tester, find.byKey(const ValueKey('unlock-contract')));
    expect(find.text('إلغاء قفل عقد موقّع؟'), findsOneWidget);
    await tap(tester, find.byKey(const ValueKey('confirm-unlock')));
    expect(open().isLocked, isFalse);
    expect(open().history.last.event, 'unlock');
    await finish(tester);
  });

  testWidgets('milestone → invoice: fields, link and live status', (
    tester,
  ) async {
    await start(tester);
    await create(tester);
    ctl().edit((k) => k.copyWith(totalMinor: 1000000));
    await settle(tester);
    final m = open().milestones.first;
    await tap(tester, find.byKey(ValueKey('create-invoice-${m.id}')));

    final invoices = await drive(tester, db.invoicesDao.getAll);
    final inv = invoices.firstWhere((i) => i.contractRef == 'CT-2026-0001');
    expect(inv.number, 'OM-2026-0002');
    expect(inv.clientId, client.id);
    expect(inv.status, InvoiceStatus.draft);
    final item = inv.sections.single.items.single;
    expect(item.service, 'الدفعة المقدمة');
    expect(item.unitPriceMinor, 300000);
    expect(inv.sections.single.currency.code, 'EGP');
    expect(open().milestones.first.invoiceId, inv.id);
    final stored = await drive(
      tester,
      () => db.contractsDao.getById(open().id),
    );
    expect(stored!.milestones.first.invoiceId, inv.id);

    expect(find.text('OM-2026-0002'), findsWidgets);
    await drive(
      tester,
      () => db.invoicesDao.markPaid(inv.id, inv.issueDate),
    );
    await settle(tester);
    // Shown in the milestone row and in "الفواتير المرتبطة".
    expect(find.text('مدفوعة'), findsWidgets);

    // A contract with linked invoices can't be deleted.
    expect(
      await drive(tester, () => ctl().delete(open().id)),
      isA<HasLinkedInvoices>(),
    );
  });

  testWidgets('restore from library needs a confirm; snapshot stays put', (
    tester,
  ) async {
    await start(tester);
    await create(tester);
    final first = open().clauses.first;
    ctl().editClause(first.id, (x) => x.copyWith(body: 'نص معدّل للعقد'));
    await settle(tester);

    await tap(tester, find.byIcon(Icons.more_vert).first);
    await tap(tester, find.text('استرجاع النص من المكتبة'));
    expect(find.text('استرجاع نص المكتبة؟'), findsOneWidget);
    await tap(tester, find.text('إلغاء'));
    expect(open().clauses.first.body, 'نص معدّل للعقد');

    await tap(tester, find.byIcon(Icons.more_vert).first);
    await tap(tester, find.text('استرجاع النص من المكتبة'));
    await tap(tester, find.byKey(const ValueKey('confirm-restore')));
    expect(open().clauses.first.body, contains('يلتزم الطرف الأول بتصميم'));
    await finish(tester);
  });

  testWidgets('client with a contract: delete asks, counting the contract', (
    tester,
  ) async {
    await start(tester);
    await drive(
      tester,
      () => db.clientsDao.upsert(const Client(id: 'beta', name: 'Beta Co')),
    );
    final t = await template(tester, quoteTemplateName);
    await drive(
      tester,
      () => ctl().create(NewContractRequest(clientId: 'beta', template: t)),
    );
    await settle(tester);
    await tester.tap(
      find.descendant(of: find.byType(Sidebar), matching: find.text('Beta Co')),
      buttons: kSecondaryButton,
    );
    await settle(tester);
    await tester.tap(find.text('حذف العميل').last);
    await settle(tester);
    expect(find.text('Beta Co عنده فواتير'), findsOneWidget);
    expect(find.textContaining('عقد واحد'), findsWidgets);
    await tap(tester, find.byKey(const ValueKey('archive-client')));
    expect(
      find.descendant(of: find.byType(Sidebar), matching: find.text('Beta Co')),
      findsNothing,
    );
    expect(c.read(contractProvider).contract, isNull);
  });
}
