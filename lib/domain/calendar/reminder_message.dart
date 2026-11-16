import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

/// A short, polite payment reminder for [invoice], Arabic then English,
/// with the number, the amount due, the (effective) due date and the
/// provider's payment details. Document text like the PDF, so it is
/// bilingual whatever the UI language.
String paymentReminderMessage({
  required Invoice invoice,
  required Settings settings,
  required CalendarDate today,
  Client? client,
}) {
  final total = invoice.totals.total.format();
  final due = invoice.effectiveDueDate;
  final late = invoice.isOverdue(today);
  final name = client?.contact.trim().isNotEmpty ?? false
      ? client!.contact.trim()
      : client?.name.trim() ?? '';
  final pay = [
    if (settings.instapay.trim().isNotEmpty)
      (
        'InstaPay',
        settings.instapay.trim(),
      ),
    if (settings.wallet.trim().isNotEmpty)
      (
        'محفظة / Wallet',
        settings.wallet.trim(),
      ),
    if (settings.bankIban.trim().isNotEmpty) ('IBAN', settings.bankIban.trim()),
  ];
  final from = settings.name.trim();

  final ar = StringBuffer()
    ..writeln(name.isEmpty ? 'مرحبًا،' : 'مرحبًا $name،')
    ..writeln(
      late
          ? 'نذكّركم بلطف بأن الفاتورة رقم ${invoice.number} بمبلغ $total '
                'كانت مستحقة في ${formatArabicDate(due)}.'
          : 'نذكّركم بلطف بأن الفاتورة رقم ${invoice.number} بمبلغ $total '
                'مستحقة في ${formatArabicDate(due)}.',
    );
  if (pay.isNotEmpty) {
    ar.writeln('يمكن السداد عبر:');
    for (final (k, v) in pay) {
      ar.writeln('• $k: $v');
    }
  }
  ar
    ..writeln('إذا تم السداد بالفعل فبرجاء تجاهل هذه الرسالة. شكرًا لكم.')
    ..write(from);

  final en = StringBuffer()
    ..writeln(name.isEmpty ? 'Hello,' : 'Hello $name,')
    ..writeln(
      late
          ? 'A friendly reminder that invoice ${invoice.number} for $total '
                'was due on ${formatInvoiceDate(due)}.'
          : 'A friendly reminder that invoice ${invoice.number} for $total '
                'is due on ${formatInvoiceDate(due)}.',
    );
  if (pay.isNotEmpty) {
    en.writeln('You can pay via:');
    for (final (k, v) in pay) {
      en.writeln('• ${k == 'محفظة / Wallet' ? 'Wallet' : k}: $v');
    }
  }
  en
    ..writeln(
      'If you have already paid, please ignore this message. Thank you.',
    )
    ..write(from);

  return '${ar.toString().trim()}\n\n—\n\n${en.toString().trim()}';
}
