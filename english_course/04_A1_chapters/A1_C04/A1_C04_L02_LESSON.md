# A1 — Chapter 4 — Lesson 2 (A1-C04-L02) — The Welcome Morning: Sounds, Forms, and Frames

```yaml
lesson_id: A1-C04-L02
lesson_type: R                       # review lesson: retrieval part 2 + clinic 2 + integration
chapter: 4
title: "Checkpoint Review 1: Welcome-Day Mission — Part 2: The Welcome Morning"
estimated_minutes: 20                # pause point after the retrieval block (≈ minute 9)
prerequisites:
  chapters: [1, 2, 3]
  verified_against: "LEXICAL_LEDGER.csv (86 taught rows) · GRAMMAR_LEDGER.csv (G001–G009
    taught) · A1_C04_MANIFEST.md rulings · A1_C04_L01_HANDOFF.md · bible newcomers table
    (Amara/Rafael registered before first lines)"
artifacts_manifest:
  retrieval_items: 8                 # A1-C04-RT009–016 (Ch3 spans)
  clinic_items: 8                    # A1-C04-CL2-001–008 (clinic 2: from vs a/an)
  conversation_package: 1            # A1-C04-D01 — integrated listening, 2 takes (learning + challenge)
  listening_items: 6                 # A1-C04-L02-LS001–006 (gist 2 · detail 2 · speaker 1 · transfer 1)
  reading_items: 6                   # A1-C04-L02-RD001–006 (2 text types: sign-in sheet + profile card)
  guided_writing_items: 4            # A1-C04-L02-WR001–004 (tiles; WR001 = the three-sentence introduction)
  conversation_prep_items: 6         # A1-C04-L02-CV001–006 (rehearsal before the L3 roleplay)
  audio_scripts: 17                  # A1-C04-AUD026…AUD042
  illustration_briefs: 6             # A1-C04-ILL006…ILL011 (block 11/16 after this lesson)
  screens: 10                        # A1-C04-S10…S19
macro_definitions_for_F3:
  STYLE: >-
    Original modern editorial illustration, organic shapes, clean line work, restrained
    texture, generous negative space, cream background, warm orange and terracotta accents,
    soft brown lines, charcoal detail, one muted green and one muted blue as secondary
    support, WCAG-AA contrast, readable at small size
  NEG: >-
    photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D,
    stereotypes, distorted hands, duplicate objects, flags, national symbols
rulings_recorded_for_lens_3:
  - "Still zero new targets. RT part 2 retrieves Ch3 spans; D01 integrates Ch1+Ch2+Ch3 in
    one scene. 'I speak … and …' appears in Amara's profile card as taught-frame
    recombination (manifest ruling 1), never as a tested new frame."
  - "Amara's first spoken lines are D01 (learning take) and CV004/005 — after her bible
    registration (C4-L1 session) and known-facts registration (this session, before use)."
  - "Cast lines stay canon: no cast member states a non-canon origin or job. CL2-002 uses
    Kenji ('I'm from Japan.'); RT009 uses Sam ('I'm from Mexico.') — both canon."
  - "RT014 samples the clinic-2 confusion (from vs a/an) before the clinic runs — a
    deliberate diagnostic probe, documented here for lens 4."
  - "LS001–006 form one testlet on D01 (practice, not quiz) — dependence declared; the
    checkpoint's three recordings in L3 do NOT share stimuli with D01."
  - "Be-agreement discipline continues: no item makes Alex a singular be-referent; plural
    they only with named pairs."
instruction_lexicon_note: >-
  Stages 1–4 active. Words used this lesson: listen · look · tap · choose · match · say ·
  repeat · put in order · first · next · last · one · two · again · correct · try again ·
  read · answer · check · play. "record" is not needed this lesson (RT008 was L1). "sort"
  is never used as a word.
scene_glue_note: >-
  Glue words this lesson (receptive, illustrated, never tested): morning, welcome
  (interjection), sheet, card, new (as in "a new neighbor"), door. Amara is now in-scene
  from S14 onward; Rafael does NOT appear this lesson (he arrives at the door in L3).
```

---

## The morning arrives (S10 — story)

Sun on the Community House floor. The badge table is ready; Alex pins the poster straight, one last tap. Your badge is on the table — first one. **AUD026** opens the lesson:

```text
GUIDE: (warm) It is morning. … The Community House is open! …
You and Alex — badges, table, poster. … Ready?
ALEX: (bright) Okay! … You're my friend, and today — you're the badge… helper!
(warm) Hmm — today: you say hello. New people! New names!
```

`helper` is spoken glue (Alex points at the badge in the art); the tested language is everything around it.

**Today's plan, in icons (S10 footer):** 🌍 country words → 🚪 two doors (*from* vs *a/an*) → 🎧 one long listen → 📄 a sheet and a card → 🗣️ your three lines → 🤝 rehearsal. Mission card step 1 (👋 *Say hello*) earns its star today.

---

## §1 Cumulative retrieval — part 2: Chapter 3 (S11–S12)

Eight items, faster and more mixed than Chapter 3 ever asked: countries back-to-back with jobs, possessives back-to-back with the *I'm …* frames — exactly how the welcome morning will fire them at you.

### RT009 — country audio → map card

```yaml
id: A1-C04-RT009
type: audio_to_map
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD027
prompt_text: "Tap the country."
target_ids: [A1-C03-L01-V008, A1-C03-L01-V033]
options:                              # reuses the C3 map-card art family (A1-C03-ILL002…012)
  - {id: A, asset: "Mexico map card"}
  - {id: B, asset: "Brazil map card"}
  - {id: C, asset: "Spain map card"}
correct_option_ids: [A]
rationale: "Sam is from Mexico (bible); 'I'm from Mexico' + the map shape of Mexico (V008, V033)."
feedback_correct: "Yes — Mexico. Sam's country."
feedback_incorrect: "Listen: 'Mexico.' Find the map card for Mexico."
help_ladder: "rung 1 replay → rung 2 two map cards dim → rung 3 answer with explanation."
```

**AUD027** — `rt009_origin` · Sam · learning_slow_clear

```text
SAM: (cheerful) Hi! I'm Sam. I'm from Mexico.
```

### RT010 — languages detail

```yaml
id: A1-C04-RT010
type: listening_detail_three_option
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD028
prompt_text: "Alex speaks:"
target_ids: [A1-C03-L01-V030, A1-C03-L01-V005, A1-C03-L01-V006]
options:
  - {id: A, label: "English and Spanish"}
  - {id: B, label: "English and Arabic"}
  - {id: C, label: "English and French"}
correct_option_ids: [C]
rationale: "Alex is from Canada and speaks English and French (bible cast-origins table); the named referent licenses 'They speak …' (V030)."
feedback_correct: "Yes — English and French."
feedback_incorrect: "Alex: English… and French."
help_ladder: "rung 1 replay → rung 2 the two language chips glow as they are heard → rung 3 answer with explanation."
```

**AUD028** — `rt010_languages` · Nina · learning_slow_clear

```text
NINA: (patient) Alex is from Canada. … They speak English and French.
```

### RT011 — job image ↔ word

```yaml
id: A1-C04-RT011
type: image_word_match
instruction_words: [look, match, tap]
stimulus_visual: "Leo in the café kitchen — blue apron, pots, a pan (A1-CHAR-ILL001 crop + café props)"
prompt_text: "Leo is a:"
target_ids: [A1-C03-L01-V024, A1-C03-L01-V035, A1-C03-L01-V036]
options:
  - {id: A, label: nurse}
  - {id: B, label: cook}
  - {id: C, label: driver}
correct_option_ids: [B]
rationale: "Leo is the cook in the café kitchen (bible job); image↔word retrieval of the jobs set."
feedback_correct: "Yes — Leo is a cook."
feedback_incorrect: "Pots, a pan, the kitchen — a cook!"
help_ladder: "rung 1 props highlight one by one → rung 2 two labels dim → rung 3 answer with explanation."
```

### RT012 — "Where is Nina from?"

```yaml
id: A1-C04-RT012
type: form_choice
instruction_words: [read, tap]          # speaker icon replays the canon line
speaker_icon_replay: A1-C03-L01-AUD001 excerpt ("Nina — Peru.")
stimulus_text: "Where is Nina from? — She's from ___."
target_ids: [A1-C03-L01-V034, A1-C03-L01-V033, A1-C03-L02-G007]
options:
  - {id: A, label: Peru}
  - {id: B, label: Egypt}
  - {id: C, label: Kenya}
correct_option_ids: [A]
rationale: "Nina is from Peru (bible); the taught question chunk (V034) takes the country in the taught answer frame (V033 + G007 she's)."
feedback_correct: "Yes — Nina is from Peru. She's from Peru."
feedback_incorrect: "Nina's dot is on Peru."
help_ladder: "rung 1 replay canon line → rung 2 map dots appear under the options → rung 3 answer with explanation."
```

### RT013 — her email

```yaml
id: A1-C04-RT013
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Nina — ___ email address: nina.petrova@aroa.com"
target_ids: [A1-C03-L02-G008, A1-C02-L02-V013]
options:
  - {id: A, label: his}
  - {id: B, label: her}
  - {id: C, label: their}
correct_option_ids: [B]
rationale: "Nina = one person, she → her (G008 possessives with named referent)."
feedback_correct: "Yes — her email address."
feedback_incorrect: "Nina is she → her email address."
help_ladder: "rung 1 the she-chip glows → rung 2 his/her/their chips shown with icons (one man · one woman · two people) → rung 3 answer with explanation."
```

### RT014 — the frame probe (diagnostic for clinic 2)

```yaml
id: A1-C04-RT014
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Kenji is ___ engineer."
target_ids: [A1-C03-L01-V021, A1-C03-L01-V036, A1-C03-L02-G009]
options:
  - {id: A, label: a}
  - {id: B, label: from}
  - {id: C, label: an}
correct_option_ids: [C]
rationale: "Jobs take a/an by sound; engineer starts with a vowel sound → an. 'from' never introduces a job (that is clinic 2's confusion, probed here on purpose)."
feedback_correct: "Yes — Kenji is an engineer."
feedback_incorrect: "A job word takes an here: an engineer. 'From' is for countries."
help_ladder: "rung 1 the two doors of ILL010 preview → rung 2 the vowel tile glows → rung 3 answer with explanation."
design_note: "A miss here routes the learner into clinic 2 with the probe item flagged — the clinic is not skipped either way (lens 4: probe documented, not double-scored)."
```

### RT015 — "What do you do?" → the right frame

```yaml
id: A1-C04-RT015
type: best_next_turn
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD029
prompt_text: "You say:"
target_ids: [A1-C03-L01-V035, A1-C03-L01-V036, A1-C03-L01-V033]
options:
  - {id: A, label: "I'm from Spain."}
  - {id: B, label: "My name is Alex."}
  - {id: C, label: "I'm a teacher."}
correct_option_ids: [C]
rationale: "'What do you do?' asks the job (V035) — answer with the a/an job frame (V036); the two distractors answer different, taught questions (origin, name)."
feedback_correct: "Yes! 'I'm a teacher.'"
feedback_incorrect: "'What do you do?' — the job! 'I'm a teacher.'"
help_ladder: "rung 1 replay → rung 2 the three question chips (name? / from? / job?) flash → rung 3 answer with explanation."
```

**AUD029** — `rt015_jobquestion` · Alex · learning_slow_clear

```text
ALEX: (bright) And you — what do you do?
```

### RT016 — the introduction chain

```yaml
id: A1-C04-RT016
type: best_next_turn
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD030
prompt_text: "Alex says:"
target_ids: [A1-C01-L02-V027, A1-C03-L01-V029, A1-C03-L01-V031]
options:
  - {id: A, label: "Nice to meet you, Sam!"}
  - {id: B, label: "See you!"}
  - {id: C, label: "Good morning!"}
correct_option_ids: [A]
rationale: "After 'This is my friend Sam' the taught next line is the meeting formula (V027); the too-version (V031) comes when Sam says it back — LS006 retrieves that contrast."
feedback_correct: "Yes — 'Nice to meet you, Sam!'"
feedback_incorrect: "A new face! 'Nice to meet you!'"
help_ladder: "rung 1 replay → rung 2 the waving-hand icon from the C1 meeting scene glows → rung 3 answer with explanation."
```

**AUD030** — `rt016_introduce` · Maya · learning_slow_clear

```text
MAYA: (warm) Alex! … This is my friend Sam.
```

**Pause point (end of S12, ≈ minute 9).** Progress saves. The clinic waits; returning resumes exactly here.

---

## §2 Clinic 2 — "I'm from ___" vs "I'm a/an ___" (S13 · ILL010)

**One confusion:** the two doors of *I'm …*. Country? The **from** door. Job? The **a/an** door — and which article, by sound. This clinic absorbs C3-CLIN-C (*a* or *an*) and C3-CLIN-D (*from* vs *a*).

**Why it matters for the mission:** every introduction walks through both doors — *"I'm from Kenya." I'm an office worker."* — and mixing them ("I'm from an engineer") is the most common Arc-1 slip after *be* agreement.

### The model (CL2-001)

**AUD031** — `clinic2_model_learning` · Maya + Kenji · learning_slow_clear — and **AUD032** — `clinic2_model_challenge` · same content, fresh challenge take

```text
MAYA:  (warm)   I'm from Egypt. … I'm a nurse.
KENJI: (calm)   I'm from Japan. … I'm an engineer.
```

ILL010 shows the two doorways: the **country door** (a small map motif above it) and the **job door** (tool silhouettes above it). The words *from / a / an* stay in the app layer as chips. Two speakers, both doors, twice — minimal pairs by canon fact.

```yaml
id: A1-C04-CL2-001
type: clinic_model                 # perception model — no response required
instruction_words: [listen, look]
audio_asset_ids: [A1-C04-AUD031, A1-C04-AUD032]
visual_asset_id: A1-C04-ILL010
target_ids: [A1-C03-L01-V033, A1-C03-L01-V036, A1-C03-L02-G009]
presentation: "Doorways light in step with the four learning-take lines (reduced-motion:
  numbered halos); the challenge take plays once after, chips dark. One optional replay."
rationale: "Input before any ask: both frames heard from two canon speakers before the
  first choice item."
```

### CL2-002 — hear the door

```yaml
id: A1-C04-CL2-002
type: audio_to_category
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD033
prompt_text: "Tap: a country · a job · a phone number"
target_ids: [A1-C03-L01-V033, A1-C03-L01-V003]
options:
  - {id: A, asset: "country door (map motif)"}
  - {id: B, asset: "job door (tools motif)"}
  - {id: C, asset: "phone card motif"}
correct_option_ids: [A]
rationale: "'I'm from Japan' opens the country door — from + country (V033); jobs and phone numbers never follow 'from'."
feedback_correct: "Yes — from + a country."
feedback_incorrect: "'From' + a country. Japan!"
help_ladder: "rung 1 replay → rung 2 the country door glows → rung 3 answer with explanation."
```

**AUD033** — `cl2002_line` · Kenji · learning_slow_clear

```text
KENJI: (calm) I'm from Japan.
```

### CL2-003 — the country door only

```yaml
id: A1-C04-CL2-003
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Leo is from ___."
speaker_icon_replay: A1-C04-AUD022 (Leo: "I'm from Australia." — L1 clinic canon line)
target_ids: [A1-C03-L01-V011, A1-C03-L01-V033]
options:
  - {id: A, label: a cook}
  - {id: B, label: an engineer}
  - {id: C, label: Australia}
correct_option_ids: [C]
rationale: "After 'from' only a country fits; the two job options belong to the other door."
feedback_correct: "Yes — Leo is from Australia."
feedback_incorrect: "'From' + a country. Leo is from Australia."
help_ladder: "rung 1 replay Leo's canon line → rung 2 country door glows → rung 3 answer with explanation."
```

### CL2-004 — the job door: which article?

```yaml
id: A1-C04-CL2-004
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Maya is ___ nurse."
speaker_icon_replay: A1-C03-L03-AUD058 excerpt ("…an engineer." — Kenji, for contrast)
target_ids: [A1-C03-L02-G009, A1-C03-L01-V020, A1-C03-L01-V036]
options:
  - {id: A, label: an}
  - {id: B, label: a}
  - {id: C, label: from}
correct_option_ids: [B]
rationale: "Nurse starts with a consonant sound → a nurse (G009, by sound not spelling)."
feedback_correct: "Yes — Maya is a nurse."
feedback_incorrect: "Nurse — n is a consonant sound: a nurse."
help_ladder: "rung 1 the first sound tile glows → rung 2 the a/an chips pair with their door icons → rung 3 answer with explanation."
```

### CL2-005 — the job door again, vowel sound

```yaml
id: A1-C04-CL2-005
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Amara is ___ office worker."
speaker_icon_replay: A1-C04-AUD036 excerpt (D01 learning take — Maya's introducing line: "…an office worker.")
target_ids: [A1-C03-L02-G009, A1-C03-L01-V025, A1-C03-L01-V036]
options:
  - {id: A, label: an}
  - {id: B, label: a}
  - {id: C, label: from}
correct_option_ids: [A]
rationale: "Office starts with a vowel sound → an office worker; Amara's canon job (bible newcomers table)."
feedback_correct: "Yes — Amara is an office worker."
feedback_incorrect: "Office — o is a vowel sound: an office worker."
help_ladder: "rung 1 the first sound tile glows → rung 2 the an-chip pairs with the vowel icon → rung 3 answer with explanation."
```

### CL2-006 — rebuild the model line (tile order)

```yaml
id: A1-C04-CL2-006
type: tile_order
instruction_words: [listen, put in order]
stimulus_audio: A1-C03-L03-AUD058 excerpt ("I'm an engineer." — Kenji)
tiles: ["engineer", "I'm", "an"]
prompt_text: "Kenji says:"
target_ids: [A1-C03-L02-G009, A1-C03-L01-V036]
correct_order: ["I'm", "an", "engineer"]
rationale: "Rebuilds the canon line with the article before the job word — frame order I'm + a/an + job."
feedback_correct: "'I'm an engineer.' Kenji's line!"
feedback_incorrect: "First: I'm. Next: an. Last: the job — engineer."
help_ladder: "rung 1 replay with word highlights → rung 2 first tile locks as a worked example → rung 3 answer with explanation."
```

### CL2-007 — transfer: answer the origin question

```yaml
id: A1-C04-CL2-007
type: contextual_choice
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD034
prompt_text: "You say:"
target_ids: [A1-C03-L01-V032, A1-C03-L01-V033]
options:
  - {id: A, label: "I'm a Kenya."}
  - {id: B, label: "I'm from Kenya."}
  - {id: C, label: "I'm an Kenya."}
correct_option_ids: [B]
rationale: "'Where are you from?' takes from + country; both distractors push a job article onto a country — the exact confusion, both error forms."
feedback_correct: "Yes — 'I'm from Kenya.'"
feedback_incorrect: "A country! 'I'm from Kenya.'"
help_ladder: "rung 1 replay → rung 2 country door glows → rung 3 answer with explanation."
```

**AUD034** — `cl2007_question` · Nina · learning_slow_clear

```text
NINA: (clear, friendly) Where are you from?
```

### CL2-008 — transfer: answer the job question

```yaml
id: A1-C04-CL2-008
type: contextual_choice
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD035
prompt_text: "You say:"
target_ids: [A1-C03-L01-V035, A1-C03-L01-V036, A1-C03-L02-G009]
options:
  - {id: A, label: "I'm an driver."}
  - {id: B, label: "I'm from a driver."}
  - {id: C, label: "I'm a driver."}
correct_option_ids: [C]
rationale: "'What do you do?' takes a/an + job; driver starts with a consonant → a driver. The distractors are the two classic error forms."
feedback_correct: "Yes — 'I'm a driver.'"
feedback_incorrect: "A job, with a: 'I'm a driver.'"
help_ladder: "rung 1 replay → rung 2 job door + consonant tile glow → rung 3 answer with explanation."
```

**AUD035** — `cl2008_question` · Nina · learning_slow_clear

```text
NINA: (clear, friendly) And you — what do you do?
```

### Clinic 2 — exit and routing

```yaml
clinic_exit:
  criterion: "6 of 7 interactive items (CL2-002…008) correct with no help above rung 2."
  on_exit: "Mission card step 1 earns its star; the integrated listening starts."
  on_stay: "Parallel clinic items return tomorrow (app-generated from the same two doors,
    canon referents only); Checkpoint 1 always re-samples this confusion (A1-CP1-G block)."
  duration_target: "5–8 minutes — model once (plus one optional replay); items are one tap each."
```

---

## §3 The integrated listening — A1-C04-D01: Amara checks in (S14–S16 · ILL006/007)

The door opens. A new neighbor walks in. You are at the badge table; Nina waves her to the desk. **Listen once, all the way through** — this is one real welcome-morning minute, not word-by-word practice.

**AUD036** — `d01_learning` · full scene · learning_slow_clear (~38 s)

```text
NINA:  (clear) Good morning! Welcome!
AMARA: (warm-bright) Hi! My name is Amara Otieno.
NINA:  Amara… how do you spell that?
AMARA: A-M-A-R-A.
NINA:  A-M-A-R-A. … Thank you! Your phone number, please?
AMARA: 5-5-5… 3-1-9.
NINA:  Great! And your email address?
AMARA: amara.otieno@aroa.com.
NINA:  Thank you, Amara!
ALEX:  (arriving, bright) Hi! I'm Alex. Nice to meet you, Amara!
AMARA: Nice to meet you too!
MAYA: (warm) Amara! This is my friend Sam. Sam — this is Amara.
SAM:   (cheerful) Hi, Amara! Nice to meet you!
AMARA: Nice to meet you too!
```

**AUD037** — `d01_challenge` · same scene, fresh challenge take (~30 s, connected, fewer pauses — a new recording, never a sped-up edit)

```text
NINA:  Good morning! Welcome! Hi — your name, please?
AMARA: Amara Otieno.
NINA:  How do you spell that?
AMARA: A-M-A-R-A.
NINA:  Thanks! Phone number?
AMARA: 5-5-5, 3-1-9.
NINA:  Email address?
AMARA: amara.otieno@aroa.com.
NINA:  Great — thank you, Amara!
ALEX:  Hi! I'm Alex — nice to meet you!
MAYA:  Amara, this is my friend Sam!
SAM:   Hi Amara — nice to meet you!
AMARA: Nice to meet you too!
```

```yaml
id: A1-C04-D01
type: conversation_package_integrated
duration_learning: "≈38 s (13 turns)"
duration_challenge: "≈30 s (fresh recording, reduced support)"
setting: "Community House check-in desk, welcome morning (ILL006 learning / ILL007 challenge)"
characters: [Nina, Amara, Alex, Maya, Sam]
target_to_turn_map:
  greeting_chunk:        "N1 (Good morning! Welcome!) — V003"
  name_frame:            "A1/N2 (My name is Amara Otieno.) — V024"
  spelling_repair:       "N3/A3/N4 (how do you spell that? / A-M-A-R-A) — C2-V007, PAT001"
  digits_detail:         "N5/A5 (5-5-5, 3-1-9) — PAT002–005"
  email_detail:          "N6/A6 (amara.otieno@aroa.com) — C2-V012/V018"
  meeting_formula:       "A7/A8 (Nice to meet you / too) — V027, C3-V031"
  introduction_chunk:    "M9 (This is my friend Sam.) — C3-V029"
prerequisite_ids: [A1-C01-L01-V003, A1-C01-L02-V024, A1-C02-L01-V007, A1-C02-L02-PAT002,
  A1-C02-L02-PAT003, A1-C02-L02-V012, A1-C01-L02-V027, A1-C03-L01-V031, A1-C03-L01-V029]
transcript_release: "after each LS item's response (§10.7); one default replay permitted, logged, never penalized"
qa_status: script_review
```

### The listening ladder (LS001–006 — one testlet on D01, declared for lens 4)

**First listen — gist (S14, learning take):**

```yaml
id: A1-C04-L02-LS001
type: listening_gist
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD036
prompt_text: "Who checks in?"
target_ids: [A1-C03-L01-V027, A1-C01-L02-V024]
options:
  - {id: A, label: Amara}
  - {id: B, label: Maya}
  - {id: C, label: Alex}
correct_option_ids: [A]
rationale: "Amara gives name, spelling, digits, email at the desk — the check-in is hers."
feedback_correct: "Yes — Amara checks in."
feedback_incorrect: "The new name at the desk: Amara."
help_ladder: "rung 1 replay from A1's line → rung 2 the desk scene narrows to Amara → rung 3 answer with explanation."

id: A1-C04-L02-LS002
type: listening_gist
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD036
prompt_text: "Where are they?"
target_ids: [A1-C02-L02-V010, A1-C03-L01-V002]
options:
  - {id: A, label: "the café"}
  - {id: B, label: "the check-in desk"}
  - {id: C, label: "the park"}
correct_option_ids: [B]
rationale: "Register, badges, Nina's desk — the welcome-morning check-in (setting integrated from scene + audio)."
feedback_correct: "Yes — the check-in desk."
feedback_incorrect: "A desk, a register, badges — the check-in desk."
help_ladder: "rung 1 replay the opening line → rung 2 ILL006 narrows to the desk → rung 3 answer with explanation."
```

**Second listen — detail (S15, challenge take):**

```yaml
id: A1-C04-L02-LS003
type: listening_detail
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD037          # challenge take — detail at welcome-morning speed
prompt_text: "Amara's phone number:"
target_ids: [A1-C02-L02-PAT002, A1-C02-L02-PAT003, A1-C02-L02-V010]
options:
  - {id: A, label: "5-5-5 · 3-5-9"}
  - {id: B, label: "5-5-5 · 2-0-1"}
  - {id: C, label: "5-5-5 · 3-1-9"}
correct_option_ids: [C]
rationale: "Five-five-five, three-one-nine — the digit-group detail at speed (bible newcomers table)."
feedback_correct: "Yes — 5-5-5, 3-1-9."
feedback_incorrect: "Listen for the last group: three… one… nine."
help_ladder: "rung 1 replay with digit captions → rung 2 digit tiles appear in heard groups → rung 3 answer with explanation."

id: A1-C04-L02-LS004
type: listening_detail
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD037
prompt_text: "Tap the name."
target_ids: [A1-C02-L01-PAT001, A1-C02-L01-V007]
options:
  - {id: A, label: AMARA}
  - {id: B, label: AMRA}
  - {id: C, label: AMARIA}
correct_option_ids: [A]
rationale: "A-M-A-R-A — five letters, heard twice in the scene; the distractors drop or add a letter."
feedback_correct: "A-M-A-R-A. Amara!"
feedback_incorrect: "Listen: A… M… A… R… A."
help_ladder: "rung 1 replay the spelling turn with letter captions → rung 2 letter tiles A _ A R _ revealed → rung 3 answer with explanation."
```

**Third pass — speaker and transfer (S16, learner's choice of take):**

```yaml
id: A1-C04-L02-LS005
type: listening_speaker
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD036
prompt_text: "Who says: 'This is my friend Sam.'?"
target_ids: [A1-C03-L01-V029, A1-C03-L01-V026]
options:
  - {id: A, label: Nina}
  - {id: B, label: Maya}
  - {id: C, label: Amara}
correct_option_ids: [B]
rationale: "Maya owns the introduction chunk — her canon friendship with Sam (bible) and her voice (warm, medium, calm)."
feedback_correct: "Yes — Maya. It is her friend Sam."
feedback_incorrect: "The warm voice in the middle: Maya."
help_ladder: "rung 1 replay from the line → rung 2 the three speaker chips with portraits appear → rung 3 answer with explanation."

id: A1-C04-L02-LS006
type: listening_transfer
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD036
prompt_text: "Amara says:"
target_ids: [A1-C03-L01-V031, A1-C01-L02-V027]
options:
  - {id: A, label: "Nice to meet you."}
  - {id: B, label: "My name is Amara."}
  - {id: C, label: "Nice to meet you too."}
correct_option_ids: [C]
rationale: "Amara is the second speaker of the formula in both meetings → the too-version (V031); the transfer is pragmatic: answering a greeting-formula, not repeating it."
feedback_correct: "Yes — 'Nice to meet you too!'"
feedback_incorrect: "Sam says it first — Amara answers: 'Nice to meet you too!'"
help_ladder: "rung 1 replay the closing exchange → rung 2 the too-chip glows on Amara's line → rung 3 answer with explanation."

testlet_note: "LS001–006 share D01 as stimulus (declared; practice, not quiz). Items are answerable
  from separate turns — no item's answer is another item's content. The L3 checkpoint listens
  to three fresh recordings, none of them D01."
```

---

## §4 Reading — the sheet and the card (S17–S18 · ILL008/009)

### Text 1 — the day's sign-in sheet (C2 genre returns, now with real morning data)

The sheet hangs by the badge table. Four rows, three columns — name · digits · message (app-rendered on the ILL008 paper art; this is the register-page genre from C2-L2):

| Name | Phone | Email |
|---|---|---|
| Maya Haddad | 5-5-5 · 2-0-1 | maya.haddad@aroa.com |
| Leo Novak | 6-2-0 · 1-5-4 | leo.novak@aroa.com |
| Nina Petrova | 5-5-5 · 2-0-9 | nina.petrova@aroa.com |
| Amara Otieno | 5-5-5 · 3-1-9 | amara.otieno@aroa.com |

```yaml
id: A1-C04-L02-RD001
type: form_scan_detail
instruction_words: [read, tap]
stimulus_visual: "sign-in sheet (above)"
prompt_text: "Leo's phone number:"
target_ids: [A1-C02-L02-PAT002, A1-C02-L02-PAT003, A1-C02-L02-V010]
options:
  - {id: A, label: "6-2-0 · 1-5-4"}
  - {id: B, label: "5-5-5 · 2-0-1"}
  - {id: C, label: "6-2-0 · 1-4-5"}
correct_option_ids: [A]
rationale: "Row scan: Leo Novak → 6-2-0, 1-5-4 (canon)."
feedback_correct: "Yes — 6-2-0, 1-5-4."
feedback_incorrect: "Find the Leo row. Read the digits: 6-2-0, 1-5-4."
help_ladder: "rung 1 the Leo row highlights → rung 2 the digit cell pulses → rung 3 answer with explanation."

id: A1-C04-L02-RD002
type: form_scan_detail
instruction_words: [read, tap]
stimulus_visual: "sign-in sheet (above)"
prompt_text: "leo.novak@aroa.com — who?"
target_ids: [A1-C02-L02-V012, A1-C02-L02-V018, A1-C01-L02-V023]
options:
  - {id: A, label: Nina}
  - {id: B, label: Amara}
  - {id: C, label: Leo}
correct_option_ids: [C]
rationale: "Email-to-name row scan (the reverse direction of the C2 message-card task)."
feedback_correct: "Yes — Leo. His email."
feedback_incorrect: "Scan the email column down: Leo."
help_ladder: "rung 1 the email column highlights → rung 2 the Leo row pulses → rung 3 answer with explanation."

id: A1-C04-L02-RD003
type: form_scan_detail
instruction_words: [read, tap]
stimulus_visual: "sign-in sheet (above)"
prompt_text: "Amara's email address:"
target_ids: [A1-C02-L02-V012, A1-C02-L02-V018, A1-C02-L02-V015]
options:
  - {id: A, label: "amara.otieno@aroa.com"}
  - {id: B, label: "amara.haddad@aroa.com"}
  - {id: C, label: "maya.otieno@aroa.com"}
correct_option_ids: [A]
rationale: "Row + column cross: the new row's message cell; distractors swap real first/last names from the sheet."
feedback_correct: "Yes — amara.otieno@aroa.com."
feedback_incorrect: "Amara's row: amara.otieno@…"
help_ladder: "rung 1 the Amara row highlights → rung 2 the email cell pulses → rung 3 answer with explanation."
```

### Text 2 — Amara's profile card (C3 genre returns)

The card on the notice board next to the map wall (ILL009 art; app-rendered lines):

> **AMARA OTIENO**
> I'm Amara. I'm from Kenya.
> I speak Swahili and English.
> I'm an office worker.

```yaml
id: A1-C04-L02-RD004
type: profile_comprehension
instruction_words: [read, tap]
stimulus_visual: "profile card (above)"
prompt_text: "Amara is from:"
target_ids: [A1-C03-L01-V014, A1-C03-L01-V033]
options:
  - {id: A, label: Egypt}
  - {id: B, label: Kenya}
  - {id: C, label: Japan}
correct_option_ids: [B]
rationale: "Line 2 of the card — the from frame with Kenya."
feedback_correct: "Yes — Kenya."
feedback_incorrect: "Read line two: 'I'm from Kenya.'"
help_ladder: "rung 1 the from line highlights → rung 2 the country chips narrow → rung 3 answer with explanation."

id: A1-C04-L02-RD005
type: profile_comprehension
instruction_words: [read, tap]
stimulus_visual: "profile card (above)"
prompt_text: "Amara is:"
target_ids: [A1-C03-L01-V025, A1-C03-L01-V036, A1-C03-L02-G009]
options:
  - {id: A, label: "a nurse"}
  - {id: B, label: "a driver"}
  - {id: C, label: "an office worker"}
correct_option_ids: [C]
rationale: "Line 4 — the a/an job frame; an before the vowel sound of office."
feedback_correct: "Yes — an office worker."
feedback_incorrect: "Read line four: 'I'm an office worker.'"
help_ladder: "rung 1 the job line highlights → rung 2 the two doors preview from clinic 2 → rung 3 answer with explanation."

id: A1-C04-L02-RD006
type: profile_comprehension
instruction_words: [read, tap]
stimulus_visual: "profile card (above)"
prompt_text: "Amara speaks:"
target_ids: [A1-C03-L01-V030, A1-C03-L01-V006]
options:
  - {id: A, label: "Spanish and English"}
  - {id: B, label: "Swahili and English"}
  - {id: C, label: "English and French"}
correct_option_ids: [B]
rationale: "Line 3 — the languages frame; Kenya's languages as stored in the C3 country record (recognition level)."
feedback_correct: "Yes — Swahili and English."
feedback_incorrect: "Read line three: 'I speak Swahili and English.'"
help_ladder: "rung 1 the speak line highlights → rung 2 the language chips narrow → rung 3 answer with explanation."
```

---

## §5 Guided writing — your three lines (S19 · ILL011)

Tiles only — no typing, ever. Everything you build is what you will say at the door in Lesson 3.

### WR001 — the greeter's three-sentence introduction (the §9.4 core task)

```yaml
id: A1-C04-L02-WR001
type: tile_introduction               # three sentences, three slots, tap-built
instruction_words: [tap, put in order, check]
target_ids: [A1-C01-L02-V024, A1-C03-L01-V033, A1-C03-L01-V036, A1-C03-L02-G009]
slots:
  - slot: 1                           # NAME
    frame: "My name is ___."
    bank: [fictional-name bank from C3-L3 WR006 — six safe names]
    correct: any                       # the learner's safe fictional choice
  - slot: 2                           # FROM
    frame: "I'm from ___."
    bank: [Canada, Mexico, Peru, Egypt, Australia, Brazil, Japan, Kenya, Spain, India]
    correct: any                       # the ten taught countries; plus a skip chip ("Not today")
  - slot: 3                           # JOB
    frame: "I'm a/an ___."
    bank: [student, teacher, doctor, nurse, engineer, designer, driver, cook, office worker]
    article_handling: "The app supplies a/an automatically after the job tap — the learner
      sees 'I'm an engineer.' build correctly; the article choice itself was clinic 2."
skip_path: "Any slot may be skipped ('Not today'); the sentence closes without it and
  nothing is asserted about the learner. A full skip still completes the task (badge art
  shows three empty speech lines — ready, not wrong)."
self_check_step: "check → the three sentences play as one audio line (app-assembled from
  cast models); the learner taps 'Sounds good!' or 'Again, please.'"
rationale: "This is the exact introduction the L3 roleplay and Checkpoint 1 tile task reuse
  — built once, rehearsed, then performed."
```

### WR002 — introduce Amara (the friend chain)

```yaml
id: A1-C04-L02-WR002
type: tile_order_and_select
instruction_words: [tap, put in order, check]
prompt_text: "Amara — three lines:"
target_ids: [A1-C03-L01-V029, A1-C03-L02-G007, A1-C03-L01-V033, A1-C03-L01-V036]
correct_sentences:
  - ["This is my friend Amara."]
  - ["She's from Kenya."]
  - ["She's an office worker."]
tile_bank:                           # distractor tiles carry the two classic slips
  - "This is my friend Amara."
  - "He's from Kenya."               # pronoun slip
  - "She's from Kenya."
  - "She's a office worker."         # article slip
  - "She's an office worker."
correct_tiles: ["This is my friend Amara.", "She's from Kenya.", "She's an office worker."]
rationale: "Selection + order: the introduction chain with gender-pronoun and article traps
  inside the bank — retrieval of G007/G008/G009 in one product."
feedback_correct: "'This is my friend Amara. She's from Kenya. She's an office worker.'"
feedback_incorrect: "Listen for the she-tiles — Amara is she. And the office tile takes an."
help_ladder: "rung 1 the three target tiles glow → rung 2 the he-tile crosses out softly → rung 3 worked example builds sentence one."
```

### WR003 — the badge-line order

```yaml
id: A1-C04-L02-WR003
type: tile_order
instruction_words: [put in order]
prompt_text: "Amara at the door — four lines:"
tiles: ["Nice to meet you!", "Good morning!", "I'm from Kenya.", "My name is Amara."]
correct_order: ["Good morning!", "My name is Amara.", "I'm from Kenya.", "Nice to meet you!"]
target_ids: [A1-C01-L01-V003, A1-C01-L02-V024, A1-C03-L01-V033, A1-C01-L02-V027]
rationale: "The natural greeting sequence: greeting → name → from → meeting formula (the
  mission's opening arc in four lines)."
feedback_correct: "'Good morning! My name is Amara. I'm from Kenya. Nice to meet you!'"
feedback_incorrect: "First: the greeting. Next: the name. Then: from. Last: nice to meet you."
help_ladder: "rung 1 first tile locks as a worked example → rung 2 the four line-type icons (sun · name card · map · handshake) hint the order → rung 3 answer with explanation."
```

### WR004 — finish the new row

```yaml
id: A1-C04-L02-WR004
type: form_tile_fill
instruction_words: [tap, check]
prompt_text: "Amara's row:"
target_ids: [A1-C02-L01-PAT001, A1-C02-L02-PAT002, A1-C02-L02-PAT003, A1-C02-L02-V012]
subtasks:
  - cell: name
    bank: [AMARA, AMRAA, AMARRA]
    correct: AMARA
  - cell: digits
    bank: ["5-5-5 · 3-1-9", "5-5-5 · 9-3-1", "5-3-5 · 3-1-9"]
    correct: "5-5-5 · 3-1-9"
  - cell: email
    bank: ["amara.otieno@aroa.com", "otieno.amara@aroa.com", "amara@otieno.aroa.com"]
    correct: "amara.otieno@aroa.com"
rationale: "The check-in writing transfer: spelling, digit order, and email form — the
  D01 details rebuilt as the row Nina wrote."
feedback_correct: "The row is complete — Amara is in!"
feedback_incorrect: "Listen to the scene again: A-M-A-R-A · 5-5-5, 3-1-9 · amara.otieno@…"
help_ladder: "rung 1 D01 replay per cell → rung 2 one wrong tile per cell crosses out → rung 3 worked example fills the name cell."
```

---

## §6 Conversation rehearsal — before the door (S19 rehearsal strip)

Six cards, one flow: what the greeter says, asks, and repairs. This is the rehearsal for the L3 roleplay — no score, immediate feedback.

```yaml
id: A1-C04-L02-CV001
type: best_next_turn
instruction_words: [look, tap]
scene_visual: "ILL011 — a silhouette at the open door; your badge art in the corner"
prompt_text: "First, you say:"
target_ids: [A1-C01-L01-V003, A1-C01-L01-V001]
options:
  - {id: A, label: "Good morning!"}
  - {id: B, label: "See you!"}
  - {id: C, label: "I'm a teacher."}
correct_option_ids: [A]
rationale: "Opening a welcome-morning encounter: the time-of-day greeting first; the
  distractors close an encounter or answer an unasked question."
feedback_correct: "'Good morning!' — the door is open."
feedback_incorrect: "Start with a greeting: 'Good morning!'"
help_ladder: "rung 1 the sun icon glows → rung 2 the two wrong line-type icons dim → rung 3 answer with explanation."

id: A1-C04-L02-CV002
type: intent_icons
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD038
prompt_text: "Alex says: 'How do you spell that?' — Tap:"
target_ids: [A1-C02-L01-V007, A1-C02-L01-PAT001]
options:                              # icon chips, not sentences — intent retrieval
  - {id: A, asset: "digits chip (5-5-5)"}
  - {id: B, asset: "letters chip (A-B-C)"}
  - {id: C, asset: "job-tools chip (apron)"}
correct_option_ids: [B]
rationale: "The spelling question maps to the letters intent — taught chunk (C2-V007) met as meaning."
feedback_correct: "Yes — the name, letter by letter."
feedback_incorrect: "'How do you spell that?' — letters!"
help_ladder: "rung 1 replay → rung 2 the letters chip glows → rung 3 answer with explanation."
```

**AUD038** — `cv002_spell` · Alex · learning_slow_clear

```text
ALEX: (bright) Amara… how do you spell that?
```

```yaml
id: A1-C04-L02-CV003
type: turn_order
instruction_words: [put in order, first, next, last]
prompt_text: "Four lines — first to last:"
tiles:
  - "ALEX: What's your name?"
  - "AMARA: My name is Amara."
  - "ALEX: How do you spell that?"
  - "AMARA: A-M-A-R-A."
correct_order: ["ALEX: What's your name?", "AMARA: My name is Amara.", "ALEX: How do you spell that?", "AMARA: A-M-A-R-A."]
target_ids: [A1-C01-L02-V026, A1-C01-L02-V024, A1-C02-L01-V007, A1-C02-L01-PAT001]
rationale: "The check-in exchange in order — question, answer, repair, spelling (the exact
  sequence D01 modeled and the L3 roleplay runs)."
feedback_correct: "That is the check-in: name → spell → letters!"
feedback_incorrect: "First: the name question. Next: the name. Then: spell it. Last: the letters."
help_ladder: "rung 1 speaker portraits alternate (question/answer color) → rung 2 first tile locks → rung 3 answer with explanation."

id: A1-C04-L02-CV004
type: branch_choice
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD039
prompt_text: "Amara says: 'I'm from Kenya.' Next, you say:"
target_ids: [A1-C03-L01-V035, A1-C03-L01-V029]
options:
  - {id: A, label: "See you!"}
  - {id: B, label: "Nice to meet you, Kenya!"}
  - {id: C, label: "What do you do?"}
correct_option_ids: [C]
rationale: "The mission sequence: after origin comes the job question (V035) — the greeter
  keeps the exchange going; option B misfires the meeting formula at a country."
feedback_correct: "Yes — 'What do you do?' The next door."
feedback_incorrect: "The job question next: 'What do you do?'"
help_ladder: "rung 1 the two doors from clinic 2 preview → rung 2 the question chips (name? from? job?) flash → rung 3 answer with explanation."
```

**AUD039** — `cv004_origin` · Amara · learning_slow_clear

```text
AMARA: (warm-bright) I'm from Kenya.
```

```yaml
id: A1-C04-L02-CV005
type: repair_in_conversation
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD040          # challenge pace — by design
prompt_text: "Fast! You say:"
target_ids: [A1-C02-L01-V008]
options:
  - {id: A, label: "Good morning!"}
  - {id: B, label: "I'm from Kenya."}
  - {id: C, label: "Can you repeat that, please?"}
correct_option_ids: [C]
rationale: "The name came too fast — the taught repair (C2-V008) inside the conversation
  flow, at the moment it would really be needed."
feedback_correct: "'Can you repeat that, please?' — and Amara says it again, slowly."
feedback_incorrect: "Too fast? Ask: 'Can you repeat that, please?'"
help_ladder: "rung 1 replay at learning pace → rung 2 repair chip row (repeat · slow · spell) → rung 3 answer with explanation."

id: A1-C04-L02-CV006
type: branch_choice
instruction_words: [look, tap]
scene_visual: "ILL011 — three silhouettes: you, Sam, Amara"
prompt_text: "You say:"
target_ids: [A1-C03-L01-V029, A1-C03-L01-V026]
options:
  - {id: A, label: "See you!"}
  - {id: B, label: "Sam! This is my friend Amara."}
  - {id: C, label: "Nice to meet you, Sam!"}
correct_option_ids: [B]
rationale: "You are the introducer: the chunk is yours to say (V029); option C is Sam's
  line, not yours — a pragmatic trap, not a grammar one."
feedback_correct: "'Sam! This is my friend Amara.' — mission step three, rehearsed."
feedback_incorrect: "You introduce: 'This is my friend Amara.' Sam says the rest!"
help_ladder: "rung 1 the speech-bubble over your silhouette glows → rung 2 the introduce icon (two figures + arrow) appears → rung 3 answer with explanation."
```

---

## Session close (S19)

**AUD041** — `pause_encouragement` · guide · learning_slow_clear

```text
GUIDE: (warm) Good, good! … The morning is ready. … Break — or the rehearsal cards.
```

**AUD042** — `session_close` · guide + Alex · learning_slow_clear

```text
GUIDE: (warm) Lesson 2 is complete. … Three stars on your mission card!
ALEX: (bright) Next: the door, a new friend — and your Checkpoint! … See you!
```

Close prompts (guide-led, no bank items): *Say: "Good morning! My name is ___."* · *Match: Kenya → the map* · *Your three lines: play them back* (WR001's self-check replays). Next-time footer: 🚪 one friend at the door · 🎭 the mission roleplay · ⭐ Checkpoint 1.

---

## Encounter and review map (this lesson)

| Span | Targets retrieved | Where (cites) |
|---|---|---|
| C3 countries | V008 · V011 · V014 · V033 · V034 | RT009, RT012, CL2-002/003/007, WR001/003, RD004, CV004 |
| C3 languages | V005 · V006 · V030 | RT010, RD006, profile card line 3 |
| C3 jobs | V020 · V021 · V024 · V025 · V035 · V036 | RT011, RT015, CL2-003/004/005/006/008, WR001/002, RD005, CV004 |
| C3 people/introducing | V026 · V029 · V031 | RT016, LS005, WR002, CV006, D01 turns M9/A8 |
| C3 grammar | G007 · G008 · G009 | RT012/013, CL2-004/005/006, WR002 |
| C1 identity/greeting | V003 · V024 · V026 · V027 | RT015/016, LS001/006, WR001/003, CV001/003/006, D01 turns N1/A1 |
| C2 alphabet/numbers | PAT001–005 · V007 · V010 · V012 · V015 · V018 (C2) | LS003/004, RD001–003, WR004, CV002/003/005, D01 turns N3–N6 |
| C2 repair | V008 (C2) | CV005, D01 framing |

Every line of D01 maps to a prerequisite (target_to_turn_map above). This lesson is a second later-chapter retrieval for the Ch3 span (L1 touched C1/C2; Ch4 overall counts once per target — the ledger's `later_review_chapters: 4` entries fulfill through the chapter, not per lesson). Still zero new targets; no ledger rows changed.

---

## Audio index — A1-C04 block, L2 (17 scripts, AUD026–AUD042)

| ID | slug | voice | style | used by |
|---|---|---|---|---|
| AUD026 | lesson2_open | guide + Alex | learning_slow_clear | S10 |
| AUD027 | rt009_origin | Sam | learning_slow_clear | RT009 |
| AUD028 | rt010_languages | Nina | learning_slow_clear | RT010 |
| AUD029 | rt015_jobquestion | Alex | learning_slow_clear | RT015 |
| AUD030 | rt016_introduce | Maya | learning_slow_clear | RT016 |
| AUD031 | clinic2_model_learning | Maya + Kenji | learning_slow_clear | CL2-001 |
| AUD032 | clinic2_model_challenge | Maya + Kenji | challenge_natural_slow | CL2-001 |
| AUD033 | cl2002_line | Kenji | learning_slow_clear | CL2-002 |
| AUD034 | cl2007_question | Nina | learning_slow_clear | CL2-007 |
| AUD035 | cl2008_question | Nina | learning_slow_clear | CL2-008 |
| AUD036 | d01_learning | full scene (5 voices) | learning_slow_clear | D01, LS001/002/005/006 |
| AUD037 | d01_challenge | full scene (5 voices) | challenge_natural_slow | LS003/004 |
| AUD038 | cv002_spell | Alex | learning_slow_clear | CV002 |
| AUD039 | cv004_origin | Amara | learning_slow_clear | CV004 |
| AUD040 | cv005_fast_name | Amara | challenge_natural_slow | CV005 |
| AUD041 | pause_encouragement | guide | learning_slow_clear | S12 pause |
| AUD042 | session_close | guide + Alex | learning_slow_clear | S19 |

All records open at `qa_status: script_review`; transcripts release per §10.7. Two cast replays are cross-referenced rather than re-recorded: A1-C04-AUD022 (Leo, from L1) and A1-C03-L03-AUD058 (Kenji, from C3-L3) — canon lines, unchanged.

---

## Illustration briefs — A1-C04-ILL006–011 (block 11/16 after this lesson)

### ILL006 — D01 learning scene: Amara at the desk

```yaml
id: A1-C04-ILL006
purpose: "Integrated listening scene anchor (learning take)."
scene: "Nina at her check-in desk, register page open; Amara opposite her, canvas bag on
  the desk edge, mid-greeting; the badge table with Alex in the soft background right;
  morning light through the open door left."
composition: "Desk dialogue diagonal (Nina left, Amara right), background figures small and
  uncluttered; register page visible but illegible."
must_show: [Nina, Amara, desk, register page, open door light, background Alex]
must_not_show_extra: [legible writing, digits, logos, more than three figures]
continuity: "Nina model sheet + ILL002 desk (C4-L1); Amara per bible newcomers table
  (short braided hair, coral cardigan); Alex small in background, mustard sweater."
alt_text: "Nina sits at the check-in desk greeting Amara, who stands opposite with her bag
  on the desk; Alex is at the badge table in the background."
embedding_slot: "S14 hero, 3:2"
status: placeholder
generation_prompt: "{STYLE} — two women at a small check-in desk in a community hall, one
  seated with a register page, one standing with a canvas bag, morning light from an open
  door, a third person small at a badge table in the background. MUST_SHOW: desk dialogue,
  register page, open-door light, background figure. MUST_NOT_SHOW: {NEG}, handwriting,
  digits. ALT: A check-in desk greeting between two women, a third person in the background."
```

### ILL007 — D01 challenge variant: the hall at work

```yaml
id: A1-C04-ILL007
purpose: "Challenge-take scene — same moment, wider field, more to tune out."
scene: "The same hall moment from further back: Nina's desk front-left, Maya and Sam
  arriving mid-right with a wave, the map wall behind, two unnamed neighbor silhouettes
  deeper in the hall."
composition: "Wide establishing frame; the desk pair stays the visual anchor (bottom-left
  third); extra figures soft-focus, never competing."
must_show: [desk pair, Maya and Sam arriving, map wall behind, two soft silhouettes]
must_not_show_extra: [legible anything, more than six figures, clutter]
continuity: "Map wall now with six dots (ILL001, C4-L1); Maya green scrubs; Sam green
  t-shirt + blank badge."
alt_text: "A wider view of the hall: the check-in desk at front left, two friends arriving
  at right, the world-map wall behind, other neighbors deeper in the room."
embedding_slot: "S15 hero, 16:9"
status: placeholder
generation_prompt: "{STYLE} — a wide community-hall scene: a check-in desk pair at front
  left, two arriving figures waving at right, a world map with six orange dots on the back
  wall, two soft silhouettes deeper in the hall. MUST_SHOW: desk pair, map wall with six
  dots, arriving figures. MUST_NOT_SHOW: {NEG}, text, flags. ALT: A wide hall scene with a
  check-in desk, arriving friends, and a dotted world-map wall."
```

### ILL008 — the day's sign-in sheet

```yaml
id: A1-C04-ILL008
purpose: "Reading text 1 carrier — the register-page genre returns with real rows."
scene: "The sign-in sheet on a clipboard hanging by the badge table: a three-column paper
  grid (person icon · phone icon · envelope icon headers), four rows of illegible mark
  strokes, a terracotta pencil on the clip."
composition: "Paper fills the frame at a slight angle; row marks are soft scribble strokes
  — the real table renders in the app layer over this art."
must_show: [clipboard, three icon-headed columns, four row strokes, pencil]
must_not_show_extra: [legible names, digits, letters, logos]
continuity: "Same register genre as C2-L2 ILL024 (three icon-headed columns), now with a
  fourth row."
alt_text: "A clipboard sign-in sheet with three icon-headed columns and four filled rows."
embedding_slot: "S17 hero, 3:4 portrait"
status: placeholder
generation_prompt: "{STYLE} — a clipboard with a sign-in sheet: three columns headed by a
  person icon, a phone icon and an envelope icon, four rows of soft scribble marks, a
  pencil on the clip. MUST_SHOW: clipboard, three icon columns, four rows. MUST_NOT_SHOW:
  {NEG}, legible writing, digits. ALT: A clipboard sign-in sheet with icon-headed columns."
```

### ILL009 — Amara's profile card

```yaml
id: A1-C04-ILL009
purpose: "Reading text 2 carrier — the C3 profile-card genre returns."
scene: "A card pinned to the notice board beside the map wall: Amara's portrait (waist-up,
  warm smile, coral cardigan), four soft text-block lines suggested as strokes, one small
  map shape of Kenya as a corner motif."
composition: "Card front-facing, portrait upper half, line strokes lower half; the Kenya
  silhouette small bottom-right; pin and slight paper curl for warmth."
must_show: [Amara portrait, card frame, four line strokes, Kenya map motif]
must_not_show_extra: [legible text, letters, digits, flags]
continuity: "Amara per bible newcomers table; card genre from A1-C03-ILL031–033 (C3-L3
  profile cards)."
alt_text: "A pinned profile card with a portrait of Amara and four lines of suggested text."
embedding_slot: "S18 hero, 3:4 portrait"
status: placeholder
generation_prompt: "{STYLE} — a pinned profile card on a notice board: waist-up portrait of
  a woman with short braided hair and a coral cardigan smiling warmly, four soft text-block
  strokes below, a small country-map silhouette motif in the corner. MUST_SHOW: portrait,
  card, line strokes, map motif. MUST_NOT_SHOW: {NEG}, legible text, flags. ALT: A pinned
  profile card with a smiling portrait and suggested text lines."
```

### ILL010 — clinic 2: the two doorways

```yaml
id: A1-C04-ILL010
purpose: "Clinic 2 visual anchor — from vs a/an as two literal doors."
scene: "Two friendly doorways side by side on one wall: above the left door, a small world
  map motif; above the right door, tool silhouettes (a small pot, a stethoscope shape, a
  wrench shape). Both doors open onto warm light."
composition: "Symmetrical pair, flat front view, generous margin; doors glow softly one at
  a time during the clinic (reduced-motion: halo numbers)."
must_show: [two doorways, map motif above left, tools motif above right, warm light]
must_not_show_extra: [letters, words, arrows, the word from or a/an in art]
continuity: "Amber map motifs match ILL001's dot orange; tool shapes echo the jobs art of
  C3-L1."
alt_text: "Two open doorways side by side, one under a small map motif, one under tool
  silhouettes."
embedding_slot: "S13 persistent banner, 16:9"
status: placeholder
generation_prompt: "{STYLE} — two friendly open doorways side by side on a cream wall, a
  small world-map motif above the left door and simple tool silhouettes above the right
  door, warm light inside both. MUST_SHOW: two doorways, map motif, tools motif. MUST_NOT_SHOW:
  {NEG}, letters, words, arrows. ALT: Two open doorways, one marked by a map motif and one
  by tools."
```

### ILL011 — your badge, three speech lines

```yaml
id: A1-C04-ILL011
purpose: "Writing + rehearsal anchor — the greeter's three lines made visible."
scene: "A helper badge (blank rectangle on a red lanyard) resting on the badge table; from
  it, three empty speech-bubble outlines rise like steps — one with a sun icon tint, one
  with a name-card icon tint, one with a map icon tint. Door light behind."
composition: "Badge lower-left anchor, bubbles stepping up-right; icons are tints, never
  drawn content; the learner is never depicted."
must_show: [helper badge on lanyard, three empty speech bubbles, three icon tints, door light]
must_not_show_extra: [text in bubbles, a depicted learner, letters, numbers]
continuity: "Badge design from C1-L2 S12; bubble tints match the WR001 slot icons
  (greeting · name · from) in the app layer."
alt_text: "A blank helper badge on the table with three empty speech bubbles rising from
  it, each tinted with a small icon."
embedding_slot: "S19 hero, 3:2"
status: placeholder
generation_prompt: "{STYLE} — a blank name badge on a red lanyard resting on a table, three
  empty rounded speech-bubble outlines rising like steps from it, each softly tinted (sun,
  name-card, map), open-door light behind. MUST_SHOW: badge, three empty bubbles, icon
  tints. MUST_NOT_SHOW: {NEG}, text in bubbles, person. ALT: A blank badge with three empty
  speech bubbles rising from it."
```

---

## Screens and UI/UX implementation notes (S10–S19)

| Screen | Content | UI/UX tips |
|---|---|---|
| S10 | Story: the morning arrives | AUD026 with poster/badge animation (reduced-motion: static); lesson plan as icon row with today's star highlighted; save state. |
| S11 | Retrieval set 1 (RT009–012) | Map cards at ≥72 pt width for shape reading; audio items play before options (listening-first); canon line replays via speaker icon, never scored. |
| S12 | Retrieval set 2 (RT013–016) + pause | RT014 shows the two-door preview silently (foreshadows the clinic without teaching it); pause banner after RT016 with equal-weight buttons. |
| S13 | Clinic 2 (model + CL2-002…008) | ILL010 banner pinned; doors glow per item; a/an chips pair with sound icons (vowel/consonant), never spelling rules as text; exit criterion silent. |
| S14 | D01 first listen + gist | One full play first with the scene art only (no captions, no scrubber) — then LS001/002 as bottom cards; replay button appears only after first response. |
| S15 | D01 detail listen | Switch to the challenge take for LS003/004 (declared in item records); digit tiles group 3+3 visually; transcript still hidden. |
| S16 | D01 speaker + transfer | Speaker chips with portraits (A/B/C) at 56 pt; take selector (learning/challenge) for the third pass; transcript releases here for one read-through. |
| S17 | Reading: the sign-in sheet | Table renders in app layer over ILL008; row highlight follows the help ladder; column icons repeat from C2 (person · phone · envelope). |
| S18 | Reading: the profile card | Card lines reveal one by one on first read (paced); each RD item highlights its line on rung 1; Kenya motif tappable for the map-family recall. |
| S19 | WR001–004 + rehearsal strip + close | One goal per card in a vertical flow (three-line build → Amara chain → badge order → row fill → CV cards); WR001 slots each their own card with the skip chip always visible; close plays AUD042 and shows three stars. |

All screens: WCAG-AA on cream, ≥44 pt targets, no color-only meaning, alt text on every asset, save at every boundary, reduced-motion variants, English-only chrome with icon support for glue words.

---

## Self-check (authoring session 13)

**Counts vs manifest** — retrieval 8/8 (RT009–016; chapter now 16/16) · clinic 8/8 (CL2-001–008) · conversation package 1/1 (D01, two takes) · listening 6/6 (LS001–006: gist 2 · detail 2 · speaker 1 · transfer 1) · reading 6/6 (RD001–006: two text types — sign-in sheet + profile card) · writing 4/4 (WR001–004, WR001 = the three-sentence introduction) · conversation prep 6/6 (CV001–006) · audio 17/17 (AUD026–042) · illustration briefs 6/6 (ILL006–011; block 11/16) · screens 10/10 (S10–S19). Zero new ledger rows. ✓

**Truncation scan** — 0 `TBD`/`TODO`; 0 continuation markers; every yaml block closed. ✓

**Answer-key balance audit** (31 three-option items, letters as written): RT — A: RT009, RT012, RT016 (3) · B: RT011, RT013 (2) · C: RT010, RT014, RT015 (3). CL2 — A: CL2-002, CL2-005 (2) · B: CL2-004, CL2-007 (2) · C: CL2-003, CL2-008 (2). LS — A: LS001, LS004 (2) · B: LS002, LS005 (2) · C: LS003, LS006 (2). RD — A: RD001, RD003 (2) · B: RD004, RD006 (2) · C: RD002, RD005 (2). CV — A: CV001 (1) · B: CV002, CV006 (2) · C: CV004, CV005 (2). **Totals: A10 · B10 · C11** — no positional skew. Tile tasks (CL2-006, WR002–004, CV003) carry no letter. ✓

**Instruction-lexicon stage audit** — words used: listen · look · tap · choose · match · say (close prompts) · repeat (help rungs) · put in order · first · next · last · one · two · again · correct · try again · read · answer (not used — no items require it; declared available) · check (WR self-checks) · play (WR001 playback, close prompts). All stage-legal; "sort" unused; "record" unused this lesson. ✓

**Red-team pass (in-session fixes recorded)** — (1) audio numbering skipped AUD035 during drafting (cl2008 was numbered 036): renumbered — cl2008 → AUD035, D01 takes → AUD036/037, CV stimuli → AUD038–040, close pair → AUD041/042, final count 17; (2) CL2-003's speaker-replay field carried two alternative wordings: rewritten to one canon reference (AUD022, Leo, L1); (3) CL2-005's replay reference updated to the corrected D01 learning-take ID (AUD036).

**Lens spot-checks** — L1 dependencies: all items cite taught targets; D01's every turn maps to prerequisites. L2 pedagogy: clinic 2 follows model → perception → choice → tile → transfer; listening ladder runs gist → detail → speaker/transfer across takes. L3 micro-set policy: no new sets (review chapter). L4 assessment: LS testlet dependence declared; RT014 documented as a diagnostic probe feeding clinic 2, not double-scored; checkpoint stays independent of D01. L5 audio: 17 scripts, two-take pairs (model + D01) as fresh recordings. L6 grounding: Kenya = Swahili and English per the C3 record; no new facts invented — Amara/Rafael data is registered fiction. L8 inclusion: singular they for Alex maintained (RT010 "They speak…" with named referent); no gender inference from names (Amara/Rafael pronouns fixed in the bible, not derived). L9 sensitivity: origins voluntary; no status language; no `Good night` in any option (checked all 31 option sets + D01). L10 continuity: cast lines all canon; cross-chapter replays flagged (AUD022, C3-AUD058). L12: no typing; skip paths on WR001; no learner depiction in art. L13: verified above. L14: three catches above; also verified — no numbers above 20 in learner content (digit groups only), no Alex-as-singular be item (CL2 uses Maya/Kenji/Amara/Leo), no `the` anywhere, WR002's "a office worker" appears only as a distractor tile (never as correct), and the challenge D01 take is a fresh script, not a speed edit. Article audit: "the" appears only in instruction/feedback register (24 occurrences, all in prompt/feedback prose — the same register C3-L1 feedback used) and never in a target sentence, option, or cast line — the G009 boundary holds.

**Open items carried to L3** — RP001 roleplay (Rafael at the door; 6–8 turns; non-voice alternative) · Checkpoint 1 (A1-CP1-V12 · G12 · LS10 over three fresh recordings · RD6 · CN6 · W001–002 tile tasks · SM01 speaking mission + tap alternative) · results/gate routing (80/70; near-pass → clinic + A1-CP1-B001–015; below-70 → per-section loop) · parallel pool A1-CP1-P001–012 · chapter wrap-up + QA report + **chapter gate with compact tip** · ILL012–016 · screens S20–S28 · audio from AUD043 (chapter block) and A1-CP1-AUD001–003 (checkpoint recordings).


