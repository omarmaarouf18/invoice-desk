import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

/// Default payment schedule of a new contract (30/40/30) or quote (50/50).
/// Percentages, so they follow the total as it changes.
List<PaymentMilestone> defaultMilestones(
  TemplateKind kind,
  String Function() newId,
) => switch (kind) {
  TemplateKind.contract => [
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة المقدمة',
      percentBp: 3000,
      trigger: 'عند التوقيع',
    ),
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة الثانية',
      percentBp: 4000,
      trigger: 'عند قبول المرحلة 1',
    ),
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة الأخيرة',
      percentBp: 3000,
      trigger: 'عند التسليم النهائي',
    ),
  ],
  TemplateKind.quote => [
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة المقدمة',
      percentBp: 5000,
      trigger: 'عند الموافقة على العرض',
    ),
    PaymentMilestone(
      id: newId(),
      label: 'الدفعة الأخيرة',
      percentBp: 5000,
      trigger: 'عند التسليم',
    ),
  ],
};

/// Amendment number [no] of [root]: same series/year/seq, numbered
/// `<root>-A<no>`, one blank clause titled [clauseTitle], empty annexes.
/// [prefix] is the series prefix from settings; a root numbered by hand
/// with another prefix keeps its own.
Contract buildAmendment({
  required Contract root,
  required int no,
  required String prefix,
  required CalendarDate today,
  required String preamble,
  required String clauseTitle,
  required String Function() newId,
}) => Contract(
  id: newId(),
  clientId: root.clientId,
  number: formatContractNumber(
    root.number.startsWith('$prefix-') ? prefix : root.number.split('-').first,
    root.year,
    root.seq,
    amendmentNo: no,
  ),
  series: root.series,
  year: root.year,
  seq: root.seq,
  amendmentNo: no,
  parentId: root.id,
  kind: ContractKind.amendment,
  templateName: root.templateName,
  title: root.title,
  projectName: root.projectName,
  projectSummary: root.projectSummary,
  preamble: preamble,
  issueDate: today,
  jurisdiction: root.jurisdiction,
  currency: root.currency,
  vars: {...root.vars},
  clauses: [ContractClause(id: newId(), title: clauseTitle)],
);

/// A draft invoice for milestone [index] of [c]: one section in the
/// contract's currency, the milestone label as the service, its amount
/// (largest-remainder split), and `contractRef` = the contract number.
/// Null when the milestone has no amount.
Invoice? invoiceForMilestone({
  required Contract c,
  required int index,
  required int seq,
  required CalendarDate today,
  required Settings settings,
  required String Function() newId,
}) {
  final amount = milestoneAmounts(c.totalMinor, c.milestones)[index];
  if (amount <= 0) return null;
  final m = c.milestones[index];
  return Invoice(
    id: newId(),
    clientId: c.clientId,
    number: formatInvoiceNumber(settings.invoicePrefix, today.year, seq),
    year: today.year,
    seq: seq,
    issueDate: today,
    dueDate: m.dueDate ?? today.addDays(settings.defaultDueDays),
    contractRef: c.number,
    notesEn: settings.notesEn,
    notesAr: settings.notesAr,
    sections: [
      InvoiceSection(
        id: newId(),
        currency: c.currency,
        titleAr: c.projectName,
        items: [
          LineItem(
            id: newId(),
            service: m.label.trim().isEmpty ? c.number : m.label.trim(),
            description: [
              c.projectName.trim(),
              m.trigger.trim(),
            ].where((e) => e.isNotEmpty).join(' — '),
            unitPriceMinor: amount,
          ),
        ],
      ),
    ],
  );
}
