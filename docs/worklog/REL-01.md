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
- 2026-11-18 — A Fedora 45 build links GLib 2.80 symbols (`g_once_init_enter_pointer`) and aborts on Ubuntu 22.04 / Debian 12; only the ubuntu-22.04 build is shippable. Verified by building in an `ubuntu:22.04` container (glibc need: 2.34).
- 2026-11-18 — On a minimal Ubuntu 22.04 the app aborted with "Couldn't open libGLESv2.so.2": the engine dlopen()s EGL/GLES, invisible to dpkg-shlibdeps/rpm/namcap. Now declared in all three packages; the smoke script no longer installs EGL itself, so it tests the packages' own dependencies.
- 2026-11-18 — With those fixes, `scripts/smoke_linux.sh` passes in ubuntu:22.04, debian:12, fedora:latest and archlinux:latest; lintian (22.04 and Debian 12), rpmlint (with the rpmlintrc) and namcap are clean.
- 2026-11-18 — Two podman containers with `:Z` on the same folder relabel it and break each other; use `:z`.
- 2026-11-18 — `dart run` prints "Running build hooks..." on stdout; the workflows call `dart tool/release.dart` so captured output stays clean.
- 2026-11-18 — The Windows exe icon was Flutter's default; replaced with the app icon.

## Open questions

1. GPG signs with a passphrase-less signing subkey, so no secret beyond `GPG_PRIVATE_KEY` is needed (brief §11). Want a `GPG_PASSPHRASE` secret instead? — recommended: no, a dedicated subkey without passphrase that lives only in GitHub secrets — open.
2. `feat/bilingual-styles` phases 7–8 are not done. Does 0.5.0 ship without them? — recommended: yes, ship 0.5.0 with phases 0–6 and keep 7–8 for 0.6.0 — open.
3. Signing runs only on releases (and release dry runs), not on `main` pushes, to save SignPath quota and notarization time — recommended: keep — open.

## Unverified (needs the first `main` run)

- Windows scripts (no `pwsh` locally), macOS scripts (no Mac), the AppImage smoke, the Arch build from the CI tarball, SignPath/Apple/GPG/winget/portfolio steps.

## Leftovers

- `package_linux.sh` downloads `appimagetool` from the moving `continuous` tag without a checksum (unchanged here).
