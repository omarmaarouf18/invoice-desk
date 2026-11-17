import 'package:flutter/material.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';
import 'package:printing/printing.dart';

/// The rendered pages of a PDF, as every live preview shows them: white
/// pages on the lowest surface, no toolbar.
///
/// [render] must stay the same closure until the content changes, so the
/// pages only re-rasterise when there is something new to show.
class PdfPagesView extends StatelessWidget {
  const PdfPagesView({
    required this.render,
    super.key,
    this.maxPageWidth = 820,
  });

  final LayoutCallback render;

  /// The widest a page is drawn, in logical pixels.
  final double maxPageWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // The UI direction, for the message (the pages themselves are LTR).
    final uiDir = Directionality.of(context);
    // The page itself is laid out by the PDF; the scroll view is LTR so
    // the pages don't jump sides when the UI is Arabic.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PdfPreview(
        build: render,
        useActions: false,
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        maxPageWidth: maxPageWidth,
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
        // A calm message instead of the package's red error box (also what
        // tests see: they have no rasteriser).
        onError: (context, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Space.l),
            child: Text(
              context.l10n.previewFailed,
              textAlign: TextAlign.center,
              textDirection: uiDir,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
      ),
    );
  }
}
