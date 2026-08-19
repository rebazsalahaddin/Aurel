# Handoff — A1-C02-L02

```yaml
lesson_id: A1-C02-L02
artifacts_delivered:
  A1_C02_L02_LESSON.md: 1/1             # 1,890 lines, full content, no truncation
  vocabulary_records: 9/9               # V010–V018 (5 contact words + at/dot + 2 What's-your chunks)
  pattern_system_records: 3/3           # PAT003 (6–10), PAT004 (11–15), PAT005 (16–20)
  grammar_records: 3/3                  # G004 Are you…? + short answers; G005 It's…; G006 imperatives
  practice_items: 50/50                 # PR-V021–036 (16) + PR-G001–030 (30) + PR-P001–004 (4);
                                        #   45 choice items rebalanced to 15 A / 15 B / 15 C
  audio_scripts: 37/37                  # AUD032–068 (story, 15 number models, 3 chants, 9 word/chunk
                                        #   models, 3 grammar models, 3 pron stimuli, 1 challenge take,
                                        #   2 blended)
  illustration_briefs: 10/10            # ILL015–024 with generation prompts; no letters/digits/@ in art
  screens_with_uiux_tips: 10/10         # S12–S21
targets_introduced: [A1-C02-L02-PAT003, A1-C02-L02-PAT004, A1-C02-L02-PAT005,
  A1-C02-L02-V010..V018, A1-C02-L02-G004, A1-C02-L02-G005, A1-C02-L02-G006]
targets_retrieved: [sorry (open item CLOSED — S12 frame 3), alphabet PAT001, numbers 0–5 PAT002,
  What's your name?, please, thank you, You're welcome (survival), hello, good morning,
  again, repeat, Can you repeat that please?, How do you spell that? (PR-G019 badge read),
  Sam Rivera name-check, Maya/Leo/Nina names]
story_state: "Leo delivered twenty cups for the classes (counted with Nina, 10+10). The register
  page now holds name row, digits row, message row (three dotted rows — ILL024). Grammar lives
  at the desk: Nina checks badges with Are you…?, details travel by It's…, and the five class
  words are now learner content. Fictional sample data fixed: Maya's phone 5-5-5, 2-0-1;
  Maya's email maya.haddad@aroa.com (spoken: maya dot haddad at aroa dot com); Leo's challenge
  number 9-7-2-4-1-6."
next_step: "Session 7 → A1-C02-L03 (C+R). Per manifest: check-in conversation package, BOTH
  versions (phone + email), 8–10 turns — greeting/name, badge check (Are you…? turn 3), spelling
  request, ONE repair turn, details (phone OR email per version), thanks, farewell; learning +
  fresh challenge takes; target-to-turn map; substitution table; branch map; comprehension
  testlets. 16 conversation items (CV001–016), 16 listening items (LS001–016, 3 testlets),
  8 reading items (RD001–008: form fields + message card), 2 tile-writing tasks (WR001–002:
  assemble the email; My phone number is…), 6 pronunciation items (PR-P005–010). Audio from
  AUD069; ILL from ILL025; screens S22–S31."
open_items: []                          # sorry-retrieval item CLOSED this session
id_positions:
  audio_block: A1-C02-AUD068 used, next A1-C02-AUD069
  ill_block: A1-C02-ILL024 used, next A1-C02-ILL025
  practice: next PR-CV001 / PR-LS001 / PR-P005 / WR001
  vocab: next V019+ (L3 introduces none — conversation chapter); grammar ledger fully clear for C2
```

Notes for the next session's agent:

1. Read `STATE.md`, `DECISIONS.md`, both ledgers, the character bible, audio style guide, and this file before writing anything (§1.3). Chapter brief = master prompt §9.2; plan = `A1_C02_MANIFEST.md`.
2. **Two dialogue versions required** (phone + email) — §9.2 says "Provide phone and email versions." Model them as one package: learning take (phone version) + challenge take (email version, fresh recording), plus testlet stimuli.
3. Listening ladder = 3 testlets (gist / detail / response), each 2–4 items sharing one stimulus with documented dependence (§10.0). Number strings in stimuli stay ≤6 digits in two 3-digit chunks; sample digits use the fixed fictional data above — verify character-by-digit.
4. Writing = tile assembly only (no typing): the email `maya.haddad@aroa.com` and `My phone number is 5-5-5, 2-0-1.` — symbols (@, .) are app-layer tiles, never art.
5. Grammar G004/G005 get their `conversation_turn_ids` filled by this lesson (badge check turn; details turns) — cite the turn IDs back into the grammar records' fields if you restate them in the package.
6. Answer-key discipline (learned this session): balance positions across choice items before delivering; a 31/12/2 skew fails the red-team lens.
7. Reminder: no `Good night` anywhere; nothing above 20; no real personal data; transcripts only after response.
