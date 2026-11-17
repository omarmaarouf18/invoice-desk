import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/domain/doc_format.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

part 'cards/calendar_link.dart';
part 'cards/details_card.dart';
part 'cards/totals_card.dart';
part 'cards/notes_scope_cards.dart';

/// Watches one slice of the open invoice. The selector tolerates the
/// invoice closing (the card is then disposed before it rebuilds).
T _watchInv<T>(WidgetRef ref, T Function(Invoice i) pick) {
  final v = ref.watch(
    editorProvider.select(
      (s) => s.invoice == null ? null : (pick(s.invoice!),),
    ),
  );
  return v!.$1;
}

EditorController _ctl(WidgetRef ref) => ref.read(editorProvider.notifier);

/// Two fields side by side on the 8 px grid.
class _Pair extends StatelessWidget {
  const _Pair(this.a, this.b);
  final Widget a;
  final Widget b;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: a),
      const SizedBox(width: Space.m - 4),
      Expanded(child: b),
    ],
  );
}

// ── بيانات الفاتورة ──────────────────────────────────────────────────────
// ── الإجماليات والضريبة ─────────────────────────────────────────────────
// ── ملاحظات ─────────────────────────────────────────────────────────────
// ── صفحة نطاق المشروع ───────────────────────────────────────────────────
