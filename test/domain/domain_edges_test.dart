import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/results.dart';
import 'package:invoice_desk/domain/trash.dart';

import '../helpers/contract_fixtures.dart';

void main() {
  var n = 0;
  String id() => 'x${n++}';

  test('enums round-trip through their stored values', () {
    for (final s in InvoiceStatus.values) {
      expect(InvoiceStatus.fromDb(s.dbValue), s);
    }
    for (final c in BillingCycle.values) {
      expect(BillingCycle.fromDb(c.dbValue), c);
    }
    for (final k in TemplateKind.values) {
      expect(TemplateKind.fromDb(k.dbValue), k);
    }
    for (final k in ContractKind.values) {
      expect(ContractKind.fromDb(k.dbValue), k);
    }
    for (final s in ContractStatus.values) {
      expect(ContractStatus.fromDb(s.dbValue), s);
    }
    expect(BillingCycle.monthly.isRecurring, isTrue);
    expect(BillingCycle.oneTime.isRecurring, isFalse);
  });

  test('copyWith replaces only what is given; equality follows values', () {
    const s = Settings(name: 'A');
    final s2 = s.copyWith(
      role: 'r',
      city: 'c',
      email: 'e',
      phone: 'p',
      website: 'w',
      invoicePrefix: 'X',
      defaultDueDays: 7,
      instapay: 'i',
      wallet: 'wa',
      bankIban: 'b',
      notesEn: 'ne',
      notesAr: 'na',
      backupDir: '/b',
      lastBackupAt: 5,
      legalName: 'L',
      nationalIdOrRegistry: 'N',
      address: 'Ad',
      contractPrefix: 'K',
      quotePrefix: 'Q',
      defaultJurisdiction: 'J',
      contractWesternDigits: true,
    );
    expect(s2.name, 'A');
    expect(
      [s2.invoicePrefix, s2.contractPrefix, s2.quotePrefix],
      [
        'X',
        'K',
        'Q',
      ],
    );
    expect(s2.contractWesternDigits, isTrue);
    expect(s2.hasProfile, isTrue);
    expect(const Settings().hasProfile, isFalse);

    const c = Client(id: '1', name: 'A');
    final c2 = c.copyWith(
      contact: 'k',
      city: 'c',
      phone: 'p',
      email: 'e',
      archived: true,
      legalName: 'L',
      registryNo: 'R',
      address: 'Ad',
      representative: 'Rep',
      representativeTitle: 'T',
    );
    expect(c2.id, '1');
    expect(c2 == c, isFalse);
    expect(c2, c2.copyWith());
    expect(c2.hashCode, c2.copyWith().hashCode);

    const item = LineItem(id: 'i');
    final item2 = item.copyWith(
      id: 'j',
      service: 's',
      description: 'd',
      cycle: BillingCycle.annual,
      qty: 2,
      unitPriceMinor: 300,
    );
    expect(item.isBlank, isTrue);
    expect(item2.lineMinor, 600);

    const sec = InvoiceSection(id: 's', currency: Currency.egp);
    final sec2 = sec.copyWith(
      id: 't',
      titleEn: 'E',
      titleAr: 'ع',
      currency: Currency.usd,
      items: [item2],
    );
    expect(sec2.subtotal, const Money(600, Currency.usd));

    const scope = ScopePage();
    final scope2 = scope.copyWith(
      enabled: true,
      title: 't',
      overview: 'o',
      done: 'd',
      delivered: 'dl',
      warranty: 'w',
    );
    expect(scope2.enabled, isTrue);
    expect(splitLines(' a \n\n b '), ['a', 'b']);
  });

  test('invoice derived values, cloning and validation', () {
    const today = CalendarDate(2026, 11, 15);
    final inv = Invoice(
      id: 'i',
      clientId: '',
      number: '',
      year: 2026,
      seq: 1,
      issueDate: today,
      dueDate: today.addDays(-1),
      status: InvoiceStatus.sent,
      vatOn: true,
      sections: const [
        InvoiceSection(
          id: 's',
          currency: Currency.egp,
          items: [LineItem(id: 'l', unitPriceMinor: 10000)],
        ),
      ],
    );
    expect(inv.totals.vat.of(Currency.egp), 1400);
    expect(inv.displayStatus(today), DisplayStatus.overdue);
    expect(
      inv.copyWith(status: InvoiceStatus.voided).displayStatus(today),
      DisplayStatus.voided,
    );
    final cloned = cloneSections(inv.sections, id);
    expect(cloned.single.id, isNot('s'));
    expect(cloned.single.items.single.unitPriceMinor, 10000);
    expect(renewalSections(inv.sections, id), isNull);
    expect(
      validateInvoice(inv, numberTaken: (_, _) => false),
      {InvoiceIssue.missingClient, InvoiceIssue.emptyNumber},
    );
    expect(
      validateInvoice(
        inv.copyWith(clientId: 'c', number: 'OM-2026-0001'),
        numberTaken: (_, _) => true,
      ),
      {InvoiceIssue.duplicateNumber},
    );
    expect(parseInvoiceNumber('free text'), isNull);
    expect(nextSeq(const [(year: 2025, seq: 9)], 2026), 1);
  });

  test('contract models: copyWith, events, locking', () {
    const lib = LibraryClause(id: 'l');
    expect(
      lib
          .copyWith(
            id: 'm',
            title: 't',
            body: 'b',
            optional: true,
            enabledByDefault: false,
          )
          .optional,
      isTrue,
    );
    const t = ClauseTemplate(id: 't', name: 'T');
    final t2 = t.copyWith(
      name: 'U',
      kind: TemplateKind.quote,
      archived: true,
      preamble: 'p',
      closing: 'c',
      varDefaults: {'a': '1'},
      clauses: [lib],
    );
    expect(t2.kind, TemplateKind.quote);
    expect(t2.clauses, hasLength(1));

    const cl = ContractClause(id: 'c', fromLibraryClauseId: 'l');
    expect(
      cl.copyWith(fromLibraryClauseId: () => null).fromLibraryClauseId,
      isNull,
    );
    const sc = ScopeItem(id: 's');
    expect(sc.isBlank, isTrue);
    expect(
      sc
          .copyWith(
            id: 'u',
            phase: 'p',
            item: 'i',
            description: 'd',
            acceptance: 'a',
          )
          .isBlank,
      isFalse,
    );
    const m = PaymentMilestone(id: 'm', amountMinor: 5);
    expect(m.isFixed, isTrue);
    expect(m.copyWith(amountMinor: () => null).isFixed, isFalse);
    expect(
      const ContractEvent(at: 7, event: 'unlock').toJson(),
      {'at': 7, 'event': 'unlock'},
    );

    final c = acmeContract();
    final c2 = c.copyWith(
      number: 'CT-2026-0009',
      series: TemplateKind.quote,
      year: 2027,
      seq: 9,
      amendmentNo: 1,
      parentId: () => 'p',
      kind: ContractKind.amendment,
      templateName: 'tn',
      title: 'ti',
      projectName: 'pn',
      projectSummary: 'ps',
      preamble: 'pr',
      closing: 'cl',
      issueDate: const CalendarDate(2027, 1, 1),
      startDate: () => const CalendarDate(2027, 1, 2),
      signedDate: () => const CalendarDate(2027, 1, 3),
      endDate: () => const CalendarDate(2027, 6, 1),
      status: ContractStatus.completed,
      jurisdiction: 'j',
      currency: Currency.usd,
      totalMinor: 100,
      vars: const {},
      outOfScope: 'o',
      unlocked: true,
      history: const [ContractEvent(at: 1, event: 'unlock')],
      createdAt: 1,
      updatedAt: 2,
    );
    expect(c2.isAmendment, isTrue);
    expect(c2.isQuote, isTrue);
    expect(c2.isLocked, isFalse);
    expect(c2.total, const Money(100, Currency.usd));
    final clone = cloneContractParts(c2, id);
    expect(clone.clauses.first.id, isNot(c2.clauses.first.id));
    expect(clone.milestones.every((x) => x.invoiceId == null), isTrue);
  });

  test('contract logic edge cases', () {
    for (final c in Currency.values) {
      expect(currencyNameAr(c), isNotEmpty);
    }
    expect(arabicOrdinal(0), '0');
    expect(arabicOrdinal(31), '31');
    expect(arabicOrdinal(15), 'الخامس عشر');
    final r = VariableResolver(
      contract: acmeContract().copyWith(totalMinor: 0),
      client: null,
      settings: const Settings(name: 'N'),
    );
    expect(r.resolve('total'), isNull);
    expect(r.resolve('client.name'), isNull);
    expect(r.resolve('provider.legalName'), 'N');
    expect(r.resolveText('{{provider.name}} / {{missing}}'), 'N / {{missing}}');
    final base = acmeContract();
    expect(validateContract(base, numberTaken: false), isEmpty);
    expect(
      validateContract(
        base.copyWith(number: ' ', clientId: ''),
        numberTaken: false,
      ),
      {ContractIssue.missingClient, ContractIssue.emptyNumber},
    );
    expect(
      validateContract(base, numberTaken: true),
      {ContractIssue.duplicateNumber},
    );
    expect(lineDiff('a\nb\nc', 'a'), [
      (DiffOp.same, 'a'),
      (DiffOp.removed, 'b'),
      (DiffOp.removed, 'c'),
    ]);
    expect(lineDiff('a', 'a\nb'), [(DiffOp.same, 'a'), (DiffOp.added, 'b')]);
    expect(milestoneAmounts(1000, const [PaymentMilestone(id: 'e')]), [0]);
    expect(parseBody(''), isEmpty);
  });

  test('results and trash entries', () {
    expect(const DuplicateNumber('X').number, 'X');
    expect(const Deleted('CT', 5).stamp, 5);
    expect(const HasLinkedInvoices(2).count, 2);
    expect(const NotFound(), isA<DeleteResult>());
    expect(const Saved(), isA<SaveResult>());
    expect(const Restored(3).count, 3);
    expect(const NeedsClient('A').clientName, 'A');
    expect(const NotInTrash(), isA<RestoreResult>());
    const e = TrashEntry(
      kind: TrashKind.invoice,
      id: 'i',
      label: 'OM-1',
      deletedAt: 0,
    );
    expect(e.clientDeleted, isFalse);
    expect(e.clientName, '');
  });
}
