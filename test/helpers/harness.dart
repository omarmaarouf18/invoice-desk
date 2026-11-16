import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/account/account.dart';
import 'package:invoice_desk/app/app.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/app/ui_prefs.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/library_seed.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/sync/sync.dart';

final testNow = DateTime(2026, 11, 15, 10);

Future<void> loadAppFonts() async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  Future<ByteData> read(String path) async =>
      ByteData.sublistView(File(path).readAsBytesSync());
  final plex = FontLoader('IBMPlexSansArabic');
  for (final w in ['Regular', 'SemiBold', 'Bold']) {
    plex.addFont(read('assets/fonts/IBMPlexSansArabic-$w.ttf'));
  }
  await plex.load();
  final root =
      Platform.environment['FLUTTER_ROOT'] ??
      File(
        Platform.resolvedExecutable,
      ).parent.parent.parent.parent.parent.parent.path;
  final icons = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (icons.existsSync()) {
    await (FontLoader('MaterialIcons')..addFont(read(icons.path))).load();
  }
}

/// Pumps the full app shell over [db] at a desktop size.
///
/// The UI language is Arabic unless [language] says otherwise, so the
/// Arabic screens keep their own tests; the English ones ask for
/// [UiLanguage.en].
Future<ProviderContainer> pumpShell(
  WidgetTester tester,
  AppDatabase db, {
  ThemeMode mode = ThemeMode.light,
  Size size = const Size(1440, 900),
  UiLanguage language = UiLanguage.ar,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final prefs = UiPrefs.memory()
    ..themeMode = mode
    ..uiLanguage = language.name;
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      accountServiceProvider.overrideWithValue(const LocalAccountService()),
      syncServiceProvider.overrideWithValue(const NoopSyncService()),
      uiPrefsProvider.overrideWithValue(prefs),
      clockProvider.overrideWithValue(Clock.fixed(testNow)),
      // The real one reads the platform plugin, which is not there in a test.
      appVersionProvider.overrideWith((ref) async => '0.4.0'),
      appPathsProvider.overrideWithValue(
        AppPaths(Directory.systemTemp.createTempSync('idesk')),
      ),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const InvoiceDeskApp(),
    ),
  );
  await settle(tester);
  return container;
}

/// Pumps the app with a contract open for the seeded client, with a
/// milestone invoice and (when [complete]) a signed contract and an
/// amendment.
Future<ProviderContainer> pumpContractEditor(
  WidgetTester tester,
  AppDatabase db, {
  required bool complete,
  ThemeMode mode = ThemeMode.light,
  UiLanguage language = UiLanguage.ar,
}) async {
  final client = (await tester.runAsync(db.clientsDao.getAll))!.single;
  if (complete) {
    await tester.runAsync(
      () => db.clientsDao.upsert(
        client.copyWith(
          legalName: 'أكاديمية العينة للتعليم',
          representative: 'أحمد علي',
          representativeTitle: 'المدير التنفيذي',
        ),
      ),
    );
  }
  final c = await pumpShell(tester, db, mode: mode, language: language);
  final t = (await tester.runAsync(db.libraryDao.getAll))!.firstWhere(
    (x) => x.name == developmentTemplateName,
  );
  final ctl = c.read(contractProvider.notifier);
  await drive(
    tester,
    () => ctl.create(
      NewContractRequest(
        clientId: client.id,
        template: t,
        title: 'تطوير وتشغيل منصة تعليمية',
        projectName: 'منصة العينة',
      ),
    ),
  );
  ctl.edit((k) => k.copyWith(totalMinor: 18000000));
  await drive(tester, ctl.flush);
  final first = c.read(contractProvider).contract!;
  await drive(
    tester,
    () => ctl.createInvoiceFromMilestone(first.milestones.first.id),
  );
  if (complete) {
    ctl.setStatus(ContractStatus.signed, missing: const []);
    await drive(tester, ctl.flush);
    await drive(
      tester,
      () => ctl.createAmendment(
        first.id,
        preamble: (n, d) => 'إلحاقًا بالعقد رقم $n المؤرخ في $d.',
        clauseTitle: 'موضوع التعديل',
      ),
    );
    await drive(tester, () => ctl.open(first.id));
  }
  await settle(tester);
  return c;
}

/// Lets drift's async queries complete, then settles frames.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 200));
  }
}

/// Runs [fn] in the test's fake zone and pumps frames until it completes,
/// so drift queries and widget-driven queries share one zone.
Future<T> drive<T>(WidgetTester tester, Future<T> Function() fn) async {
  var done = false;
  Object? error;
  late T value;
  unawaited(
    fn().then(
      (v) {
        value = v;
        done = true;
      },
      onError: (Object e) {
        error = e;
        done = true;
      },
    ),
  );
  for (var i = 0; i < 200 && !done; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  if (error != null) return Future<T>.error(error!);
  if (!done) fail('drive(): future did not complete');
  await tester.pump();
  return value;
}
