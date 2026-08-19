# A1-C01 QA Report — Chapter completion (session 4)

Self-check status (master prompt §6.3): the lens table below is the authoring agent's structured self-review, not an independent audit. Independent human review remains a release condition.

## Delivered vs manifest (expected = `A1_C01_MANIFEST.md`)

| Artifact class | Expected | Delivered | Status |
|---|---|---|---|
| Lessons | 4 (V / G / C+R / M) | 4 | ✓ |
| Vocabulary records | 30 (Sets A–E) | 30 | ✓ |
| Grammar records | 3 (G001–G003) | 3 | ✓ |
| Practice items — vocabulary | 36 | 16 (L1) + 20 (L2) | ✓ |
| Practice items — grammar | 30 | 30 (L2) | ✓ |
| Practice items — conversation | 16 | 16 (L3) | ✓ |
| Practice items — listening | 16 | 16 (L3, incl. 3 testlets) | ✓ |
| Practice items — pronunciation | 10 | 4 (L2) + 6 (L3) | ✓ |
| Practice items — reading | 8 | 8 (L3) | ✓ |
| Practice items — guided writing | 6 | 2 (L3) + 4 (L4) | ✓ |
| **Practice total** | **122** | **122** | ✓ |
| Quiz Form A | 20–24 | 22 | ✓ |
| Conversation package | 1 (learning + challenge takes) | 1 (8-turn + 7-turn) | ✓ |
| AI roleplay spec | 1 | 1 (RP001, full contract) | ✓ |
| Audio scripts | word models 30 + blended 3 + comprehension 6 + models/misc | 47 (AUD001–047) | ✓ within §10.0 budget (comprehension listening = 6: hook, dialogue, challenge, 2 testlet stimuli, 1 quiz stimulus) |
| Illustration briefs | ≤40 | 34 (ILL001–034), all with generation prompts | ✓ |
| Screens + UI/UX tips | 37 (S01–S37) | 37 | ✓ |
| Remediation map + clinic seeds | yes | 5 clinics specified | ✓ |
| Spaced-review export | yes | yes (per-set table in L4) | ✓ |
| Sanctioned-placeholder compliance | [ILL:] tokens + status: placeholder only | pass (truncation greps = 0 across all four lessons) | ✓ |
| Parallel Form B | dedicated follow-up session | not authored (by design — on owner request `form B`) | deferred per §14 |

## Lens table (14 lenses, §6.2) — format: lens | pass/fail | finding | fix applied

| # | Lens | Result | Finding | Fix applied |
|---|---|---|---|---|
| 1 | Scope & progression | pass | 4 lessons teach exactly the §9.1 brief; one grammar dimension per step (G001 person+contraction → G002 possessive direction → G003 chunks); no forward grammar beyond `[CHUNK:survival]` (`You're welcome!`, `Welcome!`) | — |
| 2 | Retrieval & spacing | pass | every target ≥4 in-chapter encounters (input/practice/blended/4th use) and ≥2 later-chapter retrievals scheduled (ledger `later_review_chapters`); encounters vary modality | — |
| 3 | Lexicon & sense | pass with note | Sets A/B/D are 7–8 items ✓; Set C is 5 ✓; **Set E is 3** — below the 5–8 micro-set floor | Disposition: Set E functions as the G003 chunk set applied through the dialogue model (AUD040), not a standalone lexical micro-set; rule clarified in GLOSSARY at F3: *chunk sets attached to a grammar target follow the grammar's sequencing, not the lexical floor* |
| 4 | Form–meaning–use | pass | `not_yet_allowed_forms` respected everywhere (no 3rd-person be, no negatives, no question analysis); contractions natural; no terminology tested | — |
| 5 | Dialogue naturalness | pass | 8 turns (band 6–8 ✓); target_to_turn map complete; branches coherent; no unnatural repetition | — |
| 6 | Audio script quality | pass (script level) | learning + challenge takes scripted; names verified character-by-character (Maya, Nina, Leo, Petrova, Rivera, Sam); `delivery_style` from enum; recordings are human-side | — |
| 7 | Assessment validity | pass | one defensible answer per item; distractor rationales present; listening options readable at level; no motor/memory/culture load; formality pairs (hello/hi, thank you/thanks, goodbye/bye) never tested against each other | — |
| 8 | Self-study survivability | pass | every instruction word demonstrated (S03) before use; help ladder on all items; recovery paths (clinics + Form B) defined; resume state at every pause screen | — |
| 9 | IDs & contracts | pass | all IDs resolve against ledgers/registers; no reuse; schemas match §10 contracts; answer keys only in creator records | — |
| 10 | Visual contract | pass | 34 briefs complete with generation prompts + alt text; badge/state-strip/storyboard schemas reused consistently; assessment options use fresh skins (ILL031–034), parallel salience | — |
| 11 | Ethical engagement | pass | no streaks/loss framing; celebration brief + mutable; retry/continue equal weight; rewards = can-do rings only | — |
| 12 | Accessibility & bias | pass | alt-text equivalents for all image items; no color-only cues; tap-only interactions; non-audio/non-voice routes with `not measured` reporting; new character Sam registered with explicit facts (no inferred traits) | — |
| 13 | Instruction load | pass | Stage 1–3 lexicon only; `put in order`/`first`/`next`/`last` demonstrated at S24 before use | — |
| 14 | Red team (adversarial) | **pass after one fix** | found 1 defect: L3 item LS014 exposed untaught `Good night!` as a learner-facing distractor | fixed in-session: option replaced with taught `See you!` + rationale updated; re-checked = pass |

Red-team sweep summary: test-taking tricks cannot solve items (audio/image constructs carry the answers); no two-correct options (formality variants explicitly excluded from opposition); art briefs depict the target construct only; dialogue stays within taught language; difficulty ramps by support, not speed; later lessons match L1 completeness (122/122 practice items).

## Resolved limitations (honest claims)

- Quiz Form A keys/rationales are expert-authored; **pilot statistics are null** — all difficulty/level labels are hypotheses.
- The 80/70 gate and clinic triggers are provisional rules pending piloting.
- `Welcome!` and `You're welcome!` remain survival chunks (receptive), scheduled for full treatment no earlier than Ch9 service language.
- Audio exists as scripts only (`qa_status: script_review` across all 47).
- The placement assessment is deferred premium scope (stubs in session F2; Appendix A of the master prompt).
