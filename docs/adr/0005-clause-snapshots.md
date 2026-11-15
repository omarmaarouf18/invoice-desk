# 0005. Contracts snapshot their clauses

- Status: accepted
- Date: 2026-11-15

## Context

Clause wording in the library will be reviewed by a lawyer and edited over time. A contract that was sent or signed must keep the text the parties saw.

## Decision

- Creating a contract copies every clause (title, body, flags) into the contract, keeping `from_library_clause_id` as a plain reference (not a foreign key).
- Variables stay as `{{name}}` in the stored text and are resolved only when rendering.
- "استرجاع النص من المكتبة" and "حفظ في المكتبة" are explicit, confirmed actions; the restore shows a diff.

## Consequences

- Library edits never change existing contracts.
- Contracts are self-contained and render the same years later.
- Fixing a clause across many contracts is manual, one contract at a time, by design.
