// The Arabic ARB file is the template; the English one must have exactly the
// same keys, the same placeholders and the same ICU plural branches. A
// missing key would fall back to Arabic inside an English screen, which is
// the kind of bug nobody notices until a user points at it.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _load(String name) =>
    jsonDecode(
          File('lib/l10n/arb/$name').readAsStringSync(),
        )
        as Map<String, Object?>;

/// The placeholder names in a message, ignoring ICU plural branches: the
/// branch bodies hold literal text, not placeholders.
Set<String> _used(String message) => RegExp(
  r'\{([A-Za-z_][A-Za-z0-9_]*)\}',
).allMatches(message).map((m) => m.group(1)!).toSet();

/// The plural branches a message uses (`=1`, `few`, `other`, …).
Set<String> _plurals(String message) => RegExp(
  r'(?:[=!]\d+|\b(?:zero|one|two|few|many|other))\s*\{',
).allMatches(message).map((m) => m.group(0)!.trim()).toSet();

void main() {
  final ar = _load('app_ar.arb');
  final en = _load('app_en.arb');

  List<String> messages(Map<String, Object?> arb) =>
      arb.keys.where((k) => !k.startsWith('@') && k != '@@locale').toList()
        ..sort();

  test('both ARB files have the same keys', () {
    expect(messages(en), messages(ar));
    expect(en['@@locale'], 'en');
    expect(ar['@@locale'], 'ar');
  });

  test('every English message is filled in', () {
    for (final key in messages(en)) {
      final value = en[key];
      expect(value, isA<String>(), reason: key);
      expect((value! as String).trim(), isNotEmpty, reason: key);
    }
  });

  test('placeholders match the template declarations', () {
    for (final key in messages(ar)) {
      final meta = ar['@$key'] as Map<String, Object?>?;
      final declared =
          (meta?['placeholders'] as Map<String, Object?>?)?.keys.toSet() ??
          <String>{};
      expect(_used(en[key]! as String), declared, reason: key);
      expect(_used(ar[key]! as String), declared, reason: key);
    }
  });

  test('ICU plural branches match', () {
    for (final key in messages(ar)) {
      expect(
        _plurals(en[key]! as String),
        _plurals(ar[key]! as String),
        reason: key,
      );
    }
  });
}
