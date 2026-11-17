import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

/// Small per-machine UI state (window bounds, last invoice, theme, last
/// export folder) kept in a JSON file next to the database. Writes are
/// debounced and atomic (temp file + rename).
class UiPrefs {
  UiPrefs(this._file, Map<String, Object?> data) : _data = data;

  /// In-memory prefs for tests.
  factory UiPrefs.memory() => UiPrefs(File(''), {});

  static Future<UiPrefs> load(File file) async {
    try {
      if (file.existsSync()) {
        final decoded = jsonDecode(await file.readAsString());
        if (decoded is Map<String, Object?>) return UiPrefs(file, decoded);
      }
    } on Object {
      // Corrupt prefs are not worth failing start-up for.
    }
    return UiPrefs(file, {});
  }

  final File _file;
  final Map<String, Object?> _data;
  Timer? _timer;

  String? get lastInvoiceId => _data['lastInvoiceId'] as String?;
  set lastInvoiceId(String? v) => _set('lastInvoiceId', v);

  String? get lastExportDir => _data['lastExportDir'] as String?;
  set lastExportDir(String? v) => _set('lastExportDir', v);

  ThemeMode get themeMode => ThemeMode.values.firstWhere(
    (m) => m.name == _data['themeMode'],
    orElse: () => ThemeMode.system,
  );
  set themeMode(ThemeMode m) => _set('themeMode', m.name);

  /// UI language: `system`, `ar` or `en` (see `UiLanguage`); null until
  /// the user picks one.
  String? get uiLanguage => _data['uiLanguage'] as String?;
  set uiLanguage(String? v) => _set('uiLanguage', v);

  /// Top-level switch: the calendar instead of invoices & contracts.
  /// The Settings section last shown (a `SettingsSection` name).
  String? get settingsSection => _data['settingsSection'] as String?;
  set settingsSection(String? v) => _set('settingsSection', v);

  bool get calendarMode => _data['calendarMode'] == true;
  set calendarMode(bool v) => _set('calendarMode', v);

  /// `month`, `week` or `agenda`.
  String get calendarView => _data['calendarView'] as String? ?? 'month';
  set calendarView(String v) => _set('calendarView', v);

  /// `saturday`, `sunday` or `monday`.
  String get weekStart => _data['weekStart'] as String? ?? 'saturday';
  set weekStart(String v) => _set('weekStart', v);

  /// Desktop notification on start (off by default).
  bool get notifyOnStart => _data['notifyOnStart'] == true;
  set notifyOnStart(bool v) => _set('notifyOnStart', v);

  /// `YYYY-MM-DD` the "today" banner was dismissed on.
  String? get todayBannerDismissed => _data['todayBannerDismissed'] as String?;
  set todayBannerDismissed(String? v) => _set('todayBannerDismissed', v);

  /// The "أكمل بياناتك" banner was dismissed.
  bool get profileBannerDismissed => _data['profileBannerDismissed'] == true;
  set profileBannerDismissed(bool v) => _set('profileBannerDismissed', v);

  Rect? get windowBounds {
    final b = _data['window'];
    if (b is! List || b.length != 4) return null;
    final v = b.whereType<num>().map((e) => e.toDouble()).toList();
    if (v.length != 4) return null;
    return Rect.fromLTWH(v[0], v[1], v[2], v[3]);
  }

  set windowBounds(Rect? r) => _set(
    'window',
    r == null ? null : [r.left, r.top, r.width, r.height],
  );

  void _set(String key, Object? value) {
    if (_data[key] == value) return;
    _data[key] = value;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 400), () => unawaited(flush()));
  }

  Future<void> flush() async {
    _timer?.cancel();
    if (_file.path.isEmpty) return;
    try {
      final tmp = File('${_file.path}.tmp');
      await tmp.writeAsString(jsonEncode(_data), flush: true);
      await tmp.rename(_file.path);
    } on Object catch (e) {
      debugPrint('UiPrefs flush failed: $e');
    }
  }
}
