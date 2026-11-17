import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/features/styles/style_inspector.dart';
import 'package:invoice_desk/features/styles/style_list.dart';
import 'package:invoice_desk/features/styles/style_preview.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// «تصميم المستندات»: the style list on the start side, the live preview
/// in the middle and the inspector on the end side. Below
/// [threeColumnWidth] the preview and the inspector share the middle as
/// two tabs, so the preview never gets squeezed.
class StylesPage extends ConsumerStatefulWidget {
  const StylesPage({super.key});

  /// The narrowest width that fits list + preview (≥ 380) + inspector.
  static const threeColumnWidth = 1180.0;

  @override
  ConsumerState<StylesPage> createState() => _StylesPageState();
}

class _StylesPageState extends ConsumerState<StylesPage> {
  // Captured while ref is valid; also used from dispose.
  late final StyleEditorController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = ref.read(styleEditorProvider.notifier);
  }

  @override
  void dispose() {
    unawaited(_ctl.flush());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<CustomStyle>>>(userStylesProvider, (_, next) {
      final v = next.value;
      if (v != null) _ctl.sync(v);
    });
    return Padding(
      padding: const EdgeInsets.all(Space.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _StylesHeader(),
          const SizedBox(height: Space.m),
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) =>
                  box.maxWidth >= StylesPage.threeColumnWidth
                  ? const _ThreeColumns()
                  : const _TwoColumns(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeColumns extends StatelessWidget {
  const _ThreeColumns();

  @override
  Widget build(BuildContext context) => const Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SizedBox(width: 260, child: StyleList()),
      SizedBox(width: Space.m),
      Expanded(child: StylePreview()),
      SizedBox(width: Space.m),
      SizedBox(width: 360, child: StyleInspector()),
    ],
  );
}

class _TwoColumns extends StatelessWidget {
  const _TwoColumns();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(width: 240, child: StyleList()),
        const SizedBox(width: Space.m),
        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TabBar(
                  tabs: [
                    Tab(text: l.tabPreview),
                    Tab(text: l.tabEdit),
                  ],
                ),
                const SizedBox(height: Space.s),
                const Expanded(
                  child: TabBarView(
                    children: [StylePreview(), StyleInspector()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StylesHeader extends ConsumerWidget {
  const _StylesHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l.stylesTitle,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              Text(l.stylesSubtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        OutlinedButton.icon(
          key: const ValueKey('styles-back'),
          onPressed: () => ref.read(workspaceProvider.notifier).back(),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: Text(l.back),
        ),
      ],
    );
  }
}
