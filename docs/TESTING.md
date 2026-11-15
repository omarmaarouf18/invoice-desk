# Testing

Run everything the way CI does:

```bash
./scripts/ci_local.sh
```

## Layout

| Folder | What |
|---|---|
| `test/core/`, `test/domain/` | Pure logic: money, dates, totals, numbering, variables, milestones, diff |
| `test/data/` | Repositories and DAOs on in-memory drift (`AppDatabase.memory()`): deletes, trash, backups, restore of older backups, outbox |
| `test/drift/app_db/` | Migration tests against the committed snapshots (generated helpers in `generated/`) |
| `test/pdf/` | PDF smoke tests: page counts, footer on every page, amber highlights, watermark |
| `test/ui/` | Widget flows through the real shell (`pumpShell`) and goldens |
| `test/architecture/` | The layering rule |
| `test/helpers/` | `harness.dart` (fonts, `pumpShell`, `drive`, `settle`) and `contract_fixtures.dart` (fake "Acme Studio" data) |

Widget tests run in a fake-async zone and drift does real I/O. Await database work with `drive(tester, () => …)` and let streams settle with `settle(tester)`. Pass a fixed `Clock` through `clockProvider` (the harness does) rather than `withClock`: repositories and the backup service use the injected clock.

## Tags

- `golden`: pixel comparisons against the PNGs in `test/ui/goldens/` and `docs/screenshot.png`. They depend on font rendering, so CI runs them in their own job on a pinned runner.

Run the suite without them with `--exclude-tags golden`, or only them with `--tags golden`.

## Updating goldens on purpose

A golden should only change because the UI changed on purpose.

1. Run the golden tests. Failures write diffs to `test/ui/failures/` (git-ignored).
2. Look at `*_isolatedDiff.png` and `*_testImage.png` and confirm the change is the intended one, in the intended region.
3. Re-run with `--update-goldens`.
4. Say in the commit message what changed visually and why.

Refactors must not change goldens. If one does, find out why before updating it.

## Migration tests

A schema change takes these steps:

1. Run `dart run drift_dev make-migrations` after bumping `schemaVersion`. It adds the snapshot and the test helpers.
2. Add a data test to `test/drift/app_db/migration_test.dart`: insert rows into the old schema (`verifier.schemaAt(n).rawDatabase`), migrate, and check the rows, new defaults, triggers and seeds.
3. Add the old version to `test/data/backup_compat_test.dart` so its backups still restore.

## Rehearsing an upgrade

Tests use in-memory snapshots. Before a release with a schema change, also rehearse on a real file created by the previously **installed** release, in a temporary data folder. The steps are in [RELEASING.md](RELEASING.md#2-rehearse-the-upgrade-schema-changes-only). Never use the real data folder for this.

## Coverage

`scripts/ci_local.sh` runs the suite with `--coverage` and prints coverage per layer from `coverage/lcov.info`. It fails if `lib/core`, `lib/domain`, or the money, numbering or migration code drops below 90%.
