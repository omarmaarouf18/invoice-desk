import 'package:invoice_desk/domain/document_style.dart';
import 'package:meta/meta.dart';

@immutable
/// A user-created or customized document style stored in the database.
class CustomStyle {
  /// Creates a custom style instance.
  const CustomStyle({
    required this.id,
    required this.name,
    required this.style,
    this.kind = 'any',
    this.basePreset = 'classic',
    this.schemaVersion = 1,
    this.archived = false,
    this.isDemo = false,
    this.createdAt = 0,
    this.updatedAt = 0,
  });

  /// Stable UUID of this style.
  final String id;

  /// User-facing display name.
  final String name;

  /// Applicable document types: `'invoice'`, `'contract'`, or `'any'`.
  final String kind;

  /// Starting preset identifier (`'classic'`, `'modern'`, etc.).
  final String basePreset;

  /// Resolved style configuration.
  final DocumentStyle style;

  /// Schema version of the style JSON for forward compatibility.
  final int schemaVersion;

  /// Whether the style is archived / hidden from pickers.
  final bool archived;

  /// Demo data flag.
  final bool isDemo;

  /// Creation epoch in UTC milliseconds.
  final int createdAt;

  /// Last modification epoch in UTC milliseconds.
  final int updatedAt;

  /// Returns a copy with the given fields replaced.
  CustomStyle copyWith({
    String? id,
    String? name,
    String? kind,
    String? basePreset,
    DocumentStyle? style,
    int? schemaVersion,
    bool? archived,
    bool? isDemo,
    int? createdAt,
    int? updatedAt,
  }) => CustomStyle(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    basePreset: basePreset ?? this.basePreset,
    style: style ?? this.style,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    archived: archived ?? this.archived,
    isDemo: isDemo ?? this.isDemo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
