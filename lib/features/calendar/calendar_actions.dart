import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/calendar/events.dart';
import 'package:invoice_desk/domain/calendar/ics.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/calendar/reminder_message.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/calendar/calendar_dialogs.dart';
import 'package:invoice_desk/features/calendar/event_style.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

/// Every action of the calendar: all writes go through the same
/// repositories and controllers as the rest of the app (autosave, undo,
/// validation).
class CalendarActions {
  CalendarActions(this.ref, this.context);
  final WidgetRef ref;
  final BuildContext context;

  AppLocalizations get l => context.l10n;
  CalendarDate get _today => ref.read(todayProvider);

  /// Leaves the calendar for the invoice editor.
  Future<void> openInvoice(String id) async {
    ref.read(calendarModeProvider.notifier).set(false);
    await ref.read(editorProvider.notifier).open(id);
  }

  Future<void> openContract(String id) async {
    ref.read(calendarModeProvider.notifier).set(false);
    await ref.read(contractProvider.notifier).open(id);
  }

  /// Paid on [day] (the selected day by default), with Undo.
  Future<void> markPaid(CalendarEvent e, CalendarDate day) async {
    final id = e.invoiceId;
    if (id == null) return;
    final editor = ref.read(editorProvider.notifier);
    final r = await editor.markPaid(id, on: day);
    if (r is! Done) return showSnack(l.nothingOpen);
    showSnack(
      l.markedPaid(r.number),
      actions: [(l.undo, () => unawaited(editor.markUnpaid(id)))],
    );
  }

  /// Asks for a date and a reason, then appends a postponement (Undo
  /// removes it). [to] prefills the date (drag-and-drop).
  Future<void> postpone(CalendarEvent e, {CalendarDate? to}) async {
    final type = e.milestoneId != null
        ? PostponedEntity.milestone
        : PostponedEntity.invoice;
    final entity = e.milestoneId ?? e.invoiceId;
    if (entity == null) return;
    final from = e.date;
    final picked = await showPostponeDialog(
      context,
      from: from,
      initial: to ?? (from.isBefore(_today) ? _today : from).addDays(7),
    );
    if (picked == null || picked.date == from) return;
    final repo = ref.read(calendarRepositoryProvider);
    final id = await repo.postpone(
      type: type,
      entityId: entity,
      from: from,
      to: picked.date,
      reason: picked.reason,
    );
    showSnack(
      l.postponed(formatArabicDate(picked.date)),
      actions: [(l.undo, () => unawaited(repo.undoPostpone(id)))],
    );
  }

  /// Drag-and-drop onto [day]: a reminder just moves; invoices and
  /// milestones are postponed (asks for a reason, Esc cancels).
  Future<void> dropOn(CalendarEvent e, CalendarDate day) async {
    if (day == e.date || !e.type.isMovable) return;
    if (e.type == CalendarEventType.reminder) {
      final repo = ref.read(calendarRepositoryProvider);
      final r = await repo.reminderById(e.reminderId!);
      if (r == null) return;
      await repo.saveReminder(r.copyWith(date: day));
      showSnack(
        l.postponed(formatArabicDate(day)),
        actions: [(l.undo, () => unawaited(repo.saveReminder(r)))],
      );
      return;
    }
    await postpone(e, to: day);
  }

  /// Copies a short bilingual payment reminder to the clipboard.
  Future<void> copyReminder(CalendarEvent e) async {
    final id = e.invoiceId;
    if (id == null) return;
    final inv = await ref.read(invoiceRepositoryProvider).getById(id);
    if (inv == null) return;
    final settings = await ref.read(settingsRepositoryProvider).get();
    final client = await ref
        .read(clientRepositoryProvider)
        .getById(
          inv.clientId,
        );
    final text = paymentReminderMessage(
      invoice: inv,
      settings: settings,
      client: client,
      today: _today,
    );
    await Clipboard.setData(ClipboardData(text: text));
    showSnack(l.reminderCopied);
  }

  /// The existing milestone → invoice flow (contract editor).
  Future<void> invoiceMilestone(CalendarEvent e) async {
    final contractId = e.contractId;
    final milestoneId = e.milestoneId;
    if (contractId == null || milestoneId == null) return;
    final ctl = ref.read(contractProvider.notifier);
    await ctl.open(contractId);
    final number = await ctl.createInvoiceFromMilestone(milestoneId);
    if (number == null) return showSnack(l.milestoneNeedsAmount);
    showSnack(l.invoiceCreatedFromMilestone(number, e.title));
    ref.read(calendarModeProvider.notifier).set(false);
  }

  /// The existing renew flow, dated on the renewal day.
  Future<void> renew(CalendarEvent e) async {
    final id = e.invoiceId;
    if (id == null) return;
    final r = await ref.read(editorProvider.notifier).renew(id, on: e.date);
    switch (r) {
      case Created(:final number):
        ref.read(calendarModeProvider.notifier).set(false);
        showSnack(l.renewCreated(number));
      case NothingToRenew(:final number):
        showSnack(l.renewNone(number));
      case _:
        showSnack(l.nothingOpen);
    }
  }

  Future<void> addReminder(CalendarDate day) async {
    final r = await showReminderDialog(context, date: day);
    if (r == null) return;
    await ref
        .read(calendarRepositoryProvider)
        .saveReminder(
          Reminder(
            id: const Uuid().v4(),
            date: r.date,
            time: r.time,
            text: r.text,
          ),
        );
  }

  Future<void> editReminder(CalendarEvent e) async {
    final repo = ref.read(calendarRepositoryProvider);
    final old = await repo.reminderById(e.reminderId!);
    if (old == null || !context.mounted) return;
    final r = await showReminderDialog(context, date: old.date, existing: old);
    if (r == null) return;
    await repo.saveReminder(
      old.copyWith(date: r.date, time: () => r.time, text: r.text),
    );
  }

  Future<void> toggleDone(CalendarEvent e) async {
    final repo = ref.read(calendarRepositoryProvider);
    final r = await repo.reminderById(e.reminderId!);
    if (r != null) await repo.setDone(r, done: !r.isDone);
  }

  Future<void> deleteReminder(CalendarEvent e) async {
    final repo = ref.read(calendarRepositoryProvider);
    final r = await repo.reminderById(e.reminderId!);
    if (r == null) return;
    await repo.deleteReminder(r.id);
    showSnack(
      l.reminderDeleted,
      actions: [(l.undo, () => unawaited(repo.saveReminder(r)))],
    );
  }

  /// "تصدير إلى التقويم (.ics)": the visible range, or every event from
  /// today on.
  Future<void> exportIcs({required bool future}) async {
    final data = ref.read(calendarDataProvider);
    if (data == null) return;
    final today = _today;
    final range = future
        ? DateRange(today, today.addDays(3 * 366))
        : ref.read(visibleRangeProvider);
    final events = calendarEvents(
      range,
      data,
      ref.read(clockProvider),
    ).where((e) => exportedTypes.contains(e.type)).toList();
    final prefs = ref.read(uiPrefsProvider);
    final location = await getSaveLocation(
      suggestedName: 'invoice-desk-${today.toIso()}.ics',
      initialDirectory: prefs.lastExportDir,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'iCalendar', extensions: ['ics']),
      ],
    );
    if (location == null || !context.mounted) return;
    var path = location.path;
    if (!path.toLowerCase().endsWith('.ics')) path = '$path.ics';
    final ics = buildIcs(
      events,
      stamp: ref.read(clockProvider).now(),
      calendarName: l.appTitle,
      summary: (e) =>
          '${eventTypeLabel(context, e.type)}: ${eventTitle(context, e)}',
      description: (e) => eventDetail(context, e),
    );
    try {
      await File(path).writeAsString(ics, flush: true);
    } on Object {
      return showSnack(l.exportFailed);
    }
    prefs.lastExportDir = p.dirname(path);
    showSnack(
      l.icsExported(events.length),
      actions: [(l.openFolder, () => openPath(p.dirname(path)))],
    );
  }
}
