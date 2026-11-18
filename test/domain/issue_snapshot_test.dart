import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/issue_snapshot.dart';
import 'package:invoice_desk/domain/models.dart';

void main() {
  const settings = Settings(
    name: 'Acme Studio',
    address: 'Old Street 1',
    bankIban: 'EG00OLD',
    taxRegistrationNo: '123-456',
    dateFormat: DocDateFormat.numeric,
    currencyDisplay: CurrencyDisplay.local,
    docDigitStyle: DigitStyle.arabicIndic,
  );
  const client = Client(
    id: 'c1',
    name: 'Sample Academy',
    city: 'Cairo',
    representative: 'Sara',
  );

  test('round-trips through JSON', () {
    final snap = IssueSnapshot.capture(settings, client);
    final back = IssueSnapshot.tryParse(snap.toRawJson())!;
    expect(back.provider, snap.provider);
    expect(back.payment, snap.payment);
    expect(back.client, snap.client);
    expect(back.dateFormat, DocDateFormat.numeric);
    expect(back.currencyDisplay, CurrencyDisplay.local);
    expect(back.digitStyle, DigitStyle.arabicIndic);
  });

  test('applies the frozen fields over later live data', () {
    final snap = IssueSnapshot.capture(settings, client);
    final live = settings.copyWith(
      name: 'Renamed',
      address: 'New Street 9',
      bankIban: 'EG00NEW',
      invoicePrefix: 'NEW', // not printed: stays live
      dateFormat: DocDateFormat.long,
      currencyDisplay: CurrencyDisplay.code,
      docDigitStyle: DigitStyle.western,
    );
    final s = snap.applyTo(live);
    expect(s.name, 'Acme Studio');
    expect(s.address, 'Old Street 1');
    expect(s.bankIban, 'EG00OLD');
    expect(s.taxRegistrationNo, '123-456');
    expect(s.invoicePrefix, 'NEW');
    expect(s.dateFormat, DocDateFormat.numeric);
    expect(s.currencyDisplay, CurrencyDisplay.local);
    expect(s.docDigitStyle, DigitStyle.arabicIndic);

    final c = snap.applyToClient(
      client.copyWith(name: 'New Name', city: 'Giza'),
      id: 'c1',
    )!;
    expect(c.name, 'Sample Academy');
    expect(c.city, 'Cairo');
    expect(c.representative, 'Sara');
  });

  test('a deleted client still prints from the snapshot', () {
    final snap = IssueSnapshot.capture(settings, client);
    final c = snap.applyToClient(null, id: 'c1')!;
    expect(c.id, 'c1');
    expect(c.name, 'Sample Academy');
  });

  test('no client block leaves the live client alone', () {
    final snap = IssueSnapshot.capture(settings, null);
    expect(snap.applyToClient(client, id: 'c1'), same(client));
  });

  test('garbage never throws; missing keys stay live', () {
    for (final raw in [
      null,
      '',
      'not json',
      '[]',
      '{}',
      '{"v":"1"}',
      jsonEncode({'v': 1, 'provider': 7, 'format': 'x'}),
    ]) {
      final snap = IssueSnapshot.tryParse(raw);
      if (snap != null) {
        expect(snap.applyTo(settings).name, settings.name, reason: raw);
        expect(snap.dateFormat, DocDateFormat.long);
      }
    }
    expect(IssueSnapshot.tryParse('{}'), isNull);
    final partial = IssueSnapshot.tryParse(
      jsonEncode({
        'v': 2,
        'provider': {'name': 'Old', 'future': 'x'},
      }),
    )!;
    final s = partial.applyTo(settings.copyWith(bankIban: 'LIVE'));
    expect(s.name, 'Old');
    expect(s.bankIban, 'LIVE');
  });
}
