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
  - **Status:** stopped per brief §6, since a hard import means a dependency decision. Not fixed. Open question 1.

## Open questions

1. How should desktop bundles deal with `dartjni` (hard-imports `jvm.dll` / `libjvm.so`, never loaded on desktop)? — Options:
   - (a) Build without a visible JDK, so CMake's `find_package(JNI)` fails and `jni` bundles nothing. That's what a machine without Java produces. Packaging-only, but it depends on how FindJNI searches on each runner (`JAVA_HOME`, PATH, registry on Windows).
   - (b) Delete `dartjni.dll` / `libdartjni.so` from the bundle after `flutter build`, in the package scripts. The smoke tests prove the app starts without it.
   - (c) Allowlist `dartjni.dll -> jvm.dll` in the DLL check and ship it as is.
   - (d) Dependency route (pin or override `path_provider`/`jni`): out of scope (brief §6/§7).

   Recommended: (b). It's deterministic on every runner and dev box, it removes a library that can't load from all six Linux/Windows assets, and the existing smoke tests already prove startup. Any desktop code path that ever reached `jni` would fail anyway, because there is no JVM. Status: open.

## Leftovers
- Upstream `jni` bug: `/DELAYLOAD:jvm.dll` targets the undefined `${TARGET_NAME}` instead of `jni`. Worth an upstream issue (owner's call; it's a public post).
