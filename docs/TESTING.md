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
| `test/pdf/` | PDF smoke tests (page counts, footer on every page, amber highlights, watermark), content goldens in `test/pdf/goldens/`, and the RTL word-gap measurement |
| `test/ui/` | Widget flows through the real shell (`pumpShell`) and goldens |
| `test/architecture/` | The layering rule, and the guard for the vendored `pdf` package (`third_party/pdf`) |
| `test/helpers/` | `harness.dart` (fonts, `pumpShell`, `drive`, `settle`), `contract_fixtures.dart` and `sample_documents.dart` (fake "Sample Studio" / "Acme Studio" data), `pdf_golden.dart` |

Widget tests run in a fake-async zone and drift does real I/O. Await database work with `drive(tester, () => …)` and let streams settle with `settle(tester)`. Pass a fixed `Clock` through `clockProvider` (the harness does) rather than `withClock`: repositories and the backup service use the injected clock.

## Tags

- `golden`: pixel comparisons against the PNGs in `test/ui/goldens/` and `docs/screenshot.png`. They depend on font rendering, so CI runs them in their own job on a pinned runner. PDF goldens (`test/pdf/pdf_goldens_test.dart`) share the tag. They compare the inflated page content streams (every glyph run and position) as text, so they don't depend on a rasteriser.
- `rtl`: the right-to-left PDF checks that guard the vendored `pdf` patch. Run them alone with `--tags rtl`.

Run the suite without them with `--exclude-tags golden`, or only them with `--tags golden`.

## Updating goldens on purpose

A golden should only change because the UI changed on purpose.

1. Run the golden tests. Failures write diffs to `test/ui/failures/` (git-ignored).
2. Look at `*_isolatedDiff.png` and `*_testImage.png` and confirm the change is the intended one, in the intended region.
3. Re-run with `--update-goldens`.
4. Say in the commit message what changed visually and why.

PDF goldens are `.txt` dumps, so the diff shows which runs moved. Render the documents too and look at every page:

```bash
flutter test --tags golden --dart-define=SAMPLE_PDF_DIR=docs
```

That writes `docs/sample-invoice.pdf`, `docs/sample-invoice-scope.pdf` and `docs/sample-contract.pdf`, all from fictional data.

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
