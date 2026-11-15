# Releasing

Releases are Linux x86_64 packages (tarball, AppImage, RPM) plus `SHA256SUMS.txt`, attached to a **draft** GitHub release. The owner publishes the draft by hand.

## 1. Prepare

1. **Branch from the integration branch.** Every gate in `scripts/ci_local.sh` must be green.
2. **Bump the version** in `pubspec.yaml`: `version: X.Y.Z+N`, where `N` goes up by one with every release.
3. **Bump `pkgversion`** in `packaging/rpm/invoice-desk.spec`, and add a `%changelog` entry there.
4. **Update `CHANGELOG.md`.** Move "Unreleased" under the new version with today's date.
5. **Update the file names** in the README's Install section.
6. **If the schema changed:**
   - Rehearse the upgrade (below).
   - Regenerate `docs/DATA_MODEL.md` (`dart run tool/gen_data_model.dart`) and add the version to its migration history.

## 2. Rehearse the upgrade (schema changes only)

Never on real data. Use a temporary data folder:

```bash
T=$(mktemp -d)
```

```bash
INVOICE_DESK_DATA_DIR=$T timeout 10 /opt/invoice-desk/invoice_desk
```

The installed previous release creates its schema in `$T`. Then build and open the same folder with the new release:

```bash
./scripts/package_linux.sh && tar xzf dist/invoice-desk-X.Y.Z-linux-x64.tar.gz -C $T
```

```bash
INVOICE_DESK_DATA_DIR=$T timeout 12 $T/invoice-desk-X.Y.Z-linux-x64/invoice_desk
```

```bash
sqlite3 "file:$T/invoice_desk.sqlite?mode=ro" 'PRAGMA user_version; PRAGMA foreign_key_check; PRAGMA integrity_check;'
```

Expect the new `user_version`, no FK problems, `ok`, and the old rows still present. Launch the new build a second time on the same folder and check nothing is seeded twice.

## 3. Build

```bash
./scripts/package_linux.sh
```

The script:
- builds the release bundle;
- rewrites RUNPATHs to `$ORIGIN` and fails on any absolute path;
- produces `dist/` with the tarball, AppImage, RPM and `SHA256SUMS.txt`.

It needs `patchelf`, `rpmbuild`, and network access for `appimagetool`. Then check the RPM:

```bash
rpmlint dist/invoice-desk-X.Y.Z-1.x86_64.rpm
```

These categories are expected and accepted (ADRs 0006 and 0007):
- `binary-or-shlib-defines-rpath` (`$ORIGIN` only)
- `dir-or-file-in-opt`
- `invalid-soname`
- `shared-library-not-executable`
- `unstripped-binary-or-object`

Anything new needs a look.

## 4. Tag and draft release

Pushing a `vX.Y.Z` tag runs `.github/workflows/release.yml`, which builds on Ubuntu and creates a draft release. If Actions is unavailable, create the draft by hand from the local `dist/`:

```bash
gh release create vX.Y.Z --draft --target <branch> --title "Invoice Desk X.Y.Z" --notes-file notes.md dist/*.rpm dist/*.tar.gz dist/*.AppImage dist/SHA256SUMS.txt
```

Verify the upload:

```bash
gh release download vX.Y.Z -D /tmp/check && (cd /tmp/check && sha256sum -c SHA256SUMS.txt)
```

## 5. Install test

```bash
sudo dnf install ./dist/invoice-desk-X.Y.Z-1.x86_64.rpm
```

```bash
rpm -V invoice-desk
```

Then launch it on a temporary data folder (`INVOICE_DESK_DATA_DIR`) and check that `dnf remove` leaves `~/.local/share/me.omarmaarouf.invoice_desk` alone.

## Rollback

- **App.** Install the previous RPM with `sudo dnf downgrade ./invoice-desk-PREV-1.x86_64.rpm`, or run the previous AppImage or tarball.
- **Data.** An older app can't open a newer schema. To go back after a schema migration, restore a backup made by the older version: Settings → النسخ الاحتياطي → استعادة. Pick one of the dated daily backups in `backups/` from before the upgrade. Restore keeps a safety copy of the current data first.
