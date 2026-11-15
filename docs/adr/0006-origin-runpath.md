# 0006. Rewrite bundled RUNPATHs to $ORIGIN

- Status: accepted
- Date: 2026-11-15

## Context

Flutter's Linux build leaves absolute RUNPATHs in plugin libraries, pointing at the build machine's project folder and, for one library, `/usr/lib/jvm`. rpmlint flagged them, and they leak build paths and could load the wrong library on a user's machine.

## Decision

- `scripts/package_linux.sh` copies the bundle and rewrites RUNPATHs with `patchelf`: `$ORIGIN/lib` for the binary and `$ORIGIN` for `lib/*`.
- It then fails if any RUNPATH entry is not `$ORIGIN`-relative (`readelf -d` check).

## Consequences

- The tarball, AppImage and RPM are relocatable, and no build paths ship.
- Packaging needs `patchelf`.
- rpmlint still reports `binary-or-shlib-defines-rpath` for the `$ORIGIN` entries; that is accepted.
