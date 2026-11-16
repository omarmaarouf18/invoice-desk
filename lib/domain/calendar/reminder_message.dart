import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';

/// A short, polite payment reminder for [invoice], with the number, the
/// amount due, the (effective) due date and the provider's payment details.
///
/// Document text, like the PDF: it follows [language], not the UI language.
/// [DocLanguage.bilingual] (the default, and the only output before 0.5)
/// gives the Arabic text, a `—` separator, then the English text.
String paymentReminderMessage({
  required Invoice invoice,
  required Settings settings,
  required CalendarDate today,
  Client? client,
  DocLanguage language = DocLanguage.bilingual,
}) {
  final total = invoice.totals.total.format();
  final due = invoice.effectiveDueDate;
  final late = invoice.isOverdue(today);
  final name = client?.contact.trim().isNotEmpty ?? false
      ? client!.contact.trim()
      : client?.name.trim() ?? '';
  final from = settings.name.trim();
  final r = _Reminder(
    number: invoice.number,
    total: total,
    due: due,
    late: late,
    name: name,
    from: from,
    settings: settings,
  );
  return switch (language) {
    DocLanguage.ar => r.arabic(),
    DocLanguage.en => r.english(),
    DocLanguage.bilingual => '${r.arabic()}\n\n—\n\n${r.english()}',
  };
}

class _Reminder {
  _Reminder({
    required this.number,
    required this.total,
    required this.due,
    required this.late,
    required this.name,
    required this.from,
    required this.settings,
  });

  final String number;
  final String total;
  final CalendarDate due;
  final bool late;
  final String name;
  final String from;
  final Settings settings;

  /// (Arabic label, English label, value) for each payment method set.
  List<(String, String, String)> get _pay => [
    if (settings.instapay.trim().isNotEmpty)
      ('InstaPay', 'InstaPay', settings.instapay.trim()),
    if (settings.wallet.trim().isNotEmpty)
      ('محفظة / Wallet', 'Wallet', settings.wallet.trim()),
    if (settings.bankIban.trim().isNotEmpty)
      ('IBAN', 'IBAN', settings.bankIban.trim()),
  ];

  String arabic() {
    final date = formatDocDate(due, DocLanguage.ar);
    final b = StringBuffer()
      ..writeln(name.isEmpty ? 'مرحبًا،' : 'مرحبًا $name،')
      ..writeln(
        late
            ? 'نذكّركم بلطف بأن الفاتورة رقم $number بمبلغ $total '
                  'كانت مستحقة في $date.'
            : 'نذكّركم بلطف بأن الفاتورة رقم $number بمبلغ $total '
                  'مستحقة في $date.',
      );
    if (_pay.isNotEmpty) {
      b.writeln('يمكن السداد عبر:');
      for (final (k, _, v) in _pay) {
        b.writeln('• $k: $v');
      }
    }
    b
      ..writeln('إذا تم السداد بالفعل فبرجاء تجاهل هذه الرسالة. شكرًا لكم.')
      ..write(from);
    return b.toString().trim();
  }

  String english() {
    final date = formatDocDate(due, DocLanguage.en);
    final b = StringBuffer()
      ..writeln(name.isEmpty ? 'Hello,' : 'Hello $name,')
      ..writeln(
        late
            ? 'A friendly reminder that invoice $number for $total '
                  'was due on $date.'
            : 'A friendly reminder that invoice $number for $total '
                  'is due on $date.',
      );
    if (_pay.isNotEmpty) {
      b.writeln('You can pay via:');
      for (final (_, k, v) in _pay) {
        b.writeln('• $k: $v');
      }
    }
    b
      ..writeln(
        'If you have already paid, please ignore this message. Thank you.',
      )
      ..write(from);
    return b.toString().trim();
  }
}
