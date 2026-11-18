import 'dart:convert';

import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:meta/meta.dart';

/// What a document printed about its parties and its formats on the day it
/// was sent, paid or signed (ADR-0014).
///
/// The style snapshot (ADR-0012) freezes the look; this freezes the
/// content that lives outside the document: the provider block, the
/// payment methods, the client block as printed, and the date, currency and
/// digit formats. Without it, a new IBAN or address in Settings would
/// re-export an invoice that was already sent with details it never had.
///
/// Stored as versioned JSON in `invoices.issue_snapshot` and
/// `contracts.issue_snapshot` (schema v8). [tryParse] never throws: a
/// missing or unreadable snapshot means "render from live data", which is
/// also how documents committed before v8 render.
@immutable
class IssueSnapshot {
  /// A snapshot; use [IssueSnapshot.capture] to take one.
  const IssueSnapshot({
    required this.provider,
    required this.payment,
    required this.client,
    required this.dateFormat,
    required this.currencyDisplay,
    required this.digitStyle,
  });

  /// Freezes [s] and [c] as a document prints them now. [c] is null for a
  /// document without a client (its client block stays live, i.e. empty).
  factory IssueSnapshot.capture(Settings s, Client? c) => IssueSnapshot(
    provider: {
      'name': s.name,
      'legalName': s.legalName,
      'role': s.role,
      'city': s.city,
      'address': s.address,
      'email': s.email,
      'phone': s.phone,
      'website': s.website,
      'nationalIdOrRegistry': s.nationalIdOrRegistry,
      'taxRegistrationNo': s.taxRegistrationNo,
    },
    payment: {
      'instapay': s.instapay,
      'wallet': s.wallet,
      'bankIban': s.bankIban,
    },
    client: c == null
        ? null
        : {
            'name': c.name,
            'legalName': c.legalName,
            'contact': c.contact,
            'city': c.city,
            'address': c.address,
            'phone': c.phone,
            'email': c.email,
            'registryNo': c.registryNo,
            'representative': c.representative,
            'representativeTitle': c.representativeTitle,
          },
    dateFormat: s.dateFormat,
    currencyDisplay: s.currencyDisplay,
    digitStyle: s.docDigitStyle,
  );

  /// The newest JSON version this build writes.
  static const version = 1;

  /// [raw] read back; null when it is empty, not JSON, or not a snapshot.
  /// Unknown keys are ignored and missing ones fall back to live data, so
  /// a newer version still renders what this build understands.
  static IssueSnapshot? tryParse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final j = jsonDecode(raw);
      if (j is! Map<String, dynamic> || j['v'] is! int) return null;
      Map<String, String> strings(Object? m) => {
        if (m is Map)
          for (final e in m.entries)
            if (e.key is String && e.value is String)
              e.key as String: e.value as String,
      };
      final format = j['format'] is Map
          ? j['format'] as Map
          : const <String, Object?>{};
      return IssueSnapshot(
        provider: strings(j['provider']),
        payment: strings(j['payment']),
        client: j['client'] is Map ? strings(j['client']) : null,
        dateFormat: DocDateFormat.fromCode(format['date'] as String?),
        currencyDisplay: CurrencyDisplay.fromDb(format['currency'] as String?),
        digitStyle: DigitStyle.fromCode(format['digits'] as String?),
      );
    } on Object {
      return null;
    }
  }

  /// Provider fields by name (see [IssueSnapshot.capture]).
  final Map<String, String> provider;

  /// InstaPay, wallet and IBAN.
  final Map<String, String> payment;

  /// Client fields as printed; null when the document had no client.
  final Map<String, String>? client;

  /// How dates were printed.
  final DocDateFormat dateFormat;

  /// How currencies were written next to amounts.
  final CurrencyDisplay currencyDisplay;

  /// How digits were printed in Arabic text.
  final DigitStyle digitStyle;

  /// The JSON stored in the document row.
  String toRawJson() => jsonEncode({
    'v': version,
    'provider': provider,
    'payment': payment,
    'client': ?client,
    'format': {
      'date': dateFormat.code,
      'currency': currencyDisplay.dbValue,
      'digits': digitStyle.code,
    },
  });

  /// [live] with the frozen provider, payment and format fields; every
  /// other setting (prefixes, defaults, backups…) stays live. A key the
  /// snapshot lacks keeps the live value.
  Settings applyTo(Settings live) {
    String p(String k, String v) => provider[k] ?? v;
    String pay(String k, String v) => payment[k] ?? v;
    return live.copyWith(
      name: p('name', live.name),
      legalName: p('legalName', live.legalName),
      role: p('role', live.role),
      city: p('city', live.city),
      address: p('address', live.address),
      email: p('email', live.email),
      phone: p('phone', live.phone),
      website: p('website', live.website),
      nationalIdOrRegistry: p(
        'nationalIdOrRegistry',
        live.nationalIdOrRegistry,
      ),
      taxRegistrationNo: p('taxRegistrationNo', live.taxRegistrationNo),
      instapay: pay('instapay', live.instapay),
      wallet: pay('wallet', live.wallet),
      bankIban: pay('bankIban', live.bankIban),
      dateFormat: dateFormat,
      currencyDisplay: currencyDisplay,
      docDigitStyle: digitStyle,
    );
  }

  /// [live] with the client block as it was printed. With no frozen client
  /// block, [live] is returned as is. A client deleted since keeps
  /// printing from the snapshot ([id] is the document's client id).
  Client? applyToClient(Client? live, {required String id}) {
    final c = client;
    if (c == null) return live;
    final base = live ?? Client(id: id, name: c['name'] ?? '');
    String f(String k, String v) => c[k] ?? v;
    return base.copyWith(
      name: f('name', base.name),
      legalName: f('legalName', base.legalName),
      contact: f('contact', base.contact),
      city: f('city', base.city),
      address: f('address', base.address),
      phone: f('phone', base.phone),
      email: f('email', base.email),
      registryNo: f('registryNo', base.registryNo),
      representative: f('representative', base.representative),
      representativeTitle: f(
        'representativeTitle',
        base.representativeTitle,
      ),
    );
  }
}
