import 'dart:io';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:invoice_desk/data/app_paths.dart';
import 'package:invoice_desk/data/backup.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/data/repositories/trash_repository.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/trash.dart';

/// The style editor's repository actions and document styles in the trash.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late Directory dir;
  late StyleRepository styles;
  late TrashRepository trash;
  var now = DateTime.utc(2026, 11, 17, 12);

  final png = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 1, 2, 3, 4, //
  ]);

  setUp(() async {
    now = DateTime.utc(2026, 11, 17, 12);
    db = AppDatabase.memory();
    dir = await Directory.systemTemp.createTemp('styles');
    styles = StyleRepository(db, clock: Clock(() => now));
    trash = TrashRepository(db, BackupService(db, paths: AppPaths(dir)));
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  test('duplicating a preset keeps it as the base', () async {
    final s = await styles.duplicateStyle(
      id: 'u1',
      name: 'Brand',
      presetId: DocPreset.formal.id,
    );
    expect(s.basePreset, 'formal');
    expect(s.style, DocPreset.formal.style);
    expect((await styles.getUserStyleById('u1'))?.name, 'Brand');
  });

  test('names are made unique; rename trims and ignores empty', () async {
    await styles.duplicateStyle(id: 'a', name: 'Brand', presetId: 'classic');
    final b = await styles.duplicateStyle(
      id: 'b',
      name: 'Brand',
      presetId: 'classic',
    );
    expect(b.name, 'Brand (2)');
    await styles.renameStyle('b', '  Night  ');
    expect((await styles.getUserStyleById('b'))?.name, 'Night');
    await styles.renameStyle('b', '   ');
    expect((await styles.getUserStyleById('b'))?.name, 'Night');
  });

  test('reset goes back to the base preset but keeps name and logo', () async {
    final logo = await styles.saveAsset(bytes: png);
    final s = await styles.duplicateStyle(
      id: 'u',
      name: 'Mine',
      presetId: 'bold',
    );
    await styles.saveUserStyle(
      s.copyWith(
        style: s.style.copyWith(primary: 0xFF000000, logoAssetId: logo),
      ),
    );
    await styles.resetStyle('u');
    final back = (await styles.getUserStyleById('u'))!;
    expect(back.name, 'Mine');
    expect(back.style, DocPreset.bold.style.copyWith(logoAssetId: logo));
  });

  test('export then import moves the style and its logo', () async {
    final logo = await styles.saveAsset(bytes: png);
    final s = await styles.duplicateStyle(
      id: 'u',
      name: 'Travel',
      presetId: 'modern',
    );
    final custom = s.style.copyWith(logoAssetId: logo, footerTextEn: 'Hi');
    await styles.saveUserStyle(s.copyWith(style: custom));
    final raw = (await styles.exportStyleFile('u'))!;

    final imported = await styles.importStyleFile(
      raw,
      id: 'u2',
      fallbackName: 'Imported',
    );
    expect(imported.name, 'Travel (2)');
    expect(imported.basePreset, 'modern');
    expect(imported.style, custom); // Same content hash, same asset id.
    expect(await styles.getAsset(imported.style.logoAssetId!), png);
  });

  test('import rejects a non-style file and a bad logo', () async {
    expect(
      () => styles.importStyleFile('{}', id: 'x', fallbackName: 'X'),
      throwsFormatException,
    );
    const bad =
        '{"format":"invoice-desk-style","version":1,"style":{},'
        '"logo":{"mime":"image/gif","base64":"R0lGODlh"}}';
    expect(
      () => styles.importStyleFile(bad, id: 'x', fallbackName: 'X'),
      throwsA(isA<InvalidAssetException>()),
    );
    expect(await styles.getUserStyles(), isEmpty);
  });

  test('a deleted style is in the trash, restores and purges', () async {
    await styles.duplicateStyle(id: 'u', name: 'Old', presetId: 'minimal');
    await styles.softDeleteUserStyle('u');
    final entry = (await trash.entries()).single;
    expect(entry.kind, TrashKind.style);
    expect(entry.label, 'Old');

    expect(await trash.restore(entry), isA<Restored>());
    expect(await styles.getUserStyleById('u'), isNotNull);

    await styles.softDeleteUserStyle('u');
    final backup = await trash.purge((await trash.entries()).single);
    expect(backup.existsSync(), isTrue);
    expect(await trash.entries(), isEmpty);
    expect(await db.select(db.documentStyles).get(), isEmpty);
  });

  test('styles older than 30 days in the trash are purged', () async {
    await styles.duplicateStyle(id: 'old', name: 'Old', presetId: 'classic');
    await styles.duplicateStyle(id: 'new', name: 'New', presetId: 'classic');
    await styles.softDeleteUserStyle('old');
    now = now.add(const Duration(days: 20));
    await styles.softDeleteUserStyle('new');
    now = now.add(const Duration(days: 11));

    expect(await styles.purgeDeletedStyles(), 1);
    final left = await db.select(db.documentStyles).get();
    expect(left.map((r) => r.id), ['new']);
  });

  test('a document style with a stale id falls back to Classic', () async {
    expect(
      await styles.resolveStyle(styleId: 'gone'),
      const DocumentStyle(),
    );
  });
}
