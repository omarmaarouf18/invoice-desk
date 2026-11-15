import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/app.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/app/ui_prefs.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/db.dart';

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
Future<ProviderContainer> pumpShell(
  WidgetTester tester,
  AppDatabase db, {
  ThemeMode mode = ThemeMode.light,
  Size size = const Size(1440, 900),
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final prefs = UiPrefs.memory()..themeMode = mode;
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      uiPrefsProvider.overrideWithValue(prefs),
      clockProvider.overrideWithValue(Clock.fixed(testNow)),
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
