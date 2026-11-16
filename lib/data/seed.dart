import 'package:clock/clock.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/demo_seed.dart';
import 'package:invoice_desk/domain/models.dart';

const defaultNotesEn = '''
Covers initial setup plus the first billing period of every recurring service.
Monthly items renew each month unless cancelled with 7 days' notice; annual items renew each year unless cancelled before the renewal date.
One-time items will not appear on future invoices.
USD items may be paid in EGP at the bank's selling rate on the payment date.''';

const defaultNotesAr = '''
تغطي هذه الفاتورة تكاليف الإعداد وأول فترة لكل خدمة متكررة.
البنود الشهرية تتجدد كل شهر ما لم تُلغَ بإشعار قبلها بـ 7 أيام، والسنوية تتجدد كل سنة ما لم تُلغَ قبل موعد التجديد.
البنود التي تُدفع مرة واحدة لن تظهر في الفواتير القادمة.
يجوز سداد البنود الدولارية بالجنيه بسعر البيع في البنك يوم السداد.''';

/// A fresh install's profile: empty (the "أكمل بياناتك" banner asks for
/// it), with the default notes and a neutral invoice prefix.
const seedSettings = Settings(
  invoicePrefix: 'INV',
  notesEn: defaultNotesEn,
  notesAr: defaultNotesAr,
);

/// Fresh install: the empty profile plus the fictional demo set, dated
/// around today on the zone's clock.
Future<void> seedDatabase(AppDatabase db) async {
  await db.settingsDao.save(seedSettings);
  await seedDemo(db, clock: clock);
}
