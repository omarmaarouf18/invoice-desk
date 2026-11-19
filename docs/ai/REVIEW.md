# Review checklist (for the Reviewer)

Run this on every Builder report before the owner says "go". Check the claims against the repo; never trust the report alone.

## 1. Repo state

- [ ] `git status --short` is clean, and `git log --oneline <base>..HEAD` matches the commits the report lists.
- [ ] Commit messages follow `docs/ai/WORKFLOW.md` §4. Golden re-baselines are in their own commits, with a reason.
- [ ] Nothing that shouldn't be there was committed: agent scratch, databases, real names or phones, generated files the gate doesn't expect.

## 2. Gate

- [ ] The report pastes the literal gate summary, and every SKIP is explained.
- [ ] If anything looks off, re-run the targeted tests yourself.

## 3. Behaviour (look, don't read)

- [ ] Open every new or changed golden PNG. Check both directions, light and dark when relevant:
  - truncation from the wrong end;
  - mixed Arabic/English runs;
  - plurals («1 invoices»);
  - overflow;
  - icons pointing the wrong way.
- [ ] Open every regenerated sample PDF. Check:
  - Arabic word spacing;
  - page breaks (no heading orphaned at a page end);
  - digits and dates in the document's language;
  - nothing empty or placeholder-like printed.
- [ ] Existing documents look identical unless the brief says otherwise.

## 4. Copy

- [ ] Read the new user-facing Arabic and English strings: natural wording, consistent terms, ICU plurals for counts.
- [ ] «Template» means clause templates only; visual styles are «تصميم المستند» / Document style.

## 5. Rules (AGENTS.md §3)

- [ ] Layers are respected: the UI doesn't use drift, and domain/core don't import Flutter.
- [ ] Schema changes follow the migration ritual. Backup compatibility is still tested.
- [ ] No new network, telemetry or heavy dependency. Fonts are bundled with their licence.
- [ ] Sizes are within limits. No `DateTime.now()`.

## 6. Output to the owner

Write in English (`AGENTS.md` §6):

1. Verdict: approve, or approve with fixes.
2. What you checked yourself.
3. Problems found, most important first, each with the evidence (file or screenshot).
4. Answers to the Builder's open questions, with a recommendation each.
5. A paste-ready English reply for the Builder: the fixes first, then the answers, then "commit, gate, continue to …".
