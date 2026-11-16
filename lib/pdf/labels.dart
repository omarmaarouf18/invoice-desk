import 'package:invoice_desk/domain/doc_language.dart';

/// Every fixed label printed on a document, in one language.
///
/// Not ARB: the document language is chosen per document and is independent
/// of the UI language (ADR-0011). Builders take [DocLabels.of] the document
/// language, and a bilingual invoice reads [en] for the main label and [ar]
/// for the small secondary one.
class DocLabels {
  const DocLabels._({
    required this.invoice,
    required this.invoiceNo,
    required this.issueDate,
    required this.dueDate,
    required this.contractRef,
    required this.paid,
    required this.billedTo,
    required this.attn,
    required this.paymentDetails,
    required this.wallet,
    required this.bankIban,
    required this.pleaseQuote,
    required this.amountsIn,
    required this.service,
    required this.description,
    required this.billing,
    required this.qty,
    required this.amount,
    required this.oneTime,
    required this.monthly,
    required this.annual,
    required this.subtotal,
    required this.notes,
    required this.vat,
    required this.vatNotApplicable,
    required this.totalDue,
    required this.dueBy,
    required this.pageOf,
    required this.scopeTitle,
    required this.scopeOverview,
    required this.scopeDone,
    required this.scopeDelivered,
    required this.scopeWarranty,
    required this.providerSignature,
    required this.clientSignature,
    required this.preamble,
    required this.contract,
    required this.quote,
    required this.amendmentOf,
    required this.draft,
    required this.firstPartyProvider,
    required this.secondPartyClient,
    required this.firstParty,
    required this.secondParty,
    required this.providerIdOrRegistry,
    required this.clientRegistryOrId,
    required this.address,
    required this.email,
    required this.phone,
    required this.representedBy,
    required this.scopeAnnex,
    required this.paymentAnnex,
    required this.integralPartOf,
    required this.noScopeYet,
    required this.phase,
    required this.item,
    required this.acceptance,
    required this.outOfScope,
    required this.totalFee,
    required this.payment,
    required this.percent,
    required this.trigger,
    required this.date,
    required this.total,
    required this.signatures,
    required this.name,
    required this.title,
    required this.signature,
    required this.stamp,
    required this.firstPartyInitials,
    required this.secondPartyInitials,
  });

  /// The labels for [lang]; bilingual documents use [en] as the main set.
  static DocLabels of(DocLanguage lang) => lang == DocLanguage.ar ? ar : en;

  // ── Invoice header ──
  final String invoice;
  final String invoiceNo;
  final String issueDate;
  final String dueDate;
  final String contractRef;

  /// Paid stamp; the date follows it.
  final String paid;

  // ── Parties ──
  final String billedTo;

  /// `Attn: name`.
  final String Function(String name) attn;
  final String paymentDetails;
  final String wallet;
  final String bankIban;

  /// `Please quote OM-2026-0001`.
  final String Function(String number) pleaseQuote;

  // ── Items table ──
  /// `Amounts in EGP`.
  final String Function(String currencyCode) amountsIn;
  final String service;
  final String description;
  final String billing;
  final String qty;
  final String amount;
  final String oneTime;
  final String monthly;
  final String annual;
  final String subtotal;

  // ── Notes and totals ──
  final String notes;
  final String vat;
  final String vatNotApplicable;
  final String totalDue;

  /// `Due by 14 Oct 2026`; the date is already formatted.
  final String Function(String date) dueBy;

  /// `Page 1 of 2`; numbers already formatted (digits applied).
  final String Function(String page, String pages) pageOf;

  // ── Scope page ──
  final String scopeTitle;
  final String scopeOverview;
  final String scopeDone;
  final String scopeDelivered;
  final String scopeWarranty;

  /// `Provider's signature — name`.
  final String Function(String name) providerSignature;
  final String Function(String name) clientSignature;

  // ── Contract ──
  final String preamble;

  /// `Contract` / `عقد` (the title follows).
  final String contract;
  final String quote;

  /// `Amendment 1 to CT-2026-0001`.
  final String Function(int no, String number) amendmentOf;
  final String draft;
  final String firstPartyProvider;
  final String secondPartyClient;
  final String firstParty;
  final String secondParty;
  final String providerIdOrRegistry;
  final String clientRegistryOrId;
  final String address;
  final String email;
  final String phone;
  final String representedBy;
  final String scopeAnnex;
  final String paymentAnnex;

  /// `An integral part of CT-2026-0001`.
  final String Function(String number) integralPartOf;
  final String noScopeYet;
  final String phase;
  final String item;
  final String acceptance;
  final String outOfScope;
  final String totalFee;
  final String payment;
  final String percent;
  final String trigger;
  final String date;
  final String total;
  final String signatures;
  final String name;
  final String title;
  final String signature;
  final String stamp;
  final String firstPartyInitials;
  final String secondPartyInitials;

  /// English labels. Invoice labels are exactly what 0.4 printed.
  static final en = DocLabels._(
    invoice: 'INVOICE',
    invoiceNo: 'Invoice No.',
    issueDate: 'Issue date',
    dueDate: 'Due date',
    contractRef: 'Contract ref.',
    paid: 'PAID',
    billedTo: 'BILLED TO',
    attn: (n) => 'Attn: $n',
    paymentDetails: 'PAYMENT DETAILS',
    wallet: 'Wallet',
    bankIban: 'Bank / IBAN',
    pleaseQuote: (n) => 'Please quote $n',
    amountsIn: (c) => 'Amounts in $c',
    service: 'SERVICE',
    description: 'DESCRIPTION',
    billing: 'BILLING',
    qty: 'QTY',
    amount: 'AMOUNT',
    oneTime: 'One-time',
    monthly: 'Monthly',
    annual: 'Annual',
    subtotal: 'Subtotal',
    notes: 'NOTES',
    vat: 'VAT',
    vatNotApplicable: 'Not applicable',
    totalDue: 'Total due',
    dueBy: (d) => 'Due by $d',
    pageOf: (p, n) => 'Page $p of $n',
    scopeTitle: 'Project scope',
    scopeOverview: 'Overview',
    scopeDone: 'What was done',
    scopeDelivered: 'What the client receives',
    scopeWarranty: 'Warranty and support',
    providerSignature: (n) => 'Provider signature — $n',
    clientSignature: (n) => 'Client signature — $n',
    preamble: 'Preamble',
    contract: 'Contract',
    quote: 'Quotation',
    amendmentOf: (no, n) => 'Amendment No. $no to contract $n',
    draft: 'DRAFT',
    firstPartyProvider: 'First party (service provider)',
    secondPartyClient: 'Second party (client)',
    firstParty: 'First party',
    secondParty: 'Second party',
    providerIdOrRegistry: 'National ID / commercial registry',
    clientRegistryOrId: 'Commercial registry / national ID',
    address: 'Address',
    email: 'Email',
    phone: 'Phone',
    representedBy: 'Represented by',
    scopeAnnex: 'Annex (1): Scope of work',
    paymentAnnex: 'Annex (2): Fees and payments',
    integralPartOf: (n) => 'An integral part of $n',
    noScopeYet: 'No scope items yet.',
    phase: 'Phase',
    item: 'Item',
    acceptance: 'Acceptance criteria',
    outOfScope: 'Out of scope',
    totalFee: 'Total fee',
    payment: 'Payment',
    percent: 'Share',
    trigger: 'Due on',
    date: 'Date',
    total: 'Total',
    signatures: 'Signatures',
    name: 'Name',
    title: 'Title',
    signature: 'Signature',
    stamp: 'Stamp',
    firstPartyInitials: 'First party initials',
    secondPartyInitials: 'Second party initials',
  );

  /// Arabic labels. Contract and scope-page labels are exactly what 0.4
  /// printed.
  static final ar = DocLabels._(
    invoice: 'فاتورة',
    invoiceNo: 'رقم الفاتورة',
    issueDate: 'تاريخ الإصدار',
    dueDate: 'تاريخ الاستحقاق',
    contractRef: 'مرجع العقد',
    paid: 'مدفوعة',
    billedTo: 'العميل',
    attn: (n) => 'عناية: $n',
    paymentDetails: 'بيانات الدفع',
    wallet: 'محفظة',
    bankIban: 'بنك / IBAN',
    pleaseQuote: (n) => 'يرجى ذكر رقم الفاتورة $n',
    amountsIn: (c) => 'المبالغ بعملة $c',
    service: 'الخدمة',
    description: 'الوصف',
    billing: 'الفوترة',
    qty: 'الكمية',
    amount: 'المبلغ',
    oneTime: 'مرة واحدة',
    monthly: 'شهري',
    annual: 'سنوي',
    subtotal: 'الإجمالي الفرعي',
    notes: 'ملاحظات',
    vat: 'ضريبة القيمة المضافة',
    vatNotApplicable: 'لا تنطبق',
    totalDue: 'الإجمالي المستحق',
    dueBy: (d) => 'مستحقة السداد في $d',
    pageOf: (p, n) => 'صفحة $p من $n',
    scopeTitle: 'نطاق المشروع',
    scopeOverview: 'نظرة عامة',
    scopeDone: 'ما تم تنفيذه',
    scopeDelivered: 'ما يستلمه العميل',
    scopeWarranty: 'الضمان والدعم',
    providerSignature: (n) => 'توقيع مقدم الخدمة — $n',
    clientSignature: (n) => 'توقيع العميل — $n',
    preamble: 'تمهيد',
    contract: 'عقد',
    quote: 'عرض سعر',
    amendmentOf: (no, n) => 'ملحق تعديل رقم $no للعقد $n',
    draft: 'مسودة',
    firstPartyProvider: 'الطرف الأول (مقدم الخدمة)',
    secondPartyClient: 'الطرف الثاني (العميل)',
    firstParty: 'الطرف الأول',
    secondParty: 'الطرف الثاني',
    providerIdOrRegistry: 'رقم قومي / سجل تجاري',
    clientRegistryOrId: 'سجل تجاري / رقم قومي',
    address: 'العنوان',
    email: 'البريد الإلكتروني',
    phone: 'الهاتف',
    representedBy: 'يمثله',
    scopeAnnex: 'ملحق (1) نطاق العمل',
    paymentAnnex: 'ملحق (2) المقابل والدفعات',
    integralPartOf: (n) => 'جزء لا يتجزأ من $n',
    noScopeYet: 'لم تُحدد بنود النطاق بعد.',
    phase: 'المرحلة',
    item: 'البند',
    acceptance: 'معيار القبول',
    outOfScope: 'خارج النطاق',
    totalFee: 'إجمالي المقابل',
    payment: 'الدفعة',
    percent: 'النسبة',
    trigger: 'الاستحقاق',
    date: 'التاريخ',
    total: 'الإجمالي',
    signatures: 'التوقيعات',
    name: 'الاسم',
    title: 'الصفة',
    signature: 'التوقيع',
    stamp: 'الختم',
    firstPartyInitials: 'توقيع الطرف الأول',
    secondPartyInitials: 'توقيع الطرف الثاني',
  );
}
