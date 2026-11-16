import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';

import '../helpers/harness.dart';

final today = CalendarDate.fromDateTime(testNow);

Future<AppDatabase> demoDb() async {
  final db = AppDatabase.memory(
    seeder: (db) => seedDemo(db, clock: Clock.fixed(testNow)),
  );
  return db;
}

Future<Invoice> invoiceWhere(
  WidgetTester tester,
  AppDatabase db,
  bool Function(Invoice) test,
) async =>
    (await drive(tester, () => db.invoicesDao.getAll())).firstWhere(test);

Future<void> openCalendar(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyC);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
  await settle(tester);
}

Future<void> openDay(WidgetTester tester, CalendarDate d) async {
  await tester.tap(find.byKey(ValueKey('day-${d.toIso()}')));
  await settle(tester);
}

void main() {
  setUpAll(loadAppFonts);
  late AppDatabase db;
  setUp(() async => db = await demoDb());
  tearDown(() => db.close());

  testWidgets('Ctrl+Shift+C switches to the calendar and is remembered', (
    tester,
  ) async {
    final c = await pumpShell(tester, db);
    expect(find.byKey(const Key('today-banner')), findsOneWidget);
    expect(find.text('اليوم: 1 مستحق · 1 متأخر'), findsOneWidget);
    await openCalendar(tester);
    expect(c.read(calendarModeProvider), isTrue);
    expect(c.read(uiPrefsProvider).calendarMode, isTrue);
    expect(find.byKey(ValueKey('day-${today.toIso()}')), findsOneWidget);
    // Keyboard: W / A / M switch the view, arrows move the day (RTL).
    await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
    await settle(tester);
    expect(c.read(calendarProvider).view, CalendarView.week);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await settle(tester);
    expect(c.read(calendarProvider).selected, today.addDays(1));
    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await settle(tester);
    expect(c.read(calendarProvider).selected, today);
    expect(c.read(calendarProvider).panelOpen, isTrue);
  });

  testWidgets('mark paid from the day panel, then undo', (tester) async {
    await pumpShell(tester, db);
    await openCalendar(tester);
    await openDay(tester, today);
    final inv = await invoiceWhere(
      tester,
      db,
      (i) => i.dueDate == today && i.status == InvoiceStatus.sent,
    );
    await tester.tap(find.byKey(ValueKey('invoice-due-${inv.id}:actMarkPaid')));
    await settle(tester);
    final paid = await drive(tester, () => db.invoicesDao.getById(inv.id));
    expect(paid!.status, InvoiceStatus.paid);
    expect(paid.paidDate, today);
    await tester.tap(find.text('تراجع'));
    await settle(tester);
    final undone = await drive(tester, () => db.invoicesDao.getById(inv.id));
    expect(undone!.status, InvoiceStatus.sent);
    expect(undone.paidDate, isNull);
  });

  testWidgets('postpone keeps a history; the invoice moves and is not late', (
    tester,
  ) async {
    await pumpShell(tester, db);
    await openCalendar(tester);
    await openDay(tester, today);
    final inv = await invoiceWhere(
      tester,
      db,
      (i) => i.dueDate == today && i.status == InvoiceStatus.sent,
    );
    await tester.tap(find.byKey(ValueKey('invoice-due-${inv.id}:actPostpone')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('postpone-reason')), 'مهلة');
    await tester.tap(find.widgetWithText(FilledButton, 'تأجيل'));
    await settle(tester);
    final history = await drive(
      tester,
      () => db.calendarDao.postponementsOf(inv.id),
    );
    expect(history.single.fromDate, today);
    expect(history.single.toDate, today.addDays(7));
    expect(history.single.reason, 'مهلة');
    final moved = await drive(tester, () => db.invoicesDao.getById(inv.id));
    expect(moved!.effectiveDueDate, today.addDays(7));
    expect(moved.dueDate, today, reason: 'the original stays');
  });

  testWidgets('milestone → invoice and renewal → invoice', (tester) async {
    final c = await pumpShell(tester, db);
    await openCalendar(tester);
    // The upcoming milestone (in 18 days).
    c.read(calendarProvider.notifier).select(today.addDays(18), open: true);
    await settle(tester);
    final btn = find.byWidgetPredicate(
      (w) =>
          w.key is ValueKey<String> &&
          (w.key! as ValueKey<String>).value.endsWith(':actCreateInvoice'),
    );
    expect(btn, findsOneWidget);
    await tester.tap(btn);
    await settle(tester);
    final contracts = await drive(tester, () => db.contractsDao.getAll());
    final m = contracts
        .expand((k) => k.milestones)
        .firstWhere((m) => m.dueDate == today.addDays(18));
    expect(m.invoiceId, isNotNull);
    expect(c.read(calendarModeProvider), isFalse, reason: 'opens the result');

    // Renewal of the monthly hosting invoice (issued 25 days ago).
    final src = await invoiceWhere(
      tester,
      db,
      (i) =>
          i.issueDate == today.addDays(-25) && i.status == InvoiceStatus.paid,
    );
    final day = src.issueDate.addMonths(1);
    c.read(calendarModeProvider.notifier).set(true);
    c.read(calendarProvider.notifier).select(day, open: true);
    await settle(tester);
    await tester.tap(
      find.byKey(ValueKey('renewal-${src.id}-${day.toIso()}:actRenewInvoice')),
    );
    await settle(tester);
    final renewed = (await drive(
      tester,
      () => db.invoicesDao.getAll(),
    )).where((i) => i.issueDate == day && i.clientId == src.clientId);
    expect(renewed, hasLength(1));
    expect(renewed.single.isDemo, isFalse);
  });

  testWidgets('reminders: add, mark done, delete with undo', (tester) async {
    await pumpShell(tester, db);
    await openCalendar(tester);
    final day = today.addDays(2);
    await openDay(tester, day);
    await tester.tap(find.byKey(const Key('add-reminder')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('reminder-text')), 'اتصال');
    await tester.enterText(find.byKey(const Key('reminder-time')), '9:30');
    await tester.tap(find.widgetWithText(FilledButton, 'حفظ'));
    await settle(tester);
    var all = await drive(tester, () => db.calendarDao.allReminders());
    final r = all.firstWhere((x) => x.text == 'اتصال');
    expect(r.date, day);
    expect(r.time, '09:30');

    await tester.tap(find.byKey(ValueKey('reminder-${r.id}:actDone')));
    await settle(tester);
    expect(
      (await drive(tester, () => db.calendarDao.reminderById(r.id)))!.isDone,
      isTrue,
    );
    await tester.tap(find.byKey(ValueKey('reminder-${r.id}:actDelete')));
    await settle(tester);
    all = await drive(tester, () => db.calendarDao.allReminders());
    expect(all.where((x) => x.id == r.id), isEmpty);
    await tester.tap(find.text('تراجع'));
    await settle(tester);
    all = await drive(tester, () => db.calendarDao.allReminders());
    expect(all.where((x) => x.id == r.id), hasLength(1));
  });

  testWidgets('drag a due chip to another day = postpone; Esc cancels', (
    tester,
  ) async {
    await pumpShell(tester, db);
    await openCalendar(tester);
    final inv = await invoiceWhere(
      tester,
      db,
      (i) => i.dueDate == today && i.status == InvoiceStatus.sent,
    );
    Future<void> dragTo(CalendarDate target) async {
      final chip = find.descendant(
        of: find.byKey(ValueKey('day-${today.toIso()}')),
        matching: find.byType(Draggable<CalendarEvent>),
      );
      final from = tester.getCenter(chip.first);
      final to = tester.getCenter(
        find.byKey(ValueKey('day-${target.toIso()}')),
      );
      final g = await tester.startGesture(from);
      await tester.pump(const Duration(milliseconds: 50));
      await g.moveTo(to);
      await tester.pump(const Duration(milliseconds: 50));
      await g.up();
      await settle(tester);
    }

    await dragTo(today.addDays(2));
    expect(find.byKey(const Key('postpone-reason')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await settle(tester);
    expect(
      await drive(tester, () => db.calendarDao.postponementsOf(inv.id)),
      isEmpty,
    );

    await dragTo(today.addDays(2));
    await tester.enterText(find.byKey(const Key('postpone-reason')), 'سفر');
    await tester.tap(find.widgetWithText(FilledButton, 'تأجيل'));
    await settle(tester);
    final h = await drive(tester, () => db.calendarDao.postponementsOf(inv.id));
    expect(h.single.toDate, today.addDays(2));
  });

  testWidgets('"في التقويم" from the invoice editor selects the event', (
    tester,
  ) async {
    final c = await pumpShell(tester, db);
    final inv = await invoiceWhere(
      tester,
      db,
      (i) => i.dueDate == today.addDays(3),
    );
    await drive(tester, () => c.read(editorProvider.notifier).open(inv.id));
    await settle(tester);
    await tester.ensureVisible(find.byKey(const Key('in-calendar')));
    await tester.tap(find.byKey(const Key('in-calendar')));
    await settle(tester);
    final s = c.read(calendarProvider);
    expect(c.read(calendarModeProvider), isTrue);
    expect(s.selected, today.addDays(3));
    expect(s.selectedEventId, 'invoice-due-${inv.id}');
    expect(s.panelOpen, isTrue);
  });
}
