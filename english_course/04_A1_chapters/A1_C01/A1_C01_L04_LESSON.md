# A1-C01-L04 — Lesson 4: The Welcome Mission

Chapter 1 · Hello! My Name Is Alex · Lesson type M (assembly steps 13–15 + chapter wrap-up)
Core time ≈ 20 min · prerequisites: A1-C01-L01–L03 taught · **chapter-completion session**

**Focus:** mission/AI roleplay (step 13), mixed quiz Form A (step 14), results/repair/spaced review (step 15), chapter wrap-up + QA lens table + chapter gate.
**Screens:** S30–S37. **New assets:** 1 audio (AUD047), 4 illustration briefs (ILL031–ILL034 — fresh quiz skins; assessment options never reuse the exact input-card art).
**Practice bank added:** guided writing 4 (PR-WR003–006) → chapter banks complete: **122 practice items** (36 V + 30 G + 16 CV + 16 LS + 10 P + 8 RD + 6 WR). Quiz Form A: 22 items.
**Cumulative share note:** the 15–25% cumulative rule activates from Chapter 2; Chapter 1 has no prior chapters, so all 22 items are current-chapter items.

---

## STEP 13 — Mission and AI roleplay (≈ 5 min) · Screens S30–S31

### Mission brief (S30)

> **Your mission: go to the welcome event.**
> Maya is at the table. Say hello. Give your name. Ask Maya's name. Ask how she is. Close politely.
> [ILL: A1-C01-ILL023 | alt: Nina walks toward the welcome table where Maya waits, waving, in morning light]

Mission checklist (visual, icon-led): ① greet ② give your name ③ ask a name ④ one `How are you?` exchange ⑤ polite close. Completing all five — by voice **or** by tiles — completes the mission (low-stakes, ungraded, retryable).

**UI/UX tip — S30:** Frame the mission as the story payoff, not a test: the five checklist items mirror the AUD043 dialogue beats exactly, so the learner recognizes every step. Offer two equal entry buttons — "Speak" (mic) and "Tap" (branching fallback) — same size, same color family; the choice is recorded for analytics but never judged. Mic permission (if not already granted) is requested here with the plain privacy notice.

### AI roleplay spec — A1-C01-RP001 (full §10.9 contract)

```yaml
id: A1-C01-RP001
scenario: "You arrive at the Aroa Community House welcome table. Maya, the helper, greets you."
learner_role: "a new arrival at the welcome event"
ai_role: "Maya Haddad — warm, unhurried, speaks only taught A1 language"
communicative_goal: "greet, give your own name, ask Maya's name, one How-are-you? exchange, close politely"
turn_limit: 8
allowed_topics: [greetings, names, states, polite closing]
allowed_intents: [greet, give_name, ask_name, ask_state, answer_state, thank, close]
required_slots: [learner_name, name_exchange_completed, one_state_exchange]
target_vocabulary_ids: [A1-C01-L01-V001, V002, V006, V008, V010, A1-C01-L02-V016, V017, V018, V019, V020, V024, V025, V026, V027, V028, V029, V030]
target_grammar_ids: [A1-C01-L02-G001, G002, G003]
accepted_response_examples:
  - "Hello!" / "Hi!" / "Good morning!"
  - "My name is Sam." / "I'm Sam." (any name; first+last optional)
  - "What's your name?"
  - "How are you?"
  - "I'm good/fine/okay/great, thank you! And you?" / "Not bad! And you?"
  - "Nice to meet you!" / "Nice to meet you, Maya!"
  - "Thank you! See you!" / "Excuse me — goodbye!" / "Bye, Maya!"
acceptable_variants: [any time-appropriate greeting; any taught state; formal My name is… or friendly I'm…; any close from the branch map; ASR-mangled names accepted if any plausible name is heard]
known_language_ceiling: [ledger status = taught (V001–V030, G001–G003) + [CHUNK:survival] "You're welcome!"]
off_topic_redirect_1: "Maya smiles: 'Nice! … What's your name?'"
off_topic_redirect_2: "Maya waves gently: 'Excuse me! … See you!' (roleplay ends safely; retry offered)"
end_condition_success: "all required slots filled within 8 turns → Maya: 'Nice to meet you, <name>! See you!' + mission checklist fills"
end_condition_safe_stop: "8 turns used, two redirects used, or learner taps stop → friendly close, partial checklist kept, retry always offered"
feedback_dimensions: [task_achievement, intelligibility, vocabulary_use, grammar_use]
feedback_timing: after_roleplay
privacy_notice_required: true
non_voice_alternative: branching_dialogue
```

**Behaviour notes (bind the implementation):** Maya opens with `Hello! Welcome! What's your name?`; asks exactly one thing per turn; accepts any name; mirrors the learner's chosen formality; uses the ask-back only after the learner answers `How are you?`. Post-roleplay feedback names two strengths + at most one next step (e.g., "Strong: you gave your name clearly. Next: try And you? after your state."). No accent, speed, or personality commentary ever. Voice data: processed on-device where possible, deletable, never required (tap path always available).

**UI/UX tip — S31:** Chat-style roleplay view: Maya's face + speech bubble (tappable replay), learner's turn via mic button or tile picker (the substitution table as tiles: greeting / name / state / close groups). Checklist sits as a compact ribbon of five dots that fill live. Safe-stop button always visible, labeled with the loop-arrow icon. After the roleplay, transcript is fully visible (practice context) and each Maya line replays on tap.

**Non-voice branching alternative (same mission, same slots):** four tile steps mirroring CV014's two-blank mechanic — ① choose greeting (5 options) ② build `My name is …` with editable name tile ③ choose Maya-question to ask (`What's your name?` / `How are you?` — both accepted, name question required for full checklist) ④ choose close. Maya's replies come from AUD044 line models.

---

## STEP 14 — Mixed quiz Form A (≈ 7 min) · Screens S32–S33

**Structure (22 items):** vocabulary 6 · grammar 6 · listening 4 · reading 2 · discourse 2 · guided writing 2. One skill per screen-swap; no section headers that reveal the skill mix; item order interleaved (V-G-LS-V-CN-G-…). Answers and rationales live in creator records only — never in the delivery payload.

```json
{
  "id": "A1-C01-QZ-V001",
  "content_version": "1.0.0",
  "assessment_context": "chapter_quiz",
  "component": "vocabulary",
  "subskill": "recognise_politeness_audio",
  "cefr_level_hypothesis": "A1",
  "construct": "Identify the gratitude word thanks in isolation",
  "prerequisite_ids": ["A1-C01-L01-V011"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD012", "illustration_asset_id": null},
  "prompt": "Listen. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"thanks"},{"id":"B","text":"sorry"},{"id":"C","text":"hello"}],
  "correct_option_ids": ["A"],
  "rationale": "The audio says thanks.",
  "distractor_rationales": {"B":"sorry is for small problems","C":"hello is a greeting"},
  "feedback_correct": "Yes — thanks!",
  "feedback_incorrect": "One small word for a small thank-you.",
  "hint_ladder": ["Replay; the receiving picture lights up.","One option is a greeting. Remove it."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-V002",
  "assessment_context": "chapter_quiz",
  "component": "vocabulary",
  "subskill": "choose_greeting_for_arrival_scene",
  "construct": "Match a greeting to an arriving-person scene",
  "prerequisite_ids": ["A1-C01-L01-V001","A1-C01-L01-V006"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL031"},
  "prompt": "Look. Choose. The meeting starts:",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Goodbye!"},{"id":"B","text":"Hello!"},{"id":"C","text":"See you!"}],
  "correct_option_ids": ["B"],
  "rationale": "A person walks toward the door waving — the meeting starts with a greeting.",
  "distractor_rationales": {"A":"goodbye ends meetings","C":"see you ends meetings"},
  "feedback_correct": "Yes — hello starts the meeting!",
  "feedback_incorrect": "The person ARRIVES. Which words open a meeting?",
  "hint_ladder": ["Look at the feet and the door.","Two options end talks."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-V003",
  "assessment_context": "chapter_quiz",
  "component": "listening",
  "subskill": "match_time_greeting_to_scene",
  "construct": "Match the heard time greeting to the correct scene",
  "prerequisite_ids": ["A1-C01-L01-V005"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD006", "illustration_asset_id": null},
  "prompt": "Listen. Match.",
  "response_type": "image_choice",
  "options": [{"id":"A","illustration_asset_id":"A1-C01-ILL002"},{"id":"B","illustration_asset_id":"A1-C01-ILL004"},{"id":"C","illustration_asset_id":"A1-C01-ILL003"}],
  "correct_option_ids": ["B"],
  "rationale": "Good evening matches the dark, lamplit scene.",
  "distractor_rationales": {"A":"morning has a low rising sun","C":"afternoon has a high sun"},
  "feedback_correct": "Yes — evening!",
  "feedback_incorrect": "Listen for the time word, then look at the sky.",
  "hint_ladder": ["Replay; one scene lights up per word.","Two scenes are daylight."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","alt_text_parallel_options"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-V004",
  "assessment_context": "chapter_quiz",
  "component": "vocabulary",
  "subskill": "choose_politeness_word_for_scene",
  "construct": "Choose the receiver's politeness word for a giving scene",
  "prerequisite_ids": ["A1-C01-L01-V010"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL032"},
  "prompt": "Look. Choose. Nina gets the box. Nina says:",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Excuse me"},{"id":"B","text":"Sorry!"},{"id":"C","text":"Thank you!"}],
  "correct_option_ids": ["C"],
  "rationale": "Nina receives — the gratitude word fits.",
  "distractor_rationales": {"A":"excuse me passes or exits","B":"no problem happened"},
  "feedback_correct": "Yes — thank you!",
  "feedback_incorrect": "Nina GETS the box. Which word is for getting?",
  "hint_ladder": ["Look at the hands — give and get.","One word is only for problems."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-V005",
  "assessment_context": "chapter_quiz",
  "component": "listening",
  "subskill": "match_state_audio_to_face",
  "construct": "Match the heard state word to the correct face",
  "prerequisite_ids": ["A1-C01-L02-V018"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD022", "illustration_asset_id": null},
  "prompt": "Listen. Match.",
  "response_type": "image_choice",
  "options": [{"id":"A","illustration_asset_id":"A1-C01-ILL016"},{"id":"B","illustration_asset_id":"A1-C01-ILL015"},{"id":"C","illustration_asset_id":"A1-C01-ILL013"}],
  "correct_option_ids": ["B"],
  "rationale": "Okay matches the level so-so hand.",
  "distractor_rationales": {"A":"great has both arms up","C":"good has the full warm smile"},
  "feedback_correct": "Yes — okay!",
  "feedback_incorrect": "Listen again — a middle word.",
  "hint_ladder": ["Replay; faces light up in order.","One face has arms high. Remove it."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","alt_text_parallel_options"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-V006",
  "assessment_context": "chapter_quiz",
  "component": "vocabulary",
  "subskill": "match_greeting_to_time_strip",
  "construct": "Choose the time-appropriate greeting for the evening panel of a scene strip",
  "prerequisite_ids": ["A1-C01-L01-V005"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL034"},
  "prompt": "Look. Choose. Panel three (dark sky):",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Good morning!"},{"id":"B","text":"Good evening!"},{"id":"C","text":"Bye!"}],
  "correct_option_ids": ["B"],
  "rationale": "The dark lamplit panel takes the evening greeting.",
  "distractor_rationales": {"A":"morning matches the low-sun panel","C":"a farewell does not open a meeting"},
  "feedback_correct": "Yes — good evening!",
  "feedback_incorrect": "Find the dark panel. Its sky and lamps ask for one greeting.",
  "hint_ladder": ["Look at panel three's sky and lamps.","Remove the goodbye."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-G001",
  "assessment_context": "chapter_quiz",
  "component": "grammar",
  "subskill": "choose_possessive_self",
  "construct": "Select my for the speaker's own badge",
  "prerequisite_ids": ["A1-C01-L02-G002"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL033"},
  "prompt": "Sam's badge. Sam says: '____ name is Sam.'",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"My"},{"id":"B","text":"Your"},{"id":"C","text":"And"}],
  "correct_option_ids": ["A"],
  "rationale": "Own badge → my.",
  "distractor_rationales": {"B":"your = the other person's badge","C":"not a badge word"},
  "feedback_correct": "Yes — my!",
  "feedback_incorrect": "Whose badge? Sam's OWN badge.",
  "hint_ladder": ["Self or other?","One option is not a badge word."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-G002",
  "assessment_context": "chapter_quiz",
  "component": "grammar",
  "subskill": "choose_be_form_with_I",
  "construct": "Select am with I",
  "prerequisite_ids": ["A1-C01-L02-G001"],
  "stimulus": {"text": "I ___ Sam.", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"are"},{"id":"B","text":"is"},{"id":"C","text":"am"}],
  "correct_option_ids": ["C"],
  "rationale": "I takes am.",
  "distractor_rationales": {"A":"are goes with you","B":"is is not taught with I or you"},
  "feedback_correct": "Yes — I am Sam!",
  "feedback_incorrect": "With I, use am.",
  "hint_ladder": ["Say it aloud: I am…","One option belongs with you."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": [],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-G003",
  "assessment_context": "chapter_quiz",
  "component": "grammar",
  "subskill": "choose_be_form_with_you",
  "construct": "Select are with you",
  "prerequisite_ids": ["A1-C01-L02-G001"],
  "stimulus": {"text": "You ___ Sam!", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"are"},{"id":"B","text":"am"},{"id":"C","text":"is"}],
  "correct_option_ids": ["A"],
  "rationale": "you takes are.",
  "distractor_rationales": {"B":"am goes with I","C":"is is not taught with I or you"},
  "feedback_correct": "Yes — You are Sam!",
  "feedback_incorrect": "With you, use are.",
  "hint_ladder": ["Say it aloud: You are…","One option belongs with I."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": [],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-G004",
  "assessment_context": "chapter_quiz",
  "component": "grammar",
  "subskill": "choose_possessive_in_question_chunk",
  "construct": "Select your inside the name question",
  "prerequisite_ids": ["A1-C01-L02-V026"],
  "stimulus": {"text": "What's ____ name?", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"my"},{"id":"B","text":"you"},{"id":"C","text":"your"}],
  "correct_option_ids": ["C"],
  "rationale": "The chunk asks the other person's name → your.",
  "distractor_rationales": {"A":"my asks about the speaker's own name","B":"you needs are"},
  "feedback_correct": "Yes — What's your name?",
  "feedback_incorrect": "You ask about THEIR name.",
  "hint_ladder": ["Point outward — whose name?","One option needs are after it."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": [],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-G005",
  "assessment_context": "chapter_quiz",
  "component": "grammar",
  "subskill": "produce_short_form",
  "construct": "Contract I am to I'm in a sentence",
  "prerequisite_ids": ["A1-C01-L02-G001"],
  "stimulus": {"text": "I am Sam. → short friendly form: ____ Sam.", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"I'm"},{"id":"B","text":"Im"},{"id":"C","text":"I"}],
  "correct_option_ids": ["A"],
  "rationale": "I am joins to I'm with the apostrophe.",
  "distractor_rationales": {"B":"missing the apostrophe","C":"the verb disappeared"},
  "feedback_correct": "Yes — I'm Sam!",
  "feedback_incorrect": "Join I and am — keep the little hook.",
  "hint_ladder": ["Say it fast — two words melt.","One option lost the hook; one lost the verb."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": [],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-G006",
  "assessment_context": "chapter_quiz",
  "component": "grammar",
  "subskill": "choose_correct_sentence",
  "construct": "Identify the correctly formed introduction sentence",
  "prerequisite_ids": ["A1-C01-L02-G002"],
  "stimulus": {"text": "One is correct:", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Me name is Sam."},{"id":"B","text":"My name is Sam."},{"id":"C","text":"My name Sam."}],
  "correct_option_ids": ["B"],
  "rationale": "my + name + is + name + period.",
  "distractor_rationales": {"A":"me → my","C":"missing is"},
  "feedback_correct": "Yes — perfect introduction!",
  "feedback_incorrect": "Check the badge word and the little verb.",
  "hint_ladder": ["Read each aloud.","Two options each miss one piece."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": [],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-LS001",
  "assessment_context": "chapter_quiz",
  "component": "listening",
  "subskill": "identify_first_name_fresh_speaker",
  "construct": "Identify the first name in a fresh check-in exchange",
  "prerequisite_ids": ["A1-C01-L02-V022"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD047", "illustration_asset_id": "A1-C01-ILL033"},
  "prompt": "Listen. Choose. First name:",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Sam"},{"id":"B","text":"Rivera"},{"id":"C","text":"Maya"}],
  "correct_option_ids": ["A"],
  "rationale": "My name is Sam Rivera — first name Sam.",
  "distractor_rationales": {"B":"the last name","C":"the other speaker"},
  "feedback_correct": "Yes — Sam!",
  "feedback_incorrect": "Listen to the words after My name is.",
  "hint_ladder": ["Replay the first line.","The FIRST name comes first."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-LS002",
  "assessment_context": "chapter_quiz",
  "component": "listening",
  "subskill": "identify_state_fresh_speaker",
  "construct": "Identify the male speaker's state answer",
  "prerequisite_ids": ["A1-C01-L02-V018"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD047", "illustration_asset_id": null},
  "prompt": "Listen. Choose. How is Sam?",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"great"},{"id":"B","text":"okay"},{"id":"C","text":"fine"}],
  "correct_option_ids": ["B"],
  "rationale": "Sam answers I'm okay, thank you!",
  "distractor_rationales": {"A":"great is MAYA's answer","B→note":"(correct)","C":"fine is not said"},
  "feedback_correct": "Yes — okay!",
  "feedback_incorrect": "Listen for SAM's feeling word (the man).",
  "hint_ladder": ["Replay Sam's second line.","One state belongs to Maya."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-LS003",
  "assessment_context": "chapter_quiz",
  "component": "listening",
  "subskill": "identify_speaker_by_line_reuse",
  "construct": "Attribute the excuse-me line to the correct speaker in the model dialogue",
  "prerequisite_ids": ["A1-C01-L01-V013"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD043", "illustration_asset_id": null},
  "prompt": "Listen. Choose. Who says 'Excuse me'?",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Nina"},{"id":"B","text":"Alex"},{"id":"C","text":"Maya"}],
  "correct_option_ids": ["C"],
  "rationale": "Maya says Excuse me, Nina — see you! (T8).",
  "distractor_rationales": {"A":"Nina is the one being addressed","B":"Alex is not in this dialogue"},
  "feedback_correct": "Yes — Maya politely exits!",
  "feedback_incorrect": "Listen to the END of the dialogue — who steps away?",
  "hint_ladder": ["Replay the last line.","The speaker says a NAME after excuse me — whose?"],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-LS004",
  "assessment_context": "chapter_quiz",
  "component": "listening",
  "subskill": "identify_setting_challenge_reuse",
  "construct": "Identify the setting of the challenge dialogue",
  "prerequisite_ids": ["A1-C01-L01-V004"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD045", "illustration_asset_id": null},
  "prompt": "Listen. Match. Where are they?",
  "response_type": "image_choice",
  "options": [{"id":"A","illustration_asset_id":"A1-C01-ILL028"},{"id":"B","illustration_asset_id":"A1-C01-ILL001"},{"id":"C","illustration_asset_id":"A1-C01-ILL007"}],
  "correct_option_ids": ["A"],
  "rationale": "The café terrace meeting (Leo + Maya, afternoon).",
  "distractor_rationales": {"B":"the community hall welcome event","C":"the park path farewell"},
  "feedback_correct": "Yes — the café!",
  "feedback_incorrect": "Good afternoon + Leo + Maya — where did they meet?",
  "hint_ladder": ["Replay the opening line.","Two scenes are from the morning event."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","alt_text_parallel_options"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-RD001",
  "assessment_context": "chapter_quiz",
  "component": "reading",
  "subskill": "read_badge_last_name",
  "construct": "Read the last name from a fresh badge",
  "prerequisite_ids": ["A1-C01-L02-V023"],
  "stimulus": {"text": "SAM RIVERA", "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL033"},
  "prompt": "Look. Choose. Last name:",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Sam"},{"id":"B","text":"Rivera"},{"id":"C","text":"Kim"}],
  "correct_option_ids": ["B"],
  "rationale": "The last name comes last on the badge.",
  "distractor_rationales": {"A":"the first name","C":"another cast member's last name"},
  "feedback_correct": "Yes — Rivera!",
  "feedback_incorrect": "The BOTTOM word is the last name.",
  "hint_ladder": ["Point to the bottom word.","One option is Alex's family name."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["dynamic_type_safe"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-RD002",
  "assessment_context": "chapter_quiz",
  "component": "reading",
  "subskill": "read_card_writer",
  "construct": "Identify the writer of a fresh two-line welcome card",
  "prerequisite_ids": ["A1-C01-L02-V024"],
  "stimulus": {"text": "Welcome! / My name is Maya. / Nice to meet you.", "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL030"},
  "prompt": "Look. Choose. The card is from:",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"Alex"},{"id":"B","text":"Leo"},{"id":"C","text":"Maya"}],
  "correct_option_ids": ["C"],
  "rationale": "The card states My name is Maya.",
  "distractor_rationales": {"A":"Alex wrote the L3 card — this one is new","B":"Leo is not named"},
  "feedback_correct": "Yes — Maya's card!",
  "feedback_incorrect": "Read the middle line.",
  "hint_ladder": ["Find My name is…","Two names are other cast members."],
  "estimated_seconds": 15,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["dynamic_type_safe"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-CN001",
  "assessment_context": "chapter_quiz",
  "component": "conversation",
  "subskill": "best_reply_to_state_question",
  "construct": "Choose the full state reply with ask-back",
  "prerequisite_ids": ["A1-C01-L02-V029","A1-C01-L02-V030"],
  "stimulus": {"text": "Maya: 'How are you?' You:", "audio_asset_id": "A1-C01-AUD032", "illustration_asset_id": null},
  "prompt": "Listen. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"My name is Sam."},{"id":"B","text":"I'm fine, thank you! And you?"},{"id":"C","text":"Good afternoon!"}],
  "correct_option_ids": ["B"],
  "rationale": "State answer + ask-back.",
  "distractor_rationales": {"A":"name answer","C":"a greeting, not an answer"},
  "feedback_correct": "Yes — feeling plus the ask-back!",
  "feedback_incorrect": "The question asks HOW you are.",
  "hint_ladder": ["Replay the question.","Remove the name answer."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-CN002",
  "assessment_context": "chapter_quiz",
  "component": "conversation",
  "subskill": "dialogue_order_four_turns",
  "construct": "Order a fresh four-turn first meeting",
  "prerequisite_ids": ["A1-C01-L02-V024","A1-C01-L02-V026","A1-C01-L02-V027"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C01-ILL032"},
  "prompt": "Put in order. First. Next. Last.",
  "response_type": "tile_order",
  "tiles": ["Hello! What's your name?", "My name is Sam.", "Nice to meet you, Sam!", "How are you?"],
  "correct_order": ["Hello! What's your name?", "My name is Sam.", "Nice to meet you, Sam!", "How are you?"],
  "rationale": "ask name → give name → meet → ask state.",
  "feedback_correct": "A brand-new meeting, in perfect order!",
  "feedback_incorrect": "Start with the name question.",
  "hint_ladder": ["Which line asks first?","The state question ends the sequence."],
  "estimated_seconds": 45,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["tap_only_no_drag"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-WR001",
  "assessment_context": "chapter_quiz",
  "component": "guided_writing",
  "subskill": "tile_question_sentence",
  "construct": "Build the name question with the question mark",
  "prerequisite_ids": ["A1-C01-L02-V026"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD030", "illustration_asset_id": "A1-C01-ILL020"},
  "prompt": "Put in order.",
  "response_type": "tile_order",
  "tiles": ["What's", "your", "name", "?"],
  "correct_order": ["What's", "your", "name", "?"],
  "rationale": "question chunk + question mark.",
  "feedback_correct": "What's your name? — with the asking hook!",
  "feedback_incorrect": "The asking hook (? ) ends the line.",
  "hint_ladder": ["Play the model and point.","The hook goes last."],
  "estimated_seconds": 30,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": ["tap_only_no_drag"],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

```json
{
  "id": "A1-C01-QZ-WR002",
  "assessment_context": "chapter_quiz",
  "component": "guided_writing",
  "subskill": "capitalisation_choice",
  "construct": "Identify correct capitalisation of an introduction sentence",
  "prerequisite_ids": ["A1-C01-L02-G001"],
  "stimulus": {"text": "One is correct:", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.",
  "response_type": "single_choice",
  "options": [{"id":"A","text":"my name is sam."},{"id":"B","text":"My name is Sam."},{"id":"C","text":"My Name Is Sam."}],
  "correct_option_ids": ["B"],
  "rationale": "Capital first word + capital name only; every-word capitals are wrong.",
  "distractor_rationales": {"A":"no capitals at all","C":"every word capitalized — names take capitals, not every word"},
  "feedback_correct": "Yes — big M, big Sam, small others!",
  "feedback_incorrect": "Check which words are BIG.",
  "hint_ladder": ["Point at each letter size.","One option has no big letters at all."],
  "estimated_seconds": 20,
  "scoring_weight": 1,
  "is_anchor": false,
  "pilot_stats": null,
  "accessibility_tags": [],
  "bias_review": "pending",
  "review_status": "reviewed"
}
```

**Quiz listening — new asset AUD047 (`learning_slow_clear`, verbatim):** SAM: "Hello! My name is Sam Rivera." … MAYA: "Nice to meet you, Sam! How are you?" … SAM: "I'm okay, thank you! And you?" … MAYA: "I'm great! Excuse me, Sam — see you!"

**UI/UX tips — S32/S33:** S32 sets expectations honestly: "22 quick items · about 7 minutes · you can pause" with the pause-anywhere guarantee and no streak/loss framing. S33 renders one item per screen-swap, interleaved skills, correct-position rotation, no section reveals. Listening items: single default replay; transcript unlocks only for review AFTER the whole quiz. A quiet progress bar (no countdown). VoiceOver: prompt → options in listed order; tile tasks number each tile as tapped.

---

## STEP 15 — Results, repair, spaced review (≈ 3 min) · Screens S34–S37

### Guided-writing practice (WR003–006, runs before the results summary as calm-down consolidation; S34a)

```yaml
id: A1-C01-PR-WR003
component: guided_writing
subskill: punctuation_choice
instruction: "Look. Choose."   # shown: Nice to meet you ___
tiles_options: [".", "?", "!"]
response_type: tile_choice
correct_option_ids: ["."]
rationale: the meeting chunk is a statement — a period ends it.
feedback_correct: "Yes — it tells, so it ends with the dot."
feedback_incorrect: "The voice goes DOWN — a telling dot."
hint_ladder: ["Say it — up or down at the end?","The asking hook is for questions."]
estimated_seconds: 20
accessibility_tags: [tap_only_no_drag]
```

```yaml
id: A1-C01-PR-WR004
component: guided_writing
subskill: build_welcome_card
instruction: "Look. Choose. One. Two."
stimulus: {illustration_asset_id: A1-C01-ILL030, audio_asset_id: null}
task: build YOUR two-line welcome card
line_1_options: ["Welcome!", "See you!", "Sorry!"]
line_2_options: ["My name is Sam.", "I'm fine.", "How are you?"]
correct_option_ids: ["Welcome!", "My name is Sam."]
rationale: a card welcomes + names its writer.
feedback_correct: "Your card is ready for the table!"
feedback_incorrect: "Line 1 says hello to everyone; line 2 gives your name."
hint_ladder: ["Which line works for EVERY reader?","Line 2 must give a name."]
estimated_seconds: 40
accessibility_tags: [tap_only_no_drag, dynamic_type_safe]
```

```yaml
id: A1-C01-PR-WR005
component: guided_writing
subskill: tile_sentence_first_name
instruction: "Put in order."
stimulus: {illustration_asset_id: A1-C01-ILL033, audio_asset_id: null}
tiles: ["My", "first", "name", "is", "Sam", "."]
response_type: tile_order
correct_order: ["My", "first", "name", "is", "Sam", "."]
rationale: the extended introduction sentence.
feedback_correct: "My first name is Sam. — six tiles, one sentence!"
feedback_incorrect: "Start with the badge words."
hint_ladder: ["Which three words sit together on the badge?","The dot goes last."]
estimated_seconds: 35
accessibility_tags: [tap_only_no_drag]
```

```yaml
id: A1-C01-PR-WR006
component: guided_writing
subskill: tile_sentence_friendly_variant
instruction: "Put in order."
stimulus: {illustration_asset_id: A1-C01-ILL019, audio_asset_id: A1-C01-AUD029}
tiles: ["I'm", "Nina", "."]
response_type: tile_order
correct_order: ["I'm", "Nina", "."]
rationale: the short friendly variant of the introduction.
feedback_correct: "I'm Nina. — short and friendly!"
feedback_incorrect: "The joined word comes first."
hint_ladder: ["Play the model.","The dot goes last."]
estimated_seconds: 20
accessibility_tags: [tap_only_no_drag]
```

### Gate and scoring (S34)

- **Pass:** ≥80% overall (≥18/22) **and** no core section below 70% (vocabulary ≥5/6 · grammar ≥5/6 · listening ≥3/4 · discourse+conversation ≥2/2… discourse section = CN001–002 + roleplay mission credit; writing counts toward overall, not a core gate at Ch1).
- **Near-pass (70–79% overall, or one core section below 70%):** route to the matching clinic (below) + alternate short form (**Form B** — generated in a dedicated follow-up session on owner request `form B`).
- **Below 70%:** personalised review route (clinic sequence + re-entry), unlimited time.
- **Unlimited retries with parallel content. No permanent lock. Mission completion (voice or tap) required alongside the quiz for the chapter badge.**

**Results copy follows the §14 pattern** (never labels the learner):

```text
Strong: You can greet, give your name, and say how you are.
Developing: Morning and evening greetings are close — the sun pictures help.
Next: the four-minute sun-and-sky review, then Chapter 2!
```

**UI/UX tip — S34:** Show the five can-do rings from S01 filling (greet / thank / name / ask / state), strengths first, one developing area max, one next step. No percentages-as-judgment; the number is available behind a tap for interested learners. Retry and continue buttons are equally weighted visually — no dark pattern.

### Remediation map + clinic seeds (S35)

| Error type (from item records) | Clinic seed | Trigger | Content spec (generated on activation) |
|---|---|---|---|
| time-greeting confusions (V003/QZ-V003/006) | `C1-CLIN-A sun-and-sky` | any 2 errors in time greetings | 8 items: audio→scene and scene→word, sun position/lamps as cues, new skins from ILL034 panels |
| my/your direction (G001-qz/G013-family errors) | `C1-CLIN-B whose-badge` | ≥2 direction errors | 8 items: badge-pointing scenes, self vs other, `My name is…`/`Your name is…` completion |
| I'm/you're person errors | `C1-CLIN-C self-or-other` | ≥2 person errors | 6 items: speaker-cue frames, I'm/You're/My triads, then tile build |
| chunk swaps (name↔state answers) | `C1-CLIN-D name-or-feeling` | ≥2 chunk-swap errors | 8 items: question-type sorting, reply matching, two-blank mini dialogues |
| name/state listening misses | `C1-CLIN-E names-and-feelings` | ≥2 listening errors | 6 items: fresh mini-exchanges (new names + states), first/last name detail, transcript-after-response |

Clinics are 6–10 items each, tap-only, ungraded, with the help ladder; each ends with 2 near-transfer items and updates the review schedule. (Specifications are complete; item authoring activates on first learner need or on owner request `clinic <id>`.)

**UI/UX tip — S35:** Remediation is offered as "practice picks" with icon + one-line benefit — never a red failure screen. The learner may skip everything; the schedule adapts either way.

### Spaced-review export list (S36)

Scheduler (app logic) receives this authored export — per §7.4 the app owns intervals; content supplies the retrieval opportunities:

| Target set | Exported review opportunities (already authored) | Next chapters' scheduled retrieval |
|---|---|---|
| Set A greetings/farewells | S10 warm-up, S09/S19 galleries, AUD017/035–037 replays | Ch2 warm-ups (L1), Ch4 retrieval 1, Checkpoint 1 |
| Set B politeness | S10 warm-up, galleries, dialogue T3/T7/T8 | Ch2 check-in conversation, Ch4, Ch9/10 service language |
| Set C states | S19, substitution drills CV005/006 | Ch2 warm-up, Ch4, Ch11 plans |
| Set D identity/chunks | dialogue package, RD/WR items, RP001 | Ch2 spelling/forms, Ch3 profiles, Checkpoint 1 |
| Set E state questions | dialogue + roleplay + CN items | Ch4, Ch11 invitations |
| G001–G003 | grammar bank, quiz, roleplay | Ch2 `Are you…?`, Ch3 full `be` paradigm |

### Chapter map / next (S37)

> ✦ **Chapter 1 complete!** You can say hello, give your name, ask how someone is, and close politely — in a real first meeting.
> Next: **Chapter 2 — Spell It and Share Your Details.**

**UI/UX tip — S36/S37:** S36 shows the review plan as a calm week-strip (no streak shaming; optional notifications off by default). S37 is the celebration peak: brief (≤3 s), mutable, reduced-motion safe; the chapter map shows Arc 1 (Chapters 1–4) with Chapter 1 filled — story progress, not point totals.

---

## Audio scripts — verbatim (1 new asset)

| ID | Purpose | Delivery | Verbatim script |
|---|---|---|---|
| A1-C01-AUD047 | quiz listening (fresh check-in) | learning_slow_clear | SAM: "Hello! My name is Sam Rivera." … MAYA: "Nice to meet you, Sam! How are you?" … SAM: "I'm okay, thank you! And you?" … MAYA: "I'm great! Excuse me, Sam — see you!" |

`transcript_release: after_response` (quiz stimulus). `qa_status: script_review`.

---

## Illustration briefs — 4 fresh quiz skins (ILL031–ILL034)

Macro convention as L3: `STYLE`/`NEG` tokens expand to the full constants defined in the lesson preambles at export (F3).

```yaml
id: A1-C01-ILL031
status: placeholder
content_purpose: assessment
semantic_target: arrival greeting scene (fresh skin)
must_show: [a friendly new character walking toward an open shop door, waving, daytime]
must_not_show: [text, leaving postures]
characters: [Sam Rivera — new friendly face: short curly dark hair, green t-shirt, canvas tote]
setting: corner shop street, day
action: arriving and waving
composition: medium-wide, door right, walker left
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [new character design registered here; reuse in Ch2+]
alt_text: A smiling person with short curly dark hair walks toward an open shop door, waving hello
embedding_slot: QZ-V002 stimulus; WR-adjacent
generation_prompt: "STYLE; SUBJECT: a smiling young man with short curly dark hair in a green t-shirt carrying a canvas tote walks toward an open shop door on the right, one hand raised in a hello wave; COMPOSITION: medium-wide shot, walker left, door right, plain daytime street, 1:1; MUST SHOW: walking direction toward the door; raised hello wave; open door; friendly face; NEG; ALT: A smiling person with short curly dark hair walks toward an open shop door, waving hello."
```

```yaml
id: A1-C01-ILL032
status: placeholder
content_purpose: assessment
semantic_target: giving-and-receiving scene (fresh skin)
must_show: [Sam giving a small box with both hands to Nina; Nina receiving with a warm smile]
must_not_show: [text, money, sad faces]
characters: [Sam Rivera, Nina Petrova]
setting: welcome table
action: giving and receiving
composition: medium two-shot, box centered
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [Nina model sheet; Sam from ILL031]
alt_text: Sam gives a small box with both hands to Nina, who receives it with a warm smile
embedding_slot: QZ-V004 stimulus; QZ-CN002 stimulus
generation_prompt: "STYLE; SUBJECT: a young man with short curly dark hair in a green t-shirt gives a small box with both hands to a woman with grey-streaked dark hair in a teal cardigan, who receives it with a warm grateful smile; COMPOSITION: medium two-shot, the box centered between them, welcome table softly behind, 1:1; MUST SHOW: both giver hands on the box; receiver's warm smile; clear give-and-get direction; NEG; ALT: Sam gives a small box with both hands to Nina, who receives it with a warm smile."
```

```yaml
id: A1-C01-ILL033
status: placeholder
content_purpose: assessment
semantic_target: Sam's name badge (fresh reading surface)
must_show: [one blank badge with the two-line schema, pinned on a green t-shirt]
must_not_show: [any letters, logos]
characters: [Sam Rivera torso]
setting: plain cream background
action: badge display
composition: torso crop centered on badge
camera_distance: close
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [badge geometry from ILL018]
alt_text: A blank name badge with two empty lines pinned to a green t-shirt
embedding_slot: QZ-G001, QZ-LS001, QZ-RD001, WR005 (app-layer text: SAM RIVERA)
generation_prompt: "STYLE; SUBJECT: a blank name badge pinned to a green t-shirt torso, showing the standard two empty line shapes — shorter top, longer bottom — with no writing; COMPOSITION: close torso crop centered on the badge, plain cream background, generous margins for app text overlay, 1:1; MUST SHOW: badge pin; two empty lines of different lengths; blank surface; NEG; ALT: A blank name badge with two empty lines pinned to a green t-shirt."
```

```yaml
id: A1-C01-ILL034
status: placeholder
content_purpose: assessment
semantic_target: time-of-day triple strip (fresh matching surface)
must_show: [three equal panels: low rising sun, high sun with short shadows, dark sky with warm lamps; the same street corner in all three]
must_not_show: [text, clocks, numbers]
characters: []
setting: one street corner, three times of day
action: none — scene strip
composition: strict triptych, equal panels, identical framing
camera_distance: wide
aspect_ratio: "16:9"
background_complexity: medium
continuity_requirements: [identical corner geometry across panels; parallel salience]
alt_text: The same street corner three times: low rising sun, high midday sun, and a dark sky with warm lamps
embedding_slot: QZ-V006 stimulus; C1-CLIN-A source
generation_prompt: "STYLE; SUBJECT: the same friendly street corner shown in three equal side-by-side panels — left: low rising sun with long soft shadows; middle: high bright sun with very short shadows; right: deep blue dark sky with two warm glowing street lamps; COMPOSITION: strict triptych, three equal panels with identical framing and corner geometry, 16:9; MUST SHOW: clearly different sun heights and shadow lengths; lamps only in the right panel; identical buildings across panels; NEG; ALT: The same street corner three times: low rising sun, high midday sun, and a dark sky with warm lamps."
```

All 4: `answer_leakage_check: pass`, `cultural_review: pass`, `accessibility_review: pass`. **New character registered:** Sam Rivera (he/him, 25, shop assistant — job noted for Ch3's jobs set; facts recorded in the bible by this session).

---

## Accessibility and integrity notes (lesson-level)

- Quiz: transcripts only after full-quiz review mode; one default replay per listening stimulus; no timers; latency unrecorded for scoring.
- Mission: voice and tap paths are fully equivalent for every required slot; privacy notice before mic; deletable recordings.
- All tile interactions tap-sequence; Dynamic Type throughout; celebration is brief, mutable, reduced-motion safe.
- Answer keys and rationales exist only in these creator records, never in the delivery payload.

## Ledger delta and register usage

- No new lexical/grammar targets. Practice IDs used: WR003–006, QZ-V001–006, QZ-G001–006, QZ-LS001–004, QZ-RD001–002, QZ-CN001–002, QZ-WR001–002; RP001.
- `ILLUSTRATION_ID_REGISTER.csv`: 34 of 40 used; next `A1-C01-ILL035`. Audio: next `A1-C01-AUD048`.
- **Chapter 1 banks complete:** vocabulary 36 · grammar 30 · conversation 16 · listening 16 · pronunciation 10 · reading 8 · guided writing 6 = 122 practice items + 22-item quiz Form A + mission roleplay.
