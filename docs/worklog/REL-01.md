# REL-01 — Release pipeline (CI/CD to GitHub Releases)

**Brief:** docs/briefs/2026-11-18-release-pipeline.md · **Branch:** feat/release-pipeline (off `f21a67d`, SET-01 committed) · **Also:** WF-03 (housekeeping). PERF-01 is deferred (brief §7).

## Plan

1. **WF-03** (first, small): `AI_CONTEXT.md` release line; fictional names in `test/ui/contract_flow_test.dart`; `.gitignore` + `.gitleaks.toml` rules for signing material; commit the brief.
2. **macOS recreated** (own commit): fresh `flutter create --platforms=macos` from a scratch project, bundle id `me.omarmaarouf.invoice-desk`, product name "Invoice Desk", icon from `assets/icon/invoice-desk.png`, no flavors, `.metadata` without `ios`.
3. **Linux packages:** `scripts/package_linux.sh` builds once and writes the stable names (brief §4). New: `packaging/deb/` (dpkg-deb, `/opt/invoice-desk`, lintian overrides), `packaging/arch/PKGBUILD` (`invoice-desk-bin`, built in `archlinux:latest`), rpmlint filter file, a glibc ceiling check (`MAX_GLIBC=2.35` in CI), `scripts/smoke_linux.sh` for the container installs.
4. **Windows packages:** `packaging/windows/` (Inno Setup script, MSIX manifest + logos), `scripts/package_windows.ps1` (VC++ runtime copied next to the exe, DLL check, zip, Inno, MSIX via `makeappx`), `scripts/smoke_windows.ps1`.
5. **macOS package:** `scripts/package_macos.sh` (build, optional sign + notarize in a temporary keychain, dmg, verify), `scripts/smoke_macos.sh`.
6. **Workflows:** a reusable `package.yml` (the whole matrix + smoke tests) called by `ci.yml` on `main` and by `release.yml`; `release.yml` = verify → package → publish (checksums, `latest.json`, attestations, optional GPG, published release, optional portfolio hook + winget). `tool/release.dart` holds the testable logic (tag/pubspec/CHANGELOG checks, notes, `latest.json`). `actionlint` clean.
7. **Docs:** `docs/RELEASING.md` rewritten (pipeline, `latest.json` schema, owner sequence with exact commands, one-time setup), README install per platform + verification, CHANGELOG, ARCHITECTURE/AGENTS map if they mention packaging.
8. Gate, commits per task ID, report, stop.

## Decisions taken inside the brief

- **One reusable workflow** for packaging, so `main` CI and the release build the exact same way (brief §1 "a release is never the first time a package is built").
- **No App Sandbox on macOS.** The app keeps a backup folder and an export folder chosen in an earlier session and writes to them later; under the sandbox that needs security-scoped bookmarks, which `file_selector` does not create, so those settings would silently stop working after a restart. Sandboxing is only required for the Mac App Store, which is not a target. Hardened runtime stays on (required for notarization). Data stays in `~/Library/Application Support/me.omarmaarouf.invoice-desk`.
- **MSIX without new dependencies:** hand-written `AppxManifest.xml` + `makeappx.exe` from the Windows SDK on the runner (no `msix` pub package). Placeholder identity values when the repo variables are missing, so the artifact always builds.
- **Release tooling in Dart** (`tool/release.dart`, `dart:io` only) with unit tests, like the other `tool/` scripts.

## Findings

- 2026-11-18 — The local Fedora build already stays at GLIBC_2.34 (`invoice_desk`, `libsqlite3.so`, `libdartjni.so`); the rest is older. Building on ubuntu-22.04 keeps everything ≤ 2.35.
- 2026-11-18 — The current `macos/` has `PRODUCT_NAME = my_app`, `com.example.myApp`, `$(FLAVOR_APP_NAME)` in Info.plist and dev/stg configurations; it cannot have produced a usable app.

## Open questions

(none yet)

## Leftovers

- `package_linux.sh` downloads `appimagetool` from the moving `continuous` tag without a checksum (unchanged here).
