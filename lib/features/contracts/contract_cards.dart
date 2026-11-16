import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/contract_logic.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/invoice_logic.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/features/contracts/contract_actions.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/contracts/contract_widgets.dart';
import 'package:invoice_desk/features/editor/editor_cards.dart' show DateField;
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

part 'cards/calendar_link.dart';
part 'cards/lock_banner.dart';
part 'cards/details_card.dart';
part 'cards/variables_card.dart';
part 'cards/clauses_card.dart';
part 'cards/variable_field.dart';
part 'cards/scope_annex_card.dart';
part 'cards/payment_annex_card.dart';
part 'cards/linked_invoices_card.dart';

/// Watches one slice of the open contract (tolerates it closing).
T _watch<T>(WidgetRef ref, T Function(Contract c) pick) {
  final v = ref.watch(
    contractProvider.select(
      (s) => s.contract == null ? null : (pick(s.contract!),),
    ),
  );
  return v!.$1;
}

ContractController _ctl(WidgetRef ref) => ref.read(contractProvider.notifier);

bool _locked(WidgetRef ref) => _watch(ref, (c) => c.isLocked);

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

const _gap = SizedBox(height: Space.m - 4);

/// A date that may be empty, with a clear button.
class OptionalDateField extends ConsumerWidget {
  const OptionalDateField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.enabled = true,
  });

  final String label;
  final CalendarDate? value;
  final ValueChanged<CalendarDate?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final today = ref.watch(todayProvider);
    Future<void> pick() async {
      final picked = await showDatePicker(
        context: context,
        initialDate: (value ?? today).toDateTime(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) onChanged(CalendarDate.fromDateTime(picked));
    }

    return InkWell(
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      onTap: enabled ? () => unawaited(pick()) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          suffixIcon: value != null && enabled
              ? IconButton(
                  tooltip: l.clearDate,
                  icon: const Icon(Icons.close, size: 16),
                  onPressed: () => onChanged(null),
                )
              : const Icon(Icons.calendar_today_outlined, size: 16),
        ),
        child: Text(value == null ? '—' : formatArabicDate(value!)),
      ),
    );
  }
}

// ── Lock banner ──────────────────────────────────────────────────────────
// ── بيانات العقد ─────────────────────────────────────────────────────────
// ── المتغيرات ────────────────────────────────────────────────────────────
// ── البنود ───────────────────────────────────────────────────────────────
// ── ملحق (1) نطاق العمل ──────────────────────────────────────────────────
// ── ملحق (2) المقابل والدفعات ───────────────────────────────────────────
// ── الفواتير المرتبطة ────────────────────────────────────────────────────
/// Keeps `services.dart` imported for the shortcut constants in the page.
const contractSaveShortcut = SingleActivator(
  LogicalKeyboardKey.keyS,
  control: true,
);
