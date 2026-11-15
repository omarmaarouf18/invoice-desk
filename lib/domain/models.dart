import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:meta/meta.dart';

/// Stored lifecycle of an invoice; overdue is derived, not stored.
enum InvoiceStatus {
  /// Being written.
  draft('draft'),

  /// Sent and unpaid.
  sent('sent'),

  /// Paid; has a paid date.
  paid('paid'),

  /// Cancelled; kept so its number is never reused.
  voided('void');

  const InvoiceStatus(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Inverse of [dbValue]; throws on unknown values.
  static InvoiceStatus fromDb(String v) =>
      InvoiceStatus.values.firstWhere((s) => s.dbValue == v);
}

/// What the UI shows: status plus the derived overdue state.
enum DisplayStatus {
  /// Not sent yet.
  draft,

  /// Sent, not yet due.
  sent,

  /// Sent and past its due date (derived, never stored).
  overdue,

  /// Paid.
  paid,

  /// Cancelled; kept for numbering.
  voided,
}

/// How often a line item is billed; renewals keep only recurring ones.
enum BillingCycle {
  /// Billed once.
  oneTime('one-time'),

  /// Renews monthly.
  monthly('monthly'),

  /// Renews yearly.
  annual('annual');

  const BillingCycle(this.dbValue);

  /// Stored value (CHECK-constrained in the schema).
  final String dbValue;

  /// Monthly or annual.
  bool get isRecurring => this != BillingCycle.oneTime;

  /// Inverse of [dbValue]; throws on unknown values.
  static BillingCycle fromDb(String v) =>
      BillingCycle.values.firstWhere((s) => s.dbValue == v);
}

@immutable
/// The provider's profile and defaults (one row).
class Settings {
  /// Defaults match a fresh install.
  const Settings({
    this.name = '',
    this.role = '',
    this.city = '',
    this.email = '',
    this.phone = '',
    this.website = '',
    this.invoicePrefix = 'OM',
    this.defaultDueDays = 30,
    this.instapay = '',
    this.wallet = '',
    this.bankIban = '',
    this.notesEn = '',
    this.notesAr = '',
    this.backupDir,
    this.lastBackupAt,
    this.legalName = '',
    this.nationalIdOrRegistry = '',
    this.address = '',
    this.contractPrefix = 'CT',
    this.quotePrefix = 'QT',
    this.defaultJurisdiction = 'المحكمة الاقتصادية المختصة',
    this.contractWesternDigits = false,
  });

  /// Printed on invoices; `{{provider.name}}`.
  final String name;

  /// Job title under the name.
  final String role;

  /// City under the name.
  final String city;

  /// `{{provider.email}}`.
  final String email;

  /// `{{provider.phone}}`.
  final String phone;

  /// Printed in the invoice header and footer.
  final String website;

  /// Invoice numbers are `<prefix>-<year>-<seq>`.
  final String invoicePrefix;

  /// Days from issue to due date on new invoices (0–3650).
  final int defaultDueDays;

  /// InstaPay address printed under "Payment".
  final String instapay;

  /// Mobile wallet number printed under "Payment".
  final String wallet;

  /// IBAN printed under "Payment".
  final String bankIban;

  /// Default English notes of new invoices, one per line.
  final String notesEn;

  /// Default Arabic notes of new invoices, one per line.
  final String notesAr;

  /// Custom backup folder; null means `<data dir>/backups`.
  final String? backupDir;

  /// UTC epoch milliseconds.
  final int? lastBackupAt;

  /// `{{provider.legalName}}`; falls back to [name] when empty.
  final String legalName;

  /// `{{provider.id}}`.
  final String nationalIdOrRegistry;

  /// `{{provider.address}}`.
  final String address;

  /// Contract numbers are `<prefix>-<year>-<seq>`.
  final String contractPrefix;

  /// Quote numbers are `<prefix>-<year>-<seq>`.
  final String quotePrefix;

  /// Copied into each new contract's `{{jurisdiction}}`.
  final String defaultJurisdiction;

  /// Sub-item numbers in contract PDFs: `1.` instead of `١.`.
  final bool contractWesternDigits;

  /// A name is set; the first-run checklist uses it.
  bool get hasProfile => name.trim().isNotEmpty;

  /// A copy with the given fields replaced (null keeps the old value).
  Settings copyWith({
    String? name,
    String? role,
    String? city,
    String? email,
    String? phone,
    String? website,
    String? invoicePrefix,
    int? defaultDueDays,
    String? instapay,
    String? wallet,
    String? bankIban,
    String? notesEn,
    String? notesAr,
    String? backupDir,
    int? lastBackupAt,
    String? legalName,
    String? nationalIdOrRegistry,
    String? address,
    String? contractPrefix,
    String? quotePrefix,
    String? defaultJurisdiction,
    bool? contractWesternDigits,
  }) => Settings(
    name: name ?? this.name,
    role: role ?? this.role,
    city: city ?? this.city,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    website: website ?? this.website,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    defaultDueDays: defaultDueDays ?? this.defaultDueDays,
    instapay: instapay ?? this.instapay,
    wallet: wallet ?? this.wallet,
    bankIban: bankIban ?? this.bankIban,
    notesEn: notesEn ?? this.notesEn,
    notesAr: notesAr ?? this.notesAr,
    backupDir: backupDir ?? this.backupDir,
    lastBackupAt: lastBackupAt ?? this.lastBackupAt,
    legalName: legalName ?? this.legalName,
    nationalIdOrRegistry: nationalIdOrRegistry ?? this.nationalIdOrRegistry,
    address: address ?? this.address,
    contractPrefix: contractPrefix ?? this.contractPrefix,
    quotePrefix: quotePrefix ?? this.quotePrefix,
    defaultJurisdiction: defaultJurisdiction ?? this.defaultJurisdiction,
    contractWesternDigits: contractWesternDigits ?? this.contractWesternDigits,
  );
}

@immutable
/// Someone invoices and contracts are for.
class Client {
  /// A client; ids are UUIDs, [name] is required.
  const Client({
    required this.id,
    required this.name,
    this.contact = '',
    this.city = '',
    this.phone = '',
    this.email = '',
    this.archived = false,
    this.legalName = '',
    this.registryNo = '',
    this.address = '',
    this.representative = '',
    this.representativeTitle = '',
  });

  /// Stable UUID.
  final String id;

  /// Display name; never empty (CHECK constraint).
  final String name;

  /// Contact person, printed as "Attn:".
  final String contact;

  /// Printed under the name.
  final String city;

  /// Phone; searchable with any digits.
  final String phone;

  /// `{{client.email}}`.
  final String email;

  /// Hidden with its documents from the list, search and summary.
  final bool archived;

  /// Legal details used in contracts.
  final String legalName;

  /// سجل تجاري / رقم قومي.
  final String registryNo;

  /// `{{client.address}}`.
  final String address;

  /// Who signs for the client; `{{client.representative}}`.
  final String representative;

  /// Their title; `{{client.representativeTitle}}`.
  final String representativeTitle;

  /// A copy with the given fields replaced (the id never changes).
  Client copyWith({
    String? name,
    String? contact,
    String? city,
    String? phone,
    String? email,
    bool? archived,
    String? legalName,
    String? registryNo,
    String? address,
    String? representative,
    String? representativeTitle,
  }) => Client(
    id: id,
    name: name ?? this.name,
    contact: contact ?? this.contact,
    city: city ?? this.city,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    archived: archived ?? this.archived,
    legalName: legalName ?? this.legalName,
    registryNo: registryNo ?? this.registryNo,
    address: address ?? this.address,
    representative: representative ?? this.representative,
    representativeTitle: representativeTitle ?? this.representativeTitle,
  );

  @override
  bool operator ==(Object other) =>
      other is Client &&
      other.id == id &&
      other.name == name &&
      other.contact == contact &&
      other.city == city &&
      other.phone == phone &&
      other.email == email &&
      other.archived == archived &&
      other.legalName == legalName &&
      other.registryNo == registryNo &&
      other.address == address &&
      other.representative == representative &&
      other.representativeTitle == representativeTitle;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    contact,
    city,
    phone,
    email,
    archived,
    legalName,
    registryNo,
    address,
    representative,
    representativeTitle,
  );
}

@immutable
/// One billed line of an invoice section.
class LineItem {
  /// A line; ids are UUIDs.
  const LineItem({
    required this.id,
    this.service = '',
    this.description = '',
    this.cycle = BillingCycle.oneTime,
    this.qty = 1,
    this.unitPriceMinor = 0,
  });

  /// Stable UUID.
  final String id;

  /// What is billed; remembered for autocomplete.
  final String service;

  /// Details, printed muted.
  final String description;

  /// One-time, monthly or annual.
  final BillingCycle cycle;

  /// Whole units, 0 or more.
  final int qty;

  /// Price per unit, in minor units of the section's currency.
  final int unitPriceMinor;

  /// [qty] × [unitPriceMinor], minor units.
  int get lineMinor => qty * unitPriceMinor;

  /// No service, description or price; not printed.
  bool get isBlank =>
      service.trim().isEmpty &&
      description.trim().isEmpty &&
      unitPriceMinor == 0;

  /// A copy with the given fields replaced.
  LineItem copyWith({
    String? id,
    String? service,
    String? description,
    BillingCycle? cycle,
    int? qty,
    int? unitPriceMinor,
  }) => LineItem(
    id: id ?? this.id,
    service: service ?? this.service,
    description: description ?? this.description,
    cycle: cycle ?? this.cycle,
    qty: qty ?? this.qty,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
  );
}

@immutable
/// A group of lines in one currency with a bilingual title.
class InvoiceSection {
  /// A section; ids are UUIDs.
  const InvoiceSection({
    required this.id,
    required this.currency,
    this.titleEn = '',
    this.titleAr = '',
    this.items = const [],
  });

  /// Stable UUID.
  final String id;

  /// English title.
  final String titleEn;

  /// Arabic title.
  final String titleAr;

  /// Every line's price is in this currency.
  final Currency currency;

  /// In order.
  final List<LineItem> items;

  /// Sum of the lines, before VAT.
  Money get subtotal => Money(
    items.fold(0, (sum, i) => sum + i.lineMinor),
    currency,
  );

  /// A copy with the given fields replaced.
  InvoiceSection copyWith({
    String? id,
    String? titleEn,
    String? titleAr,
    Currency? currency,
    List<LineItem>? items,
  }) => InvoiceSection(
    id: id ?? this.id,
    titleEn: titleEn ?? this.titleEn,
    titleAr: titleAr ?? this.titleAr,
    currency: currency ?? this.currency,
    items: items ?? this.items,
  );
}

@immutable
/// The optional second page of an invoice (scope and handover).
class ScopePage {
  /// Off by default.
  const ScopePage({
    this.enabled = false,
    this.title = '',
    this.overview = '',
    this.done = '',
    this.delivered = '',
    this.warranty = '',
  });

  /// Adds the page to the PDF.
  final bool enabled;

  /// Page heading.
  final String title;

  /// "نظرة عامة" paragraph.
  final String overview;

  /// One entry per line.
  final String done;

  /// "ما تم تسليمه", one entry per line.
  final String delivered;

  /// "الضمان والدعم" paragraph.
  final String warranty;

  /// A copy with the given fields replaced.
  ScopePage copyWith({
    bool? enabled,
    String? title,
    String? overview,
    String? done,
    String? delivered,
    String? warranty,
  }) => ScopePage(
    enabled: enabled ?? this.enabled,
    title: title ?? this.title,
    overview: overview ?? this.overview,
    done: done ?? this.done,
    delivered: delivered ?? this.delivered,
    warranty: warranty ?? this.warranty,
  );
}

@immutable
/// An invoice with its sections and items.
class Invoice {
  /// An invoice; [number] is unique, ids are UUIDs.
  const Invoice({
    required this.id,
    required this.clientId,
    required this.number,
    required this.year,
    required this.seq,
    required this.issueDate,
    required this.dueDate,
    this.paidDate,
    this.status = InvoiceStatus.draft,
    this.contractRef = '',
    this.vatOn = false,
    this.vatRateBp = 1400,
    this.notesEn = '',
    this.notesAr = '',
    this.scope = const ScopePage(),
    this.sections = const [],
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  /// Stable UUID.
  final String id;

  /// Empty while the user has not picked a client yet.
  final String clientId;

  /// e.g. `OM-2026-0001`; unique, never reused (deleted ones included).
  final String number;

  /// Year part of the number.
  final int year;

  /// Sequence within the year, from 1.
  final int seq;

  /// Printed date; drives the year of a new number.
  final CalendarDate issueDate;

  /// Overdue after this day while still sent.
  final CalendarDate dueDate;

  /// Set when paid; null otherwise.
  final CalendarDate? paidDate;

  /// Stored status; see [DisplayStatus] for overdue.
  final InvoiceStatus status;

  /// Contract number this bills against; links it to that contract.
  final String contractRef;

  /// Adds VAT per currency at [vatRateBp].
  final bool vatOn;

  /// VAT rate in basis points (1400 = 14%).
  final int vatRateBp;

  /// English notes, one per line.
  final String notesEn;

  /// Arabic notes, one per line.
  final String notesAr;

  /// Optional scope page.
  final ScopePage scope;

  /// In order; each has its own currency.
  final List<InvoiceSection> sections;

  /// UTC epoch ms; 0 until first saved.
  final int createdAt;

  /// UTC epoch ms of the last save.
  final int updatedAt;

  /// A copy with the given fields replaced; [paidDate] takes a function
  /// so it can be cleared.
  Invoice copyWith({
    String? id,
    String? clientId,
    String? number,
    int? year,
    int? seq,
    CalendarDate? issueDate,
    CalendarDate? dueDate,
    CalendarDate? Function()? paidDate,
    InvoiceStatus? status,
    String? contractRef,
    bool? vatOn,
    int? vatRateBp,
    String? notesEn,
    String? notesAr,
    ScopePage? scope,
    List<InvoiceSection>? sections,
    int? createdAt,
    int? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    clientId: clientId ?? this.clientId,
    number: number ?? this.number,
    year: year ?? this.year,
    seq: seq ?? this.seq,
    issueDate: issueDate ?? this.issueDate,
    dueDate: dueDate ?? this.dueDate,
    paidDate: paidDate != null ? paidDate() : this.paidDate,
    status: status ?? this.status,
    contractRef: contractRef ?? this.contractRef,
    vatOn: vatOn ?? this.vatOn,
    vatRateBp: vatRateBp ?? this.vatRateBp,
    notesEn: notesEn ?? this.notesEn,
    notesAr: notesAr ?? this.notesAr,
    scope: scope ?? this.scope,
    sections: sections ?? this.sections,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

/// Splits a multi-line notes field into non-empty trimmed lines.
List<String> splitLines(String text) =>
    text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
