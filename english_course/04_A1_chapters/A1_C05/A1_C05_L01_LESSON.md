# A1 — Chapter 5 — Lesson 1 (A1-C05-L01) — Families, Friends, and Numbers 21–100

```yaml
lesson_id: A1-C05-L01
lesson_type: V                       # vocabulary lesson (chapter's full lexical load minus L2 have-chunks)
chapter: 5
title: "My Family and the People I Know — Part 1: Families, Friends, and Numbers 21–100"
estimated_minutes: 20                # pause point after Set B practices (≈ minute 9)
prerequisites:
  chapters: [1, 2, 3, 4]             # Arc 1 complete incl. Checkpoint 1; nothing conditionally scheduled
  verified_against: "LEXICAL_LEDGER.csv (89 taught rows + PAT006–008 scheduled for this lesson)
    · GRAMMAR_LEDGER.csv (G001–G009 taught; G010–G012 scheduled L2 — NOT usable this lesson)"
artifacts_manifest:
  vocabulary_records: 27             # A1-C05-L01-V001…V027, full §10.4 schema
  pattern_system_records: 3          # A1-C05-L01-PAT006…PAT008 (C2-L01 PAT format)
  practice_items: 41                 # PR-V001–027 + PR-N001–010 + PR-P001–004 (warm-up WU1–3 separate)
  audio_scripts: 37                  # A1-C05-AUD001…AUD037
  illustration_briefs: 22            # A1-C05-ILL001…ILL022 (block 22/36)
  screens: 12                        # A1-C05-S01…S12
macro_definitions_for_F3:            # expand at export time only, never inside learner content
  STYLE: >-
    Original modern editorial illustration, organic shapes, clean line work, restrained
    texture, generous negative space, cream background, warm orange and terracotta accents,
    soft brown lines, charcoal detail, one muted green and one muted blue as secondary
    support, WCAG-AA contrast, readable at small size
  NEG: >-
    photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D,
    stereotypes, distorted hands, duplicate objects
rulings_recorded_for_lens_3:
  - "Set C (partner, husband, wife, dog) is 4 records, below the 5-item micro-set floor:
    attached-set disposition (C2-B / C2-D / C3-E precedent), anchored by the REVIEW word
    'friend' (A1-C03-L01-V026 — no new row). Full encounter count preserved via photo cards."
  - "'dog' is added as ONE record (V018): §9.5's own guided-writing example ('She has a
    dog.') requires it productively at L3, and Pepper's photos need the word. The word is
    the target — never a breed; Pepper's look is bible-fixed."
  - "'This is my …' = recombination of A1-C03-L01-V029 + taught possessive adjectives
    (G002/G008): NO new ledger row (C4 ruling-1 precedent). Practiced as a frame extension
    (PR-V008, PR-V014, PR-V025)."
  - "Have-chunks are L2 records (with G011). No have/has appears anywhere in L1 — hook,
    stems, options, and feedback included. Ownership is expressed only with possessive
    adjectives this lesson."
  - "Grammar guardrail: NO possessive 's in L1 (G010 is L2). Relationship stems use
    possessive adjectives only: 'This is MY grandmother', 'HER name is Noor', first-person
    cast lines. The §9.5 sample 'Leo's sister' waits for L2."
  - "Plurals stay lexical in L1: 'children' enters as a word of Set B; the -s/-es rule is
    G012 in L2. 'parents' as a plural form is NOT used; stems say 'my mother and my father'."
  - "Age requires numbers, so Set E (How old is …? / … years old) is taught AFTER the
    pattern systems. Age statements use be: 'Sami is twenty-three years old.' — never
    'has 23 years'."
  - "Number art shows grouped quantities only — never numerals (no_text_in_image): tens =
    bundled groups of ten, 21–29 = full bundles + loose units, 100 = a 10×10 dot field.
    Grouping, not colour, carries the -ty meaning; digits are app-layer typography."
instruction_lexicon_note: >-
  No new instruction words this lesson. Stages 1–4 are all available (read, answer, record,
  play, check active since C3-L2), but L1 needs none beyond stages 1–3 plus the C3-era
  forms; the supported recording (PR-P004) is icon-cued anyway for consistency. "sort" is
  not in the controlled lexicon and is never used as a word.
scene_glue_note: >-
  Photo-afternoon glue words (photo, album, "photo afternoon" as the event name) are
  receptive, illustrated in ILL001, never tested, never practice targets — same register
  as C4's welcome-morning glue. All Ch5 figure facts (Noor 68, Sami 23 student, Eva 24
  tall, Pepper, Jordan mentioned-only) were registered in CHARACTER_AND_VISUAL_BIBLE.md
  BEFORE this lesson was authored. The learner's real family is never requested.
```

---

## Chapter can-do promise (restated at chapter start, screen S00-lead)

This chapter: **say who is in a photo — family, partner, friends — give ages, and describe people.** Today: the people words and the numbers 21 to 100.

---

# S01 — Story hook: the photo afternoon

**Screen:** full-bleed [ILL: A1-C05-ILL001 | alt: Nina, Alex, Maya and Leo sit around a Community House table with an open photo album, loose photos and a phone; Maya points at an album page]. Auto-plays A1-C05-AUD001 (learning take) with line-by-line highlight. Replay always available.

**Continuity (bible-fixed):** after the welcome morning (C4-L3, ILL016 finale), Nina invites her friends to a photo afternoon at the Community House — her registered preview line. Maya's family album carries her grandmother Noor (68) and brother Sami (23, student). Leo's photos carry his sister Eva (24, tall) and his dog Pepper (small, scruffy, brown, red collar). Nina mentions her partner Jordan (engineer) by name only — no photo.

### A1-C05-AUD001 — Hook dialogue (learning take)

```yaml
id: A1-C05-AUD001
purpose: story_hook
voices: [NINA, MAYA, LEO, ALEX]
delivery_style: learning_slow_clear
pacing: ≈100–110 wpm; … pauses 400–600 ms; family words and number words slightly emphasized
script: |
  NINA: Good afternoon! Welcome to our photo afternoon! Photos — my family, my friends…
  MAYA: Good, good. Look! My family album. (warm) This is my grandmother. Her name is Noor.
  LEO: Ah! Nice. And this — my sister Eva. And my dog, Pepper!
  MAYA: And my brother. Sami is twenty-three.
  LEO: Eva is twenty-four. Tall and friendly!
  NINA: And my partner Jordan — an engineer. No photo… okay!
  ALEX: Okay! One album, six photos, one dog! … Now it's your turn. Who is this?
transcript_release: after_one_pass
qa_status: script_review
targets_planted: [V001 family, V003 mother/mom + V004 father/dad (album context), V009
  grandmother, V006 brother, V005 sister, V018 dog, V019–V024 descriptors (tall,
  friendly spoken), V025 "Who is this?", PAT006 twenty-three, PAT006 twenty-four,
  PAT007 sixty-eight implied by Noor's age card in S03, "This is my …" recombination]
guardrail: >-
  No have/has anywhere in the hook (G011 is L2): Leo says "my dog, Pepper" as a noun
  phrase, never "I have a dog". No possessive 's. Nina's Jordan line is a name-mention
  only — no photo exists (bible ruling), and no question ever asks the learner about
  their own family.
```

**Mission seed:** Alex's closing question — "Who is this?" — is the chapter's big question; the learner learns to answer it all lesson and uses it in the L3 photo-description task.

---

# S02 — Warm-up (retrieval only: Chapters 1–4)

Three quick taps, one per prior chapter cluster; icon-cued, no new language.

| id | retrieves | format | correct | distractor rationale |
|---|---|---|---|---|
| WU1 | A1-C01-L01-V004 `good afternoon` + A1-C01-L02-V029 `I'm good/fine/okay` | audio NINA: "Good afternoon! How are you?" → choose reply | "I'm good, thank you." | "Goodbye." / "See you." = farewells mixed into a greeting exchange |
| WU2 | A1-C02-L02-PAT004–005 numbers 11–20 | audio GUIDE: "fifteen" → digit chips | 15 | 14 (fourteen/fifteen first-sound pair), 16 (sixteen next in chain — count-on slip) |
| WU3 | A1-C03-L01-V012 Brazil + A1-C03-L01-V033 `I'm from …` | audio RAFAEL: "Hi! I'm Rafael. I'm from Brazil." → country card | Brazil map card | Egypt / Kenya = Africa pull via Rafael's C4 newcomer pairing |

WU1–WU3 are warm-up retrieval, not bank items; they carry feedback lines only ("Correct! / Try again — listen one more time."). WU2 quietly re-activates the -teen words that PAT007's contrast will lean on.

---

# S03 — Micro-set A teach: Family A (8 records)

**Screen:** card carousel over Maya's album pages. Card grammar identical to C3-S03: art → model audio → word → echo (say-icon). Split cards carry two words with a shared scene. [ILL: A1-C05-ILL002 | family group portrait] opens the set; then ILL003–007.

## Vocabulary records V001–V008

```yaml
id: A1-C05-L01-V001
content_version: 1.0.0
headword_or_phrase: family
primary_spelling: family
accepted_variants: [{spelling: families, note: plural — recognition only; plural grammar is G012 in L2}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a group of people who are connected as relatives
learner_definition: the people in your photos together: mother, father, sister, brother. One family.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈfæm.əl.i"
stress_pattern: "● ○ ○  FAM-i-ly"
audio_asset_ids: [A1-C05-AUD002]
core_collocation_or_frame: "my family" / "This is my family."
example_sentence: This is my family.
example_known_language_check: passed   # This + my taught; family is the new word
illustration_asset_id: A1-C05-ILL002
semantic_cue: group portrait — several figures of different ages standing together
alt_text: five figures of different ages standing together for a portrait, warm smiles
common_confusion: family (the group) vs one person-word (mother, sister — members of the group)
feedback_for_confusion: "Family = ALL the people together. One person is mother, sister, brother."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V002
content_version: 1.0.0
headword_or_phrase: mother / mom
primary_spelling: mother
accepted_variants: [{spelling: mom, note: the everyday word for the same person — both taught on one card; mom is informal, mother is the neutral word}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: female parent
learner_definition: your female parent. Mother — and the easy word: mom.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈmʌð.ɚ (mother) · mɑːm (mom)"
stress_pattern: "● ○  MO-ther · ●  MOM"
audio_asset_ids: [A1-C05-AUD003]      # pair-take: mother · mom · mother · mom
core_collocation_or_frame: "my mother / my mom" / "This is my mother."
example_sentence: This is my mother.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL003   # woman waving, both words on the app-layer card
semantic_cue: adult woman, arm raised in a wave, child's hand in the frame corner
alt_text: a woman waves with one hand while holding a small child's hand
common_confusion: mother vs father (the set's near pair — the art fixes it); mom spelled differently from mother
feedback_for_confusion: "Mother and mom = the same person. Mother is the neutral word; mom is the easy, everyday word."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V003
content_version: 1.0.0
headword_or_phrase: father / dad
primary_spelling: father
accepted_variants: [{spelling: dad, note: the everyday word for the same person — same disposition as mom}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: male parent
learner_definition: your male parent. Father — and the easy word: dad.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈfɑː.ðɚ (father) · dæd (dad)"
stress_pattern: "● ○  FA-ther · ●  DAD"
audio_asset_ids: [A1-C05-AUD004]      # pair-take: father · dad · father · dad
core_collocation_or_frame: "my father / my dad" / "This is my father."
example_sentence: This is my father.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL004
semantic_cue: adult man lifting a child onto his shoulders
alt_text: a smiling man lifts a small child onto his shoulders
common_confusion: father vs mother (near pair); the TH sound in mother/father — /ð/ same mouth shape
feedback_for_confusion: "Father = the man. Mother = the woman. Both start the same way — listen for m or f."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V004
content_version: 1.0.0
headword_or_phrase: sister
primary_spelling: sister
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: female sibling (same parents)
learner_definition: a girl or woman with the same mother and father as you. Eva is my sister, Leo says.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈsɪs.tɚ"
stress_pattern: "● ○  SI-ster"
audio_asset_ids: [A1-C05-AUD005]
core_collocation_or_frame: "my sister" / "This is my sister."
example_sentence: This is my sister.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL005   # left half of the sister|brother split card
semantic_cue: young woman and a young man side by side; woman ringed (app layer)
alt_text: a young woman and a young man stand side by side; she carries a bag
common_confusion: sister vs brother (the split card's pair); sister vs daughter (a daughter has parent-words around her)
feedback_for_confusion: "Sister = a woman with your mother and father. Brother = a man."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V005
content_version: 1.0.0
headword_or_phrase: brother
primary_spelling: brother
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: male sibling (same parents)
learner_definition: a boy or man with the same mother and father as you. Maya says: my brother Sami.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈbrʌð.ɚ"
stress_pattern: "● ○  BRO-ther"
audio_asset_ids: [A1-C05-AUD006]
core_collocation_or_frame: "my brother" / "This is my brother."
example_sentence: This is my brother.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL005   # right half of the sister|brother split card
semantic_cue: the young man half of the split; man ringed (app layer)
alt_text: a young man in a denim jacket stands beside a young woman
common_confusion: brother vs father (both male — age decides); brother vs brother's ending sound vs mother/father family rhyme
feedback_for_confusion: "Brother = a MAN with your mother and father — not your father!"
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V006
content_version: 1.0.0
headword_or_phrase: son
primary_spelling: son
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: male child relative to the parent
learner_definition: a boy child. A parent says: my son.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "sʌn"
stress_pattern: "●  SON"
audio_asset_ids: [A1-C05-AUD007]
core_collocation_or_frame: "my son"
example_sentence: This is my son.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL006   # left half of the son|daughter split card
semantic_cue: a boy child held by an adult's hand, adult cropped to the arm
alt_text: a small boy holds a grown-up's hand
common_confusion: son vs sun (same sound — no sun art appears, so no trap); son vs daughter (pair)
feedback_for_confusion: "Son = a BOY child. Daughter = a girl child."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V007
content_version: 1.0.0
headword_or_phrase: daughter
primary_spelling: daughter
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: female child relative to the parent
learner_definition: a girl child. A parent says: my daughter.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈdɔː.tɚ"
stress_pattern: "● ○  DUGH-ter"
audio_asset_ids: [A1-C05-AUD008]
core_collocation_or_frame: "my daughter"
example_sentence: This is my daughter.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL006   # right half of the son|daughter split card
semantic_cue: a girl child held by an adult's hand, adult cropped to the arm
alt_text: a small girl holds a grown-up's hand
common_confusion: daughter spelling (au after d); daughter vs son (pair)
feedback_for_confusion: "Daughter = a GIRL child. D-A-U-G-H-T-E-R."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V008
content_version: 1.0.0
headword_or_phrase: parent
primary_spelling: parent
accepted_variants: [{spelling: parents, note: plural — recognition only in L1; the -s rule is G012 in L2}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a mother or father
learner_definition: one word for mother OR father: parent.
prerequisite_ids: [A1-C05-L01-V002, A1-C05-L01-V003]
pronunciation_model: general_american
ipa: "ˈper.ənt"
stress_pattern: "● ○  PA-rent"
audio_asset_ids: [A1-C05-AUD009]
core_collocation_or_frame: "my parent" / "Mother and father — two parents."
example_sentence: My parent is here.
example_known_language_check: passed   # is + here as illustrated app-layer caption context; "here" appears only inside this caption, never tested
illustration_asset_id: A1-C05-ILL007
semantic_cue: an adult figure ringed beside a small child (mother-or-father, the ring marks the parent)
alt_text: a grown-up stands beside a small child, one arm around them
common_confusion: parent (one mother-or-father) vs family (the whole group)
feedback_for_confusion: "Parent = mother or father — ONE of them. Family = everybody."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S04 — Micro-set A practice (8 items)

**Screen:** tap-first cards; help ladder = (1) replay audio, (2) highlight the frame, (3) replay the hook line. Feedback always names the rule, never "wrong". Answer positions are balanced across the lesson (see self-check).

```yaml
id: A1-C05-L01-PR-V001
type: audio_word_to_image               # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C05-AUD002 (family)
target_ids: [A1-C05-L01-V001]
options:
  - {id: A, asset: "ILL002 — the group portrait"}
  - {id: B, asset: "ILL005 left — one young woman"}
  - {id: C, asset: "ILL007 — one grown-up with a child"}
correct_option_ids: [A]
distractor_rationales:
  B: "sister — one person only; family is the whole group"
  C: "parent — one grown-up; family is everybody together"
feedback_correct: "Family — all the people together."
feedback_incorrect: "Listen again: family = the GROUP, not one person."
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V002
type: audio_word_to_image               # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C05-AUD005 (sister)
target_ids: [A1-C05-L01-V004]
options:
  - {id: A, asset: "ILL006 left — a small boy with a grown-up's hand"}
  - {id: B, asset: "ILL005 left — the young woman"}
  - {id: C, asset: "ILL004 — a man lifts a child"}
correct_option_ids: [B]
distractor_rationales:
  A: "son — a child; sister is a grown-up woman with your mother and father"
  C: "father — a parent; sister is not a parent"
feedback_correct: "Sister — the woman with your mother and father."
feedback_incorrect: "Sister is a WOMAN, not a parent and not a child. Listen once more."
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V003
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL006 left — a small boy holds a grown-up's hand"
target_ids: [A1-C05-L01-V006]
options:
  - {id: A, text: daughter}
  - {id: B, text: brother}
  - {id: C, text: son}
correct_option_ids: [C]
distractor_rationales:
  A: "daughter — the girl-child word; the picture shows a boy"
  B: "brother — also male, but the hand says this is a parent's CHILD, small, not a sibling pair"
feedback_correct: "Son — a boy child."
feedback_incorrect: "The child is a BOY and very small. A parent says: my son."
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V004
type: word_bank_gap                      # 3 tiles
instruction_words: [choose]
stimulus: "photo of Sami (ILL020-style young man card) + audio fresh take — MAYA: My ____ is Sami. Sami is twenty-three."
target_ids: [A1-C05-L01-V005]
options:
  - {id: A, text: sister}
  - {id: B, text: brother}
  - {id: C, text: parent}
correct_option_ids: [B]
distractor_rationales:
  A: "sister — the woman word; the photo and Maya's line show a man"
  C: "parent — Sami is Maya's brother, not her mother or father"
feedback_correct: "My brother is Sami — a man with your mother and father."
feedback_incorrect: "Look at the photo: a young man. Which word is a man?"
prerequisite_ids: [A1-C02-L02-PAT005]
```

```yaml
id: A1-C05-L01-PR-V005
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL003 — a woman waves, a child's hand in the frame corner; app-layer card shows both words"
target_ids: [A1-C05-L01-V002]
options:
  - {id: A, text: "mother / mom"}
  - {id: B, text: "father / dad"}
  - {id: C, text: "daughter"}
correct_option_ids: [A]
distractor_rationales:
  B: "father — the man word; the picture shows a woman"
  C: "daughter — the child; the woman is the grown-up"
feedback_correct: "Mother — and the easy word mom. Same person."
feedback_incorrect: "The grown-up in the picture is a WOMAN. Mother — mom."
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V006
type: spelling_choice                    # 3 options — CUMULATIVE (retrieves C2 spelling)
instruction_words: [look, choose]
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L01-V001 spell + A1-C02-L01-V007 How do you spell that?"
stimulus: "GUIDE: How do you spell that? … brother"
target_ids: [A1-C05-L01-V005]
options:
  - {id: A, text: brother}
  - {id: B, text: brofter}
  - {id: C, text: bruther}
correct_option_ids: [A]
distractor_rationales:
  B: "brofter — the TH written as t, a sound-written spelling"
  C: "bruther — vowel swap inside the second part"
feedback_correct: "brother. B-R-O-T-H-E-R."
feedback_incorrect: "Say it slowly: bro-ther. Look for the TH in the middle."
prerequisite_ids: [A1-C02-L01-V001, A1-C02-L01-PAT001]
```

```yaml
id: A1-C05-L01-PR-V007
type: audio_detail_to_photo              # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — MAYA: This is my grandmother. Her name is Noor."
target_ids: [A1-C05-L01-V009, A1-C03-L01-V029]
options:
  - {id: A, asset: "ILL010 left — an older man with silver hair"}
  - {id: B, asset: "ILL002 — the group portrait"}
  - {id: C, asset: "ILL008 left — an older woman with silver hair in a bun"}
correct_option_ids: [C]
distractor_rationales:
  A: "grandfather — the older-man word; Noor is a woman"
  B: "family — the group; one person is named"
feedback_correct: "Noor — Maya says: my grandmother!"
feedback_incorrect: "Noor is a WOMAN with silver hair. Which photo is that?"
prerequisite_ids: [A1-C03-L01-V029]
note: >-
  Set B words (grandmother V009) are heard here as hook-echo BEFORE their teach screen —
  the hook planted them (encounter #0 story-plant, C3 precedent). The item is answerable
  from the planted audio + photo; grandmother as a productive choice returns in S06.
```

```yaml
id: A1-C05-L01-PR-V008
type: put_in_order                       # 4 tiles
instruction_words: [put, in, order]
stimulus_tiles: [sister, my, is, This]
target_ids: [A1-C05-L01-V004, A1-C03-L01-V029]
solution: "This is my sister."
feedback_correct: "This is my sister. — the photo sentence!"
feedback_incorrect: "Start with This. End with the person word. Try again."
prerequisite_ids: [A1-C03-L01-V029, A1-C01-L02-G002]
note: "First use of the recombined frame 'This is my …' (ruling: no new ledger row — V029 + G002)."
```

**Set A blended review:** A1-C05-AUD033 — `GUIDE: family … mother · mom … father · dad … sister … brother … son … daughter … parent … MAYA: This is my family!`

---

# S05 — Micro-set B teach: Family B (6 records)

**Screen:** same card grammar over the next album pages. [ILL: A1-C05-ILL008 | grandmother and grandfather panels] · [ILL: A1-C05-ILL009 | a grandparent with family around] · [ILL: A1-C05-ILL010 | one child | three children split] · [ILL: A1-C05-ILL011 | two kids, one ringed].

## Vocabulary records V009–V014

```yaml
id: A1-C05-L01-V009
content_version: 1.0.0
headword_or_phrase: grandmother
primary_spelling: grandmother
accepted_variants: [{spelling: grandma, note: informal variant — recognition only in L1 (mom/dad got the full pair treatment; grandma/grandpa stay receptive to keep the set at 6)}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: parent of one's parent
learner_definition: the mother of your mother or your father. Maya says: my grandmother Noor.
prerequisite_ids: [A1-C05-L01-V002, A1-C05-L01-V008]
pronunciation_model: general_american
ipa: "ˈɡræn.mʌð.ɚ"
stress_pattern: "● ○ ○  GRAND-mo-ther"
audio_asset_ids: [A1-C05-AUD010]
core_collocation_or_frame: "my grandmother" / "This is my grandmother."
example_sentence: This is my grandmother.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL008   # left panel
semantic_cue: Noor-consistent older woman (silver bun, lavender cardigan) with family photos around
alt_text: an older woman with silver hair in a loose bun sits with photo pages around her
common_confusion: grandmother vs grandfather (pair); grandmother vs mother (a generation apart — the GRAND part)
feedback_for_confusion: "GRANDmother = the mother of your mother or your father. The grand part says: one more generation up."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V010
content_version: 1.0.0
headword_or_phrase: grandfather
primary_spelling: grandfather
accepted_variants: [{spelling: grandpa, note: informal variant — recognition only in L1}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: parent of one's parent (male)
learner_definition: the father of your mother or your father.
prerequisite_ids: [A1-C05-L01-V003, A1-C05-L01-V008]
pronunciation_model: general_american
ipa: "ˈɡræn.fɑː.ðɚ"
stress_pattern: "● ○ ○  GRAND-fa-ther"
audio_asset_ids: [A1-C05-AUD011]
core_collocation_or_frame: "my grandfather"
example_sentence: This is my grandfather.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL008   # right panel
semantic_cue: older man (grey beard edge, flat cap) with a small child on his knee
alt_text: an older man in a flat cap holds a small child on his knee
common_confusion: grandfather vs grandmother (pair); the middle syllable /fɑː/ vs /mʌ/
feedback_for_confusion: "GRANDfather = the MAN one generation up. Listen for f-a in the middle."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V011
content_version: 1.0.0
headword_or_phrase: grandparent
primary_spelling: grandparent
accepted_variants: [{spelling: grandparents, note: plural — recognition only in L1}]
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a grandmother or grandfather
learner_definition: one word for grandmother OR grandfather: grandparent.
prerequisite_ids: [A1-C05-L01-V009, A1-C05-L01-V010]
pronunciation_model: general_american
ipa: "ˈɡræn.per.ənt"
stress_pattern: "● ○ ○  GRAND-pa-rent"
audio_asset_ids: [A1-C05-AUD012]
core_collocation_or_frame: "my grandparent" / "Grandmother and grandfather — two grandparents."
example_sentence: My grandparent is Noor.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL009
semantic_cue: one older figure ringed in the middle of a family group (either grandparent fits the ring)
alt_text: an older figure sits ringed in the middle of a family group
common_confusion: grandparent (one) vs grandparents (two — recognition only); grandparent vs parent (the grand generation)
feedback_for_confusion: "Grandparent = grandmother OR grandfather. Parent = mother or father — one generation DOWN."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V012
content_version: 1.0.0
headword_or_phrase: child
primary_spelling: child
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a young human being
learner_definition: a young boy or girl — one child.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "tʃaɪld"
stress_pattern: "●  CHILD"
audio_asset_ids: [A1-C05-AUD013]
core_collocation_or_frame: "one child" / "a child with a parent"
example_sentence: One child is in the photo.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL010   # left half: one child
semantic_cue: one small figure standing alone on the album page
alt_text: one small child stands alone, waving
common_confusion: child vs children (one/many — the set's built-in contrast, practised immediately); child spelling /ch/
feedback_for_confusion: "Child = ONE. Children = MANY. C-H-I-L-D."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V013
content_version: 1.0.0
headword_or_phrase: children
primary_spelling: children
accepted_variants: []
part_of_speech_or_function: noun (irregular plural of child — taught as a WORD here; the plural system is G012 in L2)
cefr_level_hypothesis: A1
sense_definition_for_creators: more than one child
learner_definition: more than one child — two, three, many: children.
prerequisite_ids: [A1-C05-L01-V012]
pronunciation_model: general_american
ipa: "ˈtʃɪl.drən"
stress_pattern: "● ○  CHIL-dren"
audio_asset_ids: [A1-C05-AUD014]
core_collocation_or_frame: "three children" / "the children are in the photo"
example_sentence: Three children are in the photo.
example_known_language_check: passed   # are appears inside this fixed two-line caption pair (be paradigm taught C3)
illustration_asset_id: A1-C05-ILL010   # right half: three children
semantic_cue: three small figures together on the album page
alt_text: three small children stand together, arms around each other
common_confusion: children vs child (many/one); children vs sons/daughters word family
feedback_for_confusion: "Children = MANY children. One child, six children — the word CHANGES, and that is fine."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V014
content_version: 1.0.0
headword_or_phrase: sibling
primary_spelling: sibling
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a brother or sister
learner_definition: one word for brother OR sister: sibling.
prerequisite_ids: [A1-C05-L01-V004, A1-C05-L01-V005]
pronunciation_model: general_american
ipa: "ˈsɪb.lɪŋ"
stress_pattern: "● ○  SIB-ling"
audio_asset_ids: [A1-C05-AUD015]
core_collocation_or_frame: "my sibling" / "one sibling, two siblings — recognition only for the plural"
example_sentence: My sibling is Sami.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL011
semantic_cue: two kids side by side, one ringed (the ringed one is "my sibling"; either a brother or a sister fits)
alt_text: two children stand side by side; one is marked with a soft ring
common_confusion: sibling (brother-or-sister) vs brother/sister (the specific word); sibling vs parent
feedback_for_confusion: "Sibling = brother OR sister — the one word for both. A parent is a generation up."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [6, 8]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S06 — Micro-set B practice + PAUSE POINT

**Screen:** practices PR-V009–014, then the pause card. **Pause card (≈ minute 9):** "Two album pages full of people! Take a break — or one more time?" [continue] [break]. Break exits cleanly; continue enters Sets C + D.

```yaml
id: A1-C05-L01-PR-V009
type: audio_word_to_image               # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C05-AUD010 (grandmother)
target_ids: [A1-C05-L01-V009]
options:
  - {id: A, asset: "ILL008 left — older woman, silver bun"}
  - {id: B, asset: "ILL008 right — older man, flat cap"}
  - {id: C, asset: "ILL004 — man lifting a child"}
correct_option_ids: [A]
distractor_rationales:
  B: "grandfather — the pair word; the audio has the m-other middle"
  C: "father — a parent, not a grand parent"
feedback_correct: "Grandmother — the woman one generation up."
feedback_incorrect: "Listen for the middle of the word: GRAND-mother. The woman."
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V010
type: one_or_many_to_word                # 3 options
instruction_words: [look, choose]
stimulus: "ILL010 right — three children together"
target_ids: [A1-C05-L01-V013]
options:
  - {id: A, text: child}
  - {id: B, text: children}
  - {id: C, text: grandparent}
correct_option_ids: [B]
distractor_rationales:
  A: "child = ONE; the photo shows three"
  C: "grandparent = a grown-up a generation up; these are small children"
feedback_correct: "Children — many!"
feedback_incorrect: "Count the figures: three. One child, three ____?"
prerequisite_ids: [A1-C02-L01-PAT003]
```

```yaml
id: A1-C05-L01-PR-V011
type: word_bank_gap                      # 3 tiles
instruction_words: [choose]
stimulus: "One child. … Six ____."
target_ids: [A1-C05-L01-V012, A1-C05-L01-V013]
options:
  - {id: A, text: childs}
  - {id: B, text: child}
  - {id: C, text: children}
correct_option_ids: [C]
distractor_rationales:
  A: "childs — the word does NOT work this way; child changes to children (the L2 rule comes later — today: the word changes)"
  B: "child = one; six needs the many-word"
feedback_correct: "One child, six children. The word changes!"
feedback_incorrect: "Six = many. child is one — which word is many?"
prerequisite_ids: [A1-C02-L01-PAT004]
```

```yaml
id: A1-C05-L01-PR-V012
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL011 — two kids side by side, one ringed, under the app-layer frame 'my ____'"
target_ids: [A1-C05-L01-V014]
options:
  - {id: A, text: sibling}
  - {id: B, text: friend}
  - {id: C, text: parent}
correct_option_ids: [A]
distractor_rationales:
  B: "friend — a C3 word; friends are chosen, siblings share a mother and father (the two kids are family art, same household cues)"
  C: "parent — a grown-up; the ringed figure is a child"
feedback_correct: "Sibling — my brother or my sister, one word."
feedback_incorrect: "The ringed figure is a CHILD like the other one — brother or sister. One word for both?"
prerequisite_ids: [A1-C03-L01-V026]
```

```yaml
id: A1-C05-L01-PR-V013
type: audio_detail_to_photo              # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — LEO: This is my sister. Her name is Eva."
target_ids: [A1-C05-L01-V004, A1-C03-L01-V029]
options:
  - {id: A, asset: "ILL010 right — three children"}
  - {id: B, asset: "ILL002 — the group portrait"}
  - {id: C, asset: "ILL005 left — a tall young woman with a bag"}
correct_option_ids: [C]
distractor_rationales:
  A: "children — several small kids; Eva is one grown woman"
  B: "family — the whole group; Leo names ONE person"
feedback_correct: "Eva — Leo says: my sister!"
feedback_incorrect: "Leo says ONE person: my sister. Which photo is one young woman?"
prerequisite_ids: [A1-C03-L01-V029]
```

```yaml
id: A1-C05-L01-PR-V014
type: word_bank_gap                      # 3 tiles
instruction_words: [choose]
stimulus: "photo of Sami (young man card) + app-layer frame: My ____ is Sami. Sami is twenty-three."
target_ids: [A1-C05-L01-V005]
options:
  - {id: A, text: mother}
  - {id: B, text: daughter}
  - {id: C, text: brother}
correct_option_ids: [C]
distractor_rationales:
  A: "mother — a parent; Sami is Maya's brother (same mother and father, one generation)"
  B: "daughter — a girl child; Sami is a young man"
feedback_correct: "My brother is Sami."
feedback_incorrect: "Sami is a young MAN. Maya says: my brother. The word?"
prerequisite_ids: []
```

**Set B blended review:** A1-C05-AUD034 — `GUIDE: grandmother · grandfather · grandparent … child · one child … children · many children … sibling … MAYA: My grandmother is Noor! … One child, six children!`

---

# S07 — Micro-sets C + D teach: people, friends — and describing people (4 + 6 records; C attached)

**Screen:** Leo's photos first (Set C): [ILL: A1-C05-ILL012 | a couple, one figure ringed] · [ILL: A1-C05-ILL013 | husband | wife couple split] · [ILL: A1-C05-ILL014 | a small scruffy brown dog with a red collar, tongue out]. The set opens on the REVIEW anchor: Maya's photo of Sam — "This is my friend Sam." (A1-C03-L01-V026; no new row). Nina's mention line plays under ILL012: "And my partner Jordan — an engineer. No photo… okay!" (bible: Jordan has no art). Then the descriptor wall (Set D): [ILL: A1-C05-ILL015 | young | old split] · [ILL: A1-C05-ILL016 | tall | short split] · [ILL: A1-C05-ILL017 | a figure waving warmly] · [ILL: A1-C05-ILL018 | a figure giving a cup to another].

**Set C is 4 records — attached-set disposition** (below the 5–8 floor; anchored by the `friend` review card; C2-B / C2-D / C3-E precedent).

## Vocabulary records V015–V024

```yaml
id: A1-C05-L01-V015
content_version: 1.0.0
headword_or_phrase: partner
primary_spelling: partner
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a person's significant other, with no assumption of marriage or gender
learner_definition: a person you live your life with. Nina says: my partner Jordan.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "ˈpɑːrt.nɚ"
stress_pattern: "● ○  PART-ner"
audio_asset_ids: [A1-C05-AUD016]
core_collocation_or_frame: "my partner" / "Nina's partner is Jordan. → taught wording: Nina says: my partner Jordan"
example_sentence: This is my partner.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL012
semantic_cue: two adult figures with linked hands; one ringed (the ringed one is "my partner"; gender-neutral art on purpose)
alt_text: two adults hold hands; one is marked with a soft ring
common_confusion: partner vs friend (partners share a home/life; friends are chosen company); partner vs husband/wife (husband/wife say "married" — partner does not)
feedback_for_confusion: "Partner = the person you share your life with. Husband and wife say MARRIED. Partner is the open word."
creator_note_inclusion: >-
  Bible inclusivity ruling: husband, wife, and partner are taught as parallel, equally
  natural words. No family structure is presented as the normal one; art never signals
  which is "usual".
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V016
content_version: 1.0.0
headword_or_phrase: husband
primary_spelling: husband
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a married man, relative to his spouse
learner_definition: a married man. The woman he is married to says: my husband.
prerequisite_ids: [A1-C05-L01-V015]
pronunciation_model: general_american
ipa: "ˈhʌz.bənd"
stress_pattern: "● ○  HUS-band"
audio_asset_ids: [A1-C05-AUD017]
core_collocation_or_frame: "my husband" / "her husband"
example_sentence: This is my husband.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL013   # left panel: couple, the man ringed
semantic_cue: a wedding-adjacent couple scene (flowers, linked hands); the MAN ringed
alt_text: a smiling couple with flowers; the man is marked with a soft ring
common_confusion: husband (the man) vs wife (the woman) — the pair is one card; the S sound /z/ in the middle
feedback_for_confusion: "Husband = the MAN in a married pair. H-U-S-band — the s sounds like z."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V017
content_version: 1.0.0
headword_or_phrase: wife
primary_spelling: wife
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: a married woman, relative to her spouse
learner_definition: a married woman. The man she is married to says: my wife.
prerequisite_ids: [A1-C05-L01-V015]
pronunciation_model: general_american
ipa: "waɪf"
stress_pattern: "●  WIFE"
audio_asset_ids: [A1-C05-AUD018]
core_collocation_or_frame: "my wife" / "his wife"
example_sentence: This is my wife.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL013   # right panel: the same couple art, the WOMAN ringed
semantic_cue: the couple scene with the WOMAN ringed — the split card's built-in contrast
alt_text: a smiling couple with flowers; the woman is marked with a soft ring
common_confusion: wife vs life (rhyme); wife vs woman (a wife is married — the couple art carries it)
feedback_for_confusion: "Wife = the WOMAN in a married pair. It rhymes with life."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V018
content_version: 1.0.0
headword_or_phrase: dog
primary_spelling: dog
accepted_variants: []
part_of_speech_or_function: noun
cefr_level_hypothesis: A1
sense_definition_for_creators: the common pet animal (Canis familiaris)
learner_definition: an animal — a dog! Pepper is a dog.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "dɔːɡ"
stress_pattern: "●  DOG"
audio_asset_ids: [A1-C05-AUD019]
core_collocation_or_frame: "my dog" / "Leo says: my dog, Pepper"
example_sentence: This is my dog.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL014   # Pepper-consistent (bible): small scruffy brown dog, red collar
semantic_cue: Pepper — small, scruffy, brown, red collar, tongue out
alt_text: a small scruffy brown dog with a red collar, tongue out, sitting
common_confusion: dog vs dad (start sound /d/ — both short words); the word is the target, never a breed
feedback_for_confusion: "Dog — the animal! Leo says: my dog, Pepper."
creator_note_inclusion: >-
  Ruling: 'dog' is added as one record because §9.5's L3 tile example ("She has a dog.")
  needs it productively; Pepper's look is bible-fixed and identical in every photo.
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V019
content_version: 1.0.0
headword_or_phrase: young
primary_spelling: young
accepted_variants: []
part_of_speech_or_function: adjective (people only in this course)
cefr_level_hypothesis: A1
sense_definition_for_creators: early in life; not old (of people; respectful register only)
learner_definition: a young person is early in life — a child, a baby. The opposite word: old.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "jʌŋ"
stress_pattern: "●  YOUNG"
audio_asset_ids: [A1-C05-AUD020]
core_collocation_or_frame: "a young child" / "Sami is young."
example_sentence: The child is young.
example_known_language_check: passed   # the fixed be-caption pair (be taught C3)
illustration_asset_id: A1-C05-ILL015   # left panel: a small child jumping
semantic_cue: a small child mid-jump, arms up
alt_text: a small child jumps with arms raised
common_confusion: young vs old (the split card's pair — one word, two directions); young vs "new" sense (not taught)
feedback_for_confusion: "Young = early in life — like the jumping child. Old is the other way."
respect_guard: "young/old describe a life stage, respectfully — never as a judgment of a person's worth."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V020
content_version: 1.0.0
headword_or_phrase: old
primary_spelling: old
accepted_variants: []
part_of_speech_or_function: adjective (people only in this course; the "used thing" sense waits)
cefr_level_hypothesis: A1
sense_definition_for_creators: far along in life; not young (of people; respectful register only)
learner_definition: an old person is far along in life — a grandmother, a grandfather.
prerequisite_ids: [A1-C05-L01-V009]
pronunciation_model: general_american
ipa: "oʊld"
stress_pattern: "●  OLD"
audio_asset_ids: [A1-C05-AUD021]
core_collocation_or_frame: "an old friend" / "Noor is sixty-eight." → respectful age statement preferred in examples
example_sentence: My grandparent is old.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL015   # right panel: a silver-haired figure seated, smiling, surrounded by family photos
semantic_cue: a silver-haired figure with a warm smile (Noor-consistent styling, respectful art)
alt_text: a silver-haired figure sits smiling among framed photos
common_confusion: old vs young (pair); "old" as an insult sense — NEVER used that way here
feedback_for_confusion: "Old = far along in life. We say it with respect: Noor is sixty-eight."
respect_guard: "old is always respectful in this course; ages are stated with numbers, and 'old' describes a life stage."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V021
content_version: 1.0.0
headword_or_phrase: tall
primary_spelling: tall
accepted_variants: []
part_of_speech_or_function: adjective (height of people)
cefr_level_hypothesis: A1
sense_definition_for_creators: greater in height than usual
learner_definition: a tall person is high — up to the top of the door! Eva is tall.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "tɔːl"
stress_pattern: "●  TALL"
audio_asset_ids: [A1-C05-AUD022]
core_collocation_or_frame: "Eva is tall." / "a tall woman"
example_sentence: Eva is tall.
example_known_language_check: passed   # Eva = Leo's sister (bible); is from G007
illustration_asset_id: A1-C05-ILL016   # left panel: one figure reaching a high shelf
semantic_cue: a figure reaching a high shelf with ease, door frame as the height ruler
alt_text: one figure easily reaches a high shelf beside a door frame
common_confusion: tall vs short (the split card's pair); tall vs "big" (untaught — never used)
feedback_for_confusion: "Tall = HIGH, up. Eva is tall. Short is the other way."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V022
content_version: 1.0.0
headword_or_phrase: short
primary_spelling: short
accepted_variants: []
part_of_speech_or_function: adjective (height of people ONLY this chapter — never the rude sense, never "short time")
cefr_level_hypothesis: A1
sense_definition_for_creators: smaller in height than usual
learner_definition: a short person is not high — down here. The opposite of tall.
prerequisite_ids: [A1-C05-L01-V021]
pronunciation_model: general_american
ipa: "ʃɔːrt"
stress_pattern: "●  SHORT"
audio_asset_ids: [A1-C05-AUD023]
core_collocation_or_frame: "a short woman" / "Alex is not tall. Alex is… (neutral art, never a cast member is called short — see guard)"
example_sentence: The child is short.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL016   # right panel: one figure on a step stool to reach the same shelf
semantic_cue: a figure on a step stool reaching the same high shelf — the pair's shared scene
alt_text: a figure stands on a step stool to reach the same high shelf
common_confusion: short vs tall (pair); short vs "small" (untaught word)
feedback_for_confusion: "Short = not high, down here. Tall = up. Same shelf, step stool!"
respect_guard: "short describes height only, factually and kindly — never as a judgment."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V023
content_version: 1.0.0
headword_or_phrase: friendly
primary_spelling: friendly
accepted_variants: []
part_of_speech_or_function: adjective (people — and, in Leo's line, one dog)
cefr_level_hypothesis: A1
sense_definition_for_creators: warm and open to people
learner_definition: a friendly person is warm and open — hello, come, sit! Pepper is friendly too.
prerequisite_ids: [A1-C03-L01-V026]
pronunciation_model: general_american
ipa: "ˈfrend.li"
stress_pattern: "● ○  FRIEND-ly"
audio_asset_ids: [A1-C05-AUD024]
core_collocation_or_frame: "Eva is friendly." / "Pepper is friendly!"
example_sentence: Eva is tall and friendly.
example_known_language_check: passed   # Leo's hook line echo
illustration_asset_id: A1-C05-ILL017
semantic_cue: a figure mid-wave with an open posture and a rounded welcome gesture
alt_text: a figure waves with a warm open smile
common_confusion: friendly vs friend (friend = the PERSON; friendly = warm, like a friend acts)
feedback_for_confusion: "A friend is a person. Friendly is how a person ACTS — warm and open."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V024
content_version: 1.0.0
headword_or_phrase: kind
primary_spelling: kind
accepted_variants: []
part_of_speech_or_function: adjective (people)
cefr_level_hypothesis: A1
sense_definition_for_creators: caring and helpful to others
learner_definition: a kind person helps and cares. Noor is kind.
prerequisite_ids: []
pronunciation_model: general_american
ipa: "kaɪnd"
stress_pattern: "●  KIND"
audio_asset_ids: [A1-C05-AUD025]
core_collocation_or_frame: "Noor is kind." / "a kind grandmother"
example_sentence: Noor is kind.
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL018
semantic_cue: a figure giving a warm drink to another figure, both smiling
alt_text: one figure hands a warm drink to another, both smiling
common_confusion: kind vs friendly (friendly = open and warm; kind = helps and cares); kind spelling (silent d)
feedback_for_confusion: "Kind = helps and cares. Friendly = open and warm. K-I-N-D — the d is quiet."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8, 11]
source_notes: [expert_judgment]
review_status: reviewed
```

---

# S08 — Micro-sets C + D practice (10 items)

**Screen:** Leo's photos and the descriptor wall drive the items; help ladder as in S04. One cumulative item retrieves C3.

```yaml
id: A1-C05-L01-PR-V015
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL012 — two adults with linked hands, one ringed, under the app-layer frame 'my ____'"
target_ids: [A1-C05-L01-V015]
options:
  - {id: A, text: partner}
  - {id: B, text: parent}
  - {id: C, text: sibling}
correct_option_ids: [A]
distractor_rationales:
  B: "parent — mother or father; a grown-up, but the linked-hands couple art says partner"
  C: "sibling — brother or sister; the two figures are adults sharing a life, not children"
feedback_correct: "Partner — my partner and me."
feedback_incorrect: "The two adults share a life. Nina says: my partner Jordan."
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V016
type: audio_word_to_image                # 3 options
instruction_words: [listen, tap]
stimulus_audio: A1-C05-AUD018 (wife)
target_ids: [A1-C05-L01-V017]
options:
  - {id: A, asset: "ILL013 left — couple, the man ringed"}
  - {id: B, asset: "ILL013 right — couple, the woman ringed"}
  - {id: C, asset: "ILL012 — couple, linked hands, one ringed"}
correct_option_ids: [B]
distractor_rationales:
  A: "husband — the man word; wife is the woman"
  C: "partner — the open word for either person; wife says the WOMAN in a married pair"
feedback_correct: "Wife — the woman in a married pair."
feedback_incorrect: "Wife = the WOMAN. Look for the ring on the woman."
prerequisite_ids: [A1-C05-L01-V015]
```

```yaml
id: A1-C05-L01-PR-V017
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL014 — a small scruffy brown dog with a red collar"
target_ids: [A1-C05-L01-V018]
options:
  - {id: A, text: friend}
  - {id: B, text: sister}
  - {id: C, text: dog}
correct_option_ids: [C]
distractor_rationales:
  A: "friend — a person word (C3); Pepper is an animal"
  B: "sister — a person word; the photo has four legs"
feedback_correct: "Dog! Pepper is a dog."
feedback_incorrect: "Count the legs! The word for this animal is…"
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V018
type: audio_detail_to_photo               # 3 options — CUMULATIVE (retrieves C3)
instruction_words: [listen, tap]
cumulative_flag: true
prerequisites_note: "retrieves A1-C03-L01-V026 friend + the V029 chunk in its original introducing sense"
stimulus_audio: "fresh take — MAYA: This is my friend Sam."
target_ids: [A1-C03-L01-V026, A1-C03-L01-V029]
options:
  - {id: A, asset: "Sam's C2/C3 established card — green t-shirt, blank badge on red lanyard"}
  - {id: B, asset: "ILL005 left — a tall young woman (Eva)"}
  - {id: C, asset: "ILL008 left — an older woman (Noor)"}
correct_option_ids: [A]
distractor_rationales:
  B: "Eva — Leo's sister; the 'friend' word does not fit family photos"
  C: "Noor — Maya's grandmother; same family pull"
feedback_correct: "Sam — Maya says: my friend!"
feedback_incorrect: "Maya says FRIEND — not sister, not grandmother. Find Sam!"
prerequisite_ids: [A1-C03-L01-V026, A1-C03-L01-V029]
```

```yaml
id: A1-C05-L01-PR-V019
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL016 left — a figure reaching a high shelf with ease"
target_ids: [A1-C05-L01-V021]
options:
  - {id: A, text: short}
  - {id: B, text: tall}
  - {id: C, text: old}
correct_option_ids: [B]
distractor_rationales:
  A: "short — the pair word; the figure reaches HIGH with no stool"
  C: "old — a life-stage word; the picture is about height"
feedback_correct: "Tall — high, up to the top!"
feedback_incorrect: "Look at the shelf: HIGH. The height word is…"
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V020
type: image_to_word                      # 3 options
instruction_words: [look, choose]
stimulus: "ILL015 right — a silver-haired figure seated among framed photos"
target_ids: [A1-C05-L01-V020]
options:
  - {id: A, text: tall}
  - {id: B, text: young}
  - {id: C, text: old}
correct_option_ids: [C]
distractor_rationales:
  A: "tall — a height word; the picture is about a life stage"
  B: "young — the pair word; the jumping child is on the other half"
feedback_correct: "Old — far along in life, with respect."
feedback_incorrect: "The pair word of the jumping child. Which one?"
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V021
type: word_bank_gap                       # 3 tiles
instruction_words: [choose]
stimulus: "photo of Pepper jumping at Leo + frame: Pepper is ____!"
target_ids: [A1-C05-L01-V023, A1-C05-L01-V018]
options:
  - {id: A, text: friendly}
  - {id: B, text: short}
  - {id: C, text: old}
correct_option_ids: [A]
distractor_rationales:
  B: "short — a height word for people; Pepper's open-arms jump says warm, not height"
  C: "old — a life-stage word; the jumping pup is neither"
feedback_correct: "Pepper is friendly! Warm and open."
feedback_incorrect: "Pepper jumps and greets everybody. How does she ACT?"
prerequisite_ids: [A1-C03-L01-V026]
```

```yaml
id: A1-C05-L01-PR-V022
type: word_bank_gap                       # 3 tiles
instruction_words: [choose]
stimulus: "ILL018 — one figure hands a warm drink to another + frame: Noor is ____."
target_ids: [A1-C05-L01-V024]
options:
  - {id: A, text: tall}
  - {id: B, text: kind}
  - {id: C, text: young}
correct_option_ids: [B]
distractor_rationales:
  A: "tall — height; the art is about helping, not height"
  C: "young — the opposite life stage; Noor is a grandmother"
feedback_correct: "Noor is kind — she helps and cares."
feedback_incorrect: "Look at the hands: a warm drink, given. Which word is helping-and-caring?"
prerequisite_ids: [A1-C05-L01-V009]
```

```yaml
id: A1-C05-L01-PR-V023
type: best_frame_from_photo              # 3 options
instruction_words: [look, choose]
stimulus: "ILL016 split — Eva (left, reaching high) next to a shorter friend + frame: Eva is ____."
target_ids: [A1-C05-L01-V021, A1-C05-L01-V004]
options:
  - {id: A, text: short}
  - {id: B, text: old}
  - {id: C, text: tall}
correct_option_ids: [C]
distractor_rationales:
  A: "short — true of the friend, not of Eva; the question asks about Eva (the ringed figure)"
  B: "old — a life-stage word; the frame asks about height"
feedback_correct: "Eva is tall — Leo says it in the hook!"
feedback_incorrect: "The ringed figure reaches the top. Eva is…"
prerequisite_ids: []
```

```yaml
id: A1-C05-L01-PR-V024
type: match_pairs                         # 4 pairs, no positional key
instruction_words: [match]
stimulus: "left: 4 photo cards (jumping child · silver-haired figure · high-shelf reacher · step-stool reacher) · right: 4 words"
target_ids: [A1-C05-L01-V019, A1-C05-L01-V020, A1-C05-L01-V021, A1-C05-L01-V022]
pairs: {ILL015 left: young, ILL015 right: old, ILL016 left: tall, ILL016 right: short}
feedback_correct: "All four — two pairs of opposites!"
feedback_incorrect: "Listen to the word, then look: high or low? Early in life or far along?"
prerequisite_ids: []
```

**Set C blended review:** A1-C05-AUD035 — `GUIDE: partner · husband · wife · dog … NINA: My partner Jordan — an engineer! … LEO: My dog, Pepper!`

**Set D blended review:** A1-C05-AUD036 — `GUIDE: young · old … tall · short … friendly · kind … LEO: Eva is tall and friendly! … MAYA: Noor is kind.`

---

# S09 — Pattern systems teach: numbers 21–100 (3 records)

**Screen:** the album's last page is a numbers page — photos of the welcome morning counted out. Card grammar: grouped-object scene → rule line → chain audio → build demo → echo. [ILL: A1-C05-ILL019 | three neat bundles of ten cups on a tray (= thirty)] · [ILL: A1-C05-ILL020 | left: thirteen cups loose and scattered · right: thirty cups in three ten-bundles] · [ILL: A1-C05-ILL021 | a 10×10 field of orange dots (= one hundred)]. **No numerals appear in any art** — digits are app-layer typography (ruling 7).

### Pattern-system record — PAT006 (numbers 21–29; ONE ledger row)

```yaml
id: A1-C05-L01-PAT006
system_type: pattern_system
name: numbers 21–29
content_version: 1.0.0
rule_for_learner: "Say twenty, then one to nine: twenty-one, twenty-two … twenty-nine. Two words, one number."
members_and_names_GA:
  twenty-one /ˌtwen.ti ˈwʌn/ (21) · twenty-two /ˌtwen.ti ˈtuː/ (22) · twenty-three /ˌtwen.ti ˈθriː/ (23) ·
  twenty-four /ˌtwen.ti ˈfɔːr/ (24) · twenty-five /ˌtwen.ti ˈfaɪv/ (25) · twenty-six /ˌtwen.ti ˈsɪks/ (26) ·
  twenty-seven /ˌtwen.ti ˈsev.ən/ (27) · twenty-eight /ˌtwen.ti ˈeɪt/ (28) · twenty-nine /ˌtwen.ti ˈnaɪn/ (29)
stress_note: "the SECOND word is stronger: twenty-ONE, twenty-THREE — the new information carries the beat"
build_demonstration: "two full bundles of ten + 1–9 loose objects (ILL019 variants) → twenty + unit"
audio_asset_ids: [A1-C05-AUD026]
practice_ids: [A1-C05-L01-PR-N003, A1-C05-L01-PR-N004, A1-C05-L01-PR-N010, A1-C05-L01-PR-P001]
not_yet_taught: [numbers above 100, "one hundred and …" (BrE filler — not in the GA model), hyphen spelling analysis (recognition only)]
later_review_chapters: [8, 9]
prerequisite_ids: [A1-C02-L02-PAT005]   # 16–20 gives twenty and the units
encounters: "input S09 cards (rule + chain audio) → practice S10 (build, order, scene-count items) → blended review S11 + AUD037 → use: ages all lesson (cast 23–34) and the L3 profile reading"
source_notes: [expert_judgment]
review_status: reviewed
```

### Pattern-system record — PAT007 (tens 30–90 + the -teen/-ty contrast; ONE ledger row)

```yaml
id: A1-C05-L01-PAT007
system_type: pattern_system
name: tens 30–90 (with the -teen/-ty contrast)
content_version: 1.0.0
rule_for_learner: "The tens end in -ty: thirty, forty, fifty, sixty, seventy, eighty, ninety. BIG beat FIRST: THIR-ty. The -teen numbers put the big beat LAST: thir-TEEN."
members_and_names_GA:
  thirty /ˈθɚ.ti/ (30) · forty /ˈfɔːr.ti/ (40) · fifty /ˈfɪf.ti/ (50) · sixty /ˈsɪk.sti/ (60) ·
  seventy /ˈsev.ən.ti/ (70) · eighty /ˈeɪ.ti/ (80) · ninety /ˈnaɪn.ti/ (90)
teen_ty_contrast: >-
  The v2 ruling moves this contrast here from v1 Chapter 2 (impossible above a 20 ceiling):
  thirteen–thirty · fourteen–forty · fifteen–fifty · sixteen–sixty · seventeen–seventy ·
  eighteen–eighty · nineteen–ninety. The MEANING cue taught: -teen = loose and extra
  (thirteen loose cups), -ty = full bundles of ten (three bundles = thirty) — ILL020.
  The SOUND cue taught: -teen = big beat LAST (thir-TEEN); -ty = big beat FIRST (THIR-ty).
  Twelve taught (C2) and forty has NO u — spelling note only.
forty_spelling_note: "forty has no u (not fourty) — creator note; the learner sees the app-layer word card only"
audio_asset_ids: [A1-C05-AUD027, A1-C05-AUD028]
practice_ids: [A1-C05-L01-PR-N001, A1-C05-L01-PR-N002, A1-C05-L01-PR-N004, A1-C05-L01-PR-N005, A1-C05-L01-PR-N006, A1-C05-L01-PR-N008, A1-C05-L01-PR-N009, A1-C05-L01-PR-P001, A1-C05-L01-PR-P003]
not_yet_taught: [hundred+ combinations before PAT008 lands in this same screen, ordinals, prices (C9), years]
later_review_chapters: [8, 9]
prerequisite_ids: [A1-C02-L02-PAT004, A1-C02-L02-PAT005]   # the -teen words 13–19 arrive from C2
encounters: "input S09 (tens chain + pair contrast audio) → practice S10 (9 items) → blended review S11 + AUD037 → L2 -teen/-ty listening ladder → L3 ages in profiles → C8 clinic option → C9 prices"
source_notes: [expert_judgment]
review_status: reviewed
```

### Pattern-system record — PAT008 (100; ONE ledger row)

```yaml
id: A1-C05-L01-PAT008
system_type: pattern_system
name: one hundred
content_version: 1.0.0
rule_for_learner: "One hundred = ten bundles of ten. The big word: HUN-dred."
members_and_names_GA:
  one hundred /wʌn ˈhʌn.drəd/ (100)
combination_note: >-
  Tens + units build with PAT006's rule once the tens exist: thirty-two, forty-seven,
  sixty-eight (Noor!), ninety-nine. The build is practised, not enumerated — no card per
  value (§8.1 counting rule).
audio_asset_ids: [A1-C05-AUD029]
practice_ids: [A1-C05-L01-PR-N005, A1-C05-L01-PR-N006, A1-C05-L01-PR-N007, A1-C05-L01-PR-N010]
not_yet_taught: [values above 100 — the course ceiling is now 100 (ruling 8), a thousand, decimals]
later_review_chapters: [9]             # prices 1–100 build directly on this row
prerequisite_ids: [A1-C05-L01-PAT006, A1-C05-L01-PAT007]
encounters: "input S09 (10×10 dot field + audio) → practice S10 → blended review AUD037 → L3 profile ages → C9 prices 1–100"
source_notes: [expert_judgment]
review_status: reviewed
```

**UI/UX tip — S09:** The three systems share one screen with a segmented stepper (21–29 · tens · 100) so the learner feels ONE number world, not three topics. Bundles pulse in sequence with the chain audio (reduced motion: numbers of the bundle appear as dot markers). The -teen/-ty pair player shows BOTH words with the strong syllable enlarged — never colour alone (enlargement + position carry it). Every digit the learner sees is app-layer text over quantity art.

---

# S10 — Numbers practice (10 items + pronunciation 1–2)

**Screen:** digit chips are app-layer typography; quantity art stays textless. Help ladder: replay → bundle highlight → rule line.

```yaml
id: A1-C05-L01-PR-N001
type: audio_word_to_number               # 3 options (digit chips)
instruction_words: [listen, tap]
stimulus_audio: "fresh take — GUIDE: thirty … THIR-ty"
target_ids: [A1-C05-L01-PAT007]
options:
  - {id: A, text: "30"}
  - {id: B, text: "13"}
  - {id: C, text: "33"}
correct_option_ids: [A]
distractor_rationales:
  B: "13 — thirteen: same start, big beat LAST; thirty has the big beat FIRST"
  C: "33 — thirty-three: the build word; one word only was said"
feedback_correct: "Thirty — 30. Big beat FIRST: THIR-ty."
feedback_incorrect: "THIR-ty — the big beat is FIRST, so it is a ten: 30."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C05-L01-PR-N002
type: audio_word_to_number               # 3 options — CUMULATIVE (fifteen from C2)
instruction_words: [listen, tap]
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L02-PAT004 fifteen; the new fifty is its -ty twin"
stimulus_audio: "fresh take — GUIDE: fifty … FIF-ty"
target_ids: [A1-C05-L01-PAT007, A1-C02-L02-PAT004]
options:
  - {id: A, text: "15"}
  - {id: B, text: "50"}
  - {id: C, text: "5"}
correct_option_ids: [B]
distractor_rationales:
  A: "15 — fifTEEN: big beat LAST = the -teen number from Chapter 2"
  C: "5 — five: the unit underneath both"
feedback_correct: "Fifty — 50. FIF-ty, big beat first."
feedback_incorrect: "Big beat FIRST = -ty = 50. Big beat LAST = -teen = 15. Listen once more."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C05-L01-PR-N003
type: quantity_to_word                    # 3 options
instruction_words: [look, choose]
stimulus: "ILL019 variant — two full bundles of ten + one loose cup"
target_ids: [A1-C05-L01-PAT006]
options:
  - {id: A, text: twelve}
  - {id: B, text: one hundred}
  - {id: C, text: twenty-one}
correct_option_ids: [C]
distractor_rationales:
  A: "twelve — a one-word number from C2; the scene shows two bundles PLUS one"
  B: "one hundred — ten bundles; only two are here"
feedback_correct: "Twenty-one — two bundles of ten, plus one."
feedback_incorrect: "Count the bundles: two full, and one loose. Twenty-…"
prerequisite_ids: [A1-C02-L02-PAT005]
```

```yaml
id: A1-C05-L01-PR-N004
type: put_in_order                        # 3 tiles
instruction_words: [put, in, order]
stimulus_tiles: [fifty, forty, thirty]
target_ids: [A1-C05-L01-PAT007]
solution: "thirty, forty, fifty"
feedback_correct: "Thirty, forty, fifty — up the tens ladder!"
feedback_incorrect: "The tens go UP: thirty is 30, then 40, then 50. Try again."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C05-L01-PR-N005
type: audio_age_to_number                 # 3 options (digit chips)
instruction_words: [listen, tap]
stimulus_audio: "fresh take — MAYA: Noor is my grandmother. Noor is sixty-eight."
target_ids: [A1-C05-L01-PAT007, A1-C05-L01-PAT008, A1-C05-L01-V009]
options:
  - {id: A, text: "68"}
  - {id: B, text: "86"}
  - {id: C, text: "48"}
correct_option_ids: [A]
distractor_rationales:
  B: "86 — eighty-six: the two parts swapped in memory; sixty comes FIRST"
  C: "48 — forty-eight: a middle-sound slip (six-/four-)"
feedback_correct: "Sixty-eight! Noor is sixty-eight years old."
feedback_incorrect: "First part sixty (60), then eight: 68. Listen for the FIRST word."
prerequisite_ids: [A1-C05-L01-V009]
```

```yaml
id: A1-C05-L01-PR-N006
type: word_to_number                      # 3 options (digit chips)
instruction_words: [read, choose]
stimulus: "app-layer word card: seventy-two"
target_ids: [A1-C05-L01-PAT007, A1-C05-L01-PAT008]
options:
  - {id: A, text: "27"}
  - {id: B, text: "72"}
  - {id: C, text: "62"}
correct_option_ids: [B]
distractor_rationales:
  A: "27 — twenty-seven: the two parts reversed"
  C: "62 — sixty-two: first-word swap (seven-/six-)"
feedback_correct: "Seventy-two — 72. Seventy (70) first, then two."
feedback_incorrect: "Read the FIRST word: seventy = 70. Then two."
prerequisite_ids: [A1-C02-L02-PAT003]
```

```yaml
id: A1-C05-L01-PR-N007
type: audio_word_to_number                # 3 options (digit chips)
instruction_words: [listen, tap]
stimulus_audio: A1-C05-AUD029 (one hundred)
target_ids: [A1-C05-L01-PAT008]
options:
  - {id: A, text: "19"}
  - {id: B, text: "90"}
  - {id: C, text: "100"}
correct_option_ids: [C]
distractor_rationales:
  A: "19 — nineteen: the -teen neighbour; hundred has two strong parts and a -dred tail"
  B: "90 — ninety: the biggest ten; one hundred is MORE than the tens — ten bundles"
feedback_correct: "One hundred — 100. Ten bundles of ten!"
feedback_incorrect: "HUN-dred — the big number: 100."
prerequisite_ids: [A1-C05-L01-PAT007]
```

```yaml
id: A1-C05-L01-PR-N008
type: sequence_rule                       # 3 options
instruction_words: [choose]
stimulus: "app-layer chain: thirty, forty, fifty, ____"
target_ids: [A1-C05-L01-PAT007]
options:
  - {id: A, text: sixteen}
  - {id: B, text: sixty}
  - {id: C, text: six}
correct_option_ids: [B]
distractor_rationales:
  A: "sixteen — the -teen twin: six-TEEN rhythm; the chain climbs the TENS (big beat first)"
  C: "six — the unit; the chain step is a ten"
feedback_correct: "Sixty — up the tens ladder!"
feedback_incorrect: "The ladder climbs TENS: thirty, forty, fifty, …"
prerequisite_ids: [A1-C02-L02-PAT003]
```

```yaml
id: A1-C05-L01-PR-N009
type: quantity_to_word                    # 3 options
instruction_words: [look, choose]
stimulus: "ILL020 right — thirty cups in three neat ten-bundles"
target_ids: [A1-C05-L01-PAT007]
options:
  - {id: A, text: thirty}
  - {id: B, text: thirteen}
  - {id: C, text: three}
correct_option_ids: [A]
distractor_rationales:
  B: "thirteen — the loose-cups word; thirteen cups stand loose and extra (ILL020 left half)"
  C: "three — the number of BUNDLES, not of cups"
feedback_correct: "Thirty — three bundles of ten. Bundles say -ty!"
feedback_incorrect: "Count bundles: three bundles of ten cups. The bundle shape says -ty."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C05-L01-PR-N010
type: quantity_to_word                    # 3 options
instruction_words: [look, choose]
stimulus: "ILL019 variant — two full bundles of ten + three loose cups"
target_ids: [A1-C05-L01-PAT006, A1-C05-L01-PAT008]
options:
  - {id: A, text: twenty}
  - {id: B, text: thirty-two}
  - {id: C, text: twenty-three}
correct_option_ids: [C]
distractor_rationales:
  A: "twenty — the bundles only; three loose cups are extra"
  B: "thirty-two — parts reversed: two bundles = twenty, THEN three"
feedback_correct: "Twenty-three — two bundles and three."
feedback_incorrect: "Bundles first (twenty), then loose cups (three)."
prerequisite_ids: [A1-C02-L02-PAT005]
```

```yaml
id: A1-C05-L01-PR-P001
type: stress_part_perception              # 2 options — -teen/-ty
instruction_words: [listen, tap]
stimulus_audio: "fresh take — GUIDE: seventeen … sevenTEEN"
prompt_icon: "the word split into two tiles: seven | teen — tap the STRONG part"
target_ids: [A1-C05-L01-PAT007, A1-C05-L01-PAT006]
options:
  - {id: A, text: seven}
  - {id: B, text: teen}
correct_option_ids: [B]
distractor_rationales:
  A: "seven — the first part; in a -teen number the big beat lands at the END"
feedback_correct: "sevenTEEN — the end is strong in -teen numbers."
feedback_incorrect: "Listen for the BIGGEST beat — at the END: -TEEN."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C05-L01-PR-P002
type: stress_part_perception              # 2 options — family words
instruction_words: [listen, tap]
stimulus_audio: A1-C05-AUD010 (grandmother)
prompt_icon: "the word split into two tiles: grand | mother — tap the STRONG part"
target_ids: [A1-C05-L01-V009]
options:
  - {id: A, text: grand}
  - {id: B, text: mother}
correct_option_ids: [A]
distractor_rationales:
  B: "mother — the family word inside; in GRANDmother the big beat is GRAND"
feedback_correct: "GRANDmother — GRAND is strong."
feedback_incorrect: "The FIRST part is strong: GRAND-mother."
prerequisite_ids: []
```

---

# S11 — Micro-set E teach + practice: the photo questions (3 records)

**Screen:** back to the album. The three chunks are frames, not objects — one scene art ([ILL: A1-C05-ILL022 | a hand points at an album photo page; beside it, a figure counts on fingers with a question bubble]) carries all three, with app-layer frame tiles. Taught AFTER the numbers (age needs 21–100 — ruling 5).

## Vocabulary records V025–V027

```yaml
id: A1-C05-L01-V025
content_version: 1.0.0
headword_or_phrase: "Who is this?"
primary_spelling: "Who is this?"
accepted_variants: []
part_of_speech_or_function: chunk (photo question; 3rd-person is arrives inside the fixed chunk — free be-paradigm work was G007)
cefr_level_hypothesis: A1
sense_definition_for_creators: asks the identity of a person in a photo
learner_definition: point at a photo and ask: Who is this?
prerequisite_ids: [A1-C03-L01-V029]    # the answer frame "This is …"
pronunciation_model: general_american
ipa: "ˈhuː ɪz ˈðɪs"
stress_pattern: "● ● ●  WHO is THIS (this carries the pointing stress)"
audio_asset_ids: [A1-C05-AUD030]
core_collocation_or_frame: "Who is this? … This is my sister."
example_sentence: "Who is this?"
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL022
semantic_cue: a finger pointing at one photo, question bubble above
alt_text: a hand points at one photo on an album page, a question bubble above
common_confusion: "Who is this?" (identity) vs "How are you?" (feeling) — different questions entirely
feedback_for_confusion: "WHO = which person. Point and ask: Who is this?"
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V026
content_version: 1.0.0
headword_or_phrase: "How old is …?"
primary_spelling: "How old is …?"
accepted_variants: []
part_of_speech_or_function: chunk (age question; be-based — never "has … years")
cefr_level_hypothesis: A1
sense_definition_for_creators: asks a person's age
learner_definition: ask the age question: How old is Sami? — Sami is twenty-three.
prerequisite_ids: [A1-C05-L01-PAT006]
pronunciation_model: general_american
ipa: "ˈhaʊ ˈoʊld ɪz"
stress_pattern: "● ● ○  HOW OLD is (the two question words carry the beat)"
audio_asset_ids: [A1-C05-AUD031]
core_collocation_or_frame: "How old is Noor? … Noor is sixty-eight."
example_sentence: "How old is Eva?"
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL022   # the finger-counting half of the scene
semantic_cue: a figure counts on fingers (Nina's habit) beside a person, question bubble
alt_text: a figure counts on their fingers beside another figure, a question bubble above
common_confusion: "How old is …?" (AGE) vs "How are you?" (feeling) — the old inside asks years
feedback_for_confusion: "How OLD = how many years. How are you = feeling. Old = age!"
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

```yaml
id: A1-C05-L01-V027
content_version: 1.0.0
headword_or_phrase: "… is … years old"
primary_spelling: "… is … years old"
accepted_variants: []
part_of_speech_or_function: chunk (age answer frame; year appears only inside the chunk)
cefr_level_hypothesis: A1
sense_definition_for_creators: states an age with a number
learner_definition: say an age: Sami is twenty-three years old.
prerequisite_ids: [A1-C05-L01-PAT006, A1-C05-L01-V026]
pronunciation_model: general_american
ipa: "… ɪz … jɪrz ˈoʊld"
stress_pattern: "the NUMBER is strongest: Sami is TWENty-three years old"
audio_asset_ids: [A1-C05-AUD032]
core_collocation_or_frame: "Eva is twenty-four years old."
example_sentence: "Sami is twenty-three years old."
example_known_language_check: passed
illustration_asset_id: A1-C05-ILL022
semantic_cue: the answer moment: photo + number tiles (app layer) + the frame
alt_text: a photo card beside number tiles and a sentence frame
common_confusion: "is … years old" (be) — never "has … years"; dropping "years old" after the number
feedback_for_confusion: "Say the WHOLE frame: is + number + years old. Sami IS twenty-three YEARS OLD."
introduction_chapter: 5
introduction_lesson: 1
later_review_chapters: [8]
source_notes: [expert_judgment]
review_status: reviewed
```

## Set E practice (3 items + pronunciation 3)

```yaml
id: A1-C05-L01-PR-V025
type: best_reply                          # 3 options
instruction_words: [listen, choose]
stimulus_audio: "fresh take — ALEX: Who is this?"
stimulus_art: "ILL008 left — the Noor photo card"
target_ids: [A1-C05-L01-V025, A1-C05-L01-V009]
options:
  - {id: A, text: "Noor is my sister."}
  - {id: B, text: "This is my grandmother."}
  - {id: C, text: "I'm Noor."}
correct_option_ids: [B]
distractor_rationales:
  A: "sister — a woman with your mother and father; Noor's silver hair and age say grandmother"
  C: "I'm Noor — the name frame; the learner is not Noor, and the photo asks for the frame answer"
feedback_correct: "This is my grandmother. — point, name, done!"
feedback_incorrect: "Point at the photo and answer with the frame: This is my …"
prerequisite_ids: [A1-C03-L01-V029, A1-C01-L02-V025]
```

```yaml
id: A1-C05-L01-PR-V026
type: audio_age_to_number                 # 3 options (digit chips)
instruction_words: [listen, tap]
stimulus_audio: "fresh take — LEO: This is my sister. Eva is twenty-four."
target_ids: [A1-C05-L01-V026, A1-C05-L01-PAT006, A1-C05-L01-V004]
options:
  - {id: A, text: "42"}
  - {id: B, text: "24"}
  - {id: C, text: "14"}
correct_option_ids: [B]
distractor_rationales:
  A: "42 — forty-two: the parts swapped; twenty comes FIRST"
  C: "14 — fourteen: the -teen neighbour; twenty-four has the big beat on TWEN"
feedback_correct: "Twenty-four! Eva is twenty-four years old."
feedback_incorrect: "TWENty-four — twenty first: 24."
prerequisite_ids: [A1-C02-L02-PAT005]
```

```yaml
id: A1-C05-L01-PR-V027
type: put_in_order                        # 4 tiles
instruction_words: [put, in, order]
stimulus_tiles: ["Sami", "is", "23", "years old"]
target_ids: [A1-C05-L01-V027, A1-C05-L01-PAT006]
solution: "Sami is 23 years old."
feedback_correct: "Sami is 23 years old. — the age frame!"
feedback_incorrect: "Start with the name, then is, then the number, then years old."
prerequisite_ids: [A1-C03-L02-G007]
```

```yaml
id: A1-C05-L01-PR-P003
type: sentence_stress_perception          # 3 options
instruction_words: [listen, tap]
stimulus_audio: "fresh take — GUIDE: Eva is TWENty-four years old."
prompt_icon: "the sentence shown as three tiles: Eva · twenty-four · years old — tap the STRONGEST word"
target_ids: [A1-C05-L01-V027, A1-C05-L01-PAT006]
options:
  - {id: A, text: Eva}
  - {id: B, text: twenty-four}
  - {id: C, text: years old}
correct_option_ids: [B]
distractor_rationales:
  A: "Eva — the name carries a small beat; the NEW information (the age) is strongest"
  C: "years old — the frame tail; it stays light"
feedback_correct: "TWENty-four — the age is the big information!"
feedback_incorrect: "Listen for the BIGGEST beat — the number."
prerequisite_ids: []
```

**Set E blended review + lesson number chain:** A1-C05-AUD037 — `GUIDE: Who is this? … This is my grandmother. … How old is Noor? … MAYA: Noor is sixty-eight years old. … twenty-one, twenty-two, twenty-three … thirty · forty · fifty · sixty · seventy · eighty · ninety … one hundred!`

---

# S12 — Lesson close: your turn at the album (recording + recap)

**Screen:** the album lays open; the four photos from the hook wait in a row. The icon-cued recording (PR-P004) invites one frame; the close card recaps the sets and previews L2.

```yaml
id: A1-C05-L01-PR-P004
type: supported_recording                 # icon-cued (mic demo animation)
instruction_words: []                     # microphone icon + pointing-hand demo; skip always visible
stimulus_audio: "A1-C05-AUD030 model, then mic icon pulses; the four photo cards are tappable"
target_ids: [A1-C05-L01-V025, A1-C03-L01-V029]
task: >-
  Point at one photo and say the frame: "Who is this? … This is my grandmother." — or any
  of the four photos with its person-word. The learner's OWN family is never requested:
  these are the cast's fictional photos, and any one of the four is a full success.
success_condition: any complete frame attempt (self-paced; replayable; never scored)
feedback_correct: "You said it! You can open any album now."
feedback_incorrect: "Listen to the model once more, then try again — slow is fine."
prerequisite_ids: []
privacy_note: >-
  The activity offers the four fictional cast photos only. The learner's real family is
  never asked, stored, or inferred; a skip button (pause icon) exits with no penalty —
  same disposition as every recording in this course.
```

**Close card:** stars for the four clusters (family words · people words · numbers 21–100 · photo questions) + "Next lesson: Leo and his sister Eva — a new way to say WHOSE. Plus one new verb: have!" + one-tap exit. (The preview NAMES the coming frames as words — his sister uses taught possessive adjectives; the possessive-'s and have/has constructs themselves never appear. C3's close card did the same with am/is/are.)

---

# Word-model and blended-review audio index (AUD001–AUD037)

All word-model assets: GUIDE voice, `learning_slow_clear`, word-model pacing (item · 300 ms · item). Mother/mom and father/dad are **pair-takes** (both words, both rhythms). Pattern models play the rule line + the full chain slowly. Chunk models play the chunk ×2 with natural intonation. Planned filenames per AUDIO_STYLE_GUIDE convention.

| asset | content | asset | content |
|---|---|---|---|
| AUD001 | hook dialogue (4 voices, full script above) | AUD020 | young |
| AUD002 | family | AUD021 | old |
| AUD003 | mother · mom (pair-take) | AUD022 | tall |
| AUD004 | father · dad (pair-take) | AUD023 | short |
| AUD005 | sister | AUD024 | friendly |
| AUD006 | brother | AUD025 | kind |
| AUD007 | son | AUD026 | PAT006 rule + 21–29 chain |
| AUD008 | daughter | AUD027 | PAT007 tens chain 30–90 |
| AUD009 | parent | AUD028 | -teen/-ty pairs (thirteen–thirty … nineteen–ninety) |
| AUD010 | grandmother | AUD029 | PAT008 one hundred + two build demos |
| AUD011 | grandfather | AUD030 | Who is this? |
| AUD012 | grandparent | AUD031 | How old is …? |
| AUD013 | child | AUD032 | … is … years old |
| AUD014 | children | AUD033 | Set A blended review |
| AUD015 | sibling | AUD034 | Set B blended review |
| AUD016 | partner | AUD035 | Set C blended review |
| AUD017 | husband | AUD036 | Set D blended review |
| AUD018 | wife | AUD037 | Set E blended review + number chain |
| AUD019 | dog | — | — |

Fresh-take practice lines (MAYA/LEO/NINA/GUIDE cues inside items) are scripted inline in their items and enter production planning with this index, per the C3/C4 convention.

---

# Encounter map (≥4 scheduled encounters per target — §7.4)

| set | 1 hook/replay | 2 teach card + model | 3 blended review | 4+ practice | later retrieval |
|---|---|---|---|---|---|
| A (V001–008) | hook lines (album, This is my grandmother) | S03 + AUD002–009 | AUD033 | PR-V001–008 | Ch6 home, Ch8 review, L2/L3 photo work |
| B (V009–014) | hook (Noor line) | S05 + AUD010–015 | AUD034 | PR-V007 hook-echo, PR-V009–014 | Ch6, Ch8 |
| C (V015–018) | hook (Jordan mention, my dog Pepper) | S07 + AUD016–019 + friend anchor | AUD035 | PR-V015–018 | Ch8; dog → L3 tile task |
| D (V019–024) | hook (Tall and friendly!) | S07 + AUD020–025 | AUD036 | PR-V019–024 + P002 | Ch8, Ch11 (describing again) |
| E (V025–027) | hook (Alex: Who is this?) | S11 + AUD030–032 | AUD037 | PR-V025–027 + P003/P004 | Ch8, L2 conversation spine |
| PAT006 | hook ages (23, 24) | S09 + AUD026 | AUD037 chain | PR-N003/010, PR-V004/026/027 + P001/P003 | Ch8, Ch9 prices, L2/L3 |
| PAT007 | (Noor 68 implied) | S09 + AUD027/028 | AUD037 chain | PR-N001/002/004/005/006/008/009 | Ch8 clinic option, Ch9 prices |
| PAT008 | — (teach-first) | S09 + AUD029 | AUD037 chain | PR-N005/006/007/010 | Ch9 prices |

Set C's hook-independent opening is compensated by the friend anchor card (a 5th encounter with V026's review); PAT008's teach-first opening is compensated by the S10 sequence item and the AUD037 chain close.

---

# Illustration briefs — A1-C05-ILL001–022 (22 of 36; block allocation in the manifest)

All briefs obey §10.10: `no_text_in_image: true`, generation prompts composed STYLE + SUBJECT + COMPOSITION + MUST_SHOW + MUST_NOT_SHOW + ALT with the {STYLE}/{NEG} macros expanded at F3. No numerals anywhere in art — digits are app-layer typography (ruling 7).

### ILL001 — hook: the photo afternoon

```yaml
id: A1-C05-ILL001
purpose: "Story hook — Arc 2 opens over an open photo album."
scene: "The Community House common room, afternoon light: Nina, Alex, Maya and Leo around a
  low table; Maya's open album, loose photos, one phone; Maya points at a page; a small
  scruffy brown dog with a red collar sits by Leo's chair."
composition: "Wide table-eye view, album dominant in the lower third, four figures evenly
  placed around, dog bottom-right; warm window light left."
must_show: [open album, four cast figures, loose photos, Pepper with red collar]
must_not_show_extra: [text, letters, numerals, logos, Jordan (no photo of Jordan exists — bible)]
continuity: "Cast model sheets A1-CHAR-ILL001–004; Pepper bible-fixed (small scruffy brown,
  red collar); the C4-L3 finale group is the emotional predecessor — same community room."
alt_text: "Four friends around a table with an open photo album and loose photos; a small brown dog sits by one chair."
embedding_slot: "S01 hero, 3:2, full-bleed"
status: placeholder
generation_prompt: "{STYLE} — four friends around a low table in a sunlit community room,
  an open photo album and loose photos on the table, one friend pointing at a page, a small
  scruffy brown dog with a red collar beside a chair. MUST_SHOW: open album, four figures,
  loose photos, brown dog with red collar. MUST_NOT_SHOW: {NEG}. ALT: Four friends around a
  table with an open photo album; a small brown dog sits by one chair."
```

### ILL002 — family (group portrait)

```yaml
id: A1-C05-ILL002
purpose: "V001 family — the group concept."
scene: "A framed group portrait on an album page: five figures of clearly different ages
  (two grown-ups, a young woman, a young man, a small child) standing together, arms
  linked, warm smiles; mixed appearances, no two figures styled alike."
composition: "Portrait-in-page framing, figures centred, album-page corner visible bottom-left."
must_show: [five figures of different ages, linked arms or hands, album-page corner]
must_not_show_extra: [text, numerals, one-family-structure signalling beyond the group itself]
continuity: "Fictional portrait family — NOT the cast; appears only as the family concept card."
alt_text: "Five people of different ages pose together for a portrait, arms linked."
embedding_slot: "V001 card, S03 carousel head, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a family group portrait of five people of clearly different
  ages standing together with arms linked, warm smiles, framed by an album page corner.
  MUST_SHOW: five figures, linked arms, age variety. MUST_NOT_SHOW: {NEG}. ALT: Five people
  of different ages pose together, arms linked."
```

### ILL003 — mother / mom · ILL004 — father / dad

```yaml
id: A1-C05-ILL003
purpose: "V002 mother/mom — one card, both words (app layer)."
scene: "An adult woman waves with one hand while holding a small child's hand; warm doorway
  light behind her."
composition: "Medium shot, woman centred, child's hand entering from the corner."
must_show: [adult woman waving, child's hand held]
must_not_show_extra: [text, a second grown-up (father card is separate)]
continuity: "Fictional figures; consistent with the ILL002 portrait family styling."
alt_text: "A woman waves while holding a small child's hand."
embedding_slot: "V002 card, S03, 1:1"
status: placeholder
generation_prompt: "{STYLE} — an adult woman waving warmly, holding a small child's hand,
  soft doorway light behind. MUST_SHOW: woman waving, child's hand. MUST_NOT_SHOW: {NEG},
  other adults. ALT: A woman waves while holding a small child's hand."
```

```yaml
id: A1-C05-ILL004
purpose: "V003 father/dad — one card, both words (app layer)."
scene: "An adult man lifts a small child onto his shoulders; both laugh."
composition: "Medium shot, figures centred, park-style soft background."
must_show: [adult man, child on shoulders, shared laughter]
must_not_show_extra: [text, other adults]
continuity: "Same fictional portrait family as ILL002/003."
alt_text: "A smiling man lifts a small child onto his shoulders."
embedding_slot: "V003 card, S03, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a smiling man lifts a small laughing child onto his shoulders
  in a soft park setting. MUST_SHOW: man, child on shoulders, laughter. MUST_NOT_SHOW:
  {NEG}, other adults. ALT: A man lifts a laughing child onto his shoulders."
```

### ILL005 — sister | brother (split card)

```yaml
id: A1-C05-ILL005
purpose: "V004 sister / V005 brother — the pair on one split card."
scene: "A young woman and a young man stand side by side on an album page; she carries a
  bag, he wears a denim jacket; each half independently croppable (app-layer ring marks
  the target half per item)."
composition: "Vertical split, one figure per half, equal size, lighting and detail."
must_show: [young woman with bag, young man in denim jacket, equal halves]
must_not_show_extra: [text, height difference signalling (descriptors are taught later — keep heights visually equal), age ambiguity]
continuity: "The man half doubles as the SAMI photo card (bible: short dark curly hair,
  denim jacket over striped shirt) — Sami-consistent styling."
alt_text: "A young woman with a bag and a young man in a denim jacket stand side by side."
embedding_slot: "V004/V005 cards, S03 + practice crops, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — a young woman carrying a bag and a young man in a denim
  jacket over a striped shirt stand side by side, equal size, album-page framing.
  MUST_SHOW: both figures, equal visual weight. MUST_NOT_SHOW: {NEG}, height contrast.
  ALT: A young woman and a young man in a denim jacket stand side by side."
```

### ILL006 — son | daughter (split card)

```yaml
id: A1-C05-ILL006
purpose: "V006 son / V007 daughter — the pair on one split card."
scene: "Left: a small boy holds a grown-up's hand (adult cropped to the arm). Right: a
  small girl holds another grown-up's hand (same cropping)."
composition: "Vertical split, equal halves; the cropped arms say 'this is a parent's child'."
must_show: [small boy with grown-up hand, small girl with grown-up hand]
must_not_show_extra: [text, full grown-up figures]
continuity: "Fictional children; no cast faces."
alt_text: "A small boy and a small girl each hold a grown-up's hand."
embedding_slot: "V006/V007 cards, S03 + practice crops, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — a small boy holding a grown-up's cropped hand on one side,
  a small girl holding another cropped grown-up's hand on the other, equal halves.
  MUST_SHOW: both children, cropped adult arms. MUST_NOT_SHOW: {NEG}, full adults.
  ALT: A boy and a girl each hold a grown-up's hand."
```

### ILL007 — parent

```yaml
id: A1-C05-ILL007
purpose: "V008 parent — one grown-up OR the other; the ring (app layer) keeps it either."
scene: "A grown-up stands beside a small child, one arm around them; the figure is drawn
  neutrally enough that the app ring (mother-or-father) does the specifying."
composition: "Medium two-figure shot, warm domestic light."
must_show: [one grown-up, one small child, arm around child]
must_not_show_extra: [text, a second grown-up, gender-coded details]
continuity: "Fictional figures."
alt_text: "A grown-up stands with an arm around a small child."
embedding_slot: "V008 card, S03, 1:1"
status: placeholder
generation_prompt: "{STYLE} — one grown-up with an arm around a small child, warm domestic
  light, neutral styling. MUST_SHOW: grown-up, child, caring arm. MUST_NOT_SHOW: {NEG},
  second adult. ALT: A grown-up with an arm around a small child."
```

### ILL008 — grandmother | grandfather (split card)

```yaml
id: A1-C05-ILL008
purpose: "V009 grandmother / V010 grandfather — the pair on one split card."
scene: "Left: an older woman with silver hair in a loose bun, lavender-purple cardigan,
  sits among photo pages. Right: an older man in a flat cap holds a small child on his knee."
composition: "Vertical split, equal halves, equal warmth and detail."
must_show: [older woman silver bun, older man flat cap with child]
must_not_show_extra: [text, frailty clichés (both figures active and warm)]
continuity: "The woman half is NOOR-consistent (bible: silver loose bun, lavender-purple
  cardigan, warm round face) — doubles as the Noor photo card."
alt_text: "An older woman with silver hair among photos; an older man in a flat cap with a child on his knee."
embedding_slot: "V009/V010 cards, S05 + practice crops, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — an older woman with silver hair in a loose bun and a lavender
  cardigan among photo pages beside an older man in a flat cap holding a small child on
  his knee, equal halves. MUST_SHOW: both elders, warmth, photo context. MUST_NOT_SHOW:
  {NEG}, frailty clichés. ALT: An older woman among photos; an older man with a child on
  his knee."
```

### ILL009 — grandparent

```yaml
id: A1-C05-ILL009
purpose: "V011 grandparent — the either-word; ring does the specifying."
scene: "One older figure sits ringed in the middle of a family group (grown-ups and
  children around), holding a photo page."
composition: "Group shot with the elder centred and softly isolated by composition (space
  around the figure), not by colour alone."
must_show: [one centred older figure, family group around, photo page]
must_not_show_extra: [text, both elders ringed]
continuity: "Group styling consistent with ILL002 family art."
alt_text: "An older figure sits at the centre of a family group, holding a photo page."
embedding_slot: "V011 card, S05, 1:1"
status: placeholder
generation_prompt: "{STYLE} — one older figure at the centre of a family group, holding a
  photo page, space around the centred figure. MUST_SHOW: centred elder, family group,
  photo page. MUST_NOT_SHOW: {NEG}. ALT: An older figure at the centre of a family group."
```

### ILL010 — child | children (split card)

```yaml
id: A1-C05-ILL010
purpose: "V012 child / V013 children — the one/many pair, the set's built-in contrast."
scene: "Left: ONE small child stands alone on an album page, waving. Right: THREE small
  children together, arms around each other."
composition: "Vertical split; the count difference IS the semantic target — countable at
  small size, no extra children joining between the halves."
must_show: [one child waving, three children together]
must_not_show_extra: [text, numerals, ambiguous counts]
continuity: "Fictional children, varied appearances."
alt_text: "One child waves alone; three children stand together, arms linked."
embedding_slot: "V012/V013 cards, S05 + practice crops, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — one small child waving alone on one side, three small
  children with arms around each other on the other, album-page framing, counts clearly
  readable. MUST_SHOW: one child, three children. MUST_NOT_SHOW: {NEG}, extra figures.
  ALT: One child waves; three children stand together."
```

### ILL011 — sibling

```yaml
id: A1-C05-ILL011
purpose: "V014 sibling — brother-or-sister in one word."
scene: "Two school-age kids side by side at a breakfast table, one softly ringed by
  composition (foreground position); a family photo hangs behind them."
composition: "Two-figure medium shot; the family-photo prop says same-family without text."
must_show: [two kids side by side, family photo behind]
must_not_show_extra: [text, grown-ups in frame]
continuity: "Fictional kids."
alt_text: "Two children sit side by side beneath a framed family photo."
embedding_slot: "V014 card, S05, 1:1"
status: placeholder
generation_prompt: "{STYLE} — two school-age children side by side at a table, a framed
  family photo on the wall behind them. MUST_SHOW: two children, family photo behind.
  MUST_NOT_SHOW: {NEG}, adults. ALT: Two children side by side under a family photo."
```

### ILL012 — partner

```yaml
id: A1-C05-ILL012
purpose: "V015 partner — the open word; Nina's Jordan line plays under this art (no Jordan figure is drawn)."
scene: "Two adults with linked hands walk in a park; the figures are drawn gender-neutral
  (soft silhouettes of the style); one figure carries a canvas bag."
composition: "Medium walking shot, path curving behind; equal visual weight."
must_show: [two adults, linked hands, park path]
must_not_show_extra: [text, wedding imagery (that is ILL013's cue), gender-marked details]
continuity: "Fictional couple — deliberately NOT any cast pairing; Jordan is never drawn (bible)."
alt_text: "Two adults walk hand in hand along a park path."
embedding_slot: "V015 card, S07, 1:1"
status: placeholder
generation_prompt: "{STYLE} — two adults walking hand in hand along a curving park path,
  one carrying a canvas bag, soft gender-neutral styling. MUST_SHOW: two adults, linked
  hands, park path. MUST_NOT_SHOW: {NEG}, wedding imagery. ALT: Two adults walk hand in
  hand in a park."
```

### ILL013 — husband | wife (split card)

```yaml
id: A1-C05-ILL013
purpose: "V016 husband / V017 wife — the married pair; the ring marks who (app layer)."
scene: "One wedding-adjacent couple scene used twice: flowers, linked hands, festive but
  modest dress. The couple is drawn once; crops mark the man / the woman per card."
composition: "Two-figure celebration shot, both figures equal size; per-card crops centre
  one figure each with the partner's shoulder kept for context."
must_show: [couple, flowers, linked hands]
must_not_show_extra: [text, religious symbols of any kind, rings enlarged to logos]
continuity: "Fictional couple; culturally neutral celebration (flowers, not ceremony specifics)."
alt_text: "A couple stands with flowers and linked hands, celebrating."
embedding_slot: "V016/V017 cards, S07 + practice crops, 1:1 split-crop"
status: placeholder
generation_prompt: "{STYLE} — a festive couple with flowers and linked hands, modest
  celebration styling, both figures equal size. MUST_SHOW: couple, flowers, linked hands.
  MUST_NOT_SHOW: {NEG}, religious symbols. ALT: A couple with flowers, hands linked."
```

### ILL014 — dog (Pepper)

```yaml
id: A1-C05-ILL014
purpose: "V018 dog — Pepper is the model; the word (never a breed) is the target."
scene: "A small scruffy brown dog with a red collar sits with its tongue out, tail a blur
  of motion; a photo-page corner frames it."
composition: "Medium centred shot; the collar and scruff are the continuity anchors."
must_show: [small scruffy brown dog, red collar, tongue out]
must_not_show_extra: [text, breed-specific markers (no pedigree look), other animals]
continuity: "PEPPER, bible-fixed: identical in ILL001 and every later Ch5 photo."
alt_text: "A small scruffy brown dog with a red collar sits with its tongue out."
embedding_slot: "V018 card, S07 + photo tasks, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a small scruffy brown dog with a red collar sitting with
  tongue out and wagging tail, framed by a photo-page corner. MUST_SHOW: scruffy brown
  dog, red collar, tongue out. MUST_NOT_SHOW: {NEG}, breed markers. ALT: A small scruffy
  brown dog with a red collar, tongue out."
```

### ILL015 — young | old (split card)

```yaml
id: A1-C05-ILL015
purpose: "V019 young / V020 old — the life-stage pair, respectful art on both halves."
scene: "Left: a small child jumps with arms raised. Right: a silver-haired figure sits
  smiling among framed photos — active, warm, never frail."
composition: "Vertical split; energy vs. gathered warmth, equal dignity and detail."
must_show: [jumping child, smiling silver-haired figure with photos]
must_not_show_extra: [text, cane/hunched clichés, negative-age tropes]
continuity: "The elder half is Noor-consistent styling (silver bun, warm round face)."
alt_text: "A child jumps with arms raised; a silver-haired figure smiles among photos."
embedding_slot: "V019/V020 cards, S07 + practice crops, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — a small child jumping with arms raised on one side, a
  silver-haired figure with a warm smile seated among framed photos on the other, equal
  dignity. MUST_SHOW: jumping child, smiling elder, photos. MUST_NOT_SHOW: {NEG}, frailty
  clichés. ALT: A jumping child; a smiling elder among photos."
```

### ILL016 — tall | short (split card)

```yaml
id: A1-C05-ILL016
purpose: "V021 tall / V022 short — the height pair over one shared scene."
scene: "One room, one high shelf: left, a figure reaches it with ease (door frame as
  ruler); right, a figure on a step stool reaches the same shelf, cheerful."
composition: "Vertical split with the SAME shelf line crossing both halves — the constant
  makes height readable without numbers; per-half crops for items."
must_show: [high shelf on both halves, easy reacher, step-stool reacher, door frame]
must_not_show_extra: [text, measurement marks, mockery cues — both figures cheerful]
continuity: "Fictional figures; the easy-reacher styling doubles as EVA-adjacent (tall,
  straight dark hair) for the photo tasks."
alt_text: "One figure reaches a high shelf easily; another reaches it from a step stool."
embedding_slot: "V021/V022 cards, S07 + practice crops, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — the same high shelf in two panels: one figure reaching it
  easily beside a door frame, another cheerfully reaching it from a step stool.
  MUST_SHOW: shared high shelf, both reachers, door frame. MUST_NOT_SHOW: {NEG}, rulers
  or marks. ALT: One figure reaches a shelf easily; another from a step stool."
```

### ILL017 — friendly

```yaml
id: A1-C05-ILL017
purpose: "V023 friendly — warmth you can see."
scene: "A figure mid-wave with an open posture, rounded welcome gesture, big warm smile;
  soft speech-bubble-free space around (bubbles would imply text)."
composition: "Single centred figure, generous negative space."
must_show: [waving hand, open posture, warm smile]
must_not_show_extra: [text, speech bubbles]
continuity: "Fictional figure, cast-adjacent styling."
alt_text: "A figure waves with a warm open smile."
embedding_slot: "V023 card, S07, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a single figure mid-wave with open posture and a big warm
  smile, generous negative space. MUST_SHOW: wave, open posture, smile. MUST_NOT_SHOW:
  {NEG}, speech bubbles. ALT: A figure waves warmly."
```

### ILL018 — kind

```yaml
id: A1-C05-ILL018
purpose: "V024 kind — helping made visible."
scene: "One figure hands a steaming cup to another seated figure; a blanket corner and a
  small cushion complete the care moment."
composition: "Two-figure domestic shot, the giving hands at the centre."
must_show: [hands giving a steaming cup, seated receiver, care details]
must_not_show_extra: [text, faces turned away (both faces visible and warm)]
continuity: "Fictional figures."
alt_text: "One figure hands a steaming cup to a seated figure."
embedding_slot: "V024 card, S07, 1:1"
status: placeholder
generation_prompt: "{STYLE} — one figure handing a steaming cup to a seated figure with a
  blanket corner nearby, both faces warm and visible. MUST_SHOW: giving hands, cup,
  seated receiver. MUST_NOT_SHOW: {NEG}. ALT: A figure gives a warm drink to someone
  seated."
```

### ILL019 — tens bundles (the -ty scene)

```yaml
id: A1-C05-ILL019
purpose: "PAT007 tens + PAT006 builds — bundles of ten as the -ty meaning cue."
scene: "A café tray carrying three NEAT bundles of ten cups each (cups banded in tens);
  variants for other items: two bundles + one loose cup (21), two bundles + three loose
  (23) — the loose-count is the unit."
composition: "Top-down tray view, bundles crisply separated, loose cups clearly outside
  the bands; countable at small size."
must_show: [banded bundles of ten cups, clearly separated loose cups in variants]
must_not_show_extra: [text, NUMERALS anywhere, ambiguous partial bundles]
continuity: "Cup design from the C2 count-scene family (same table, same palette) —
  deliberate Arc-1 callback."
alt_text: "A tray with three neat bundles of ten cups; variants add loose cups beside the bundles."
embedding_slot: "S09 pattern teach + PR-N003/009/010, 4:3 top-down"
status: placeholder
generation_prompt: "{STYLE} — a top-down café tray with three neat banded bundles of ten
  cups each, crisp separation, countable at small size. MUST_SHOW: three ten-cup bundles,
  bands. MUST_NOT_SHOW: {NEG}, numerals. ALT: A tray with three bundles of ten cups."
```

### ILL020 — -teen vs -ty (the contrast scene)

```yaml
id: A1-C05-ILL020
purpose: "PAT007's core contrast: loose-and-extra vs bundled-tens."
scene: "Split scene, same cups: left, thirteen cups standing LOOSE and scattered across a
  counter; right, thirty cups in three NEAT ten-bundles on a tray."
composition: "Vertical split; the grouping difference is the WHOLE meaning — loose says
  -teen, bundles say -ty; identical cup styling both sides."
must_show: [thirteen loose cups, three ten-bundles, identical cup styling]
must_not_show_extra: [text, numerals, count ambiguity (left side countable)]
continuity: "Same cup family as ILL019."
alt_text: "Thirteen cups stand loose on one side; thirty cups sit in three bundles of ten on the other."
embedding_slot: "S09 contrast player + PR-N009, 1:1 split"
status: placeholder
generation_prompt: "{STYLE} — the same cups in two panels: thirteen standing loose and
  scattered on a counter, thirty in three neat banded bundles on a tray. MUST_SHOW:
  loose scattered cups, three bundles, same cup style. MUST_NOT_SHOW: {NEG}, numerals.
  ALT: Loose cups on one side; bundled tens on the other."
```

### ILL021 — one hundred (the dot field)

```yaml
id: A1-C05-ILL021
purpose: "PAT008 — one hundred as ten bundles of ten."
scene: "A large square board filled with a neat ten-by-ten field of orange dots (100
  dots), ten per row; the regularity IS the number."
composition: "Flat top-down square; dots evenly spaced; four row-groups subtly separated
  by extra spacing every two rows for countability (no numerals)."
must_show: [10×10 grid of orange dots, even spacing]
must_not_show_extra: [text, numerals, partial dots]
continuity: "Orange = accent, paired with the grid structure — never colour alone."
alt_text: "A square board with one hundred orange dots in ten rows of ten."
embedding_slot: "S09 PAT008 card, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a square board filled with a neat ten-by-ten field of even
  orange dots, ten per row, subtle spacing between row pairs. MUST_SHOW: 10x10 dot grid.
  MUST_NOT_SHOW: {NEG}, numerals. ALT: One hundred dots in ten rows of ten."
```

### ILL022 — the photo questions (chunk scene)

```yaml
id: A1-C05-ILL022
purpose: "V025–V027 — one scene carries all three frames (questions about a photo)."
scene: "Left: a hand points at one photo on an open album page, a question-mark-shaped
  bubble above (no letters). Right: a figure counts on fingers (Nina's habit) beside
  another smiling figure."
composition: "Two-panel scene; the pointing hand and the counting fingers are the two
  question cues; frames and number tiles are app-layer."
must_show: [pointing hand at a photo, question bubble, finger-counting figure]
must_not_show_extra: [text, letters, numerals in art]
continuity: "The counting figure is Nina-styled (grey-streaked bun, teal cardigan) — her
  bible habit made useful."
alt_text: "A hand points at a photo under a question bubble; beside it, a figure counts on fingers."
embedding_slot: "S11 chunk teach + practices, 3:2 two-panel"
status: placeholder
generation_prompt: "{STYLE} — a hand pointing at one photo on an open album page beneath
  an empty question bubble, beside a figure counting on their fingers next to a smiling
  friend. MUST_SHOW: pointing hand, photo, question bubble, counting fingers. MUST_NOT_SHOW:
  {NEG}. ALT: A hand points at a photo; a figure counts on fingers."
```

---

# Screen inventory and UI/UX tips (S01–S12)

| screen | content | UI/UX tips |
|---|---|---|
| A1-C05-S01 | hook: photo afternoon, AUD001 | full-bleed art, line-highlight sync; replay always visible; captions off by default (audio-first), tap-to-reveal |
| A1-C05-S02 | warm-up WU1–3 | three-tap ribbon; one default replay per item; progress dots, not scores |
| A1-C05-S03 | Set A teach | card carousel over album pages; split cards flip halves on tap (reduce-motion: crossfade); each card ≤7 s of audio |
| A1-C05-S04 | Set A practice | help ladder: replay → frame highlight → hook line; feedback names the rule; PR-V008 order tiles snap with haptic (optional) |
| A1-C05-S05 | Set B teach | same card grammar as S03; one/many split card pulses the count on tap |
| A1-C05-S06 | Set B practice + **pause** | pause card at ≈minute 9 with [continue]/[break]; break exits cleanly, resume returns to this card |
| A1-C05-S07 | Sets C+D teach | Leo's photos then the descriptor wall; the friend anchor card opens Set C; Jordan line plays with NO photo tile (a soft empty frame stays empty — the art never invents Jordan) |
| A1-C05-S08 | Sets C+D practice | photo crops reuse S07 art; rings are app-layer and pair with position, never colour alone |
| A1-C05-S09 | pattern systems teach | segmented stepper (21–29 · tens · 100); bundle pulses with chain audio; -teen/-ty player enlarges the strong syllable |
| A1-C05-S10 | numbers practice + P001–P002 | digit chips ≥44 pt; bundles highlight on help rung 2; stress-tile targets large and position-paired |
| A1-C05-S11 | Set E teach + practice + P003 | frames shown as tiles with the number slot visually open; recording NOT here (it closes the lesson) |
| A1-C05-S12 | close: PR-P004 + recap | mic icon-only with visible skip (privacy note in item); close card stars the four clusters and previews L2; one-tap exit |

Accessibility carried on every screen: WCAG-AA on cream, ≥44 pt tap targets, no colour-only meaning (rings pair with position/crop; stress pairs with enlargement), alt text on every asset, reduced-motion variants for flips and pulses, replay never scored.

---

# Lesson self-check (lens pass at authoring time)

- **Counts:** 27 vocab/chunk records (V001–V027) + 3 pattern-system records (PAT006–008) · 41 bank items (PR-V001–027 + PR-N001–010 + PR-P001–004) + 3 warm-up · 37 audio (AUD001–037) · 22 ILL (ILL001–022; block 22/36) · 12 screens — matches the closed L1 manifest in `A1_C05_MANIFEST.md`.
- **Answer-key balance (audited by grep after writing):** 34 three-option items → **A 11 / B 12 / C 11**; 2-option items: PR-P001 B, PR-P002 A; non-positional: 3 order (PR-V008, PR-N004, PR-V027), 1 match (PR-V024), 1 recording (PR-P004). Four in-session remaps applied (PR-V025 A→B; PR-N003→C; PR-N006→B; PR-N008→B) — the audit reads the file, never the intention.
- **Red-team catches fixed in-session:** (1) PR-V006 drafted with three identical option strings (misspellings lost in transcription) — final set restored: brother / brofter / bruther; (2) PR-N009 drafted with the bundle art keyed to thirteen plus an inline correction note — rewritten clean to key THIRTY, note deleted; (3) the answer-key skews above, caught by the closing audit; (4) a learner-facing language sweep caught 8 guardrail leaks and rewrote them — possessive-'s in two learner_definitions (V004, V006), two feedback lines (V009, PR-V003), one feedback_correct (PR-V023), and the chapter promise; plus "say what someone has" and the close card's "Leo has a dog!" using has before L2 — the close card now NAMES the frames without using them (C3 am/is/are precedent), and has was removed from every learner-facing string.
- **Truncation scan:** zero `…`-ended fields, zero `TBD`/`TODO`; the only ellipses are sanctioned pause notation in audio scripts and the `…` inside chunk spellings and frame tiles.
- **Prerequisite audit:** every stem, option, and feedback line uses taught-or-same-lesson language. **No possessive 's** (all relationship wording uses possessive adjectives or first-person cast lines) · **no have/has anywhere** (hook checked line by line — "my dog, Pepper" is a noun phrase) · **no plural -s grammar** (children enters as a word; PR-V011's childs distractor is explicitly corrected against, not taught) · **no numbers above 100** · **no `Good night`** · no third-person -s verbs in any stem (cast lines use is/be-forms and nouns only).
- **Inclusivity & privacy:** husband/wife/partner parallel presentation (ruling 10 + bible); descriptors respectful by design (respect_guard fields on young/old/short); the learner's real family never requested — PR-P004 offers the four fictional cast photos only, with skip.
- **Standing guardrails held:** English only · no required typing · `sort` never used · all audio `qa_status: script_review` · all illustrations `status: placeholder` with {STYLE}/{NEG} macros for F3 · no numerals in any art · Ch5 figure facts from the bible (registered BEFORE authoring) · cumulative span Ch1–Ch4 preserved for the L3 quiz.





