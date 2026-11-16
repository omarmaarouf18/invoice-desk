# 0011. Document language model

- Status: accepted (defaults D1–D8 not yet confirmed by the owner)
- Date: 2026-11-16

## Context

Invoice Desk had one language per layer, hard-wired. The UI was Arabic. Invoices were English with small Arabic secondaries, and their scope page was Arabic. Contracts and the payment reminder were Arabic (the reminder was Arabic plus English). Freelancers who invoice in both languages need to pick the language of each document independently of the language they use the app in. An English-speaking user may send an Arabic invoice, and the reverse.

## Decision

- **Two independent languages.** The *UI language* is a per-machine preference: `UiLanguage { system, ar, en }` in UiPrefs (D8). The *document language* belongs to each document: `DocLanguage { ar, en, bilingual }` in `lib/domain/doc_language.dart`. Neither one is derived from the other.
- **Values.**
  - `ar` is a full right-to-left page.
  - `en` is left-to-right.
  - `bilingual` is today's invoice: English layout with Arabic secondary labels.
  - Contracts support `ar` and `en` only (D2); a bilingual contract would need two parallel columns.
- **Resolution (D7).** A new document starts in the document's own choice, else the client's preferred language, else the global default (`ar`): `resolveDocLanguage`. Existing invoices get `bilingual` when the column is added, so they keep their look.
- **Where text comes from.**
  - UI strings stay in ARB files (`app_ar.arb` is the template).
  - Document text never goes through ARB, because it must not follow the UI locale. Fixed PDF labels live in a pure-Dart table, `lib/pdf/labels.dart` (`DocLabels.of(lang)`). Formatted values live in `lib/domain/doc_format.dart`:
    - `formatDocDate`, `formatDocDayMonth` and `formatDocMonthYear`;
    - `clauseHeading` (`البند الأول` / `Article 1`);
    - `currencyName` and `formatDocMoney`;
    - `applyDigitStyle`.
  - Domain functions that produce document text take a `DocLanguage`: `defaultMilestones`, `paymentReminderMessage`, `VariableResolver.language` and `contractHeading`.
- **Digits (D6).** `DigitStyle { western, arabicIndic }` applies to Arabic document text only; English text always uses Western digits. The default for new documents is Western. The existing `contractWesternDigits` setting migrates into it, so existing contracts keep their digits.
- **Line items (D1)** stay one field, written in the document's language. Bilingual invoices keep their bilingual section titles and notes.
- **Unknown values.** Unknown or damaged stored values fall back instead of throwing (`DocLanguage.fromCode`, `DigitStyle.fromCode`, `UiLanguage.fromName`).
- **The UI locale.** `localeProvider` resolves the choice against the locales that have translations. Choosing English before `app_en.arb` exists safely stays Arabic, and so does a system locale the app doesn't support.

## Consequences

- Switching the UI language never changes a document, and a document's language never depends on the machine it is opened on.
- Every builder and formatter takes a language explicitly. A forgotten parameter defaults to today's output (Arabic for contracts and resolver values, bilingual for the reminder), so nothing changes until the language is stored (schema v6).
- Two places hold translations (ARB for the UI, `DocLabels` for documents). The duplication is deliberate: the two sets differ in tone (UI microcopy versus formal document wording) and in lifecycle.
- English contract wording is a translation of the Arabic seed. It is marked "draft wording — have it reviewed by a lawyer" until reviewed.
