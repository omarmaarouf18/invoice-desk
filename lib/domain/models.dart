import 'package:flutter/foundation.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';

enum InvoiceStatus {
  draft('draft'),
  sent('sent'),
  paid('paid'),
  voided('void');

  const InvoiceStatus(this.dbValue);
  final String dbValue;

  static InvoiceStatus fromDb(String v) =>
      InvoiceStatus.values.firstWhere((s) => s.dbValue == v);
}

/// What the UI shows: status plus the derived overdue state.
enum DisplayStatus { draft, sent, overdue, paid, voided }

enum BillingCycle {
  oneTime('one-time'),
  monthly('monthly'),
  annual('annual');

  const BillingCycle(this.dbValue);
  final String dbValue;

  bool get isRecurring => this != BillingCycle.oneTime;

  static BillingCycle fromDb(String v) =>
      BillingCycle.values.firstWhere((s) => s.dbValue == v);
}

@immutable
class Settings {
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

  final String name;
  final String role;
  final String city;
  final String email;
  final String phone;
  final String website;
  final String invoicePrefix;
  final int defaultDueDays;
  final String instapay;
  final String wallet;
  final String bankIban;
  final String notesEn;
  final String notesAr;
  final String? backupDir;

  /// UTC epoch milliseconds.
  final int? lastBackupAt;

  final String legalName;
  final String nationalIdOrRegistry;
  final String address;
  final String contractPrefix;
  final String quotePrefix;
  final String defaultJurisdiction;

  /// Sub-item numbers in contract PDFs: `1.` instead of `١.`.
  final bool contractWesternDigits;

  bool get hasProfile => name.trim().isNotEmpty;

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
class Client {
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

  final String id;
  final String name;
  final String contact;
  final String city;
  final String phone;
  final String email;
  final bool archived;

  /// Legal details used in contracts.
  final String legalName;

  /// سجل تجاري / رقم قومي.
  final String registryNo;
  final String address;
  final String representative;
  final String representativeTitle;

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
class LineItem {
  const LineItem({
    required this.id,
    this.service = '',
    this.description = '',
    this.cycle = BillingCycle.oneTime,
    this.qty = 1,
    this.unitPriceMinor = 0,
  });

  final String id;
  final String service;
  final String description;
  final BillingCycle cycle;
  final int qty;
  final int unitPriceMinor;

  int get lineMinor => qty * unitPriceMinor;

  bool get isBlank =>
      service.trim().isEmpty &&
      description.trim().isEmpty &&
      unitPriceMinor == 0;

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
class InvoiceSection {
  const InvoiceSection({
    required this.id,
    required this.currency,
    this.titleEn = '',
    this.titleAr = '',
    this.items = const [],
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final Currency currency;
  final List<LineItem> items;

  Money get subtotal => Money(
    items.fold(0, (sum, i) => sum + i.lineMinor),
    currency,
  );

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
class ScopePage {
  const ScopePage({
    this.enabled = false,
    this.title = '',
    this.overview = '',
    this.done = '',
    this.delivered = '',
    this.warranty = '',
  });

  final bool enabled;
  final String title;
  final String overview;

  /// One entry per line.
  final String done;
  final String delivered;
  final String warranty;

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
class Invoice {
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

  final String id;

  /// Empty while the user has not picked a client yet.
  final String clientId;
  final String number;
  final int year;
  final int seq;
  final CalendarDate issueDate;
  final CalendarDate dueDate;
  final CalendarDate? paidDate;
  final InvoiceStatus status;
  final String contractRef;
  final bool vatOn;
  final int vatRateBp;
  final String notesEn;
  final String notesAr;
  final ScopePage scope;
  final List<InvoiceSection> sections;
  final int createdAt;
  final int updatedAt;

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
