# Handoff — A1-C01-L02

```yaml
lesson_id: A1-C01-L02
artifacts_delivered:
  A1_C01_L02_LESSON.md: 1/1
  vocabulary_records: 15/15          # V016–V030, Sets C (states) + D (identity/chunks) + E (state questions)
  grammar_records: 3/3               # G001 I'm/you're · G002 my/your · G003 name/state chunks
  practice_items: 54/54              # PR-V017–V036 (20 vocab) + PR-G001–G030 (30 grammar) + PR-P001–P004 (4 pronunciation)
  audio_scripts: 24/24               # AUD019–AUD042 (warm-up, 15 word models, 3 blended, 3 grammar models, 2 pronunciation)
  illustration_briefs: 10/10         # A1-C01-ILL013–ILL022, each with generation_prompt
  screens_with_uiux_tips: 10/10      # S10–S19
targets_introduced: [A1-C01-L02-V016 … V030, A1-C01-L02-G001 … G003]
targets_retrieved: [V001–V015 (S10 warm-up = encounter #4 — Sets A/B in-chapter requirement complete)]
story_state: "Mid-morning at the welcome event. Leo and Nina have arrived; everyone wears blank
  name badges. The learner can now give their name (My name is…/I'm…), ask What's your name?,
  ask How are you?, answer with a state, and bounce the question back with And you?"
next_step: "Lesson A1-C01-L03 (type C+R, assembly steps 10–12). Screens S20–S29. Deliver: the
  conversation package (6–8 turn first-meeting dialogue at the welcome table — learning take +
  fresh challenge take, target_to_turn map, comprehension testlets, substitution table, branch
  map, bounded roleplay seed), the listening ladder (3 testlets: gist → detail → challenge),
  16 conversation practice items, 16 listening practice items, 6 pronunciation practice items,
  reading set (2 name badges + two-line welcome card + greeting-by-time matching = 8 items),
  2 tile-writing tasks (My name is Alex. / Nice to meet you.), ~8 ILL briefs from A1-C01-ILL023,
  audio from A1-C01-AUD043 (dialogue learning take, challenge take, 3 testlets, line models)."
open_items: []                       # clean gate
```

Notes for the next session's agent:

1. Read `STATE.md`, `DECISIONS.md`, both ledgers, the character bible, audio style guide, and this file before writing anything (master prompt §1.3).
2. Chapter bank status: vocabulary 36/36 ✓ · grammar 30/30 ✓ · pronunciation 4/10 (add 6 in L3) · conversation 0/16 · listening 0/16 · reading 0/8 · writing 0/6 (L3 adds conversation/listening/reading/writing per the manifest).
3. The dialogue must use ONLY ledger items with status `taught` (V001–V030, G001–G003) plus `[CHUNK:survival]` `You're welcome!`. Turn count for Ch1: 6–8 turns. Characters available at the scene: all four (Leo and Nina arrived in L2 — bible).
4. Illustration IDs resume at `A1-C01-ILL023`; audio at `A1-C01-AUD043`; conversation practice IDs resume at `A1-C01-PR-CV001`; listening at `A1-C01-PR-LS001`; reading at `A1-C01-PR-RD001`; writing at `A1-C01-PR-WR001`; pronunciation P005–P010.
5. The state-face strength strip (S11) and the two-line badge schema (ILL018) are established visual systems — reuse their geometry in L3.
