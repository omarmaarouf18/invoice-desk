import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/calendar_repository.dart';
import 'package:invoice_desk/data/repositories/client_repository.dart';
import 'package:invoice_desk/data/repositories/contract_repository.dart';
import 'package:invoice_desk/data/repositories/demo_repository.dart';
import 'package:invoice_desk/data/repositories/invoice_repository.dart';
import 'package:invoice_desk/data/repositories/library_repository.dart';
import 'package:invoice_desk/data/repositories/settings_repository.dart';
import 'package:invoice_desk/data/repositories/trash_repository.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/trash.dart';

// The data layer's providers. Features read repositories from here and
// never touch the database, DAOs or drift directly (enforced by
// test/architecture/layering_test.dart).

/// Seam: the open database, overridden in bootstrap and tests.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('override databaseProvider'),
);

/// Seam: where the database, UI prefs and backups live.
final appPathsProvider = Provider<AppPaths>(
  (ref) => throw UnimplementedError('override appPathsProvider'),
);

/// The one clock: UI dates and every timestamp the data layer writes.
final clockProvider = Provider<Clock>((ref) => const Clock());

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final clientRepositoryProvider = Provider<ClientRepository>(
  (ref) => ClientRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final invoiceRepositoryProvider = Provider<InvoiceRepository>(
  (ref) => InvoiceRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final contractRepositoryProvider = Provider<ContractRepository>(
  (ref) => ContractRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(databaseProvider),
    paths: ref.watch(appPathsProvider),
    clock: ref.watch(clockProvider),
  ),
);

final trashRepositoryProvider = Provider<TrashRepository>(
  (ref) => TrashRepository(
    ref.watch(databaseProvider),
    ref.watch(backupServiceProvider),
    clock: ref.watch(clockProvider),
  ),
);

// Live read models.

final settingsProvider = StreamProvider<Settings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final clientsProvider = StreamProvider<List<Client>>(
  (ref) => ref.watch(clientRepositoryProvider).watchAll(),
);

final invoicesProvider = StreamProvider<List<Invoice>>(
  (ref) => ref.watch(invoiceRepositoryProvider).watchAll(),
);

final contractsProvider = StreamProvider<List<Contract>>(
  (ref) => ref.watch(contractRepositoryProvider).watchAll(),
);

/// The clause library (Settings → مكتبة البنود).
final libraryProvider = StreamProvider<List<ClauseTemplate>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchAll(),
);

/// "المحذوفات", newest deletion first.
final trashProvider = StreamProvider<List<TrashEntry>>(
  (ref) => ref.watch(trashRepositoryProvider).watch(),
);

final calendarRepositoryProvider = Provider<CalendarRepository>(
  (ref) => CalendarRepository(
    ref.watch(databaseProvider),
    clock: ref.watch(clockProvider),
  ),
);

final demoRepositoryProvider = Provider<DemoRepository>(
  (ref) => DemoRepository(
    ref.watch(databaseProvider),
    ref.watch(backupServiceProvider),
    clock: ref.watch(clockProvider),
  ),
);

final postponementsProvider = StreamProvider<List<Postponement>>(
  (ref) => ref.watch(calendarRepositoryProvider).watchPostponements(),
);

final remindersProvider = StreamProvider<List<Reminder>>(
  (ref) => ref.watch(calendarRepositoryProvider).watchReminders(),
);

/// Settings → البيانات التجريبية: show "إضافة" or "حذف".
final hasDemoProvider = StreamProvider<bool>(
  (ref) => ref.watch(demoRepositoryProvider).watchHasDemo(),
);
