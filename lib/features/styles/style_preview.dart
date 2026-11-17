import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/core/dates.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/doc_language.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/style_sample.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/pdf_render.dart';
import 'package:invoice_desk/features/preview/pdf_pages_view.dart';
import 'package:invoice_desk/features/styles/style_editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/pdf/contract_pdf.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:printing/printing.dart';

/// The middle column: the selected style on the open invoice (or contract),
/// else on a fictional sample, re-rendered 300 ms after the last edit like
/// the editors' previews.
class StylePreview extends ConsumerWidget {
  const StylePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PreviewToolbar(),
        Divider(height: 1),
        Expanded(child: _PreviewPages()),
      ],
    ),
  );
}

class _PreviewToolbar extends ConsumerWidget {
  const _PreviewToolbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final st = ref.watch(styleEditorProvider);
    final ctl = ref.read(styleEditorProvider.notifier);
    final openLang = ref.watch(
      editorProvider.select((s) => s.invoice?.language),
    );
    final hasInvoice = openLang != null;
    final defaultLang = ref.watch(
      settingsProvider.select((s) => s.value?.defaultDocLanguage),
    );
    final hasContract = ref.watch(
      contractProvider.select((s) => s.contract != null),
    );
    final contract = st.previewContract && hasContract;
    final langs = [
      DocLanguage.ar,
      if (!contract) DocLanguage.bilingual,
      DocLanguage.en,
    ];
    final onDoc = contract || hasInvoice;
    final shown = previewLanguageOf(
      st,
      contract: contract,
      documentLanguage: openLang ?? defaultLang ?? DocLanguage.ar,
    );
    return Padding(
      padding: const EdgeInsets.all(Space.s),
      child: Wrap(
        spacing: Space.m,
        runSpacing: Space.s,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: false, label: Text(l.stylePreviewInvoice)),
              ButtonSegment(
                value: true,
                enabled: hasContract,
                label: Text(l.stylePreviewContract),
              ),
            ],
            selected: {contract},
            onSelectionChanged: (v) => ctl.setPreviewContract(v.first),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.docLanguage,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(width: Space.s),
              DropdownButton<DocLanguage>(
                key: const ValueKey('style-preview-lang'),
                value: shown,
                underline: const SizedBox.shrink(),
                items: [
                  for (final lang in langs)
                    DropdownMenuItem(
                      value: lang,
                      child: Text(_langName(l, lang)),
                    ),
                ],
                onChanged: ctl.setPreviewLanguage,
              ),
            ],
          ),
          Text(
            onDoc ? l.stylePreviewOpenDoc : l.stylePreviewSample,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

/// The language the preview is drawn in: the one picked in the toolbar,
/// else [documentLanguage] (the open invoice's, or the default for the
/// sample). Contracts are Arabic or English only.
DocLanguage previewLanguageOf(
  StyleEditorState st, {
  required bool contract,
  required DocLanguage documentLanguage,
}) {
  final picked = st.previewLanguage ?? documentLanguage;
  if (contract) {
    return st.previewLanguage == DocLanguage.en
        ? DocLanguage.en
        : DocLanguage.ar;
  }
  return picked;
}

String _langName(AppLocalizations l, DocLanguage lang) => switch (lang) {
  DocLanguage.ar => l.docLanguageAr,
  DocLanguage.en => l.docLanguageEn,
  DocLanguage.bilingual => l.docLanguageBilingual,
};

class _PreviewPages extends ConsumerStatefulWidget {
  const _PreviewPages();

  @override
  ConsumerState<_PreviewPages> createState() => _PreviewPagesState();
}

class _PreviewPagesState extends ConsumerState<_PreviewPages> {
  static const _debounce = Duration(milliseconds: 300);
  Timer? _timer;
  LayoutCallback? _build;

  @override
  void initState() {
    super.initState();
    _snapshot();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _snapshot() {
    final settings = ref.read(settingsProvider).value;
    final fonts = ref.read(pdfFontsProvider).value;
    if (settings == null || fonts == null) return;
    final st = ref.read(styleEditorProvider);
    final style = st.style;
    final styles = ref.read(styleRepositoryProvider);
    final clients = ref.read(clientsProvider).value ?? const <Client>[];
    Client? clientOf(String id) => clients.where((c) => c.id == id).firstOrNull;
    final contract = ref.read(contractProvider).contract;
    LayoutCallback build;
    if (st.previewContract && contract != null) {
      final contracts = ref.read(contractsProvider).value ?? const <Contract>[];
      final lang = previewLanguageOf(
        st,
        contract: true,
        documentLanguage: DocLanguage.ar,
      );
      final data = ContractPdfData(
        contract: contract,
        client: clientOf(contract.clientId),
        settings: settings,
        parent: contracts.where((x) => x.id == contract.parentId).firstOrNull,
        language: lang,
      );
      build = (_) => renderContractInStyle(styles, data, fonts, style);
    } else {
      final open = ref.read(editorProvider).invoice;
      final today = CalendarDate.fromDateTime(ref.read(clockProvider).now());
      final base =
          open ?? styleSampleInvoice(settings.defaultDocLanguage, today);
      final inv = base.copyWith(
        language: previewLanguageOf(
          st,
          contract: false,
          documentLanguage: base.language,
        ),
      );
      final data = InvoicePdfData(
        invoice: inv,
        client: open == null ? styleSampleClient : clientOf(open.clientId),
        settings: settings,
      );
      build = (_) => renderInvoiceInStyle(styles, data, fonts, style);
    }
    setState(() => _build = build);
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(_debounce, () {
      if (mounted) _snapshot();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(
        styleEditorProvider.select((s) => s.revision),
        (_, _) => _schedule(),
      )
      ..listen(settingsProvider, (_, _) => _schedule())
      ..listen(clientsProvider, (_, _) => _schedule())
      ..listen(pdfFontsProvider, (_, _) => _schedule());
    final build = _build;
    if (build == null) {
      return Center(
        child: Text(
          context.l10n.previewLoading,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return PdfPagesView(render: build);
  }
}
