# A1 — Chapter 4 — Lesson 1 (A1-C04-L01) — Welcome Back: Hello, Spell It, Say It Again

```yaml
lesson_id: A1-C04-L01
lesson_type: R                       # review lesson: recap + cumulative retrieval part 1 + clinic 1
chapter: 4
title: "Checkpoint Review 1: Welcome-Day Mission — Part 1: Hello, Spell It, Say It Again"
estimated_minutes: 20                # pause point after the retrieval block (≈ minute 9)
prerequisites:
  chapters: [1, 2, 3]                # 86 lexical rows + 5 pattern systems + G001–G009 all taught
  verified_against: "LEXICAL_LEDGER.csv (86 taught rows, no new rows this chapter) ·
    GRAMMAR_LEDGER.csv (G001–G009 taught) · A1_C04_MANIFEST.md rulings"
artifacts_manifest:
  recap_recall_items: 3              # A1-C04-RC001–003 (diagnostic, unscored)
  retrieval_items: 8                 # A1-C04-RT001–008 (Ch1 + Ch2 spans)
  clinic_items: 8                    # A1-C04-CL1-001–008 (clinic 1: be + person-word agreement)
  audio_scripts: 25                  # A1-C04-AUD001…AUD025
  illustration_briefs: 5             # A1-C04-ILL001…ILL005
  screens: 9                         # A1-C04-S01…S09
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
  - "Review chapter (§9.4): NO new targets. This lesson retrieves Ch1 + Ch2 spans; Ch3
    spans retrieve in L2. Every item carries target_ids citing ledger prerequisites."
  - "Recombination is not new language: pronoun swaps inside taught frames (e.g. 'You're
    Maya') count as retrieval. No ledger rows are added."
  - "Be-agreement choice items never use Alex as a singular referent (Alex = they/them per
    bible); singular items use Leo/Nina/Maya, plural items use named pairs ('Maya and
    Sam'). No plural-origin sentence asserts a country pair that does not exist in canon."
  - "Clinic 1 absorbs C3-CLIN-A (they is/they are) into the wider am/is/are confusion;
    clinic art comes from the fresh A1-C04-ILL block (C3 block is complete — owner note 3)."
  - "RC001–003 are diagnostic recap taps, unscored, not part of the practice bank."
instruction_lexicon_note: >-
  Stages 1–4 all active this chapter (listen, look, tap, choose, match, say, repeat, one,
  two, again, correct, try again, put in order, first, next, last, read, answer, record,
  play, check). RT008 uses "record" legally (stage 4 since C3-L2), icon-cued with the
  microphone demo. "sort" is never used as a word. No new instruction words.
scene_glue_note: >-
  Glue words this lesson (receptive, illustrated or icon-cued, never tested, never
  targets): morning, welcome, help, door, fast, counts, badge (badge was already glue at
  C1-L2 S12; welcome was already glue at C3-L1). Newcomers Amara Otieno and Rafael Costa
  are bible-registered BEFORE first use; their first lines are in L2/L3 — they do not
  speak in this lesson.
```

---

## Mission promise (chapter re-entry, screen S01)

**Your mission:** one new morning at the Community House — a welcome morning for new neighbors. Alex says: *"You're my friend! Look: one badge. It's your badge!"* You say hello. You check in. You say: *"This is my friend …"*

Three steps, three lessons: **today** — hello, names, spelling, numbers, and one clinic on *am/is/are*. Lesson 2 — the welcome morning: sounds, forms, and frames. Lesson 3 — the mission roleplay and **Checkpoint 1**.

This lesson adds **no new words**. Everything is what you know — retrieved, mixed, and used faster.

---

## §1 Story re-entry — the recap carousel (S01–S04)

One new morning. The Community House door is open. Before the mission starts, three memories — three pictures on the wall of everything Chapters 1–3 built. Each beat ends with one diagnostic tap (unscored; the app uses it only to pick practice support).

### Beat A — the map wall (S02 · ILL001)

The big world map. **Six orange dots** now — five cast dots and yours (placed in the Chapter 3 mission).

**AUD001** — `recap_narration_A` · guide voice · learning_slow_clear

```text
GUIDE: Look! … The map wall. … Six dots. …
Alex — Canada. … Maya — Egypt. … Leo — Australia. …
Nina — Peru. … Sam — Mexico. … … (warm) And you. … Your dot!
```

**RC001** — `recap_recall_map` · diagnostic · unscored

```yaml
id: A1-C04-RC001
type: image_three_option
instruction_words: [look, tap]
stimulus_visual: "ILL001 (map wall, six dots); one dot highlighted under Nina's region"
prompt_audio: AUD001 (final line replays: "Nina — Peru.")
prompt_text: "Nina — ?"
target_ids: [A1-C03-L01-V009, A1-C03-L01-V034]
options:
  - {id: A, label: Egypt}
  - {id: B, label: Peru}
  - {id: C, label: Canada}
correct_option_ids: [B]
rationale: "Nina is from Peru (bible + C3-L1 AUD001); the highlighted dot sits on Peru."
feedback_correct: "Yes! Nina is from Peru."
feedback_incorrect: "Look at the highlighted dot. It is on Peru."
help_ladder: "rung 1 replay AUD001 final line → rung 2 highlight the Peru dot only → rung 3 answer with explanation."
```

### Beat B — the check-in desk (S03 · ILL002)

The little desk by the door. The register page with three rows: name · phone digits · email message. This is where Chapter 2 happened.

**AUD002** — `recap_narration_B` · guide voice · learning_slow_clear

```text
GUIDE: Look! … Nina's desk. … The register page. …
Name. … Phone number. … Email address. …
(warm) You know these words!
```

**RC002** — `recap_recall_friend` · diagnostic · unscored

```yaml
id: A1-C04-RC002
type: audio_three_option
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD003
prompt_text: "Maya + Sam = ?"
target_ids: [A1-C03-L01-V026, A1-C03-L01-V029]
options:
  - {id: A, label: friends}
  - {id: B, label: teachers}
  - {id: C, label: students}
correct_option_ids: [A]
rationale: "'This is my friend Sam' (C3-L1) — Maya and Sam are friends (bible known-facts)."
feedback_correct: "Yes! They're friends."
feedback_incorrect: "Maya says: 'This is my friend Sam.' Friends!"
help_ladder: "rung 1 replay → rung 2 highlight 'friend' in the caption → rung 3 answer with explanation."
```

**AUD003** — `recap_line_friend` · Maya · learning_slow_clear

```text
MAYA: (warm) This is my friend Sam.
```

**RC003** — `recap_recall_number` · diagnostic · unscored

```yaml
id: A1-C04-RC003
type: audio_number_three_option
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD004
prompt_text: "Ten + ten = ?"
target_ids: [A1-C02-L02-PAT005]
options:
  - {id: A, label: "12"}
  - {id: B, label: "11"}
  - {id: C, label: "20"}
correct_option_ids: [C]
rationale: "Nina counts Leo's cups on her fingers — ten and ten is twenty (C2-L2 canon, AUD032)."
feedback_correct: "Yes! Twenty cups."
feedback_incorrect: "Listen again: ten… and ten. Twenty!"
help_ladder: "rung 1 replay → rung 2 show 10 + 10 finger icons → rung 3 answer with explanation."
```

**AUD004** — `recap_line_count` · Nina · learning_slow_clear

```text
NINA: (counting on fingers, patient) Ten… and ten… … twenty!
```

### Beat C — the badges, and the new morning (S04 · ILL003 + ILL005)

Blank name badges on the table — like the first welcome event. Then the notice board: a new poster. Sun, house, people, one star. **A second welcome morning — for new neighbors.**

**AUD005** — `recap_narration_C` · guide voice + Alex · learning_slow_clear

```text
GUIDE: Look! … The badges. … And the notice board. …
(warm) A welcome morning! … New people are at the door.
ALEX: (bright) Hi! You're my friend! … Look: one badge. … It's your badge!
```

UI note: "new people", "at the door", and "welcome morning" ride as illustrated glue (ILL005 shows the poster; the door stands open in ILL003's background). Nothing here is tested.

---

## §2 Cumulative retrieval — part 1: Chapters 1 + 2 (S05–S07)

**S05 — the mission card.** Three steps, one star each: 👋 *Say hello* · 📝 *Check in* · 👥 *"This is my friend…"*. Today's tap work feeds step 1 and step 2.

Sixteen retrieval items cover the chapter (§9.4); **items 1–8 below are today's half** — greetings, names, spelling, numbers, contact cards, repair, and one supported recording. Each is faster and more mixed than in Chapter 2: recognition at study speed was then; this is recognition at welcome-morning speed.

### RT001 — greeting → time-of-day scene

```yaml
id: A1-C04-RT001
type: audio_to_scene
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD006
prompt_text: "Look. Tap: morning · afternoon · evening."
target_ids: [A1-C01-L01-V003, A1-C01-L01-V004, A1-C01-L01-V005]
options:
  - {id: A, asset: "café scene, sun low, long shadows (morning)"}
  - {id: B, asset: "park scene, sun high, short shadows (afternoon)"}
  - {id: C, asset: "station scene, dusk sky, warm lamps (evening)"}
correct_option_ids: [B]
rationale: "'Good afternoon' matches the high-sun afternoon scene (V004)."
feedback_correct: "Good afternoon! ☀️"
feedback_incorrect: "The sun is high — afternoon. 'Good afternoon!'"
help_ladder: "rung 1 replay → rung 2 dim two scenes → rung 3 replay with the word 'afternoon' highlighted in the caption."
distractor_design: "Scenes differ by sun height and palette only — never a night scene (Good night is banned as greeting or distractor)."
```

**AUD006** — `rt001_greeting` · Nina · learning_slow_clear

```text
NINA: (clear, friendly) Good afternoon!
```

### RT002 — first name or last name?

```yaml
id: A1-C04-RT002
type: audio_detail_three_option
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD007
prompt_text: "First name = ?"
target_ids: [A1-C01-L02-V021, A1-C01-L02-V022, A1-C01-L02-V023]
options:
  - {id: A, label: Maya}
  - {id: B, label: Haddad}
  - {id: C, label: "Maya Haddad"}
correct_option_ids: [A]
rationale: "Maya is the first name; Haddad is the last name (C1-L2)."
feedback_correct: "Yes — Maya is her first name."
feedback_incorrect: "Maya = first name. Haddad = last name."
help_ladder: "rung 1 replay → rung 2 split-screen name card (first | last) → rung 3 answer with explanation."
```

**AUD007** — `rt002_name` · Maya · learning_slow_clear

```text
MAYA: (warm) My name is Maya Haddad.
```

### RT003 — best next turn

```yaml
id: A1-C04-RT003
type: best_next_turn
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD008
prompt_text: "You say:"
target_ids: [A1-C01-L02-V028, A1-C01-L02-V029, A1-C01-L02-V030, A1-C01-L02-V024]
options:
  - {id: A, label: "My name is Alex."}
  - {id: B, label: "See you!"}
  - {id: C, label: "I'm good, thank you. And you?"}
correct_option_ids: [C]
rationale: "'How are you?' asks a state, not a name; the taught answer chain is I'm good + thank you + And you?"
feedback_correct: "Yes! And Alex says: 'I'm great.'"
feedback_incorrect: "'How are you?' — you say: 'I'm good, thank you. And you?'"
help_ladder: "rung 1 replay → rung 2 show the state-word chip row (good · fine · okay · great · not bad) → rung 3 answer with explanation."
```

**AUD008** — `rt003_question` · Alex · learning_slow_clear

```text
ALEX: (bright) Hi! How are you?
```

### RT004 — spell the name you heard

```yaml
id: A1-C04-RT004
type: audio_spelling_three_option
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD009
prompt_text: "Tap the name."
target_ids: [A1-C02-L01-PAT001, A1-C02-L01-V007]
options:
  - {id: A, label: Maya}
  - {id: B, label: Maia}
  - {id: C, label: Mayha}
correct_option_ids: [A]
rationale: "The letters spell M-A-Y-A; only option A matches every heard letter."
feedback_correct: "M-A-Y-A. Maya!"
feedback_incorrect: "Listen: M… A… Y… A. Maya."
help_ladder: "rung 1 replay with letter-by-letter captions → rung 2 letter tiles M _ Y _ revealed → rung 3 answer with explanation."
distractor_design: "Both distractors are near-miss spellings of the same heard name — no real variant is offered as correct."
```

**AUD009** — `rt004_spelling` · Nina · learning_slow_clear

```text
NINA: (patient) Maya. … M - A - Y - A.
```

### RT005 — phone digits at welcome-morning speed

```yaml
id: A1-C04-RT005
type: audio_digits_three_option
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD010
prompt_text: "Tap the phone number."
target_ids: [A1-C02-L01-PAT002, A1-C02-L02-PAT003, A1-C02-L02-PAT004, A1-C02-L02-PAT005]
options:
  - {id: A, label: "6-2-0 · 1-4-5"}
  - {id: B, label: "6-2-0 · 1-5-4"}
  - {id: C, label: "2-6-0 · 1-5-4"}
correct_option_ids: [B]
rationale: "Leo's canon number is 6-2-0, 1-5-4 (C2-L4 quiz check-in); the two distractors swap one digit inside or across groups."
feedback_correct: "Yes — 6-2-0, 1-5-4. Leo's number."
feedback_incorrect: "Listen for the last group: one… five… four."
help_ladder: "rung 1 replay with digit captions → rung 2 digit tiles appear in heard groups → rung 3 answer with explanation."
```

**AUD010** — `rt005_phone` · Leo · challenge_natural_slow

```text
LEO: (relaxed, quick) My phone number is 6-2-0… 1-5-4.
```

### RT006 — repair under speed

```yaml
id: A1-C04-RT006
type: repair_choice
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD011          # challenge pace — by design
prompt_audio: A1-C04-AUD012            # guide framing line
prompt_text: "Fast! You say:"
target_ids: [A1-C02-L01-V008]
options:
  - {id: A, label: "Can you repeat that, please?"}
  - {id: B, label: "How are you?"}
  - {id: C, label: "See you!"}
correct_option_ids: [A]
rationale: "The question came too fast to catch — the taught repair is the repeat request (C2-L1)."
feedback_correct: "Yes! Alex says it again — slowly."
feedback_incorrect: "Too fast? Say: 'Can you repeat that, please?'"
help_ladder: "rung 1 replay at learning pace (the app reveals what was said) → rung 2 show the repair chip row (repeat · slow · spell) → rung 3 answer with explanation."
design_note: "One default replay is permitted (audio guide); after a replay the challenge take plays at learning pace — latency or replays never lower the score."
```

**AUD011** — `rt006_fast_question` · Alex · challenge_natural_slow

```text
ALEX: (quick, natural) What's your email address?
```

**AUD012** — `rt006_framing` · guide · learning_slow_clear

```text
GUIDE: (warm) Fast! … What do you say?
```

### RT007 — the register card

```yaml
id: A1-C04-RT007
type: listening_detail_card
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD013          # two-line mini-exchange
prompt_text: "Tap Maya's card."
target_ids: [A1-C02-L02-V010, A1-C02-L02-V011, A1-C02-L02-V012, A1-C02-L01-PAT002, A1-C02-L02-PAT003]
options:                               # app-rendered contact cards (ILL002 art family)
  - {id: A, card: "Nina Petrova · 5-5-5 2-0-9 · nina.petrova@aroa.com"}
  - {id: B, card: "Leo Novak · 6-2-0 1-5-4 · leo.novak@aroa.com"}
  - {id: C, card: "Maya Haddad · 5-5-5 2-0-1 · maya.haddad@aroa.com"}
correct_option_ids: [C]
rationale: "Maya's canon card is phone 5-5-5, 2-0-1 and maya.haddad@aroa.com; both name and digits must match the heard line."
feedback_correct: "Yes — Maya's card: 5-5-5, 2-0-1."
feedback_incorrect: "Listen: 'Five-five-five… two-zero-one.' That is Maya's card."
help_ladder: "rung 1 replay with digit captions → rung 2 dim Nina's and Leo's cards → rung 3 answer with explanation."
canon_check: "All three cards are bible/canon contacts (Nina C2-L3 message card; Leo C2-L4; Maya C2-L2 AUD061). No invented data."
```

**AUD013** — `rt007_register` · Nina + Maya · learning_slow_clear

```text
NINA: (clear) Maya — your phone number, please?
MAYA: (warm) 5-5-5… 2-0-1.
```

### RT008 — supported recording: your badge line

```yaml
id: A1-C04-RT008
type: supported_recording              # icon-cued; stage-4 word "record" is legal here
instruction_words: [listen, say, record, play]
model_audio: A1-C04-AUD014
prompt_text: "You say: 'Good morning! My name is ___. I'm a ___.'"
target_ids: [A1-C01-L01-V003, A1-C01-L02-V024, A1-C01-L02-V025, A1-C03-L01-V036]
supported_build: >-
  Step 1: tap the greeting chip (Good morning! · Hello! · Hi!) — any is correct.
  Step 2: tap your safe fictional name chip (WR006 fictional-name bank, C3-L3) or skip.
  Step 3: tap one job chip from the nine taught jobs (student · teacher · doctor · nurse ·
  engineer · designer · driver · cook · office worker). Step 4: record · play · check.
skip_path: "One tap: 'Not today.' The model plays; the item closes as complete-with-skip; nothing is asserted about the learner."
privacy_note: "Recording stays on the device; only the learner can play it. No upload, no scoring of accent — the check is self-tapped ('Sounds like the model' / 'Again, please')."
rationale: "Integrates greeting + name + job frame — the exact badge line the L3 mission opens with."
help_ladder: "rung 1 replay model → rung 2 chunk chips appear one at a time with the model's rhythm dots → rung 3 model + learner take play back-to-back for self-check."
```

**AUD014** — `rt008_model` · Alex · learning_slow_clear

```text
ALEX: (bright, model rhythm) Good morning! … My name is Alex. … I'm a designer.
```

**Pause point (end of S07, ≈ minute 9).** Progress saves. The clinic waits; returning resumes exactly here.

---

## §3 Clinic 1 — be + person-word agreement (S08 · ILL004)

**One confusion:** *am / is / are* with the person words — I · you · he · she · they · we. This is the grammar spine of all three chapters, and the place where "they is" and "I is" sneak back in (C3-CLIN-A now lives here).

**Why it matters for the mission:** every mission line is a be-line — *"You're Maya." "He's Leo." "They're my friends." "We're friends."*

### The model (CL1-001)

**AUD015** — `clinic1_model_learning` · cast six-pack · learning_slow_clear — and **AUD016** — `clinic1_model_challenge` · same content, fresh challenge take

```text
ALEX:  (bright)      I'm Alex.
NINA:  (reads badge) Hi! You're Maya.
MAYA:  (points)      He's Leo.
SAM:   (cheerful)    She's Nina.
MAYA:  (warm)        Alex and Sam! They're my friends.
ALEX:  (arm in arm with Maya) We're friends!
```

ILL004 shows six panels — one figure, one badge-reader pair, one pointing pair, one pair + one, two pairs — the words am/is/are stay in the app layer as colored chips under each panel. Challenge take: same six lines, connected, no panel pauses.

```yaml
id: A1-C04-CL1-001
type: clinic_model                 # perception model — no response required
instruction_words: [listen, look]
audio_asset_ids: [A1-C04-AUD015, A1-C04-AUD016]
visual_asset_id: A1-C04-ILL004
target_ids: [A1-C01-L02-G001, A1-C03-L02-G007]
presentation: "Panels light in step with the six learning-take lines (reduced-motion:
  numbered halos, no motion); the challenge take plays once after, chips dark, for
  perception only. One optional replay of each take."
rationale: "Input before any ask: all six person-word + be pairs heard with explicit
  named referents before the first choice item."
```

### CL1-002 — hear it, point at the person

```yaml
id: A1-C04-CL1-002
type: audio_to_person
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD017
prompt_text: "Tap: she."
target_ids: [A1-C03-L02-G007]
options:
  - {id: A, asset: "Leo (blue apron, waving)"}
  - {id: B, asset: "Nina (teal cardigan, notebook)"}
  - {id: C, asset: "Sam (green t-shirt, blank badge)"}
correct_option_ids: [B]
rationale: "'She's Nina' — she points at Nina; he/she map to the named referent in the line (G007 discipline)."
feedback_correct: "Yes — she = Nina."
feedback_incorrect: "The voice says 'She's Nina.' She = Nina."
help_ladder: "rung 1 replay → rung 2 the she-chip glows under the line → rung 3 answer with explanation."
```

**AUD017** — `cl1002_line` · Maya · learning_slow_clear

```text
MAYA: (warm) She's Nina.
```

### CL1-003 — is / are / am with one person

```yaml
id: A1-C04-CL1-003
type: form_choice
instruction_words: [read, tap]          # stage-4 "read" is legal; a speaker icon replays the line too
stimulus_text: "Nina ___ from Peru."
speaker_icon_replay: A1-C04-AUD018
target_ids: [A1-C03-L02-G007, A1-C03-L01-V009, A1-C03-L01-V033]
options:
  - {id: A, label: am}
  - {id: B, label: are}
  - {id: C, label: is}
correct_option_ids: [C]
rationale: "Nina = one person, she — be takes is. Am is only I; are is you/we/they."
feedback_correct: "Yes — Nina is from Peru. She's from Peru."
feedback_incorrect: "One person (she) → is. 'Nina is from Peru.'"
help_ladder: "rung 1 replay the line with 'is' voiced → rung 2 ILL004 panel 3 highlights (one person → is) → rung 3 answer with explanation."
```

**AUD018** — `cl1003_line` · Nina · learning_slow_clear

```text
NINA: (patient) I'm Nina. I'm from Peru.
```

### CL1-004 — is / are / am with two people

```yaml
id: A1-C04-CL1-004
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Maya and Sam ___ friends."
speaker_icon_replay: A1-C04-AUD019
target_ids: [A1-C03-L02-G007, A1-C03-L01-V026, A1-C03-L01-V029]
options:
  - {id: A, label: are}
  - {id: B, label: is}
  - {id: C, label: am}
correct_option_ids: [A]
rationale: "Maya and Sam = two people, they — be takes are. The canon line is 'They're my friends.'"
feedback_correct: "Yes — Maya and Sam are friends. They're friends."
feedback_incorrect: "Two people (they) → are. 'Maya and Sam are friends.'"
help_ladder: "rung 1 replay with 'are' voiced → rung 2 ILL004 panel 5 highlights (two people → are) → rung 3 answer with explanation."
```

**AUD019** — `cl1004_line` · Maya · learning_slow_clear

```text
MAYA: (warm) Alex and Sam! They're my friends.
```

### CL1-005 — your own line

```yaml
id: A1-C04-CL1-005
type: form_choice
instruction_words: [read, tap]
stimulus_text: "I ___ a student."
speaker_icon_replay: A1-C04-AUD020
target_ids: [A1-C01-L02-G001, A1-C03-L01-V017, A1-C03-L01-V036]
options:
  - {id: A, label: are}
  - {id: B, label: is}
  - {id: C, label: am}
correct_option_ids: [C]
rationale: "I takes am — the first chunk ever taught ('I'm …'). Learner identity is never asserted: the sentence is the learner's own badge line, 'student' is one of the nine taught jobs."
feedback_correct: "Yes — I am a student. I'm a student."
feedback_incorrect: "I → am. 'I'm a student.'"
help_ladder: "rung 1 replay with 'am' voiced → rung 2 ILL004 panel 1 highlights (I → am) → rung 3 answer with explanation."
inclusive_note: "If the learner's chosen job chip from RT008 differs, the sentence rebuilds with that job — the grammar point is unchanged."
```

**AUD020** — `cl1005_line` · guide · learning_slow_clear

```text
GUIDE: (warm) You say: I'm a student.
```

### CL1-006 — the negative pair

```yaml
id: A1-C04-CL1-006
type: form_choice_contextual
instruction_words: [read, tap]
stimulus_text: "Leo isn't a doctor. He ___ a cook."
speaker_icon_replay: A1-C04-AUD021
target_ids: [A1-C03-L02-G007, A1-C03-L01-V019, A1-C03-L01-V024]
options:
  - {id: A, label: are}
  - {id: B, label: is}
  - {id: C, label: am}
correct_option_ids: [B]
rationale: "He = one person → is; isn't already shows the negative, so the gap needs is, not a new negative."
feedback_correct: "Yes — Leo is a cook. He isn't a doctor."
feedback_incorrect: "He → is. 'He is a cook. He isn't a doctor.'"
help_ladder: "rung 1 replay both lines → rung 2 the isn't chip and is chip glow in pairing → rung 3 answer with explanation."
```

**AUD021** — `cl1006_line` · Leo · learning_slow_clear

```text
LEO: (friendly laugh) I'm not a doctor! … I'm a cook.
```

### CL1-007 — rebuild the model line (tile order)

```yaml
id: A1-C04-CL1-007
type: tile_order
instruction_words: [listen, put in order]
stimulus_audio: A1-C04-AUD022
tiles: ["Australia", "from", "I'm"]
prompt_text: "Leo says:"
target_ids: [A1-C03-L02-G007, A1-C03-L01-V011, A1-C03-L01-V033]
correct_order: ["I'm", "from", "Australia"]
rationale: "Rebuilds Leo's canon line 'I'm from Australia' — frame order I'm + from + country (C3-L1)."
feedback_correct: "'I'm from Australia.' Leo's line!"
feedback_incorrect: "First: I'm. Next: from. Last: the country — Australia."
help_ladder: "rung 1 replay with word highlights → rung 2 first tile locks itself as a worked example → rung 3 answer with explanation."
```

**AUD022** — `cl1007_line` · Leo · learning_slow_clear

```text
LEO: (relaxed) I'm from Australia.
```

### CL1-008 — transfer: the badge game

```yaml
id: A1-C04-CL1-008
type: contextual_choice
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD023          # mini-scene: Leo at the badge table, Maya in front of him
scene_visual: "ILL003 family — Leo holds Maya's blank badge up, both visible, Maya facing Leo"
prompt_text: "Leo says: '___ Maya!'"
target_ids: [A1-C01-L02-G001, A1-C03-L02-G007]
options:
  - {id: A, label: "I'm"}
  - {id: B, label: "You're"}
  - {id: C, label: "She's"}
correct_option_ids: [B]
rationale: "Leo is speaking TO Maya, face to face — second person: You're Maya. She's would be talking about her to someone else; I'm is Leo naming himself."
feedback_correct: "Yes! Leo looks at Maya: 'You're Maya!'"
feedback_incorrect: "Leo looks at Maya and speaks to her → you. 'You're Maya!'"
help_ladder: "rung 1 replay scene → rung 2 the eye-line arrow between Leo and Maya glows → rung 3 answer with explanation."
```

**AUD023** — `cl1008_scene` · Leo + Maya · learning_slow_clear

```text
LEO:  (reads the badge, pleased) Ah! … You're Maya!
MAYA: (warm laugh) Yes! Nice to meet you.
```

### Clinic 1 — exit and routing

```yaml
clinic_exit:
  criterion: "6 of 7 interactive items (CL1-002…008) correct with no help above rung 2."
  on_exit: "Mission card step 2 earns its star; session close plays."
  on_stay: "Parallel clinic items (app-generated from the same six panels, same referents) return tomorrow and after the L2 clinic; Checkpoint 1 always re-samples this confusion (A1-CP1-G block)."
  duration_target: "5–8 minutes — the model plays once (plus one optional replay); items are one tap each."
```

---

## §4 Session close (S09)

**AUD024** — `pause_encouragement` · guide · learning_slow_clear

```text
GUIDE: (warm) Good! … Sixteen words back. … Take a break — or one more clinic item.
```

Close prompts (guide-led, no bank items, no scoring): *Say: "Good morning!"* (tap-to-reveal the sun icon) · *Spell: Maya* (letter tiles flip) · *Alex says: "How are you?" — you say: …* (three state-word chips wave). Each ends with a play button replaying the learner's choice.

**AUD025** — `session_close` · guide + Alex · learning_slow_clear

```text
GUIDE: (warm) That is Lesson 1. … Two stars on your mission card!
ALEX: (bright) Next: the welcome morning! … New people. New names. … See you!
```

Next-time preview (S09 footer, icon row): 🌍 map cards · 👥 two new faces · 🎧 one long listen · ✍️ tiles — *Lesson 2: the welcome morning.*

---

## Encounter and review map (this lesson)

| Span | Targets retrieved | Where (cites) |
|---|---|---|
| C1 greetings/time-of-day | V003 · V004 · V005 | RT001, RT008 |
| C1 states + How-are-you chain | V016–V020 · V028–V030 | RT003 (chips), close prompts |
| C1 identity | V021 · V022 · V023 · V024 · V025 · G001 | RT002, RT003, RT008, CL1-005, CL1-008 |
| C1 Nice to meet you | V027 | AUD023 (Maya's reply) |
| C2 alphabet | PAT001 · V007 (C2) | RT004 |
| C2 numbers 0–20 | PAT002–PAT005 | RC003, RT005, RT007 |
| C2 contact | V010–V012 (C2) · V018 (C2) | RT006, RT007 |
| C2 repair | V008 (C2) | RT006 |
| C3 countries | V009 · V011 · V033 · V034 | RC001, CL1-003, CL1-007 |
| C3 jobs | V017 · V019 · V024 · V036 | RT008, CL1-005, CL1-006 |
| C3 people/friend | V026 · V029 | RC002, CL1-004 |
| C3 grammar | G001 · G005 · G007 | clinic 1 (all items), AUD005 ("It's your badge") |

This lesson is one later-chapter retrieval for every target above (the ledgers' `later_review_chapters: 4` entries begin fulfilling here). No new targets; no ledger rows changed.

---

## Audio index — A1-C04 block, L1 (25 scripts, AUD001–AUD025)

| ID | slug | voice | style | used by |
|---|---|---|---|---|
| AUD001 | recap_narration_A | guide | learning_slow_clear | S02 |
| AUD002 | recap_narration_B | guide | learning_slow_clear | S03 |
| AUD003 | recap_line_friend | Maya | learning_slow_clear | RC002 |
| AUD004 | recap_line_count | Nina | learning_slow_clear | RC003 |
| AUD005 | recap_narration_C | guide + Alex | learning_slow_clear | S04 |
| AUD006 | rt001_greeting | Nina | learning_slow_clear | RT001 |
| AUD007 | rt002_name | Maya | learning_slow_clear | RT002 |
| AUD008 | rt003_question | Alex | learning_slow_clear | RT003 |
| AUD009 | rt004_spelling | Nina | learning_slow_clear | RT004 |
| AUD010 | rt005_phone | Leo | challenge_natural_slow | RT005 |
| AUD011 | rt006_fast_question | Alex | challenge_natural_slow | RT006 |
| AUD012 | rt006_framing | guide | learning_slow_clear | RT006 |
| AUD013 | rt007_register | Nina + Maya | learning_slow_clear | RT007 |
| AUD014 | rt008_model | Alex | learning_slow_clear | RT008 |
| AUD015 | clinic1_model_learning | cast six-pack | learning_slow_clear | CL1-001 |
| AUD016 | clinic1_model_challenge | cast six-pack | challenge_natural_slow | CL1-001 |
| AUD017 | cl1002_line | Maya | learning_slow_clear | CL1-002 |
| AUD018 | cl1003_line | Nina | learning_slow_clear | CL1-003 |
| AUD019 | cl1004_line | Maya | learning_slow_clear | CL1-004 |
| AUD020 | cl1005_line | guide | learning_slow_clear | CL1-005 |
| AUD021 | cl1006_line | Leo | learning_slow_clear | CL1-006 |
| AUD022 | cl1007_line | Leo | learning_slow_clear | CL1-007 |
| AUD023 | cl1008_scene | Leo + Maya | learning_slow_clear | CL1-008 |
| AUD024 | pause_encouragement | guide | learning_slow_clear | S07 pause |
| AUD025 | session_close | guide + Alex | learning_slow_clear | S09 |

All records open at `qa_status: script_review`; transcripts release per §10.7 (listening items release after the response; models release with the screen). Planned filenames follow `<ASSET_ID>_<style>_<take>.wav`.

---

## Illustration briefs — A1-C04-ILL001–005 (5 of 16; block allocation in the manifest)

### ILL001 — recap A: the map wall, six dots

```yaml
id: A1-C04-ILL001
purpose: "Recap beat A — the Arc-1 payoff image: six dots now."
scene: "The 'Neighbors Around the World' wall from C3-L1 ILL001, now with SIX orange dot
  stickers on the big world map — five cast dots (Canada, Egypt, Australia, Peru, Mexico)
  and the learner's dot, placed in the C3-L3 mission. Morning light, Community House hall."
composition: "Wall-facing view, map filling the upper two-thirds, wainscot below; dots as
  flat orange circles large enough to count at small size; no furniture clutter."
must_show: [world-map outline, six orange dots, cream wall, soft morning light]
must_not_show_extra: [country names, flags, people, the empty sixth space]
continuity: "Same wall, same map silhouette as A1-C03-ILL001 — the only change is the
  sixth dot where the empty space was."
alt_text: "A world map on a cream wall with six orange dot stickers."
embedding_slot: "S02 hero, 3:2, full-bleed left"
status: placeholder
generation_prompt: "{STYLE} — a large world map poster on a cream wall in a community
  hall, morning light, six orange dot stickers placed on the map, generous negative space,
  flat editorial shapes. MUST_SHOW: world map outline, six orange dots, cream wall, soft
  light. MUST_NOT_SHOW: {NEG}, country names, flags, people, lettering. ALT: A world map
  on a cream wall with six orange dot stickers."
```

### ILL002 — recap B: the check-in desk

```yaml
id: A1-C04-ILL002
purpose: "Recap beat B — where Chapter 2 happened; anchors register-card items."
scene: "Nina's small check-in desk by the Community House door: a register page with three
  empty rows (name, digits, message — three icon-headed columns), a pen on a string, a jar
  of blank badges. Nina not present (the desk waits)."
composition: "Three-quarter desk view, register page dominant, icons (person silhouette ·
  phone · envelope) heading the three columns; warm terracotta desk edge."
must_show: [desk, register page, three icon-headed columns, pen, blank badges jar]
must_not_show_extra: [legible writing, digits, logos, hands]
continuity: "Register-page genre from C2-L2 ILL024 (three rows: name · digits · message)."
alt_text: "A small check-in desk with a three-column register page, a pen, and a jar of blank badges."
embedding_slot: "S03 hero, 4:3"
status: placeholder
generation_prompt: "{STYLE} — a small wooden check-in desk in a community hall, a register
  page with three columns headed by a person icon, a phone icon and an envelope icon, a pen
  on a string, a jar of blank badges. MUST_SHOW: desk, register page, three icon columns,
  pen, badge jar. MUST_NOT_SHOW: {NEG}, handwriting, digits. ALT: A check-in desk with a
  three-column register page and a jar of blank badges."
```

### ILL003 — recap C: the badge table

```yaml
id: A1-C04-ILL003
purpose: "Recap beat C and CL1-008 scene base — badges and the greeting triangle."
scene: "The badge table from the first welcome event: blank name badges fanned on a
  terracotta cloth; in the background the open Community House door, morning light, notice
  board edge visible. Leo-and-Maya badge-game variant (CL1-008) reuses this art with the
  two figures in the foreground corners."
composition: "Table diagonal across the lower third, badges large and countable (five),
  door and light as a soft background triangle; the CL1-008 crop keeps Leo (blue apron)
  left and Maya (green scrubs) right, eye-line arrows live in the app layer."
must_show: [five blank badges, terracotta cloth, open door, morning light]
must_not_show_extra: [text on badges, lanyard logos, more than two figures in the crop]
continuity: "Badge design from C1-L2 S12 (blank rectangle on a red lanyard); Leo and Maya
  model sheets A1-CHAR-ILL001/003 expressions."
alt_text: "A table with five blank name badges; behind it, an open door lets in morning light."
embedding_slot: "S04 hero + CL1-008 inset, 3:2"
status: placeholder
generation_prompt: "{STYLE} — a badge table with five blank name badges on a terracotta
  cloth, an open community-house door in the background with morning light. MUST_SHOW:
  five blank badges, cloth, open door, soft light. MUST_NOT_SHOW: {NEG}, writing on
  badges, logos. ALT: A table of blank name badges by an open, sunlit door."
```

### ILL004 — clinic 1 chart: one person or two

```yaml
id: A1-C04-ILL004
purpose: "Clinic 1 visual anchor — agreement shown as counting people, not as words."
scene: "Six flat panels in a 2×3 grid, each showing a person-word situation without words:
  (1) one figure pointing to self · (2) one figure facing one other figure · (3) one
  figure pointing at one other · (4) one figure pointing at a woman · (5) two figures
  plus two figures · (6) two figures arm in arm. The am/is/are chips live in the app
  layer under each panel, keyed amber (am) · orange (is) · blue (are)."
composition: "Even grid, generous gutters, figures as simple silhouettes with cast color
  cues (Alex mustard, Maya green, Leo blue, Nina teal, Sam green+tote); panels highlight
  softly one at a time during the clinic."
must_show: [six panels, self-point, face-to-face, pointing pairs, two-plus-two, arm in arm]
must_not_show_extra: [letters, numbers, word chips baked in, arrows with labels]
continuity: "Color cues from the character sheets; silhouette style keeps pronouns
  referential, never gendered inference — panels 3 and 4 differ by pointing direction only."
alt_text: "A six-panel chart of simple figures: pointing to self, facing one person,
  pointing at others, and pairs together."
embedding_slot: "S08 persistent strip, 16:9, panels tappable"
status: placeholder
generation_prompt: "{STYLE} — a six-panel grid of simple illustrated figures showing
  self-pointing, one-to-one facing, pointing at another person, and two pairs of people
  together, generous gutters, flat shapes, cast color cues (mustard, green, blue, teal).
  MUST_SHOW: six distinct panels, clear pointing directions, pairs. MUST_NOT_SHOW: {NEG},
  letters, numbers, word labels. ALT: A six-panel chart of figures pointing and pairing."
```

### ILL005 — the notice board: welcome morning

```yaml
id: A1-C04-ILL005
purpose: "Story bridge — the second welcome morning is announced; sets the chapter mission."
scene: "The Community House notice board: one big poster pinned center — sun, a little
  house, three small people figures, one star. Alex (mustard sweater, round glasses) pins
  the last corner, stepping back pleased. Map-wall edge visible left."
composition: "Board fills frame, poster dominant and icon-only; Alex small at the right
  edge, reaching; cork texture restrained."
must_show: [notice board, poster with sun + house + people + star, Alex pinning, map edge]
must_not_show_extra: [poster text, date, clock, flags]
continuity: "Alex model sheet A1-CHAR-ILL001 + waving expression ILL008; the poster's
  sun-house-people-star icon set returns on S05's mission card (app layer)."
alt_text: "Alex pins a poster showing a sun, a house, people, and a star to a notice board."
embedding_slot: "S04/S05 hero, 3:2"
status: placeholder
generation_prompt: "{STYLE} — a cork notice board in a community hall with one large
  icon-only poster (sun, small house, three people figures, one star), a person in a
  mustard sweater and round glasses pinning its corner. MUST_SHOW: board, poster icons
  (sun, house, people, star), pinning figure. MUST_NOT_SHOW: {NEG}, poster text, dates,
  flags. ALT: Alex pins a welcome-poster with sun, house, people, and star icons."
```

---

## Screens and UI/UX implementation notes (S01–S09)

| Screen | Content | UI/UX tips |
|---|---|---|
| S01 | Chapter re-entry + mission promise | Poster-icon row animates in once (reduced-motion: static fade); "no new words" chip under the title; continue button ≥44 pt; progress bar resets to chapter 4 of 12 with Arc-1 badge visible. |
| S02 | Recap A: map wall + RC001 | ILL001 full-bleed; dots pulse once in canon order (reduced-motion: numbered halos); RC001 as a single bottom card, one tap; replay button on the prompt. |
| S03 | Recap B: desk + RC002/003 | ILL002 left, two stacked recall cards right; each card independent (no gating); number tiles in RC003 at 56 pt with 8 pt spacing (tap forgiveness). |
| S04 | Recap C: badges → the new morning | ILL003 cross-fades to ILL005 on swipe (reduced-motion: button switch); AUD005 text never displayed (narration carries the glue); star icon previews the mission card. |
| S05 | Mission card: three steps | Icon steps (👋 📝 👥) with one-line captions in taught chunks; today's steps highlighted, L2/L3 steps dimmed but visible — the whole chapter in one glance; save state here. |
| S06 | Retrieval set 1 (RT001–004) | One item per card, swipe or tap-next; audio items show a single centered play button first, options reveal after first play (listening-first); letter/word options at 22 pt minimum. |
| S07 | Retrieval set 2 (RT005–008) + pause | Digits grouped 3+3 with a thin gap (matches canon grouping); RT008 microphone icon pulses with the model rhythm (reduced-motion: static ring); pause banner after RT008: "Break — or one more?" both buttons equal weight (no dark pattern). |
| S08 | Clinic 1 (model + CL1-002…008) | ILL004 strip pinned bottom, active panel glows softly (never color-only — panel number chip also lifts); each item one tap; rung-1 replay always available without penalty; exit criterion runs silently, no visible score. |
| S09 | Session close | Two-star state on the mission card; three close prompts as gentle flip cards; next-time icon row; session length shown honestly ("≈ 18 min"); return path saves to S08 if the clinic was skipped at pause. |

All screens: WCAG-AA contrast on cream, ≥44 pt targets, no color-only meaning (every state change pairs an icon or label), alt text on every asset, save state at every screen boundary, English-only UI chrome with icon support for any glue word.

---

## Self-check (authoring session 12)

**Counts vs manifest** — recap recall 3/3 (RC001–003) · retrieval 8/8 (RT001–008; part 1 of 16) · clinic 8/8 (CL1-001 model + 002–008) · audio 25/25 (AUD001–AUD025, one challenge pair for the clinic model) · illustration briefs 5/5 (ILL001–005; block now 5/16 used) · screens 9/9 (S01–S09). No new ledger rows — verified: lesson introduces zero vocabulary/grammar records. ✓

**Truncation scan** — 0 `TBD`/`TODO`; 0 continuation markers; every yaml block closed. ✓

**Answer-key balance audit** (16 three-option items, letters as written): A = RC002, RT002, RT004, RT006, CL1-004 (5) · B = RC001, RT001, RT005, CL1-002, CL1-006, CL1-008 (6) · C = RC003, RT003, RT007, CL1-003, CL1-005 (5). **5/6/5** — no positional skew. RT008 (recording) and CL1-007 (tile order) carry no letter. ✓

**Instruction-lexicon stage audit** — words used: listen · look · tap · choose (S06 set intro) · say · repeat · put in order · read · record · play · check · first · next · last · one · two · again · correct · try again. All within stages 1–4 (fully active by Ch4). "sort" not used. "record" legal since C3-L2 and icon-cued in RT008. ✓

**Red-team pass (in-session fixes recorded)** — (1) RC002 carried a draft correction block: removed, stimulus set cleanly to AUD003; (2) the clinic intro contained a self-correcting aside ("We're helpers — no, We're friends"): rewritten clean; (3) audio numbering drifted during drafting (a/b take names inside one ID): renumbered to the chapter-continuous AUD001–025 block with the clinic challenge take as its own ID (AUD016), matching the two-takes-two-IDs convention.

**Lens spot-checks** — L1 dependencies: every item cites only taught targets (Ch1–Ch2 spans by design; three C3 country/job cites appear only inside canon lines and the clinic, all taught). L4 assessment: RC items marked diagnostic/unscored; clinic items unscored practice with a silent exit criterion. L9 sensitivity: no immigration/status language; origins appear only as canon cast facts; `Good night` absent (RT001 offers three daytime/dusk scenes, never night). L12 interaction: RT008 has skip + privacy paths; no typing anywhere. L13: verified above. L14: the three catches above; also checked and confirmed — no numbers above 20, no Alex-as-singular be item (CL1-003 uses Nina), no invented country pairs (CL1-004 asserts only the canon Maya–Sam friendship), all three contact cards canon.

**Open items carried to L2** — retrieval part 2 (RT009–016, Ch3 spans) · clinic 2 (from-vs-a/an) · D01 integrated listening (Amara's first lines — bible-registered, speaks in L2) · RD/WR/CV blocks · AUD026+ continue the chapter block · ILL006–011.

