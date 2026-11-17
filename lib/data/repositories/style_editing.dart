part of 'style_repository.dart';

/// What the style editor does to user styles: duplicate, rename, reset,
/// export and import, and the 30-day trash purge. Every write goes through
/// [StyleRepository.saveUserStyle], so each one syncs like any other row.
extension StyleEditing on StyleRepository {
  /// Copies [source] (a preset or a user style) into a new user style
  /// named [name] (made unique among live styles) and returns it.
  ///
  /// A preset's copy remembers the preset as its base, so "Reset to
  /// preset" goes back to it; a user style's copy keeps its base and logo.
  Future<CustomStyle> duplicateStyle({
    required String id,
    required String name,
    String? presetId,
    CustomStyle? source,
  }) async {
    final preset = presetId == null ? null : DocPreset.fromId(presetId);
    final copy = CustomStyle(
      id: id,
      name: await uniqueStyleName(name),
      basePreset: preset?.name ?? source?.basePreset ?? 'classic',
      style: preset?.style ?? source?.style ?? DocPreset.classic.style,
    );
    await saveUserStyle(copy);
    return copy;
  }

  /// Renames [id] to the trimmed [name]; an empty name is ignored.
  Future<void> renameStyle(String id, String name) async {
    final s = await getUserStyleById(id);
    if (s == null || name.trim().isEmpty) return;
    await saveUserStyle(s.copyWith(name: name.trim()));
  }

  /// Puts [id] back to its base preset's look, keeping its name and logo
  /// (the logo is the user's, not the preset's).
  Future<void> resetStyle(String id) async {
    final s = await getUserStyleById(id);
    if (s == null) return;
    final base = DocPreset.fromId(s.basePreset).style;
    await saveUserStyle(
      s.copyWith(
        style: s.style.logoAssetId == null
            ? base
            : base.copyWith(logoAssetId: s.style.logoAssetId),
      ),
    );
  }

  /// The `.json` text of user style [id], logo embedded; null if [id] is
  /// not a live user style.
  Future<String?> exportStyleFile(String id) async {
    final s = await getUserStyleById(id);
    if (s == null) return null;
    final logoId = s.style.logoAssetId;
    final asset = logoId == null
        ? null
        : await (_db.select(
            _db.documentAssets,
          )..where((a) => a.id.equals(logoId))).getSingleOrNull();
    return StyleFile(
      name: s.name,
      basePreset: s.basePreset,
      style: s.style,
      logo: asset?.bytes,
      logoMime: asset?.mime,
    ).encode();
  }

  /// Imports a style file as new user style [id] and returns it.
  ///
  /// Throws [FormatException] when [raw] is not a style file, and
  /// [InvalidAssetException] when its logo is not a PNG/JPEG ≤ 1 MB (the
  /// same rule as an upload). An unnamed file is called [fallbackName];
  /// a taken name gets a " (2)" suffix.
  Future<CustomStyle> importStyleFile(
    String raw, {
    required String id,
    required String fallbackName,
  }) async {
    final file = StyleFile.decode(raw);
    final logo = file.logo;
    final logoId = logo == null ? null : await saveAsset(bytes: logo);
    final style = CustomStyle(
      id: id,
      name: await uniqueStyleName(
        file.name.isEmpty ? fallbackName : file.name,
      ),
      basePreset: DocPreset.fromId(file.basePreset).name,
      style: logoId == null
          ? file.style
          : file.style.copyWith(logoAssetId: logoId),
    );
    await saveUserStyle(style);
    return style;
  }

  /// [name], or `name (2)`, `name (3)`… when a live user style has it.
  Future<String> uniqueStyleName(String name) async {
    final base = name.trim();
    final taken = {for (final s in await getUserStyles()) s.name};
    if (!taken.contains(base)) return base;
    for (var n = 2; ; n++) {
      final candidate = '$base ($n)';
      if (!taken.contains(candidate)) return candidate;
    }
  }

  /// Hard-deletes styles that have been in the trash longer than [age]
  /// (start-up housekeeping, like the other tables). Returns the count.
  Future<int> purgeDeletedStyles({Duration age = trashRetention}) =>
      at(() async {
        final cutoff = _nowMs - age.inMilliseconds;
        return (_db.delete(_db.documentStyles)..where(
              (s) =>
                  s.deletedAt.isNotNull() &
                  s.deletedAt.isSmallerThanValue(cutoff),
            ))
            .go();
      });
}
