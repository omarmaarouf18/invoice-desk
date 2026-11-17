import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/features/styles/inspector_controls.dart';
import 'package:invoice_desk/features/styles/style_actions.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/features/styles/style_inspector.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// The three page margins, in points.
class MarginSliders extends StatelessWidget {
  const MarginSliders({
    required this.style,
    required this.edit,
    required this.format,
    super.key,
  });

  final DocumentStyle style;
  final StyleEdit? edit;
  final String Function(double v) format;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final e = edit;
    SliderRow row(
      String label,
      double v,
      DocumentStyle Function(DocumentStyle s, double v) f,
    ) => SliderRow(
      label: label,
      value: v,
      min: 15,
      max: 80,
      step: 1,
      format: format,
      onChanged: e == null ? null : (x) => e((s) => f(s, x)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        row(
          l.marginSide,
          style.marginHorizontal,
          (s, v) => s.copyWith(marginHorizontal: v),
        ),
        row(l.marginTop, style.marginTop, (s, v) => s.copyWith(marginTop: v)),
        row(
          l.marginBottom,
          style.marginBottom,
          (s, v) => s.copyWith(marginBottom: v),
        ),
      ],
    );
  }
}

class HeaderLogoGroup extends ConsumerWidget {
  const HeaderLogoGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    return PanelCard(
      title: l.styleGroupHeader,
      icon: Icons.web_asset_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChoiceRow<HeaderStyle>(
            label: l.headerStyleLabel,
            value: s.headerStyle,
            options: [
              (HeaderStyle.band, l.headerBand),
              (HeaderStyle.rule, l.headerRule),
              (HeaderStyle.none, l.headerNone),
            ],
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(headerStyle: v)),
          ),
          _LogoRow(assetId: s.logoAssetId, enabled: edit != null),
          if (s.logoAssetId != null) ...[
            SliderRow(
              label: l.logoSize,
              value: s.logoSize,
              min: 20,
              max: 120,
              step: 2,
              format: (v) => l.pointsValue('${v.round()}'),
              onChanged: edit == null
                  ? null
                  : (v) => edit((x) => x.copyWith(logoSize: v)),
            ),
            ChoiceRow<LogoPosition>(
              label: l.logoPosition,
              value: s.logoPosition,
              options: [
                (LogoPosition.start, l.positionStart),
                (LogoPosition.center, l.positionCenter),
                (LogoPosition.end, l.positionEnd),
              ],
              onChanged: edit == null
                  ? null
                  : (v) => edit((x) => x.copyWith(logoPosition: v)),
            ),
          ],
          ToggleRow(
            label: l.showRole,
            value: s.showRole,
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(showRole: v)),
          ),
          ToggleRow(
            label: l.showCity,
            value: s.showCity,
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(showCity: v)),
          ),
          ToggleRow(
            label: l.showContacts,
            value: s.showContacts,
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(showContacts: v)),
          ),
        ],
      ),
    );
  }
}

class _LogoRow extends ConsumerStatefulWidget {
  const _LogoRow({required this.assetId, required this.enabled});
  final String? assetId;
  final bool enabled;

  @override
  ConsumerState<_LogoRow> createState() => _LogoRowState();
}

class _LogoRowState extends ConsumerState<_LogoRow> {
  Future<Uint8List?>? _bytes;
  String? _loaded;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final id = widget.assetId;
    if (id != _loaded) {
      _loaded = id;
      _bytes = id == null
          ? null
          : ref.read(styleRepositoryProvider).getAsset(id);
    }
    final a = StyleActions(ref, context);
    final enabled = widget.enabled;
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.s),
      child: Row(
        children: [
          _LogoBox(bytes: _bytes),
          const SizedBox(width: Space.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: Space.xs,
                  children: [
                    OutlinedButton(
                      key: const ValueKey('style-logo-choose'),
                      onPressed: enabled
                          ? () => unawaited(a.chooseLogo())
                          : null,
                      child: Text(l.logoChoose),
                    ),
                    if (id != null)
                      TextButton(
                        onPressed: enabled ? a.removeLogo : null,
                        child: Text(l.logoRemove),
                      ),
                  ],
                ),
                Text(l.logoHint, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBox extends StatelessWidget {
  const _LogoBox({required this.bytes});
  final Future<Uint8List?>? bytes;

  @override
  Widget build(BuildContext context) => Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Space.radiusSmall),
      border: Border.all(color: context.colors.border),
    ),
    padding: const EdgeInsets.all(Space.xs),
    child: FutureBuilder<Uint8List?>(
      future: bytes,
      builder: (context, snap) => snap.data == null
          ? Icon(Icons.image_outlined, color: context.colors.muted)
          : Image.memory(
              snap.data!,
              fit: BoxFit.contain,
              semanticLabel: context.l10n.logoLabel,
            ),
    ),
  );
}

class TableGroup extends ConsumerWidget {
  const TableGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    return PanelCard(
      title: l.styleGroupTable,
      icon: Icons.table_rows_outlined,
      child: ChoiceRow<TableStyle>(
        label: l.tableStyleLabel,
        value: s.tableStyle,
        options: [
          (TableStyle.plain, l.tablePlain),
          (TableStyle.striped, l.tableStriped),
          (TableStyle.bordered, l.tableBordered),
        ],
        onChanged: edit == null
            ? null
            : (v) => edit((x) => x.copyWith(tableStyle: v)),
      ),
    );
  }
}

class TotalsGroup extends ConsumerWidget {
  const TotalsGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    return PanelCard(
      title: l.styleGroupTotals,
      icon: Icons.functions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChoiceRow<TotalsStyle>(
            label: l.totalsStyleLabel,
            value: s.totalsStyle,
            options: [
              (TotalsStyle.outlined, l.totalsOutlined),
              (TotalsStyle.solid, l.totalsSolid),
              (TotalsStyle.plain, l.totalsPlain),
            ],
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(totalsStyle: v)),
          ),
          ToggleRow(
            label: l.showVatRow,
            value: s.showVatRow,
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(showVatRow: v)),
          ),
          ToggleRow(
            label: l.showPaidStamp,
            value: s.showPaidStamp,
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(showPaidStamp: v)),
          ),
        ],
      ),
    );
  }
}

class FooterGroup extends ConsumerWidget {
  const FooterGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    final id = ref.watch(styleEditorProvider.select((x) => x.selectedId));
    return PanelCard(
      title: l.styleGroupFooter,
      icon: Icons.short_text,
      child: Column(
        children: [
          SyncedTextField(
            key: ValueKey('footer-ar-$id'),
            label: l.footerAr,
            value: s.footerTextAr,
            readOnly: edit == null,
            maxLines: 3,
            minLines: 2,
            textDirection: TextDirection.rtl,
            onChanged: (v) => edit?.call((x) => x.copyWith(footerTextAr: v)),
          ),
          const SizedBox(height: Space.s),
          SyncedTextField(
            key: ValueKey('footer-en-$id'),
            label: l.footerEn,
            value: s.footerTextEn,
            readOnly: edit == null,
            maxLines: 3,
            minLines: 2,
            textDirection: TextDirection.ltr,
            onChanged: (v) => edit?.call((x) => x.copyWith(footerTextEn: v)),
          ),
        ],
      ),
    );
  }
}
