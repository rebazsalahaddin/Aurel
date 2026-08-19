# A1-C01-L03 — Lesson 3: A Real First Meeting

Chapter 1 · Hello! My Name Is Alex · Lesson type C+R (assembly steps 10–12)
Core time ≈ 20 min · pause at ≈ 10 min (after the listening ladder) · prerequisites: A1-C01-L01, L02 taught

**Focus:** model conversation + listening ladder (steps 10–11), reading + guided tile-writing (step 12).
**Screens:** S20–S29. **New assets:** 4 audio (AUD043–AUD046), 8 illustration briefs (ILL023–ILL030).
**Practice bank added:** conversation 16 (PR-CV001–016) · listening 16 (PR-LS001–016) · pronunciation 6 (PR-P005–P010) · reading 8 (PR-RD001–008) · guided writing 2 (PR-WR001–002) = 48 items. Chapter banks after this lesson: vocabulary 36/36 ✓ grammar 30/30 ✓ pronunciation 10/10 ✓ conversation 16/16 ✓ listening 16/16 ✓ reading 8/8 ✓ writing 2/6 (L4 completes).
**Instruction words:** Stage 1–3 only; `put in order`, `first`, `next`, `last` (Stage 3) demonstrated at S24 before the order tasks.

---

## STEP 10 — Model conversation and supported listening · Screens S20–S23

### Conversation package A1-C01-D01 — "First Meeting at the Welcome Table"

```yaml
id: A1-C01-D01
scenario: first meeting at a community welcome event
goal: greet, exchange names, ask and answer How are you?, close politely
location: the welcome table outside the Aroa Community House, morning
cast: [Nina Petrova (arriving guest, she/her), Maya Haddad (helper at the table, she/her)]
tone: warm, unhurried, friendly; two intelligible voices, Guide-model stable
prerequisites: all V001–V030, G001–G003 (ledger status taught)
turns: 8
audio_learning_take: A1-C01-AUD043
audio_line_models: A1-C01-AUD044
audio_challenge_take: A1-C01-AUD045
storyboard: [ILL023, ILL024, ILL025, ILL026, ILL027]
transcript_release: after testlet 1 is scored (audio-first integrity)
```

**Clean transcript (learning take, AUD043, `learning_slow_clear`):**

| # | Speaker | Line |
|---|---|---|
| T1 | NINA | Hi! Good morning! |
| T2 | MAYA | Good morning! Welcome! `[CHUNK:survival]` |
| T3 | NINA | Thank you! What's your name? |
| T4 | MAYA | My name is Maya. I'm Maya. |
| T5 | NINA | Nice to meet you, Maya! I'm Nina. |
| T6 | MAYA | Nice to meet you, Nina! How are you? |
| T7 | NINA | I'm good, thank you! And you? |
| T8 | MAYA | I'm fine! Excuse me, Nina — see you! |

**Annotated target_to_turn map:**

| Target ID | Item | Turn(s) |
|---|---|---|
| A1-C01-L01-V002 | hi | T1 |
| A1-C01-L01-V003 | good morning | T1, T2 |
| A1-C01-L01-V010 | thank you | T3, T7 |
| A1-C01-L01-V013 | excuse me | T8 |
| A1-C01-L01-V008 | see you | T8 |
| A1-C01-L02-V017 | fine | T8 |
| A1-C01-L02-V016 | good (in I'm good) | T7 |
| A1-C01-L02-V024 | My name is … | T4 |
| A1-C01-L02-V025 | I'm … | T4, T5, T7, T8 |
| A1-C01-L02-V026 | What's your name? | T3 |
| A1-C01-L02-V027 | Nice to meet you | T5, T6 |
| A1-C01-L02-V028 | How are you? | T6 |
| A1-C01-L02-V029 | I'm good/fine/okay | T7, T8 |
| A1-C01-L02-V030 | And you? | T7 |
| A1-C01-L02-G001 | I'm/you're (I'm lines) | T4, T5, T7, T8 |
| A1-C01-L02-G002 | my/your (in name frames) | T3, T4 |
| A1-C01-L02-G003 | ask → answer → ask back | T3→T4, T6→T7→(And you?) |

Targets not natural in this dialogue (time-fixed greetings afternoon/evening, goodbye/bye, please, thanks, sorry, yes/no, okay/great/not bad, first/last name spoken, welcome ownership) are covered by the **substitution table**, **branch map**, practice items, and the L4 quiz — see coverage matrix below. Per §7.7, no target is force-repeated merely to hit quotas.

**Challenge take (AUD045, `challenge_natural_slow`) — fresh equivalent, café terrace, afternoon, Maya↔Leo (first meeting, per bible):**

| # | Speaker | Line |
|---|---|---|
| C1 | LEO | Hello! Good afternoon! |
| C2 | MAYA | Good afternoon! What's your name? |
| C3 | LEO | My name is Leo. I'm Leo. |
| C4 | MAYA | Nice to meet you, Leo! I'm Maya. |
| C5 | LEO | Nice to meet you, Maya! How are you? |
| C6 | MAYA | I'm great, thank you! And you? |
| C7 | LEO | Not bad! Excuse me, Maya — see you! |

**Casting/pronunciation notes:** Nina — clear, evenly paced, patient; Maya — warm, medium, unhurried; Leo — lower, relaxed, friendly. Challenge take ≈ 120–130 wpm vs learning ≈ 100–110 wpm; contractions fully natural in both; names (Maya, Nina, Leo, Petrova) verified character-by-character in scripts.

**Substitution table (all cells use taught language only):**

| Slot | Safe substitutions |
|---|---|
| Opening greeting | `Hi!` / `Hello!` + `Good morning!` / `Good afternoon!` / `Good evening!` (time-appropriate) |
| Name giving | `My name is Nina Petrova.` / `I'm Nina.` (any fictional name; first + last optional) |
| State answer | `I'm good/fine/okay/great.` / `Not bad!` (+ `, thank you!`) |
| Ask-back | `And you?` |
| Polite close | `Excuse me — see you!` / `Goodbye!` / `Bye!` (+ name) |

**Branch map:**

- **time branch:** morning / afternoon / evening greeting (three dialogue skins)
- **state branch:** five state answers (good/fine/okay/great/not bad) — all accepted, varied across retries
- **close branch:** see you / goodbye / bye; "no time" exit adds `Excuse me`
- **register branch:** formal `My name is …` vs friendly `I'm …` — both always accepted

**AI roleplay seed (full spec is Lesson 4's mission):** learner arrives at the welcome table; Maya (AI) greets; learner gives own name (voice or tap-tiles), asks Maya's name, one How-are-you? exchange, polite close. Turn limit 8; A1 ceiling = taught ledger only; non-voice alternative = branching dialogue with tiles.

**Coverage matrix (chapter-level, conversation/listening/reading use):**

| Target group | Dialogue turn | Conversation practice | Listening | Reading | Writing | L4 quiz |
|---|---|---|---|---|---|---|
| V001–V008 greetings/farewells | T1,T2,T8 + challenge C1,C7 | CV001, 009, 010, 012, 015 | LS008, 010, 015 | RD007 | — | ✓ |
| V009–V015 politeness | T3,T7,T8 | CV011 | LS007, 012 | — | — | ✓ |
| V016–V020 states | T7,T8 + C6,C7 | CV005, 006 | LS009, 016 | — | — | ✓ |
| V021–V027 identity/chunks | T3–T6 + C2–C4 | CV002, 003, 004, 007, 013, 014, 016 | LS001–006, 011, 013, 014 | RD001–006, 008 | WR001, WR002 | ✓ |
| V028–V030 state questions | T6,T7 + C5,C6 | CV008 | LS012 | — | — | ✓ |
| G001–G003 | all turns | CV003–006, 014 | LS011–014 | RD008 | WR001 | ✓ |

**UI/UX tip — S20 (conversation play):** Storyboard player: five panels (ILL023–027) crossfade per speaker; big play/pause; speaker chip glows per turn. Captions hidden until testlet 1 is scored (then a "show words" toggle unlocks — transcript_release policy). Free replay (unscored model). Line-mode button jumps to AUD044 per-line playback for rehearsal. VoiceOver: panel alt-texts read between turns; transcript (when unlocked) exposes per-turn elements.

### Listening ladder

**Testlet 1 — GIST (S21, on AUD043; items LS001–003; documented testlet — items share the stimulus):**

```yaml
id: A1-C01-PR-LS001
assessment_context: practice
component: listening
subskill: identify_participants
testlet: TL1 (3 items, stimulus A1-C01-AUD043, dependence documented)
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD043, illustration_asset_id: A1-C01-ILL023}
response_type: image_choice
options: [{id: A, illustration_asset_id: A1-C01-ILL025}, {id: B, text: "three people"}, {id: C, text: "four people"}]
correct_option_ids: [A]
rationale: two speakers — Nina and Maya.
distractor_rationales: {B: "three voices are not heard", C: "four voices are not heard"}
feedback_correct: "Yes — two people talk."
feedback_incorrect: "Listen again — count the voices."
hint_ladder: ["Play again; the speaker chips glow per turn.", "Two names are spoken. Count them."]
estimated_seconds: 30
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-LS002
testlet: TL1
subskill: identify_relationship_type
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD043, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: "first meeting"}, {id: B, text: "goodbye talk"}, {id: C, text: "sorry talk"}]
correct_option_ids: [A]
rationale: they exchange names and say Nice to meet you — a first meeting.
distractor_rationales: {B: "they only close at the very end", C: "no problem happens"}
feedback_correct: "Yes — a first meeting!"
feedback_incorrect: "They ask names and meet. What kind of talk is that?"
hint_ladder: ["Listen for What's your name?", "Remove the problem-talk option."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS003
testlet: TL1
subskill: identify_time_of_day
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD043, illustration_asset_id: null}
response_type: image_choice
options: [{id: A, illustration_asset_id: A1-C01-ILL002}, {id: B, illustration_asset_id: A1-C01-ILL004}, {id: C, illustration_asset_id: A1-C01-ILL003}]
correct_option_ids: [A]
rationale: both say good morning.
distractor_rationales: {B: "evening — the lamps scene", C: "afternoon — the high-sun terrace"}
feedback_correct: "Yes — morning!"
feedback_incorrect: "Listen for the time greeting."
hint_ladder: ["Replay T1.", "Two greetings are said. Which time?"]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response, alt_text_parallel_options]
```

**Testlet 2 — DETAIL (S22, on AUD046; items LS004–007; short exchange: ALEX: "Hello! What's your name?" … NINA: "My name is Nina Petrova." … ALEX: "Nice to meet you, Nina!" … NINA: "Thank you!"):**

```yaml
id: A1-C01-PR-LS004
assessment_context: practice
component: listening
subskill: identify_first_name
testlet: TL2 (4 items, stimulus A1-C01-AUD046)
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD046, illustration_asset_id: A1-C01-ILL018}
response_type: single_choice
options: [{id: A, text: Maya}, {id: B, text: Nina}, {id: C, text: Leo}]
correct_option_ids: [B]
rationale: "she says My name is Nina Petrova — first name Nina"
distractor_rationales: {A: "Maya is not in this recording", C: "Leo is not in this recording"}
feedback_correct: "Yes — Nina!"
feedback_incorrect: "Listen to the words after My name is."
hint_ladder: ["Replay the name line.", "The FIRST name comes before the family name."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-LS005
testlet: TL2
subskill: identify_last_name
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD046, illustration_asset_id: A1-C01-ILL018}
response_type: single_choice
options: [{id: A, text: Petrova}, {id: B, text: Nina}, {id: C, text: Haddad}]
correct_option_ids: [A]
rationale: the last name is Petrova.
distractor_rationales: {B: "Nina is the first name", C: "Haddad is Maya's family name"}
feedback_correct: "Yes — Petrova!"
feedback_incorrect: "The LAST name comes last. Listen again."
hint_ladder: ["Replay; the bottom badge line glows.", "One option is the first name."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS006
testlet: TL2
subskill: identify_meeting_chunk
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD046, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: "Nice to meet you!"}, {id: B, text: "Goodbye!"}, {id: C, text: "Sorry!"}]
correct_option_ids: [A]
rationale: Alex answers the first meeting with the meeting chunk.
distractor_rationales: {B: "no one leaves", C: "no problem happens"}
feedback_correct: "Yes — the meeting words!"
feedback_incorrect: "A first meeting just happened."
hint_ladder: ["Replay Alex's second line.", "Remove the leaving word."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS007
testlet: TL2
subskill: identify_politeness_word
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD046, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: please}, {id: B, text: "Thank you!"}, {id: C, text: "Excuse me"}]
correct_option_ids: [B]
rationale: Nina ends with Thank you.
distractor_rationales: {A: "please asks for something", C: "excuse me passes or exits — Nina thanks"}
feedback_correct: "Yes — thank you!"
feedback_incorrect: "The LAST word Nina says."
hint_ladder: ["Replay the final line.", "Two words ask or pass. Remove them."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

**Testlet 3 — CHALLENGE (S23, on AUD045; items LS008–010; fresh voices, faster take, reduced support — played once by default):**

```yaml
id: A1-C01-PR-LS008
assessment_context: practice
component: listening
subskill: identify_time_of_day_challenge
testlet: TL3 (3 items, stimulus A1-C01-AUD045)
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD045, illustration_asset_id: A1-C01-ILL028}
response_type: single_choice
options: [{id: A, text: morning}, {id: B, text: afternoon}, {id: C, text: evening}]
correct_option_ids: [B]
rationale: the greeting is good afternoon.
distractor_rationales: {A: "morning greetings are not said", C: "no evening lamps in this take"}
feedback_correct: "Yes — afternoon!"
feedback_incorrect: "Listen to the FIRST greeting."
hint_ladder: ["One replay is allowed — listen for the time word.", "Remove the answer that matches the morning event."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-LS009
testlet: TL3
subskill: identify_state_challenge
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD045, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: great}, {id: B, text: "I'm fine"}, {id: C, text: "Not bad!"}]
correct_option_ids: [C]
rationale: Leo answers How are you? with Not bad!
distractor_rationales: {A: "great is MAYA's answer", B: "fine is not said in this take"}
feedback_correct: "Yes — not bad!"
feedback_incorrect: "Listen for LEO's feeling word (the man)."
hint_ladder: ["Replay; the male voice answers near the end.", "One state belongs to Maya."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS010
testlet: TL3
subskill: identify_closing_challenge
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD045, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: "Excuse me — see you!"}, {id: B, text: "Nice to meet you!"}, {id: C, text: "Good morning!"}]
correct_option_ids: [A]
rationale: Leo politely exits at the end.
distractor_rationales: {B: "the meeting words come earlier", C: "the wrong time greeting"}
feedback_correct: "Yes — a polite exit!"
feedback_incorrect: "The LAST line is the exit."
hint_ladder: ["Replay the final line.", "Two options start the talk, one ends it."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response]
```

**Transfer/response items (LS011–016):**

```yaml
id: A1-C01-PR-LS011
component: listening
subskill: respond_to_name_question
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD030, illustration_asset_id: null}   # What's your name?
response_type: single_choice
options: [{id: A, text: "I'm fine."}, {id: B, text: "My name is Sam."}, {id: C, text: "See you!"}]
correct_option_ids: [B]
rationale: name question → name answer (any name accepted as construct; Sam = the safe fictional sample).
distractor_rationales: {A: "state answer", C: "leaving chunk"}
feedback_correct: "Yes — a name answers a name question!"
feedback_incorrect: "The question wants a NAME."
hint_ladder: ["Replay the question.", "Remove the goodbye."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS012
component: listening
subskill: respond_to_state_question
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD032, illustration_asset_id: null}   # How are you?
response_type: single_choice
options: [{id: A, text: "Not bad, thank you! And you?"}, {id: B, text: "My name is Sam."}, {id: C, text: "Good afternoon!"}]
correct_option_ids: [A]
rationale: state answer + ask back.
distractor_rationales: {B: "name answer", C: "greeting, not an answer"}
feedback_correct: "Yes — a feeling answer and the ask-back!"
feedback_incorrect: "The question wants a FEELING."
hint_ladder: ["Replay the question.", "Remove the name answer."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS013
component: listening
subskill: respond_to_meeting_chunk
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}   # line model: "Nice to meet you, Nina!"
response_type: single_choice
options: [{id: A, text: "Nice to meet you, Maya!"}, {id: B, text: "Bye, Maya!"}, {id: C, text: "I'm okay, Maya."}]
correct_option_ids: [A]
rationale: the meeting chunk returns symmetrically.
distractor_rationales: {B: "no one leaves", C: "no state question is open"}
feedback_correct: "Yes — meeting words return meeting words!"
feedback_incorrect: "A first meeting is happening."
hint_ladder: ["Replay the line.", "Remove the leaving word."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS014
component: listening
subskill: follow_up_after_introduction
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}   # line model: "I'm Leo."
response_type: single_choice
options: [{id: A, text: "Nice to meet you, Leo!"}, {id: B, text: "My name is Leo."}, {id: C, text: "See you!"}]
correct_option_ids: [A]
rationale: a first-time introduction invites the meeting chunk.
distractor_rationales: {B: "repeats Leo's own name back to him", C: "no one is leaving — the meeting just started"}
feedback_correct: "Yes — meet Leo warmly!"
feedback_incorrect: "Leo just gave HIS name for the first time."
hint_ladder: ["Replay the line.", "One option repeats Leo's name as your own."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-LS015
component: listening
subskill: predict_next_action
instruction: "Listen. Choose."   # AUD043 T8: "I'm fine! Excuse me, Nina — see you!"
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}
response_type: image_choice
options: [{id: A, illustration_asset_id: A1-C01-ILL027}, {id: B, illustration_asset_id: A1-C01-ILL021}, {id: C, illustration_asset_id: A1-C01-ILL005}]
correct_option_ids: [A]
rationale: the polite exit means Maya steps away to the table.
distractor_rationales: {B: "a handshake starts a meeting — it already happened", C: "a hello wave opens a talk — this closes it"}
feedback_correct: "Yes — she politely steps away!"
feedback_incorrect: "Her words END the talk. What happens after?"
hint_ladder: ["Replay the last line.", "Two pictures START meetings."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response, alt_text_parallel_options]
```

```yaml
id: A1-C01-PR-LS016
component: listening
subskill: infer_next_speaker_answer
instruction: "Listen. Choose."   # AUD045 C6: "I'm great, thank you! And you?"
stimulus: {audio_asset_id: A1-C01-AUD045, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: "Not bad!"}, {id: B, text: "My name is Leo."}, {id: C, text: "Good afternoon!"}]
correct_option_ids: [A]
rationale: And you? returns the state question — the man answers with his state.
distractor_rationales: {B: "his name was already given", C: "the time greeting already happened"}
feedback_correct: "Yes — the question bounces back and he answers!"
feedback_incorrect: "The question asked HOW he is."
hint_ladder: ["Replay the end of Maya's line.", "Remove the name and the greeting."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response]
```

**UI/UX tips — S21/S22/S23:** Ladder difficulty is engineered by support, not speed tricks: S21 shows the storyboard during gist questions; S22 strips to the badge icon; S23 plays once by default with one diagnostic replay (never penalized) and no imagery until after the response. Each testlet ends with its transcript unlocking (line-by-line, tappable to replay AUD044). Timer absent throughout; latency never scored.

---

## PAUSE — after S23 (≈ 10 min): checkpoint screen, two rings filled, state saved.

---

## STEP 11 — Conversation practice (≈ 6 min) · Screens S24–S26 (CV001–016)

```yaml
id: A1-C01-PR-CV001
component: conversation
subskill: best_next_turn_greeting
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD002, illustration_asset_id: null}   # Hello!
response_type: single_choice
options: [{id: A, text: "Bye!"}, {id: B, text: "Hi!"}, {id: C, text: "Thank you!"}]
correct_option_ids: [B]
rationale: a greeting returns a greeting.
distractor_rationales: {A: "ends a talk", C: "thanks for receiving"}
feedback_correct: "Yes — hello back!"
feedback_incorrect: "A hello wants a hello."
hint_ladder: ["Replay the greeting.", "Remove the goodbye."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-CV002
component: conversation
subskill: identify_speaker_intent
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD030, illustration_asset_id: null}   # What's your name?
response_type: single_choice
options: [{id: A, text: "she wants a name"}, {id: B, text: "she wants to leave"}, {id: C, text: "she says thank you"}]
correct_option_ids: [A]
rationale: the name question asks for a name.
distractor_rationales: {B: "no closing words are said", C: "no thanks word is said"}
feedback_correct: "Yes — she asks for a name!"
feedback_incorrect: "Listen to the question word."
hint_ladder: ["Replay; listen for name.", "Remove the goodbye idea."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-CV003
component: conversation
subskill: dialogue_order_short
instruction: "Put in order. First. Next. Last."
stimulus: {illustration_asset_id: A1-C01-ILL025, audio_asset_id: null}
tiles: ["Hi! What's your name?", "My name is Maya.", "Nice to meet you, Maya!", "How are you?"]
response_type: tile_order
correct_order: ["Hi! What's your name?", "My name is Maya.", "Nice to meet you, Maya!", "How are you?"]
rationale: ask → give → meet → ask state.
feedback_correct: "A perfect mini meeting!"
feedback_incorrect: "Start with the question for a name."
hint_ladder: ["Which line asks first?", "The state question comes last."]
estimated_seconds: 40
accessibility_tags: [tap_only_no_drag]
```

```yaml
id: A1-C01-PR-CV004
component: conversation
subskill: dialogue_order_full
instruction: "Put in order. First. Next. Last."
stimulus: {illustration_asset_id: A1-C01-ILL023, audio_asset_id: null}
tiles: ["Hi! Good morning!", "Good morning! Welcome!", "Thank you! What's your name?", "My name is Maya. I'm Maya.", "Nice to meet you, Maya! I'm Nina.", "How are you?"]
response_type: tile_order
correct_order: as listed
rationale: the model dialogue's first six turns.
feedback_correct: "The whole opening — in order!"
feedback_incorrect: "Two greetings open the talk."
hint_ladder: ["Play the model once more.", "The name question follows the welcome."]
estimated_seconds: 60
accessibility_tags: [tap_only_no_drag]
```

```yaml
id: A1-C01-PR-CV005
component: conversation
subskill: substitute_state_answer
instruction: "Listen. Choose."   # Nina: I'm good! — choose ANOTHER true answer
stimulus: {audio_asset_id: A1-C01-AUD033, illustration_asset_id: null}
response_type: single_choice
options: [{id: A, text: "I'm great!"}, {id: B, text: "I'm Maya."}, {id: C, text: "My name"}]
correct_option_ids: [A]
rationale: any state word substitutes in the answer frame.
distractor_rationales: {B: "a name answer", C: "not a full answer"}
feedback_correct: "Yes — any feeling word works in the frame!"
feedback_incorrect: "The frame I'm ___ takes a FEELING."
hint_ladder: ["Look at the state strip.", "Remove the name answer."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-CV006
component: conversation
subskill: sort_replies_by_question
instruction: "Match." (two-column tap-sort)
stimulus: {illustration_asset_id: null, audio_asset_id: null}
columns: ["What's your name? replies", "How are you? replies"]
cards: ["My name is Sam.", "I'm Nina.", "I'm good.", "Not bad!"]
correct_sort: {name: ["My name is Sam.", "I'm Nina."], state: ["I'm good.", "Not bad!"]}
rationale: name replies vs state replies.
feedback_correct: "Name words for name questions; feeling words for feeling questions!"
feedback_incorrect: "Ask: does the card give a NAME or a FEELING?"
hint_ladder: ["Read one card aloud with each question.", "I'm works for both — check what follows it."]
estimated_seconds: 45
accessibility_tags: [tap_only_no_drag]
```

```yaml
id: A1-C01-PR-CV007
component: conversation
subskill: best_next_turn_after_introduction
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}   # "My name is Leo."
response_type: single_choice
options: [{id: A, text: "Nice to meet you, Leo!"}, {id: B, text: "And you?"}, {id: C, text: "You're welcome!"}]
correct_option_ids: [A]
rationale: first-time name → meeting chunk.
distractor_rationales: {B: "no state question is open yet", C: "answers thank you"}
feedback_correct: "Yes — meet him warmly!"
feedback_incorrect: "A first meeting just happened."
hint_ladder: ["Was a question asked?", "One option answers a thanks."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-CV008
component: conversation
subskill: best_next_turn_after_ask_back
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}   # "I'm fine! And you?"
response_type: single_choice
options: [{id: A, text: "What's your name?"}, {id: B, text: "I'm okay, thank you!"}, {id: C, text: "Goodbye!"}]
correct_option_ids: [B]
rationale: answer the returned state question.
distractor_rationales: {A: "changes the topic", C: "the talk is not closing"}
feedback_correct: "Yes — your feeling, then done!"
feedback_incorrect: "The question asked YOU."
hint_ladder: ["Which question is open?", "Remove the new question."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response]
```

```yaml
id: A1-C01-PR-CV009
component: conversation
subskill: choose_greeting_for_scene
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL004, audio_asset_id: null}   # evening street
prompt_line: "The meeting starts. Choose:"
response_type: single_choice
options: [{id: A, text: "Good evening!"}, {id: B, text: "Good morning!"}, {id: C, text: "See you!"}]
correct_option_ids: [A]
rationale: dark sky + lamps = evening greeting opens a meeting.
distractor_rationales: {B: "morning is light sky", C: "a farewell — the meeting starts"}
feedback_correct: "Yes — good evening!"
feedback_incorrect: "Look at the sky and the lamps. The meeting STARTS."
hint_ladder: ["Day or night?", "Remove the goodbye."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-CV010
component: conversation
subskill: choose_closing_line
prompt_line: "The meeting ends. Choose:"
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL007, audio_asset_id: null}
response_type: single_choice
options: [{id: A, text: "Hello!"}, {id: B, text: "See you!"}, {id: C, text: "What's your name?"}]
correct_option_ids: [B]
rationale: walking apart + waving = the close.
distractor_rationales: {A: "a greeting opens", C: "a question opens"}
feedback_correct: "Yes — see you!"
feedback_incorrect: "They walk AWAY."
hint_ladder: ["Look at the feet.", "Two options open a talk."]
estimated_seconds: 15
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-CV011
component: conversation
subskill: choose_politeness_word_in_context
prompt_line: "Maya goes to the table. She says ___ first."
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL027, audio_asset_id: null}
response_type: single_choice
options: [{id: A, text: "Excuse me"}, {id: B, text: "I'm fine"}, {id: C, text: "Good morning"}]
correct_option_ids: [A]
rationale: stepping away politely takes excuse me.
distractor_rationales: {B: "a state answer without a question", C: "a greeting mid-talk"}
feedback_correct: "Yes — excuse me!"
feedback_incorrect: "She steps PAST to leave politely."
hint_ladder: ["Look — she moves away.", "One option is a feeling word."]
estimated_seconds: 15
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-CV012
component: conversation
subskill: choose_polite_exit_branch
prompt_line: "Nina has no time. Her polite close:"
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL027, audio_asset_id: null}
response_type: single_choice
options: [{id: A, text: "Hello!"}, {id: B, text: "What's your name?"}, {id: C, text: "Excuse me — see you!"}]
correct_option_ids: [C]
rationale: the no-time exit branch from the branch map.
distractor_rationales: {A: "opens a talk", B: "starts a longer exchange"}
feedback_correct: "Yes — the polite exit!"
feedback_incorrect: "She has NO time — end the talk kindly."
hint_ladder: ["Does she open or close?", "Remove the question."]
estimated_seconds: 15
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-CV013
component: listening
subskill: identify_speaker_by_line
instruction: "Listen. Choose."   # AUD044 line: T2 "Good morning! Welcome!"
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}
prompt_line: "Who says Welcome!?"
response_type: image_choice
options: [{id: A, illustration_asset_id: A1-CHAR-ILL002}, {id: B, illustration_asset_id: A1-CHAR-ILL004}, {id: C, illustration_asset_id: A1-CHAR-ILL003}]
correct_option_ids: [A]
rationale: Maya (the helper, T2) says Welcome.
distractor_rationales: {B: "Nina is the arriving guest", C: "Leo is not in this dialogue"}
feedback_correct: "Yes — Maya welcomes!"
feedback_incorrect: "The HELPER at the table says welcome."
hint_ladder: ["Replay T2 with the panel showing.", "Two speakers: who arrives, who helps?"]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response, alt_text_parallel_options]
```

```yaml
id: A1-C01-PR-CV014
component: conversation
subskill: two_blank_introduction
instruction: "Look. Choose. One. Two."
stimulus: {illustration_asset_id: A1-C01-ILL020, audio_asset_id: null}   # Maya asks you
dialogue_frame: "MAYA: 'Hi! What's your name?'  YOU: '____'  MAYA: 'Nice to meet you! How are you?'  YOU: '____'"
blank_1_options: [{id: 1A, text: "My name is Sam."}, {id: 1B, text: "I'm fine."}, {id: 1C, text: "See you!"}]
blank_2_options: [{id: 2A, text: "My name is Sam."}, {id: 2B, text: "I'm okay, thank you!"}, {id: 2C, text: "Good morning!"}]
correct_option_ids: [1A, 2B]
rationale: name answer then state answer.
distractor_rationales: {1B: "state answer to a name question", 1C: "closing chunk", 2A: "name repeated where a state fits", 2C: "a greeting, not an answer"}
feedback_correct: "You just held up your end of the meeting!"
feedback_incorrect: "Give your NAME, then your FEELING."
hint_ladder: ["Check which question each blank follows.", "Blank 2 answers How are you?"]
estimated_seconds: 40
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-CV015
component: conversation
subskill: dialogue_order_challenge_variant
instruction: "Put in order. First. Next. Last."
stimulus: {illustration_asset_id: A1-C01-ILL028, audio_asset_id: null}
tiles: ["Hello! Good afternoon!", "My name is Leo. I'm Leo.", "Nice to meet you, Leo! I'm Maya.", "How are you?", "I'm great, thank you! And you?"]
response_type: tile_order
correct_order: as listed
rationale: the challenge dialogue's first five content turns.
feedback_correct: "The café meeting — in order!"
feedback_incorrect: "Two lines open: the greeting and the name question group."
hint_ladder: ["Play the challenge take once more.", "The ask-back comes last."]
estimated_seconds: 50
accessibility_tags: [tap_only_no_drag]
```

```yaml
id: A1-C01-PR-CV016
component: pronunciation
subskill: echo_meeting_chunk
instruction: "Listen. Say."
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: A1-C01-ILL021}   # "Nice to meet you, Nina!"
response_type: speak_repeat
scoring: ungraded — record, playback, self-compare
correct_option_ids: []
rationale: produce the meeting chunk with stress on meet.
feedback_correct: "Recorded! Play both — make MEET the big word."
feedback_incorrect: "Try again, or skip — no points lost."
hint_ladder: ["Model twice; tap the big word.", "Say only meet you — MEET is strong."]
estimated_seconds: 30
accessibility_tags: [non_voice_alternative_tap_word, mic_optional_never_blocks]
```

**UI/UX tips — S24/S25/S26:** S24 (order tasks): tiles listed vertically, tapped in sequence, numbered badges appear as chosen, undo by re-tap — no dragging. S25 (next-turn): chat-bubble stimulus with the two-face frame; options as three reply bubbles. S26 (substitution): the state strip and badge schema return; the two-column sort uses tap-in / tap-out. All conversation items play their line via AUD044 before options appear (listen-first, then read).

### Pronunciation completion (P005–P010, runs inside S23b/S26b blocks)

```yaml
id: A1-C01-PR-P005
component: pronunciation
subskill: perceive_stress_in_chunk
instruction: "Listen. Choose." (tap the strong/big word)
stimulus: {audio_asset_id: A1-C01-AUD030, illustration_asset_id: null}   # What's your NAME?
response_type: single_choice
options: [{id: A, text: What's}, {id: B, text: your}, {id: C, text: name}]
correct_option_ids: [C]
rationale: the last word carries the stress.
feedback_correct: "Yes — NAME is the strong word!"
feedback_incorrect: "The BIG word is the last one."
hint_ladder: ["Replay; watch the size hint.", "Small words stay small."]
estimated_seconds: 15
accessibility_tags: [audio_required]
```

```yaml
id: A1-C01-PR-P006
component: pronunciation
subskill: perceive_statement_vs_question_revisited
instruction: "Listen. Choose." (arrow icons)
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: null}   # mixed lines: statements + questions
trials: ["My name is Maya.", "How are you?", "I'm good.", "And you?"]
response_type: icon_choice
options: [{id: A, icon: arrow_down}, {id: B, icon: arrow_up}]
correct_option_ids: per trial [A, B, A, B]
rationale: telling falls; asking rises.
feedback_correct: "Down for telling, up for asking!"
feedback_incorrect: "Listen to the END of the voice."
hint_ladder: ["Replay the trial.", "Say it and feel your voice."]
estimated_seconds: 50
accessibility_tags: [audio_required, visual_arrow_equivalent_shown]
```

```yaml
id: A1-C01-PR-P007
component: pronunciation
subskill: shadow_short_exchange
instruction: "Listen. Say."
stimulus: {audio_asset_id: A1-C01-AUD046, illustration_asset_id: A1-C01-ILL018}
role: Nina's lines ("My name is Nina Petrova." / "Thank you!")
response_type: speak_repeat
scoring: ungraded — record/playback/compare; note "say your OWN name in the frame next"
correct_option_ids: []
rationale: produce the name frame aloud.
feedback_correct: "Recorded! Now try it with YOUR name."
feedback_incorrect: "Try again or skip."
hint_ladder: ["Model twice.", "Say only Nina Petrova first."]
estimated_seconds: 40
accessibility_tags: [non_voice_alternative_tap_word]
```

```yaml
id: A1-C01-PR-P008
component: pronunciation
subskill: shadow_polite_exit
instruction: "Listen. Say."
stimulus: {audio_asset_id: A1-C01-AUD044, illustration_asset_id: A1-C01-ILL027}   # "Excuse me, Nina — see you!"
response_type: speak_repeat
scoring: ungraded; note "keep it light and friendly, not sad"
correct_option_ids: []
rationale: produce the exit line naturally.
feedback_correct: "Recorded! Light and friendly — perfect."
feedback_incorrect: "Try again or skip."
hint_ladder: ["Model twice.", "Say only see you first."]
estimated_seconds: 30
accessibility_tags: [non_voice_alternative_tap_word]
```

```yaml
id: A1-C01-PR-P009
component: pronunciation
subskill: perceive_stress_meet
instruction: "Listen. Choose." (tap the strong word)
stimulus: {audio_asset_id: A1-C01-AUD031, illustration_asset_id: null}   # nice to MEET you
response_type: single_choice
options: [{id: A, text: Nice}, {id: B, text: meet}, {id: C, text: you}]
correct_option_ids: [B]
rationale: stress lands on meet.
feedback_correct: "Yes — MEET is the strong word!"
feedback_incorrect: "The BIG word is in the middle."
hint_ladder: ["Replay; watch the size hint.", "First and last stay small."]
estimated_seconds: 15
accessibility_tags: [audio_required]
```

```yaml
id: A1-C01-PR-P010
component: pronunciation
subskill: personal_introduction
instruction: "Listen. Say."
stimulus: {audio_asset_id: A1-C01-AUD038, illustration_asset_id: A1-C01-ILL019}
task: "Say: My name is ___. I'm ___." (the learner's own name)
response_type: speak_repeat
scoring: ungraded — private playback; one note: "down at the end for telling"
correct_option_ids: []
rationale: personalized production of the chapter frame.
feedback_correct: "Recorded! That is YOUR hello — Chapter 1 is nearly yours."
feedback_incorrect: "Try again or skip."
hint_ladder: ["Model twice, then use your name.", "Keep the voice down at the end."]
estimated_seconds: 45
accessibility_tags: [non_voice_alternative_tap_word, mic_optional_never_blocks]
```

---

## STEP 12 — Reading and guided writing (≈ 4 min) · Screens S27–S29

**Texts (app-layer text over ILL029/ILL030 backgrounds; never baked into art):**

1. **Badge 1:** `MAYA HADDAD` (on ILL029 badge pair, left)
2. **Badge 2:** `LEO NOVAK` (right)
3. **Welcome card** (two lines, on ILL030): `Welcome!` / `My name is Alex.`
4. **Greeting-by-time board:** two mini-scenes (ILL002 morning / ILL004 evening) with the greeting words as tappable labels below the board (app layer)

```yaml
id: A1-C01-PR-RD001
component: reading
subskill: read_badge_first_name
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL029, text_overlay: "MAYA HADDAD"}
prompt_line: "First name:"
response_type: single_choice
options: [{id: A, text: Maya}, {id: B, text: Haddad}, {id: C, text: Leo}]
correct_option_ids: [A]
rationale: the first name comes first on the badge.
distractor_rationales: {B: "the last name", C: "the other badge's first name"}
feedback_correct: "Yes — Maya!"
feedback_incorrect: "The TOP word is the first name."
hint_ladder: ["Point to the top word.", "One name is from the other badge."]
estimated_seconds: 15
accessibility_tags: [dynamic_type_safe]
```

```yaml
id: A1-C01-PR-RD002
component: reading
subskill: read_badge_last_name
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL029, text_overlay: "MAYA HADDAD"}
prompt_line: "Last name:"
response_type: single_choice
options: [{id: A, text: Maya}, {id: B, text: Leo}, {id: C, text: Haddad}]
correct_option_ids: [C]
rationale: the last name comes last.
distractor_rationales: {A: "the first name", B: "the other badge's first name"}
feedback_correct: "Yes — Haddad!"
feedback_incorrect: "The BOTTOM word is the last name."
hint_ladder: ["Point to the bottom word.", "One option is Maya herself."]
estimated_seconds: 15
accessibility_tags: [dynamic_type_safe]
```

```yaml
id: A1-C01-PR-RD003
component: reading
subskill: read_badge_first_name
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL029, text_overlay: "LEO NOVAK"}
prompt_line: "First name:"
response_type: single_choice
options: [{id: A, text: Novak}, {id: B, text: Leo}, {id: C, text: Maya}]
correct_option_ids: [B]
rationale: Leo is the first name.
distractor_rationales: {A: "the last name", C: "the other badge's name"}
feedback_correct: "Yes — Leo!"
feedback_incorrect: "The TOP word on this badge."
hint_ladder: ["Point to the top word.", "One option is from Maya's badge."]
estimated_seconds: 15
accessibility_tags: [dynamic_type_safe]
```

```yaml
id: A1-C01-PR-RD004
component: reading
subskill: read_badge_last_name
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL029, text_overlay: "LEO NOVAK"}
prompt_line: "Last name:"
response_type: single_choice
options: [{id: A, text: Novak}, {id: B, text: Leo}, {id: C, text: Haddad}]
correct_option_ids: [A]
rationale: Novak is the last name.
distractor_rationales: {B: "the first name", C: "Maya's last name"}
feedback_correct: "Yes — Novak!"
feedback_incorrect: "The BOTTOM word on this badge."
hint_ladder: ["Point to the bottom word.", "One option belongs to Maya."]
estimated_seconds: 15
accessibility_tags: [dynamic_type_safe]
```

```yaml
id: A1-C01-PR-RD005
component: reading
subskill: read_card_identify_host
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL030, text_overlay: "Welcome! / My name is Alex."}
prompt_line: "The card is from:"
response_type: single_choice
options: [{id: A, text: Maya}, {id: B, text: Alex}, {id: C, text: Nina}]
correct_option_ids: [B]
rationale: the card states the writer's name.
distractor_rationales: {A: "Maya is at the table, not the card writer", C: "Nina arrives later"}
feedback_correct: "Yes — Alex's card!"
feedback_incorrect: "Read the second line."
hint_ladder: ["Find My name is…", "Two options are helpers, one is the host."]
estimated_seconds: 15
accessibility_tags: [dynamic_type_safe]
```

```yaml
id: A1-C01-PR-RD006
component: reading
subskill: identify_text_purpose
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL030, text_overlay: "Welcome! / My name is Alex."}
prompt_line: "The card says:"
response_type: single_choice
options: [{id: A, text: "a name"}, {id: B, text: "a goodbye"}, {id: C, text: "a question"}]
correct_option_ids: [A]
rationale: the card welcomes and gives a name — no question mark, no farewell.
distractor_rationales: {B: "no farewell words", C: "no question mark"}
feedback_correct: "Yes — it gives a name!"
feedback_incorrect: "Look for a ? or a farewell word."
hint_ladder: ["Point at the end marks.", "Welcome is a hello word."]
estimated_seconds: 15
accessibility_tags: [dynamic_type_safe]
```

```yaml
id: A1-C01-PR-RD007
component: reading
subskill: match_greeting_to_time_board
instruction: "Match."
stimulus: {illustration_asset_id: null, text_overlay: "board with two scenes"}
scenes: [{illustration_asset_id: A1-C01-ILL002}, {illustration_asset_id: A1-C01-ILL004}]
labels: ["Good morning!", "Good evening!"]
response_type: matching
correct_pairs: [{ILL002: "Good morning!"}, {ILL004: "Good evening!"}]
rationale: sun position ↔ time greeting.
feedback_correct: "Morning sun, evening lamps — matched!"
feedback_incorrect: "Look at the sky and the lamps."
hint_ladder: ["Say each greeting with each scene.", "The dark scene is not morning."]
estimated_seconds: 30
accessibility_tags: [tap_only_matching_no_drag, alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-RD008
component: reading
subskill: read_question_choose_reply
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL018, text_overlay: "What's your name?"}
prompt_line: "Your line:"
response_type: single_choice
options: [{id: A, text: "My name is Sam."}, {id: B, text: "I'm fine, thank you!"}, {id: C, text: "See you!"}]
correct_option_ids: [A]
rationale: the written question asks a name.
distractor_rationales: {B: "answers a state question", C: "closes a talk"}
feedback_correct: "Yes — you read the question and answered it!"
feedback_incorrect: "Read the question again — what does it want?"
hint_ladder: ["Find the word name in the question.", "Remove the goodbye."]
estimated_seconds: 20
accessibility_tags: [dynamic_type_safe]
```

**UI/UX tip — S27/S28:** Reading text always renders in the app layer (never inside art) with Dynamic Type to XL; badges use the ILL018 geometry so the schema transfers. RD tasks auto-play nothing by default (reading measures reading) — but a "listen to it" button appears AFTER a correct response, linking the written word to its audio model (dual coding without contaminating the reading construct).

### Guided tile-writing (S29)

```yaml
id: A1-C01-PR-WR001
component: guided_writing
subskill: tile_sentence_name
instruction: "Put in order."
stimulus: {illustration_asset_id: A1-C01-ILL019, audio_asset_id: A1-C01-AUD028}
tiles: ["My", "name", "is", "Sam", "."]
response_type: tile_order
correct_order: ["My", "name", "is", "Sam", "."]
rationale: the introduction sentence with capital M, capital name, final period.
feedback_correct: "My name is Sam. — you wrote your first sentence!"
feedback_incorrect: "Start with the badge word."
hint_ladder: ["Which two words sit together on the badge?", "The dot goes last."]
estimated_seconds: 30
accessibility_tags: [tap_only_no_drag, dynamic_type_safe]
```

```yaml
id: A1-C01-PR-WR002
component: guided_writing
subskill: tile_sentence_meeting_chunk
instruction: "Put in order."
stimulus: {illustration_asset_id: A1-C01-ILL021, audio_asset_id: A1-C01-AUD031}
tiles: ["Nice", "to", "meet", "you", "."]
response_type: tile_order
correct_order: ["Nice", "to", "meet", "you", "."]
rationale: the meeting chunk as a written sentence.
feedback_correct: "Nice to meet you. — meeting words on the page!"
feedback_incorrect: "Say it first — the order is the sound."
hint_ladder: ["Play the model and point to each tile.", "The dot goes last."]
estimated_seconds: 30
accessibility_tags: [tap_only_no_drag, dynamic_type_safe]
```

**UI/UX tip — S29:** Tiles show capitalization and the period as real tiles (they are content here, not decoration). Correct assembly triggers the written line animating into a speech bubble above the speaker in the scene — writing instantly becomes communication. Optional: keyboard/speech input OFF by default; the tap path is the only required path.

---

## Audio scripts — verbatim (4 new assets)

| ID | Purpose | Delivery | Verbatim script |
|---|---|---|---|
| A1-C01-AUD043 | model dialogue learning take | learning_slow_clear | NINA: "Hi! Good morning!" … MAYA: "Good morning! Welcome!" … NINA: "Thank you! What's your name?" … MAYA: "My name is Maya. I'm Maya." … NINA: "Nice to meet you, Maya! I'm Nina." … MAYA: "Nice to meet you, Nina! How are you?" … NINA: "I'm good, thank you! And you?" … MAYA: "I'm fine! Excuse me, Nina — see you!" |
| A1-C01-AUD044 | dialogue line models | learning_slow_clear | each of the 8 lines of AUD043 in order, spoken twice, 800 ms between lines (line-level replay source for S20/S25/P006/P007/P008/LS013/LS014/LS015 uses T8: "I'm fine! Excuse me, Nina — see you!") |
| A1-C01-AUD045 | challenge dialogue | challenge_natural_slow | LEO: "Hello! Good afternoon!" … MAYA: "Good afternoon! What's your name?" … LEO: "My name is Leo. I'm Leo." … MAYA: "Nice to meet you, Leo! I'm Maya." … LEO: "Nice to meet you, Maya! How are you?" … MAYA: "I'm great, thank you! And you?" … LEO: "Not bad! Excuse me, Maya — see you!" |
| A1-C01-AUD046 | testlet 2 stimulus (detail) | learning_slow_clear | ALEX: "Hello! What's your name?" … NINA: "My name is Nina Petrova." … ALEX: "Nice to meet you, Nina!" … NINA: "Thank you!" |

All records: `qa_status: script_review`; `transcript_release: after_response` on testlet stimulus uses (gist/detail/challenge), `always_in_practice` on line models.

---

## Illustration briefs — 8 complete placeholder records (ILL023–ILL030)

Style constant and negative base identical to Lesson 1; every `generation_prompt` MUST carry the full STYLE prefix and negative suffix verbatim (see `A1_C01_L01_LESSON.md`); abbreviated below only as "STYLE" / "NEG" for readability — **the emitted brief in the app pipeline must include them in full.**

```yaml
id: A1-C01-ILL023
status: placeholder
content_purpose: conversation
semantic_target: storyboard panel 1 — the arrival (gist support)
must_show: [Nina walking toward the welcome table, Maya behind the table, morning light]
must_not_show: [text, closed eyes, turned backs]
characters: [Nina Petrova, Maya Haddad]
setting: welcome table, Community House, morning
action: arrival wave
composition: wide-medium, path leading to the table
camera_distance: wide
aspect_ratio: "16:9"
background_complexity: medium
continuity_requirements: [Nina + Maya model sheets; table from ILL001]
alt_text: Nina walks toward the welcome table where Maya waits, waving, in morning light
embedding_slot: S20 panel 1; LS001 stimulus
generation_prompt: "STYLE; SUBJECT: a woman with grey-streaked dark hair in a low bun and a teal cardigan walks toward an outdoor welcome table where a woman with dark wavy hair and a small star pin waits and waves, morning light; COMPOSITION: wide-medium shot, path leading to the table, 16:9; MUST SHOW: arrival wave from Maya; walking direction toward the table; morning light; NEG; ALT: Nina walks toward the welcome table where Maya waits, waving, in morning light."
```

```yaml
id: A1-C01-ILL024
status: placeholder
content_purpose: conversation
semantic_target: storyboard panel 2 — welcome (T2)
must_show: [Maya's open welcoming gesture toward Nina, warm smile]
must_not_show: [text, objects exchanged]
characters: [Maya Haddad, Nina Petrova]
setting: welcome table
action: welcoming gesture
composition: medium two-shot over the table
camera_distance: medium
aspect_ratio: "16:9"
background_complexity: low
continuity_requirements: [both model sheets]
alt_text: Maya makes a warm open welcome gesture toward Nina across the welcome table
embedding_slot: S20 panel 2
generation_prompt: "STYLE; SUBJECT: a woman with dark wavy hair in an olive jacket stands behind a welcome table making a warm open-palm welcome gesture toward a woman in a teal cardigan, both smiling; COMPOSITION: medium two-shot across the table, 16:9; MUST SHOW: open welcoming palm; warm mutual smiles; NEG; ALT: Maya makes a warm open welcome gesture toward Nina across the welcome table."
```

```yaml
id: A1-C01-ILL025
status: placeholder
content_purpose: conversation
semantic_target: storyboard panel 3 — the name exchange (T3–T4)
must_show: [both speakers' blank chest badges visible, questioning and answering postures]
must_not_show: [text on badges, other people]
characters: [Nina Petrova, Maya Haddad]
setting: welcome table
action: asking and giving names
composition: medium symmetrical two-shot, badges mid-frame
camera_distance: medium
aspect_ratio: "16:9"
background_complexity: low
continuity_requirements: [badge geometry from ILL018]
alt_text: Nina and Maya face each other at the table, blank name badges visible, as they ask and give their names
embedding_slot: S20 panel 3; LS001 option A; CV003/004 stimulus
generation_prompt: "STYLE; SUBJECT: two women face each other across a welcome table, one with an open asking hand, the other gesturing toward her own blank chest badge, both badges clearly visible; COMPOSITION: medium symmetrical two-shot, badges mid-frame and readable as blank shapes, 16:9; MUST SHOW: two blank badges; asking hand; answering self-gesture; NEG; ALT: Nina and Maya face each other at the table, blank name badges visible, as they ask and give their names."
```

```yaml
id: A1-C01-ILL026
status: placeholder
content_purpose: conversation
semantic_target: storyboard panel 4 — the meeting moment (T5–T6)
must_show: [two women shaking hands or hand-over-heart warmth, first-meeting energy]
must_not_show: [text, hugging]
characters: [Nina Petrova, Maya Haddad]
setting: welcome table
action: first-meeting warmth
composition: medium two-shot, joined hands centered
camera_distance: medium
aspect_ratio: "16:9"
background_complexity: low
continuity_requirements: [both model sheets]
alt_text: Nina and Maya clasp hands warmly at their first meeting, both smiling
embedding_slot: S20 panel 4
generation_prompt: "STYLE; SUBJECT: a woman in a teal cardigan and a woman in an olive jacket clasp hands warmly over a welcome table, genuine first-meeting smiles; COMPOSITION: medium two-shot, joined hands centered, 16:9; MUST SHOW: clasped hands; two genuine smiles; eye contact; NEG; ALT: Nina and Maya clasp hands warmly at their first meeting, both smiling."
```

```yaml
id: A1-C01-ILL027
status: placeholder
content_purpose: conversation
semantic_target: storyboard panel 5 — the polite exit (T8)
must_show: [Maya stepping toward the table cups, turning back mid-wave to Nina; Nina waving back]
must_not_show: [text, sad faces]
characters: [Maya Haddad, Nina Petrova]
setting: welcome table with cups
action: polite parting
composition: wide-medium, space opening between them
camera_distance: wide
aspect_ratio: "16:9"
background_complexity: medium
continuity_requirements: [table from ILL001]
alt_text: Maya steps toward the cups, turning back to wave; Nina waves back — a polite goodbye
embedding_slot: S20 panel 5; CV011/012; LS015 option A; P008 stimulus
generation_prompt: "STYLE; SUBJECT: a woman with dark wavy hair steps toward a welcome table with cups, body angled away but head turned back mid-wave to a woman in a teal cardigan who waves back; COMPOSITION: wide-medium shot, opening space between the two, 16:9; MUST SHOW: turned-back wave; answering wave; cups on the table; NEG; ALT: Maya steps toward the cups, turning back to wave; Nina waves back — a polite goodbye."
```

```yaml
id: A1-C01-ILL028
status: placeholder
content_purpose: conversation
semantic_target: challenge scene — café terrace afternoon meeting
must_show: [Leo at the café terrace greeting Maya, high afternoon sun, short shadows]
must_not_show: [text, evening light, morning light]
characters: [Leo Novak, Maya Haddad]
setting: Aroa Café terrace, afternoon
action: greeting across a small terrace table
composition: medium two-shot, terrace rails behind
camera_distance: medium
aspect_ratio: "16:9"
background_complexity: medium
continuity_requirements: [Leo + Maya model sheets; terrace from ILL003]
alt_text: Leo waves to Maya from the café terrace under a high afternoon sun
embedding_slot: S23 stimulus; LS008; CV015 stimulus
generation_prompt: "STYLE; SUBJECT: a tall man with curly auburn hair and a beard in a blue apron waves from a café terrace to a woman with dark wavy hair arriving, high sun with very short shadows; COMPOSITION: medium two-shot across a small terrace table, terrace rails behind, 16:9; MUST SHOW: high afternoon sun; short shadows; friendly wave; NEG; ALT: Leo waves to Maya from the café terrace under a high afternoon sun."
```

```yaml
id: A1-C01-ILL029
status: placeholder
content_purpose: reading
semantic_target: two name badges side by side (text-overlay surface)
must_show: [two blank badges lying side by side on the welcome table, top and bottom line shapes visible on each]
must_not_show: [any letters, names, logos]
characters: []
setting: welcome table surface
action: badge display
composition: top-down slight angle, badges left and right
camera_distance: top_down
aspect_ratio: "16:9"
background_complexity: low
continuity_requirements: [badge geometry from ILL018, twice]
alt_text: Two blank name badges lie side by side on the welcome table, each with an empty top and bottom line
embedding_slot: S27 (RD001–004 text overlay host)
generation_prompt: "STYLE; SUBJECT: two blank name badges lying side by side on a wooden welcome-table surface, each showing two empty line shapes (shorter top, longer bottom) with no writing; COMPOSITION: top-down slight angle, one badge left, one right, generous margins for app text overlay, 16:9; MUST SHOW: two badges; four empty line shapes; clean blank surfaces; NEG; ALT: Two blank name badges lie side by side on the welcome table, each with an empty top and bottom line."
```

```yaml
id: A1-C01-ILL030
status: placeholder
content_purpose: reading
semantic_target: welcome card (text-overlay surface)
must_show: [a small blank card standing on the welcome table, two empty line shapes]
must_not_show: [any letters, logos]
characters: []
setting: welcome table
action: card display
composition: slight top-down angle, card centered
camera_distance: close
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [palette continuity with ILL001]
alt_text: A small blank welcome card stands on the table with two empty lines where a greeting and a name can go
embedding_slot: S28 (RD005–006 text overlay host)
generation_prompt: "STYLE; SUBJECT: a small blank paper card standing upright on a wooden welcome table, showing two empty line shapes and no writing; COMPOSITION: slight top-down angle, card centered with generous margins for app text overlay, 1:1; MUST SHOW: standing card; two empty lines; clean blank surface; NEG; ALT: A small blank welcome card stands on the table with two empty lines where a greeting and a name can go."
```

All 8: `answer_leakage_check: pass` (LS001's options are panel images of participants — the stimulus audio, not the image, carries the answer; CV013 options are three distinct character sheets), `cultural_review: pass`, `accessibility_review: pass`.

---

## Accessibility and integrity notes (lesson-level)

- Testlet stimuli: transcripts unlock only after each testlet's last response; one default replay (diagnostic); challenge take's single-play default can be replayed once via the help path — never penalized.
- Reading items present text in the app layer only; Dynamic Type to XL; no time pressure; reading is never solved by auto-playing audio (audio link appears post-response).
- Tile tasks everywhere are tap-sequence based — no dragging, no precision.
- Non-audio route: all LS items offer a text/scene equivalent reporting listening `not measured`; CV016/P007/P008/P010 have tap-only alternatives.
- VoiceOver order per screen: stimulus → prompt → options → help; storyboard panels read their alt-texts between dialogue turns.

## Ledger delta and register usage

- No new lexical/grammar targets (this lesson applies and retrieves taught items — encounters #4 for Sets C/D/E and G001–G003 via dialogue + practice; L4 quiz is the assessment encounter).
- `ILLUSTRATION_ID_REGISTER.csv`: 30 of 40 used; next `A1-C01-ILL031`.
- Audio: next `A1-C01-AUD047`. Practice IDs used: CV001–016, LS001–016, P005–P010, RD001–008, WR001–002.
- Chapter banks: vocabulary 36/36 ✓ · grammar 30/30 ✓ · pronunciation 10/10 ✓ · conversation 16/16 ✓ · listening 16/16 ✓ · reading 8/8 ✓ · writing 2/6 (L4 adds 4).
- Bible facts added (this session, before authoring): Nina↔Maya and Maya↔Leo first meetings.
