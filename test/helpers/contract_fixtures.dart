import 'dart:io';

import 'package:flutter/services.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';

/// Fonts straight from the asset files (no asset bundle needed).
PdfFonts loadPdfFonts() {
  ByteData f(String w) => ByteData.sublistView(
    File('assets/fonts/IBMPlexSansArabic-$w.ttf').readAsBytesSync(),
  );
  ByteData? fn(String w) {
    final file = File('assets/fonts/NotoNaskhArabic-$w.ttf');
    return file.existsSync()
        ? ByteData.sublistView(file.readAsBytesSync())
        : null;
  }

  return PdfFonts.fromBytes(
    regular: f('Regular'),
    semiBold: f('SemiBold'),
    bold: f('Bold'),
    naskhRegular: fn('Regular'),
    naskhSemiBold: fn('SemiBold'),
    naskhBold: fn('Bold'),
  );
}

/// Fake provider and client: sample data only, no real people.
const sampleSettings = Settings(
  name: 'Sample Studio',
  role: 'المدير الفني',
  email: 'hello@provider.example',
  phone: '+20 100 000 0000',
  legalName: 'استوديو نموذج للبرمجيات',
  nationalIdOrRegistry: 'سجل تجاري رقم 000000',
  address: 'المنصورة، الدقهلية',
  docDigitStyle: DigitStyle.arabicIndic,
);

const acme = Client(
  id: 'acme',
  name: 'Acme Studio',
  email: 'legal@acme.example',
  phone: '+20 111 222 3333',
  legalName: 'شركة أكمي ستوديو للحلول الرقمية ش.ذ.م.م',
  registryNo: 'سجل تجاري رقم 123456 القاهرة',
  address: 'التجمع الخامس، القاهرة الجديدة',
  representative: 'سارة عادل',
  representativeTitle: 'المدير التنفيذي',
);

var _n = 0;
String fixtureId() => 'id-${_n++}';

ClauseTemplate seedTemplateModel(SeedTemplate t) => ClauseTemplate(
  id: fixtureId(),
  name: t.name,
  kind: TemplateKind.fromDb(t.kind),
  preamble: t.preamble,
  closing: t.closing,
  varDefaults: t.defaults,
  clauses: [
    for (final c in t.clauses)
      LibraryClause(
        id: fixtureId(),
        title: c.title,
        body: c.body,
        optional: c.optional,
        enabledByDefault: c.enabledByDefault,
      ),
  ],
);

/// Template A for Acme Studio, every variable filled.
Contract acmeContract({
  bool optionalOn = false,
  ContractStatus status = ContractStatus.sent,
}) {
  final t = seedTemplateModel(developmentTemplate);
  final clauses = [
    for (final c in clausesFromTemplate(t, fixtureId))
      c.optional ? c.copyWith(enabled: optionalOn) : c,
  ];
  return Contract(
    id: 'contract-acme',
    clientId: acme.id,
    number: 'CT-2026-0001',
    year: 2026,
    seq: 1,
    issueDate: const CalendarDate(2026, 11, 15),
    templateName: t.name,
    title: 'تطوير وتشغيل منصة تعليمية',
    projectName: 'منصة أكمي التعليمية',
    projectSummary: 'منصة ويب وتطبيق موبايل لإدارة الدورات والطلاب.',
    preamble: t.preamble,
    status: status,
    jurisdiction: 'المحكمة الاقتصادية بالقاهرة',
    totalMinor: 18000000,
    vars: {
      ...t.varDefaults,
      'revenueSharePct': '5',
      'revenueShareYears': '3',
      'escrowAgent': 'مكتب المحاماة المتفق عليه',
    },
    outOfScope:
        'كتابة المحتوى التعليمي وتصويره\n'
        'رسوم المتاجر والاستضافة والخدمات الخارجية\n'
        'أي تكاملات غير مذكورة في الجدول أعلاه',
    clauses: clauses,
    scope: const [
      ScopeItem(
        id: 's1',
        phase: 'المرحلة 1',
        item: 'التصميم',
        description: 'ثلاثة تصميمات مبدئية للواجهات الرئيسية',
        acceptance: 'اعتماد تصميم واحد كتابةً',
      ),
      ScopeItem(
        id: 's2',
        phase: 'المرحلة 2',
        item: 'لوحة التحكم',
        description: 'إدارة الدورات والطلاب والمدفوعات والتقارير',
        acceptance: 'اجتياز سيناريوهات القبول على البيئة التجريبية',
      ),
      ScopeItem(
        id: 's3',
        phase: 'المرحلة 2',
        item: 'تطبيق الموبايل',
        description: 'Android و iOS بتسجيل دخول برمز OTP',
        acceptance: 'نشر نسخة تجريبية على المتجرين',
      ),
      ScopeItem(
        id: 's4',
        phase: 'المرحلة 3',
        item: 'الإطلاق',
        description: 'التجهيز على الخوادم ونقل البيانات الأولية',
        acceptance: 'تشغيل المنصة للمستخدمين بنجاح',
      ),
    ],
    milestones: const [
      PaymentMilestone(
        id: 'm1',
        label: 'الدفعة المقدمة',
        percentBp: 3000,
        trigger: 'عند التوقيع',
      ),
      PaymentMilestone(
        id: 'm2',
        label: 'الدفعة الثانية',
        percentBp: 4000,
        trigger: 'عند قبول المرحلة 2',
      ),
      PaymentMilestone(
        id: 'm3',
        label: 'الدفعة الأخيرة',
        percentBp: 3000,
        trigger: 'عند قبول المرحلة الأخيرة',
        dueDate: CalendarDate(2027, 2, 15),
      ),
    ],
  );
}

Money get acmeTotal => const Money(18000000, Currency.egp);

/// English version of Acme contract for English preset goldens.
Contract acmeContractEn({
  bool optionalOn = false,
  ContractStatus status = ContractStatus.sent,
}) => Contract(
  id: 'contract-acme-en',
  clientId: acme.id,
  number: 'CT-2026-0001',
  year: 2026,
  seq: 1,
  issueDate: const CalendarDate(2026, 11, 15),
  templateName: 'Software Development Agreement',
  title: 'Platform Development and Maintenance',
  projectName: 'Acme Learning Platform',
  projectSummary: 'Web platform and mobile application for managing courses.',
  preamble: 'This Agreement is entered into by and between the parties.',
  status: status,
  jurisdiction: 'Cairo Economic Court',
  totalMinor: 18000000,
  outOfScope: 'Content creation\nHosting fees\nUnspecified integrations',
  clauses: const [
    ContractClause(
      id: 'c1',
      title: 'Scope of Services',
      body: 'The Provider agrees to deliver the services specified in Annex 1.',
    ),
    ContractClause(
      id: 'c2',
      title: 'Fees and Payment',
      body: 'The Client agrees to pay the fees outlined in Annex 2.',
    ),
  ],
  scope: const [
    ScopeItem(
      id: 's1',
      phase: 'Phase 1',
      item: 'Design',
      description: 'Initial UI/UX prototypes for key flows',
      acceptance: 'Written approval from Client',
    ),
    ScopeItem(
      id: 's2',
      phase: 'Phase 2',
      item: 'Development',
      description: 'Frontend and backend implementation',
      acceptance: 'Successful test runs on staging',
    ),
  ],
  milestones: const [
    PaymentMilestone(
      id: 'm1',
      label: 'Upfront deposit',
      percentBp: 5000,
      trigger: 'Upon signing',
    ),
    PaymentMilestone(
      id: 'm2',
      label: 'Final payment',
      percentBp: 5000,
      trigger: 'Upon delivery',
      dueDate: CalendarDate(2027, 2, 15),
    ),
  ],
);

ContractPdfData sampleContractData({
  DocLanguage language = DocLanguage.ar,
  ContractStatus status = ContractStatus.sent,
}) => ContractPdfData(
  contract: language == DocLanguage.en
      ? acmeContractEn(status: status)
      : acmeContract(status: status),
  client: acme,
  settings: sampleSettings,
  language: language,
);
