// ignore_for_file: recursive_getters, drift check constraints reference their own column
import 'package:drift/drift.dart';
import 'package:invoice_desk/data/tables.dart';

/// Stored binary assets for documents (logo images).
///
/// Deduplicated by content hash: [id] is the hex SHA-256 digest of [bytes].
/// PNG or JPEG only, up to 1 MB, validated on import.
@DataClassName('DocumentAssetRow')
class DocumentAssets extends Table with SyncRev {
  /// Hex SHA-256 hash of the asset bytes.
  TextColumn get id => text()();

  /// Media type: `image/png` or `image/jpeg`.
  TextColumn get mime =>
      text().check(mime.isIn(const ['image/png', 'image/jpeg']))();

  /// Binary image payload (PNG/JPEG ≤ 1 MB).
  BlobColumn get bytes => blob()();

  /// Creation epoch in UTC milliseconds.
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}

/// User-customized document styles (schema v7).
///
/// Built-in presets (Classic, Modern, Minimal, Bold, Blank) live as consts in
/// code. User-created or duplicated styles are persisted here.
@DataClassName('DocumentStyleRow')
class DocumentStyles extends Table with SyncRev {
  /// UUID of this custom style.
  TextColumn get id => text()();

  /// User-facing display name.
  TextColumn get name =>
      text().check(name.trim().length.isBiggerThanValue(0))();

  /// Applicable document types: `invoice`, `contract`, or `any`.
  TextColumn get kind => text()
      .withDefault(const Constant('any'))
      .check(kind.isIn(const ['invoice', 'contract', 'any']))();

  /// Starting preset identifier (`classic`, `modern`, `minimal`, `bold`, `blank`).
  TextColumn get basePreset => text().withDefault(const Constant('classic'))();

  /// JSON serialization of the resolved DocumentStyle.
  TextColumn get json => text().withDefault(const Constant(''))();

  /// Schema version of the style JSON for forward compatibility.
  IntColumn get schemaVersion => integer().withDefault(const Constant(1))();

  /// Whether the style is archived / hidden from pickers.
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  /// Demo data flag.
  BoolColumn get isDemo => boolean().withDefault(const Constant(false))();

  /// Creation epoch in UTC milliseconds.
  IntColumn get createdAt => integer()();

  /// Last modification epoch in UTC milliseconds.
  IntColumn get updatedAt => integer()();

  /// Soft deletion timestamp; null for active styles.
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  bool get isStrict => true;
}
