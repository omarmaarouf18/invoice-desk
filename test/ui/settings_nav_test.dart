import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/settings/settings_section.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

/// Phase 6: sectioned settings with search; autosave still works.
void main() {
  setUpAll(loadAppFonts);

  Finder section(SettingsSection s) =>
      find.byKey(ValueKey('settings-section-${s.name}'));

  testWidgets('search narrows the sections; Enter opens the first', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    c.read(workspaceProvider.notifier).show(Workspace.settings);
    await settle(tester);
    for (final s in SettingsSection.values) {
      expect(section(s), findsOneWidget, reason: s.name);
    }

    // A control label, not a section name, finds its section.
    await tester.enterText(
      find.byKey(const ValueKey('settings-search')),
      'iban',
    );
    await settle(tester);
    expect(section(SettingsSection.payment), findsOneWidget);
    expect(section(SettingsSection.general), findsNothing);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);
    expect(c.read(settingsSectionProvider), SettingsSection.payment);
    expect(c.read(uiPrefsProvider).settingsSection, 'payment');

    await tester.enterText(
      find.byKey(const ValueKey('settings-search')),
      'zzz-nothing',
    );
    await settle(tester);
    expect(find.text('No settings match.'), findsOneWidget);
  });

  testWidgets('an edit in a section still autosaves', (tester) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    c.read(workspaceProvider.notifier).show(Workspace.settings);
    await settle(tester);
    await tester.tap(section(SettingsSection.profile));
    await settle(tester);
    final website = find.widgetWithText(TextField, 'Website');
    await tester.enterText(website, 'acme.example');
    await settle(tester);
    // Past the 600 ms debounce.
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    final saved = (await tester.runAsync(db.settingsDao.get))!;
    expect(saved.website, 'acme.example');
  });

  testWidgets('new invoices use the numbering, VAT and currency settings', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final s = (await tester.runAsync(db.settingsDao.get))!;
    await tester.runAsync(
      () => db.settingsDao.save(
        s.copyWith(
          invoicePrefix: 'AS',
          invoiceNumberPattern: '{PREFIX}/{YY}/{SEQ:3}',
          defaultVatOn: true,
          defaultVatRateBp: 500,
          defaultCurrency: Currency.sar,
        ),
      ),
    );
    final c = await pumpShell(tester, db);
    final client = (await tester.runAsync(db.clientsDao.getAll))!.single;
    await drive(
      tester,
      () => c.read(editorProvider.notifier).newInvoice(clientId: client.id),
    );
    await settle(tester);
    final inv = c.read(editorProvider).invoice!;
    // The seed already has 2026-0001, so the next is 2.
    expect(inv.number, 'AS/26/002');
    expect((inv.year, inv.seq), (2026, 2));
    expect(inv.vatOn, isTrue);
    expect(inv.vatRateBp, 500);
    expect(inv.sections.first.currency, Currency.sar);
    await drive(tester, c.read(editorProvider.notifier).flush);
    await settle(tester); // UiPrefs writes are debounced too.
  });

  testWidgets('the numbering card previews the next number and flags errors', (
    tester,
  ) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    final c = await pumpShell(tester, db, language: UiLanguage.en);
    openSettingsFor(c, SettingsSection.invoices);
    await settle(tester);
    final preview = find.byKey(const ValueKey('number-next-preview'));
    await tester.ensureVisible(preview);
    expect(find.text('Next number: OM-2026-0002'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('number-pattern')),
        matching: find.byType(TextField),
      ),
      '{PREFIX}-{SEQ:4}',
    );
    await settle(tester);
    expect(find.textContaining('so numbers never repeat'), findsOneWidget);
    expect(preview, findsNothing);
  });
}

void openSettingsFor(ProviderContainer c, SettingsSection s) {
  c.read(settingsSectionProvider.notifier).set(s);
  c.read(workspaceProvider.notifier).show(Workspace.settings);
}
