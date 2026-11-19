# Brief — Green release pipeline and the first published version (0.5.0)

**Branch:** `feat/release-green` · **Base:** `dev@5dd01de` (the owner's Phase 0 merge of `origin/main`) · **Task IDs:** `WF-04` (CI plumbing), `REL-02` (package matrix green), `REL-03` (0.5.0 release) · **Status:** Phase 0 done by the owner 2026-11-19; Phase 1 started

Read `AGENTS.md`, `docs/ai/WORKFLOW.md`, `docs/RELEASING.md` and `docs/worklog/REL-01.md` first. This brief finishes `docs/briefs/2026-11-18-release-pipeline.md` (REL-01); it does not redesign it. You never push, merge, tag or run workflows. The owner does, and sends you the run links.

## 1. Goal

- Every package in the matrix (Linux, Windows, macOS) builds and passes its smoke test in CI **before** it reaches `main`.
- `main` CI is green, and the `release.yml` dry run on `main` is green.
- The old versions are tagged (`v0.2.0`–`v0.4.0`), and `v0.5.0` is published on GitHub Releases with every asset, `SHA256SUMS.txt`, `latest.json` and attestations.
- `main` and `dev` can't drift apart again.

## 2. Current state (verified 2026-11-19)

| Area | Where | State |
|---|---|---|
| Last `main` CI | run 44350255386 on `40bb882` | Failed. Quality, tests, build, goldens, codegen, schema and security passed. Three packaging jobs failed, and the rest of the matrix was cancelled (fail-fast), so `gh run list` shows "cancelled" |
| ↳ linux packages | `packaging/linux/invoice-desk.desktop` | `desktop-file-validate` rejected `Version=1.5`, because Ubuntu 22.04's validator only knows ≤ 1.4. Fixed on `dev` (`c0dd257`) |
| ↳ windows packages | `scripts/package_windows.ps1:51` | `sqlite3.dll` is missing from the bundle. sqlite3 3.x ships the DLL as a native asset, and `windows/CMakeLists.txt` never installed it. Fixed on `dev` (`3dda24b`, native-assets install block from the 3.44 template) |
| ↳ macos package | `.github/workflows/package.yml` | GitHub rejected `macos-14`: "configuration 'macos-14-arm64-us-default' is not supported". Fixed on `dev` (`02e27ac`, `macos-15`) |
| `dev` vs `main` | git | Diverged. Both branch off `c0b6e4f`. `main` has the Dependabot PR #4 merge (`9655ad4` + merge `40bb882`, action pins bumped), and `dev` has the three fixes above. **Resolved in Phase 0** (`5dd01de`) |
| Packaging trigger | `ci.yml` job `packages` | `if: push && ref == main` only. `dev` CI skips it (the green dev run 44350003271 shows `packages` skipped), so none of the three fixes has run in CI |
| Release dry run | `release.yml` `verify` job | Fails unless `$GITHUB_SHA` is on `main` (also in dry-run mode) |
| Ruleset | `protect-main` | Blocks deletion and non-fast-forward pushes. Requires `quality`, `tests` and `build`. It does **not** require linear history, which is why a PR merge commit landed on `main` |
| Dependabot | `.github/dependabot.yml` | No `target-branch`, so PRs go to `main`. PRs #5 (pub minor/patch) and #6 (pub major) fail `flutter pub get`: `window_manager ^0.7.0` needs Dart ^3.14, and `very_good_analysis ^11.0.0` needs ^3.13. CI pins Flutter 3.44.6, which ships Dart 3.12.2. **Closed in Phase 0** |
| Version | `pubspec.yaml` | `0.4.0+5`. `CHANGELOG.md` has only `## [Unreleased]` on top. Tags: only `v0.1.0`. No GitHub releases |
| Unverified from REL-01 | worklog | Windows scripts, macOS scripts, AppImage smoke, Arch build from the CI tarball, and the container install matrix have never run on GitHub runners |

### Known bugs in scope

- **B1** — Packaging fixes can only be tested by moving `main`, so every packaging bug costs a red `main` run. Cause: the `packages` job is main-only, and the dry run is main-only.
- **B2** — Dependabot PRs target `main` and are merged with a merge commit, which breaks the "`main` only fast-forwards to `dev`" rule (RELEASING §3).

## 3. Decisions

| # | Decision | Default | Date / by |
|---|---|---|---|
| D1 | How to test packaging before `main` | `package.yml` gets a `workflow_dispatch` trigger (`sign` default `false`, `retention-days` default 7). The owner runs it on `dev` before every fast-forward of `main`. `ci.yml` stays as it is | 2026-11-19 / planner, proposed |
| D2 | Release dry run off `main` | Unchanged: main-only. D1 covers the builds, and the publish job is rehearsed once on `main` (Phase 3) | 2026-11-19 / planner, proposed |
| D3 | Dependabot | `target-branch: dev` for both ecosystems. Ignore `window_manager >=0.7` and `very_good_analysis >=11` until a Flutter SDK bump task. Close #5 and #6 | 2026-11-19 / planner, proposed |
| D4 | Keep `main` linear | The owner adds **Require linear history** to `protect-main`. Nobody presses "Merge" on a PR into `main` | 2026-11-19 / planner, proposed |
| D5 | Scope of 0.5.0 | Ships phases 0–6 of the bilingual-styles brief; 7–8 go to 0.6.0 (REL-01 open question 2) | owner to confirm |
| D6 | Signing for 0.5.0 | Ship unsigned on Windows and macOS if the secrets aren't ready (already allowed by R5/R6). The README states the Gatekeeper/SmartScreen steps | owner to confirm |

## 4. Phases

### Phase 0 — Re-join `main` and `dev` (owner, before the Builder starts)

Merge `main` into `dev` (verified clean; it keeps `main`'s newer action pins) and push `dev`:

```bash
git switch dev && git pull && git merge --no-edit origin/main && git push origin dev
```

Close PRs #5 and #6 with a note pointing to D3.

**Done when:** `git merge-base --is-ancestor origin/main origin/dev` succeeds, and `dev` CI is green.

### Phase 1 — CI plumbing (WF-04)

- `package.yml`: add `workflow_dispatch` with the same inputs as `workflow_call` and the D1 defaults. Inputs must resolve the same way under both triggers (`inputs.*` works for both, so don't use `github.event.inputs`).
- `dependabot.yml`: add `target-branch: dev` to both ecosystems and the D3 `ignore` entries, each with a comment that names the SDK each one needs.
- `docs/RELEASING.md`:
  - §3: add a step "run `package.yml` on `dev`" before the fast-forward;
  - §4: the same step on every release;
  - add a short "Never merge into `main`" note (D4), with the ruleset change the owner makes.

**Done when:** `actionlint` is clean, the local gate is green, and there is one commit per logical change.

### Phase 2 — Package matrix green (REL-02)

A loop between the owner and the Builder:

1. The owner pushes `feat/release-green` and runs:
   ```bash
   gh workflow run package.yml --ref feat/release-green
   ```
   Then they send the run link.
2. The Builder reads the logs with `gh run view <id> --log-failed`, fixes packaging/CI only, commits `fix(REL-02): …`, and logs the finding in `docs/worklog/REL-02.md`.
3. Repeat until green.

Check each one explicitly in the run, not only "job green":

- **Linux:**
  - the `.desktop` file validates;
  - tarball, AppImage, `.deb` and `.rpm` are built from one bundle;
  - `rpmlint` and `lintian` are clean;
  - the glibc ceiling is ≤ 2.35;
  - the tarball and AppImage smoke runs pass;
  - the Arch package builds from the CI tarball and `namcap` is clean;
  - every image in the install matrix (`ubuntu:22.04`, `debian:12`, `fedora`, `arch`) installs, launches headless and is removed.
- **Windows:**
  - `sqlite3.dll` and the VC++ runtime are in the bundle;
  - the DLL dependency check passes;
  - the Inno installer, the portable zip and the MSIX (artifact only) are built;
  - silent install → launch → alive → uninstall passes;
  - the portable zip launches.
- **macOS (`macos-15`):**
  - the app is built;
  - sqlite3 is bundled (check the native assets the same way as on Windows);
  - the `.dmg` is built (state universal or arm64);
  - the unsigned path is taken cleanly with no secrets;
  - mount → launch → alive → quit passes.
- **Artifacts:** every name matches the stable names in REL-01 brief §4, with no version in the name.

**Done when:**
- one `package.yml` run on the branch is fully green, with its link in the report;
- the "Unverified" list in `REL-01.md` is emptied or each remaining item is explained.

### Phase 3 — `main` and the dry run (owner, Builder on call)

1. Fast-forward `main` to the green `dev` commit: `git push origin dev:main`.
2. Check that the `main` CI run is fully green, including `packages`.
3. Run `gh workflow run release.yml --ref main -f dry_run=true`. Check that `verify` passes, `latest.json` and `SHA256SUMS.txt` are produced and correct, the attestations are created, and no release is created.
4. Any failure goes back to the Builder as in Phase 2.

**Done when:** both run links are green and recorded in `REL-02.md`.

### Phase 4 — Old tags and 0.5.0 (REL-03)

1. **Owner:** tag `v0.2.0`, `v0.3.0` and `v0.4.0` with `release.yml` disabled (RELEASING §3 step 4, unchanged).
2. **Builder:** bump `pubspec.yaml` to `0.5.0+6`, and turn `## [Unreleased]` into `## [0.5.0] - <date>` covering phases 0–6 and the pipeline (D5). Then:
   - update `AI_CONTEXT.md` ("Released", "Next");
   - update the README install section if D6 means unsigned macOS;
   - run `dart tool/release.dart verify --tag v0.5.0` locally;
   - commit `chore(release): 0.5.0`.
3. **Owner:** run `package.yml` on `dev` (D1). Then fast-forward `main`, wait for green, and push `v0.5.0`.

**Done when:** the release page for `v0.5.0` is published (not a draft) and:
- every `releases/latest/download/<name>` link from REL-01 §4 downloads;
- `latest.json` validates against schema 1;
- `sha256sum -c SHA256SUMS.txt --ignore-missing` passes;
- `gh attestation verify <file> --repo omarmaarouf18/invoice-desk` passes for at least one asset per platform.

## 5. Definition of done (whole brief)

- `./scripts/ci_local.sh --no-package` passes, and the workflows are `actionlint` clean.
- The green run links for `package.yml` (branch), `main` CI and the `release.yml` dry run are in `docs/worklog/REL-02.md`.
- `v0.5.0` is published as in Phase 4.
- `docs/RELEASING.md`, `AI_CONTEXT.md`, `CHANGELOG.md` and the README are true. List them under "Docs corrected".
- No app behaviour changes, and the goldens are unchanged.

## 6. Stop and ask

On top of `AGENTS.md` §6, stop and ask when:

- A smoke test fails because of the app, not the packaging: a crash, a missing feature, or a DB that isn't created.
- A fix needs a new dependency, a Flutter SDK bump, or a change under `lib/`.
- macOS won't launch unsigned on `macos-15` (for example, Gatekeeper in the smoke test), and the only fix seems to be signing.
- A runner image or tool (Inno Setup, `makeappx`, `appimagetool`, `archlinux:latest`) changed in a way that needs a new pinned version or a decision.
- The dry run's `latest.json` or the asset names differ from REL-01 §4.

## 7. Out of scope

- Flutter SDK bump and dependency updates (#5, #6, and the 36 outdated packages): separate task after 0.5.0.
- Signing secrets (Apple, SignPath, GPG, winget, portfolio hook): owner setup, RELEASING §5.
- PERF-01, and phases 7–8 of the bilingual-styles brief.
- Pinning `appimagetool` to a checksum (REL-01 leftover), unless it breaks a run in Phase 2.

## Decisions (owner rulings during the work)

| Date | Ruling |
|---|---|
| 2026-11-19 | Phase 0 done: `origin/dev` = `5dd01de` (merge of `origin/main`), `dev` CI run 44466037046 green, #5 and #6 closed per D3. Builder branches `feat/release-green` off `5dd01de`. |
| 2026-11-19 | `dartjni` (from transitive `jni`; hard-imports `jvm.dll` / `libjvm.so`; never loaded on desktop): option (b). The package scripts remove it from the desktop bundles after `flutter build`, on all three platforms. A guard fails the build if any bundled binary still needs `jvm.dll` / `libjvm.*`, and the smoke tests add one launch without `INVOICE_DESK_DATA_DIR`, so the default data-dir lookup is proven to work without `jni`. Upstream `jni` issue: owner decides later. |
| 2026-11-19 | `install ubuntu:22.04` (re-run job 135394180551 failed with `Failed to fetch http://archive.ubuntu.com/ubuntu/dists/jammy/InRelease Connection failed`, then `E: Package 'xauth' has no installation candidate`): switch the mirror. In CI only, the ubuntu container uses `http://azure.archive.ubuntu.com/ubuntu` for `jammy`, `jammy-updates` and `jammy-backports`, and keeps `security.ubuntu.com`. It's driven by an env var set in `package.yml`, so local runs keep the default mirror. `apt-get update` fails on any fetch error. |
| 2026-11-19 | `main` CI run 44490378245: `packages / install ubuntu:22.04` ran out of download tries while each try was resuming (`81.0 → 74.0 → 36.2 MB` left of 93.7 MB). Ruling: container download tries go to 6, with the limits rebalanced and the job's `timeout-minutes` raised to fit the worst case. The `ubuntu:22.04` install entry becomes non-blocking (`continue-on-error`), so a mirror stall can't block `release.yml`; `debian:12` keeps covering the `.deb`. On failure that entry emits a `::warning::` naming the mirror stall, and `RELEASING.md` says a red `ubuntu:22.04` install must be checked by hand before tagging. |
