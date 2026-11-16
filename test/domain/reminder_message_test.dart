import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/reminder_message.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';

void main() {
  const invoice = Invoice(
    id: 'i',
    clientId: 'c',
    number: 'SS-2026-0007',
    year: 2026,
    seq: 7,
    issueDate: CalendarDate(2026, 9, 1),
    dueDate: CalendarDate(2026, 9, 14),
    status: InvoiceStatus.sent,
    sections: [
      InvoiceSection(
        id: 's',
        currency: Currency.egp,
        items: [LineItem(id: 'l', service: 'Design', unitPriceMinor: 150000)],
      ),
    ],
  );
  const settings = Settings(
    name: 'Sample Studio',
    instapay: 'sample@instapay',
    wallet: '0100 000 0001',
  );
  const client = Client(id: 'c', name: 'Acme Studio', contact: 'Sara');

  String msg(
    DocLanguage? l, {
    CalendarDate today = const CalendarDate(2026, 9, 1),
  }) => l == null
      ? paymentReminderMessage(
          invoice: invoice,
          settings: settings,
          today: today,
          client: client,
        )
      : paymentReminderMessage(
          invoice: invoice,
          settings: settings,
          today: today,
          client: client,
          language: l,
        );

  test('bilingual by default: Arabic, separator, English', () {
    final both = msg(null);
    expect(both, msg(DocLanguage.bilingual));
    expect(both, '${msg(DocLanguage.ar)}\n\n—\n\n${msg(DocLanguage.en)}');
  });

  test('Arabic only', () {
    final ar = msg(DocLanguage.ar);
    expect(ar, startsWith('مرحبًا Sara،'));
    expect(ar, contains('مستحقة في 14 سبتمبر 2026.'));
    expect(ar, contains('• محفظة / Wallet: 0100 000 0001'));
    expect(ar, isNot(contains('Hello')));
    expect(ar, endsWith('Sample Studio'));
  });

  test('English only, overdue wording', () {
    final en = msg(DocLanguage.en, today: const CalendarDate(2026, 10, 1));
    expect(en, startsWith('Hello Sara,'));
    expect(en, contains('SS-2026-0007'));
    expect(en, contains('was due on 14 Sep 2026.'));
    expect(en, contains('• InstaPay: sample@instapay'));
    expect(en, contains('• Wallet: 0100 000 0001'));
    expect(en, isNot(contains('مرحبًا')));
  });
}
