# Brief — Release pipeline (CI/CD to GitHub Releases)

**Branch:** `feat/release-pipeline` (off the finished `feat/bilingual-styles`) · **Task IDs:** `REL-01` (packaging + CI/CD), `PERF-01` (performance pass), `WF-03` (repo housekeeping) · **Status:** approved by the owner, start after SET-01 is committed

Read `AGENTS.md`, `docs/ai/WORKFLOW.md` and `docs/RELEASING.md` first. You never push, merge or tag; the owner does.

## 1. Goal

- **Release:** one tag (`vX.Y.Z`) pushed by the owner → every package for every target is built, smoke-tested and published to **GitHub Releases in this repo** automatically. Nothing is published if any build or smoke test fails.
- **Main:** every push to `main` builds every package as CI artifacts, so a release is never the first time a package is built.
- **Portfolio:** a portfolio site can link the latest version forever without code (stable asset names), or read `latest.json` for version, date, notes and sizes.
- **Targets:** Windows, macOS, Linux.

## 2. Facts (verified 2026-11-18)

| Item | State |
|---|---|
| Repo | `omarmaarouf18/invoice-desk`, **public** now, so GitHub-hosted runners are free |
| `main` | `e4f63fa`, stale (before `v0.1.0`). The branches form one linear chain: `main → release-packaging → feature/contracts → hardening/v0.3 → feature/calendar → feat/bilingual-styles` |
| PRs | #1, #2, #3 are open, stacked, and all target `release-packaging` |
| Tags / releases | Only `v0.1.0`; no GitHub releases |
| Existing packaging | `scripts/package_linux.sh`, `packaging/linux/` (install/uninstall, .desktop), `packaging/rpm/invoice-desk.spec`. `release.yml` builds tarball + AppImage + RPM on `ubuntu-24.04` into a **draft** release |
| CI | `ci.yml` builds Linux, Windows (`flutter build windows`, no installer, no artifact) and macOS on every push |
| `macos/` | Came from another project (dev/stg flavor icons; created with a different Flutter revision; `.metadata` also lists `ios`, which doesn't exist) |
| Old client data | The owner confirmed it is consented test data. **No history rewrite.** |

Flutter can't cross-compile desktop apps: Windows builds need Windows, macOS builds need macOS, and Linux builds only Linux.

## 3. Decisions

| # | Decision |
|---|---|
| R1 | Releases are published in this repo with `GITHUB_TOKEN` (`contents: write`, `id-token: write`, `attestations: write`). No mirror repo. |
| R2 | The owner pushes the tag. Everything after the tag is automatic and **published** (not a draft) only if all jobs pass. |
| R3 | Asset names are **stable, without the version**, so `https://github.com/omarmaarouf18/invoice-desk/releases/latest/download/<name>` always works. The version lives inside each package and in `latest.json`. |
| R4 | Linux builds on **ubuntu-22.04** (glibc 2.35) for compatibility with Debian 12 and Ubuntu 22.04. The README states the minimum glibc. |
| R5 | macOS is signed and notarized when the Apple secrets exist (the owner has a Developer account). Otherwise it ships unsigned. |
| R6 | **GitHub Releases is the only download source** (owner preference). The Windows `.exe` ships **unsigned** for now. An optional SignPath step runs only if its secrets exist. The MSIX is built only for an optional Microsoft Store listing later. A TLS/domain certificate cannot sign code. |
| R7 | Optional GPG signature of `SHA256SUMS.txt` when `GPG_PRIVATE_KEY` exists (owner's key, published on the owner's domain). |
| R8 | No iOS target. macOS is kept but recreated cleanly. |

## 4. Asset names

| Platform | File |
|---|---|
| Windows installer | `InvoiceDesk-Setup-x64.exe` |
| Windows portable | `InvoiceDesk-Windows-x64.zip` |
| Windows Store package | `InvoiceDesk-x64.msix`, as a **workflow artifact only**. It is NOT attached to the release or listed in `latest.json`: an unsigned MSIX can't be installed from a download, so it's only for Store submission |
| macOS | `InvoiceDesk-macOS.dmg` (universal if feasible, else arm64 — say which) |
| Debian/Ubuntu | `invoice-desk_amd64.deb` |
| Fedora/RHEL | `invoice-desk.x86_64.rpm` |
| Arch | `invoice-desk-x86_64.pkg.tar.zst` |
| Any distro | `InvoiceDesk-x86_64.AppImage`, `invoice-desk-linux-x64.tar.gz` |
| Integrity | `SHA256SUMS.txt` (+ `SHA256SUMS.txt.asc` if R7), `latest.json` |

`latest.json` (versioned schema, documented in `docs/RELEASING.md`):

```json
{
  "schema": 1,
  "version": "0.5.0",
  "date": "2026-11-20",
  "notes": "<the CHANGELOG section, markdown>",
  "assets": [
    { "platform": "windows", "format": "exe", "name": "InvoiceDesk-Setup-x64.exe",
      "url": "https://github.com/omarmaarouf18/invoice-desk/releases/download/v0.5.0/InvoiceDesk-Setup-x64.exe",
      "size": 12345678, "sha256": "…" }
  ]
}
```

## 5. Workflows

### `ci.yml`
- **PRs and pushes to branches other than main:** quality, codegen, schema, tests + coverage, goldens, security, Linux build. No packaging.
- **Push to `main`:** all of the above, plus the full package matrix (§6) as artifacts with 14-day retention, plus smoke tests. No publishing.

### `release.yml`
- **Triggers:** a `v*` tag push, or `workflow_dispatch` with input `dry_run` (default `true`).
- **`verify` job:**
  - The tag equals `v` + the `pubspec.yaml` version name.
  - `CHANGELOG.md` has a `## [X.Y.Z]` section.
  - The tagged commit is on `main`.
  - Fail fast otherwise.
- **Build jobs** (§6) in parallel, each with a smoke test.
- **`publish` job** (ubuntu, `needs` all builds):
  - Download all artifacts and write `SHA256SUMS.txt` and `latest.json`.
  - Add `actions/attest-build-provenance` attestations for every asset.
  - Optionally GPG-sign the checksums (R7).
  - Create the **published** release, with notes taken from the CHANGELOG section.
  - Optionally call `PORTFOLIO_DEPLOY_HOOK` and open a winget PR when `WINGET_TOKEN` exists.
  - In dry-run mode: everything except creating the release.
- **Action pinning:** pin every third-party action to a commit SHA (the repo already does this).
- **Concurrency:** one release at a time.
- **Permissions:** least privilege per job.

## 6. Build matrix

### Linux (`ubuntu-22.04`)
- `flutter build linux --release` once, then package that one bundle into every format.
- **.deb (new):**
  - Built with `dpkg-deb`, as `/opt/invoice-desk`, a `/usr/bin/invoice-desk` symlink, the .desktop file and hicolor icons.
  - Correct `Depends` (`libgtk-3-0`, …).
  - `lintian` clean, or justified overrides.
- **.rpm:** existing spec. `rpmlint` clean.
- **Arch (new):**
  - `packaging/arch/PKGBUILD` (`invoice-desk-bin`), built from the release tarball.
  - Built in an `archlinux:latest` container with `makepkg` as a non-root user.
  - `namcap` clean.
  - The PKGBUILD stays AUR-ready.
- **AppImage and tar.gz:** keep.
- **Smoke tests:**
  - Install the .deb in `ubuntu:22.04` and `debian:12` containers, the .rpm in `fedora:latest`, and the pkg in `archlinux`.
  - Launch headless with `xvfb-run`, and check that it starts and exits cleanly on a throwaway `INVOICE_DESK_DATA_DIR`.

### Windows (`windows-2022`)
- `flutter build windows --release`.
- **Inno Setup .exe:**
  - Per-user install by default.
  - Start-menu shortcut and uninstaller.
  - User data is never removed.
  - Version and publisher metadata set.
- **Portable .zip.**
- **MSIX:**
  - Identity values come from repo variables `MSIX_IDENTITY_NAME`, `MSIX_PUBLISHER`, `MSIX_PUBLISHER_DISPLAY_NAME`.
  - The first Store submission is manual; document it.
- **Bundle every runtime DLL** (sqlite3, VC++ runtime), so the app starts on a clean Windows.
- **Optional SignPath step:** runs only when `SIGNPATH_API_TOKEN` and its variables exist.
- **Smoke test:** silent install, launch, check the process is alive, close it, silent uninstall.

### macOS (`macos-14`)
- **First, recreate `macos/` cleanly** (`flutter create --platforms=macos .`):
  - App name "Invoice Desk", our bundle id and our icon.
  - Remove the dev/stg icons and the `ios` entry in `.metadata`.
  - Own commit.
- `flutter build macos --release`, then a `.dmg`.
- **When the Apple secrets exist** (`MACOS_CERT_P12_BASE64`, `MACOS_CERT_PASSWORD`, `APPLE_TEAM_ID`, `APPLE_API_KEY_ID`, `APPLE_API_ISSUER_ID`, `APPLE_API_KEY_P8_BASE64`, `MACOS_KEYCHAIN_PASSWORD`):
  - Use a temporary keychain.
  - Codesign with hardened runtime and a timestamp: nested code first, then the app, then the dmg.
  - Notarize with `xcrun notarytool submit --wait` and an API key, then `stapler staple`.
  - Verify with `codesign --verify --deep --strict` and `spctl`.
  - Clean up in an `always()` step. Never echo a secret.
- **Entitlements:**
  - Hardened runtime is required.
  - Decide on App Sandbox from what the app needs (`file_selector` open/save, the data folder, `url_launcher`), and explain the choice.
  - If sandboxed, check that the data dir, backups and PDF export still work.
- **Smoke test:** mount the dmg, launch the app, check it is alive, quit.

## 7. PERF-01 (deferred — separate task after the pipeline is merged; do not start it in this task)

- **Measure in profile mode**, on the demo data plus a generated large set (2,000 invoices, 300 clients, 100 contracts; fictional, not committed):
  - cold start to first frame;
  - PDF preview of a 2-page invoice;
  - typing latency in the editor;
  - sidebar scroll and search;
  - calendar month switch;
  - style editor preview update.
- **Check whether PDF building runs on the UI isolate.** If it does, move it to `Isolate.run`, with the fonts loaded once.
- **Fix only what the numbers show.** No behaviour change; goldens unchanged.
- **Report** a before/after table with raw numbers.

## 8. WF-03 (repo housekeeping, preparation only)

- **Fix `AI_CONTEXT.md`:** the line "Released: 0.4.0 on main" is false.
- **Replace the real names in the current tree** in `test/ui/contract_flow_test.dart` with fictional names. No history rewrite.
- **Add the secret-file guard:** a `.gitignore` and a gitleaks rule for `*.p12`, `*.p8`, `*.cer`, `*.pfx`, `*.key`, `*.asc` private keys.
- **Write `docs/RELEASING.md`** with the exact owner commands for:
  1. pushing `feat/bilingual-styles` and `feat/release-pipeline`;
  2. fast-forwarding `main`;
  3. tagging `v0.2.0`, `v0.3.0` and `v0.4.0` on their `chore(release)` commits;
  4. closing PRs #1–#3 as "included in main";
  5. deleting the merged branches;
  6. bumping to `0.5.0+6` with a `## [0.5.0]` CHANGELOG section;
  7. tagging `v0.5.0`.
- **One-time owner setup steps** also go in `docs/RELEASING.md`:
  - Apple secrets;
  - MSIX identity from Partner Center;
  - SignPath application (needs an OSI licence; the licence choice is the owner's, per ADR-0009);
  - GPG key;
  - winget token;
  - portfolio deploy hook.

## 9. README

- **Install section per platform:**
  - Windows: Microsoft Store (once live), winget, direct .exe (with the SmartScreen "More info → Run anyway" note while unsigned), portable .zip.
  - macOS: dmg.
  - Linux: deb, rpm, Arch, AppImage, tarball.
- **Minimum OS versions and glibc.**
- **How to verify a download:**
  - `sha256sum -c SHA256SUMS.txt --ignore-missing`
  - `gh attestation verify <file> --repo omarmaarouf18/invoice-desk`

## 10. Done when

- **The gate is green locally.** Workflows pass `actionlint`. Every signing or publishing step that needs a secret is skipped cleanly when that secret is absent, so the owner can add certificates later without code changes.
- **Commit per task ID.** Report in the WORKFLOW §5 format, then **stop**. You can't run GitHub workflows from a branch that isn't pushed.

### Owner sequence (put it in `docs/RELEASING.md` with exact commands)

1. Push `feat/bilingual-styles` and `feat/release-pipeline`.
2. Fast-forward `main` to `feat/release-pipeline` and push. The `main` CI run builds and smoke-tests every package: this is the first real test of the matrix.
3. Run `release.yml` by hand with `dry_run=true` on `main`. Send the run link to the agent to fix anything that fails.
4. Tag `v0.2.0`, `v0.3.0` and `v0.4.0` on the old commits, close PRs #1–#3, and delete the merged branches.
5. Add the certificates and secrets when ready (Apple, optional SignPath / GPG / winget / portfolio hook). Re-run the dry run.
6. Bump to `0.5.0`, add the CHANGELOG section, merge, and tag `v0.5.0`. The release publishes itself.

## 11. Stop and ask

- Any package cannot be built or smoke-tested on its runner.
- App Sandbox breaks a feature.
- A signing step would need a secret that is not in the list above.
- Any change to app behaviour beyond packaging and the measured performance fixes.

## Decisions (owner rulings during the work)

| Date | Ruling |
|---|---|
| 2026-11-18 | A local hook blocks `flutter create`; the owner chose to run it in a visible Terminal tab in a scratch folder and copy only `macos/` in. |
| 2026-11-18 | Merge every branch into one `dev` branch and keep it; old branches deleted locally and on GitHub, PRs #1–#3 closed. `main` follows `dev` by fast-forward. |
