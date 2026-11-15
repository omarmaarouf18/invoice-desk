import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/pdf/invoice_pdf.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:printing/printing.dart';

/// The real PDF, re-rendered 300 ms after the last edit.
class PreviewPane extends ConsumerStatefulWidget {
  const PreviewPane({super.key});

  @override
  ConsumerState<PreviewPane> createState() => _PreviewPaneState();
}

class _PreviewPaneState extends ConsumerState<PreviewPane> {
  static const _debounce = Duration(milliseconds: 300);

  Timer? _timer;
  InvoicePdfData? _data;

  /// Stable closure per snapshot, so PdfPreview only re-rasterises when the
  /// snapshot changes.
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
    final inv = ref.read(editorProvider).invoice;
    final settings = ref.read(settingsProvider).value;
    final fonts = ref.read(pdfFontsProvider).value;
    if (inv == null || settings == null || fonts == null) return;
    final clients = ref.read(clientsProvider).value ?? const <Client>[];
    final data = InvoicePdfData(
      invoice: inv,
      client: clients.where((c) => c.id == inv.clientId).firstOrNull,
      settings: settings,
    );
    setState(() {
      _data = data;
      _build = (_) => buildInvoicePdf(data, fonts);
    });
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
      ..listen(editorProvider.select((s) => s.revision), (_, _) => _schedule())
      ..listen(settingsProvider, (_, _) => _schedule())
      ..listen(clientsProvider, (_, _) => _schedule())
      ..listen(pdfFontsProvider, (_, _) => _schedule());
    final theme = Theme.of(context);
    final build = _build;
    if (build == null || _data == null) {
      return Center(
        child: Text(
          context.l10n.previewLoading,
          style: theme.textTheme.bodySmall,
        ),
      );
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PdfPreview(
        build: build,
        useActions: false,
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        maxPageWidth: 820,
        padding: const EdgeInsets.all(Space.l),
        previewPageMargin: const EdgeInsets.only(bottom: Space.m),
        scrollViewDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
        ),
        pdfPreviewPageDecoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: context.colors.border),
        ),
        loadingWidget: const SizedBox.shrink(),
      ),
    );
  }
}
