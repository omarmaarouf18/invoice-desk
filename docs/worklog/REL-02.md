# REL-02 — Package matrix green

**Brief:** docs/briefs/2026-11-19-release-green.md, Phase 2 · **Branch:** feat/release-green

## Runs

| Run | Commit | Linux | Windows | macOS | Notes |
|---|---|---|---|---|---|
| 44468227612 | `5deb348` | ❌ rpmlint | ❌ DLL check | ✅ | arch + install matrix skipped (they need the Linux job) |

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

## Open questions

1. How should desktop bundles deal with `dartjni`? — Answered 2026-11-19: option (b), remove it after `flutter build` and guard on all three platforms (brief Decisions table).

## Leftovers
- Upstream `jni` bug: `/DELAYLOAD:jvm.dll` targets the undefined `${TARGET_NAME}` instead of `jni`. Owner decides later whether to file it (ruling 2026-11-19).
