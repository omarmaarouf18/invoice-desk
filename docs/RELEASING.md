# Releasing

The owner pushes a `vX.Y.Z` tag on `main`. Everything after that is automatic: every package for Windows, macOS and Linux is built, smoke-tested and **published** to GitHub Releases in this repo. Nothing is published if any check, build or smoke test fails.

Every push to `main` builds and smoke-tests the same packages as 14-day CI artifacts, so a release is never the first time a package is built.

Agents never push, tag or publish; the commands in this file are the owner's.

## 1. The pipeline

| Workflow | When | What |
|---|---|---|
| `ci.yml` | every push and PR | format, analyze, layering, sizes, codegen, schema guard, tests + coverage, goldens, security, Linux build + smoke run |
| `ci.yml` → `package.yml` | push to `main` | the full package matrix below, **unsigned**, as artifacts (14 days) |
| `release.yml` | tag `v*`, or by hand | `verify` → `package.yml` (signed when the secrets exist) → `publish` |

`release.yml`:

1. **verify** fails fast unless the tag is `v` + the `pubspec.yaml` version name, `CHANGELOG.md` has a `## [X.Y.Z]` section, and the tagged commit is on `main` (`tool/release.dart verify`).
2. **package** (`package.yml`, jobs in parallel):

   | Job | Runner | Builds | Checks |
   |---|---|---|---|
   | linux | `ubuntu-22.04` (glibc 2.35) | one `flutter build linux`, then tarball, AppImage, RPM, deb | glibc ceiling 2.35, `rpmlint`, `lintian`, tarball + AppImage smoke runs |
   | arch | `archlinux:latest` container | `makepkg` from the tarball, as a non-root user | `namcap` |
   | install (×4) | `ubuntu:22.04`, `debian:12`, `fedora:latest`, `archlinux:latest` containers | — | install the package, launch headless 15 s, remove (`scripts/smoke_linux.sh`) |
   | windows | `windows-2022` | Inno Setup `.exe`, portable `.zip`, `.msix`; optional SignPath signing | bundled-DLL check; silent install → launch → uninstall, zip launch (`scripts/smoke_windows.ps1`) |
   | macos | `macos-15` | universal `.app` → `.dmg`; optional Developer ID signing + notarization | `codesign`/`spctl` when signed; mount → launch → quit (`scripts/smoke_macos.sh`) |

3. **publish** downloads the release assets, writes `SHA256SUMS.txt` and `latest.json`, adds build-provenance attestations for every asset, optionally GPG-signs the checksums, and creates the **published** release with the CHANGELOG section as its notes. Then, optionally, it calls the portfolio deploy hook and opens a winget PR.

Run by hand (**Actions → Release → Run workflow**) with `dry_run` ticked (the default), it does everything except creating the release and its follow-ups; the would-be release is kept as the `release-preview` artifact. `dry_run` unticked is only accepted when the workflow is run on a tag, to re-run a release whose run failed.

Every step that needs a secret is skipped cleanly while that secret is absent, so certificates can be added later without code changes. Every third-party action is pinned to a commit SHA.

### Smoke test

Every package is installed (or unpacked) and launched with `INVOICE_DESK_DATA_DIR` set to an empty temporary folder. It passes when the app is still running after 15 s, has created `invoice_desk.sqlite`, logged no Dart/Flutter exception and stops when asked; removing the package must leave that data folder alone.

## 2. Assets

Names never carry the version, so `https://github.com/omarmaarouf18/invoice-desk/releases/latest/download/<name>` always points at the latest release. The version lives inside each package and in `latest.json`.

| Platform | File | Notes |
|---|---|---|
| Windows | `InvoiceDesk-Setup-x64.exe` | Inno Setup; per-user install in `%LOCALAPPDATA%\Programs\Invoice Desk` (an admin can choose all users) |
| Windows | `InvoiceDesk-Windows-x64.zip` | portable folder `InvoiceDesk\` with `VERSION.txt` |
| macOS | `InvoiceDesk-macOS.dmg` | universal (Apple silicon + Intel); the build prints `lipo -archs` |
| Debian/Ubuntu | `invoice-desk_amd64.deb` | `/opt/invoice-desk`, `/usr/bin/invoice-desk` |
| Fedora/RHEL | `invoice-desk.x86_64.rpm` | `/opt/invoice-desk`, `/usr/bin/invoice-desk` |
| Arch | `invoice-desk-x86_64.pkg.tar.zst` | package name `invoice-desk-bin` |
| Any distro | `InvoiceDesk-x86_64.AppImage`, `invoice-desk-linux-x64.tar.gz` | the tarball's folder is `invoice-desk-X.Y.Z-linux-x64/` |
| Integrity | `SHA256SUMS.txt`, `SHA256SUMS.txt.asc` (when GPG is set up), `latest.json` | |

Workflow artifacts only, never attached to a release:

- `windows-msix` — `InvoiceDesk-x64.msix`, unsigned, for a Microsoft Store submission (an unsigned MSIX cannot be installed from a download).
- `aur-pkgbuild` — the `PKGBUILD` and `.SRCINFO` with this release's `pkgver` and checksum, ready for the AUR.

### `latest.json` (schema 1)

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

- `schema` goes up only for a breaking change; fields are only ever added within a schema.
- `date` is the UTC publish date, `YYYY-MM-DD`. `size` is in bytes; `sha256` is lowercase hex.
- `platform` is `windows`, `macos` or `linux`; `format` is `exe`, `zip`, `dmg`, `deb`, `rpm`, `pkg.tar.zst`, `AppImage` or `tar.gz`.
- `assets` lists every release asset except the integrity files, in the order of the table above.
- A site reads it from `https://github.com/omarmaarouf18/invoice-desk/releases/latest/download/latest.json`.

The asset list and the format live in `tool/release.dart`; `test/tool/release_test.dart` covers them.

### Package checks: accepted findings

Each package checker runs strictly; the findings below are accepted on purpose and listed where the checker reads them:

- **All Linux packages:** the app is a prebuilt, self-contained Flutter bundle in `/opt/invoice-desk` with `$ORIGIN` RUNPATHs (ADR-0006, ADR-0007). Its libraries are shipped as Flutter builds them (no SONAME on `libapp.so`, not stripped, no PIE on the launcher, a few unused `DT_NEEDED` entries). Fonts are bundled (AGENTS.md rule 14).
- **rpmlint:** `packaging/rpm/invoice-desk.rpmlintrc`. **lintian:** `packaging/deb/lintian-overrides`. **namcap:** the `accepted` pattern in `scripts/package_arch.sh`.
- **EGL/GLES** are declared by hand (`libegl1, libgles2` / `libEGL.so.1`, `libGLESv2.so.2` / `libglvnd`): the engine loads them with `dlopen`, so the dependency scanners cannot see them, and a minimal system aborts at launch without them.

### macOS entitlements: no App Sandbox

The app is signed with the hardened runtime and **no** App Sandbox:

- Settings keeps a backup folder and an export folder chosen in an earlier session, and the app writes to them later. Under the sandbox that needs security-scoped bookmarks, which `file_selector` does not create, so both settings would stop working after a restart.
- The sandbox is only required for the Mac App Store, which is not a target. Developer ID + notarization does not need it.
- Data stays in `~/Library/Application Support/me.omarmaarouf.invoice-desk`. `url_launcher` (opening an exported PDF) and the open/save dialogs need no entitlement without the sandbox.
- `Release.entitlements` sets nothing else; `DebugProfile.entitlements` adds `allow-jit` for debug builds only.

## 3. Owner sequence (first time)

**Branches (done 2026-11-18).** The old chain `main → release-packaging → feature/contracts → hardening/v0.3 → feature/calendar → feat/bilingual-styles → feat/release-pipeline` was fast-forwarded into one integration branch, `dev`. The old branches are deleted locally and on GitHub, and PRs #1–#3 are closed. Work now lands on `dev`; `main` only moves by fast-forward to a `dev` commit whose CI is green.

**1. Push `dev`** and wait for its CI run (quality, tests, build):

```bash
git push origin dev
```

```bash
gh run list --branch dev --limit 1
```

**2. Fast-forward `main` to `dev`.** The `protect-main` ruleset only accepts a commit that already has the required checks, which is why `dev` goes first. A fast-forward keeps every SHA, so the old release commits stay taggable; never squash- or rebase-merge into `main`.

```bash
git push origin dev:main
```

This `main` push runs `package.yml`: the first real build and smoke test of the whole matrix. Check it:

```bash
gh run list --workflow ci.yml --branch main --limit 1
```

**3. Dry-run the release on `main`.** Send the run link to the agent if anything fails.

```bash
gh workflow run release.yml --ref main -f dry_run=true
```

```bash
gh run list --workflow release.yml --limit 1
```

**4. Tag the old releases.**

Pushing a tag runs the `release.yml` **of the tagged commit**. The old commits still carry the old workflow, which would create draft releases. Pause the workflow while pushing the old tags:

```bash
gh workflow disable release.yml
```

```bash
git tag -a v0.2.0 98a7cb9 -m "Invoice Desk 0.2.0" && git tag -a v0.3.0 df865df -m "Invoice Desk 0.3.0" && git tag -a v0.4.0 e120ecb -m "Invoice Desk 0.4.0"
```

```bash
git push origin v0.2.0 v0.3.0 v0.4.0
```

```bash
gh workflow enable release.yml
```

**5. Add certificates and secrets when ready** (§5): Apple, then optionally SignPath, GPG, winget and the portfolio hook. Re-run the dry run (step 3) after each.

**6. Release 0.5.0** (§4): bump to `0.5.0+6`, add the `## [0.5.0]` CHANGELOG section, merge to `main`, then:

```bash
git tag -a v0.5.0 -m "Invoice Desk 0.5.0" && git push origin v0.5.0
```

The release publishes itself.

## 4. Every release

1. **Prepare on a branch from `main`.** `./scripts/ci_local.sh --no-package` is green.
2. **Bump the version** in `pubspec.yaml`: `version: X.Y.Z+N`, where `N` goes up by one every release (0.5.0 is `0.5.0+6`).
3. **Move `[Unreleased]`** in `CHANGELOG.md` under `## [X.Y.Z] - YYYY-MM-DD`. This section becomes the release notes.
4. **Packaging metadata:** add a `%changelog` entry and bump the `pkgversion` default in `packaging/rpm/invoice-desk.spec`; set `pkgver` in `packaging/arch/PKGBUILD`.
5. **If the schema changed:** rehearse the upgrade (§6) and regenerate `docs/DATA_MODEL.md` (`dart run tool/gen_data_model.dart`).
6. **Commit** `chore(release): X.Y.Z`, merge to `main` (fast-forward or merge commit), wait for the `main` CI run, then tag that commit:

```bash
git tag -a vX.Y.Z -m "Invoice Desk X.Y.Z" && git push origin vX.Y.Z
```

7. **Check the release page** and the downloads:

```bash
gh release download vX.Y.Z -D /tmp/check && (cd /tmp/check && sha256sum -c SHA256SUMS.txt)
```

8. **AUR (optional):** copy `PKGBUILD` and `.SRCINFO` from the run's `aur-pkgbuild` artifact into the AUR repository and push it.

If the tag run fails after the tag is pushed, fix the cause on `main`, delete and re-push the tag on the fixed commit (nothing was published), or re-run the failed jobs if the cause was outside the repo.

## 5. One-time setup (secrets and variables)

Secrets: Settings → Secrets and variables → Actions → Secrets, or `gh secret set NAME`. Variables: the Variables tab, or `gh variable set NAME --body VALUE`. Never commit the files; `.gitignore` and the gitleaks rules block `*.p12`, `*.p8`, `*.pfx`, `*.cer`, `*.key`, `*.asc`.

### Apple (macOS signing + notarization, decision R5)

All seven must exist, or the dmg ships unsigned.

1. In Xcode or the developer portal, create a **Developer ID Application** certificate and export it with its private key as `cert.p12` with a password.
2. In App Store Connect → Users and Access → Integrations → **App Store Connect API**, create a team key with the Developer role. Download `AuthKey_<KEYID>.p8` (once only) and note the key ID and issuer ID.
3. Set the secrets:

```bash
base64 -w0 cert.p12 | gh secret set MACOS_CERT_P12_BASE64
```

```bash
gh secret set MACOS_CERT_PASSWORD
```

```bash
openssl rand -base64 24 | gh secret set MACOS_KEYCHAIN_PASSWORD
```

```bash
gh secret set APPLE_TEAM_ID --body "<10-character team ID>"
```

```bash
gh secret set APPLE_API_KEY_ID --body "<key ID>" && gh secret set APPLE_API_ISSUER_ID --body "<issuer UUID>"
```

```bash
base64 -w0 AuthKey_<KEYID>.p8 | gh secret set APPLE_API_KEY_P8_BASE64
```

Then delete `cert.p12` and the `.p8` from disk (keep them in your password manager).

### Microsoft Store (MSIX identity)

1. Partner Center → Apps and games → **New product** → MSIX or PWA app; reserve the name "Invoice Desk".
2. Product identity page: copy **Package/Identity/Name**, **Package/Identity/Publisher** (`CN=…`) and **Package/Properties/PublisherDisplayName**:

```bash
gh variable set MSIX_IDENTITY_NAME --body "<Package/Identity/Name>" && gh variable set MSIX_PUBLISHER --body "<CN=…>" && gh variable set MSIX_PUBLISHER_DISPLAY_NAME --body "<display name>"
```

3. The **first submission is manual**: download the `windows-msix` artifact of the next `main` run (or of the release run), then in Partner Center create a submission, upload `InvoiceDesk-x64.msix` under Packages, fill in the listing (Arabic and English), age rating and privacy policy (the app collects nothing), and submit. The Store signs the package. Later versions can be uploaded the same way.
4. Note: under MSIX, Windows redirects writes to `%APPDATA%` into the package's private folder, so a Store install does not see the data of an `.exe` install. Test a backup/restore round trip before the listing goes live.

### SignPath (optional Windows signing, decision R6)

Until this exists the `.exe` is unsigned and SmartScreen shows "Windows protected your PC" (More info → Run anyway).

1. SignPath Foundation signs **open-source** projects only: the repository needs an OSI-approved licence. Choosing one is the owner's decision (ADR-0009); nothing in this pipeline assumes it.
2. Apply at signpath.org, then in SignPath create the project (slug), a release signing policy, and connect GitHub as a trusted build system for this repo with an artifact configuration that signs `InvoiceDesk-Setup-x64.exe`.
3. Set:

```bash
gh secret set SIGNPATH_API_TOKEN
```

```bash
gh variable set SIGNPATH_ORGANIZATION_ID --body "<org id>" && gh variable set SIGNPATH_PROJECT_SLUG --body "invoice-desk" && gh variable set SIGNPATH_SIGNING_POLICY_SLUG --body "release-signing"
```

Signing runs on releases (and dry runs), not on `main` pushes. A TLS/domain certificate cannot sign code.

### GPG (optional signature of `SHA256SUMS.txt`, decision R7)

The workflow imports `GPG_PRIVATE_KEY` and signs with **no passphrase**, so store a dedicated signing subkey without one (not your primary key):

```bash
gpg --quick-add-key <PRIMARY-FPR> ed25519 sign 2y
```

```bash
export T=$(mktemp -d) && gpg --export-secret-subkeys --armor <SUBKEY-ID>! | GNUPGHOME=$T gpg --import && GNUPGHOME=$T gpg --passwd <SUBKEY-ID>
```

(leave the new passphrase empty), then:

```bash
GNUPGHOME=$T gpg --export-secret-subkeys --armor <SUBKEY-ID>! | gh secret set GPG_PRIVATE_KEY && rm -rf "$T"
```

Publish the public key on your domain (`gpg --export --armor <PRIMARY-FPR>`). Users verify with `gpg --verify SHA256SUMS.txt.asc SHA256SUMS.txt`.

### winget (optional)

1. The first manifest is manual: once a release exists, on Windows run `wingetcreate new https://github.com/omarmaarouf18/invoice-desk/releases/download/vX.Y.Z/InvoiceDesk-Setup-x64.exe` with the identifier `OmarMaarouf.InvoiceDesk`, and submit the PR it opens to `microsoft/winget-pkgs`.
2. Fork `microsoft/winget-pkgs` to your account, and create a classic token with the `public_repo` scope:

```bash
gh secret set WINGET_TOKEN
```

Each later release then opens the update PR itself.

### Portfolio deploy hook (optional)

A deploy-hook URL from the portfolio's host (Vercel, Netlify, Cloudflare Pages…). The release `POST`s to it so the site rebuilds and picks up `latest.json`:

```bash
gh secret set PORTFOLIO_DEPLOY_HOOK
```

## 6. Rehearse the upgrade (schema changes only)

Never on real data. Use a temporary data folder:

```bash
T=$(mktemp -d)
```

```bash
INVOICE_DESK_DATA_DIR=$T timeout 10 /opt/invoice-desk/invoice_desk
```

The installed previous release creates its schema in `$T`. Then build and open the same folder with the new release:

```bash
./scripts/package_linux.sh && tar xzf dist/invoice-desk-linux-x64.tar.gz -C $T
```

```bash
INVOICE_DESK_DATA_DIR=$T timeout 12 $T/invoice-desk-X.Y.Z-linux-x64/invoice_desk
```

```bash
sqlite3 "file:$T/invoice_desk.sqlite?mode=ro" 'PRAGMA user_version; PRAGMA foreign_key_check; PRAGMA integrity_check;'
```

Expect the new `user_version`, no FK problems, `ok`, and the old rows still present. Launch the new build a second time on the same folder and check nothing is seeded twice.

## 7. Building locally

- **Linux:** `./scripts/package_linux.sh` builds the bundle and writes the Linux assets to `dist/`. It needs `patchelf`; the RPM needs `rpmbuild`, the deb `dpkg-deb` + `dpkg-shlibdeps` (Debian/Ubuntu), the AppImage downloads `appimagetool`. A build on a newer distro needs a newer glibc/GLib than the release; only the `ubuntu-22.04` build is shipped. `scripts/package_arch.sh dist` and `scripts/smoke_linux.sh <package>` run as root in the matching container, e.g.:

```bash
podman run --rm -v "$PWD":/src:z -w /src docker.io/library/debian:12 bash scripts/smoke_linux.sh dist/invoice-desk_amd64.deb
```

- **Windows:** `pwsh scripts/package_windows.ps1` (needs Visual Studio's C++ tools, Inno Setup 6 and the Windows SDK), then `pwsh scripts/smoke_windows.ps1 -Installer dist/InvoiceDesk-Setup-x64.exe -Zip dist/InvoiceDesk-Windows-x64.zip`.
- **macOS:** `./scripts/package_macos.sh`, then `./scripts/smoke_macos.sh dist/InvoiceDesk-macOS.dmg`. Without the Apple variables in the environment it builds an ad-hoc-signed dmg.

## Rollback

- **App.** Install the previous release's package from its release page (`sudo apt install ./invoice-desk_amd64.deb`, `sudo dnf downgrade ./invoice-desk.x86_64.rpm`, `sudo pacman -U …`, the previous `.exe` or dmg), or run the previous AppImage or tarball.
- **Data.** An older app can't open a newer schema. To go back after a schema migration, restore a backup made by the older version: Settings → النسخ الاحتياطي → استعادة. Pick one of the dated daily backups in `backups/` from before the upgrade. Restore keeps a safety copy of the current data first.
- **A bad release.** Mark it as a pre-release or delete it on GitHub (the previous one becomes "latest" again, and so do the `latest/download` links and `latest.json`), then fix and release a new patch version. Never re-use a version number for different files.
