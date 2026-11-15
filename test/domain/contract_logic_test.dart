import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';

import '../helpers/contract_fixtures.dart';

void main() {
  group('variables', () {
    final c = acmeContract();
    VariableResolver r(Contract c, {Client? client = acme}) =>
        VariableResolver(contract: c, client: client, settings: sampleSettings);

    test('known variables come from settings, client and contract', () {
      final v = r(c);
      expect(v.resolve('provider.legalName'), 'استوديو نموذج للبرمجيات');
      expect(v.resolve('provider.id'), 'سجل تجاري رقم 000000');
      expect(v.resolve('client.representative'), 'سارة عادل');
      expect(v.resolve('contract.number'), 'CT-2026-0001');
      expect(v.resolve('contract.date'), '15 نوفمبر 2026');
      expect(v.resolve('project.name'), 'منصة أكمي التعليمية');
      expect(v.resolve('total'), '180,000 جنيه مصري');
      expect(v.resolve('currency'), 'جنيه مصري');
      expect(v.resolve('jurisdiction'), 'المحكمة الاقتصادية بالقاهرة');
    });

    test('legal names fall back to the display name', () {
      final v = r(
        c,
        client: const Client(id: 'x', name: 'Beta'),
      );
      expect(v.resolve('client.legalName'), 'Beta');
      expect(v.resolve('client.representative'), isNull);
    });

    test('custom variables come from the contract; empty is missing', () {
      expect(r(c).resolve('durationWeeks'), '10');
      final blank = c.copyWith(vars: {...c.vars, 'durationWeeks': '  '});
      expect(r(blank).resolve('durationWeeks'), isNull);
      expect(r(c).resolve('neverDefined'), isNull);
    });

    test('used/custom/missing follow the enabled clauses only', () {
      expect(
        customVariablesUsed(c),
        containsAll(['designOptions', 'durationWeeks']),
      );
      // Optional clauses are off: their variables are not used.
      expect(customVariablesUsed(c), isNot(contains('escrowAgent')));
      expect(r(c).missing(), isEmpty);

      final on = acmeContract(optionalOn: true).copyWith(vars: const {});
      final missing = r(on).missing();
      expect(missing.first, 'designOptions');
      expect(missing, contains('escrowAgent'));
      expect(missing, isNot(contains('client.legalName')));
    });

    test('segments keep missing names visible and never store values', () {
      final v = r(c.copyWith(vars: const {}));
      final segs = v.segments(
        'مدة {{durationWeeks}} أسبوعًا لـ {{client.name}}',
      );
      expect(
        segs.map((s) => s.text).join(),
        'مدة {{durationWeeks}} أسبوعًا لـ Acme Studio',
      );
      expect(segs.where((s) => s.missing).single.variable, 'durationWeeks');
      expect(variablesIn('{{ a.b }} {{c}} {{a.b}}'), ['a.b', 'c']);
    });
  });

  test('body: "- " lines become numbered sub-items', () {
    final blocks = parseBody('مقدمة\n- أولًا\n- ثانيًا\n\nخاتمة');
    expect(blocks, hasLength(3));
    expect((blocks[1] as SubItemsBlock).items, ['أولًا', 'ثانيًا']);
    expect(subItemLabel(2, western: false), '٢.');
    expect(subItemLabel(12, western: true), '12.');
  });

  test('Arabic ordinals 1–30', () {
    expect(arabicOrdinal(1), 'الأول');
    expect(arabicOrdinal(10), 'العاشر');
    expect(arabicOrdinal(11), 'الحادي عشر');
    expect(arabicOrdinal(12), 'الثاني عشر');
    expect(arabicOrdinal(20), 'العشرون');
    expect(arabicOrdinal(21), 'الحادي والعشرون');
    expect(arabicOrdinal(25), 'الخامس والعشرون');
    expect(arabicOrdinal(30), 'الثلاثون');
  });

  test('numbering: CT, QT and amendment suffixes', () {
    expect(formatContractNumber('CT', 2026, 3), 'CT-2026-0003');
    expect(formatContractNumber('QT', 2026, 12), 'QT-2026-0012');
    expect(
      formatContractNumber('CT', 2026, 3, amendmentNo: 1),
      'CT-2026-0003-A1',
    );
  });

  group('milestones', () {
    PaymentMilestone pct(int bp) => PaymentMilestone(id: '$bp', percentBp: bp);

    test('largest remainder makes 3 × 33.33% add up to the total', () {
      final ms = [pct(3333), pct(3333), pct(3334)];
      final a = milestoneAmounts(10000, ms);
      expect(a.reduce((x, y) => x + y), 10000);
      expect(a, [3333, 3333, 3334]);
      // A total that doesn't divide evenly still sums exactly.
      final b = milestoneAmounts(10001, [pct(3334), pct(3333), pct(3333)]);
      expect(b.reduce((x, y) => x + y), 10001);
    });

    test('fixed amounts mix with percentages', () {
      final ms = [
        const PaymentMilestone(id: 'a', amountMinor: 2500000),
        pct(5000),
      ];
      final c = acmeContract().copyWith(milestones: ms);
      final check = checkMilestones(c);
      expect(check.amounts, [2500000, 9000000]);
      expect(check.balanced, isFalse);
      expect(check.difference, 18000000 - 11500000);
    });

    test('100% balances; 90% warns', () {
      expect(checkMilestones(acmeContract()).balanced, isTrue);
      final off = acmeContract().copyWith(milestones: [pct(4000), pct(5000)]);
      final check = checkMilestones(off);
      expect(check.balanced, isFalse);
      expect(check.percentSumBp, 9000);
    });
  });

  test('locking and status rules', () {
    final c = acmeContract(status: ContractStatus.signed);
    expect(c.isLocked, isTrue);
    expect(c.copyWith(unlocked: true).isLocked, isFalse);
    expect(ContractStatus.sent.needsResolvedVariables, isTrue);
    expect(ContractStatus.cancelled.needsResolvedVariables, isFalse);
    expect(ContractStatus.active.isInForce, isTrue);
  });

  test('line diff marks removed and added lines', () {
    final d = lineDiff('أ\nب\nج', 'أ\nد\nج');
    expect(d, [
      (DiffOp.same, 'أ'),
      (DiffOp.removed, 'ب'),
      (DiffOp.added, 'د'),
      (DiffOp.same, 'ج'),
    ]);
  });

  test('contract money in Arabic words', () {
    expect(formatContractMoney(18000000, Currency.egp), '180,000 جنيه مصري');
    expect(formatContractMoney(25050, Currency.usd), '250.50 دولار أمريكي');
    expect(
      formatArabicDate(const CalendarDate(2026, 11, 15)),
      '15 نوفمبر 2026',
    );
  });
}
