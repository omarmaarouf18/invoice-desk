import 'dart:convert';
import 'dart:typed_data';

import 'package:invoice_desk/domain/document_style.dart';
import 'package:meta/meta.dart';

/// The `format` tag of an exported style file.
const styleFileFormat = 'invoice-desk-style';

/// The newest style file version this build reads and writes.
const styleFileVersion = 1;

/// A document style as it travels between machines in a `.json` file.
///
/// The logo travels inside the file (base64), so the style looks the same
/// after import; the importer re-validates it like any upload (PNG/JPEG,
/// ≤ 1 MB). Logo asset ids are machine-local and are never written.
@immutable
class StyleFile {
  /// A style file.
  const StyleFile({
    required this.name,
    required this.style,
    this.basePreset = 'classic',
    this.logo,
    this.logoMime,
  });

  /// Parses [raw]; throws [FormatException] when it is not JSON, not a
  /// style file, or from a newer version. Out-of-range or unknown style
  /// values are clamped or dropped by [DocumentStyle.fromJson], never
  /// rejected.
  factory StyleFile.decode(String raw) {
    final Object? json;
    try {
      json = jsonDecode(raw);
    } on FormatException {
      throw const FormatException('not JSON');
    }
    if (json is! Map<String, dynamic>) {
      throw const FormatException('not a style file');
    }
    if (json['format'] != styleFileFormat) {
      throw const FormatException('not a style file');
    }
    final version = json['version'];
    if (version is! int || version < 1 || version > styleFileVersion) {
      throw const FormatException('unsupported version');
    }
    final style = json['style'];
    if (style is! Map<String, dynamic>) {
      throw const FormatException('no style');
    }
    final name = json['name'] is String ? (json['name'] as String).trim() : '';
    final base = json['basePreset'];
    Uint8List? logo;
    String? mime;
    if (json['logo'] case {'base64': final String b64, 'mime': final m}) {
      try {
        logo = base64Decode(b64);
        mime = m is String ? m : null;
      } on FormatException {
        logo = null; // A broken logo is dropped, the style still imports.
      }
    }
    return StyleFile(
      name: name.length > 80 ? name.substring(0, 80) : name,
      basePreset: base is String && base.isNotEmpty ? base : 'classic',
      style: DocumentStyle.fromJson(style).copyWith(clearLogoAssetId: true),
      logo: logo,
      logoMime: mime,
    );
  }

  /// The display name; may be empty in a hand-written file.
  final String name;

  /// The preset "Reset to preset" goes back to.
  final String basePreset;

  /// The style, without a logo asset id.
  final DocumentStyle style;

  /// The logo image bytes, if the style has one.
  final Uint8List? logo;

  /// The logo's MIME type (`image/png` or `image/jpeg`), if known.
  final String? logoMime;

  /// The file's JSON text, indented for people who open it.
  String encode() => const JsonEncoder.withIndent('  ').convert({
    'format': styleFileFormat,
    'version': styleFileVersion,
    'name': name,
    'basePreset': basePreset,
    'style': style.copyWith(clearLogoAssetId: true).toJson(),
    if (logo != null) 'logo': {'mime': logoMime, 'base64': base64Encode(logo!)},
  });
}
