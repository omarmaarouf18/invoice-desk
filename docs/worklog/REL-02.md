# REL-02 — Package matrix green

**Brief:** docs/briefs/2026-11-19-release-green.md, Phase 2 · **Branch:** feat/release-green

## Runs

| Run | Commit | Linux | Windows | macOS | Notes |
|---|---|---|---|---|---|
| 44468227612 | `5deb348` | ❌ rpmlint | ❌ DLL check | ✅ | arch + install matrix skipped (they need the Linux job) |
| 44471887698 | `8e8295c` | ✅ (+ arch, install debian:12, fedora, arch) | ✅ | ✅ | `install ubuntu:22.04` hung 20 min with no output and was cancelled. The re-run (job 135394180551) failed after 14 min: `Failed to fetch http://archive.ubuntu.com/ubuntu/dists/jammy/InRelease Connection failed [IP: 185.125.190.82 80]`, then `E: Package 'xauth' has no installation candidate` |
| 44478892261 | `a97328c` | ❌ AppImage smoke | ✅ | ✅ | the runner's own `apt-get update` (in `smoke_linux.sh`) timed out at 90 s: `azure.archive.ubuntu.com` stalled, every InRelease `Ign`, and `packages.microsoft.com` was a `Hit`. The tarball smoke's update a minute earlier took 30 s. Arch and the install matrix were skipped |
| 44484076707 | `173f74e` | ✅ (+ arch, install debian:12, fedora, arch) | ✅ | ✅ | `install ubuntu:22.04`: `apt-get update` took 2 s (Azure, 49.5 MB), then `install -y xvfb xauth libgl1-mesa-dri procps` stalled mid-download (`libgl1-amber-dri`, 4.2 MB) and hit its 110 s limit. On the runner, `apt_retry.sh` worked under sudo, but its install took 6.5 min at 44 kB/s, close to the 600 s limit. Branch CI run 44484076759 green |
| 44490378245 (`main` CI) | `c312104` | ✅ except `install ubuntu:22.04` | ✅ | ✅ | first `main` run with packages. `install ubuntu:22.04` ran out of its 3 download tries while each try was resuming (`81.0 → 74.0 → 36.2 MB` left of 93.7 MB). Every other job green |
| 44495539215 (`main` CI) | `e9f3a72` | ✅ | ✅ | ✅ | **fully green, including the package matrix** (Phase 3) |
| 44495540370 (`release.yml` dry run on `main`) | `e9f3a72` | ✅ | ✅ | ✅ | **fully green** (Phase 3). `publish` produced all 8 stable-named assets, `SHA256SUMS.txt`, `latest.json` and attestations, and created no release. `install ubuntu:22.04` passed after one download retry |

## Findings

- 2026-11-19 — **rpmlint on Ubuntu 22.04 is the wrong linter** (run 44468227612, `package.yml` rpmlint step).
  - **What the log shows:** Ubuntu's rpmlint 2.2.0 loads only its own `configdefaults.toml` and reports 41 errors and 4 warnings. The extra findings are `non-versioned-file-in-library-package` on every file, `no-signature`, `no-packager-tag`, `no-group-tag` and `invalid-license OFL-1.1`. It also reports two of our filters as unused, because that version doesn't have those checks.
  - **Fix:** lint the RPM in a `fedora:latest` container (its target distro). The build stays on 22.04 (R4). `rpmlint` is dropped from the apt list, and no filters were added for the old-rpmlint findings.
  - **Checked locally:** the same `docker run` command on the local `dist/invoice-desk.x86_64.rpm` (built 2026-11-18) gives rpmlint 2.9.0 with Fedora's config: "0 errors, 2 warnings, 135 filtered, 0 badness". It exits 0.
- 2026-11-19 — **`dartjni.dll -> jvm.dll` is a hard import, not delay-loaded** (run 44468227612, `package_windows.ps1` DLL check).
  - **Where it comes from:** `dartjni.dll` comes from transitive `jni 1.1.2` (via `path_provider_android` → `jni_flutter`). It is only built when CMake finds a JDK, and the `windows-2022` runner has one. A Fedora dev box with `/usr/bin/javac` builds `libdartjni.so` too.
  - **Why it's a hard import:** `jni-1.1.2/src/CMakeLists.txt:45-47` sets `/DELAYLOAD:jvm.dll` on `${TARGET_NAME}`, but no CMake file in `jni` or this app defines `TARGET_NAME`. With an empty target list, `set_target_properties` is a silent no-op. Checked with CMake 4.3.0: a one-line project that calls it with an empty `${TARGET_NAME}` configures with no error. The library is then linked with `target_link_libraries(jni ${JNI_LIBRARIES})`, which pulls in `jvm.lib`. So `jvm.dll` lands in the normal import table.
  - **Not seen in the binary:** the failed job uploads no Windows artifact, and `dumpbin` doesn't run here. The evidence comes from the build files, not from the DLL's headers.
  - **Linux has the same library:** `deb.log` in `linux-packaging-logs` shows `dpkg-shlibdeps: warning: cannot find library libjvm.so needed by …/lib/libdartjni.so`. The RPM hides it with `__requires_exclude_from ^/opt/invoice-desk/.*$`. So every Linux package already ships a `libdartjni.so` that can't load. That's harmless as long as nothing opens it: `jni` opens it lazily with `DynamicLibrary.open`, and only Android code paths use `jni`.
  - **Status:** fixed per the owner ruling of 2026-11-19, option (b). See the next finding.
- 2026-11-19 — **`dartjni` removed from the desktop bundles; JVM guards added on all three platforms.**
  - **Removal:** `package_linux.sh` deletes `lib/libdartjni.so` from the staged copy, and `package_windows.ps1` deletes `dartjni.dll` from the bundle. Both run after `flutter build`. The Arch package is built from the tarball, so it doesn't have it either.
  - **Guards:**
    - Linux: any ELF with `NEEDED libjvm.so` fails the build.
    - Windows: any `jvm.dll` import fails the DLL check, even if the DLL were somehow bundled.
    - macOS: any `dartjni` file, or any Mach-O linking `libjvm.dylib` / `JavaVM.framework`, fails the build. macOS doesn't strip, because removing a file from a built `.app` breaks its signature.
  - **macOS has no dartjni today:** `jni 1.1.2` declares only linux, windows and android. The `.dmg` from run 44468227612 contains no file matching `jni` or `jvm`; its frameworks are App, FlutterMacOS, objective_c and sqlite3. That also confirms the brief's "sqlite3 is bundled" item for macOS.
  - **namcap:** dropped the `libjvm.so is an uninstalled dependency` acceptance from `package_arch.sh`. It's no longer needed and would hide a regression.
  - **RPM `__requires_exclude_from ^/opt/invoice-desk/.*$` is kept.** It was never specific to `libdartjni.so`. It keeps rpm's dependency scan away from the whole prebuilt bundle (ADR-0007). `__provides_exclude_from` hides the bundle's own libraries, so without it rpm would add `Requires` on `libflutter_linux_gtk.so` and friends that nothing provides. The real requirements are declared by hand in the spec.
  - **Smoke tests add a launch without `INVOICE_DESK_DATA_DIR`.**
    - Linux: every package, on a throwaway `HOME`/`XDG_*`. `path_provider_linux` uses `xdg.dataHome`, so a real `~/.local/share/me.omarmaarouf.invoice_desk` is never opened.
    - Windows (zip) and macOS: CI only (`CI=true`). The OS resolves the folder there, so it can't be redirected. The launch refuses to start if a database already exists there, and it removes the folder afterwards.
  - **Checked locally** (Fedora, `MAX_GLIBC=2.42 ./scripts/package_linux.sh --no-deb`, exit 0):
    - "no bundled binary needs a JVM";
    - `dartjni` matches 0 entries in both the tarball and the RPM;
    - the unstripped `build/linux/x64/release/bundle/lib/libdartjni.so` shows `(NEEDED) Shared library: [libjvm.so]`, so the guard's pattern matches what it should catch;
    - in `fedora:latest`: `smoke OK: invoice-desk-linux-x64.tar.gz (2 × 15 s: temp data dir, default data dir on a temp HOME)` (gtk3 pre-installed, standing in for the runner), and `smoke OK: invoice-desk.x86_64.rpm (…)`. The default data dir was `<temp HOME>/.local/share/me.omarmaarouf.invoice_desk`.
  - **Not checked locally:** the Windows and macOS changes (no `pwsh`, no macOS here), the `.deb` (no `dpkg-shlibdeps`) and the AppImage smoke.

- 2026-11-19 — **`install ubuntu:22.04` hung silently** (run 44471887698).
  - **What happened:** no output at all from `smoke_linux.sh`, not even the `dpkg -s` line, until the 20-minute job limit cancelled it. All apt output went to `/dev/null` with `-qq`, so the stall couldn't be seen.
  - **Fix:** every apt/dnf/pacman call now goes through `pm <limit> …`. It prints the command and its limit, runs it under `timeout` with no stdin, and appends the output to a log. On failure or timeout it prints the log in a `::group::` and names the call. Apt also gets `Acquire::Retries=3` and `Acquire::http::Timeout=30`. The install job is now `timeout-minutes: 10`, and the per-call limits (worst case on apt: 60 + 120 + 120 + 60 s, plus a 10 s kill grace each) stay below it, so a stalled call always prints its log before the job is killed.
  - **Reproduced locally, probable cause:** in `ubuntu:22.04` here, `apt-get update` stalled too.
    - The new failure path printed: `::error::timed out after 60 s: env DEBIAN_FRONTEND=noninteractive apt-get … update`. The log shows `security.ubuntu.com` complete, then `Ign:7 http://archive.ubuntu.com/ubuntu jammy-updates InRelease`, then nothing.
    - A bare `apt-get update` with a 300 s limit got as far as `Get:9 http://archive.ubuntu.com/ubuntu jammy/universe amd64 Packages [17.5 MB]` and was then killed (`rc=124`).
    - `curl` with a 20 s limit got 0 bytes from `archive.ubuntu.com` (91.189.91.83), and 3,721,312 bytes in 3.5 s from `security.ubuntu.com` (91.189.90.11).

    So Canonical's main archive was stalling from here at the same time as the CI hang. That's consistent with the CI symptom, but it's my network's view, not proof of what the runner saw. The next CI hang will now print its own log.
  - **Success path checked locally:** the CI RPM from this run, in `fedora:latest`: `dnf install` … `(limit 180 s)`, the package install `(limit 120 s)`, `dnf remove` `(limit 60 s)`, then `smoke OK: invoice-desk.x86_64.rpm (2 × 15 s: temp data dir, default data dir on a temp HOME)`.
  - **This run's Linux assets have no `dartjni`:** checked in the tarball, the RPM and the `.deb` (the `.deb` holds 9 libraries in `/opt/invoice-desk/lib`, none of them dartjni).

- 2026-11-19 — **`install ubuntu:22.04`: `archive.ubuntu.com` stalls, and apt carried on with an empty index** (re-run job 135394180551; owner ruling 2026-11-19).
  - **Cause confirmed in CI:** the re-run shows the connection failure to `archive.ubuntu.com`, then `Package 'xauth' has no installation candidate`. So `apt-get update` exited 0 despite the failed fetch, and the install found an empty index. That matches the local measurement in the previous finding.
  - **Fix:**
    - With `SMOKE_APT_MIRROR` set, `smoke_linux.sh` rewrites the `archive.ubuntu.com` lines (`jammy`, `jammy-updates`, `jammy-backports`) in `/etc/apt/sources.list` and prints the result. `security.ubuntu.com` stays.
    - `package.yml` sets `SMOKE_APT_MIRROR=http://azure.archive.ubuntu.com/ubuntu` for the `ubuntu:22.04` matrix entry only. Local runs and the other images keep their defaults. If the variable is set and the file has no `archive.ubuntu.com` line, the script fails rather than silently doing nothing.
    - `apt-get update` runs with `--error-on=any` (apt ≥ 2.1, so available in 22.04's apt 2.4.15).
  - **Update limit raised from 60 s to 90 s:**
    - The first local Azure run timed out at 60 s, after every index had started downloading.
    - Timed on its own, the same update finished in 22 s (`Fetched 49.5 MB in 22s (2247 kB/s)`, rc=0), so the limit was too tight for fetch-speed variance.
    - The new worst case on apt is 90 + 120 + 120 + 60 s plus a 10 s kill grace each, which still fits the 10-minute job.
  - **Checked locally:**
    - The CI `.deb` from run 44471887698 in `ubuntu:22.04`, with `SMOKE_APT_MIRROR=http://azure.archive.ubuntu.com/ubuntu`: the 7 rewritten Azure lines, the 3 security lines, `Status: install ok installed`, `smoke OK: invoice-desk_amd64.deb (2 × 15 s: temp data dir, default data dir on a temp HOME)`. Exit 0, 2 min 43 s in total.
    - `--error-on=any` with one unreachable source (`127.0.0.1:9`): `E: Failed to fetch …` and `rc=100`. The same update without the flag gives `rc=0`, which is how CI carried on with an empty index.
  - **Side effect, not yet seen in CI:** the tarball and AppImage smokes run `smoke_linux.sh` on the `ubuntu-22.04` runner itself, so the runner's `apt-get update` (its own mirror plus third-party repos) now fails on any fetch error too. Before, a broken third-party repo was ignored. If that turns out flaky, the fix is to limit the flag to the containers.

- 2026-11-19 — **The runner's own mirror stalled the AppImage smoke** (run 44478892261, owner instruction 2026-11-19).
  - **What happened:** `smoke_linux.sh` always ran `apt-get update` + `install`, even on the runner, where the job's "Build and packaging dependencies" step had already installed `xvfb` and `xauth`. This time `azure.archive.ubuntu.com` stalled (every InRelease `Ign`). `packages.microsoft.com` was a `Hit`, so it wasn't the `--error-on=any` side effect flagged earlier.
  - **Fix 1, the runner never touches the package manager:**
    - The script now checks for `xvfb-run`, `xauth`, `pgrep` and a Mesa DRI driver (`*/dri/*.so` under `/usr/lib` or `/usr/lib64`). If all are present it prints "no package-manager setup" and skips the block. Otherwise it names what is missing and installs it, which is what happens in the bare containers.
    - `package.yml`'s dependency step now also installs `libgl1-mesa-dri` and `procps`, so the check always passes on the runner.
  - **Fix 2, containers retry `apt-get update`:** `pm_retry 3 45` runs the whole update up to 3 times with a 45 s limit each, and logs `::warning::attempt n/3 …` between tries. The other limits were lowered so the worst case stays inside `timeout-minutes: 10`: apt deps 110 s, package 110 s, remove 45 s.
    - apt total: 3 × 55 + 120 + 120 + 55 = 460 s;
    - dnf/pacman total: 190 + 120 + 55 = 365 s;

    both including the 10 s kill grace.
  - **Checked locally** (packages from run 44471887698):
    - Runner-like: `ubuntu:22.04` with the display tools, gtk3 and EGL/GLES pre-installed, then `apt-get` and `dpkg` moved away so any package-manager call would fail. The tarball smoke printed "xvfb-run, xauth, pgrep and a Mesa DRI driver are present: no package-manager setup" and `smoke OK: invoice-desk-linux-x64.tar.gz (…)`.
    - Retry: `ubuntu:22.04` with one unreachable source. Three `::warning::attempt n/3 failed (exit 100)` lines, the log with the `E: Failed to fetch …` lines, then `::error::failed (exit 100): …`. Exit 1.
    - Containers: the `.deb` in `ubuntu:22.04` via Azure (2 min 54 s), the RPM in `fedora:latest` and the Arch package in `archlinux:latest`. All three printed "display setup needed (missing xvfb-run)" and then `smoke OK`.
  - **Still exposed at the time:** the job's own "Build and packaging dependencies" step ran `sudo apt-get update` with no limit and no retry. Open question 3, fixed in the next finding.

- 2026-11-19 — **The runner's dependency steps now have time limits and retries** (owner, answering open question 3).
  - **Helper:** new `scripts/apt_retry.sh <package>…`:
    - `apt-get update` up to 3 tries of 90 s each, with `::warning::apt-get update try n/3 …` after each failed try;
    - then `apt-get install -y` with a single 600 s limit;
    - both with `-o Acquire::Retries=3 -o Acquire::http::Timeout=30`.

    The limits can be changed with `APT_TRIES`, `APT_UPDATE_LIMIT` and `APT_INSTALL_LIMIT`. Output goes straight to the job log, and it uses sudo unless run as root. Both `package.yml` "Build and packaging dependencies" and `ci.yml` "Linux build dependencies" now call it. No bare `apt-get update` is left in the workflows.
  - **No `--error-on=any` here,** unlike the container smoke. The runner carries third-party repos, and the owner asked only for limits and retries. This means a refused fetch still exits 0 on the runner. A stall is caught by the time limit, and the follow-up `install` fails if the index is unusable.
  - **Checked locally (`ubuntu:22.04`, as root):**
    - stall, with a blackhole source (`10.255.255.1`) and `APT_UPDATE_LIMIT=5`: three `::warning::apt-get update try n/3 timed out after 5 s`, then `::error::apt-get update failed 3 times`. Exit 1, 15 s in total;
    - success via Azure: `xauth` and `procps` installed, exit 0;
    - install limit, with `APT_INSTALL_LIMIT=2` and `clang`: `::error::apt-get install timed out after 2 s`, exit 1.
  - **sudo path:** confirmed on the runner in run 44484076707.

- 2026-11-19 — **Slow mirrors stall `apt-get install`, not only `update`** (run 44484076707, owner instruction 2026-11-19).
  - **What happened:** in the container, the display-tools install stalled mid-download and used up its single 110 s try. On the runner, the dependency install took 6.5 min at 44 kB/s against a 600 s limit. That shows `apt_retry.sh` works under sudo on the runner, which was the open "not checked" item.
  - **Retrying the install as is would not have worked.** A local test retried `apt-get install` with 8 tries of 6 s each.
    - The downloads resumed (`Need to get 61.8 MB` → `47.6 MB/61.8 MB` → `43.4 MB/61.8 MB` → `7017 kB/61.8 MB`).
    - But the try that finished downloading was killed while dpkg was unpacking. Every later try then failed with `E: dpkg was interrupted, you must manually run 'dpkg --configure -a' to correct the problem.` (exit 100).
  - **Fix, in both helpers:** only `apt-get install -y --download-only …` is retried. That step is network-only, resumes from `/var/cache/apt/archives/partial`, and never runs dpkg. Then `apt-get install -y …` runs once from the cache, under its own limit.
    - `smoke_linux.sh` (containers): `apt_install` = download 3 × 100 s, then install 60 s, for both the display tools and the package. The install job is now `timeout-minutes: 20`. Worst case with apt: update 3 × 55 + (3 × 110 + 70) × 2 + remove 55 = 1020 s, which leaves about 180 s for checkout, the artifact download and the launches. dnf/pacman are unchanged at 365 s.
    - `apt_retry.sh` (runner): update 3 × 90 s, download 3 × 300 s (`APT_DOWNLOAD_LIMIT`), install once 300 s (`APT_INSTALL_LIMIT`). Worst case is about 26 min, inside the 40- and 45-minute jobs that call it. The last failed try now ends in `::error::` with its reason, instead of a `::warning::` followed by a generic error.
  - **Checked locally (`ubuntu:22.04`, Azure mirror):**
    - `apt_retry.sh` with `APT_TRIES=8 APT_DOWNLOAD_LIMIT=6`: four download tries timed out with a warning each, while the amount left to get fell to `7689 kB/61.8 MB`. Try 5 finished, then `install -y … try 1/1` reported `Need to get 0 B/61.8 MB of archives`. `xvfb-run` and `xauth` were installed, exit 0.
    - Full `.deb` smoke via Azure: download, then install, for the display tools and the local `.deb` (`--download-only` works with a `.deb` path), `Status: install ok installed`, `smoke OK: invoice-desk_amd64.deb (…)`. 2 min 47 s.

- 2026-11-19 — **`install ubuntu:22.04` is non-blocking; 6 download tries** (`main` CI run 44490378245, owner ruling 2026-11-19).
  - **What happened:** the download-only retry worked as designed. Each try resumed (`81.0 → 74.0 → 36.2 MB` left of 93.7 MB), but 3 tries weren't enough on a mirror that slow.
  - **Fix:**
    - **More tries:** `smoke_linux.sh` downloads with 6 tries of 90 s. Worst case with apt: update 3 × 55 + (6 × 100 + 70) × 2 + remove 55 = 1560 s. The install job goes from `timeout-minutes: 20` to 30 (1800 s), which leaves about 240 s for checkout, the artifact download and the launches.
    - **Non-blocking:** `package.yml` `linux-install` has `continue-on-error: ${{ matrix.image == 'ubuntu:22.04' }}`, so a mirror stall can't fail `package.yml` and therefore can't block `release.yml`. `debian:12` keeps covering the `.deb`.
    - **Warning:** on failure, a step limited to that entry emits `::warning title=install ubuntu%3A22.04 failed (non-blocking)::Most likely a stalled Ubuntu mirror (http://azure.archive.ubuntu.com/ubuntu) …`. The `:` in the title is escaped, as workflow-command properties require.
    - **`RELEASING.md`:** the install row of the §1 package table now marks `ubuntu:22.04` as non-blocking. A new §1 paragraph says how to check a red one by hand before tagging: a package-manager timeout or fetch error means re-run the job; an app failure is a release blocker. §4 step 6 points to it.
  - **Checked locally:** the full `.deb` smoke in `ubuntu:22.04` via Azure, with the download tries at `(limit 90 s)`: `smoke OK: invoice-desk_amd64.deb (…)`, 2 min 53 s. actionlint and shellcheck are clean.
  - **Not checked:** `continue-on-error`, and the warning step's `if: failure() && matrix.image == 'ubuntu:22.04'`. Both only run on GitHub.

- 2026-11-19 — **Phase 3 done** (reported by the owner).
  - **Green runs:** `main` CI run 44495539215 and the release dry run 44495540370 on `main` (see the Runs table).
  - **Old drafts:** the 4 draft releases v0.1.0–v0.4.0 that the old workflow made were deleted by the owner.
  - **Old tags:** `v0.2.0`, `v0.3.0` and `v0.4.0` were pushed with `release.yml` disabled. Re-enabling it right after the push still started three Release runs (44498581999, 44498582189, 44498584153). They were cancelled, and no drafts were created.
  - **RELEASING §3 step 4 now:** wait before re-enabling, then watch for about 60 s after enabling. While the workflow is disabled `gh run list` shows nothing, so the watch has to come after enabling, not before. If a run appears, cancel it and delete only draft releases, keeping the tags. Fixed in REL-03.

## Open questions

1. How should desktop bundles deal with `dartjni`? — Answered 2026-11-19: option (b), remove it after `flutter build` and guard on all three platforms (brief Decisions table).
2. Should the `ubuntu:22.04` container use another Ubuntu mirror? — Answered 2026-11-19: yes, `azure.archive.ubuntu.com` in CI only, with `security.ubuntu.com` kept (brief Decisions table).

3. Should the Linux job's own "Build and packaging dependencies" step get the same treatment? — Answered 2026-11-19: yes, in `package.yml` and `ci.yml`, through one helper (`scripts/apt_retry.sh`).

## Leftovers
- Upstream `jni` bug: `/DELAYLOAD:jvm.dll` targets the undefined `${TARGET_NAME}` instead of `jni`. Owner decides later whether to file it (ruling 2026-11-19).
