part of 'demo_seed.dart';

/// Contracts, the postponement and reminders of the demo set.
extension _DemoContracts on _DemoSeed {
  // ── Contracts ────────────────────────────────────────────────────────

  Future<String> _ctNumber(int seq, CalendarDate d, {int amendment = 0}) =>
      Future.value(
        formatContractNumber('DEMO-CT', d.year, seq, amendmentNo: amendment),
      );

  Future<void> _contracts(List<Client> c, Map<String, Invoice> inv) async {
    final [acme, _, delta, _, academy] = c;
    final templates = await db.libraryDao.getAll();
    final dev = templates.firstWhere(
      (x) => x.name == developmentTemplateName,
      orElse: () => templates.first,
    );
    Contract base(Client client, CalendarDate issue, String title) {
      final seq = _ctSeq++;
      return Contract(
        id: id(),
        clientId: client.id,
        number: formatContractNumber('DEMO-CT', issue.year, seq),
        year: issue.year,
        seq: seq,
        issueDate: issue,
        templateName: dev.name,
        title: title,
        preamble: dev.preamble,
        closing: dev.closing,
        jurisdiction: 'المحكمة الاقتصادية المختصة',
        vars: {...dev.varDefaults},
        clauses: clausesFromTemplate(dev, id),
        isDemo: true,
      );
    }

    // 1. Draft with a missing variable (durationWeeks left blank).
    final draft = base(academy, t.addDays(-2), 'تطبيق الطلاب');
    await db.contractsDao.saveContract(
      draft.copyWith(
        projectName: 'تطبيق الطلاب',
        vars: {...draft.vars, 'durationWeeks': ''},
        totalMinor: 9000000,
        milestones: [
          PaymentMilestone(id: id(), label: 'مقدم', percentBp: 5000),
          PaymentMilestone(id: id(), label: 'عند التسليم', percentBp: 5000),
        ],
      ),
    );

    // 2. Signed: two milestones invoiced, one upcoming, one overdue; ends
    // in three weeks.
    final signed = base(delta, t.addDays(-27), 'نظام حجز العيادات');
    final m1 = await invoice(
      delta,
      issue: t.addDays(-25),
      due: t.addDays(-18),
      paid: t.addDays(-19),
      status: InvoiceStatus.paid,
      contractRef: signed.number,
      sections: [
        section(Currency.egp, 'Contract', 'العقد', [
          item('الدفعة المقدمة', 36000),
        ]),
      ],
    );
    final m2 = await invoice(
      delta,
      issue: t.addDays(-4),
      due: t.addDays(10),
      contractRef: signed.number,
      sections: [
        section(Currency.egp, 'Contract', 'العقد', [
          item('تسليم المرحلة الأولى', 36000),
        ]),
      ],
    );
    inv['m1'] = m1;
    inv['m2'] = m2;
    await db.contractsDao.saveContract(
      signed.copyWith(
        projectName: 'نظام حجز العيادات',
        status: ContractStatus.signed,
        signedDate: () => t.addDays(-26),
        startDate: () => t.addDays(-25),
        endDate: () => t.addDays(21),
        totalMinor: 12000000,
        milestones: [
          PaymentMilestone(
            id: id(),
            label: 'الدفعة المقدمة',
            percentBp: 3000,
            trigger: 'عند التوقيع',
            dueDate: t.addDays(-18),
            invoiceId: m1.id,
          ),
          PaymentMilestone(
            id: id(),
            label: 'تسليم المرحلة الأولى',
            percentBp: 3000,
            dueDate: t.addDays(10),
            invoiceId: m2.id,
          ),
          PaymentMilestone(
            id: id(),
            label: 'تسليم المرحلة الثانية',
            percentBp: 2000,
            dueDate: t.addDays(18),
          ),
          PaymentMilestone(
            id: id(),
            label: 'دفعة الاختبارات',
            percentBp: 2000,
            dueDate: t.addDays(-4),
          ),
        ],
      ),
    );

    // 3. Completed, with a signed amendment.
    final done = base(acme, t.addDays(-210), 'إعادة تصميم الموقع');
    await db.contractsDao.saveContract(
      done.copyWith(
        projectName: 'موقع Acme Studio',
        status: ContractStatus.completed,
        signedDate: () => t.addDays(-205),
        startDate: () => t.addDays(-200),
        endDate: () => t.addDays(-30),
        totalMinor: 4500000,
        vars: {...done.vars, 'warrantyMonths': '3'},
      ),
    );
    final amendDate = t.addDays(-90);
    await db.contractsDao.saveContract(
      done.copyWith(
        id: id(),
        number: await _ctNumber(done.seq, done.issueDate, amendment: 1),
        kind: ContractKind.amendment,
        amendmentNo: 1,
        parentId: () => done.id,
        title: 'تعديل: إضافة المدونة',
        issueDate: amendDate,
        status: ContractStatus.signed,
        signedDate: () => amendDate,
        startDate: () => null,
        endDate: () => null,
        totalMinor: 600000,
        clauses: clausesFromTemplate(dev, id),
      ),
    );
  }

  // ── Postponement and reminders ────────────────────────────────────────

  Future<void> _reminders(List<Client> c, Map<String, Invoice> inv) async {
    final postponed = inv['postponed']!;
    await db.calendarDao.addPostponement(
      Postponement(
        id: id(),
        entityType: PostponedEntity.invoice,
        entityId: postponed.id,
        fromDate: postponed.dueDate,
        toDate: t.addDays(7),
        reason: 'طلب العميل مهلة حتى صرف دفعة القضية',
      ),
    );
    final overdue = inv['overdue']!;
    final reminders = [
      Reminder(
        id: id(),
        date: t.addDays(1),
        time: '10:00',
        text: 'اتصال بمخبز النيل بخصوص الفاتورة المتأخرة',
        clientId: c[1].id,
        linkType: ReminderLink.invoice,
        linkId: overdue.id,
        isDemo: true,
      ),
      Reminder(
        id: id(),
        date: t.addDays(12),
        text: 'Review Delta Clinics contract before it ends',
        clientId: c[2].id,
        isDemo: true,
      ),
      Reminder(
        id: id(),
        date: t.addDays(-2),
        text: 'إرسال عرض سعر لأكاديمية Bright Path',
        clientId: c[4].id,
        doneAt: clock.now().toUtc().millisecondsSinceEpoch,
        isDemo: true,
      ),
    ];
    for (final r in reminders) {
      await db.calendarDao.saveReminder(r);
    }
  }
}
