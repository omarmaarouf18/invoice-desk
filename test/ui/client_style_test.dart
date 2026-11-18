import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/clients/client_dialog.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

/// The client's preferred document style (`clients.style_id`), chosen in
/// the client dialog; "Follow the default" is null.
void main() {
  setUpAll(loadAppFonts);

  Finder picker() => find.byWidgetPredicate(
    (w) =>
        w is DropdownButtonFormField<String?> &&
        (w.key! as ValueKey<String>).value.startsWith(
          'style-picker-Preferred document style',
        ),
  );

  Future<Future<Client?>> open(WidgetTester tester, Client? client) async {
    final db = AppDatabase.memory(seeder: legacySeed);
    addTearDown(() => tester.runAsync(db.close));
    await pumpShell(tester, db, language: UiLanguage.en);
    final ctx = tester.element(find.byType(Scaffold).first);
    final result = showClientDialog(ctx, client: client);
    await settle(tester);
    return result;
  }

  testWidgets('a new client follows the default until a style is picked', (
    tester,
  ) async {
    final result = await open(tester, null);
    expect(find.text('Follow the default'), findsOneWidget);
    // No way out to the style editor from inside the dialog.
    expect(find.byTooltip('Edit styles…'), findsNothing);

    await tester.enterText(
      find
          .descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextField),
          )
          .first,
      'Acme Studio',
    );
    tester.widget<DropdownButtonFormField<String?>>(picker()).onChanged!(
      DocPreset.modern.id,
    );
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Save'),
      ),
    );
    await settle(tester);
    final c = (await result)!;
    expect(c.name, 'Acme Studio');
    expect(c.styleId, DocPreset.modern.id);
  });

  testWidgets('"Follow the default" clears a client\'s style', (
    tester,
  ) async {
    const client = Client(
      id: 'c9',
      name: 'Sample Academy',
      styleId: 'preset_bold',
    );
    final result = await open(tester, client);
    expect(find.text('Bold'), findsOneWidget);

    tester.widget<DropdownButtonFormField<String?>>(picker()).onChanged!(null);
    await settle(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Save'),
      ),
    );
    await settle(tester);
    expect((await result)!.styleId, isNull);
  });
}
