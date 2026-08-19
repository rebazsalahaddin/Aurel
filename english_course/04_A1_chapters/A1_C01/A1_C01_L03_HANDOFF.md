# Handoff — A1-C01-L03

```yaml
lesson_id: A1-C01-L03
artifacts_delivered:
  A1_C01_L03_LESSON.md: 1/1
  conversation_package: 1/1          # A1-C01-D01: 8-turn learning take + 7-turn challenge take, target_to_turn
                                     # map, substitution table, branch map, coverage matrix, roleplay seed
  practice_items: 48/48              # CV001–016 (16 conversation) + LS001–016 (16 listening, 3 testlets)
                                     # + P005–P010 (6 pronunciation) + RD001–008 (8 reading) + WR001–002 (2 writing)
  audio_scripts: 4/4                 # AUD043 learning take · AUD044 line models · AUD045 challenge · AUD046 detail testlet
  illustration_briefs: 8/8           # A1-C01-ILL023–ILL030 (5 storyboard panels, challenge scene, badge pair, welcome card)
  screens_with_uiux_tips: 10/10      # S20–S29
targets_introduced: []               # application lesson — no new targets
targets_retrieved: [V001–V030, G001–G003 — encounter #4 via dialogue + ladder + practice]
story_state: "Nina and Maya have met for the first time at the welcome table (model dialogue);
  later, Maya and Leo meet at the café terrace in the afternoon (challenge take). The learner
  has now heard, used, read, and written the full Chapter 1 repertoire — the mission and quiz remain."
next_step: "Lesson A1-C01-L04 (type M, assembly steps 13–15 + chapter wrap-up). Screens S30–S37.
  Deliver: (1) AI roleplay spec A1-C01-RP001 in full (scenario: you arrive at the welcome table,
  Maya greets — learner gives own name via voice or tiles, asks Maya's name, one How-are-you?
  exchange, polite close; turn_limit 8; §10.9 contract fields); (2) mission brief S30; (3) mixed
  quiz Form A — 22 items (vocabulary 6, grammar 6, listening 4, reading 2, discourse 2, guided
  writing 2; 4–5 cumulative items drawn from L01–L03 targets; gate 80% overall / ≥70% per core
  section); (4) 4 guided-writing practice items (WR003–006: punctuation/capitalisation choices,
  welcome-card two-liner, name-badge fill, chunk variant); (5) remediation map + clinic seeds;
  (6) spaced-review export list; (7) chapter wrap-up: QA lens table (all 14 lenses), chapter QA
  report, ledger consolidation; (8) chapter gate with the /compact context tip."
open_items: []                       # clean gate
```

Notes for the next session's agent:

1. Read `STATE.md`, `DECISIONS.md`, both ledgers, the character bible, audio style guide, and this file before writing anything (master prompt §1.3).
2. **Quiz sourcing rule:** quiz items are NEW items (fresh skins, same constructs) — do not copy practice items; reuse audio assets per the §10.0 ratio rule (AUD043–046 may serve quiz listening with new questions, or author 1–2 new short recordings from AUD047).
3. **Generation-prompt convention:** L3 briefs use the `STYLE` / `NEG` macro tokens defined in full in both L1 (§Illustration briefs preamble) and the L3 preamble — L4 may use the same macro pattern; the F3 export pass expands them into final strings.
4. ID positions: audio → `A1-C01-AUD047`; illustration → `A1-C01-ILL031`; quiz → `A1-C01-QZ-*-…`; writing practice → `PR-WR003`; roleplay → `A1-C01-RP001`.
5. Chapter banks: everything complete except writing 2/6 — L4's four writing items close it. Chapter gate = lens table + wrap-up + compact tip (master prompt §1.5/§1.7).
