# 0002. drift + SQLite for local storage

- Status: accepted
- Date: 2026-11-15

## Context

All data is local. Invoices, contracts and their parts are relational, need transactions and constraints, and must survive app crashes. The schema will evolve, and users' data must migrate safely.

## Decision

Use SQLite through drift.
- The schema is in Dart, with STRICT tables, CHECK constraints, foreign keys and triggers (in a `.drift` file).
- WAL journaling with `synchronous = FULL`.
- Step-by-step migrations, with committed schema snapshots and generated migration tests.

## Consequences

- One file is the whole state, so backups are trivial and safe (`VACUUM INTO`).
- Invariants live in the database, not just the UI: unique numbers, no orphans, guard triggers.
- Code generation (`build_runner`) is part of the workflow, and CI checks it is fresh.
- Drift shares watch streams by SQL text, so each aggregate's watch query must differ. This caused a real bug, now covered by a test.
