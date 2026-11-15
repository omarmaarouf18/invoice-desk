import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/l10n/l10n.dart';

/// "تعديل / معاينة" switch for narrow windows (Ctrl+1 / Ctrl+2), shared by
/// the invoice and contract editors.
class EditPreviewTabs extends ConsumerWidget {
  const EditPreviewTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return SegmentedButton<bool>(
      showSelectedIcon: false,
      segments: [
        ButtonSegment(
          value: false,
          label: Tooltip(message: 'Ctrl+1', child: Text(l.tabEdit)),
          icon: const Icon(Icons.edit_outlined, size: 16),
        ),
        ButtonSegment(
          value: true,
          label: Tooltip(message: 'Ctrl+2', child: Text(l.tabPreview)),
          icon: const Icon(Icons.visibility_outlined, size: 16),
        ),
      ],
      selected: {ref.watch(previewTabProvider)},
      onSelectionChanged: (s) =>
          ref.read(previewTabProvider.notifier).set(s.first),
    );
  }
}

/// "حفظ" and "PDF" buttons of an editor top bar.
class SaveExportButtons extends StatelessWidget {
  const SaveExportButtons({
    required this.onSave,
    required this.onExport,
    super.key,
  });

  final VoidCallback onSave;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: '${l.save} (Ctrl+S)',
          child: OutlinedButton(onPressed: onSave, child: Text(l.save)),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: '${l.exportPdfLong} (Ctrl+E)',
          child: FilledButton.icon(
            onPressed: onExport,
            icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
            label: Text(l.exportPdf),
          ),
        ),
      ],
    );
  }
}

/// The "…" menu button of an editor top bar.
class MoreMenu extends StatelessWidget {
  const MoreMenu({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => MenuAnchor(
    builder: (context, controller, _) => IconButton(
      key: const ValueKey('contract-more'),
      tooltip: context.l10n.more,
      onPressed: () =>
          controller.isOpen ? controller.close() : controller.open(),
      icon: const Icon(Icons.more_horiz),
    ),
    menuChildren: children,
  );
}

/// A red "حذف" menu entry.
class DeleteMenuItem extends StatelessWidget {
  const DeleteMenuItem({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final error = Theme.of(context).colorScheme.error;
    return MenuItemButton(
      leadingIcon: Icon(Icons.delete_outline, size: 18, color: error),
      onPressed: onPressed,
      child: Text(context.l10n.menuDelete, style: TextStyle(color: error)),
    );
  }
}
