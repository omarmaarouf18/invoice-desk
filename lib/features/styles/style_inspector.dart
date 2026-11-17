import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/style_contrast.dart';
import 'package:invoice_desk/features/styles/blocks_group.dart';
import 'package:invoice_desk/features/styles/inspector_controls.dart';
import 'package:invoice_desk/features/styles/inspector_groups.dart';
import 'package:invoice_desk/features/styles/style_actions.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:invoice_desk/widgets/common.dart';

/// Edits the selected style; null while a preset is selected (every
/// control is then disabled).
typedef StyleEdit = void Function(DocumentStyle Function(DocumentStyle s));

/// The style shown and the edit callback, for one inspector group.
(DocumentStyle, StyleEdit?) watchStyle(WidgetRef ref) {
  final (style, preset) = ref.watch(
    styleEditorProvider.select((s) => (s.style, s.isPreset)),
  );
  return (style, preset ? null : ref.read(styleEditorProvider.notifier).edit);
}

/// The end column: every setting of the selected style, grouped as the
/// brief lists them. Edits autosave 600 ms after the last one.
class StyleInspector extends StatelessWidget {
  const StyleInspector({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsetsDirectional.only(bottom: Space.xl),
    children: const [
      _InspectorHeader(),
      SizedBox(height: Space.s),
      _ColoursGroup(),
      SizedBox(height: Space.s),
      _FontGroup(),
      SizedBox(height: Space.s),
      HeaderLogoGroup(),
      SizedBox(height: Space.s),
      TableGroup(),
      SizedBox(height: Space.s),
      TotalsGroup(),
      SizedBox(height: Space.s),
      BlocksGroup(),
      SizedBox(height: Space.s),
      FooterGroup(),
    ],
  );
}

class _InspectorHeader extends ConsumerWidget {
  const _InspectorHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final st = ref.watch(styleEditorProvider);
    final draft = st.draft;
    if (draft != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(Space.m),
          child: SyncedTextField(
            key: ValueKey('style-name-${draft.id}'),
            label: l.styleNameLabel,
            value: draft.name,
            onChanged: ref.read(styleEditorProvider.notifier).setName,
          ),
        ),
      );
    }
    final preset = DocPreset.fromId(st.selectedId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(presetName(l, preset), style: theme.textTheme.titleMedium),
            const SizedBox(height: Space.xs),
            Text(l.stylePresetReadOnly, style: theme.textTheme.bodySmall),
            const SizedBox(height: Space.s),
            FilledButton.icon(
              key: const ValueKey('style-duplicate-preset'),
              onPressed: () => unawaited(
                StyleActions(ref, context).duplicatePreset(preset),
              ),
              icon: const Icon(Icons.copy_outlined, size: 18),
              label: Text(l.styleDuplicateToCustomize),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColoursGroup extends ConsumerWidget {
  const _ColoursGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    ValueChanged<int>? set(DocumentStyle Function(int c) f) =>
        edit == null ? null : (c) => edit((_) => f(c));
    return PanelCard(
      title: l.styleGroupColours,
      icon: Icons.palette_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColourField(
            label: l.colourPrimary,
            value: s.primary,
            onChanged: set((c) => s.copyWith(primary: c)),
          ),
          ColourField(
            label: l.colourAccent,
            value: s.accent,
            onChanged: set((c) => s.copyWith(accent: c)),
          ),
          ColourField(
            label: l.colourInk,
            value: s.ink,
            onChanged: set((c) => s.copyWith(ink: c)),
          ),
          ColourField(
            label: l.colourMuted,
            value: s.muted,
            onChanged: set((c) => s.copyWith(muted: c)),
          ),
          ColourField(
            label: l.colourSurface,
            value: s.surface,
            onChanged: set((c) => s.copyWith(surface: c)),
          ),
          ColourField(
            label: l.colourTableHeader,
            value: s.tableHeaderBg,
            onChanged: set((c) => s.copyWith(tableHeaderBg: c)),
          ),
          ColourField(
            label: l.colourBorder,
            value: s.border,
            onChanged: set((c) => s.copyWith(border: c)),
          ),
          for (final issue in contrastIssues(s)) _ContrastNote(issue),
        ],
      ),
    );
  }
}

class _ContrastNote extends StatelessWidget {
  const _ContrastNote(this.issue);
  final ContrastIssue issue;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = missingColors(context);
    final pair = switch (issue.pair) {
      ContrastPair.inkOnPage => l.contrastInkOnPage,
      ContrastPair.mutedOnPage => l.contrastMutedOnPage,
      ContrastPair.primaryOnPage => l.contrastPrimaryOnPage,
      ContrastPair.inkOnSurface => l.contrastInkOnSurface,
      ContrastPair.mutedOnSurface => l.contrastMutedOnSurface,
      ContrastPair.mutedOnTableHeader => l.contrastMutedOnTableHeader,
      ContrastPair.whiteOnInk => l.contrastWhiteOnInk,
      ContrastPair.whiteOnPrimary => l.contrastWhiteOnPrimary,
    };
    return Padding(
      padding: const EdgeInsets.only(top: Space.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: c.fg),
          const SizedBox(width: Space.xs),
          Expanded(
            child: Text(
              l.contrastWarning(pair, issue.ratio.toStringAsFixed(1)),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: c.fg),
            ),
          ),
        ],
      ),
    );
  }
}

class _FontGroup extends ConsumerWidget {
  const _FontGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final (s, edit) = watchStyle(ref);
    String pt(double v) => l.pointsValue(
      v.toStringAsFixed(v == v.roundToDouble() ? 0 : 1),
    );
    return PanelCard(
      title: l.styleGroupFont,
      icon: Icons.text_fields,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChoiceRow<DocFontFamily>(
            label: l.fontFamily,
            value: s.fontFamily,
            options: [
              (DocFontFamily.ibmPlexSansArabic, l.fontPlex),
              (DocFontFamily.notoNaskhArabic, l.fontNaskh),
            ],
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(fontFamily: v)),
          ),
          SliderRow(
            label: l.fontBaseSize,
            value: s.baseSize,
            min: 8,
            max: 14,
            step: 0.5,
            format: pt,
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(baseSize: v)),
          ),
          SliderRow(
            label: l.fontScale,
            value: s.scale,
            min: 0.8,
            max: 1.5,
            step: 0.05,
            format: (v) => '${(v * 100).round()}%',
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(scale: v)),
          ),
          ChoiceRow<DocPaper>(
            label: l.paperSize,
            value: s.paper,
            options: [
              (DocPaper.a4, l.paperA4),
              (DocPaper.letter, l.paperLetter),
            ],
            onChanged: edit == null
                ? null
                : (v) => edit((x) => x.copyWith(paper: v)),
          ),
          MarginSliders(style: s, edit: edit, format: pt),
        ],
      ),
    );
  }
}
