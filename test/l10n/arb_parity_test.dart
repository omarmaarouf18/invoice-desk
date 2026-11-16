// The Arabic ARB file is the template; the English one must have exactly the
// same keys, the same placeholders and the same ICU plural branches. A
// missing key would fall back to Arabic inside an English screen, which is
// the kind of bug nobody notices until a user points at it.
//
// A count is a special case: "1 invoices" is not English. Every count is
// therefore rendered through an ICU plural form, and the test fails when a
// count is written as a bare number.

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

Map<String, Object?> _load(String name) =>
    jsonDecode(
          File('lib/l10n/arb/$name').readAsStringSync(),
        )
        as Map<String, Object?>;

/// The placeholder names in a message. A plural expression counts as one
/// placeholder: its branch bodies refer to it, they do not add one.
Set<String> _used(String message) => _uses(message).map((u) => u.name).toSet();

/// The plural branches a message uses (`=1`, `few`, `other`, …).
Set<String> _plurals(String message) => RegExp(
  r'(?:[=!]\d+|\b(?:zero|one|two|few|many|other))\s*\{',
).allMatches(message).map((m) => m.group(0)!.trim()).toSet();

/// One `{…}` placeholder in a message.
class _Use {
  const _Use({required this.name, required this.end, required this.plural});

  /// The name of the placeholder.
  final String name;

  /// The index after the closing brace.
  final int end;

  /// Whether it is written as `{name, plural, …}`.
  final bool plural;
}

/// Every placeholder in [message], with the place it was written at.
List<_Use> _uses(String message) {
  final uses = <_Use>[];
  var i = 0;
  while (i < message.length) {
    final open = message.indexOf('{', i);
    if (open < 0) break;
    final close = _closingBrace(message, open);
    if (close < 0) break;
    final body = message.substring(open + 1, close);
    uses.add(
      _Use(
        name: body.split(',').first.trim(),
        end: close + 1,
        plural: body.contains(','),
      ),
    );
    i = close + 1;
  }
  return uses;
}

/// The index of the brace that closes the one at [open], or -1.
int _closingBrace(String message, int open) {
  var depth = 0;
  for (var i = open; i < message.length; i++) {
    if (message[i] == '{') {
      depth++;
    } else if (message[i] == '}') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

/// Whether the text after [use] carries on with a word: "{count} invoices"
/// counts the invoices, "Contracts ({count})" does not.
bool _followedByWord(String message, _Use use) {
  var i = use.end;
  while (i < message.length && message[i].trim().isEmpty) {
    i++;
  }
  if (i >= message.length) return false;
  return _isLetter(message[i]);
}

/// A letter of a script the app knows (Latin, Greek, Cyrillic, Hebrew,
/// Arabic and their extensions).
bool _isLetter(String c) {
  final cp = c.codeUnitAt(0);
  return (cp >= 0x41 && cp <= 0x5A) || // A-Z
      (cp >= 0x61 && cp <= 0x7A) || // a-z
      (cp >= 0x00C0 && cp <= 0x024F) || // Latin extended
      (cp >= 0x0370 && cp <= 0x052F) || // Greek, Cyrillic
      (cp >= 0x0590 && cp <= 0x05FF) || // Hebrew
      (cp >= 0x0600 && cp <= 0x06FF) || // Arabic
      (cp >= 0x0750 && cp <= 0x077F) || // Arabic supplement
      (cp >= 0x08A0 && cp <= 0x08FF) || // Arabic extended-A
      (cp >= 0xFB50 && cp <= 0xFDFF) || // Hebrew, Arabic presentation
      (cp >= 0xFE70 && cp <= 0xFEFF); // Arabic presentation-B
}

/// The declared type of every placeholder of a key.
Map<String, String> _types(Map<String, Object?>? meta) {
  final placeholders =
      (meta?['placeholders'] as Map<String, Object?>?) ?? <String, Object?>{};
  return {
    for (final entry in placeholders.entries)
      entry.key:
          (entry.value as Map<String, Object?>?)?['type'] as String? ?? '',
  };
}

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

  test('a count is written as a plural, in both languages', () {
    for (final arb in [en, ar]) {
      for (final key in messages(arb)) {
        final message = arb[key]! as String;
        final types = _types(arb['@$key'] as Map<String, Object?>?);
        for (final use in _uses(message)) {
          if (types[use.name] != 'int') continue;
          // A count that names what it counts ("{count} invoices") and a
          // placeholder called "count" always need a plural form. A bare
          // number that stands on its own ("+{count}", "Section {n}") does
          // not.
          final counts = use.name == 'count' || _followedByWord(message, use);
          if (!counts) continue;
          expect(
            use.plural,
            isTrue,
            reason:
                '$key: {${use.name}} counts something and needs a plural form, '
                'for example {${use.name}, plural, =1{one} other{{${use.name}} many}}',
          );
        }
      }
    }
  });
}
