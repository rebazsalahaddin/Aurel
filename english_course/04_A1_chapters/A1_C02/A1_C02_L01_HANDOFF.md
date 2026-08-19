# Handoff — A1-C02-L01

```yaml
lesson_id: A1-C02-L01
artifacts_delivered:
  A1_C02_MANIFEST.md: 1/1               # 4-lesson map, closed per-lesson manifests, 39 screens, quiz/gate + cumulative rule
  A1_C02_L01_LESSON.md: 1/1             # 1,270 lines, full content, no truncation
  vocabulary_records: 9/9               # V001–V009: spell, repeat, slow, again, listen, say + 3 repair chunks
  pattern_system_records: 2/2           # PAT001 alphabet A–Z (4 families); PAT002 numbers 0–5
  practice_items: 20/20                 # PR-V001–020 (19 choice + 1 supported-recording speak)
  audio_scripts: 31/31                  # AUD001–031 (hook, 6 word models, 3 chunk models, 4 families,
                                        #   8 isolated letters, 4 isolated numbers, chant, spelling chain, 3 blended)
  illustration_briefs: 14/14            # ILL001–014, all with generation prompts; no letters/numerals in art
  screens_with_uiux_tips: 11/11         # S01–S11
targets_introduced: [A1-C02-L01-PAT001, A1-C02-L01-PAT002, A1-C02-L01-V001..V009]
targets_retrieved_ch1: [hello, good morning, What's your name?, My name is…, I'm…, I'm good,
  thank you, please, yes/no, name, first name, How are you?, Welcome! (survival chunk)]
  # 'sorry' (A1-C01-L01-V012) is scheduled for Ch2 in the ledger but was NOT retrieved in L1 —
  # the L02 warm-up must include one 'sorry' encounter (open item below).
story_state: "The morning after the welcome event, Nina runs the Community House check-in desk.
  The learner registers for community classes; Maya registers at the same desk. The chapter
  question 'How do you spell that?' is planted in the hook (AUD001) and taught at S09.
  Learner can now: say letter names in 4 families, discriminate B/D and M/N, count 0–5,
  and use the three repair chunks."
next_step: "Session 6 → A1-C02-L02 (V+G). Per manifest: numbers 6–10/11–15/16–20 (PAT003–005,
  15 new number models), contact words (phone, phone number, email, email address, address),
  at/dot, chunks What's your phone number?/What's your email address?/It's…; grammar G004
  (Are you…? + short answers), G005 (It's for letters/numbers/details), G006 (demonstrated
  imperatives record). Practice: PR-V021–036 (16 V) + PR-G001–030 (30 G) + PR-P001–004 (4 P).
  Audio continues at AUD032; ILL at ILL015. Screens S12–S21. Warm-up MUST retrieve: alphabet
  families + 0–5 + one 'sorry' item (see note above)."
open_items:
  - "'sorry' (A1-C01-L01-V012) ledger lists Ch2 retrieval — schedule one encounter in L02 warm-up"
  - "Set C2-B is a 3-item chunk set (attached-set ruling, as C1 Set E) — recorded for lens 3 at chapter QA"
id_positions:
  audio_block: A1-C02-AUD031 used, next A1-C02-AUD032
  ill_block: A1-C02-ILL014 used, next A1-C02-ILL015
  practice: PR-V020 used, next PR-V021 / PR-G001
  vocab: V009 used; L02 starts V010; PAT003–005 activate
```

Notes for the next session's agent:

1. Read `STATE.md`, `DECISIONS.md`, both ledgers, the character bible, audio style guide, and this file before writing anything (§1.3). Chapter brief = master prompt §9.2; chapter plan = `A1_C02_MANIFEST.md`.
2. **Do not create letter-per-card vocabulary records.** The alphabet is and remains ONE pattern-system row (PAT001). L2 adds number ranges the same way — one row per range.
3. `-teen` awareness in L2 pronunciation is receptive only: number words end in different final sounds; NEVER name a `-ty` word (C5 scope, §9.2 v2 fix).
4. G004–G006 are Ch2's grammar targets (ledger scheduled rows) — check `not_yet_allowed_forms` before authoring practice (no 3rd person, no is/are questions beyond Are you…?).
5. Every contact detail in L2+ is fictional (`maya.haddad@aroa-mail.com` style); never request real personal data; no required typing (tile assembly only).
6. Quiz cumulative rule reminder for L4: 4–7 of the 24–30 quiz items retrieve Chapter 1 targets (ledger `later_review_chapters` is the source).
