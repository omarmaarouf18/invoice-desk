import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/features/styles/style_actions.dart';
import 'package:invoice_desk/features/styles/style_thumbnail.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// Picks a document style: the presets and the user's styles, each with
/// its thumbnail, and an "Edit styles…" button that opens the editor.
///
/// [nullLabel] names the "no style of its own" choice (`value == null`);
/// without it there is no such choice. [onChanged] null disables the field
/// and [helper] says why (the look is locked).
class DocStylePicker extends ConsumerWidget {
  const DocStylePicker({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.nullLabel,
    this.helper,
    this.showEditButton = true,
  });

  final String label;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? nullLabel;
  final String? helper;

  /// The "Edit styles…" button; off inside a dialog, where leaving for
  /// the style editor would hide behind it.
  final bool showEditButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final mine = ref.watch(userStylesProvider).value ?? const <CustomStyle>[];
    final entries = <(String?, String, DocumentStyle?)>[
      if (nullLabel != null) (null, nullLabel!, null),
      for (final p in DocPreset.values) (p.id, presetName(l, p), p.style),
      for (final s in mine) (s.id, s.name, s.style),
    ];
    // A style that was deleted shows as the null choice (or Classic).
    final known = entries.any((e) => e.$1 == value);
    final shown = known
        ? value
        : (nullLabel != null ? null : DocPreset.classic.id);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DropdownButtonFormField<String?>(
            key: ValueKey('style-picker-$label-$shown-${mine.length}'),
            initialValue: shown,
            isExpanded: true,
            decoration: InputDecoration(labelText: label, helperText: helper),
            items: [
              for (final (id, name, style) in entries)
                DropdownMenuItem(
                  value: id,
                  child: Row(
                    children: [
                      if (style == null)
                        const SizedBox(
                          width: 16,
                          child: Icon(Icons.link, size: 16),
                        )
                      else
                        StyleThumbnail(style: style, width: 16),
                      const SizedBox(width: Space.s),
                      Expanded(
                        child: Text(name, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
            ],
            onChanged: onChanged,
          ),
        ),
        if (showEditButton) ...[
          const SizedBox(width: Space.xs),
          IconButton(
            tooltip: l.docStyleEdit,
            onPressed: () =>
                ref.read(workspaceProvider.notifier).show(Workspace.styles),
            icon: const Icon(Icons.palette_outlined),
          ),
        ],
      ],
    );
  }
}
