# 0008. Offline-first, local data is the source of truth

- Status: accepted
- Date: 2026-11-15

## Context

Freelancers invoice from anywhere. Their documents contain client data and amounts that they may not want on someone else's server. The app must be fully useful with no account and no network.

## Decision

- The local SQLite database is the source of truth.
- Every feature, including export, backup and restore, works offline.
- No network calls exist in the app today.
- Future sync is an add-on that reads an outbox and must never block local use (ADR 0009).

## Consequences

- No accounts, servers or outages are needed to use the app.
- Backups are the user's responsibility; the app makes them automatic and local.
- Multi-device use waits for sync.
