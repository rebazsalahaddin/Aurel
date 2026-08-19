# A1-C04 QA Report — Chapter 4 wrap-up (self-check, §6.3)

Scope: A1-C04-L01…L03 + manifest + Checkpoint 1 (A1-CP1-*). Sources: the three lesson files, both ledgers, the bible, the audio guide, the register, the handoffs. This is the authoring agent's self-review; independent human review remains a release condition.

## Delivered vs. manifest

| artifact family | manifest | delivered | status |
|---|---|---|---|
| lessons | 3 | 3 (L01 878 ln · L02 1,246 ln · L03 1,268 ln) | ✓ |
| new lexical/grammar records | 0 | **0 — verified across all three lessons** | ✓ (review chapter) |
| retrieval items | 16 | 16 (RT001–016; 8 Ch1+Ch2 + 8 Ch3) | ✓ |
| clinics | 2 (6–10 items each) | 2 (CL1-001–008 be-agreement; CL2-001–008 from-vs-a/an; exits + routing) | ✓ |
| diagnostic recap | 3 | 3 (RC001–003, unscored) | ✓ |
| conversation package | 1 | 1 (A1-C04-D01, 2 takes, 5 voices, target-to-turn map) | ✓ |
| listening | 6 | 6 (LS001–006: gist 2 · detail 2 · speaker 1 · transfer 1; testlet declared) | ✓ |
| reading | 6 | 6 (RD001–006; sign-in sheet + profile card — 2 text types) | ✓ |
| guided writing | 4 | 4 (WR001–004; WR001 = three-sentence tile introduction) | ✓ |
| conversation prep | 6 | 6 (CV001–006) | ✓ |
| roleplay | 1 | 1 (A1-C04-RP001: 8-turn cap, 5 required slots, guardrails, N1–N5 alternative) | ✓ |
| Checkpoint 1 | 46 + 2 tile + 1 SM | 45 choice + G012 tile + W001–002 + SM01 (dual path) + 3 recordings | ✓ |
| alternate short form | 15 | 15 (A1-CP1-B001–015 + own recording CP-AUD004) | ✓ |
| parallel pool | 12 | 12 (A1-CP1-P001–012 + regeneration rule, owner-flagged) | ✓ |
| audio scripts | ≈45 plan | **53 chapter (AUD001–053) + 4 checkpoint recordings** | ✓ exceeds |
| illustration briefs | 16 | **16/16 — block complete** | ✓ |
| screens | 28 | 28 (S01–S09 · S10–S19 · S20–S28) | ✓ |

Practice-bank note: §10.2's 122-item minimum is scoped to **new-language** chapters; §9.4 defines the review shape. C4 totals: 61 practice items + 73 assessment items (46 checkpoint + 15 B-form + 12 pool) = **134 authored interactions, all retrieval** — no new core language anywhere.

## Fourteen-lens table

| lens | verdict | finding / fix |
|---|---|---|
| 1 dependency & sequencing | pass | zero new targets (verified); every item/turn cites taught prerequisites via `target_ids`/`reviews`; recombination ruling (manifest 1) prevented silent scope growth |
| 2 pedagogical soundness | pass | review flow per §9.4: recap → retrieval (split) → clinics → integrated listening → form/profile reading → tile intro → rehearsal → roleplay → checkpoint; clinics follow model→perception→choice→tile→transfer with exit criteria |
| 3 micro-set & pattern policy | pass | no new micro-sets or pattern systems; seven rulings documented (manifest) incl. the two owner-note resolutions |
| 4 assessment integrity | pass | checkpoint independent (3 declared recordings; no D01/practice/roleplay stimulus reuse — the two practice-audio re-performances for CN001/CN003 are declared); testlets declared (LS on D01); gate arithmetic verified (47 points; 80% = 38; per-component floors); B-form conversion rule stated |
| 5 audio integrity | pass | scripts only, `script_review`; 53 + 4 scripts; challenge takes are fresh recordings; cross-references to canon audio flagged, not re-recorded |
| 6 anti-hallucination & grounding | pass | newcomers (Amara, Rafael) and every C4 story fact registered in the bible BEFORE use; all contact data is registered fiction; no citations or statistics anywhere |
| 7 test construction | pass-after-fix | balance discipline held: L1 5/6/5 (16), L2 10/10/11 (31), L3 15/15/15 (45) + B-form 5/5/5 — four skews or claim-mismatches caught and fixed in-session (L1 claim correction; L3 15/17/13 → 15/15/15; N-nodes 4/1/0 → 1/2/2; B-form 15/0/0 → 5/5/5) |
| 8 inclusion & representation | pass | singular they maintained (Alex never a singular be-referent; G007 cite); newcomer pronouns fixed in the bible, never inferred from names; gender-varied job art; ten-country spread retained |
| 9 sensitive-content safety | pass | origins voluntary everywhere (hook, roleplay guardrails, SM01); no immigration/status language; `Good night` absent from every option set incl. N-nodes; no numbers >20; no alcohol/gambling/politics/religion/dating |
| 10 character & world continuity | pass | bible-first held 100%: 2 newcomer figures + 12 known-facts rows added before use; ILL016 finale matches cast + newcomers; map-wall dot count consistent (6) across ILL001/ILL007/ILL016 |
| 11 accessibility & UI/UX | pass | 28 screens with tips; WCAG-AA; ≥44 pt; no color-only meaning (star states pair with icons/labels); reduced-motion variants; no countdown or shame framing on the checkpoint |
| 12 no-required-typing & interaction | pass | all interactions tap/order/record; WR/CP skip paths; SM01 dual path (voice OR tap, equal completion); latency, replays, hints never scored |
| 13 instruction-lexicon discipline | pass | stages 1–4 only; "sort" never used; "record/play" legal since C3-L2 and icon-cued; B-form/P-pool introduce no new instruction words |
| 14 red team | pass-after-fix | **16 recorded in-session catches, all fixed before gates**: L1 — draft block in RC002, self-correcting aside, audio-ID drift (renumbered to chapter-continuous block), balance claim corrected in three files, missing CL1-001 formal record, typo; L2 — numbering gap (AUD035), two-way draft replay line, stale cross-reference; L3 — V006 key/value mismatch, V008 mixed-modality stimulus, G005/G006 correction-trail artifacts, LS004 semantic key error (high sun ≠ morning), B-form all-A keys + unresolved note, P-pool skew, closing-audit mismatch (self-check claimed what the file didn't have) |

## Known limitations (honest record)

- Audio is scripts only; no recordings or pilot data exist; `pilot_stats` remain null by design.
- The A1-C04 ILL block is complete (16/16): no spare C4 art exists; any future C4 clinic art needs a new allocation.
- The P-pool is text/visual only (one B-form recording exists; the pool has none) — declared, not cut.
- The P-pool regeneration rule (canon-template item generation beyond the 12 authored items) is **flagged for owner ratification** before any generated item ships.
- The C3 owner note on the N-section-as-cumulative ruling remains open — C4 did not resolve it (C4's checkpoint subsumes its own cumulative rule; the ruling still needs a decision for future chapter quizzes).
- The "Form B on request" debt for C1–C3 chapter quizzes stands (C4's B-form is delivered; C1–C3 forms would be dedicated sessions).
- Retry evidence beyond the authored pool + B-form depends on the regeneration rule above.

## Chapter completion table entry

A1-C04 | 3/3 lessons | 0 new targets (review) · 61 practice + 134 authored interactions | Checkpoint 1 ✓ (45 choice + 2 tiles + SM01; gate 80/70; B-form 15; pool 12) | roleplay RP001 ✓ | ILL 16/16 block complete | audio 53 + 4 | lenses: 12 pass · 2 pass-after-fix (7, 14)
