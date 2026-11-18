// Release checks and metadata for .github/workflows/release.yml
// (docs/RELEASING.md). Pure dart:io, so CI runs it right after `pub get`.
//
//   dart tool/release.dart verify --tag v0.5.0
//       the tag equals v + pubspec version name, and CHANGELOG.md has
//       a `## [0.5.0]` section. Prints the version.
//   dart tool/release.dart notes --version 0.5.0
//       prints that CHANGELOG section (the release notes).
//   dart tool/release.dart manifest --dir dist --version 0.5.0 \
//       --repo omarmaarouf18/invoice-desk --date 2026-11-20
//       checks dist/ holds exactly the release assets listed in SHA256SUMS.txt
//       and writes dist/latest.json (schema 1).
import 'dart:convert';
import 'dart:io';

/// The current `latest.json` schema. Bump it only for a breaking change and
/// document the new shape in docs/RELEASING.md.
const manifestSchema = 1;

/// One release asset: its stable file name (release decision R3) and how a
/// download page should label it.
typedef ReleaseAsset = ({String name, String platform, String format});

/// Every file attached to a release, in display order. The MSIX is a workflow
/// artifact only and never listed here (brief §4).
const List<ReleaseAsset> releaseAssets = [
  (name: 'InvoiceDesk-Setup-x64.exe', platform: 'windows', format: 'exe'),
  (name: 'InvoiceDesk-Windows-x64.zip', platform: 'windows', format: 'zip'),
  (name: 'InvoiceDesk-macOS.dmg', platform: 'macos', format: 'dmg'),
  (name: 'invoice-desk_amd64.deb', platform: 'linux', format: 'deb'),
  (name: 'invoice-desk.x86_64.rpm', platform: 'linux', format: 'rpm'),
  (
    name: 'invoice-desk-x86_64.pkg.tar.zst',
    platform: 'linux',
    format: 'pkg.tar.zst',
  ),
  (name: 'InvoiceDesk-x86_64.AppImage', platform: 'linux', format: 'AppImage'),
  (name: 'invoice-desk-linux-x64.tar.gz', platform: 'linux', format: 'tar.gz'),
];

/// Thrown for any check that must stop the release; the message is shown
/// as-is in the CI log.
class ReleaseError implements Exception {
  ReleaseError(this.message);
  final String message;
  @override
  String toString() => message;
}

final _semver = RegExp(r'^\d+\.\d+\.\d+$');

/// The version name (`X.Y.Z`, without `+build`) of a pubspec.yaml text.
String pubspecVersion(String pubspec) {
  final m = RegExp(
    r'^version:\s*(\S+)\s*$',
    multiLine: true,
  ).firstMatch(pubspec);
  if (m == null) throw ReleaseError('pubspec.yaml has no version line');
  final name = m.group(1)!.split('+').first;
  if (!_semver.hasMatch(name)) {
    throw ReleaseError('pubspec version "$name" is not X.Y.Z');
  }
  return name;
}

/// Checks [tag] against the pubspec and CHANGELOG texts and returns the
/// version. Fails fast with a message naming the file to fix.
String verify({
  required String tag,
  required String pubspec,
  required String changelog,
}) {
  if (!tag.startsWith('v') || !_semver.hasMatch(tag.substring(1))) {
    throw ReleaseError('tag "$tag" is not vX.Y.Z');
  }
  final version = pubspecVersion(pubspec);
  if (tag != 'v$version') {
    throw ReleaseError(
      'tag $tag does not match pubspec.yaml version $version (expected v$version)',
    );
  }
  changelogSection(changelog, version);
  return version;
}

/// The body of `## [version]` in a Keep-a-Changelog text: everything up to
/// the next `## ` heading or link-reference block, trimmed. Throws when the
/// section is missing or empty.
String changelogSection(String changelog, String version) {
  final lines = const LineSplitter().convert(changelog);
  final head = RegExp('^## \\[${RegExp.escape(version)}\\]');
  final start = lines.indexWhere(head.hasMatch);
  if (start < 0) {
    throw ReleaseError('CHANGELOG.md has no "## [$version]" section');
  }
  final body = <String>[];
  for (final line in lines.skip(start + 1)) {
    if (line.startsWith('## ') || RegExp(r'^\[[^\]]+\]:\s').hasMatch(line)) {
      break;
    }
    body.add(line);
  }
  final text = body.join('\n').trim();
  if (text.isEmpty) {
    throw ReleaseError('CHANGELOG.md section [$version] is empty');
  }
  return text;
}

/// Parses `sha256sum` output into file name → hex digest.
Map<String, String> parseChecksums(String sums) {
  final out = <String, String>{};
  for (final line in const LineSplitter().convert(sums)) {
    if (line.trim().isEmpty) continue;
    final m = RegExp(r'^([0-9a-f]{64}) [ *](.+)$').firstMatch(line.trim());
    if (m == null) throw ReleaseError('bad SHA256SUMS.txt line: $line');
    out[m.group(2)!] = m.group(1)!;
  }
  return out;
}

/// Builds the `latest.json` map (schema [manifestSchema]).
///
/// [checksums] and [sizes] (bytes) must cover exactly [releaseAssets]: a
/// missing or an unexpected file fails, so a release never ships without a
/// platform or with a stray file.
Map<String, Object> buildManifest({
  required String version,
  required String date,
  required String notes,
  required String repo,
  required Map<String, String> checksums,
  required Map<String, int> sizes,
}) {
  final expected = {for (final a in releaseAssets) a.name};
  final missing = expected.difference(checksums.keys.toSet());
  final extra = checksums.keys.toSet().difference(expected);
  if (missing.isNotEmpty) {
    throw ReleaseError('missing release assets: ${missing.join(', ')}');
  }
  if (extra.isNotEmpty) {
    throw ReleaseError(
      'unexpected files in SHA256SUMS.txt: ${extra.join(', ')}',
    );
  }
  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date)) {
    throw ReleaseError('date "$date" is not YYYY-MM-DD');
  }
  return {
    'schema': manifestSchema,
    'version': version,
    'date': date,
    'notes': notes,
    'assets': [
      for (final a in releaseAssets)
        {
          'platform': a.platform,
          'format': a.format,
          'name': a.name,
          'url':
              'https://github.com/$repo/releases/download/v$version/${a.name}',
          'size':
              sizes[a.name] ?? (throw ReleaseError('no size for ${a.name}')),
          'sha256': checksums[a.name]!,
        },
    ],
  };
}

Map<String, String> _options(List<String> args) {
  final out = <String, String>{};
  for (var i = 0; i < args.length; i++) {
    if (!args[i].startsWith('--') || i + 1 >= args.length) {
      throw ReleaseError('bad argument ${args[i]}');
    }
    out[args[i].substring(2)] = args[++i];
  }
  return out;
}

String _need(Map<String, String> o, String key) =>
    o[key] ?? (throw ReleaseError('--$key is required'));

void main(List<String> args) {
  try {
    if (args.isEmpty) {
      throw ReleaseError('usage: release.dart verify|notes|manifest [options]');
    }
    final o = _options(args.sublist(1));
    switch (args.first) {
      case 'verify':
        stdout.writeln(
          verify(
            tag: _need(o, 'tag'),
            pubspec: File('pubspec.yaml').readAsStringSync(),
            changelog: File('CHANGELOG.md').readAsStringSync(),
          ),
        );
      case 'notes':
        stdout.writeln(
          changelogSection(
            File('CHANGELOG.md').readAsStringSync(),
            _need(o, 'version'),
          ),
        );
      case 'manifest':
        final dir = Directory(_need(o, 'dir'));
        final version = _need(o, 'version');
        final checksums = parseChecksums(
          File('${dir.path}/SHA256SUMS.txt').readAsStringSync(),
        );
        final manifest = buildManifest(
          version: version,
          date: _need(o, 'date'),
          notes: changelogSection(
            File('CHANGELOG.md').readAsStringSync(),
            version,
          ),
          repo: _need(o, 'repo'),
          checksums: checksums,
          sizes: {
            for (final n in checksums.keys)
              n: File('${dir.path}/$n').lengthSync(),
          },
        );
        File('${dir.path}/latest.json').writeAsStringSync(
          '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
        );
        stdout.writeln('wrote ${dir.path}/latest.json');
      default:
        throw ReleaseError('unknown command ${args.first}');
    }
  } on ReleaseError catch (e) {
    stderr.writeln('::error::$e');
    exitCode = 1;
  }
}
