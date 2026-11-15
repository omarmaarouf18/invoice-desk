# 0009. Free desktop app, paid end-to-end encrypted sync

- Status: accepted
- Date: 2026-11-15

## Context

The app will be distributed to other people, and it needs a sustainable business model that doesn't cripple the free product or require trusting a server with plaintext business data.

## Decision

- The desktop app stays free and fully functional forever. Nothing on the desktop is gated.
- The paid subscription is cross-platform, end-to-end encrypted cloud sync (desktop, mobile, later web).
- The code carries seams for it today:
  - `AccountService`, `LocalAccountService` → `localOnly`.
  - `SyncService`, `NoopSyncService`.
  - Sync-ready rows: UUIDs, `updated_at`, `rev`, tombstones, `device_id`, and an `outbox` written in the same transaction as each change.
- The encryption design is in ADR 0010.

## Consequences

- The desktop client could be open source (MIT) without undermining the business, because the paid value is the service. The licence decision is left to the owner.
- Every write path pays a small cost (an outbox row).
- Purge must keep unsynced tombstones once sync exists. A TODO and a placeholder test mark the spot.
