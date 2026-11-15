part of '../models.dart';

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
