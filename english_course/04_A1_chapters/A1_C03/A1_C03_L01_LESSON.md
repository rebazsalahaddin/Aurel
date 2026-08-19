# A1 — Chapter 3 — Lesson 1 (A1-C03-L01) — Countries, Languages, Jobs

```yaml
lesson_id: A1-C03-L01
lesson_type: V                       # vocabulary lesson (chapter's full lexical load)
chapter: 3
title: "Where Are You From? — Part 1: Countries, Languages, Jobs"
estimated_minutes: 20                # pause point after Set B practices (≈ minute 9)
prerequisites:
  chapters: [1, 2]                   # all C1/C2 targets taught; nothing conditionally scheduled
  verified_against: "LEXICAL_LEDGER.csv (50 taught rows) · GRAMMAR_LEDGER.csv (G001–G006 taught)"
artifacts_manifest:
  vocabulary_records: 36             # A1-C03-L01-V001…V036, full §10.4 schema
  practice_items: 40                 # PR-V001–036 + PR-P001–004 (warm-up WU1–3 separate)
  audio_scripts: 44                  # A1-C03-AUD001…AUD044
  illustration_briefs: 22            # A1-C03-ILL001…ILL022
  screens: 12                        # A1-C03-S01…S12
macro_definitions_for_F3:            # expand at export time only, never inside learner content
  STYLE: >-
    Original modern editorial illustration, organic shapes, clean line work, restrained
    texture, generous negative space, cream background, warm orange and terracotta accents,
    soft brown lines, charcoal detail, one muted green and one muted blue as secondary
    support, WCAG-AA contrast, readable at small size
  NEG: >-
    photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D,
    stereotypes, distorted hands, duplicate objects, flags, national symbols
rulings_recorded_for_lens_3:
  - "Country triples = ONE record each: headword = country name; nationality adjective and
    language(s) stored in-record at recognition level. Productive target = the country name
    inside 'I'm from …'; language names are repeated inside the modelled 'They speak …'
    frame. §9.3 does not add nationality adjectives as productive A1 grammar."
  - "Set E (4 jobs) is below the 5-item micro-set floor: attached to Set D on the same teach
    screen (same disposition as C2-B / C2-D attached sets). Full encounter count preserved
    via cast-anchored audio."
  - "Grammar guardrail: 3rd-person be appears in L1 ONLY inside the two fixed chunks
    ('Where is Alex from?') and in cast first-person audio. No practice stem or option
    produces he/she/is/are freely — that is G007 in L2. All listening stems are first-person
    cast lines or taught chunks."
  - "'I'm a/an …' is presented as a FIXED frame in L1; the a/an-by-sound rule is G009 in L2.
    No L1 item asks the learner to choose between a and an."
instruction_lexicon_note: >-
  No new instruction words this lesson; stages 1–3 only (listen, look, tap, choose, match,
  say, repeat, one, two, again, correct, try again, put in order, first, next, last).
  The one sorting activity (PR-V017) is icon-cued with a two-basket demo animation —
  "sort" is not in the controlled lexicon and is never used as a word. The supported
  recording (PR-P004) is icon-cued (microphone demo); the word "record" activates in L2.
scene_glue_note: >-
  Hook scene glue words (map, wall, welcome, class, turn, next time) are receptive,
  illustrated in ILL001, never tested, never practice targets. All Aroa canon from
  CHARACTER_AND_VISUAL_BIBLE.md; cast origins fixed there BEFORE this lesson was authored.
```

---

## Chapter can-do promise (restated at chapter start, screen S00-lead)

This chapter: **ask and answer "Where are you from?", say your languages, say your job, introduce a friend, and understand short identity profiles.** Today's lesson gives you all the words: countries, languages, jobs, and the frames that carry them.

---

# S01 — Story hook: "Neighbors Around the World"

**Screen:** full-bleed [ILL: A1-C03-ILL001 | alt: Nina, Alex, Maya, Leo and Sam stand beside a big world-map wall with orange dots; Sam holds a sheet of orange dot stickers]. Auto-plays A1-C03-AUD001 (learning take) with line-by-line highlight. Replay always available.

**Continuity (bible-fixed):** the morning after the Chapter 2 check-in, in the Community House big hall. Sam's orange dots come from his corner shop (his tote appears). Maya and Sam met at the welcome event and are friends (C1-L4) — "This is my friend Sam" is bible-true. Cast origins: Alex Canada · Maya Egypt · Leo Australia · Nina Peru · Sam Mexico.

### A1-C03-AUD001 — Hook dialogue (learning take)

```yaml
id: A1-C03-AUD001
purpose: story_hook
voices: [NINA, ALEX, MAYA, LEO, SAM]
delivery_style: learning_slow_clear
pacing: ≈100–110 wpm; … pauses 400–600 ms; country names slightly emphasized
script: |
  NINA: Good morning! Welcome to your first community class.
  ALEX: Okay! Look at this! … A big map, and orange dots!
  NINA: One orange dot … for one country. (warm) Maya, first?
  MAYA: Good, good. I'm from Egypt. I speak Arabic and English.
  NINA: Egypt. … One dot.
  LEO: Ah! My turn. I'm from Australia. I speak English.
  ALEX: I'm from Canada. I speak English and French.
  NINA: And I'm from Peru. I speak Spanish.
  MAYA: Look! … This is my friend Sam.
  SAM: Hi! I'm Sam. I'm from Mexico — Spanish and English. Nice to meet you!
  LEO: Nice to meet you too.
  ALEX: Five dots! … And you? Where are you from?
  NINA: (warm) Share, if you like. Your dot goes here next time.
transcript_release: after_one_pass
qa_status: script_review
targets_planted: [V007 Canada, V008 Mexico, V009 Peru, V010 Egypt, V011 Australia,
  V003 from, V005 English, V006 speak, V029 "This is …", V031 "Nice to meet you too",
  V032 "Where are you from?", V033 "I'm from …"]
guardrail: >-
  Nina's closing line makes origin-sharing voluntary ("Share, if you like"). No character
  asks about status, documents, or residence — origins are personal facts offered freely.
```

**Mission seed:** the empty space on the wall (one unused dot) is for the learner — they place it in the C3-L3 mission.

---

# S02 — Warm-up (retrieval only: Chapters 1–2)

Three quick taps, one per prior target; icon-cued, no new language.

| id | retrieves | format | correct | distractor rationale |
|---|---|---|---|---|
| WU1 | A1-C01-L01-V003 `good morning` | audio "Good morning." → choose reply | "Good morning." | "Goodbye." / "See you." = farewell mixed into a greeting exchange (timing error) |
| WU2 | A1-C02-L01-PAT001 alphabet + A1-C02-L01-V007 `How do you spell that?` | audio "How do you spell that?" + photo of Maya → choose the letter chain | M-A-Y-A | M-A-Y-O (letter-name sound confusion a/ei), M-Y-A-A (order swap — the C2 repair skill) |
| WU3 | A1-C02-L02-PAT002–005 numbers + Leo's canon phone | audio LEO: "My phone number is six two zero … one five four." → choose the digits | 6-2-0, 1-5-4 | 6-2-0, 1-4-5 (four/five mishearing), 6-0-2, 1-5-4 (two/zero order loss) |

WU1–WU3 are warm-up retrieval, not bank items; they carry feedback lines only ("Correct! / Try again — listen one more time.").

---

# S03 — Micro-set A teach: the origin frame (6 records)

**Screen:** card carousel, one card per word: [ILL: A1-C03-ILL002 | alt: one card shows open country landscape with fields and hills; the other shows a city with streets and houses]. Each card: word, model audio (AUD002–007), one frame line reused from the hook.

## Vocabulary records V001–V006

```yaml
id: A1-C03-L01-V001
content_version: 1.0.0
headword_or_phrase: country
primary_spelling: country
accepted_variants: [{spelling: countries, note: plural — recognition only in A1 core}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a nation people can be from, e.g. Canada, Egypt, Japan
learner_definition: a big place — one country, one name on the map. Canada is a country.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈkʌn.tri"
stress_pattern: "● ○  COUN-try"
audio_asset_ids: [A1-C03-AUD002]
core_collocation_or_frame: "One country, one dot." / "Canada is a country."
example_sentence: Egypt is a country.
example_known_language_check: passed   # all words taught (C1 is/my hook I'm from Egypt)
illustration_asset_id: A1-C03-ILL002   # landscape half of the split card
semantic_cue: orange dot placed on a map region
alt_text: open landscape with rolling fields and distant hills under a cream sky
common_confusion: country vs city (both big places; one has fields, one has streets)
feedback_for_confusion: "A country is very big — Canada, Egypt, Japan. A city has streets
  and houses — Aroa is a city."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V002
content_version: 1.0.0
headword_or_phrase: city
primary_spelling: city
accepted_variants: [{spelling: cities, note: plural — recognition only in A1 core}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a large town with streets and buildings where people live
learner_definition: a place with streets and houses. Aroa is a city.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈsɪt.i"
stress_pattern: "● ○  CI-ty"
audio_asset_ids: [A1-C03-AUD003]
core_collocation_or_frame: "Aroa is a city."
example_sentence: Aroa is a city.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL002   # city half of the split card
semantic_cue: blocks, streets, small houses
alt_text: small city with streets, houses, and a park corner under a soft sky
common_confusion: city vs country (see V001)
feedback_for_confusion: "City: streets and houses. Country: the very big place — Canada, Japan."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V003
content_version: 1.0.0
headword_or_phrase: from
primary_spelling: from
accepted_variants: []
part_of_speech_or_function: preposition (fixed frame: I'm from …)
cefr_level_hypothesis: A1
sense_definition_for_creators: names the place a person's origin is tied to, after be
learner_definition: says your place. I'm from Peru. = Peru is my place.
prerequisite_ids: [A1-C01-L02-G001]    # I'm frame known from Ch1
pronunciation_model: general_american
ipa: "frʌm"                            # strong form; weak /frəm/ noted for listening
stress_pattern: one strong syllable
audio_asset_ids: [A1-C03-AUD004]
core_collocation_or_frame: "I'm from Peru." / "Where are you from?"
example_sentence: Maya is from Egypt.
example_known_language_check: passed   # 3rd-person is appears in hook-echo line only (chunk context)
illustration_asset_id: A1-C03-ILL001   # hook scene: dot placed on map region
semantic_cue: orange dot moving from a person to their map region
alt_text: hand placing an orange dot on a world map while a figure waves
common_confusion: "I'm from Mexico." vs "I'm Mexico." (dropping from)
feedback_for_confusion: "Say from: I'm FROM Mexico — from says your place."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V004
content_version: 1.0.0
headword_or_phrase: language
primary_spelling: language
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a system of words people speak, e.g. Arabic, English
learner_definition: what people speak. Arabic is a language. English is a language.
prerequisite_ids: [A1-C03-L01-V006]    # speak co-taught; frame taught together
pronunciation_model: general_american
ipa: "ˈlæŋ.ɡwɪdʒ"
stress_pattern: "● ○○  LAN-guage"
audio_asset_ids: [A1-C03-AUD005]
core_collocation_or_frame: "I speak Arabic and English. Two languages!"
example_sentence: English is a language.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL001
semantic_cue: two speech bubbles (blank — no letters) over Maya's hook line
alt_text: two empty rounded speech bubbles floating over talking figures
common_confusion: language vs English (English is ONE language; language is the kind of thing)
feedback_for_confusion: "English, Arabic, Spanish — these are languages. 'Language' is the
  name for all of them."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V005
content_version: 1.0.0
headword_or_phrase: English
primary_spelling: English
accepted_variants: []
part_of_speech_or_function: noun (language name; capitalized, fixed)
cefr_level_hypothesis: A1
sense_definition_for_creators: the language of this course; the learners' target language
learner_definition: the language of this app! You speak English here.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈɪŋ.ɡlɪʃ"
stress_pattern: "● ○  ENG-lish"
audio_asset_ids: [A1-C03-AUD006]
core_collocation_or_frame: "I speak English."
example_sentence: Leo speaks English. → taught as echo of hook: LEO: I speak English.
example_known_language_check: passed   # delivered as hook echo (first person), not free 3rd person
illustration_asset_id: A1-C03-ILL001
semantic_cue: Leo's hook speech bubble replay
alt_text: man at a map wall saying a line into a blank speech bubble
common_confusion: English (the language) vs english — always capitalized as a name
feedback_for_confusion: "English is a name — big E: English."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V006
content_version: 1.0.0
headword_or_phrase: speak
primary_spelling: speak
accepted_variants: []
part_of_speech_or_function: verb (frames only: I speak … / They speak … — full verb system is C7)
cefr_level_hypothesis: A1
sense_definition_for_creators: produce a language
learner_definition: you speak a language. I speak English!
prerequisite_ids: []
pronunciation_model: general_american
ipa: "spiːk"
stress_pattern: "●  SPEAK"
audio_asset_ids: [A1-C03-AUD007]
core_collocation_or_frame: "I speak Arabic and English." / "They speak Spanish."
example_sentence: I speak English.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL001
semantic_cue: mouth-open talking gesture beside blank speech bubbles
alt_text: figure speaking warmly beside two empty speech bubbles
common_confusion: speak vs say (say = one word/thing now; speak = a language you have)
feedback_for_confusion: "A language? Use speak. One word? Use say. (say is from Chapter 2.)"
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S04 — Micro-set A practice (6 items)

**Screen:** tap-first cards; help ladder = (1) replay audio, (2) highlight the frame, (3) show the hook line. Feedback always names the rule, never "wrong".

```yaml
id: A1-C03-L01-PR-V001
type: audio_word_to_image               # 2 options
instruction_words: [listen, tap]
stimulus_audio: A1-C03-AUD002 (country)
target_ids: [A1-C03-L01-V001, A1-C03-L01-V002]
options:
  - {id: A, asset: "ILL002 left half — fields and hills"}
  - {id: B, asset: "ILL002 right half — streets and houses"}
correct_option_ids: [A]
distractor_rationales:
  B: "city — the near-pair taught in the same set; picture cue distinguishes them"
feedback_correct: "Yes — country: fields, hills, very big."
feedback_incorrect: "Listen one more time. City has streets. Country is fields and hills."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V002
type: audio_word_to_word                 # 3 options
instruction_words: [listen, choose]
stimulus_audio: "fresh take — GUIDE: I'm from Canada. … from! … from"
target_ids: [A1-C03-L01-V003]
options:
  - {id: A, text: from}
  - {id: B, text: friend}
  - {id: C, text: fine}
correct_option_ids: [A]
distractor_rationales:
  B: "friend — /fr/ sound-alike taught today (V026)"
  C: "fine — /f/ + long-i sound-alike from C1-L02 V017"
feedback_correct: "From! I'm FROM Canada."
feedback_incorrect: "The word says your place: I'm ____ Canada. Try again."
prerequisite_ids: [A1-C01-L02-V019]
```

```yaml
id: A1-C03-L01-PR-V003
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL002 city half (recolored variant: streets and houses)"
target_ids: [A1-C03-L01-V002]
options:
  - {id: A, text: country}
  - {id: B, text: city}
  - {id: C, text: language}
correct_option_ids: [B]
distractor_rationales:
  A: "country — the near-pair; picture shows streets and houses, not fields"
  C: "language — set-mate; a language is spoken, not a place"
feedback_correct: "City — streets and houses. Aroa is a city."
feedback_incorrect: "Look at the picture: streets and houses. Which word is that?"
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V004
type: word_bank_gap                      # 3 tiles
instruction_words: [choose]
stimulus: "Kenya · They ____ English and Swahili."
target_ids: [A1-C03-L01-V006]
options:
  - {id: A, text: say}
  - {id: B, text: listen}
  - {id: C, text: speak}
correct_option_ids: [C]
distractor_rationales:
  A: "say = one word or one thing now, not a language you have"
  B: "listen = take in; speaking is producing"
feedback_correct: "They speak English and Swahili. Speak + language!"
feedback_incorrect: "A language goes with speak. Try again."
prerequisite_ids: [A1-C02-L01-V005, A1-C02-L01-V006]
```

```yaml
id: A1-C03-L01-PR-V005
type: audio_detail_to_map                # 3 map-card options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — NINA: Hi! I'm Nina. I'm from Peru."
target_ids: [A1-C03-L01-V009]
options:
  - {id: A, asset: "ILL005 Peru map card"}
  - {id: B, asset: "ILL011 Spain map card"}
  - {id: C, asset: "ILL004 Mexico map card"}
correct_option_ids: [A]
distractor_rationales:
  B: "Spain — Spanish-speaking like Peru; Nina speaks Spanish, so it pulls"
  C: "Mexico — also Spanish-speaking; both plausible until the country word is heard"
feedback_correct: "Peru! Nina is from Peru. (She speaks Spanish.)"
feedback_incorrect: "Listen for the country word at the end: I'm from …"
prerequisite_ids: [A1-C03-L01-V033]
```

```yaml
id: A1-C03-L01-PR-V006
type: spelling_choice                    # 3 options — CUMULATIVE (retrieves C2 spelling)
instruction_words: [look, choose]
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L01-V001 spell + A1-C02-L01-V007 How do you spell that?"
stimulus: "GUIDE: How do you spell that? … language"
target_ids: [A1-C03-L01-V004]
options:
  - {id: A, text: langwige}
  - {id: B, text: language}
  - {id: C, text: langauge}
correct_option_ids: [B]
distractor_rationales:
  A: "sound-written form — /dʒ/ written as g, /ɪ/ as i-e"
  C: "letter-order swap inside the -gua- sequence — the C2 'read it again' repair catches this"
feedback_correct: "language. L-A-N-G-U-A-G-E."
feedback_incorrect: "Say it slowly, then look again: lan-guage."
prerequisite_ids: [A1-C02-L01-V001, A1-C02-L01-PAT001]
```

**Set A blended review:** A1-C03-AUD038 — `GUIDE: country … city … from … language … English … speak … Now you: Canada is a country. Aroa is a city. I'm from … I speak English.`

---

# S05 — Micro-set B teach: the cast five countries (5 records)

**Screen:** five map cards in a row (ILL003–007), each with the cast member's hook line replay (first-person audio), the country word large, and the triple under it: *country → nationality · languages*. Tap a card: model plays (AUD008–012), learner repeats (say-icon).

**Map-card art base (all ten cards, ILL003–012):** one shared visual grammar — simplified, textless world map in soft browns on cream; the country's region filled in warm orange; no borders drawn with labels, no flags, no text. ALT text names the country (app layer). Highlights read at small size; color is never the only cue (region shape + position carry it too).

```yaml
id: A1-C03-L01-V007
content_version: 1.0.0
headword_or_phrase: Canada
primary_spelling: Canada
accepted_variants: []
part_of_speech_or_function: proper noun (country name; capitalized, fixed)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in North America; Alex's origin (bible-fixed)
learner_definition: a country. Alex is from Canada.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈkæn.ə.də"
stress_pattern: "● ○ ○  CA-na-da"
audio_asset_ids: [A1-C03-AUD008]
core_collocation_or_frame: "I'm from Canada. · Canadian · English and French"
example_sentence: ALEX (hook echo): I'm from Canada. I speak English and French.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL003
semantic_cue: orange-highlighted region on the textless world map (north, wide)
alt_text: simplified world map with Canada's region filled in warm orange
common_confusion: Canada vs Kenya sound (both 3 syllables, /k/ start, /ə/ middle)
feedback_for_confusion: "CA-na-da — three parts, starts like cat. Kenya starts like Ken."
nationality_and_languages_recognition: "Canadian · English and French (both official —
  Canada has two official languages)"
creator_note_inclusion: >-
  Canada has two official languages and many immigrant and Indigenous languages besides;
  the card names two, never "Canada's language" singular.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V008
content_version: 1.0.0
headword_or_phrase: Mexico
primary_spelling: Mexico
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in North America; Sam's origin (bible-fixed)
learner_definition: a country. Sam is from Mexico.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈmɛk.sɪ.koʊ"
stress_pattern: "● ○ ○  ME-xi-co"
audio_asset_ids: [A1-C03-AUD009]
core_collocation_or_frame: "I'm from Mexico. · Mexican · Spanish and English"
example_sentence: SAM (hook echo): I'm from Mexico — Spanish and English.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL004
semantic_cue: orange-highlighted region on the textless world map (south of Canada's)
alt_text: simplified world map with Mexico's region filled in warm orange
common_confusion: Mexico vs Mexican (country vs person-word; -can ending)
feedback_for_confusion: "Mexico = the country. Mexican = from Mexico."
nationality_and_languages_recognition: "Mexican · Spanish (many Indigenous languages too)"
creator_note_inclusion: >-
  Spanish is the majority language; Mexico recognizes many Indigenous languages. Card says
  Spanish; never imply one language or one identity.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V009
content_version: 1.0.0
headword_or_phrase: Peru
primary_spelling: Peru
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in South America; Nina's origin (bible-fixed)
learner_definition: a country. Nina is from Peru.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "pəˈruː"
stress_pattern: "○ ●  pe-RU"
audio_asset_ids: [A1-C03-AUD010]
core_collocation_or_frame: "I'm from Peru. · Peruvian · Spanish"
example_sentence: NINA (hook echo): I'm from Peru. I speak Spanish.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL005
semantic_cue: orange-highlighted region on the textless world map (west coast of South America)
alt_text: simplified world map with Peru's region filled in warm orange
common_confusion: Peru stress (pe-RU, last part strong — like hello he-LLO rhythm)
feedback_for_confusion: "Pe-RU — the last part is strong."
nationality_and_languages_recognition: "Peruvian · Spanish (Quechua and Aymara also official)"
creator_note_inclusion: >-
  Peru has more than one official language; the card names Spanish, notes exist for creators.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V010
content_version: 1.0.0
headword_or_phrase: Egypt
primary_spelling: Egypt
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in Africa; Maya's origin (bible-fixed)
learner_definition: a country. Maya is from Egypt.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈiː.dʒɪpt"
stress_pattern: "● ●  EE-gypt"
audio_asset_ids: [A1-C03-AUD011]
core_collocation_or_frame: "I'm from Egypt. · Egyptian · Arabic and English"
example_sentence: MAYA (hook echo): I'm from Egypt. I speak Arabic and English.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL006
semantic_cue: orange-highlighted region on the textless world map (northeast Africa)
alt_text: simplified world map with Egypt's region filled in warm orange
common_confusion: Egypt vs Japanese ending sound (-gypt /dʒɪpt/ vs -ese /niːz/)
feedback_for_confusion: "EE-gypt — strong first part, short and quick at the end."
nationality_and_languages_recognition: "Egyptian · Arabic (English widely used)"
creator_note_inclusion: >-
  Arabic is the official language; naming one language is a card limit, not a claim.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V011
content_version: 1.0.0
headword_or_phrase: Australia
primary_spelling: Australia
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in Oceania; Leo's origin (bible-fixed)
learner_definition: a country. Leo is from Australia.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ɔːˈstreɪl.jə"
stress_pattern: "○ ● ○  au-STRA-lia"
audio_asset_ids: [A1-C03-AUD012]
core_collocation_or_frame: "I'm from Australia. · Australian · English"
example_sentence: LEO (hook echo): I'm from Australia. I speak English.
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL007
semantic_cue: orange-highlighted region on the textless world map (southeast, island continent)
alt_text: simplified world map with Australia's region filled in warm orange
common_confusion: Australia vs Australian (country vs person-word — like Mexico/Mexican)
feedback_for_confusion: "Australia = the country. Australian = from Australia."
nationality_and_languages_recognition: "Australian · English"
creator_note_inclusion: >-
  Australia's first languages are Aboriginal and Torres Strait Islander languages; English
  named on the card is the most-spoken language today, not the only one.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S06 — Micro-set B practice + PAUSE POINT

**Screen:** practices PR-V007–012, then the pause card. **Pause card (≈ minute 9):** "Five dots on the wall! Take a break — or one more time?" [continue] [break]. Break exits cleanly; continue enters Set C.

```yaml
id: A1-C03-L01-PR-V007
type: match_pairs                        # 5 pairs, no positional key
instruction_words: [match]
stimulus: "left: 5 map cards (ILL003–007) · right: 5 country words"
target_ids: [A1-C03-L01-V007, A1-C03-L01-V008, A1-C03-L01-V009, A1-C03-L01-V010, A1-C03-L01-V011]
pairs: {ILL003: Canada, ILL004: Mexico, ILL005: Peru, ILL006: Egypt, ILL007: Australia}
feedback_correct: "All five! The cast five."
feedback_incorrect: "Listen to the word, then look at the map shape and place."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V008
type: audio_detail_to_map                # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — MAYA: Hi! I'm Maya. I'm from Egypt."
target_ids: [A1-C03-L01-V010]
options:
  - {id: A, asset: "ILL009 Japan map card"}
  - {id: B, asset: "ILL004 Mexico map card"}
  - {id: C, asset: "ILL006 Egypt map card"}
correct_option_ids: [C]
distractor_rationales:
  A: "Japan — /dʒ/ start sound-pulls with Egypt's /dʒ/ middle"
  B: "Mexico — set-mate; plausible until the country word lands"
feedback_correct: "Egypt! Maya is from Egypt."
feedback_incorrect: "Listen for the country word: I'm from …"
prerequisite_ids: [A1-C03-L01-V033]
```

```yaml
id: A1-C03-L01-PR-V009
type: question_to_word                   # 3 options (uses the taught chunk as stem)
instruction_words: [choose]
stimulus: "Where is Alex from?"
target_ids: [A1-C03-L01-V007, A1-C03-L01-V034]
options:
  - {id: A, text: Canada}
  - {id: B, text: Egypt}
  - {id: C, text: Mexico}
correct_option_ids: [A]
distractor_rationales:
  B: "Egypt — Maya's country; cast-fact cross-over"
  C: "Mexico — Sam's country; cast-fact cross-over"
feedback_correct: "Alex is from Canada. (English and French!)"
feedback_incorrect: "Remember the hook: Alex speaks English and French."
prerequisite_ids: [A1-C03-L01-V034]
```

```yaml
id: A1-C03-L01-PR-V010
type: best_reply                         # 3 options
instruction_words: [choose]
stimulus_audio: "fresh take — GUIDE: Where are you from?"
target_ids: [A1-C03-L01-V033]
options:
  - {id: A, text: "My name is Mexico."}
  - {id: B, text: "I'm from Mexico."}
  - {id: C, text: "I'm Mexico."}
correct_option_ids: [B]
distractor_rationales:
  A: "name-frame swapped into an origin question (name vs from confusion)"
  C: "missing from — the classic drop; from says your place"
feedback_correct: "I'm from Mexico. From + country!"
feedback_incorrect: "The question asks your place, not your name. Use from."
prerequisite_ids: [A1-C01-L02-V026, A1-C03-L01-V003]
```

```yaml
id: A1-C03-L01-PR-V011
type: word_bank_gap                      # 3 tiles, language names at recognition level
instruction_words: [choose]
stimulus: "Canada · They speak English and ____."
target_ids: [A1-C03-L01-V007]
options:
  - {id: A, text: Swahili}
  - {id: B, text: Japanese}
  - {id: C, text: French}
correct_option_ids: [C]
distractor_rationales:
  A: "Swahili — Kenya's language; strong sound-image from Set C model"
  B: "Japanese — Japan's language; same pull"
feedback_correct: "English and French — Canada's two official languages."
feedback_incorrect: "Listen to Alex's line again: English and …"
prerequisite_ids: [A1-C03-L01-V006]
```

```yaml
id: A1-C03-L01-PR-V012
type: audio_detail_to_map                # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — SAM: Hi! I'm Sam. I'm from Mexico."
target_ids: [A1-C03-L01-V008]
options:
  - {id: A, asset: "ILL004 Mexico map card"}
  - {id: B, asset: "ILL005 Peru map card"}
  - {id: C, asset: "ILL003 Canada map card"}
correct_option_ids: [A]
distractor_rationales:
  B: "Peru — Spanish-speaking like Mexico; language pulls before country lands"
  C: "Canada — Alex's country; hook-neighbor confusion"
feedback_correct: "Mexico! Sam is from Mexico."
feedback_incorrect: "Sam speaks Spanish and English — but where is he from? Listen again."
prerequisite_ids: [A1-C03-L01-V033]
```

**Set B blended review:** A1-C03-AUD039 — `GUIDE: Canada — I'm from Canada … Mexico — I'm from Mexico … Peru — I'm from Peru … Egypt — I'm from Egypt … Australia — I'm from Australia. … Five dots on the wall!`

---

# S07 — Micro-set C teach: the world five countries (5 records)

**Screen:** same map-card grammar (ILL008–012). These five have no cast owner, so the guide voice carries them with a "world tour" frame: `Brazil — they speak Portuguese!` — each card names country, nationality, language at recognition level. The learner's productive frame stays `I'm from …` (used in S12 with a free choice of any of the ten).

```yaml
id: A1-C03-L01-V012
content_version: 1.0.0
headword_or_phrase: Brazil
primary_spelling: Brazil
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in South America
learner_definition: a country. People from Brazil speak Portuguese.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "brəˈzɪl"
stress_pattern: "○ ●  bra-ZIL"
audio_asset_ids: [A1-C03-AUD013]
core_collocation_or_frame: "I'm from Brazil. · Brazilian · Portuguese"
example_sentence: GUIDE (teach card): Brazil! … They speak Portuguese in Brazil. → taught as
  "Brazil · They speak Portuguese."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL008
semantic_cue: orange-highlighted region on the textless world map (east South America)
alt_text: simplified world map with Brazil's region filled in warm orange
common_confusion: Brazil stress (bra-ZIL — strong last part, like Peru pe-RU)
feedback_for_confusion: "bra-ZIL — last part strong."
nationality_and_languages_recognition: "Brazilian · Portuguese"
creator_note_inclusion: >-
  Brazil also has Indigenous and immigrant languages; Portuguese is the most-spoken language.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V013
content_version: 1.0.0
headword_or_phrase: Japan
primary_spelling: Japan
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in Asia
learner_definition: a country. People from Japan speak Japanese.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "dʒəˈpæn"
stress_pattern: "○ ●  Ja-PAN"
audio_asset_ids: [A1-C03-AUD014]
core_collocation_or_frame: "I'm from Japan. · Japanese · Japanese"
example_sentence: "Japan · They speak Japanese."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL009
semantic_cue: orange-highlighted region on the textless world map (east Asia, island arc)
alt_text: simplified world map with Japan's region filled in warm orange
common_confusion: Japan vs Japanese (country vs language-and-person word — SAME word for both in Japanese)
feedback_for_confusion: "Japan = the country. Japanese = the language AND the person word."
nationality_and_languages_recognition: "Japanese · Japanese"
creator_note_inclusion: >-
  Japan has other languages (for example Ryukyuan languages); Japanese is the main language.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V014
content_version: 1.0.0
headword_or_phrase: Kenya
primary_spelling: Kenya
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in East Africa
learner_definition: a country. People from Kenya speak Swahili and English.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈkɛn.jə"
stress_pattern: "● ○  KEN-ya"
audio_asset_ids: [A1-C03-AUD015]
core_collocation_or_frame: "I'm from Kenya. · Kenyan · Swahili and English"
example_sentence: "Kenya · They speak Swahili and English."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL010
semantic_cue: orange-highlighted region on the textless world map (East Africa)
alt_text: simplified world map with Kenya's region filled in warm orange
common_confusion: Kenya vs Canada (both 3 syllables, /k/ start; CA-na-da vs KEN-ya)
feedback_for_confusion: "KEN-ya — two parts, starts like Ken. Canada has three parts."
nationality_and_languages_recognition: "Kenyan · Swahili and English (both official)"
creator_note_inclusion: >-
  Kenya has many languages besides its two official ones; two are named on the card.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V015
content_version: 1.0.0
headword_or_phrase: Spain
primary_spelling: Spain
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in Europe
learner_definition: a country. People from Spain speak Spanish.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "speɪn"
stress_pattern: "●  SPAIN"
audio_asset_ids: [A1-C03-AUD016]
core_collocation_or_frame: "I'm from Spain. · Spanish · Spanish"
example_sentence: "Spain · They speak Spanish."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL011
semantic_cue: orange-highlighted region on the textless world map (southwest Europe)
alt_text: simplified world map with Spain's region filled in warm orange
common_confusion: Spain vs Spanish (country vs language; one strong syllable vs two)
feedback_for_confusion: "Spain = the country (one part). Spanish = the language (two parts)."
nationality_and_languages_recognition: "Spanish (adjective) · Spanish"
creator_note_inclusion: >-
  Spain also has co-official regional languages (Catalan, Galician, Basque among them);
  Spanish is the card's named language.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V016
content_version: 1.0.0
headword_or_phrase: India
primary_spelling: India
accepted_variants: []
part_of_speech_or_function: proper noun (country name)
cefr_level_hypothesis: A1
sense_definition_for_creators: country in South Asia
learner_definition: a country. People from India speak Hindi and English — and many more.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈɪn.di.ə"
stress_pattern: "● ○ ○  IN-di-a"
audio_asset_ids: [A1-C03-AUD017]
core_collocation_or_frame: "I'm from India. · Indian · Hindi and English"
example_sentence: "India · They speak Hindi and English."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL012
semantic_cue: orange-highlighted region on the textless world map (South Asia)
alt_text: simplified world map with India's region filled in warm orange
common_confusion: India vs Indian (country vs person-word; -an ending again)
feedback_for_confusion: "India = the country. Indian = from India."
nationality_and_languages_recognition: "Indian · Hindi and English"
creator_note_inclusion: >-
  India has many, many languages (dozens with official recognition); two are named on the
  card and the teach screen says "and many more" — never one language, never one identity.
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S08 — Micro-set C practice + pronunciation 1 (6 items)

```yaml
id: A1-C03-L01-PR-V013
type: match_pairs                        # 5 pairs
instruction_words: [match]
stimulus: "left: 5 map cards (ILL008–012) · right: 5 country words"
target_ids: [A1-C03-L01-V012, A1-C03-L01-V013, A1-C03-L01-V014, A1-C03-L01-V015, A1-C03-L01-V016]
pairs: {ILL008: Brazil, ILL009: Japan, ILL010: Kenya, ILL011: Spain, ILL012: India}
feedback_correct: "Five more! Ten countries now."
feedback_incorrect: "Say the word, then look at the map shape and place."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V014
type: audio_word_to_map                  # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C03-AUD016 (Spain, model take)
target_ids: [A1-C03-L01-V015]
options:
  - {id: A, asset: "ILL008 Brazil map card"}
  - {id: B, asset: "ILL011 Spain map card"}
  - {id: C, asset: "ILL012 India map card"}
correct_option_ids: [B]
distractor_rationales:
  A: "Brazil — the set's other 'strong-last-part' country; sound-image pull"
  C: "India — three-part /-ə/ ending neighbor; shape pull on a small map"
feedback_correct: "Spain — SPAIN, one strong part."
feedback_incorrect: "One part, strong: SPAIN. Find it on the map."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V015
type: word_bank_gap                      # 3 tiles
instruction_words: [choose]
stimulus: "Japan · They speak ____."
target_ids: [A1-C03-L01-V013]
options:
  - {id: A, text: Arabic}
  - {id: B, text: Spanish}
  - {id: C, text: Japanese}
correct_option_ids: [C]
distractor_rationales:
  A: "Arabic — Egypt's language; /dʒ/ sound-neighbor of Japan"
  B: "Spanish — most frequent language in the set (Mexico, Peru, Spain); frequency pull"
feedback_correct: "Japanese — in Japan, they speak Japanese."
feedback_incorrect: "Same word twice: Japan → Japanese. Look again."
prerequisite_ids: [A1-C03-L01-V030]
```

```yaml
id: A1-C03-L01-PR-V016
type: question_to_word                   # 3 options (taught chunk stem)
instruction_words: [choose]
stimulus: "Where is Leo from?"
target_ids: [A1-C03-L01-V011, A1-C03-L01-V034]
options:
  - {id: A, text: Australia}
  - {id: B, text: Canada}
  - {id: C, text: Egypt}
correct_option_ids: [A]
distractor_rationales:
  B: "Canada — Alex's country; cast cross-over"
  C: "Egypt — Maya's country; cast cross-over"
feedback_correct: "Australia! Leo is from Australia."
feedback_incorrect: "Leo speaks English only — remember who speaks two languages."
prerequisite_ids: [A1-C03-L01-V034]
```

```yaml
id: A1-C03-L01-PR-V017
type: icon_cued_sort                     # two baskets: JOBS / COUNTRIES — icon + demo, no word
instruction_words: []                    # two-basket demo animation carries the instruction
stimulus: "5 tiles: teacher · Brazil · driver · Spain · nurse → basket 1 (person-at-work
  icon) or basket 2 (map-region icon)"
target_ids: [A1-C03-L01-V018, A1-C03-L01-V023, A1-C03-L01-V020, A1-C03-L01-V012, A1-C03-L01-V015]
solution: {basket_person_work: [teacher, driver, nurse], basket_map_region: [Brazil, Spain]}
feedback_correct: "Jobs — what people do. Countries — places on the map."
feedback_incorrect: "Look at the tile: a job is work a person does; a country is a place."
prerequisite_ids: []
lexicon_note: "'sort' is NOT used as an instruction word (not in controlled lexicon); the
  two-basket demo animation carries the meaning (audit rule, stage check)."
```

```yaml
id: A1-C03-L01-PR-P001
type: stress_perception                  # 2 options
instruction_words: [listen, tap]
stimulus_audio: A1-C03-AUD013 (Brazil, model take)
target_ids: [A1-C03-L01-V012]
prompt_icon: "word shown as two dots: ○ ● vs ● ○ (tap the strong part)"
options:
  - {id: A, text: "BRA-zil (first part strong)"}
  - {id: B, text: "bra-ZIL (second part strong)"}
correct_option_ids: [B]
distractor_rationales:
  A: "first-syllable default — most set words so far start strong (COUN-try, KEN-ya)"
feedback_correct: "bra-ZIL — the last part is strong, like pe-RU."
feedback_incorrect: "Listen again — the strong part is at the end."
prerequisite_ids: []
```

**Set C blended review:** A1-C03-AUD040 — `GUIDE: Brazil · Portuguese … Japan · Japanese … Kenya · Swahili and English … Spain · Spanish … India · Hindi and English. … Ten countries, five dots on the wall — and one dot for you!`

---

# S09 — Micro-sets D + E teach: jobs (5 + 4 records — E attached)

**Screen:** nine job cards in one scroll (ILL013–021). Set D opens with the three CAST cards (teacher = Nina, nurse = Maya — then doctor, student, engineer), each cast card replaying a fresh first-person line: `NINA: I'm a teacher.` / `MAYA: I'm a nurse.` / `LEO: I'm a cook.` / `ALEX: I'm a designer.` **Set E (designer, driver, cook, office worker) is attached to D's screen** — it is below the 5-item floor as a standalone set, so it shares D's teach block; the four cards include Leo (cook) and Alex (designer) so every E word arrives with a cast voice and face.

**Frame note:** all lines use the fixed frame `I'm a/an …` (taught today as V036). The a/an CHOICE rule is not taught until G009 (L2) — the article arrives inside the frame, never as a decision.

```yaml
id: A1-C03-L01-V017
content_version: 1.0.0
headword_or_phrase: student
primary_spelling: student
accepted_variants: []
part_of_speech_or_function: noun (job word; used with a/an)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who studies; the learner's likely answer to What do you do?
learner_definition: a person who studies. You are a student!
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈstuː.dənt"
stress_pattern: "● ○  STU-dent"
audio_asset_ids: [A1-C03-AUD018]
core_collocation_or_frame: "I'm a student."
example_sentence: "GUIDE: I'm a student."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL013
semantic_cue: adult evening student with notebook and phone (community-class look, 16+ respectful)
alt_text: adult man with dark skin seated at a class table, notebook open, phone beside it
common_confusion: student vs teacher (the class pair — one studies, one teaches)
feedback_for_confusion: "You study → student. Nina teaches → teacher."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V018
content_version: 1.0.0
headword_or_phrase: teacher
primary_spelling: teacher
accepted_variants: []
part_of_speech_or_function: noun (job word)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who teaches; Nina's job (bible)
learner_definition: a person who teaches. Nina is a teacher.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈtiː.tʃɚ"
stress_pattern: "● ○  TEA-cher"
audio_asset_ids: [A1-C03-AUD019]
core_collocation_or_frame: "I'm a teacher."
example_sentence: "NINA (cast card): I'm a teacher."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL014   # Nina, bible appearance, at a blank board
semantic_cue: Nina (known face) at the front of a class
alt_text: Nina, grey-streaked hair in a low bun and teal cardigan, gesturing at a blank board
common_confusion: teacher vs student (see V017)
feedback_for_confusion: "Nina teaches — teacher. The class studies — students."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V019
content_version: 1.0.0
headword_or_phrase: doctor
primary_spelling: doctor
accepted_variants: []
part_of_speech_or_function: noun (job word)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who treats sick people
learner_definition: a person who helps sick people. A doctor works at a hospital.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈdɑːk.tɚ"
stress_pattern: "● ○  DOC-tor"
audio_asset_ids: [A1-C03-AUD020]
core_collocation_or_frame: "I'm a doctor."
example_sentence: "GUIDE: I'm a doctor."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL015
semantic_cue: doctor with stethoscope (no text on badge)
alt_text: woman doctor in a coat with a stethoscope, smiling, hospital corridor behind
common_confusion: doctor vs nurse (hospital pair — both help; the frame I'm a… works for both)
feedback_for_confusion: "Both help people. The doctor treats you; the nurse cares for you.
  Maya is a nurse!"
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V020
content_version: 1.0.0
headword_or_phrase: nurse
primary_spelling: nurse
accepted_variants: []
part_of_speech_or_function: noun (job word)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who cares for patients; Maya's job (bible)
learner_definition: a person who cares for sick people. Maya is a nurse.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "nɚs"
stress_pattern: "●  NURSE"
audio_asset_ids: [A1-C03-AUD021]
core_collocation_or_frame: "I'm a nurse."
example_sentence: "MAYA (cast card): I'm a nurse."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL016   # Maya in scrubs (bible: green scrubs / star pin)
semantic_cue: Maya in her green scrubs with the small star pin
alt_text: Maya, dark brown wavy hair tied back, green scrubs, small star pin, warm smile
common_confusion: nurse vs doctor (hospital pair); nurse /nɚs/ one strong part
feedback_for_confusion: "Maya cares for people — nurse. One strong part: NURSE."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V021
content_version: 1.0.0
headword_or_phrase: engineer
primary_spelling: engineer
accepted_variants: []
part_of_speech_or_function: noun (job word)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who designs and builds systems, machines, structures
learner_definition: a person who designs and builds things.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˌen.dʒəˈnɪr"
stress_pattern: "○ ○ ●  en-gi-NEER (strong LAST part)"
audio_asset_ids: [A1-C03-AUD022]
core_collocation_or_frame: "I'm an engineer."   # an — fixed frame sound, rule in L2
example_sentence: "GUIDE: I'm an engineer."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL017
semantic_cue: engineer with hard hat and tablet at a building site
alt_text: man with glasses and a hard hat holding a tablet, scaffolding softly behind
common_confusion: engineer stress (en-gi-NEER — the set's one strong-last word; also /dʒ/ like Japan/Egypt)
feedback_for_confusion: "en-gi-NEER — the last part is strong."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V022
content_version: 1.0.0
headword_or_phrase: designer
primary_spelling: designer
accepted_variants: []
part_of_speech_or_function: noun (job word)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who designs (graphics, products); Alex's job (bible)
learner_definition: a person who makes designs — pictures and plans for things. Alex is a designer.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "dɪˈzaɪ.nɚ"
stress_pattern: "○ ● ○  de-SIG-ner"
audio_asset_ids: [A1-C03-AUD023]
core_collocation_or_frame: "I'm a designer."
example_sentence: "ALEX (cast card): I'm a designer."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL018   # Alex, bible appearance, at their daytime café table
semantic_cue: Alex (known face) with sketchbook at the café table
alt_text: Alex, short black hair, round glasses, mustard sweater, drawing in a sketchbook at a café table
common_confusion: designer vs engineer (both "make things" — designer draws/plans the look; engineer builds the system)
feedback_for_confusion: "Alex draws designs — de-SIG-ner. The engineer builds."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V023
content_version: 1.0.0
headword_or_phrase: driver
primary_spelling: driver
accepted_variants: []
part_of_speech_or_function: noun (job word)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who drives (bus, taxi, delivery)
learner_definition: a person who drives — a bus, a taxi, a truck.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈdraɪ.vɚ"
stress_pattern: "● ○  DRI-ver"
audio_asset_ids: [A1-C03-AUD024]
core_collocation_or_frame: "I'm a driver."
example_sentence: "GUIDE: I'm a driver."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL019
semantic_cue: woman bus driver at the wheel (no route text anywhere)
alt_text: woman bus driver with braids at the wheel of a small city bus, morning light
common_confusion: driver /ˈdraɪ.vɚ/ vs drive-frame (untaught verb — no conflict in A1 core)
feedback_for_confusion: "DRI-ver — person word. The strong part is first."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V024
content_version: 1.0.0
headword_or_phrase: cook
primary_spelling: cook
accepted_variants: []
part_of_speech_or_function: noun (job word — the person; the verb is not in A1 core)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who cooks; Leo's job (bible)
learner_definition: a person who makes food. Leo is a cook.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "kʊk"
stress_pattern: "●  COOK"
audio_asset_ids: [A1-C03-AUD025]
core_collocation_or_frame: "I'm a cook."
example_sentence: "LEO (cast card): I'm a cook."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL020   # Leo, bible appearance, café kitchen
semantic_cue: Leo in his blue apron at the café kitchen pass
alt_text: Leo, tall with curly auburn hair and beard, blue apron over striped shirt, at a café kitchen counter
common_confusion: cook /kʊk/ vs city /ˈsɪt.i/? — no; real trap: cook vs cook-FOOD? For A1:
  cook (person) vs the action — resolve with the frame "Leo is a cook."
feedback_for_confusion: "A cook makes food — like Leo at the café."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V025
content_version: 1.0.0
headword_or_phrase: office worker
primary_spelling: office worker
accepted_variants: []
part_of_speech_or_function: noun (two-word job phrase)
cefr_level_hypothesis: A1
sense_definition_for_creators: person who works in an office
learner_definition: a person who works at an office — with a computer and papers.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈɔː.fɪs ˈwɚ.kɚ"
stress_pattern: "● ○ ● ○  OF-fice WOR-ker (both first parts strong)"
audio_asset_ids: [A1-C03-AUD026]
core_collocation_or_frame: "I'm an office worker."   # an — fixed frame, rule in L2
example_sentence: "GUIDE: I'm an office worker."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL021
semantic_cue: person at a desk with laptop and lanyard (lanyard blank — no text)
alt_text: man with light olive skin at a tidy desk, laptop open, blank lanyard around his neck
common_confusion: office worker = TWO words (drop one and it means something else)
feedback_for_confusion: "Say both words: OF-fice WOR-ker."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S10 — Jobs practice + pronunciation 2 (10 items)

```yaml
id: A1-C03-L01-PR-V018
type: match_pairs                        # 5 pairs
instruction_words: [match]
stimulus: "left: 5 job cards (ILL013–017) · right: 5 job words"
target_ids: [A1-C03-L01-V017, A1-C03-L01-V018, A1-C03-L01-V019, A1-C03-L01-V020, A1-C03-L01-V021]
pairs: {ILL013: student, ILL014: teacher, ILL015: doctor, ILL016: nurse, ILL017: engineer}
feedback_correct: "Five jobs! And four more next."
feedback_incorrect: "Look at what the person holds and where they are — then match."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V019
type: audio_word_to_word                 # 3 options
instruction_words: [listen, choose]
stimulus_audio: A1-C03-AUD022 (engineer, model take)
target_ids: [A1-C03-L01-V021]
options:
  - {id: A, text: nurse}
  - {id: B, text: engineer}
  - {id: C, text: doctor}
correct_option_ids: [B]
distractor_rationales:
  A: "nurse — one-strong-part set-mate; length pull is short-vs-long"
  C: "doctor — the other hospital word"
feedback_correct: "en-gi-NEER — three parts, strong last."
feedback_incorrect: "Three parts, strong at the end. Listen once more."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V020
type: cast_audio_to_word                  # 3 options
instruction_words: [listen, choose]
stimulus_audio: "fresh take — MAYA: Hi! I'm Maya. I'm a nurse."
target_ids: [A1-C03-L01-V020]
options:
  - {id: A, text: teacher}
  - {id: B, text: doctor}
  - {id: C, text: nurse}
correct_option_ids: [C]
distractor_rationales:
  A: "teacher — Nina's job; cast cross-over"
  B: "doctor — the hospital pair word"
feedback_correct: "Maya is a nurse!"
feedback_incorrect: "Listen to the end: I'm a …"
prerequisite_ids: [A1-C03-L01-V036]
```

```yaml
id: A1-C03-L01-PR-V021
type: cast_audio_to_image                 # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — NINA: Good morning! I'm Nina. I'm a teacher."
target_ids: [A1-C03-L01-V018]
options:
  - {id: A, asset: "ILL014 teacher card (Nina at board)"}
  - {id: B, asset: "ILL013 student card"}
  - {id: C, asset: "ILL021 office worker card"}
correct_option_ids: [A]
distractor_rationales:
  B: "student — the class pair"
  C: "office worker — desk-work pull"
feedback_correct: "Nina is a teacher."
feedback_incorrect: "Nina teaches — find the person at the front of the class."
prerequisite_ids: [A1-C03-L01-V036]
```

```yaml
id: A1-C03-L01-PR-V022
type: best_reply                          # 3 options
instruction_words: [choose]
stimulus_audio: "fresh take — SAM: Hi! What do you do?"
target_ids: [A1-C03-L01-V035, A1-C03-L01-V036]
options:
  - {id: A, text: "I'm student."}
  - {id: B, text: "I'm a student."}
  - {id: C, text: "My name is a student."}
correct_option_ids: [B]
distractor_rationales:
  A: "missing a — the frame carries a/an before a job (rule deep-dive in L2)"
  C: "name-frame collision — My name is… answers a different question"
feedback_correct: "I'm a student. Jobs take a/an."
feedback_incorrect: "The question asks your job. Use I'm a + job."
prerequisite_ids: [A1-C01-L02-V024, A1-C03-L01-V035]
```

```yaml
id: A1-C03-L01-PR-V023
type: match_pairs                         # 4 pairs (attached set E)
instruction_words: [match]
stimulus: "left: 4 job cards (ILL018–021) · right: 4 job words"
target_ids: [A1-C03-L01-V022, A1-C03-L01-V023, A1-C03-L01-V024, A1-C03-L01-V025]
pairs: {ILL018: designer, ILL019: driver, ILL020: cook, ILL021: "office worker"}
feedback_correct: "Nine jobs — the full set!"
feedback_incorrect: "Look for the known faces: Alex designs, Leo cooks."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V024
type: cast_audio_to_word                  # 3 options
instruction_words: [listen, choose]
stimulus_audio: "fresh take — LEO: Ah! I'm Leo. I'm a cook."
target_ids: [A1-C03-L01-V024]
options:
  - {id: A, text: driver}
  - {id: B, text: designer}
  - {id: C, text: cook}
correct_option_ids: [C]
distractor_rationales:
  A: "driver — short-word /-er/ pull"
  B: "designer — Alex's job; cast cross-over"
feedback_correct: "Leo is a cook — at the café!"
feedback_incorrect: "Leo works in the café kitchen. Listen for the job word."
prerequisite_ids: [A1-C03-L01-V036]
```

```yaml
id: A1-C03-L01-PR-V025
type: cast_audio_to_image                 # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — ALEX: Okay! I'm Alex. I'm a designer."
target_ids: [A1-C03-L01-V022]
options:
  - {id: A, asset: "ILL018 designer card (Alex with sketchbook)"}
  - {id: B, asset: "ILL019 driver card"}
  - {id: C, asset: "ILL015 doctor card"}
correct_option_ids: [A]
distractor_rationales:
  B: "driver — /-er/ two-part word pull"
  C: "doctor — job-set neighbor"
feedback_correct: "Alex is a designer."
feedback_incorrect: "Alex draws and plans — look for the sketchbook."
prerequisite_ids: [A1-C03-L01-V036]
```

```yaml
id: A1-C03-L01-PR-V026
type: audio_word_to_word                  # 3 options
instruction_words: [listen, choose]
stimulus_audio: A1-C03-AUD026 (office worker, model take)
target_ids: [A1-C03-L01-V025]
options:
  - {id: A, text: teacher}
  - {id: B, text: "office worker"}
  - {id: C, text: student}
correct_option_ids: [B]
distractor_rationales:
  A: "teacher — second-word /-er/ pull (WOR-ker / TEA-cher)"
  C: "student — school-world pull"
feedback_correct: "OF-fice WOR-ker — two words, two strong firsts."
feedback_incorrect: "Two words — say them back and look again."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-V027
type: audio_word_to_image                 # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C03-AUD024 (driver, model take)
target_ids: [A1-C03-L01-V023]
options:
  - {id: A, asset: "ILL020 cook card"}
  - {id: B, asset: "ILL013 student card"}
  - {id: C, asset: "ILL019 driver card"}
correct_option_ids: [C]
distractor_rationales:
  A: "cook — short strong word neighbor"
  B: "student — the school world pull"
feedback_correct: "DRI-ver — at the wheel!"
feedback_incorrect: "Listen for the /-er/ ending and find the person at work."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-P002
type: stress_perception                   # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C03-AUD022 (engineer, model take)
target_ids: [A1-C03-L01-V021]
prompt_icon: "three dot-patterns: ● ○ ○ / ○ ● ○ / ○ ○ ●"
options:
  - {id: A, text: "EN-gi-neer (first strong)"}
  - {id: B, text: "en-GI-neer (middle strong)"}
  - {id: C, text: "en-gi-NEER (last strong)"}
correct_option_ids: [C]
distractor_rationales:
  A: "first-strong default — most set words so far (STU-dent, DOC-tor)"
  B: "middle-strong guess on a long word"
feedback_correct: "en-gi-NEER — the strong part is LAST."
feedback_incorrect: "Listen once more — the strong part is at the end."
prerequisite_ids: []
```

**Set D blended review:** A1-C03-AUD041 — `GUIDE: student · teacher · doctor · nurse · engineer … I'm a student. I'm a teacher. I'm a doctor. I'm a nurse. I'm an engineer!`

**Set E blended review:** A1-C03-AUD042 — `GUIDE: designer · driver · cook · office worker … ALEX: I'm a designer! … LEO: I'm a cook! … GUIDE: I'm a driver. I'm an office worker.`

---

# S11 — Micro-sets F + G teach: people, introducing, and the two big questions (6 + 5 records)

**Screen:** two panels. Panel F (people + introducing) centers on [ILL: A1-C03-ILL022 | alt: Maya stands beside Sam at the map wall, one hand open toward him, both smiling] with the replayed hook exchange `MAYA: Look! This is my friend Sam. / SAM: Nice to meet you! / LEO: Nice to meet you too.` Panel G (origin + job frames) is a "question machine": each card shows the frame as highlighted tiles over hook lines, with the C1 upgrade called out — *you already say "Nice to meet you" — today it grows a tail: "too."*

```yaml
id: A1-C03-L01-V026
content_version: 1.0.0
headword_or_phrase: friend
primary_spelling: friend
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a person you like and know well
learner_definition: a person you like. Maya and Sam are friends.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "frend"
stress_pattern: "●  FRIEND"
audio_asset_ids: [A1-C03-AUD027]
core_collocation_or_frame: "This is my friend Sam."
example_sentence: "This is my friend Sam."
example_known_language_check: passed   # my taught C1-G002; name chunks taught C1
illustration_asset_id: A1-C03-ILL022
semantic_cue: Maya's open hand toward Sam at the map wall
alt_text: Maya smiling, one hand open toward Sam beside the dotted map wall
common_confusion: friend vs from (/fr/ cluster pair — both new this lesson!)
feedback_for_confusion: "FRIEND is a person. FROM is your place: I'm FROM Peru."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V027
content_version: 1.0.0
headword_or_phrase: person
primary_spelling: person
accepted_variants: []
part_of_speech_or_function: noun (singular)
cefr_level_hypothesis: A1
sense_definition_for_creators: one human being
learner_definition: one human. Sam is a person. You are a person!
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈpɚ.sən"
stress_pattern: "● ○  PER-son"
audio_asset_ids: [A1-C03-AUD028]
core_collocation_or_frame: "one person"
example_sentence: "One person."
example_known_language_check: passed   # one taught C1 lexicon stage 2
illustration_asset_id: A1-C03-ILL022
semantic_cue: single figure standing by the wall
alt_text: one figure standing alone beside the map wall
common_confusion: person (one) vs people (many) — the count pair
feedback_for_confusion: "One person … many people."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V028
content_version: 1.0.0
headword_or_phrase: people
primary_spelling: people
accepted_variants: []
part_of_speech_or_function: noun (plural-only form for A1; count rule held for later levels)
cefr_level_hypothesis: A1
sense_definition_for_creators: more than one person; humans in general
learner_definition: many persons. The class has people from many countries.
prerequisite_ids: [A1-C03-L01-V027]
pronunciation_model: general_american
ipa: "ˈpiː.pəl"
stress_pattern: "● ○  PEO-ple"
audio_asset_ids: [A1-C03-AUD029]
core_collocation_or_frame: "People from many countries." / "They speak …"
example_sentence: "People from ten countries!"
example_known_language_check: passed   # ten taught C2 numbers
illustration_asset_id: A1-C03-ILL001
semantic_cue: the five cast figures together at the wall
alt_text: five figures standing together beside the dotted map wall
common_confusion: people vs person; people takes They — "they speak," never "people speaks" at A1
feedback_for_confusion: "PEO-ple = many. One person, ten people."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V029
content_version: 1.0.0
headword_or_phrase: "This is …"
primary_spelling: "This is …"
accepted_variants: []
part_of_speech_or_function: chunk (introducing frame; demonstrative analysis held for C6)
cefr_level_hypothesis: A1
sense_definition_for_creators: presents one person to others
learner_definition: say it when you show a person: This is Maya.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈðɪs ɪz"
stress_pattern: "● ●  THIS IS (linking: this-iz)"
audio_asset_ids: [A1-C03-AUD030]
core_collocation_or_frame: "This is my friend Sam. / This is Maya."
example_sentence: "This is my friend Sam."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL022
semantic_cue: Maya's open-hand gesture toward Sam
alt_text: open-hand introducing gesture between two smiling figures
common_confusion: "This is…" (presenting a person) vs "My name is…" (telling your own name)
feedback_for_confusion: "You show a FRIEND with This is… Your OWN name: I'm… / My name is…"
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V030
content_version: 1.0.0
headword_or_phrase: "They speak …"
primary_spelling: "They speak …"
accepted_variants: []
part_of_speech_or_function: chunk (language frame; they-analysis and verb system held for G007/C7)
cefr_level_hypothesis: A1
sense_definition_for_creators: states a language used in a place or by a group
learner_definition: say the language of a place: They speak Japanese in Japan. → taught as
  "Japan · They speak Japanese."
prerequisite_ids: [A1-C03-L01-V006]
pronunciation_model: general_american
ipa: "ðeɪ ˈspiːk"
stress_pattern: "○ ●  they SPEAK (speak carries the beat)"
audio_asset_ids: [A1-C03-AUD031]
core_collocation_or_frame: "They speak Swahili and English."
example_sentence: "Kenya · They speak Swahili and English."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL010   # Kenya card, the frame's home example
semantic_cue: group speech bubbles over the Kenya map card
alt_text: three small empty speech bubbles over a world-map card
common_confusion: "They speak …" (a group) vs "I speak …" (you)
feedback_for_confusion: "I speak English. THEY speak Swahili and English."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V031
content_version: 1.0.0
headword_or_phrase: "Nice to meet you too"
primary_spelling: "Nice to meet you too"
accepted_variants: []
part_of_speech_or_function: chunk (reply; C1's "Nice to meet you" + too)
cefr_level_hypothesis: A1
sense_definition_for_creators: the second speaker's return of the greeting
learner_definition: the answer to "Nice to meet you!" — the word too means "also you!"
prerequisite_ids: [A1-C01-L02-V027]
pronunciation_model: general_american
ipa: "ˌnaɪs tə ˈmiːt ju ˈtuː"
stress_pattern: "○ ○ ● ○ ●  nice to MEET you TOO"
audio_asset_ids: [A1-C03-AUD032]
core_collocation_or_frame: "SAM: Nice to meet you! … LEO: Nice to meet you too."
example_sentence: "Nice to meet you too."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL022
semantic_cue: Leo's reply bubble in the hook replay
alt_text: two figures exchanging warm greetings, speech bubbles crossing
common_confusion: too (also) vs two (the number 2) — same sound, different word
feedback_for_confusion: "TOO = also you. TWO = the number. Same sound — listen for the meaning!"
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V032
content_version: 1.0.0
headword_or_phrase: "Where are you from?"
primary_spelling: "Where are you from?"
accepted_variants: []
part_of_speech_or_function: chunk (origin question; wh-movement analysis held for G007)
cefr_level_hypothesis: A1
sense_definition_for_creators: asks a person's country
learner_definition: ask a person's country: Where are you from? — I'm from Egypt.
prerequisite_ids: [A1-C01-L02-G001]
pronunciation_model: general_american
ipa: "ˈwɛr ɚ ju ˈfrʌm"
stress_pattern: "● ○ ○ ●  WHERE are you FROM"
audio_asset_ids: [A1-C03-AUD033]
core_collocation_or_frame: "Where are you from? … I'm from Egypt."
example_sentence: "Where are you from?"
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL001
semantic_cue: Alex's hook question bubble
alt_text: figure asking a question, one hand raised, question-mark-shaped bubble (no letters)
common_confusion: "Where are you from?" (place) vs "What's your name?" (name)
feedback_for_confusion: "WHERE = place. Answer with I'm from + country."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V033
content_version: 1.0.0
headword_or_phrase: "I'm from …"
primary_spelling: "I'm from …"
accepted_variants: []
part_of_speech_or_function: chunk (origin answer; I'm known from C1)
cefr_level_hypothesis: A1
sense_definition_for_creators: states one's country
learner_definition: your country goes after from: I'm from Canada.
prerequisite_ids: [A1-C01-L02-V025, A1-C03-L01-V003]
pronunciation_model: general_american
ipa: "aɪm frʌm"
stress_pattern: "● ●  I'm FROM (from carries the beat; country word strongest)"
audio_asset_ids: [A1-C03-AUD034]
core_collocation_or_frame: "I'm from Peru."
example_sentence: "I'm from Peru."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL005
semantic_cue: Nina's dot landing on the Peru card
alt_text: orange dot landing on a world-map card, a waving figure beside it
common_confusion: dropping from ("I'm Mexico.")
feedback_for_confusion: "Keep from: I'm FROM Mexico."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V034
content_version: 1.0.0
headword_or_phrase: "Where is Alex from?"
primary_spelling: "Where is Alex from?"
accepted_variants: []
part_of_speech_or_function: chunk (3rd-person origin question — FIXED FRAME; paradigm is G007 in L2)
cefr_level_hypothesis: A1
sense_definition_for_creators: asks a third person's country; the class's asking-about-others frame
learner_definition: ask about another person: Where is Alex from? — Alex is from Canada.
prerequisite_ids: [A1-C03-L01-V032]
pronunciation_model: general_american
ipa: "ˈwɛr ɪz ˈæl.ɪks frʌm"
stress_pattern: "● ● ○ ●  WHERE is A-LEX FROM"
audio_asset_ids: [A1-C03-AUD035]
core_collocation_or_frame: "Where is Alex from? … Alex is from Canada."
example_sentence: "Where is Alex from? … Alex is from Canada."   # answer delivered as echo, chunk-level
example_known_language_check: passed   # 3rd-person is appears ONLY inside this fixed chunk pair
illustration_asset_id: A1-C03-ILL003
semantic_cue: Alex's photo card beside the Canada map card
alt_text: photo card and map card side by side, question bubble between them
common_confusion: "Where IS Alex from?" (about Alex) vs "Where ARE YOU from?" (about you)
feedback_for_confusion: "You → are. Alex → is. (More in Lesson 2!)"
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V035
content_version: 1.0.0
headword_or_phrase: "What do you do?"
primary_spelling: "What do you do?"
accepted_variants: []
part_of_speech_or_function: "chunk — [CHUNK:survival]"
cefr_level_hypothesis: A1
sense_definition_for_creators: asks a person's job; the survival job question (do-support held for C7)
learner_definition: ask a job: What do you do? — I'm a nurse.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈwʌt də ju ˈduː"
stress_pattern: "● ○ ○ ●  WHAT do you DO"
audio_asset_ids: [A1-C03-AUD036]
core_collocation_or_frame: "What do you do? … I'm a nurse."
example_sentence: "What do you do?"
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL016
semantic_cue: Maya's nurse card under the question bubble
alt_text: question bubble over a nurse card
common_confusion: "What do you do?" (job!) vs "How are you?" (feeling) — same do-you sound start
feedback_for_confusion: "This question asks WORK: answer with I'm a/an + job."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C03-L01-V036
content_version: 1.0.0
headword_or_phrase: "I'm a/an …"
primary_spelling: "I'm a/an …"
accepted_variants: []
part_of_speech_or_function: chunk (job-answer frame; the a-vs-an sound rule is G009 in L2)
cefr_level_hypothesis: A1
sense_definition_for_creators: states one's job; article arrives inside the frame
learner_definition: your job goes after I'm a or I'm an: I'm a cook. I'm an engineer.
prerequisite_ids: [A1-C01-L02-V025]
pronunciation_model: general_american
ipa: "aɪm ə / aɪm ən"
stress_pattern: "● ○  I'm a … (job word carries the beat: I'm a NURSE)"
audio_asset_ids: [A1-C03-AUD037]
core_collocation_or_frame: "I'm a student. / I'm an engineer."
example_sentence: "I'm a student."
example_known_language_check: passed
illustration_asset_id: A1-C03-ILL013
semantic_cue: student card under the frame
alt_text: frame tiles above a student card
common_confusion: dropping the little word ("I'm student") — the frame keeps a/an
feedback_for_confusion: "Keep the little word: I'm A student, I'm AN engineer."
introduction_chapter: 3
introduction_lesson: 1
later_review_chapters: [4, 7]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S12 — Chunks practice + pronunciation 3–4 + lesson close (9 items)

```yaml
id: A1-C03-L01-PR-V028
type: word_bank_gap                       # 2 tiles
instruction_words: [choose]
stimulus: "One person. … Ten ____."
target_ids: [A1-C03-L01-V027, A1-C03-L01-V028]
options:
  - {id: A, text: person}
  - {id: B, text: people}
correct_option_ids: [B]
distractor_rationales:
  A: "person = one; ten needs the many-word"
feedback_correct: "One person, ten people!"
feedback_incorrect: "Ten = many. Which word is many?"
prerequisite_ids: [A1-C02-L01-PAT003]
```

```yaml
id: A1-C03-L01-PR-V029
type: image_to_word                       # 3 options
instruction_words: [look, choose]
stimulus: "photo card of SAM (ILL022 crop) + frame: This is ____."
target_ids: [A1-C03-L01-V029]
options:
  - {id: A, text: Sam}
  - {id: B, text: Maya}
  - {id: C, text: Alex}
correct_option_ids: [A]
distractor_rationales:
  B: "Maya — the other face in ILL022 (she does the introducing)"
  C: "Alex — cast name neighbor"
feedback_correct: "This is Sam. Maya's friend!"
feedback_incorrect: "Look at WHO Maya's hand points to — the person she shows."
prerequisite_ids: [A1-C03-L01-V026]
```

```yaml
id: A1-C03-L01-PR-V030
type: put_in_order                        # 5 tiles
instruction_words: [put, in, order]       # stage-3 multiword instruction (demonstrated)
stimulus_tiles: [too, Nice, meet, you, to]
target_ids: [A1-C03-L01-V031]
solution: "Nice to meet you too."
feedback_correct: "Nice to meet you TOO — the answer with 'also you' inside!"
feedback_incorrect: "First word: Nice. Last word: too. Try again."
prerequisite_ids: [A1-C01-L02-V027]
```

```yaml
id: A1-C03-L01-PR-V031
type: best_reply                          # 3 options
instruction_words: [choose]
stimulus_audio: "fresh take — SAM: Nice to meet you!"
target_ids: [A1-C03-L01-V031]
options:
  - {id: A, text: "I'm good."}
  - {id: B, text: "Nice to meet you too."}
  - {id: C, text: "See you."}
correct_option_ids: [B]
distractor_rationales:
  A: "I'm good — the HOW-are-you answer; wrong question heard"
  C: "See you — a farewell; the exchange is a first meeting"
feedback_correct: "Nice to meet you too!"
feedback_incorrect: "This is a first meeting. Give the meeting reply back."
prerequisite_ids: [A1-C01-L02-V027, A1-C01-L02-V029]
```

```yaml
id: A1-C03-L01-PR-V032
type: word_bank_gap                        # 3 tiles
instruction_words: [choose]
stimulus: "Kenya · They speak ____ and English."
target_ids: [A1-C03-L01-V014, A1-C03-L01-V030]
options:
  - {id: A, text: English}
  - {id: B, text: Arabic}
  - {id: C, text: Swahili}
correct_option_ids: [C]
distractor_rationales:
  A: "English — already named in the sentence; cannot fill its own slot (also true of Kenya —
     designed out by the stem naming English separately)"
  B: "Arabic — Egypt's language; Africa continent pull"
feedback_correct: "Swahili and English — Kenya's two official languages."
feedback_incorrect: "One language is already in the sentence. Which is the OTHER one?"
prerequisite_ids: [A1-C03-L01-V030]
```

```yaml
id: A1-C03-L01-PR-V033
type: best_reply                           # 3 options
instruction_words: [choose]
stimulus_audio: "fresh take — NINA: Where are you from?"
target_ids: [A1-C03-L01-V033]
options:
  - {id: A, text: "I'm from Canada."}
  - {id: B, text: "I'm a Canada."}
  - {id: C, text: "My name is Canada."}
correct_option_ids: [A]
distractor_rationales:
  B: "I'm a… is the JOB frame; countries do not take it"
  C: "name-frame collision — the question asks place"
feedback_correct: "I'm from Canada. From + country!"
feedback_incorrect: "The question asks your PLACE. Use from."
prerequisite_ids: [A1-C03-L01-V032, A1-C01-L02-V024]
```

```yaml
id: A1-C03-L01-PR-V034
type: audio_detail_to_map                  # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — ALEX: Okay! I'm Alex. I'm from Canada."
target_ids: [A1-C03-L01-V007, A1-C03-L01-V034]
options:
  - {id: A, asset: "ILL006 Egypt map card"}
  - {id: B, asset: "ILL003 Canada map card"}
  - {id: C, asset: "ILL004 Mexico map card"}
correct_option_ids: [B]
distractor_rationales:
  A: "Egypt — Maya's country; cast cross-over"
  C: "Mexico — Sam's country; cast cross-over"
feedback_correct: "Alex is from Canada — English and French!"
feedback_incorrect: "Where is Alex from? Listen for the country word."
prerequisite_ids: [A1-C03-L01-V034]
```

```yaml
id: A1-C03-L01-PR-V035
type: put_in_order                         # 4 tiles
instruction_words: [put, in, order]
stimulus_tiles: [from, are, you, Where]
target_ids: [A1-C03-L01-V032]
solution: "Where are you from?"
feedback_correct: "Where are you from? — the lesson's big question!"
feedback_incorrect: "First word asks the place: Where. Try again."
prerequisite_ids: [A1-C01-L02-G003]
```

```yaml
id: A1-C03-L01-PR-V036
type: image_to_best_frame                  # 3 options
instruction_words: [look, choose]
stimulus: "ILL017 engineer card + question bubble: What do you do?"
target_ids: [A1-C03-L01-V035, A1-C03-L01-V036]
options:
  - {id: A, text: "I'm a driver."}
  - {id: B, text: "I'm an office worker."}
  - {id: C, text: "I'm an engineer."}
correct_option_ids: [C]
distractor_rationales:
  A: "driver — job-set neighbor; picture shows a hard hat and tablet, not a wheel"
  B: "office worker — desk-work pull"
feedback_correct: "I'm an engineer!"
feedback_incorrect: "Look at the hat and the building site behind — which job is that?"
prerequisite_ids: [A1-C03-L01-V021, A1-C03-L01-V035]
```

```yaml
id: A1-C03-L01-PR-P003
type: sentence_stress_perception           # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — GUIDE: I'm from CANADA. (country word stressed)"
target_ids: [A1-C03-L01-V033, A1-C03-L01-V007]
prompt_icon: "the sentence shown as three tiles: I'm · from · Canada — tap the STRONG word"
options:
  - {id: A, text: I'm}
  - {id: B, text: from}
  - {id: C, text: Canada}
correct_option_ids: [C]
distractor_rationales:
  A: "I'm — carries a small beat, not the information stress"
  B: "from — the frame word; new information (the country) is strongest"
feedback_correct: "CANADA! The country word carries the big beat — it's the new information."
feedback_incorrect: "Listen for the BIGGEST beat — the new word, the country."
prerequisite_ids: []
```

```yaml
id: A1-C03-L01-PR-P004
type: supported_recording                  # icon-cued (mic demo animation)
instruction_words: []                      # microphone icon + counting-pulse demo; word "record" is stage 4 (L2)
stimulus_audio: "A1-C03-AUD034 model, then mic icon pulses"
target_ids: [A1-C03-L01-V033]
task: "say: I'm from + any country of the ten (learner's free choice — their real origin is
  NEVER requested; any card choice is correct)"
success_condition: any complete frame attempt (self-paced; replayable; never scored)
feedback_correct: "You said it! Your dot can go on the wall in Lesson 3."
feedback_incorrect: "Listen to the model once more, then try again — slow is fine."
prerequisite_ids: []
privacy_note: >-
  The activity offers the ten taught countries only. The learner's real nationality is never
  asked, stored, or inferred; a skip button (pause icon) exits with no penalty.
```

**Set F blended review:** A1-C03-AUD043 — `GUIDE: friend · person · people … MAYA: This is my friend Sam! … SAM: Nice to meet you! … LEO: Nice to meet you too.`

**Set G blended review:** A1-C03-AUD044 — `GUIDE: Where are you from? … I'm from Peru. … Where is Alex from? … Alex is from Canada. … What do you do? … I'm a teacher! … I'm an engineer!`

**Lesson close card:** stars for the three micro-set clusters + "Next lesson: he, she, they, we — and the whole family of am/is/are." + one-tap exit.

---

# Word-model and blended-review audio index (AUD002–AUD044)

All word-model assets: GUIDE voice, `learning_slow_clear`, word-model pacing (item · 300 ms · item). Country models are **triple-takes** (ruling at top of file): country ×2 → nationality ×2 → language(s) ×2. Chunk models play the chunk ×2 with natural intonation. Planned filenames per AUDIO_STYLE_GUIDE convention.

| asset | content | asset | content |
|---|---|---|---|
| AUD002 | country | AUD024 | driver |
| AUD003 | city | AUD025 | cook |
| AUD004 | from | AUD026 | office worker |
| AUD005 | language | AUD027 | friend |
| AUD006 | English | AUD028 | person |
| AUD007 | speak | AUD029 | people |
| AUD008 | Canada · Canadian · English and French | AUD030 | This is … |
| AUD009 | Mexico · Mexican · Spanish and English | AUD031 | They speak … |
| AUD010 | Peru · Peruvian · Spanish | AUD032 | Nice to meet you too |
| AUD011 | Egypt · Egyptian · Arabic and English | AUD033 | Where are you from? |
| AUD012 | Australia · Australian · English | AUD034 | I'm from … |
| AUD013 | Brazil · Brazilian · Portuguese | AUD035 | Where is Alex from? |
| AUD014 | Japan · Japanese · Japanese | AUD036 | What do you do? |
| AUD015 | Kenya · Kenyan · Swahili and English | AUD037 | I'm a/an … |
| AUD016 | Spain · Spanish · Spanish | AUD038–044 | set blended reviews (A, B, C, D, E, F, G) |
| AUD017 | India · Indian · Hindi and English | — | full scripts inline at each set |
| AUD018–023 | student · teacher · doctor · nurse · engineer · designer | — | — |

---

# Encounter map (≥4 scheduled encounters per target — §7.4)

| set | 1 hook/replay | 2 teach card + model | 3 blended review | 4+ practice | later retrieval |
|---|---|---|---|---|---|
| A (V001–006) | hook lines | S03 + AUD002–007 | AUD038 | PR-V001–006 (+V006 cumulative) | Ch4 quiz (all), Ch4 mission |
| B (V007–011) | AUD001 ×5 | S05 + AUD008–012 | AUD039 | PR-V005/007–012/034 | Ch4 quiz, Ch4 mission |
| C (V012–016) | — (world five: teach-first) | S07 + AUD013–017 | AUD040 | PR-V013–017/032 | Ch4 quiz, Ch4 mission |
| D (V017–021) | — | S09 + AUD018–022 + cast lines | AUD041 | PR-V017/018–022/036 | Ch4, Ch7 routines |
| E (V022–025) | Leo/Alex cast cards | S09 + AUD023–026 | AUD042 | PR-V023–027 | Ch4, Ch7 routines |
| F (V026–031) | AUD001 (This is/Nice-too) | S11 + AUD027–032 | AUD043 | PR-V028–031 | Ch4 quiz |
| G (V032–036) | AUD001 | S11 + AUD033–037 | AUD044 | PR-V005/009/012/033–036 | Ch4 quiz, Ch7 (V035/036) |

Set C and the jobs sets get their first encounter in teach (not hook) — their hook-independent opening is compensated by a 5th encounter: the S12 "world tour" recap + close card naming all ten countries and nine jobs.

---

# Screen inventory and UI/UX tips (S01–S12)

| screen | content | UI/UX tips |
|---|---|---|
| A1-C03-S01 | hook: map wall, AUD001 | full-bleed art, line-highlight sync; replay always visible; captions off by default (audio-first), tap-to-reveal |
| A1-C03-S02 | warm-up WU1–3 | three-tap ribbon; one default replay per item; progress dots, not scores |
| A1-C03-S03 | Set A teach | card carousel; split art ILL002; each card ≤7 s of audio; thumb-scroll snap |
| A1-C03-S04 | Set A practice | help ladder: replay → frame highlight → hook line; feedback names the rule |
| A1-C03-S05 | Set B teach | five map cards; tap-to-flip triple (country/nationality/languages); hook-line replay per card |
| A1-C03-S06 | Set B practice + **pause** | pause card at ≈minute 9 with [continue]/[break]; break exits cleanly, resume returns to this card |
| A1-C03-S07 | Set C teach | same card grammar as S05 (consistency); "world tour" auto-sequence option |
| A1-C03-S08 | Set C practice + P001 | stress dots render large (≥44 pt targets); color + position, never color alone |
| A1-C03-S09 | jobs teach (D+E) | nine cards, cast cards first (known faces anchor); ILL013–021 |
| A1-C03-S10 | jobs practice + P002 | audio items one default replay; basket icons match S09 card art |
| A1-C03-S11 | chunks F+G teach | two panels; frame tiles highlight FROM/too in orange; C1 upgrade callout ("too" tail) |
| A1-C03-S12 | chunks practice + P003/P004 + close | mic activity icon-only with visible skip; close card previews L2; stars, not scores |

Accessibility carried on every screen: WCAG-AA on cream, ≥44 pt tap targets, no color-only meaning, alt text on every asset, reduced-motion variant for card flips and dot pulses.

---

# Lesson self-check (lens pass at authoring time)

- **Counts:** 36 vocab records · 40 bank items (PR-V001–036 + PR-P001–004) + 3 warm-up · 44 audio (AUD001–044) · 22 ILL (ILL001–022) · 12 screens — matches the closed L1 manifest in `A1_C03_MANIFEST.md`.
- **Truncation scan:** zero `…`-ended fields, zero `TBD`/`TODO`; the only ellipses are the sanctioned pause notation in audio scripts and the `…` inside chunk spellings.
- **Answer-key balance:** 27 three-option choice items → **9 A / 9 B / 9 C**; 2-option items: V001 A, V028 B, P001 B; non-positional: 5 match, 2 order, 1 icon-sort, 1 recording. Verified by position audit during authoring; re-verified by grep at handoff.
- **Red-team catches fixed in-session:** (1) PR-V014 drafted with the correct card at position A and remapped to B with clean rationales; (2) PR-V017 target list corrected (nurse = V020); (3) "in Japan" stems rewritten as "Japan · They speak …" to avoid the untaught preposition *in*; (4) all listening stems converted to first-person cast lines or taught chunks so no free 3rd-person *be* precedes G007; (5) PR-V032 stem rewritten to "They speak ____ and English" because "They speak English in Kenya" would make *English* a second correct answer.
- **Standing guardrails held:** no `Good night` anywhere · no numbers >20 · no required typing · `What do you do?` tagged survival · flags never a cue (map regions only) · origins voluntary, no status/documents language · every fictional fact (cast origins, dots wall, Maya–Sam friendship) registered in the bible BEFORE use · all audio `qa_status: script_review` · all illustrations `status: placeholder` with {STYLE}/{NEG} macros for F3.

