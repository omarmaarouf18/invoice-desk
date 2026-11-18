import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Every global keyboard shortcut, in one table: the shell binds these and
/// Settings → About lists them, so the two can never disagree.
enum AppShortcut {
  newInvoice(LogicalKeyboardKey.keyN, 'N'),
  newClient(LogicalKeyboardKey.keyN, 'N', shift: true),
  newContract(LogicalKeyboardKey.keyK, 'K', shift: true),
  toggleCalendar(LogicalKeyboardKey.keyC, 'C', shift: true),
  search(LogicalKeyboardKey.keyK, 'K'),
  find(LogicalKeyboardKey.keyF, 'F'),
  save(LogicalKeyboardKey.keyS, 'S'),
  exportPdf(LogicalKeyboardKey.keyE, 'E'),
  duplicate(LogicalKeyboardKey.keyD, 'D'),
  renew(LogicalKeyboardKey.keyR, 'R'),
  editTab(LogicalKeyboardKey.digit1, '1'),
  previewTab(LogicalKeyboardKey.digit2, '2');

  const AppShortcut(this.key, this.keyLabel, {this.shift = false});

  /// The key pressed with Ctrl.
  final LogicalKeyboardKey key;

  /// [key] as printed: `N`, `1`.
  final String keyLabel;

  /// Also needs Shift.
  final bool shift;

  /// What the shell binds.
  SingleActivator get activator =>
      SingleActivator(key, control: true, shift: shift);

  /// `Ctrl+Shift+N`, always in Latin, read left to right.
  String get keys => shift ? 'Ctrl+Shift+$keyLabel' : 'Ctrl+$keyLabel';
}

/// The shell's bindings: each shortcut's activator to [action]'s callback.
Map<ShortcutActivator, VoidCallback> shortcutBindings(
  VoidCallback Function(AppShortcut s) action,
) => {for (final s in AppShortcut.values) s.activator: action(s)};
