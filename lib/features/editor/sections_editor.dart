import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/digits.dart';
import 'package:invoice_desk/core/money.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

part 'sections/section_editor.dart';
part 'sections/item_row.dart';
part 'sections/service_field.dart';

/// A previously used service, for autocomplete.
class ServiceSuggestion {
  const ServiceSuggestion(this.item, this.currency);
  final LineItem item;
  final Currency currency;
}

/// Distinct services from all invoices, most recently updated first.
final serviceHistoryProvider = Provider<List<ServiceSuggestion>>((ref) {
  final invoices = [...?ref.watch(invoicesProvider).value]
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  final seen = <String>{};
  final out = <ServiceSuggestion>[];
  for (final inv in invoices) {
    for (final s in inv.sections) {
      for (final i in s.items) {
        final key = foldForSearch(i.service.trim());
        if (key.isEmpty || !seen.add(key)) continue;
        out.add(ServiceSuggestion(i, s.currency));
      }
    }
  }
  return out;
});

String cycleLabel(BuildContext context, BillingCycle c) => switch (c) {
  BillingCycle.oneTime => context.l10n.cycleOneTime,
  BillingCycle.monthly => context.l10n.cycleMonthly,
  BillingCycle.annual => context.l10n.cycleAnnual,
};

String _rawMoney(int minor) => minor % Currency.minorFactor == 0
    ? '${minor ~/ Currency.minorFactor}'
    : (minor / Currency.minorFactor).toStringAsFixed(2);

class SectionsCard extends ConsumerWidget {
  const SectionsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ids = ref.watch(
      editorProvider.select(
        (s) => s.invoice?.sections.map((e) => e.id).join(',') ?? '',
      ),
    );
    return PanelCard(
      title: l.cardSections,
      icon: Icons.view_list_outlined,
      trailing: TextButton.icon(
        onPressed: ref.read(editorProvider.notifier).addSection,
        icon: const Icon(Icons.add, size: 18),
        label: Text(l.addSection),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, id)
              in ids.split(',').where((e) => e.isNotEmpty).indexed) ...[
            if (i > 0) const SizedBox(height: Space.m),
            _SectionEditor(key: ValueKey(id), sectionId: id, index: i + 1),
          ],
        ],
      ),
    );
  }
}

// Column widths shared by header and rows.
