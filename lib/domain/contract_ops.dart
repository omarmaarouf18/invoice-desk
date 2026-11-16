import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

/// Default payment schedule of a new contract (30/40/30) or quote (50/50),
/// labelled in [language] (Arabic unless given). Percentages, so they follow
/// the total as it changes.
List<PaymentMilestone> defaultMilestones(
  TemplateKind kind,
  String Function() newId, {
  DocLanguage language = DocLanguage.ar,
}) {
  final ar = language == DocLanguage.ar;
  PaymentMilestone m(
    String labelAr,
    String labelEn,
    int bp,
    String trAr,
    String trEn,
  ) => PaymentMilestone(
    id: newId(),
    label: ar ? labelAr : labelEn,
    percentBp: bp,
    trigger: ar ? trAr : trEn,
  );
  return switch (kind) {
    TemplateKind.contract => [
      m('الدفعة المقدمة', 'Advance payment', 3000, 'عند التوقيع', 'On signing'),
      m(
        'الدفعة الثانية',
        'Second payment',
        4000,
        'عند قبول المرحلة 1',
        'On acceptance of phase 1',
      ),
      m(
        'الدفعة الأخيرة',
        'Final payment',
        3000,
        'عند التسليم النهائي',
        'On final delivery',
      ),
    ],
    TemplateKind.quote => [
      m(
        'الدفعة المقدمة',
        'Advance payment',
        5000,
        'عند الموافقة على العرض',
        'On acceptance of the quote',
      ),
      m('الدفعة الأخيرة', 'Final payment', 5000, 'عند التسليم', 'On delivery'),
    ],
  };
}

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
