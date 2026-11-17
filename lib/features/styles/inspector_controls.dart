import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// A labelled one-of-N choice. [onChanged] null disables it (a preset).
class ChoiceRow<T extends Object> extends StatelessWidget {
  const ChoiceRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final List<(T, String)> options;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Space.s),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: Space.xs),
        SegmentedButton<T>(
          showSelectedIcon: false,
          segments: [
            for (final (v, text) in options)
              ButtonSegment(value: v, label: Text(text)),
          ],
          selected: {value},
          onSelectionChanged: onChanged == null
              ? null
              : (s) => onChanged!(s.first),
        ),
      ],
    ),
  );
}

/// A labelled slider with its value shown at the end.
class SliderRow extends StatelessWidget {
  const SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.step,
    required this.format,
    required this.onChanged,
    super.key,
  });

  final String label;
  final double value;
  final double min;
  final double max;

  /// The grid the value snaps to.
  final double step;
  final String Function(double v) format;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) {
    final shown = format(value);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            Ltr(shown),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: ((max - min) / step).round(),
          label: shown,
          semanticFormatterCallback: (_) => '$label $shown',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// A switch row for one visibility toggle.
class ToggleRow extends StatelessWidget {
  const ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    value: value,
    onChanged: onChanged,
  );
}

/// The palette offered by [ColourField]: calm, print-safe colours.
const stylePalette = [
  0xFF0F1B2D, 0xFF111827, 0xFF374151, 0xFF5B6878, //
  0xFF0F766E, 0xFF1D4ED8, 0xFF6D28D9, 0xFFB91C1C, //
  0xFFB45309, 0xFF15803D, 0xFFF3F6F9, 0xFFFFFFFF, //
];

/// One style colour: a swatch that opens [stylePalette], and the hex code
/// to type an exact colour (always LTR).
class ColourField extends StatelessWidget {
  const ColourField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;

  /// Opaque ARGB.
  final int value;
  final ValueChanged<int>? onChanged;

  static String hex(int argb) =>
      (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final enabled = onChanged != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.s),
      child: Row(
        children: [
          _Swatch(
            label: label,
            value: value,
            onPick: enabled ? onChanged : null,
          ),
          const SizedBox(width: Space.s),
          Expanded(
            child: SyncedTextField(
              key: ValueKey('hex-$label'),
              label: label,
              value: hex(value),
              dense: true,
              readOnly: !enabled,
              textDirection: TextDirection.ltr,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9a-fA-F]')),
                LengthLimitingTextInputFormatter(6),
              ],
              hint: l.colourHexInvalid,
              onChanged: (v) {
                if (v.length != 6) return;
                final parsed = int.tryParse(v, radix: 16);
                if (parsed != null) onChanged?.call(0xFF000000 | parsed);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatefulWidget {
  const _Swatch({required this.label, required this.value, this.onPick});
  final String label;
  final int value;
  final ValueChanged<int>? onPick;

  @override
  State<_Swatch> createState() => _SwatchState();
}

class _SwatchState extends State<_Swatch> {
  final _menu = MenuController();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final pick = widget.onPick;
    return MenuAnchor(
      controller: _menu,
      menuChildren: [
        Padding(
          padding: const EdgeInsets.all(Space.s),
          child: SizedBox(
            width: 4 * 28 + 3 * Space.xs,
            child: Wrap(
              spacing: Space.xs,
              runSpacing: Space.xs,
              children: [
                for (final c in stylePalette)
                  Semantics(
                    button: true,
                    label: '#${ColourField.hex(c)}',
                    child: InkWell(
                      onTap: () {
                        _menu.close();
                        pick?.call(c);
                      },
                      child: _Chip(color: c, size: 28),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
      builder: (context, menu, _) => Tooltip(
        message: '${l.colourPick}: ${widget.label}',
        child: InkWell(
          borderRadius: BorderRadius.circular(Space.radiusSmall),
          onTap: pick == null
              ? null
              : () => menu.isOpen ? menu.close() : menu.open(),
          child: _Chip(color: widget.value, size: 36),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.color, required this.size});
  final int color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Color(color | 0xFF000000),
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      border: Border.all(color: context.colors.border),
    ),
  );
}
