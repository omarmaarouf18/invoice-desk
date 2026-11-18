import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/style_repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/issue_snapshot.dart';
import 'package:invoice_desk/domain/models.dart';

/// Freezes what a document prints when it becomes sent, paid or signed:
/// its look (`style_snapshot`, ADR-0012) and its parties and formats
/// (`issue_snapshot`, ADR-0014). Both repositories call this in their
/// single write path, right before the DAO writes the row.
///
/// Rules, for both document kinds:
/// - A snapshot already stored is kept, even when the caller's copy of the
///   document predates the save that took it (an editor buffer).
/// - Committing (draft → sent/paid, or → signed/active/completed) takes the
///   missing style snapshot, and the issue snapshot from the settings and
///   the client as they are now.
/// - A row that was **already** committed before v8 never gets an issue
///   snapshot: it keeps rendering from live data, as it always has.
class DocumentSnapshots {
  /// Reads documents, settings and clients from [_db]; [_styles] resolves
  /// the look to freeze.
  DocumentSnapshots(this._db, this._styles);
  final AppDatabase _db;
  final StyleRepository _styles;

  static const Set<InvoiceStatus> _invoiceCommitted = {
    InvoiceStatus.sent,
    InvoiceStatus.paid,
  };
  static const Set<ContractStatus> _contractCommitted = {
    ContractStatus.signed,
    ContractStatus.active,
    ContractStatus.completed,
  };

  /// [inv] with the snapshots it must be saved with.
  Future<Invoice> forInvoice(Invoice inv) async {
    final stored = await _db.invoicesDao.getById(inv.id);
    var out = inv.copyWith(
      styleSnapshot: () => _keep(inv.styleSnapshot, stored?.styleSnapshot),
      issueSnapshot: () => _keep(inv.issueSnapshot, stored?.issueSnapshot),
    );
    if (!_invoiceCommitted.contains(out.status)) return out;
    if (_blank(out.styleSnapshot)) {
      final style = await _styles.resolveForInvoice(out);
      out = out.copyWith(styleSnapshot: style.toRawJson);
    }
    final wasCommitted =
        stored != null && _invoiceCommitted.contains(stored.status);
    if (_blank(out.issueSnapshot) && !wasCommitted) {
      out = out.copyWith(issueSnapshot: await _capture(out.clientId));
    }
    return out;
  }

  /// [c] with the snapshots it must be saved with.
  Future<Contract> forContract(Contract c) async {
    final stored = await _db.contractsDao.getById(c.id);
    var out = c.copyWith(
      styleSnapshot: () => _keep(c.styleSnapshot, stored?.styleSnapshot),
      issueSnapshot: () => _keep(c.issueSnapshot, stored?.issueSnapshot),
    );
    if (!_contractCommitted.contains(out.status)) return out;
    if (_blank(out.styleSnapshot)) {
      final style = await _styles.resolveForContract(out);
      out = out.copyWith(styleSnapshot: style.toRawJson);
    }
    final wasCommitted =
        stored != null && _contractCommitted.contains(stored.status);
    if (_blank(out.issueSnapshot) && !wasCommitted) {
      out = out.copyWith(issueSnapshot: await _capture(out.clientId));
    }
    return out;
  }

  Future<String Function()> _capture(String clientId) async {
    final settings = await _db.settingsDao.get();
    final client = (await _db.clientsDao.getAll())
        .where((c) => c.id == clientId)
        .firstOrNull;
    final raw = IssueSnapshot.capture(settings, client).toRawJson();
    return () => raw;
  }

  static bool _blank(String? s) => s == null || s.trim().isEmpty;

  static String? _keep(String? mine, String? stored) =>
      _blank(mine) ? (_blank(stored) ? null : stored) : mine;
}
