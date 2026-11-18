import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/machine_prefs.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/app/shortcuts.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/theme/app_theme.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  group('MachinePrefs', () {
    test('missing or garbage values are the defaults', () {
      for (final json in <Map<String, Object?>>[
        {},
        {'density': 'huge', 'accent': 7, 'pdfNamePattern': '   '},
      ]) {
        final p = MachinePrefs.fromJson(json);
        expect(p.density, UiDensity.compact);
        expect(p.accent, UiAccent.teal);
        expect(p.startupView, StartupView.last);
        expect(p.pdfNamePattern, MachinePrefs.defaultPdfNamePattern);
        expect(p.exportFolder, isNull);
        expect(p.openAfterExport, isFalse);
      }
    });

    test('round-trips through JSON', () {
      const p = MachinePrefs(
        density: UiDensity.comfortable,
        accent: UiAccent.rose,
        startupView: StartupView.calendar,
        pdfNamePattern: '{DATE} {NUMBER}',
        exportFolder: '/tmp/out',
        openAfterExport: true,
      );
      final back = MachinePrefs.fromJson(p.toJson());
      expect(back.toJson(), p.toJson());
    });
  });

  group('PDF file names', () {
    String name(String client, {String pattern = '{NUMBER} - {CLIENT}'}) =>
        pdfFileName(
          pattern,
          number: 'OM-2026-0001',
          client: client,
          date: '2026-09-14',
        );

    test("the default is today's name, illegal characters dropped", () {
      expect(name('Acme Studio'), 'OM-2026-0001 - Acme Studio');
      expect(name('Acme/Studio: Ltd?'), 'OM-2026-0001 - AcmeStudio Ltd');
      expect(name(''), 'OM-2026-0001');
    });

    test('tokens fill in; an empty result falls back to the number', () {
      expect(
        name('Acme', pattern: '{DATE}_{NUMBER}'),
        '2026-09-14_OM-2026-0001',
      );
      expect(name('', pattern: '{CLIENT}'), 'OM-2026-0001');
    });
  });

  test('every shortcut has its own key combination', () {
    final combos = {
      for (final s in AppShortcut.values) (s.key, s.shift),
    };
    expect(combos, hasLength(AppShortcut.values.length));
    expect(AppShortcut.newClient.keys, 'Ctrl+Shift+N');
    expect(
      shortcutBindings((_) => () {}),
      hasLength(AppShortcut.values.length),
    );
  });

  testWidgets('an accent recolours the app; teal is the built-in palette', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final c = await pumpShell(tester, db);
    Color primary() => Theme.of(
      tester.element(find.byType(Scaffold).first),
    ).colorScheme.primary;
    expect(primary(), buildTheme(Brightness.light).colorScheme.primary);

    c
        .read(machinePrefsProvider.notifier)
        .update((p) => p.copyWith(accent: UiAccent.rose));
    await settle(tester);
    expect(primary(), isNot(buildTheme(Brightness.light).colorScheme.primary));
    expect(c.read(uiPrefsProvider).machine['accent'], 'rose');
  });

  testWidgets('"start in the calendar" wins over the remembered mode', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final c = await pumpShell(
      tester,
      db,
      machine: const MachinePrefs(startupView: StartupView.calendar),
    );
    expect(c.read(calendarModeProvider), isTrue);
  });
}
