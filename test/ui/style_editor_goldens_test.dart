// The style editor «تصميم المستندات», in both directions.
//
// The PDF preview has no rasteriser in tests, so its pane stays empty;
// these lock the list, the toolbar and the inspector layout.
//
// Regenerate with `flutter test --tags golden --update-goldens`.
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';

import '../helpers/harness.dart';
import '../helpers/legacy_seed.dart';

void main() {
  setUpAll(loadAppFonts);

  for (final lang in [UiLanguage.ar, UiLanguage.en]) {
    testWidgets('style editor (${lang.name})', (tester) async {
      final db = AppDatabase.memory(seeder: legacySeed);
      addTearDown(() => tester.runAsync(db.close));
      final c = await pumpShell(
        tester,
        db,
        language: lang,
        size: const Size(1800, 1100),
      );
      final style = (await tester.runAsync(
        () => c
            .read(styleRepositoryProvider)
            .duplicateStyle(
              id: 'golden-style',
              name: 'Acme Studio',
              presetId: DocPreset.modern.id,
            ),
      ))!;
      c.read(workspaceProvider.notifier).show(Workspace.styles);
      await settle(tester);
      await drive(
        tester,
        () => c.read(styleEditorProvider.notifier).selectUser(style),
      );
      await settle(tester);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/style_editor_${lang.name}.png'),
      );
    });
  }
}
