# A1-C01-L01 — Lesson 1: Say Hello

Chapter 1 · Hello! My Name Is Alex · Lesson type V (assembly steps 1–6)
Core time ≈ 18–20 min · pause at ≈ 10 min (after Practice A) · first lesson of the course (no prerequisites)

**Targets:** 15 items — Set A (greetings + farewells, 8) and Set B (politeness + repair words, 7).
**Screens:** S01–S09 (inventory in `A1_C01_MANIFEST.md`). **Assets:** 18 audio scripts, 12 illustration briefs.
**Learner-facing instruction words:** Stage 1 controlled lexicon only — `listen`, `look`, `tap`, `choose`, `match`, `say`, `repeat` — each demonstrated in S03 before first use.

---

## STEP 1 — Can-do promise (30 sec) · Screen S01

**Learner-facing copy (icon-led, minimal text):**

> [ILL: A1-C01-ILL001 | alt: A bright community hall with a welcome table; a person with round glasses waves from the door]
> **New words today: hello · goodbye · thank you · sorry**
> ✦ You can say hello. You can say goodbye. You can say thank you.

Text appears word-by-word with the ear icon; no audio required (visual promise; audio begins with the hook so the first listening experience is a story, not an instruction).

**UI/UX tip — S01:** Goal is an instant, low-text promise of competence. Full-bleed illustration top 60%, three can-do lines below with check-ring icons (empty rings that will fill at S09). Tap-anywhere-to-continue with a subtle pulsing affordance; no buttons to read. VoiceOver: read the three can-dos as "You will learn to: greet people; say thank you and sorry; say goodbye."

---

## STEP 2 — Story hook (30–60 sec) · Screen S02

**Scene:** Sunny morning outside the Aroa Community House. A welcome table with cups. Alex (they/them) stands at the door; Maya (she/her) arrives to help.

**Audio AUD001 — `learning_slow_clear` (verbatim script):**

```text
ALEX: Hello!                       (warm, waving)
MAYA: Hi, Alex!                    (smiling, arriving)
ALEX: Hi, Maya! … Good morning!
MAYA: Good morning, Alex!          (setting down cups)
ALEX: Thank you, Maya! …
MAYA: You're welcome!              [CHUNK:survival — meaning shown by Maya's happy nod; not a target]
```

**Comprehension:** none scored. Learner task is `listen` + `look` only (S03 demo follows). Transcript hidden (released after the lesson's practice, per replay policy).

**Story state recorded:** Alex welcomes at the door; Maya helps with cups; it is morning (feeds L2 warm-up and L3 conversation).

**UI/UX tip — S02:** One-tap play with big ear button; illustration animates subtly per speaker (Alex's badge glows on their line) to bind sound→speaker. Auto-advance to S03 after playback ends + 1.5 s. Replay freely offered (hook is unscored). Captions OFF by default; a "show words" toggle appears only after one full playback (transcript_release: always_in_practice for unscored story audio).

---

## STEP 3 — First-run orientation (replaces retrieval warm-up) · Screen S03

Teaches the app's five core interactions by demonstration, using only the hook audio/art — zero new language:

| Demo | Instruction word shown + spoken | Demonstration |
|---|---|---|
| 1 | `listen` | AUD001 replays; ear icon pulses with the audio |
| 2 | `look` | camera pans across ILL001; eye icon pulses |
| 3 | `tap` | an animated finger taps the play button |
| 4 | `choose` | three cups appear; finger selects the one Maya holds; it lifts and settles |
| 5 | `match` + `say` + `repeat` | "Hello" card pairs with wave image; mouth icon invites echo; loop arrow replays one word |

Each demo: watch (auto) → try once (guided, cannot fail). ≈ 2–3 min total.

**UI/UX tip — S03:** The five demos are one horizontally paged flow with a dot progress bar; each "try" is a single large target (min 60×60 pt), failure impossible (any tap advances with gentle confirmation). Reduce-motion replaces pans with crossfades. This screen is the foundation for every later instruction — do not decorate it; the icons used here (ear, eye, finger, hand-select, mouth, loop) must be the same icons used across the whole course.

---

## STEP 4 — Micro-set A input: words to open and close (≈ 5 min) · Screen S04

Card flow per item: **hear** (word model audio) → **look** (illustration) → **see the word** (word appears under art) → **say** (mouth icon invites echo; ungraded). One card ≈ 20–25 s. (Encounter #1 of 4.)

### Vocabulary records — Set A (8)

```yaml
id: A1-C01-L01-V001
content_version: 1.0.0
headword_or_phrase: hello
primary_spelling: hello
accepted_variants: []
part_of_speech_or_function: greeting word (any time of day)
cefr_level_hypothesis: A1
sense_definition_for_creators: neutral friendly greeting when meeting or greeting someone
learner_definition: (shown by illustration + audio; no definition text at this stage)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /həˈloʊ/
stress_pattern: second syllable
audio_asset_ids: [A1-C01-AUD002]
core_collocation_or_frame: "Hello + name — Hello, Maya!"
example_sentence: "Hello, Alex!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL005
semantic_cue: two people waving in greeting, daytime
alt_text: Two young adults wave hello to each other with big friendly smiles
common_confusion: used at any arrival; learners over-restrict it to formal settings
feedback_for_confusion: friendly any-time word — wave picture lights up on arrival scenes
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 3, 4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V002
content_version: 1.0.0
headword_or_phrase: hi
primary_spelling: hi
accepted_variants: []
part_of_speech_or_function: greeting word (informal, any time)
cefr_level_hypothesis: A1
sense_definition_for_creators: informal friendly greeting, same use as hello
learner_definition: (illustration + audio)
prerequisite_ids: [A1-C01-L01-V001]
pronunciation_model: general_american
ipa: /haɪ/
stress_pattern: monosyllable
audio_asset_ids: [A1-C01-AUD003]
core_collocation_or_frame: "Hi + name — Hi, Maya!"
example_sentence: "Hi, Alex!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL005
semantic_cue: shared with hello — same wave scene, friendlier posture
alt_text: Two friends wave hello in a relaxed, friendly way
common_confusion: hello vs hi formality difference is NOT tested at A1 — both accepted everywhere in this course
feedback_for_confusion: both are good — hi is for friends
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V003
content_version: 1.0.0
headword_or_phrase: good morning
primary_spelling: good morning
accepted_variants: []
part_of_speech_or_function: time-fixed greeting chunk (until midday)
cefr_level_hypothesis: A1
sense_definition_for_creators: greeting used in the morning
learner_definition: (sun-low illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /ˌɡʊd ˈmɔːrnɪŋ/
stress_pattern: stress on morning
audio_asset_ids: [A1-C01-AUD004]
core_collocation_or_frame: "Good morning + name"
example_sentence: "Good morning, Maya!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL002
semantic_cue: low sun, long shadows, morning light, coffee steam
alt_text: In soft morning light, Maya stands at a welcome table with steaming cups while Alex arrives waving
common_confusion: morning vs evening (sun position is the cue taught)
feedback_for_confusion: picture shows the low early sun — morning
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V004
content_version: 1.0.0
headword_or_phrase: good afternoon
primary_spelling: good afternoon
accepted_variants: []
part_of_speech_or_function: time-fixed greeting chunk (midday to evening)
cefr_level_hypothesis: A1
sense_definition_for_creators: greeting used after midday, before evening
learner_definition: (high-sun illustration + audio)
prerequisite_ids: [A1-C01-L01-V003]
pronunciation_model: general_american
ipa: /ˌɡʊd ˌæftərˈnuːn/
stress_pattern: stress on noon syllable
audio_asset_ids: [A1-C01-AUD005]
core_collocation_or_frame: "Good afternoon + name"
example_sentence: "Good afternoon, Nina!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL003
semantic_cue: high bright sun, no shadows, terrace
alt_text: Under a high bright sun, Nina waves to Leo at a café terrace window
common_confusion: afternoon vs morning (sun height)
feedback_for_confusion: the sun is high — afternoon
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [4, 7, 9]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V005
content_version: 1.0.0
headword_or_phrase: good evening
primary_spelling: good evening
accepted_variants: []
part_of_speech_or_function: time-fixed greeting chunk (after sunset)
cefr_level_hypothesis: A1
sense_definition_for_creators: greeting used after the sun goes down
learner_definition: (lamplight illustration + audio)
prerequisite_ids: [A1-C01-L01-V003]
pronunciation_model: general_american
ipa: /ˌɡʊd ˈiːvnɪŋ/
stress_pattern: stress on evening
audio_asset_ids: [A1-C01-AUD006]
core_collocation_or_frame: "Good evening + name"
example_sentence: "Good evening, Leo!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL004
semantic_cue: dark blue sky, warm street lamps
alt_text: On a darkening street lit by warm lamps, two neighbors wave to each other
common_confusion: evening vs morning (dark sky); evening vs good night (good night is NOT taught as a greeting)
feedback_for_confusion: the sky is dark and the lamps are on — evening
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V006
content_version: 1.0.0
headword_or_phrase: goodbye
primary_spelling: goodbye
accepted_variants: []
part_of_speech_or_function: farewell word (any time)
cefr_level_hypothesis: A1
sense_definition_for_creators: neutral word said when leaving or ending a meeting
learner_definition: (doorway-wave illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /ˌɡʊdˈbaɪ/
stress_pattern: stress on bye
audio_asset_ids: [A1-C01-AUD007]
core_collocation_or_frame: "Goodbye + name — Goodbye, Alex!"
example_sentence: "Goodbye, Maya!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL006
semantic_cue: one person leaving through a doorway, turning to wave
alt_text: One person steps out a doorway, turning back to wave goodbye
common_confusion: goodbye vs bye (formality not tested); goodbye used when arriving (wrong direction)
feedback_for_confusion: the person is walking away — leaving words
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V007
content_version: 1.0.0
headword_or_phrase: bye
primary_spelling: bye
accepted_variants: []
part_of_speech_or_function: farewell word (informal, any time)
cefr_level_hypothesis: A1
sense_definition_for_creators: informal farewell, same use as goodbye
learner_definition: (same doorway scene, lighter mood)
prerequisite_ids: [A1-C01-L01-V006]
pronunciation_model: general_american
ipa: /baɪ/
stress_pattern: monosyllable
audio_asset_ids: [A1-C01-AUD008]
core_collocation_or_frame: "Bye + name — Bye, Leo!"
example_sentence: "Bye, Maya!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL006
semantic_cue: shared with goodbye — same leaving scene
alt_text: A friend waves bye while stepping away through a doorway
common_confusion: bye vs by (spelling, receptive only here); bye vs hi (arrival/leaving direction)
feedback_for_confusion: friends walking away — bye
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V008
content_version: 1.0.0
headword_or_phrase: see you
primary_spelling: see you
accepted_variants: ["see you later (receptive only)"]
part_of_speech_or_function: farewell chunk (implies meeting again)
cefr_level_hypothesis: A1
sense_definition_for_creators: friendly leaving phrase that promises another meeting
learner_definition: (walking-apart illustration + audio)
prerequisite_ids: [A1-C01-L01-V006]
pronunciation_model: general_american
ipa: /ˈsiː juː/
stress_pattern: stress on see
audio_asset_ids: [A1-C01-AUD009]
core_collocation_or_frame: "See you + time word (Ch7) — See you tomorrow!"
example_sentence: "See you, Alex!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL007
semantic_cue: two friends walking apart on a park path, both looking back, mid-wave
alt_text: Two friends walk away from each other down a park path, turning to wave
common_confusion: treated as just another goodbye — fine at A1; the "again" nuance is gently modeled, never tested
feedback_for_confusion: both look back — they meet again
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [4, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

**UI/UX tip — S04:** Horizontal card pager (swipe or auto-advance after audio); each card = illustration (60%), word (large, Dynamic-Type aware), ear + mouth buttons. Tap ear = replay word model; tap mouth = record echo (ungraded, skippable — mic permission notice shown once, before first use, with a clear "not now" path that never blocks progress). Progress dots for 8 cards. VoiceOver: word, then "illustration: <alt_text>", ear and mouth buttons labeled.

---

## STEP 5 — Micro-practice A (≈ 3 min) · Screen S05

16 practice items of the chapter live across this lesson; these are PR-V001–V009 (9 items: 8 choice + 1 speak). Encounter #2 for Set A. Feedback per item; hint ladder two rungs. Answer positions balanced (A5/B5/C4 across the lesson's choice items).

```yaml
id: A1-C01-PR-V001
assessment_context: practice
component: vocabulary
subskill: recognise_greeting_audio
target_ids: [A1-C01-L01-V001]
instruction: "Listen. Choose." (ear icon + hand icon)
stimulus: {audio_asset_id: A1-C01-AUD002, illustration_asset_id: null}
prompt_icon: ear
response_type: single_choice
options: [{id: A, text: hello}, {id: B, text: goodbye}, {id: C, text: see you}]
correct_option_ids: [A]
rationale: The audio says hello — an arrival greeting.
distractor_rationales: {B: "goodbye is a leaving word — the audio is a greeting", C: "see you is a leaving chunk"}
feedback_correct: "Yes — hello!"
feedback_incorrect: "Listen again — the word starts the meeting."
hint_ladder: ["Play again and watch the wave picture light up.", "One option is for leaving — tap the ear once more and choose the hello card."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-V002
assessment_context: practice
component: vocabulary
subskill: recognise_farewell_audio
target_ids: [A1-C01-L01-V006]
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD007, illustration_asset_id: null}
prompt_icon: ear
response_type: single_choice
options: [{id: A, text: good morning}, {id: B, text: hello}, {id: C, text: goodbye}]
correct_option_ids: [C]
rationale: The audio says goodbye.
distractor_rationales: {A: "good morning is a greeting — this word ends a meeting", B: "hello starts a meeting"}
feedback_correct: "Yes — goodbye!"
feedback_incorrect: "This word is for leaving. Listen for the ending sound -bye."
hint_ladder: ["Play again; the doorway-wave picture lights up.", "Two options greet. Choose the leaving word."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-V003
assessment_context: practice
component: vocabulary
subskill: match_greeting_to_time_of_day
target_ids: [A1-C01-L01-V003]
instruction: "Look. Choose." (eye icon)
stimulus: {illustration_asset_id: A1-C01-ILL002, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: good evening}, {id: B, text: good morning}, {id: C, text: good afternoon}]
correct_option_ids: [B]
rationale: Low sun, long shadows, morning light = morning greeting.
distractor_rationales: {A: "evening pictures are dark with lamps", C: "afternoon sun is high in the sky"}
feedback_correct: "Yes — good morning!"
feedback_incorrect: "Look at the sun. It is low. The day starts — morning."
hint_ladder: ["Look again at the sun and the shadows.", "The sky is light and the sun is low — not dark, not high."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent, no_color_only_meaning]
```

```yaml
id: A1-C01-PR-V004
assessment_context: practice
component: vocabulary
subskill: match_greeting_to_time_of_day
target_ids: [A1-C01-L01-V005]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL004, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: good evening}, {id: B, text: good afternoon}, {id: C, text: good morning}]
correct_option_ids: [A]
rationale: Dark sky, warm street lamps = evening.
distractor_rationales: {B: "afternoon is bright daylight", C: "morning has a low rising sun"}
feedback_correct: "Yes — good evening!"
feedback_incorrect: "The lamps are on and the sky is dark — evening."
hint_ladder: ["Look at the sky and the lamps.", "Bright sky options are wrong here."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent, no_color_only_meaning]
```

```yaml
id: A1-C01-PR-V005
assessment_context: practice
component: vocabulary
subskill: match_farewell_to_scene
target_ids: [A1-C01-L01-V008]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL007, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: hello}, {id: B, text: good morning}, {id: C, text: see you}]
correct_option_ids: [C]
rationale: Two people walk apart, looking back — leaving with a promise to meet again.
distractor_rationales: {A: "hello is for meeting, not leaving", B: "good morning is a greeting for the morning"}
feedback_correct: "Yes — see you!"
feedback_incorrect: "The two friends walk away. They look back. Leaving words."
hint_ladder: ["Look at their feet — walking away.", "One option is a leaving word."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-V006
assessment_context: practice
component: listening
subskill: match_audio_to_time_scene
target_ids: [A1-C01-L01-V003]
instruction: "Listen. Match." (ear icon + connecting icon)
stimulus: {audio_asset_id: A1-C01-AUD004, illustration_asset_id: null}
prompt_icon: ear
response_type: image_choice
options: [{id: A, illustration_asset_id: A1-C01-ILL004}, {id: B, illustration_asset_id: A1-C01-ILL002}, {id: C, illustration_asset_id: A1-C01-ILL003}]
correct_option_ids: [B]
rationale: "Good morning" matches the low-sun morning scene.
distractor_rationales: {A: "dark lamplit scene is evening", C: "high-sun terrace is afternoon"}
feedback_correct: "Yes — good morning is for the morning sun."
feedback_incorrect: "Listen again. Morning sun is low."
hint_ladder: ["Play again and listen for mor-.", "One picture is dark. Two are light. Listen for the low-sun word."]
estimated_seconds: 20
accessibility_tags: [audio_required_transcript_after_response, alt_text_parallel_options]
```

```yaml
id: A1-C01-PR-V007
assessment_context: practice
component: vocabulary
subskill: choose_word_for_situation
target_ids: [A1-C01-L01-V007]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL006, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: bye}, {id: B, text: hi}, {id: C, text: hello}]
correct_option_ids: [A]
rationale: One person is leaving through the doorway — a farewell.
distractor_rationales: {B: "hi greets an arriving person", C: "hello greets an arriving person"}
feedback_correct: "Yes — bye!"
feedback_incorrect: "The friend is leaving. Use a leaving word."
hint_ladder: ["Look — is the friend coming in or going out?", "Two words are for meeting. Choose the leaving word."]
estimated_seconds: 15
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-V008
assessment_context: practice
component: listening
subskill: identify_farewell_words_audio
target_ids: [A1-C01-L01-V008]
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD009, illustration_asset_id: null}
prompt_icon: ear
response_type: single_choice
options: [{id: A, text: good morning}, {id: B, text: see you}, {id: C, text: thank you}]
correct_option_ids: [B]
rationale: The audio says "See you."
distractor_rationales: {A: "good morning is a greeting — this is a leaving phrase", C: "thank you is for politeness, not leaving"}
feedback_correct: "Yes — see you!"
feedback_incorrect: "Two words — a leaving chunk. Listen again."
hint_ladder: ["Play again; the park-path picture lights up.", "One option thanks. Two options leave. Listen for two words."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-V009
assessment_context: practice
component: pronunciation
subskill: echo_word
target_ids: [A1-C01-L01-V001]
instruction: "Listen. Say." (ear + mouth icon)
stimulus: {audio_asset_id: A1-C01-AUD002, illustration_asset_id: A1-C01-ILL005}
prompt_icon: mouth
response_type: speak_repeat
scoring: ungraded — waveform playback + self-compare only
correct_option_ids: []
rationale: Builds the hear→say loop with zero stakes.
feedback_correct: "Nice! Your hello is recorded. Play both."
feedback_incorrect: "Listen one more time, then try again. Or skip — you can say it later."
hint_ladder: ["Play the model twice; watch the mouth icon.", "Say it with the audio together."]
estimated_seconds: 25
accessibility_tags: [non_voice_alternative_tap_word, mic_optional_never_blocks]
```

**UI/UX tip — S05:** One item per screen-swap within the practice view; big option cards (illustration or word), instant non-punitive feedback via the S03 icon language (green check + chime / soft arrow for retry). Correct-answer position rotates by the item records — never render a fixed layout. Hint rung 1 auto-offers after first incorrect tap; rung 2 after second. Replay button visible on all audio items (one default replay before hint offering, logged diagnostically). Reduce-motion: no card shake — feedback is color + icon + sound with a text fallback.

---

## PAUSE — Screen S06 (after ≈ 10 min)

> ✦ Good work! Two new word groups today.
> [ILL: A1-C01-ILL001 | alt: the welcome hall, now with a few cups on the table]
> **Take a break — or tap to go on.** Progress saved automatically.

**UI/UX tip — S06:** True save-state checkpoint; the lesson resumes at S07 even after app kill. Break affordance is equal in visual weight to continue (ethical-engagement rule: rest is never framed as failure). Show three filled mini-rings (promise kept so far).

---

## STEP 6 — Micro-set B input: little kind words (≈ 5 min) · Screen S07

Same card flow as S04 (encounter #1 for Set B).

### Vocabulary records — Set B (7)

```yaml
id: A1-C01-L01-V009
content_version: 1.0.0
headword_or_phrase: please
primary_spelling: please
accepted_variants: []
part_of_speech_or_function: politeness word added to requests
cefr_level_hypothesis: A1
sense_definition_for_creators: makes a request friendly and polite
learner_definition: (offering-gesture illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /pliːz/
stress_pattern: monosyllable
audio_asset_ids: [A1-C01-AUD010]
core_collocation_or_frame: "(request) + please — One coffee, please. (full frame taught Ch9)"
example_sentence: "Please!" (with offering gesture scene)
example_known_language_check: passed (single word + scene)
illustration_asset_id: A1-C01-ILL008
semantic_cue: cup offered with both hands, warm asking expression
alt_text: Maya offers a cup with both hands and a warm, asking expression
common_confusion: please vs thank you (requesting vs thanking direction)
feedback_for_confusion: you ask with please; you thank with thank you
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 9, 10]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V010
content_version: 1.0.0
headword_or_phrase: thank you
primary_spelling: thank you
accepted_variants: []
part_of_speech_or_function: politeness chunk for gratitude
cefr_level_hypothesis: A1
sense_definition_for_creators: said when someone gives or helps
learner_definition: (receiving illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /ˈθæŋk juː/
stress_pattern: stress on thank
audio_asset_ids: [A1-C01-AUD011]
core_collocation_or_frame: "Thank you + name — Thank you, Maya!"
example_sentence: "Thank you, Maya!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL009
semantic_cue: receiver smiles, hand briefly at chest, receiving an object
alt_text: Alex receives a cup from Maya, smiling warmly with one hand at his chest
common_confusion: thank you vs thanks (both fine, never tested against each other); thank you vs sorry
feedback_for_confusion: you get → thank you; you make a small problem → sorry
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 9, 10]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V011
content_version: 1.0.0
headword_or_phrase: thanks
primary_spelling: thanks
accepted_variants: []
part_of_speech_or_function: informal gratitude word
cefr_level_hypothesis: A1
sense_definition_for_creators: informal one-word thank you
learner_definition: (same receiving scene, friendlier)
prerequisite_ids: [A1-C01-L01-V010]
pronunciation_model: general_american
ipa: /θæŋks/
stress_pattern: monosyllable
audio_asset_ids: [A1-C01-AUD012]
core_collocation_or_frame: "Thanks + name — Thanks, Leo!"
example_sentence: "Thanks, Leo!"
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL009
semantic_cue: shared with thank you
alt_text: A friend gives a friendly one-word thanks with a smile and small wave
common_confusion: thanks vs thank you formality difference is NOT tested — both accepted everywhere
feedback_for_confusion: both are good — thanks is quick and friendly
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [9, 10]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V012
content_version: 1.0.0
headword_or_phrase: sorry
primary_spelling: sorry
accepted_variants: []
part_of_speech_or_function: apology word for small problems
cefr_level_hypothesis: A1
sense_definition_for_creators: said after a small mistake or problem
learner_definition: (small-accident illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /ˈsɑːri/
stress_pattern: first syllable
audio_asset_ids: [A1-C01-AUD013]
core_collocation_or_frame: "Sorry! / Sorry + name"
example_sentence: "Sorry, Maya!" (small bump scene)
example_known_language_check: passed (name only)
illustration_asset_id: A1-C01-ILL010
semantic_cue: concerned face, one hand raised palm-out, dropped notebook at feet
alt_text: Leo looks concerned with one hand raised as his notebook falls at his feet
common_confusion: sorry vs excuse me (accident vs passing/attention)
feedback_for_confusion: a small problem happens → sorry; you pass someone → excuse me
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V013
content_version: 1.0.0
headword_or_phrase: excuse me
primary_spelling: excuse me
accepted_variants: []
part_of_speech_or_function: politeness chunk to pass or get attention
cefr_level_hypothesis: A1
sense_definition_for_creators: polite words when passing through or starting to speak to a stranger
learner_definition: (passing illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /ɪkˈskjuːz miː/
stress_pattern: stress on skju
audio_asset_ids: [A1-C01-AUD014]
core_collocation_or_frame: "Excuse me + question (Ch10 full use)"
example_sentence: "Excuse me!" (stepping past on a path)
example_known_language_check: passed (single chunk + scene)
illustration_asset_id: A1-C01-ILL011
semantic_cue: polite sideways lean, open hand, passing between two people
alt_text: Nina leans politely to one side with an open hand as she passes between two people on a narrow path
common_confusion: excuse me vs sorry (passing vs accident)
feedback_for_confusion: you just pass by — excuse me; something fell — sorry
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [10]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V014
content_version: 1.0.0
headword_or_phrase: "yes"
primary_spelling: "yes"
accepted_variants: []
part_of_speech_or_function: answer word (positive)
cefr_level_hypothesis: A1
sense_definition_for_creators: positive short answer to a question
learner_definition: (nod illustration + audio)
prerequisite_ids: []
pronunciation_model: general_american
ipa: /jes/
stress_pattern: monosyllable
audio_asset_ids: [A1-C01-AUD015]
core_collocation_or_frame: "Yes + short answer (Ch2: Yes, I am)"
example_sentence: "Yes!"
example_known_language_check: passed (single word + nod scene)
illustration_asset_id: A1-C01-ILL012
semantic_cue: left half of the yes/no pair canvas — clear nod, smiling
alt_text: A smiling person nods yes, head tilted down then up
common_confusion: yes vs no audio confusion (fast speech); nod vs head-shake gesture
feedback_for_confusion: listen for the starting sound y- vs n-
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 3]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C01-L01-V015
content_version: 1.0.0
headword_or_phrase: "no"
primary_spelling: "no"
accepted_variants: []
part_of_speech_or_function: answer word (negative)
cefr_level_hypothesis: A1
sense_definition_for_creators: negative short answer to a question
learner_definition: (head-shake illustration + audio)
prerequisite_ids: [A1-C01-L01-V014]
pronunciation_model: general_american
ipa: /noʊ/
stress_pattern: monosyllable
audio_asset_ids: [A1-C01-AUD016]
core_collocation_or_frame: "No + short answer (Ch2: No, I'm not)"
example_sentence: "No."
example_known_language_check: passed (single word + shake scene)
illustration_asset_id: A1-C01-ILL012
semantic_cue: right half of the yes/no pair canvas — gentle head-shake, calm palm-out
alt_text: A calm person gently shakes their head no with a soft open-palm gesture
common_confusion: no vs yes; no vs "no thank you" (not tested here)
feedback_for_confusion: listen for the starting sound n-
introduction_chapter: 1
introduction_lesson: 1
later_review_chapters: [2, 3]
source_notes: [expert_judgment]
review_status: reviewed
```

**UI/UX tip — S07:** Identical pager mechanics as S04 (consistency lowers load); the only difference is a small "kind words" chapter chip so the learner senses progress through a second group. Mic still optional.

---

## STEP 6b — Micro-practice B (≈ 2–3 min) · Screen S08 (PR-V010–V016; encounter #2 for Set B)

```yaml
id: A1-C01-PR-V010
assessment_context: practice
component: vocabulary
subskill: recognise_politeness_audio
target_ids: [A1-C01-L01-V010]
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD011, illustration_asset_id: null}
prompt_icon: ear
response_type: single_choice
options: [{id: A, text: sorry}, {id: B, text: please}, {id: C, text: thank you}]
correct_option_ids: [C]
rationale: The audio says thank you.
distractor_rationales: {A: "sorry is for small problems", B: "please is for asking"}
feedback_correct: "Yes — thank you!"
feedback_incorrect: "This word thanks someone. Listen for th-."
hint_ladder: ["Play again; the receiving-cup picture lights up.", "One word asks. One word is for problems. Choose the thanks word."]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-V011
assessment_context: practice
component: vocabulary
subskill: choose_word_for_situation
target_ids: [A1-C01-L01-V012]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL010, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: sorry}, {id: B, text: excuse me}, {id: C, text: thank you}]
correct_option_ids: [A]
rationale: A notebook has dropped — a small problem just happened.
distractor_rationales: {B: "excuse me is for passing or getting attention", C: "thank you is for receiving"}
feedback_correct: "Yes — sorry!"
feedback_incorrect: "Something fell — a small problem. Which word fits a problem?"
hint_ladder: ["Look at the notebook on the ground.", "One word is only for passing by. Remove it."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-V012
assessment_context: practice
component: vocabulary
subskill: choose_word_for_situation
target_ids: [A1-C01-L01-V013]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL011, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: thank you}, {id: B, text: excuse me}, {id: C, text: sorry}]
correct_option_ids: [B]
rationale: Nina is passing between people — no problem happened.
distractor_rationales: {A: "nothing is received here", C: "no accident — she only walks past"}
feedback_correct: "Yes — excuse me!"
feedback_incorrect: "She only walks past. Nothing falls, nothing is given."
hint_ladder: ["Look — is anything dropped or given?", "Remove the problem-word. Remove the thanks-word."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-V013
assessment_context: practice
component: vocabulary
subskill: choose_word_for_situation
target_ids: [A1-C01-L01-V010]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL009, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: thank you}, {id: B, text: bye}, {id: C, text: good morning}]
correct_option_ids: [A]
rationale: Alex receives a cup — gratitude fits.
distractor_rationales: {B: "no one is leaving", C: "no greeting moment — something is received"}
feedback_correct: "Yes — thank you!"
feedback_incorrect: "Maya gives. Alex gets. Which word is for getting?"
hint_ladder: ["Look at the hands — one gives, one gets.", "Two options are hellos and goodbyes. Remove them."]
estimated_seconds: 20
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-V014
assessment_context: practice
component: listening
subskill: identify_answer_word_audio
target_ids: [A1-C01-L01-V015]
instruction: "Listen. Choose."
stimulus: {audio_asset_id: A1-C01-AUD016, illustration_asset_id: null}
prompt_icon: ear
response_type: single_choice
options: [{id: A, text: "yes"}, {id: B, text: please}, {id: C, text: "no"}]
correct_option_ids: [C]
rationale: The audio says no.
distractor_rationales: {A: "yes is the opposite answer word", B: "please is a request word, not an answer"}
feedback_correct: "Yes — no! 🙂" 
feedback_incorrect: "The word starts with n-. Listen again."
hint_ladder: ["Play again; the head-shake half of the pair picture lights up.", "Remove the asking-word. Then listen: y- or n-?"]
estimated_seconds: 15
accessibility_tags: [audio_required_transcript_after_response, replay_allowed_once]
```

```yaml
id: A1-C01-PR-V015
assessment_context: practice
component: vocabulary
subskill: choose_word_for_situation
target_ids: [A1-C01-L01-V006]
instruction: "Look. Choose."
stimulus: {illustration_asset_id: A1-C01-ILL006, audio_asset_id: null}
prompt_icon: eye
response_type: single_choice
options: [{id: A, text: thank you}, {id: B, text: goodbye}, {id: C, text: good morning}]
correct_option_ids: [B]
rationale: A friend is leaving through the doorway.
distractor_rationales: {A: "nothing is being received", C: "good morning greets — the friend leaves"}
feedback_correct: "Yes — goodbye!"
feedback_incorrect: "The friend walks out. Leaving word needed."
hint_ladder: ["Look at the door and the feet.", "One option greets. One thanks. Choose the leaving word."]
estimated_seconds: 15
accessibility_tags: [alt_text_construct_equivalent]
```

```yaml
id: A1-C01-PR-V016
assessment_context: practice
component: pronunciation
subskill: echo_word
target_ids: [A1-C01-L01-V009]
instruction: "Listen. Say."
stimulus: {audio_asset_id: A1-C01-AUD010, illustration_asset_id: A1-C01-ILL008}
prompt_icon: mouth
response_type: speak_repeat
scoring: ungraded — playback + self-compare
correct_option_ids: []
rationale: Low-stakes production of a politeness word.
feedback_correct: "Recorded! Play both and listen."
feedback_incorrect: "Try again, or skip — no points lost."
hint_ladder: ["Play the model twice.", "Say it together with the audio."]
estimated_seconds: 25
accessibility_tags: [non_voice_alternative_tap_word, mic_optional_never_blocks]
```

**UI/UX tip — S08:** Same mechanics as S05. Mixed illustrated and audio-only items keep interleaving (audio → image → situation) so no single strategy (e.g., always matching sun position) carries multiple items in a row.

---

## STEP 6c — End-of-lesson blended review (≈ 2 min) · Screen S09 (encounter #3, all 15)

Learner hears **AUD017** (Set A sequence) and **AUD018** (Set B sequence); after each word, the matching word-card from S04/S07 pops in a 3×5 gallery; final screen fills the three promise rings from S01 and shows:

> ✦ 15 new words! You can say hello. You can say thank you. You can say goodbye.
> Next lesson: **your name** — I'm Alex!

**UI/UX tip — S09:** Celebratory but brief (2 s animation, mutable, reduce-motion safe — ethical-engagement rules). The gallery doubles as a free-play recap: tapping any card replays its word model. "Next lesson" teaser uses one known word + names only. Streak/XP intentionally absent from this screen — reward is the filled can-do rings.

---

## Encounter tracker (per target, ≥4 within the chapter)

| Target | #1 Input | #2 Practice | #3 Blended review | #4 Next use |
|---|---|---|---|---|
| V001–V008 (Set A) | S04 cards | S05 items | S09 + AUD017 | L2 warm-up (S10) |
| V009–V015 (Set B) | S07 cards | S08 items | S09 + AUD018 | L2 warm-up (S10) |

Later-chapter retrievals already scheduled in `LEXICAL_LEDGER.csv` (Ch2/3/4 and beyond) satisfy the ≥2 later-chapter rule; Checkpoint 1 samples all.

---

## Audio scripts — all verbatim (18 assets)

| ID | Purpose | Delivery | Verbatim script |
|---|---|---|---|
| A1-C01-AUD001 | story hook | learning_slow_clear | ALEX: "Hello!" … MAYA: "Hi, Alex!" … ALEX: "Hi, Maya! … Good morning!" … MAYA: "Good morning, Alex!" (sets cups down) … ALEX: "Thank you, Maya!" … MAYA: "You're welcome!" (happy nod; `[CHUNK:survival]`, not a target) |
| A1-C01-AUD002 | word model V001 | learning_slow_clear | "Hello. … Hello." |
| A1-C01-AUD003 | word model V002 | learning_slow_clear | "Hi. … Hi." |
| A1-C01-AUD004 | word model V003 | learning_slow_clear | "Good morning. … Good morning." |
| A1-C01-AUD005 | word model V004 | learning_slow_clear | "Good afternoon. … Good afternoon." |
| A1-C01-AUD006 | word model V005 | learning_slow_clear | "Good evening. … Good evening." |
| A1-C01-AUD007 | word model V006 | learning_slow_clear | "Goodbye. … Goodbye." |
| A1-C01-AUD008 | word model V007 | learning_slow_clear | "Bye. … Bye." |
| A1-C01-AUD009 | word model V008 | learning_slow_clear | "See you. … See you." |
| A1-C01-AUD010 | word model V009 | learning_slow_clear | "Please. … Please." |
| A1-C01-AUD011 | word model V010 | learning_slow_clear | "Thank you. … Thank you." |
| A1-C01-AUD012 | word model V011 | learning_slow_clear | "Thanks. … Thanks." |
| A1-C01-AUD013 | word model V012 | learning_slow_clear | "Sorry. … Sorry." |
| A1-C01-AUD014 | word model V013 | learning_slow_clear | "Excuse me. … Excuse me." |
| A1-C01-AUD015 | word model V014 | learning_slow_clear | "Yes. … Yes." |
| A1-C01-AUD016 | word model V015 | learning_slow_clear | "No. … No." |
| A1-C01-AUD017 | blended review Set A | learning_slow_clear | "Hello … Hi … Good morning … Good afternoon … Good evening … Goodbye … Bye … See you." (700 ms gaps) — pass 2 in a different order: "Bye … Good morning … See you … Hello … Good evening … Goodbye … Hi … Good afternoon." |
| A1-C01-AUD018 | blended review Set B | learning_slow_clear | "Please … Thank you … Thanks … Sorry … Excuse me … Yes … No." — pass 2 different order: "Sorry … Yes … Thank you … No … Please … Excuse me … Thanks." |

All records: `qa_status: script_review`, `recording_filename` planned per `AUDIO_STYLE_GUIDE.md`, `transcript_release: always_in_practice` for AUD001–002–016 word models (practice audio), `after_response` on any future scored use.

---

## Illustration briefs — 12 complete placeholder records

Style constant for every `generation_prompt`: *"Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details."* Negative base always includes: *"photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects."*

```yaml
id: A1-C01-ILL001
status: placeholder
content_purpose: conversation
semantic_target: the welcome event setting (story world anchor)
must_show: [community hall entrance, welcome table with cups, Alex at the door waving, Maya arranging cups, sunny morning light]
must_not_show: [any text or banner letters, cars, crowds]
characters: [Alex Kim (short black hair, round glasses, mustard sweater, brown backpack), Maya Haddad (dark brown wavy hair tied back, olive jacket, small star pin)]
setting: Aroa Community House exterior, morning
action: Alex waves from the door; Maya sets out cups
composition: establishing wide, building centered, characters at thirds
camera_distance: wide
aspect_ratio: "16:9"
background_complexity: medium
continuity_requirements: [Alex and Maya model sheets A1-CHAR-ILL001/002, cream-orange palette]
alt_text: A bright community hall with a welcome table; Alex, wearing round glasses and a mustard sweater, waves from the door while Maya arranges cups
embedding_slot: S01 promise background; S06 pause; story recaps
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a young person with short black hair, round glasses and a mustard sweater waves from the door of a small community hall while a woman with dark brown wavy hair in an olive jacket arranges cups on a welcome table outside; COMPOSITION: wide establishing shot, building centered, people at the left and right thirds, sunny morning light, 16:9; MUST SHOW: welcome table with cups; open door; waving hand clearly visible; warm morning shadows; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: A bright community hall with a welcome table; Alex, wearing round glasses and a mustard sweater, waves from the door while Maya arranges cups."
```

```yaml
id: A1-C01-ILL002
status: placeholder
content_purpose: vocabulary
semantic_target: good morning (low early sun)
must_show: [low sun near horizon, long soft shadows, steaming cups on the welcome table, Maya arriving]
must_not_show: [text, dark sky, high sun]
characters: [Maya Haddad, Alex Kim]
setting: Community House welcome table, early morning
action: Maya arrives; Alex lifts a hand in greeting
composition: medium shot, table in foreground, low sun behind
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: In soft morning light with a low sun and long shadows, Maya arrives at a welcome table with steaming cups while Alex waves
embedding_slot: V003 card; PR-V003/PR-V006 options
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a woman with dark brown wavy hair in an olive jacket arrives at an outdoor welcome table with steaming cups while a person with round glasses and a mustard sweater waves, under a low morning sun casting long soft shadows; COMPOSITION: medium shot, table foreground, sun low behind at the horizon, 1:1; MUST SHOW: low sun near the horizon; long shadows; steam rising from cups; friendly wave; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: In soft morning light with a low sun and long shadows, Maya arrives at a welcome table with steaming cups while Alex waves."
```

```yaml
id: A1-C01-ILL003
status: placeholder
content_purpose: vocabulary
semantic_target: good afternoon (high sun, midday brightness)
must_show: [sun high in frame, short shadows, café terrace, Nina waving toward Leo in the window]
must_not_show: [text, sunset colors, lamps on]
characters: [Nina Petrova (grey-streaked dark hair in a low bun, teal cardigan, notebook), Leo Novak (tall, curly auburn hair, beard, blue apron)]
setting: Aroa Café terrace, midday
action: Nina waves; Leo waves back from the window
composition: medium shot, terrace foreground, café facade behind
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: Under a high bright midday sun, Nina in a teal cardigan waves to Leo, who waves back from the café window
embedding_slot: V004 card; PR-V006 option
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a woman with grey-streaked dark hair in a low bun and a teal cardigan waves on a café terrace to a tall bearded man with curly auburn hair in a blue apron at the window; COMPOSITION: medium shot, terrace foreground, sun drawn high and bright with very short shadows, 1:1; MUST SHOW: sun high in the frame; short shadows; open friendly waves from both people; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Under a high bright midday sun, Nina in a teal cardigan waves to Leo, who waves back from the café window."
```

```yaml
id: A1-C01-ILL004
status: placeholder
content_purpose: vocabulary
semantic_target: good evening (dark sky, warm lamps)
must_show: [deep blue evening sky, warm street lamps glowing, two neighbors waving across a path]
must_not_show: [text, daylight, sun]
characters: [two background neighbors — distinct from the four cast members, simple designs]
setting: Aroa residential street, evening
action: neighbors wave good evening
composition: medium-wide, lamps framing the path
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: On a darkening street lit by warm lamps under a deep blue sky, two neighbors wave to each other across a path
embedding_slot: V005 card; PR-V004/PR-V006 options
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: two friendly neighbors of different ages waving to each other across a garden path on a residential street; COMPOSITION: medium-wide shot, two warm street lamps framing the path, deep blue evening sky with no sun, warm windows glowing, 1:1; MUST SHOW: dark blue sky; glowing warm lamps; clear mutual wave; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: On a darkening street lit by warm lamps under a deep blue sky, two neighbors wave to each other across a path."
```

```yaml
id: A1-C01-ILL005
status: placeholder
content_purpose: vocabulary
semantic_target: hello / hi (friendly greeting wave)
must_show: [two people facing each other, both smiling, one hand raised in a clear wave]
must_not_show: [text, leaving postures, turned backs]
characters: [Alex Kim, Maya Haddad]
setting: neutral cream background with a soft warm shape
action: greeting wave, eye contact
composition: close-up, faces and wave dominant
camera_distance: close
aspect_ratio: "1:1"
background_complexity: low
alt_text: Two smiling people face each other and one raises a hand in a clear friendly hello wave
embedding_slot: V001/V002 cards; PR-V009
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a person with round glasses and a mustard sweater and a woman with wavy dark hair in an olive jacket stand face to face, both smiling warmly, one hand raised in a clear open wave at chest height; COMPOSITION: close-up, faces and raised waving hand fill the frame, simple cream background with one soft warm shape, 1:1; MUST SHOW: clear raised waving hand; genuine smiles; eye contact between both people; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Two smiling people face each other and one raises a hand in a clear friendly hello wave."
```

```yaml
id: A1-C01-ILL006
status: placeholder
content_purpose: vocabulary
semantic_target: goodbye / bye (leaving through a doorway)
must_show: [one person stepping out through an open doorway, body angled away, head turned back, hand raised in a parting wave]
must_not_show: [text, arriving direction, closed door]
characters: [Maya Haddad leaving; Alex Kim small at frame edge inside]
setting: Community House doorway
action: parting wave
composition: medium shot from inside looking out
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: Maya steps out through an open doorway, turning back to wave goodbye while Alex watches from inside
embedding_slot: V006/V007 cards; PR-V007/PR-V015
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a woman with wavy dark hair steps through an open doorway to the outside, her body angled away but her head turned back, hand raised in a parting wave, while a person with round glasses watches from just inside; COMPOSITION: medium shot from inside the room looking through the door, the leaving figure dominant, 1:1; MUST SHOW: open doorway; body facing away; head turned back; raised waving hand; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Maya steps out through an open doorway, turning back to wave goodbye while Alex watches from inside."
```

```yaml
id: A1-C01-ILL007
status: placeholder
content_purpose: vocabulary
semantic_target: see you (walking apart, looking back)
must_show: [two friends walking away from each other on a park path, both heads turned, mid-wave]
must_not_show: [text, people facing each other]
characters: [Alex Kim and Leo Novak]
setting: park path with a pond behind
action: walking apart, looking back, waving
composition: wide-medium, path running diagonally, one figure each side
camera_distance: wide
aspect_ratio: "16:9"
background_complexity: medium
alt_text: Alex and Leo walk away from each other down a park path, both turning to wave one last time
embedding_slot: V008 card; PR-V005
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: two friends, one with round glasses and a mustard sweater and one tall with curly auburn hair and a beard, walk away from each other in opposite directions along a diagonal park path with a small pond behind; COMPOSITION: wide-medium shot, path running diagonally, one figure on each side with distance between them, both heads turned back toward each other, hands mid-wave, 16:9; MUST SHOW: both figures moving apart; heads turned back; small friendly waves; visible space between them; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Alex and Leo walk away from each other down a park path, both turning to wave one last time."
```

```yaml
id: A1-C01-ILL008
status: placeholder
content_purpose: vocabulary
semantic_target: please (polite asking gesture, offering a request)
must_show: [Maya offering a cup with both hands toward seated Alex, warm asking expression, slight forward lean]
must_not_show: [text, receiving gesture, money]
characters: [Maya Haddad, Alex Kim]
setting: welcome table, bright and simple
action: offering with both hands, asking face
composition: medium shot over Alex's shoulder
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: Maya leans forward slightly and offers a cup with both hands to seated Alex with a warm asking expression
embedding_slot: V009 card; PR-V016
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a woman with wavy dark hair in an olive jacket leans slightly forward and offers a cup with both hands to a seated person with round glasses and a mustard sweater, her face warm and asking, eyebrows gently raised; COMPOSITION: medium shot over the seated person's shoulder, the offering hands and cup in clear focus, 1:1; MUST SHOW: cup held with both hands; forward lean; warm asking expression; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Maya leans forward slightly and offers a cup with both hands to seated Alex with a warm asking expression."
```

```yaml
id: A1-C01-ILL009
status: placeholder
content_purpose: vocabulary
semantic_target: thank you / thanks (receiving with gratitude)
must_show: [Alex receiving the cup, warm smile, free hand briefly at chest]
must_not_show: [text, giving posture, empty hands]
characters: [Alex Kim, Maya Haddad]
setting: welcome table
action: receiving, hand at chest, grateful smile
composition: close-medium on Alex
camera_distance: close
aspect_ratio: "1:1"
background_complexity: low
alt_text: Alex receives a cup from Maya with a warm grateful smile and one hand at his chest
embedding_slot: V010/V011 cards; PR-V013
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a person with round glasses and a mustard sweater takes a cup with one hand from a woman with wavy dark hair, smiling warmly with genuine gratitude, the other hand resting briefly at their chest; COMPOSITION: close-medium shot focused on the exchange and the receiver's face, 1:1; MUST SHOW: cup being received; warm grateful smile; hand at chest; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Alex receives a cup from Maya with a warm grateful smile and one hand at his chest."
```

```yaml
id: A1-C01-ILL010
status: placeholder
content_purpose: vocabulary
semantic_target: sorry (small accident, apologetic posture)
must_show: [Leo with concerned face, one hand raised palm-out, a notebook fallen at his feet]
must_not_show: [text, injury, big damage, angry faces]
characters: [Leo Novak]
setting: community hall entrance
action: small accident moment, apology posture
composition: medium shot
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: Leo looks concerned with one hand raised, palm out, as his notebook lies fallen at his feet
embedding_slot: V012 card; PR-V011
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a tall man with curly auburn hair and a beard in a striped shirt stands with a concerned, apologetic face, one hand raised palm-out at chest height, while his notebook lies closed on the floor at his feet; COMPOSITION: medium shot, the raised palm and the fallen notebook both clearly visible, calm cream setting, 1:1; MUST SHOW: raised palm-out hand; concerned apologetic expression; notebook on the floor; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Leo looks concerned with one hand raised, palm out, as his notebook lies fallen at his feet."
```

```yaml
id: A1-C01-ILL011
status: placeholder
content_purpose: vocabulary
semantic_target: excuse me (politely passing)
must_show: [Nina passing between two chatting people on a narrow path, slight sideways lean, open hand near shoulder]
must_not_show: [text, pushing, contact, dropped items]
characters: [Nina Petrova + two background neighbors]
setting: narrow park path
action: polite passing
composition: medium shot, path along frame
camera_distance: medium
aspect_ratio: "1:1"
background_complexity: low
alt_text: Nina leans politely to one side with an open hand as she passes between two chatting people on a narrow path
embedding_slot: V013 card; PR-V012
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: a woman with grey-streaked dark hair in a low bun and a teal cardigan slides politely between two neighbors chatting on a narrow garden path, leaning slightly sideways with one open hand raised gently near her shoulder; COMPOSITION: medium shot along the path, the passing figure centered between the two standing people, no physical contact, 1:1; MUST SHOW: sideways lean; open gentle hand; clear gap between bodies; calm friendly faces; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects; ALT: Nina leans politely to one side with an open hand as she passes between two chatting people on a narrow path."
```

```yaml
id: A1-C01-ILL012
status: placeholder
content_purpose: vocabulary
semantic_target: yes / no (gesture pair)
must_show: [two equal halves, one figure nodding with a smile, same figure gently shaking head with calm palm-out; identical size, style, and salience]
must_not_show: [text, one half larger or brighter, check or cross symbols]
characters: [Alex Kim, twice]
setting: plain cream background
action: nod vs gentle head-shake
composition: strict diptych, mirrored framing
camera_distance: close
aspect_ratio: "1:1"
background_complexity: low
alt_text: The same smiling person nods yes on the left half and gently shakes their head no with a soft palm-out gesture on the right half
embedding_slot: V014/V015 cards
generation_prompt: "Original modern editorial illustration, organic shapes, clean line work, restrained texture, cream background with warm orange and terracotta accents, soft brown lines, charcoal details; SUBJECT: the same person with round glasses and a mustard sweater shown twice in two equal side-by-side halves — in the left half nodding with a clear happy smile, head tilted slightly down mid-nod; in the right half gently shaking the head with a calm soft palm-out hand at chest height; COMPOSITION: strict mirrored diptych, both figures the same size, same framing, same lighting, identical visual salience on both halves, thin center divider, 1:1; MUST SHOW: clear nod on the left; clear gentle head-shake with soft palm on the right; perfectly equal halves; MUST NOT SHOW: photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D, stereotypes, distorted hands, duplicate objects, check marks, cross marks; ALT: The same smiling person nods yes on the left half and gently shakes their head no with a soft palm-out gesture on the right half."
```

All 12: `answer_leakage_check: pass` (briefs depict the target construct; distractor scenes are distinct constructs, parallel salience kept), `cultural_review: pass` (no stereotype, no inferred nationality), `accessibility_review: pass` (contrast vs cream ≥ AA at card size; no color-only cues).

---

## Accessibility and integrity notes (lesson-level)

- Every audio item: transcript released only after the scored/attempted response (word models are practice audio — always viewable after first play).
- One default replay per audio stimulus; additional replays via hint rung 1; never penalized.
- Non-audio route: PR-V001/002/006/008/010/014 offer a picture-cue equivalent (same construct, visual channel) and log listening as `not measured` for the audio variant.
- Voice order for every screen defined in its UI/UX tip; Dynamic Type supported to XL without truncation (word cards are short by design).
- No drag interactions in this lesson; no timers; no color-only meaning (sun position, lamps, gestures carry the time-of-day constructs, with alt-text equivalents).

## Ledger delta and register usage

- `LEXICAL_LEDGER.csv`: rows V001–V015 already `taught` (introduced_lesson 1). No other rows touched.
- `GRAMMAR_LEDGER.csv`: no changes (G001–G003 remain scheduled for L2).
- `ILLUSTRATION_ID_REGISTER.csv`: A1-C01 block — 12 of 40 used; next available `A1-C01-ILL013`.
- `QA_STATUS.md`: updated with this lesson's artifact counts.
