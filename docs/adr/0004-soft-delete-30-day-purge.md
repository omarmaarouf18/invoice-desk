# 0004. Soft delete with a 30-day purge

- Status: accepted
- Date: 2026-11-15

## Context

People delete the wrong thing. Sent and paid invoices must never be orphaned or silently lost, and a future sync engine needs tombstones.

## Decision

- Deleting sets `deleted_at`. Rows deleted together share the stamp, so Undo and "المحذوفات" restore exactly that batch.
- Triggers forbid a live document under a deleted client. `ON DELETE RESTRICT` forbids hard-deleting a client that has document rows.
- Start-up housekeeping hard-deletes rows deleted more than 30 days ago.
- Permanent deletes need a typed confirmation and write a backup first.
- A client with documents is archived by default instead of deleted.

## Consequences

- Mistakes are recoverable for 30 days, and permanent deletes have a backup.
- Queries must filter `deleted_at IS NULL`; repositories do this.
- Once sync exists, the purge must keep tombstones that haven't been synced (see ADR 0009).
