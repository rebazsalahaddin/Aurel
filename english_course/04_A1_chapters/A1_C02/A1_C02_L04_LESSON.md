# A1-C02-L04 — Lesson 4: The Register Mission

Chapter 2 · Spell It and Share Your Details · Lesson type M (assembly steps 13–15 + wrap-up)
Core time ≈ 18–20 min (mission 4–6 + quiz 8–10 + results/repair/review 3) · prerequisites: A1-C02-L01–L03

**Targets introduced:** none — assessment session. Everything retrieves L01–L03 and Chapter 1.
**Screens:** S32–S39. **Assets:** 1 audio script (AUD078 — Leo's quiz check-in), 4 illustration briefs (ILL033–036, the last of the C02 block).
**Quiz Form A:** 26 items — letters 5 · numbers 5 · vocabulary+repair 4 · grammar 5 · listening 4 · reading 2 · discourse 1. **Cumulative share: 4 items retrieving Chapter 1** (15.4%, within the 15–25% band; per-item `prerequisite_ids` cite `A1-C01-*`). Answer-key balance: 9 A / 9 B / 7 C over the 25 choice items.
**Fictional data (new this lesson, bible-registered):** Leo's phone `6-2-0, 1-5-4` · the learner's app sample card email `learner@aroa.com` (phone sample `5-5-5, 2-0-1`, name = the learner's own safe fictional choice, as in C1-L4).

---

## STEP 13 — Mission brief + AI roleplay (4–6 min) · Screens S32–S33

### S32 — Mission: The Register

> [ILL: A1-C02-ILL025 | alt: Nina holds up a blank badge toward smiling Maya across the check-in desk]
> **Your mission: check in at Nina's desk.**
> ① Badge check — "Are you …?" → "Yes, I am!"
> ② Spell your name — letter by letter
> ③ One detail — your phone number OR your email
> ④ The read-back — fix it, confirm it, or repair it
> ⑤ Close — "Thank you! See you!"

The learner's sample card (app layer): NAME — your choice (safe fictional, as C1-L4) · PHONE — `5-5-5, 2-0-1` · EMAIL — `learner@aroa.com`. **No real personal data, ever.**

**UI/UX tip — S32:** Five-slot checklist with empty rings (same component as the promise screens — rings fill live during the roleplay). The sample card is tappable mid-mission (a "peek card" that pauses the partner politely — Nina waits with a patient face). VoiceOver reads the checklist as one goal sentence.

### AI roleplay contract — A1-C02-RP001 (§10.9)

```yaml
id: A1-C02-RP001
scenario: registering for community classes at the Community House check-in desk
learner_role: a new member checking in
ai_role: Nina Petrova at the desk (patient, clear, warm; counts on her fingers; never rushed)
communicative_goal: complete the register — confirm the name, spell it, give ONE contact detail, survive the read-back, close politely
turn_limit: 8
allowed_topics: [the register, names and spelling, the sample phone number, the sample email, repair requests, greetings and farewells]
allowed_intents: [greet, confirm_name, spell_name, give_phone_detail, give_email_detail, request_repetition, request_slow_speech, thank, farewell]
required_slots: [name_confirmation, spelling, one_detail, read_back_resolution, close]
target_vocabulary_ids: [A1-C02-L01-V007, A1-C02-L01-V008, A1-C02-L01-V009, A1-C02-L02-V010..V018]
target_grammar_ids: [A1-C02-L02-G004, A1-C02-L02-G005]
accepted_response_examples:
  - "Yes, I am!"
  - "M, A, Y, A."                       # the learner's own fictional name, letter by letter
  - "It's 5-5-5, 2-0-1."
  - "It's learner dot aroa? — no: learner at aroa dot com."   # self-repair accepted warmly
  - "Can you repeat that, please?"
acceptable_variants:
  - "My name is …" before spelling
  - digits in any grouping
  - "Sorry — again, please?" as repair
  - read-back confirmed with "Yes!" or "Correct!"
known_language_ceiling: [A1-C01 all, A1-C02-L01–L03 all; nothing above number 20; no third-person be; no there-is]
off_topic_redirect_1: "Nina smiles and taps the register: 'One detail, please — the phone number or the email!'"
off_topic_redirect_2: "Nina holds up the badge card gently: 'Name first — how do you spell that?'"
end_condition_success: "all five rings filled → Nina writes the last row: 'Perfect! Welcome to the classes! See you!'"
end_condition_safe_stop: "8 turns or two redirects → Nina closes warmly: 'Okay! Again tomorrow? See you!' — rings stay filled where earned; retry offered, never pushed"
feedback_dimensions: [task_achievement, intelligibility, vocabulary_use, grammar_use]
feedback_timing: after_roleplay
privacy_notice_required: true            # "This practice uses your sample card only. No real data is stored."
non_voice_alternative: branching_dialogue
```

**Non-voice alternative (branching dialogue, same mission):** five nodes, each a 2–3-choice tap version of the roleplay beats — N1 badge check (tap the yes-answer) → N2 spelling (tap the letters of your card name on the chart) → N3 detail choice (tap phone OR email line) → N4 read-back event (Nina's read-back is WRONG — tap: repeat chunked / repair / confirm) → N5 close (tap the warm double close). Same rings, same end screens; reported as `non_voice_alternative_used`.

**Behaviour notes (§10.9):** one simple question at a time; Nina requests repetition once, then offers the phrase cards; semantically correct variants accepted; only mission-relevant corrections (badge check wording, digit accuracy); feedback after the exchange; ASR uncertainty never treated as learner error; accent/speed/personality never criticised.

---

## STEP 14 — Mixed quiz Form A (8–10 min) · Screens S34–S35

**Gate rule (manifest):** 80% overall (21/26) AND ≥70% per core section (letters/numbers/vocab+repair/grammar/listening/reading). Near-pass → clinic + alternate items; below → personalised review. Unlimited parallel retries; no permanent lock. Keys live in creator records only.

### Letters (QZ-L001–005)

```json
{
  "id": "A1-C02-QZ-L001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "letters", "subskill": "recognise_letter_name_audio", "cefr_level_hypothesis": "A1",
  "construct": "Identify an isolated letter name from the GA model",
  "prerequisite_ids": ["A1-C02-L01-PAT001"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD021", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"R"},{"id":"B","text":"I"},{"id":"C","text":"A"}],
  "correct_option_ids": ["A"],
  "rationale": "The audio says /ɑːr/ — R.",
  "distractor_rationales": {"B":"I is /aɪ/ — a gliding name","C":"A is /eɪ/ — rhymes with K"},
  "feedback_correct": "Yes — R!", "feedback_incorrect": "The open ahr name: R.",
  "hint_ladder": ["Play again; hold the first sound.", "Two options rhyme. The r-one."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","visual_letter_chart_route"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-L002", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "letters", "subskill": "recognise_letter_name_audio", "cefr_level_hypothesis": "A1",
  "construct": "Identify an isolated letter name from the GA model",
  "prerequisite_ids": ["A1-C02-L01-PAT001"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD022", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"M"},{"id":"B","text":"S"},{"id":"C","text":"X"}],
  "correct_option_ids": ["B"],
  "rationale": "The audio says /ɛs/ — S.",
  "distractor_rationales": {"A":"M is /ɛm/ — lips-closed ending","C":"X is /ɛks/ — ends in ks"},
  "feedback_correct": "Yes — S!", "feedback_incorrect": "The name ends in s-s-s.",
  "hint_ladder": ["Play again; feel the last sound.", "It ends like 'sorry' starts."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","visual_letter_chart_route"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-L003", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "letters", "subskill": "discriminate_confusable_letter_names", "cefr_level_hypothesis": "A1",
  "construct": "Discriminate /iː/-family letter names",
  "prerequisite_ids": ["A1-C02-L01-PAT001"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD017", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"B"},{"id":"B","text":"C"},{"id":"C","text":"E"}],
  "correct_option_ids": ["C"],
  "rationale": "The audio says /iː/ with no first consonant — E.",
  "distractor_rationales": {"A":"B is /biː/ — voiced b-start","B":"C is /siː/ — s-start"},
  "feedback_correct": "Yes — E! Just the pure long e.",
  "feedback_incorrect": "Say the three: bee, see, ee. The answer has NO start.",
  "hint_ladder": ["Play again; is there a consonant before the eee?", "No consonant → E."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","visual_letter_chart_route"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-L004", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "letters", "subskill": "discriminate_confusable_letter_names", "cefr_level_hypothesis": "A1",
  "construct": "Discriminate the /ɛ/+nasal pair M/N",
  "prerequisite_ids": ["A1-C02-L01-PAT001"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD020", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"L"},{"id":"B","text":"N"},{"id":"C","text":"F"}],
  "correct_option_ids": ["B"],
  "rationale": "The audio says /ɛn/ — N (the nose sound sits high).",
  "distractor_rationales": {"A":"L is /ɛl/ — tongue-tip ending","C":"F is /ɛf/ — air, no nose"},
  "feedback_correct": "Yes — N!", "feedback_incorrect": "M hums on the lips; N hums behind the teeth.",
  "hint_ladder": ["Touch your lips — do they close?", "No lip closure, nose on: N."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","visual_letter_chart_route"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-L005", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "letters", "subskill": "track_letter_position", "cefr_level_hypothesis": "A1",
  "construct": "Track letter position inside a written name",
  "prerequisite_ids": ["A1-C02-L01-PAT001"],
  "stimulus": {"text": "A L E X", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose the THIRD letter.", "response_type": "single_choice",
  "options": [{"id":"A","text":"E"},{"id":"B","text":"X"},{"id":"C","text":"L"}],
  "correct_option_ids": ["A"],
  "rationale": "A(1) L(2) E(3) X(4) — E is third.",
  "distractor_rationales": {"B":"X is fourth","C":"L is second"},
  "feedback_correct": "Yes — A, L, E: the third is E.",
  "feedback_incorrect": "Point and count: one, two, three.",
  "hint_ladder": ["Tap the letters one by one.", "A… L… E."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_letters","visual_only_construct"],
  "bias_review": "pending", "review_status": "draft"
}
```

### Numbers (QZ-N001–005)

```json
{
  "id": "A1-C02-QZ-N001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "numbers", "subskill": "recognise_number_audio", "cefr_level_hypothesis": "A1",
  "construct": "Identify a 6–20 number word by ear",
  "prerequisite_ids": ["A1-C02-L02-PAT005"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD044", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"7"},{"id":"B","text":"16"},{"id":"C","text":"17"}],
  "correct_option_ids": ["C"],
  "rationale": "The audio says seventeen — SEVEN returns with the long -teen.",
  "distractor_rationales": {"A":"seven is the short first part alone","B":"sixteen starts with six-"},
  "feedback_correct": "Yes — seventeen!", "feedback_incorrect": "Which first part returns? se-…",
  "hint_ladder": ["Play again; catch the first part.", "se- + teen = 17."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","digit_strip_reference"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-N002", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "numbers", "subskill": "recognise_number_audio", "cefr_level_hypothesis": "A1",
  "construct": "Identify a th-starting number word by ear",
  "prerequisite_ids": ["A1-C02-L02-PAT004"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD040", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"13"},{"id":"B","text":"3"},{"id":"C","text":"12"}],
  "correct_option_ids": ["A"],
  "rationale": "The audio says thirteen — long, th-starting.",
  "distractor_rationales": {"B":"three is the short one-beat first part","C":"twelve starts tw-"},
  "feedback_correct": "Yes — thirteen!", "feedback_incorrect": "Long word, th- start: thir-teen.",
  "hint_ladder": ["Short or long?", "Long th- word → 13."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","digit_strip_reference"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-N003", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "numbers", "subskill": "discriminate_number_pair", "cefr_level_hypothesis": "A1",
  "construct": "Discriminate six from its -teen family",
  "prerequisite_ids": ["A1-C02-L02-PAT003", "A1-C02-L02-PAT005"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD033", "illustration_asset_id": null},
  "prompt": "Listen. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"10"},{"id":"B","text":"6"},{"id":"C","text":"16"}],
  "correct_option_ids": ["B"],
  "rationale": "The audio says six — one beat, no -teen.",
  "distractor_rationales": {"A":"ten is a different first sound","C":"sixTEEN is the long family word"},
  "feedback_correct": "Yes — six! Short and clipped.",
  "feedback_incorrect": "The -teen words are LONG. This one is short.",
  "hint_ladder": ["Tap the beats.", "One beat → 6."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","digit_strip_reference"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-N004", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "numbers", "subskill": "read_number_word", "cefr_level_hypothesis": "A1",
  "construct": "Match a written number word to its digit",
  "prerequisite_ids": ["A1-C02-L02-PAT004"],
  "stimulus": {"text": "fifteen", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"14"},{"id":"B","text":"5"},{"id":"C","text":"15"}],
  "correct_option_ids": ["C"],
  "rationale": "fif- carries five, -teen adds ten: fifteen = 15.",
  "distractor_rationales": {"A":"fourteen is written with four-","B":"five is the short first part"},
  "feedback_correct": "Yes — fifteen = 15.", "feedback_incorrect": "Find the five hiding inside: fif-.",
  "hint_ladder": ["First part says five.", "fif + teen → 15."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_word","visual_only_construct"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-N005", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "numbers", "subskill": "count_objects", "cefr_level_hypothesis": "A1",
  "construct": "Count objects in a fresh organized array",
  "prerequisite_ids": ["A1-C02-L02-PAT004"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL033"},
  "prompt": "Look. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"9"},{"id":"B","text":"8"},{"id":"C","text":"10"}],
  "correct_option_ids": ["A"],
  "rationale": "Nine cups in a three-by-three grid.",
  "distractor_rationales": {"B":"a miscount of one row","C":"one too many"},
  "feedback_correct": "Yes — nine! Three rows of three.",
  "feedback_incorrect": "Tap the picture; count the pulses.",
  "hint_ladder": ["Count one row: three.", "Three rows of three = nine."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent","tap_to_count_support"],
  "bias_review": "pending", "review_status": "draft"
}
```

### Vocabulary + repair (QZ-V001–004; V004 cumulative)

```json
{
  "id": "A1-C02-QZ-V001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "vocabulary", "subskill": "choose_repair_chunk_situation", "cefr_level_hypothesis": "A1",
  "construct": "Select the repair chunk for an uncaught detail",
  "prerequisite_ids": ["A1-C02-L01-V008"],
  "stimulus": {"text": "Nina says her name one time. You do not hear it. You say:", "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL014"},
  "prompt": "Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"Please speak slowly."},{"id":"B","text":"Can you repeat that, please?"},{"id":"C","text":"What's your email address?"}],
  "correct_option_ids": ["B"],
  "rationale": "Got nothing → hear it again → the repeat question.",
  "distractor_rationales": {"A":"slowly is for words you caught but that raced","C":"that asks for a new detail, not the same one again"},
  "feedback_correct": "Yes — ask for it again!", "feedback_incorrect": "Nothing landed → one more time.",
  "hint_ladder": ["New detail, or the same words again?", "The repeat line."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent","situation_frame_narrated"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-V002", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "vocabulary", "subskill": "assemble_email_spoken_form", "cefr_level_hypothesis": "A1",
  "construct": "Place 'at' at the big break of a spoken email",
  "prerequisite_ids": ["A1-C02-L02-V015"],
  "stimulus": {"text": "maya dot haddad ___ aroa dot com", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Look. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"dot"},{"id":"B","text":"spell"},{"id":"C","text":"at"}],
  "correct_option_ids": ["C"],
  "rationale": "The big break (person → place) takes at.",
  "distractor_rationales": {"A":"dot is already used at the two small stops","B":"spell is for letter-by-letter"},
  "feedback_correct": "Yes — at! Person AT place.", "feedback_incorrect": "The small stops have dot. The BIG break takes…",
  "hint_ladder": ["Which break is biggest?", "at."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_string"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-V003", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "vocabulary", "subskill": "match_word_to_function", "cefr_level_hypothesis": "A1",
  "construct": "Match 'address' to its home sense",
  "prerequisite_ids": ["A1-C02-L02-V014"],
  "stimulus": {"text": "Where is your home? Your ___.", "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL020"},
  "prompt": "Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"address"},{"id":"B","text":"phone"},{"id":"C","text":"name"}],
  "correct_option_ids": ["A"],
  "rationale": "Where you live = your address.",
  "distractor_rationales": {"B":"the phone is a thing you call with","C":"your name is who you are"},
  "feedback_correct": "Yes — your address!", "feedback_incorrect": "The house picture: the home word.",
  "hint_ladder": ["Look at the house.", "address."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-V004", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "vocabulary", "subskill": "greeting_by_time", "cefr_level_hypothesis": "A1",
  "construct": "CUMULATIVE — choose the time-appropriate greeting (Chapter 1)",
  "prerequisite_ids": ["A1-C01-L01-V005"],
  "stimulus": {"text": null, "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL035"},
  "prompt": "Look. Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"good morning"},{"id":"B","text":"good evening"},{"id":"C","text":"good afternoon"}],
  "correct_option_ids": ["B"],
  "rationale": "Lamps lit, low amber light, day ending → good evening.",
  "distractor_rationales": {"A":"morning light is low-sun and fresh","C":"afternoon sun is high and bright"},
  "feedback_correct": "Yes — good evening!", "feedback_incorrect": "Look at the light: the day is ENDING.",
  "hint_ladder": ["Lamps on or sun high?", "Evening."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent","no_color_only_meaning"],
  "cumulative_flag": true, "bias_review": "pending", "review_status": "draft"
}
```

### Grammar (QZ-G001–005)

```json
{
  "id": "A1-C02-QZ-G001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "grammar", "subskill": "choose_question_form", "cefr_level_hypothesis": "A1",
  "construct": "Form the Are-you check question",
  "prerequisite_ids": ["A1-C02-L02-G004"],
  "stimulus": {"text": "___ you Leo?", "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL023"},
  "prompt": "Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"Are"},{"id":"B","text":"You're"},{"id":"C","text":"I'm"}],
  "correct_option_ids": ["A"],
  "rationale": "Check-question order: Are first.",
  "distractor_rationales": {"B":"a statement, not a check","C":"the answer word, not the asker"},
  "feedback_correct": "Yes — Are you Leo?", "feedback_incorrect": "Checking puts Are FIRST.",
  "hint_ladder": ["Who asks?", "Are."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["alt_text_construct_equivalent"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-G002", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "grammar", "subskill": "choose_short_answer", "cefr_level_hypothesis": "A1",
  "construct": "Select the no-short-answer for a false check",
  "prerequisite_ids": ["A1-C02-L02-G004"],
  "stimulus": {"text": "Nina asks: \"Are you Maya?\" (to YOU). You say:", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"Yes, I am."},{"id":"B","text":"No, I'm not!"},{"id":"C","text":"I'm Maya."}],
  "correct_option_ids": ["B"],
  "rationale": "You are not Maya → the no-answer.",
  "distractor_rationales": {"A":"that is Maya's own answer","C":"a naming, not a check-answer"},
  "feedback_correct": "Yes — No, I'm not!", "feedback_incorrect": "Are YOU Maya? No! Say it.",
  "hint_ladder": ["Is the badge yours?", "No, I'm not!"],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["situation_frame_narrated"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-G003", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "grammar", "subskill": "frame_detail_answer", "cefr_level_hypothesis": "A1",
  "construct": "Frame a details answer with It's",
  "prerequisite_ids": ["A1-C02-L02-G005", "A1-C02-L02-V017"],
  "stimulus": {"text": "\"What's your phone number?\" — \"___ 4-0-1, 7-3-2.\"", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"I'm"},{"id":"B","text":"Is"},{"id":"C","text":"It's"}],
  "correct_option_ids": ["C"],
  "rationale": "Details travel with It's.",
  "distractor_rationales": {"A":"the person-word","B":"missing its owner — not the taught frame"},
  "feedback_correct": "Yes — It's 4-0-1, 7-3-2.", "feedback_incorrect": "Person or detail? Detail → It's.",
  "hint_ladder": ["How did Sam answer?", "It's."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["malformed_option_feedback_explained"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-G004", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "grammar", "subskill": "order_expansion_question", "cefr_level_hypothesis": "A1",
  "construct": "Assemble the email question in order",
  "prerequisite_ids": ["A1-C02-L02-V018"],
  "stimulus": {"tiles": ["address", "email", "your", "What's", "?"], "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Put in order.", "response_type": "tile_order",
  "correct_order": ["What's", "your", "email", "address", "?"],
  "rationale": "The expansion frame in order.",
  "feedback_correct": "What's your email address? — the register's last question!",
  "feedback_incorrect": "Start with the question word.",
  "hint_ladder": ["What's first.", "What's → your → email → address → ?"],
  "estimated_seconds": 25, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["tap_only_no_drag","order_mechanics_demonstrated"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-G005", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "grammar", "subskill": "distinguish_question_statement", "cefr_level_hypothesis": "A1",
  "construct": "Tell a check-question from a statement",
  "prerequisite_ids": ["A1-C02-L02-G004"],
  "stimulus": {"text": "Which one ASKS?", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Choose.", "response_type": "single_choice",
  "options": [{"id":"A","text":"You are Sam."},{"id":"B","text":"Are you Sam?"},{"id":"C","text":"Sam are you."}],
  "correct_option_ids": ["B"],
  "rationale": "Are-first + rising = the check-question.",
  "distractor_rationales": {"A":"a statement","C":"scrambled words"},
  "feedback_correct": "Yes — Are you Sam? asks.", "feedback_incorrect": "The asker starts with Are.",
  "hint_ladder": ["Read both aloud.", "The Are-first one."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_options"],
  "bias_review": "pending", "review_status": "draft"
}
```

### Listening (QZ-LS001–004; LS003 cumulative)

**Fresh stimulus AUD078 — `learning_slow_clear` (verbatim):**

```text
LEO:  Hello! My name is Leo Novak.
NINA: Hello, Leo! … What's your phone number?
LEO:  It's 6-2-0, 1-5-4.
NINA: Thank you, Leo!
```

```json
{
  "id": "A1-C02-QZ-LS001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "listening", "subskill": "catch_digit_chunk", "cefr_level_hypothesis": "A1",
  "construct": "Catch the first digit chunk of a fresh check-in",
  "prerequisite_ids": ["A1-C02-L02-PAT003", "A1-C02-L02-V017"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD078", "illustration_asset_id": null},
  "prompt": "Listen. Leo's FIRST number chunk:", "response_type": "single_choice",
  "options": [{"id":"A","text":"6-2-0"},{"id":"B","text":"1-5-4"},{"id":"C","text":"5-5-5"}],
  "correct_option_ids": ["A"],
  "rationale": "Leo says six, two, zero first.",
  "distractor_rationales": {"B":"the second chunk","C":"Maya's chunk — wrong caller"},
  "feedback_correct": "Yes — 6-2-0.", "feedback_incorrect": "Stop right after 'It's…'.",
  "hint_ladder": ["Play again; catch the digits before the pause.", "Six, two, zero."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": true, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","digit_strip_reference"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-LS002", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "listening", "subskill": "identify_ending", "cefr_level_hypothesis": "A1",
  "construct": "Identify how a fresh check-in closes",
  "prerequisite_ids": ["A1-C01-L01-V010"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD078", "illustration_asset_id": null},
  "prompt": "Listen. Nina's LAST line:", "response_type": "single_choice",
  "options": [{"id":"A","text":"What's your phone number?"},{"id":"B","text":"Hello, Leo!"},{"id":"C","text":"Thank you, Leo!"}],
  "correct_option_ids": ["C"],
  "rationale": "The check-in closes with thanks.",
  "distractor_rationales": {"A":"the middle question","B":"the opening greeting"},
  "feedback_correct": "Yes — thank you!", "feedback_incorrect": "Listen to the LAST line.",
  "hint_ladder": ["The end, not the start.", "Thank you, Leo!"],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-LS003", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "listening", "subskill": "identify_farewell_audio", "cefr_level_hypothesis": "A1",
  "construct": "CUMULATIVE — identify a taught farewell word by ear (Chapter 1)",
  "prerequisite_ids": ["A1-C01-L01-V006"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C01-AUD007", "illustration_asset_id": null},
  "prompt": "Listen. What word do you hear?", "response_type": "single_choice",
  "options": [{"id":"A","text":"hello"},{"id":"B","text":"goodbye"},{"id":"C","text":"sorry"}],
  "correct_option_ids": ["B"],
  "rationale": "The audio says goodbye — the leaving word.",
  "distractor_rationales": {"A":"a greeting — the word here ENDS a meeting","C":"the accident word"},
  "feedback_correct": "Yes — goodbye!", "feedback_incorrect": "This word is for leaving.",
  "hint_ladder": ["Play again; catch the ending -bye.", "goodbye."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once"],
  "cumulative_flag": true, "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-LS004", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "listening", "subskill": "identify_spelled_name", "cefr_level_hypothesis": "A1",
  "construct": "Reconstruct a name from its letter string",
  "prerequisite_ids": ["A1-C02-L01-PAT001", "A1-C02-L01-V001"],
  "stimulus": {"text": null, "audio_asset_id": "A1-C02-AUD028", "illustration_asset_id": null},
  "prompt": "Listen. The letters spell:", "response_type": "single_choice",
  "options": [{"id":"A","text":"Maya"},{"id":"B","text":"Nina"},{"id":"C","text":"Leo"}],
  "correct_option_ids": ["A"],
  "rationale": "M-A-Y-A spells Maya.",
  "distractor_rationales": {"B":"Nina is N-I-N-A","C":"Leo is L-E-O"},
  "feedback_correct": "Yes — Maya!", "feedback_incorrect": "Catch the first letter: M.",
  "hint_ladder": ["Hold letter one.", "M → Maya."],
  "estimated_seconds": 20, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["audio_required_transcript_after_response","replay_allowed_once","visual_letter_chart_route"],
  "bias_review": "pending", "review_status": "draft"
}
```

### Reading (QZ-RD001–002; RD002 cumulative)

**Form (app-layer over ILL034):**

```text
NAME:  Sam Rivera
PHONE: 4-0-1, 7-3-2
```

```json
{
  "id": "A1-C02-QZ-RD001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "reading", "subskill": "locate_digit_detail", "cefr_level_hypothesis": "A1",
  "construct": "Read a phone row on a form",
  "prerequisite_ids": ["A1-C02-L02-V011"],
  "stimulus": {"text_form": "register_form_sam", "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL034"},
  "prompt": "Look. Sam's phone number is …", "response_type": "single_choice",
  "options": [{"id":"A","text":"5-5-5, 2-0-1"},{"id":"B","text":"9-7-2-4-1-6"},{"id":"C","text":"4-0-1, 7-3-2"}],
  "correct_option_ids": ["C"],
  "rationale": "The PHONE row reads 4-0-1, 7-3-2.",
  "distractor_rationales": {"A":"Maya's number","B":"Leo's fast challenge number"},
  "feedback_correct": "Yes — the row says it.", "feedback_incorrect": "Find the PHONE row, read left to right.",
  "hint_ladder": ["Which row has digits?", "4-0-1, 7-3-2."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_form","visual_only_construct"],
  "bias_review": "pending", "review_status": "draft"
}
```

```json
{
  "id": "A1-C02-QZ-RD002", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "reading", "subskill": "locate_first_name", "cefr_level_hypothesis": "A1",
  "construct": "CUMULATIVE — read a first name off a badge (Chapter 1)",
  "prerequisite_ids": ["A1-C01-L02-V022"],
  "stimulus": {"text": "NINA PETROVA", "audio_asset_id": null, "illustration_asset_id": "A1-C02-ILL034"},
  "prompt": "Look. The FIRST name is …", "response_type": "single_choice",
  "options": [{"id":"A","text":"Nina"},{"id":"B","text":"Petrova"},{"id":"C","text":"Maya"}],
  "correct_option_ids": ["A"],
  "rationale": "First name = the calling name, first on the badge.",
  "distractor_rationales": {"B":"the family name","C":"not on this badge"},
  "feedback_correct": "Yes — Nina.", "feedback_incorrect": "Which name comes FIRST?",
  "hint_ladder": ["Read the badge left to right.", "Nina."],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_badge","visual_only_construct"],
  "cumulative_flag": true, "bias_review": "pending", "review_status": "draft"
}
```

### Discourse (QZ-CN001; cumulative)

```json
{
  "id": "A1-C02-QZ-CN001", "content_version": "1.0.0", "assessment_context": "chapter_quiz",
  "component": "discourse", "subskill": "best_next_line", "cefr_level_hypothesis": "A1",
  "construct": "CUMULATIVE — follow a Chapter-1 name exchange (Chapter 1)",
  "prerequisite_ids": ["A1-C01-L02-V027"],
  "stimulus": {"text": "ALEX: \"Hello! What's your name?\" … SAM: \"My name is Sam.\" … ALEX: \"___\"", "audio_asset_id": null, "illustration_asset_id": null},
  "prompt": "Choose the best next line.", "response_type": "single_choice",
  "options": [{"id":"A","text":"See you!"},{"id":"B","text":"Nice to meet you!"},{"id":"C","text":"My name is Alex."}],
  "correct_option_ids": ["B"],
  "rationale": "After a name exchange, the taught next move is the meet-line.",
  "distractor_rationales": {"A":"nobody is leaving","C":"Alex already introduced the topic and asked; the answer is the polite meet-line"},
  "feedback_correct": "Yes — Nice to meet you!", "feedback_incorrect": "New name, new friend → the meet-line.",
  "hint_ladder": ["The names are done. What do new friends say?", "Nice to meet you!"],
  "estimated_seconds": 15, "scoring_weight": 1, "is_anchor": false, "pilot_stats": null,
  "accessibility_tags": ["voiceover_reads_dialogue"],
  "cumulative_flag": true, "bias_review": "pending", "review_status": "draft"
}
```

**Cumulative audit:** QZ-V004 (`good evening`), QZ-LS003 (`goodbye`), QZ-RD002 (first name), QZ-CN001 (`Nice to meet you`) = **4 of 26 = 15.4%** ✓ (band 15–25%). All four cite `A1-C01-*` prerequisites.

---

## STEP 15 — Guided writing (practice bank completion) · WR003–006

```yaml
id: A1-C02-PR-WR003
assessment_context: practice
component: guided_writing
subskill: assemble_spoken_email
target_ids: [A1-C02-L02-V015, A1-C02-L02-V016]
instruction: "Put in order." (Alex's email, in words)
stimulus: {tiles: [kim, aroa, dot, alex, at, com, dot], illustration_asset_id: A1-C02-ILL030, audio_asset_id: null}
prompt_icon: order
response_type: tile_order
correct_order: [alex, dot, kim, at, aroa, dot, com]
rationale: Name • dot • name • AT • place • dot • com.
feedback_correct: "alex dot kim at aroa dot com — Alex's email, said right!"
feedback_incorrect: "Begin with the first name; the dot joins the two name parts."
hint_ladder: ["Two name parts first.", "alex • dot • kim … at … aroa • dot • com."]
estimated_seconds: 35
accessibility_tags: [tap_only_no_drag, word_tiles_app_layer]
```

```yaml
id: A1-C02-PR-WR004
assessment_context: practice
component: guided_writing
subskill: assemble_question
target_ids: [A1-C02-L02-G004]
instruction: "Put in order." (the badge check for Sam)
stimulus: {tiles: ["you", "Are", "Rivera", "Sam", "?"], illustration_asset_id: A1-C02-ILL031, audio_asset_id: null}
prompt_icon: order
response_type: tile_order
correct_order: ["Are", "you", "Sam", "Rivera", "?"]
rationale: Are + you + full name + ?
feedback_correct: "Are you Sam Rivera? — the desk's first question!"
feedback_incorrect: "The checking word leads."
hint_ladder: ["First word asks.", "Are → you → Sam → Rivera → ?"]
estimated_seconds: 30
accessibility_tags: [tap_only_no_drag, word_tiles_app_layer]
```

```yaml
id: A1-C02-PR-WR005
assessment_context: practice
component: guided_writing
subskill: assemble_repair_line
target_ids: [A1-C02-L01-V008]
instruction: "Put in order." (the repair line)
stimulus: {tiles: ["you", "Can", "please?", "that,", "repeat"], illustration_asset_id: A1-C02-ILL014, audio_asset_id: null}
prompt_icon: order
response_type: tile_order
correct_order: ["Can", "you", "repeat", "that,", "please?"]
rationale: Can you + repeat + that, + please?
feedback_correct: "Can you repeat that, please? — your rescue line, built by hand."
feedback_incorrect: "Start with Can."
hint_ladder: ["Two little words first.", "Can → you → repeat → that, → please?"]
estimated_seconds: 30
accessibility_tags: [tap_only_no_drag, word_tiles_app_layer]
```

```yaml
id: A1-C02-PR-WR006
assessment_context: practice
component: guided_writing
subskill: assemble_details_sentence
target_ids: [A1-C02-L02-V013, A1-C01-L02-G002]
instruction: "Put in order." (Nina's card line)
stimulus: {tiles: ["email", "is", "My", "nina dot petrova at aroa dot com."], illustration_asset_id: A1-C02-ILL029, audio_asset_id: null}
prompt_icon: order
response_type: tile_order
correct_order: ["My", "email", "is", "nina dot petrova at aroa dot com."]
rationale: My + thing + is + detail (the card frame, email variant).
feedback_correct: "My email is nina dot petrova at aroa dot com. — a whole card line!"
feedback_incorrect: "Whose email? Mine → My."
hint_ladder: ["Start with My.", "My → email → is → the address."]
estimated_seconds: 30
accessibility_tags: [tap_only_no_drag, word_tiles_app_layer]
```

---

## RESULTS, REPAIR, REVIEW (Screens S36–S39)

### S36 — Results

Ring set fills per section (letters · numbers · vocab+repair · grammar · listening · reading). Pass = 80% overall (21/26) + ≥70% per section. Near-pass (any single section 60–69% with overall ≥80%) → its clinic + alternate items. Below → personalized review path. **Unlimited parallel retries; no permanent lock; no loss framing.**

### S37 — Remediation map + clinic seeds

| Clinic | Trigger | Focus (6–10 items) | Exit criterion |
|---|---|---|---|
| C2-CLIN-A "same-sound letters" | letters section <70% | B/D/E and M/N minimal pairs: chart glow → hear → tap; say-along echo chains | 8/8 letter discrimination in the clinic set |
| C2-CLIN-B "the first part returns" | N-items on 11–15 wrong | three→thirTEEN, four→forTEEN, five→fifTEEN build-ups with beat-tapping | 6/6 short→long builds |
| C2-CLIN-C "six or sixteen?" | 6-vs-16/17 confusion | six/seven vs sixteen/seventeen; one-beat vs two-beat sorting game | 8/8 beat sorts |
| C2-CLIN-D "dot and at" | email items wrong | the email map: small stops (dot) vs the big break (at); rebuild 3 sample emails | 3/3 assemblies |
| C2-CLIN-E "the check and the answer" | G004 items wrong | Are-you vs You-are; yes/no short answers with badge scenes | 8/8 badge checks |

Clinic items authored on request (`clinic <id>`) as a follow-up micro-session; Form B quiz on request (`form B`).

### S38 — Spaced-review export (what comes back, when)

| Target family | Returns in |
|---|---|
| Alphabet PAT001 | C3 (spelling countries), C4 Checkpoint 1, C5 |
| Numbers 0–20 | C4, C5 (PAT006–008 build to 100), C7 (clock), C9 (prices) |
| Repair chunks V007–V009 | every conversation chapter; C4, C9 formal retrieval |
| Contact set V010–V018 | C4 Checkpoint 1, C9 (service), C10 (address/directions) |
| G004/G005 | C3 (Are you + from?), C4, C7 (What time is it? → It's …) |
| C1 set (retrieved 4× this quiz) | continues per its own ledger schedule |

### S39 — Chapter map / next

Chapter 2 rings all filled; Can-dos confirmed: say A–Z, spell and request repetition, 0–20, contact details, ask for slower/repeated speech. Preview line: **Chapter 3 — Where Are You From?** (countries, he/she/they + full be paradigm, jobs — Sam's shop). 

**UI/UX tip — S36–S39:** identical layout family to C1-S34–S37 (ritual consistency). Clinic cards use the warm palette, never red; retry and continue buttons equal weight and size. S39's chapter map shows Ch1–2 filled, Ch3 next — one glance, no clutter.

---

## AUDIO SCRIPTS (1 asset)

| ID | Purpose | Delivery | Verbatim script |
|---|---|---|---|
| A1-C02-AUD078 | quiz stimulus — Leo's fresh check-in | learning_slow_clear | LEO: "Hello! My name is Leo Novak." … NINA: "Hello, Leo! … What's your phone number?" … LEO: "It's six, two, zero … one, five, four." … NINA: "Thank you, Leo!" |

`qa_status: script_review`; digits verified character-by-digit (6-2-0, 1-5-4 — new bible datum); `transcript_release: after_response`.

---

## ILLUSTRATION BRIEFS — 4 quiz skins (ILL033–036; C02 block complete)

Style constant and negative base as every C02 brief. **No letters, digits, or symbols in art.**

```yaml
id: A1-C02-ILL033
status: placeholder
content_purpose: assessment
semantic_target: nine (fresh count array)
must_show: [exactly nine cups arranged in a clean three-by-three grid on the welcome table]
must_not_show: [a tenth cup, digits, uneven spacing]
characters: []
setting: welcome table
action: the tidy array waits to be counted
composition: straight-on, grid centered, even gutters
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [same cup family as ILL005/006/016/017; exactly nine, grid-aligned for countable rows — QZ-N005]
alt_text: Exactly nine cups stand in a neat three-by-three grid on the table
embedding_slot: QZ-N005 stimulus
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: exactly nine simple ceramic cups arranged in a clean three-by-three grid on a wooden table; COMPOSITION: straight-on medium shot, the grid centered with even spacing, every cup fully visible, 1:1; MUST SHOW: exactly nine cups; three rows of three; fully countable; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects, a tenth cup, uneven rows; ALT: Exactly nine cups stand in a neat three-by-three grid on the table."
```

```yaml
id: A1-C02-ILL034
status: placeholder
content_purpose: assessment
semantic_target: the quiz form + badge (reading backing)
must_show: [a register page and one name badge lying side by side on the desk, both completely blank, pen resting diagonally]
must_not_show: [letters, digits, symbols, stamps]
characters: []
setting: check-in desk
action: the quiz's paper surfaces, waiting
composition: top-down, form left, badge right, pen between
camera_distance: top_down
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [surfaces blank — QZ-RD001/RD002 text is app-layer; parallel salience with C1's quiz skins]
alt_text: A blank register page and a blank name badge lie side by side on the desk with a pen between them
embedding_slot: QZ-RD001 (form backing), QZ-RD002 (badge backing)
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a blank register page with dotted rows and one blank name badge lying side by side on a desk, a pen resting diagonally between them; COMPOSITION: top-down shot, the page on the left, the badge on the right, the pen crossing between, 1:1; MUST SHOW: blank dotted register rows; one blank badge; a pen; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects, any marks on either surface; ALT: A blank register page and a blank name badge lie side by side on the desk with a pen between them."
```

```yaml
id: A1-C02-ILL035
status: placeholder
content_purpose: assessment
semantic_target: good evening (late-day light for the cumulative greeting item)
must_show: [the Community House at dusk — low amber sky, warm lamps lit in the windows, one lamp by the door]
must_not_show: [dark night sky, stars, sun high in the sky, text]
characters: []
setting: Community House exterior, evening
action: the day ends warmly — lamps on
composition: wide establishing, building centered, amber sky band above
camera_distance: wide
aspect_ratio: "16:9"
background_complexity: medium
continuity_requirements: [same building as A1-C02-ILL001/ILL021 but in ENDING light — clearly distinguishable from morning; lamps lit (light state, not colour alone, carries the meaning)]
alt_text: The community house at dusk with warm lamps glowing in the windows and an amber sky
embedding_slot: QZ-V004 stimulus
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a small community building at dusk under a low amber sky, with warm lamps glowing in its windows and one lit lamp beside the door; COMPOSITION: wide establishing shot, building centered, the amber sky in a band above, 16:9; MUST SHOW: lit lamps in windows; low end-of-day sky; the same building silhouette as earlier scenes; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects, night-dark sky, stars, high sun; ALT: The community house at dusk with warm lamps glowing in the windows and an amber sky."
```

```yaml
id: A1-C02-ILL036
status: placeholder
content_purpose: assessment
semantic_target: chapter complete (results moment)
must_show: [one name badge with a small warm star resting beside it on the desk, soft glow, register closed at the edge]
must_not_show: [letters on the badge, confetti, trophies, party excess]
characters: []
setting: check-in desk, quiet moment
action: the register is done — a calm, earned close
composition: medium shot, badge + star centered, closed register at the frame edge
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
continuity_requirements: [badge blank (names app-layer); celebration restrained per the ethical-engagement rules — warm, not loud]
alt_text: A blank name badge with a small warm star beside it on the desk, a closed register at the edge
embedding_slot: S36 results; S39 chapter map header
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a single blank name badge with one small warm star resting beside it on a desk, a soft glow around them, a closed register just at the frame edge; COMPOSITION: medium shot, badge and star centered, the closed register edge at the side, calm quiet mood, 1:1; MUST SHOW: one blank badge; one small star; soft warm glow; closed register edge; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects, confetti, trophies, marks on the badge; ALT: A blank name badge with a small warm star beside it on the desk, a closed register at the edge."
```

---

## ACCESSIBILITY AND INTEGRITY NOTES

- Quiz listening: transcripts after response; one replay default. Testlet-free (all quiz items independent — no cross-item dependence in a scored form).
- Visual routes on every audio item (chart, digit strip); forms/badges read by VoiceOver from the app text layer.
- Roleplay: optional voice, never required; branching alternative is a first-class path; privacy notice shown before the mission (sample data only).
- All 26 items tap-only; ordering items use demonstrated mechanics; no timers; no colour-only cues (evening item keyed to LAMPS+SKY STATE, not hue alone).

---

## LEDGER DELTA AND REGISTER USAGE

- Ledgers: no new targets (assessment session). All quiz `prerequisite_ids` resolve to `taught` rows.
- `ILLUSTRATION_ID_REGISTER.csv`: A1-C02 block **complete** — 36/36 used, `next_available: —` (any Ch2 clinic art would need a new allocation decision).
- Bible: +Leo's phone 6-2-0, 1-5-4; +learner sample email learner@aroa.com.
- Audio block rests at AUD078.
