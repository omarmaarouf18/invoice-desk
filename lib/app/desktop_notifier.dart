import 'dart:io';

import 'package:flutter/foundation.dart';

/// Seam: an optional desktop notification. The Linux implementation uses
/// `notify-send` when it is installed and does nothing otherwise.
// ignore: one_member_abstracts, a seam with platform implementations
abstract interface class DesktopNotifier {
  /// Shows [title] / [body]; never throws.
  Future<void> show(String title, String body);
}

/// `notify-send` (libnotify) on Linux; silently skipped elsewhere or when
/// the tool is missing.
class LinuxDesktopNotifier implements DesktopNotifier {
  const LinuxDesktopNotifier();

  @override
  Future<void> show(String title, String body) async {
    if (!Platform.isLinux) return;
    try {
      await Process.run('notify-send', [
        '--app-name=Invoice Desk',
        '--icon=me.omarmaarouf.invoice_desk',
        title,
        body,
      ]);
    } on Object catch (e) {
      debugPrint('notification skipped: $e');
    }
  }
}

/// Tests and platforms without a notifier.
class NoopDesktopNotifier implements DesktopNotifier {
  const NoopDesktopNotifier();

  @override
  Future<void> show(String title, String body) async {}
}
