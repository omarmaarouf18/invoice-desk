import 'package:flutter/material.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// "تأجيل": a new date (prefilled) and a reason. Null when cancelled
/// (Esc or Cancel).
Future<({CalendarDate date, String reason})?> showPostponeDialog(
  BuildContext context, {
  required CalendarDate from,
  required CalendarDate initial,
}) => showDialog(
  context: context,
  builder: (_) => _PostponeDialog(from: from, initial: initial),
);

class _PostponeDialog extends StatefulWidget {
  const _PostponeDialog({required this.from, required this.initial});
  final CalendarDate from;
  final CalendarDate initial;

  @override
  State<_PostponeDialog> createState() => _PostponeDialogState();
}

class _PostponeDialogState extends State<_PostponeDialog> {
  late CalendarDate _date = widget.initial;
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = CalendarDate.fromDateTime(d));
  }

  void _submit() => Navigator.pop(context, (
    date: _date,
    reason: _reason.text.trim(),
  ));

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.postponeTitle),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${l.dueDate}: ${formatArabicDate(widget.from)}',
              style: TextStyle(color: context.colors.muted),
            ),
            const SizedBox(height: Space.m),
            OutlinedButton.icon(
              key: const Key('postpone-date'),
              onPressed: _pick,
              icon: const Icon(Icons.event, size: 18),
              label: Text('${l.postponeNewDate}: ${formatArabicDate(_date)}'),
            ),
            const SizedBox(height: Space.m),
            TextField(
              key: const Key('postpone-reason'),
              controller: _reason,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l.postponeReason,
                hintText: l.postponeReasonHint,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.actPostpone)),
      ],
    );
  }
}

/// New or edited reminder; null when cancelled.
Future<({CalendarDate date, String? time, String text})?> showReminderDialog(
  BuildContext context, {
  required CalendarDate date,
  Reminder? existing,
}) => showDialog(
  context: context,
  builder: (_) => _ReminderDialog(date: date, existing: existing),
);

class _ReminderDialog extends StatefulWidget {
  const _ReminderDialog({required this.date, this.existing});
  final CalendarDate date;
  final Reminder? existing;

  @override
  State<_ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<_ReminderDialog> {
  late CalendarDate _date = widget.existing?.date ?? widget.date;
  late final _text = TextEditingController(text: widget.existing?.text);
  late final _time = TextEditingController(text: widget.existing?.time);
  String? _textError;
  String? _timeError;

  @override
  void dispose() {
    _text.dispose();
    _time.dispose();
    super.dispose();
  }

  /// `9:5` → null (invalid); `9:05` → `09:05`; empty → ''.
  static String? normalizeTime(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return '';
    final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(t);
    if (m == null) return null;
    final h = int.parse(m.group(1)!);
    final min = int.parse(m.group(2)!);
    if (h > 23 || min > 59) return null;
    return '${h.toString().padLeft(2, '0')}:${m.group(2)}';
  }

  void _submit() {
    final l = context.l10n;
    final time = normalizeTime(_time.text);
    setState(() {
      _textError = _text.text.trim().isEmpty ? l.errReminderText : null;
      _timeError = time == null ? l.errTime : null;
    });
    if (_textError != null || _timeError != null) return;
    Navigator.pop(context, (
      date: _date,
      time: time!.isEmpty ? null : time,
      text: _text.text.trim(),
    ));
  }

  Future<void> _pick() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date.toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = CalendarDate.fromDateTime(d));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.existing == null ? l.reminderNew : l.reminderEdit),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('reminder-text'),
              controller: _text,
              autofocus: true,
              decoration: InputDecoration(
                labelText: l.reminderText,
                errorText: _textError,
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: Space.m),
            OutlinedButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.event, size: 18),
              label: Text(formatArabicDate(_date)),
            ),
            const SizedBox(height: Space.m),
            TextField(
              key: const Key('reminder-time'),
              controller: _time,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                labelText: l.reminderTime,
                hintText: l.reminderTimeHint,
                errorText: _timeError,
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l.save)),
      ],
    );
  }
}
