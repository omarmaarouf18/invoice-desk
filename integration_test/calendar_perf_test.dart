// Profile-mode frame timing of the calendar's month view over 2,000
// invoices. Not part of `flutter test`; run on the desktop with:
//
//   flutter drive --profile -d linux \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/calendar_perf_test.dart
//
// The summary lands in build/calendar_month.timeline_summary.json.
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';

import '../test/helpers/harness.dart';

const invoiceCount = 2000;

/// 2,000 invoices over ±1 year around today: sent, paid and drafts, with a
/// monthly item on every fifth so renewals are in play too.
Future<void> seedMany(AppDatabase db) async {
  await seedDemo(db, clock: Clock.fixed(testNow));
  final clients = await db.clientsDao.getAll();
  final today = CalendarDate.fromDateTime(testNow);
  await db.transaction(() async {
    for (var i = 0; i < invoiceCount; i++) {
      final issue = today.addDays(-365 + (i * 730 ~/ invoiceCount));
      final status = InvoiceStatus.values[i % 3];
      await db.invoicesDao.saveInvoice(
        Invoice(
          id: 'perf-$i',
          clientId: clients[i % clients.length].id,
          number: 'P-${issue.year}-${i + 1}',
          year: issue.year,
          seq: i + 1,
          issueDate: issue,
          dueDate: issue.addDays(14 + i % 20),
          paidDate: status == InvoiceStatus.paid ? issue.addDays(10) : null,
          status: status,
          sections: [
            InvoiceSection(
              id: 'perf-s-$i',
              currency: i.isEven ? Currency.egp : Currency.usd,
              items: [
                LineItem(
                  id: 'perf-i-$i',
                  service: 'Service ${i % 40}',
                  cycle: i % 5 == 0
                      ? BillingCycle.monthly
                      : BillingCycle.oneTime,
                  unitPriceMinor: 10000 + i,
                ),
              ],
            ),
          ],
        ),
      );
    }
  });
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('month view, 2,000 invoices: frame timings', (tester) async {
    final db = AppDatabase.memory(seeder: seedMany);
    addTearDown(db.close);
    await tester.runAsync(() => db.settingsDao.get());
    final c = await pumpShell(tester, db);
    c.read(calendarModeProvider.notifier).set(true);
    await settle(tester);
    expect(
      await tester.runAsync(db.invoicesDao.countLive),
      greaterThanOrEqualTo(invoiceCount),
    );
    final ctl = c.read(calendarProvider.notifier);
    await binding.traceAction(() async {
      // Page through two years of months, then select days across a month.
      for (var i = 0; i < 12; i++) {
        ctl.page(i < 6 ? -1 : 1);
        await tester.pump(const Duration(milliseconds: 16));
        await tester.pump(const Duration(milliseconds: 16));
      }
      for (var d = 0; d < 30; d++) {
        ctl.moveDays(1);
        await tester.pump(const Duration(milliseconds: 16));
      }
    }, reportKey: 'calendar_month');
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
