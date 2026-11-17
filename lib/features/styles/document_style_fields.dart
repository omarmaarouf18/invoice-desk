import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/features/contracts/contract_controller.dart';
import 'package:invoice_desk/features/editor/editor_controller.dart';
import 'package:invoice_desk/features/styles/style_picker.dart';
import 'package:invoice_desk/l10n/l10n.dart';

/// The open invoice's style. Disabled, with «التصميم مثبّت…», once the
/// look is frozen (sent or paid, or sent before styles existed).
class InvoiceStyleField extends ConsumerWidget {
  const InvoiceStyleField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final inv = ref.watch(editorProvider.select((s) => s.invoice));
    // A save may take the snapshot without touching the editor's copy.
    final saved = ref.watch(
      editorProvider.select((s) => s.status == SaveStatus.saved),
    );
    if (inv == null) return const SizedBox.shrink();
    return _LockAware(
      // Recheck when the document, its status or its saved state changes.
      lockKey:
          '${inv.id}|${inv.status.name}|${inv.styleSnapshot != null}|$saved',
      look: (repo) => repo.lookForInvoice(inv, withLogo: false),
      builder: ({required locked}) => DocStylePicker(
        label: l.docStyle,
        value: inv.styleId,
        nullLabel: l.docStyleFollows,
        helper: locked ? l.styleLockedInvoice : null,
        onChanged: locked
            ? null
            : (id) => ref
                  .read(editorProvider.notifier)
                  .edit((i) => i.copyWith(styleId: () => id)),
      ),
    );
  }
}

/// The open contract's style; frozen once it is signed.
class ContractStyleField extends ConsumerWidget {
  const ContractStyleField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = ref.watch(contractProvider.select((s) => s.contract));
    final saved = ref.watch(
      contractProvider.select((s) => s.status == SaveStatus.saved),
    );
    if (c == null) return const SizedBox.shrink();
    return _LockAware(
      lockKey: '${c.id}|${c.status.name}|${c.styleSnapshot != null}|$saved',
      look: (repo) => repo.lookForContract(c, withLogo: false),
      builder: ({required locked}) => DocStylePicker(
        label: l.docStyle,
        value: c.styleId,
        nullLabel: l.docStyleFollows,
        helper: locked ? l.styleLockedContract : null,
        onChanged: locked || c.isLocked
            ? null
            : (id) => ref
                  .read(contractProvider.notifier)
                  .edit((x) => x.copyWith(styleId: () => id)),
      ),
    );
  }
}

/// Asks the repository whether the look is locked, once per [lockKey].
class _LockAware extends ConsumerStatefulWidget {
  const _LockAware({
    required this.lockKey,
    required this.look,
    required this.builder,
  });

  final String lockKey;
  final Future<ResolvedLook> Function(StyleRepository repo) look;
  final Widget Function({required bool locked}) builder;

  @override
  ConsumerState<_LockAware> createState() => _LockAwareState();
}

class _LockAwareState extends ConsumerState<_LockAware> {
  String? _key;
  Future<bool>? _locked;

  @override
  Widget build(BuildContext context) {
    if (_key != widget.lockKey) {
      _key = widget.lockKey;
      _locked = widget
          .look(ref.read(styleRepositoryProvider))
          .then((l) => l.locked);
    }
    return FutureBuilder<bool>(
      future: _locked,
      builder: (context, snap) => widget.builder(locked: snap.data ?? false),
    );
  }
}
