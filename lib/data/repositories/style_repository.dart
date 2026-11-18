import 'package:clock/clock.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/db.dart';
import 'package:invoice_desk/data/repositories/repository.dart';
import 'package:invoice_desk/domain/contract_models.dart';
import 'package:invoice_desk/domain/custom_style.dart';
import 'package:invoice_desk/domain/document_style.dart';
import 'package:invoice_desk/domain/document_style_presets.dart';
import 'package:invoice_desk/domain/models.dart';
import 'package:invoice_desk/domain/style_file.dart';
import 'package:invoice_desk/domain/trash.dart';
import 'package:meta/meta.dart';

part 'style_editing.dart';

/// What a document prints with: the resolved style and its logo.
@immutable
class ResolvedLook {
  /// A look; [logo] is null when the style has no logo or its asset is
  /// missing (the PDF then simply has no logo).
  const ResolvedLook({
    required this.style,
    this.logo,
    this.locked = false,
    this.issueSnapshot,
  });

  /// The style to render.
  final DocumentStyle style;

  /// The logo image bytes (PNG or JPEG), if any.
  final Uint8List? logo;

  /// The look is frozen: the document was sent, paid or signed, so the
  /// editor shows the style as fixed and the picker is disabled.
  final bool locked;

  /// The document's issue snapshot JSON (ADR-0014): the caller's copy,
  /// else the stored row's; null renders from live settings and client.
  final String? issueSnapshot;
}

/// How many unfrozen documents and clients point at a style.
@immutable
class StyleUsage {
  /// A count; both are ≥ 0.
  const StyleUsage({this.drafts = 0, this.clients = 0});

  /// Invoices and contracts whose look still follows the style.
  final int drafts;

  /// Clients whose preferred style it is.
  final int clients;

  /// Anything at all would change look if the style went away.
  bool get isUsed => drafts > 0 || clients > 0;
}

/// Thrown when an uploaded logo asset is invalid (wrong format, corrupted, or too large).
class InvalidAssetException implements Exception {
  /// Creates an exception with an explanatory [message].
  const InvalidAssetException(this.message);

  /// Error message explaining why the asset was rejected.
  final String message;

  @override
  String toString() => 'InvalidAssetException: $message';
}

/// Repository managing document styles, presets, assets (logos), and resolution hierarchy.
class StyleRepository with ClockedRepository {
  /// Wraps [_db]; writes are stamped with [clock].
  StyleRepository(this._db, {this.clock = const Clock()});

  final AppDatabase _db;

  @override
  final Clock clock;

  int get _nowMs => clock.now().toUtc().millisecondsSinceEpoch;

  // ---------------------------------------------------------------------------
  // Style Resolution
  // ---------------------------------------------------------------------------

  /// Resolves the effective document style following the hierarchy (ADR-0012):
  /// 1. Snapshot (`snapshotJson`), if present and valid.
  /// 2. Document style ID (`styleId`), if set.
  /// 3. Client preferred style (`clientId`), if set.
  /// 4. Settings default style (`defaultInvoiceStyleId` / `defaultContractStyleId`).
  /// 5. Built-in Classic preset ([DocPreset.classic]).
  Future<DocumentStyle> resolveStyle({
    String? styleId,
    String? clientId,
    String? snapshotJson,
    bool isContract = false,
  }) async {
    // 1. Snapshot
    if (snapshotJson != null && snapshotJson.trim().isNotEmpty) {
      try {
        return DocumentStyle.fromRawJson(snapshotJson);
      } on Object {
        // Fall through to live resolution if snapshot is corrupted.
      }
    }

    // 2. Document style ID
    if (styleId != null && styleId.trim().isNotEmpty) {
      final style = await _resolveStyleId(styleId.trim());
      if (style != null) return style;
    }

    // 3. Client style ID
    if (clientId != null && clientId.trim().isNotEmpty) {
      final client =
          await (_db.select(_db.clients)
                ..where((c) => c.id.equals(clientId) & c.deletedAt.isNull()))
              .getSingleOrNull();
      if (client?.styleId != null && client!.styleId!.trim().isNotEmpty) {
        final style = await _resolveStyleId(client.styleId!.trim());
        if (style != null) return style;
      }
    }

    // 4. Global Settings default
    final settings = await _db.settingsDao.get();
    final defaultId = isContract
        ? settings.defaultContractStyleId
        : settings.defaultInvoiceStyleId;
    if (defaultId != null && defaultId.trim().isNotEmpty) {
      final style = await _resolveStyleId(defaultId.trim());
      if (style != null) return style;
    }

    // 5. Classic preset fallback
    return DocPreset.classic.style;
  }

  /// Resolves style for [inv]; see [lookForInvoice] for the lock rules.
  Future<DocumentStyle> resolveForInvoice(Invoice inv) async =>
      (await lookForInvoice(inv, withLogo: false)).style;

  /// Resolves style for [c]; see [lookForContract] for the lock rules.
  Future<DocumentStyle> resolveForContract(Contract c) async =>
      (await lookForContract(c, withLogo: false)).style;

  /// The look [inv] prints with: its style, its logo bytes, and whether the
  /// look is frozen.
  ///
  /// The snapshot is [inv]'s own, else the stored row's (the editor's copy
  /// may predate the save that took it). A stored invoice that is sent,
  /// paid or void with **no** snapshot predates styles (v1–v6, an old
  /// backup, demo rows): it stays Classic and locked, so a later default
  /// never restyles a document that was already sent (ADR-0012).
  /// [withLogo] false skips the asset read (snapshots only need the id).
  Future<ResolvedLook> lookForInvoice(
    Invoice inv, {
    bool withLogo = true,
  }) async {
    final row = await (_db.select(
      _db.invoices,
    )..where((i) => i.id.equals(inv.id))).getSingleOrNull();
    return _look(
      snapshot: _nonEmpty(inv.styleSnapshot) ?? _nonEmpty(row?.styleSnapshot),
      legacyCommitted:
          row != null && const {'sent', 'paid', 'void'}.contains(row.status),
      live: () => resolveStyle(styleId: inv.styleId, clientId: inv.clientId),
      withLogo: withLogo,
      issue: _nonEmpty(inv.issueSnapshot) ?? _nonEmpty(row?.issueSnapshot),
    );
  }

  /// The look [c] prints with; the same rules as [lookForInvoice], where
  /// signed, active, completed and cancelled count as committed.
  Future<ResolvedLook> lookForContract(
    Contract c, {
    bool withLogo = true,
  }) async {
    final row = await (_db.select(
      _db.contracts,
    )..where((x) => x.id.equals(c.id))).getSingleOrNull();
    return _look(
      snapshot: _nonEmpty(c.styleSnapshot) ?? _nonEmpty(row?.styleSnapshot),
      legacyCommitted:
          row != null &&
          const {
            'signed',
            'active',
            'completed',
            'cancelled',
          }.contains(row.status),
      live: () => resolveStyle(
        styleId: c.styleId,
        clientId: c.clientId,
        isContract: true,
      ),
      withLogo: withLogo,
      issue: _nonEmpty(c.issueSnapshot) ?? _nonEmpty(row?.issueSnapshot),
    );
  }

  /// The look of a style that is not attached to a document (the style
  /// editor's preview): [style] with its logo bytes, never locked.
  Future<ResolvedLook> lookForStyle(DocumentStyle style) async => ResolvedLook(
    style: style,
    logo: style.logoAssetId == null ? null : await getAsset(style.logoAssetId!),
  );

  Future<ResolvedLook> _look({
    required String? snapshot,
    required bool legacyCommitted,
    required Future<DocumentStyle> Function() live,
    required bool withLogo,
    String? issue,
  }) async {
    DocumentStyle? frozen;
    if (snapshot != null) {
      try {
        frozen = DocumentStyle.fromRawJson(snapshot);
      } on Object {
        frozen = null; // Corrupt snapshot: fall through like resolveStyle.
      }
    }
    final locked = frozen != null || legacyCommitted;
    final style =
        frozen ?? (legacyCommitted ? DocPreset.classic.style : await live());
    final logoId = style.logoAssetId;
    return ResolvedLook(
      style: style,
      logo: withLogo && logoId != null ? await getAsset(logoId) : null,
      locked: locked,
      issueSnapshot: issue,
    );
  }

  static String? _nonEmpty(String? s) =>
      s == null || s.trim().isEmpty ? null : s;

  Future<DocumentStyle?> _resolveStyleId(String id) async {
    // Built-in preset?
    if (_isPresetId(id)) {
      return DocPreset.fromId(id).style;
    }

    // Custom user style from database?
    final row = await (_db.select(
      _db.documentStyles,
    )..where((s) => s.id.equals(id) & s.deletedAt.isNull())).getSingleOrNull();
    if (row != null && row.json.isNotEmpty) {
      try {
        return DocumentStyle.fromRawJson(row.json);
      } on Object {
        // Corrupted JSON; fall through to next fallback.
      }
    }
    return null;
  }

  bool _isPresetId(String id) =>
      DocPreset.values.any((p) => p.id == id || p.name == id);

  // ---------------------------------------------------------------------------
  // Asset Storage (Logos)
  // ---------------------------------------------------------------------------

  /// Validates and saves an image asset (PNG or JPEG, ≤ 1 MB).
  ///
  /// Computes the SHA-256 hash of [bytes] as the primary key ID.
  /// Throws [InvalidAssetException] if the bytes exceed 1 MB or are not PNG/JPEG.
  Future<String> saveAsset({required Uint8List bytes, String? mime}) =>
      at(() async {
        if (bytes.length > 1024 * 1024) {
          throw InvalidAssetException(
            'Asset exceeds 1 MB limit (${bytes.length} bytes)',
          );
        }

        final isPng =
            bytes.length >= 8 &&
            bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4E &&
            bytes[3] == 0x47 &&
            bytes[4] == 0x0D &&
            bytes[5] == 0x0A &&
            bytes[6] == 0x1A &&
            bytes[7] == 0x0A;

        final isJpeg =
            bytes.length >= 3 &&
            bytes[0] == 0xFF &&
            bytes[1] == 0xD8 &&
            bytes[2] == 0xFF;

        if (!isPng && !isJpeg) {
          throw const InvalidAssetException(
            'Only PNG and JPEG formats are supported',
          );
        }

        final actualMime = isPng ? 'image/png' : 'image/jpeg';
        final hash = sha256.convert(bytes).toString();

        await _db
            .into(_db.documentAssets)
            .insert(
              DocumentAssetsCompanion.insert(
                id: hash,
                mime: actualMime,
                bytes: bytes,
                createdAt: _nowMs,
              ),
              mode: InsertMode.insertOrIgnore,
            );

        return hash;
      });

  /// Fetches the raw image bytes for [id], or null if not found.
  Future<Uint8List?> getAsset(String id) async {
    final row = await (_db.select(
      _db.documentAssets,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    return row?.bytes;
  }

  /// Whether [assetId] is currently referenced by any custom style (live or
  /// trashed), invoice snapshot, or contract snapshot.
  Future<bool> isAssetInUse(String assetId) async {
    // 1. Check custom styles (live or trashed, so restoring preserves logo)
    final inStyle =
        await (_db.select(_db.documentStyles)
              ..where((s) => s.json.like('%$assetId%'))
              ..limit(1))
            .getSingleOrNull();
    if (inStyle != null) return true;

    // 2. Check invoices (live or trashed, so restore preserves logo)
    final inInvoice =
        await (_db.select(_db.invoices)
              ..where(
                (i) =>
                    i.styleSnapshot.isNotNull() &
                    i.styleSnapshot.like('%$assetId%'),
              )
              ..limit(1))
            .getSingleOrNull();
    if (inInvoice != null) return true;

    // 3. Check contracts (live or trashed)
    final inContract =
        await (_db.select(_db.contracts)
              ..where(
                (c) =>
                    c.styleSnapshot.isNotNull() &
                    c.styleSnapshot.like('%$assetId%'),
              )
              ..limit(1))
            .getSingleOrNull();
    if (inContract != null) return true;

    return false;
  }

  /// Permanently removes unreferenced assets created more than 24 hours ago.
  Future<int> purgeUnusedAssets() => at(() async {
    final cutoffMs = _nowMs - const Duration(hours: 24).inMilliseconds;
    final assets = await (_db.select(
      _db.documentAssets,
    )..where((a) => a.createdAt.isSmallerOrEqualValue(cutoffMs))).get();
    var purged = 0;
    for (final a in assets) {
      if (!await isAssetInUse(a.id)) {
        await (_db.delete(
          _db.documentAssets,
        )..where((x) => x.id.equals(a.id))).go();
        purged++;
      }
    }
    return purged;
  });

  // ---------------------------------------------------------------------------
  // Custom Styles CRUD
  // ---------------------------------------------------------------------------

  /// Watches all active (non-deleted) custom styles.
  Stream<List<CustomStyle>> watchUserStyles() =>
      (_db.select(_db.documentStyles)
            ..where((s) => s.deletedAt.isNull())
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .watch()
          .map((rows) => rows.map(_toModel).toList());

  /// Returns all active (non-deleted) custom styles.
  Future<List<CustomStyle>> getUserStyles() async {
    final rows =
        await (_db.select(_db.documentStyles)
              ..where((s) => s.deletedAt.isNull())
              ..orderBy([(s) => OrderingTerm.asc(s.name)]))
            .get();
    return rows.map(_toModel).toList();
  }

  /// Fetches a custom style by [id].
  Future<CustomStyle?> getUserStyleById(String id) async {
    final row = await (_db.select(
      _db.documentStyles,
    )..where((s) => s.id.equals(id) & s.deletedAt.isNull())).getSingleOrNull();
    return row != null ? _toModel(row) : null;
  }

  /// Saves or updates a custom style.
  Future<void> saveUserStyle(CustomStyle style) => at(() async {
    final existing = await (_db.select(
      _db.documentStyles,
    )..where((s) => s.id.equals(style.id))).getSingleOrNull();
    final now = _nowMs;

    await _db
        .into(_db.documentStyles)
        .insertOnConflictUpdate(
          DocumentStylesCompanion.insert(
            id: style.id,
            name: style.name.trim(),
            kind: Value(style.kind),
            basePreset: Value(style.basePreset),
            json: Value(style.style.toRawJson()),
            schemaVersion: Value(style.schemaVersion),
            archived: Value(style.archived),
            isDemo: Value(style.isDemo),
            createdAt: existing?.createdAt ?? now,
            updatedAt: now,
            deletedAt: const Value(null),
          ),
        );
  });

  /// Soft-deletes a custom style.
  Future<void> softDeleteUserStyle(String id) => at(() async {
    await (_db.update(_db.documentStyles)..where((s) => s.id.equals(id))).write(
      DocumentStylesCompanion(
        deletedAt: Value(_nowMs),
        updatedAt: Value(_nowMs),
      ),
    );
  });

  /// Restores a soft-deleted custom style.
  Future<void> undoDeleteUserStyle(String id) => at(() async {
    await (_db.update(_db.documentStyles)..where((s) => s.id.equals(id))).write(
      DocumentStylesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_nowMs),
      ),
    );
  });

  CustomStyle _toModel(DocumentStyleRow r) => CustomStyle(
    id: r.id,
    name: r.name,
    kind: r.kind,
    basePreset: r.basePreset,
    style: DocumentStyle.fromRawJson(r.json),
    schemaVersion: r.schemaVersion,
    archived: r.archived,
    isDemo: r.isDemo,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );
}
