# 0003. Money as integer minor units

- Status: accepted
- Date: 2026-11-15

## Context

Floating-point money accumulates rounding errors, and invoices and contracts must add up exactly. Documents mix currencies (EGP sections next to USD sections).

## Decision

- Store and compute amounts as `int` minor units (hundredths), and rates as basis points.
- Round half-up once, at the rate.
- `MoneyBag` keeps per-currency totals and never converts.
- Milestone shares use largest-remainder allocation.

## Consequences

- Totals are exact and testable. 100% of milestones always equals the total.
- Every input path parses to minor units (`parseMoneyInput`, which accepts Arabic-Indic digits), and every output path formats.
- Currencies with other minor-unit sizes (for example 3-digit dinars) would need a per-currency factor. The supported set all use two digits.
