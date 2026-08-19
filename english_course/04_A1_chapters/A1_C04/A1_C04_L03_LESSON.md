# A1 — Chapter 4 — Lesson 3 (A1-C04-L03) — The Door, the Mission, and Checkpoint 1

```yaml
lesson_id: A1-C04-L03
lesson_type: M                       # mission + assessment session (roleplay + Checkpoint 1)
chapter: 4
title: "Checkpoint Review 1: Welcome-Day Mission — Part 3: The Door and Your Checkpoint"
estimated_minutes: 20                # roleplay + checkpoint run 20–25; pause point after the roleplay
prerequisites:
  chapters: [1, 2, 3]
  verified_against: "LEXICAL_LEDGER.csv (86 taught rows) · GRAMMAR_LEDGER.csv (G001–G009
    taught) · A1_C04_MANIFEST.md checkpoint spec · A1_C04_L02_HANDOFF.md · bible (newcomers
  table + C4 known-facts rows registered before this lesson)"
artifacts_manifest:
  roleplay_spec: 1                   # A1-C04-RP001 (§10.9 contract, 8-turn cap, non-voice path N1–N5)
  checkpoint_items: 46               # A1-CP1-V001–012 · G001–012 (11 choice + 1 tile) · LS001–010
                                     #   · RD001–006 · CN001–006 (45 choice + 1 tile)
  checkpoint_tile_tasks: 2           # A1-CP1-W001–002
  speaking_mission: 1                # A1-CP1-SM01 (rubric + tap alternative)
  checkpoint_recordings: 3           # A1-CP1-AUD001–003 (fresh; independent of D01)
  alternate_short_form: 15           # A1-CP1-B001–015 (near-pass route; own mini-recording AUD004)
  parallel_pool: 12                  # A1-CP1-P001–012 (retry pool, text/visual + regeneration rule)
  results_routing: 1                 # gate 80/70, near-pass, below-70, retries
  audio_scripts: 15                  # A1-C04-AUD043…053 (11) + A1-CP1-AUD001…004 (4)
  illustration_briefs: 5             # A1-C04-ILL012…016 — BLOCK COMPLETE (16/16)
  screens: 9                         # A1-C04-S20…S28 (chapter total 28)
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
  - "Checkpoint 1 IS the chapter quiz: 100% cumulative by design, every item carries a
    'reviews:' cite; the 15–25% rule is subsumed, not stacked (manifest ruling 2)."
  - "Checkpoint independence: the three recordings are fresh performances of canon facts;
    no D01 stimulus, no practice-item stimulus reappears. B-form and P-pool stay parallel
    (fresh referents from the same canon)."
  - "Rafael's lines stay inside taught frames; 'I speak Portuguese and English' is taught
    recombination (languages frame + and). 'This is my friend Rafael.' and bare 'This is
    Rafael.' are both accepted in RP001/SM01 (V029 is the frame 'This is …')."
  - "SM01 completion counts equally via the tap alternative (C3 RP001 precedent) — the
    mission gate is completion, never a voice requirement (lens 12)."
  - "Scoring model: 45 choice points + 2 tile tasks = 47 scored points for the 80% gate;
    SM01 is pass/fail mission completion; conversation floor = CN block + SM01 completion."
  - "No new targets (verified); 'How many' never used; numbers ≤20 only as digits/values
    already taught; 'sort' never used as a word."
instruction_lexicon_note: >-
  Stages 1–4 active: listen · look · tap · choose · match · say · repeat · put in order ·
  first · next · last · one · two · again · correct · try again · read · answer · record ·
  play · check. SM01's voice path uses record/play; the tap path uses none of them.
scene_glue_note: >-
  Glue words this lesson (receptive, illustrated, never tested): door, knock, badge,
  checkpoint (app chrome with star icon), star, sheet. Rafael is now in-scene from S21.
```

---

## The last door (S20 — story + mission final card)

The morning is full: the sheet holds four names, the wall holds six dots, and Amara is at the notice board with Sam. One thing is left — the door. **AUD043** opens the lesson:

```text
GUIDE: (warm) The morning is full. … One thing now: the door. …
A new friend is at the door. … Your badge. Your lines. Your mission!
ALEX: (bright) Okay! You're ready. … I'm here — and Amara is here. … Go!
```

Mission final card: ⭐⭐⭐ earned (hello · check in · this is my friend) — one star left: **the door star**. After the mission: **Checkpoint 1**, your Arc-1 test.

---

## §1 The mission roleplay — A1-C04-RP001 (S21–S22 · ILL012)

### Contract (§10.9)

```yaml
id: A1-C04-RP001
title: "The Door — greet, check in, introduce"
setting: "The Community House door, late morning. Rafael Costa arrives (denim jacket,
  yellow t-shirt, key ring). Alex stands back; Amara is near the notice board."
interlocutor: "RAFAEL (AI side) — lively, medium-low; speaks only taught frames; one
  repair offer per stall; never more than one question at a time."
learner_role: "greeter with a helper badge"
turn_cap: 8                          # the dialogue closes at turn 8 regardless of path
required_slots:
  - slot: greeting
    learner_move: "a time-of-day greeting or hello/hi"
    accepts: ["Good morning!", "Hello!", "Hi!"]
  - slot: name_question
    learner_move: "ask the name"
    accepts: ["What's your name?"]
  - slot: spelling_request
    learner_move: "ask for the spelling"
    accepts: ["How do you spell that?"]
  - slot: origin_question
    learner_move: "ask the origin"
    accepts: ["Where are you from?"]
  - slot: introduction
    learner_move: "introduce Rafael to Amara"
    accepts: ["This is my friend Rafael.", "This is Rafael."]
optional_slots:
  - {slot: phone_request, accepts: ["What's your phone number?", "Your phone number, please?"]}
  - {slot: job_question, accepts: ["What do you do?"]}
  - {slot: close, accepts: ["See you!", "Bye!", "Goodbye!"]}
ai_script:                           # Rafael's side; flexible order after turn 4
  T2: "Hi! I'm Rafael. Rafael Costa."
  T4: "R-A-F-A-E-L. … And my phone number: 6-1-8… 4-0-2."
  T6: "I'm from Brazil. I'm a driver. … I speak Portuguese and English!"
  T8: "Nice to meet you, Amara! … (with AMARA: 'Nice to meet you too!')"
audio_cue_ids: [A1-C04-AUD044, A1-C04-AUD045, A1-C04-AUD046, A1-C04-AUD047]
guardrails:
  - "Rafael never uses untaught grammar; his lines are the four scripted turns plus short
    acknowledgements ('Okay, okay!' — his canon-adjacent warmth, mirroring Sam's habit)."
  - "If the learner stalls 10 s: one repair offer ('My name is Rafael. R-A-F-A-E-L.'),
    then the next slot re-prompt with icons. Latency never lowers the outcome."
  - "If the learner skips a required slot twice: the slot completes as a tap choice (no
    failure state inside practice — the checkpoint, not the roleplay, gates)."
  - "No immigration/status/job-pressure framing; origins are offered facts, never demanded."
  - "The exchange never exceeds 8 turns; Amara joins only for the introduction turn."
outcome: "Practice only. Completion = all five required slots expressed (by voice or tap).
  Feedback: one star on the mission card + Alex's 'Okay!' line (AUD047 tail)."
qa_status: script_review
```

### The happy path (8 turns)

```text
T1  LEARNER: Good morning!
T2  RAFAEL:  Hi! I'm Rafael. Rafael Costa.
T3  LEARNER: Rafael — how do you spell that?
T4  RAFAEL:  R-A-F-A-E-L. … And my phone number: 6-1-8… 4-0-2.
T5  LEARNER: Thank you! Where are you from?
T6  RAFAEL:  I'm from Brazil. I'm a driver. … I speak Portuguese and English!
T7  LEARNER: Amara! This is my friend Rafael.
T8  RAFAEL:  (to Amara) Nice to meet you!
    AMARA:   Nice to meet you too!
```

Turns 3→4 and 5→6 absorb the optional slots: if the learner asks the phone or job question instead, Rafael answers it inside his next scripted turn — the required slots stay reachable within the cap.

### Non-voice alternative path (N1–N5)

```yaml
alternative_path: "tap-based, same slots, same story beats; completion counts the same"
nodes:
  - N1:
      cue: "ILL012 — the door opens; Rafael waves"
      task: "choose your first line"
      options: {A: "Good morning!", B: "See you!", C: "My name is Amara."}
      correct: [A]
      reviews: [A1-C01-L01-V003]
  - N2:
      cue: "RAFAEL: 'Hi! I'm Rafael. Rafael Costa.' (AUD044)"
      task: "choose your next line"
      options: {A: "How are you?", B: "How do you spell that?", C: "See you!"}
      correct: [B]
      reviews: [A1-C02-L01-V007]
  - N3:
      cue: "RAFAEL: 'R-A-F-A-E-L. And my phone number: 6-1-8… 4-0-2.' (AUD045)"
      task: "tap the badge: the name and the number"
      options: {A: "RAFEL · 6-1-8 4-0-2", B: "RAFAEL · 6-8-1 4-0-2", C: "RAFAEL · 6-1-8 4-0-2"}
      correct: [C]
      reviews: [A1-C02-L01-PAT001, A1-C02-L02-PAT002, A1-C02-L02-PAT003]
  - N4:
      cue: "RAFAEL: 'I'm from Brazil. I'm a driver.' (AUD046)"
      task: "tap the two chips for Rafael's card"
      options: {A: "Japan + engineer", B: "Brazil + cook", C: "Brazil + driver"}
      correct: [C]
      reviews: [A1-C03-L01-V012, A1-C03-L01-V023]
  - N5:
      cue: "Amara turns toward you (ILL012 inset)"
      task: "you introduce Rafael — choose your line"
      options: {A: "See you!", B: "This is my friend Rafael.", C: "Nice to meet you, Amara!"}
      correct: [B]
      reviews: [A1-C03-L01-V029]
design_note: "All options are clean taught lines — no banned greeting appears anywhere in
  the node set (the C3-L3 N5 lesson applied: document the ban, never print the option)."
```

**Pause point (after the roleplay, ≈ minute 8).** The checkpoint waits behind its own cover screen; progress saves; returning resumes at S23.

---

## §2 Checkpoint 1 (S23–S27 · ILL013)

**AUD049** — `checkpoint_intro` · guide · learning_slow_clear

```text
GUIDE: (warm, steady) Checkpoint 1. … Three chapters, one test. …
Listen. Read. Say your lines. … Twenty minutes. … Ready — go!
```

```yaml
checkpoint_id: A1-CP1
sections: [V, G, LS, RD, CN, W, SM]
scored_points: 47                    # V12 + G11 + LS10 + RD6 + CN6 + W2 (SM01 = completion)
time_target: "20–25 minutes"
gate:
  pass: "≥80% of 47 scored points AND ≥70% in each of V, G, LS, and conversation (CN+SM)
         AND SM01 completed (voice or tap)"
  near_pass: "70–79% overall, or exactly one component floor missed → clinic rerun of the
         weak clinic + alternate short form B001–015"
  below: "<70% → personalised review route: per-section loop of the weakest spans
         (L1 retrieval set, L2 retrieval set, or the two clinics), then B-form, then retry"
  retries: "Unlimited, parallel content only: P001–012 pool first, then the documented
         regeneration rule (below). Never the same items twice in a row."
independence: "No shared stimuli except the three declared recordings; every item carries
  reviews cites; no practice item or D01 turn reappears."
```

### Recordings (three, all fresh performances of canon facts)

**A1-CP1-AUD001** — `cp1_greetings` · Sam + Nina · learning_slow_clear (~12 s)

```text
SAM:  (cheerful) Good morning, Nina!
NINA: (clear) Good morning, Sam! How are you?
SAM:  I'm good, thank you! … And you?
NINA: I'm fine!
```

**A1-CP1-AUD002** — `cp1_checkin` · Nina + Sam · learning_slow_clear (~15 s)

```text
NINA: Your name, please?
SAM:  Sam. Sam Rivera.
NINA: How do you spell that?
SAM:  S-A-M. … R-I-V-E-R-A.
NINA: Your phone number, please?
SAM:  4-0-1… 7-3-2.
NINA: 4-0-1, 7-3-2. … Thank you, Sam!
```

**A1-CP1-AUD003** — `cp1_profile` · Kenji · learning_slow_clear (~12 s)

```text
KENJI: (calm) Hi. I'm Kenji. … I'm from Japan. …
I speak Japanese and English. … I'm an engineer.
```

### Vocabulary — A1-CP1-V001–012

```yaml
id: A1-CP1-V001
section: V
type: image_to_chunk
instruction_words: [look, tap]
stimulus_visual: "dusk street scene, warm lamps (station from the RT001 art family)"
prompt_text: "You say:"
reviews: [A1-C01-L01-V005]
options: [{id: A, label: "Good evening!"}, {id: B, label: "Good morning!"}, {id: C, label: "See you!"}]
correct_option_ids: [A]
rationale: "Dusk scene + arrival → the evening greeting (V005)."
feedback_correct: "Yes — good evening."
feedback_incorrect: "The lamps are on, the sky is orange — 'Good evening!'"

id: A1-CP1-V002
section: V
type: audio_meaning
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD001
prompt_text: "Sam is:"
reviews: [A1-C01-L02-V016, A1-C01-L02-V018]
options: [{id: A, label: "not bad"}, {id: B, label: "good"}, {id: C, label: "okay"}]
correct_option_ids: [B]
rationale: "'I'm good, thank you!' — the state word in the heard line."
feedback_correct: "Yes — 'I'm good!'"
feedback_incorrect: "Listen again: 'I'm good, thank you!'"

id: A1-CP1-V003
section: V
type: chunk_use
instruction_words: [read, tap]
stimulus_text: "A new neighbor is at the door. First, you say:"
reviews: [A1-C01-L02-V026]
options: [{id: A, label: "See you!"}, {id: B, label: "I'm a teacher."}, {id: C, label: "What's your name?"}]
correct_option_ids: [C]
rationale: "The identity question opens a new encounter (V026)."
feedback_correct: "Yes — ask the name first."
feedback_incorrect: "A new face, a new name: 'What's your name?'"

id: A1-CP1-V004
section: V
type: chunk_scene
instruction_words: [look, tap]
stimulus_visual: "the hall door at day's end, bag on shoulder, a wave"
prompt_text: "You say:"
reviews: [A1-C01-L01-V008]
options: [{id: A, label: "See you!"}, {id: B, label: "Good morning!"}, {id: C, label: "My name is Leo."}]
correct_option_ids: [A]
rationale: "Leaving + wave → the taught farewell (V008)."
feedback_correct: "'See you!' — yes."
feedback_incorrect: "A wave at the door — 'See you!'"

id: A1-CP1-V005
section: V
type: intent_icons
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD002
prompt_text: "'How do you spell that?' — Tap:"
reviews: [A1-C02-L01-V007, A1-C02-L01-PAT001]
options: [{id: A, asset: "digits chip"}, {id: B, asset: "letters chip"}, {id: C, asset: "map chip"}]
correct_option_ids: [B]
rationale: "The spelling question maps to letters (C2-V007)."
feedback_correct: "Yes — letter by letter."
feedback_incorrect: "'How do you spell that?' — letters!"

id: A1-CP1-V006
section: V
type: audio_number
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD002
prompt_text: "Sam's phone — first group:"
reviews: [A1-C02-L01-PAT002, A1-C02-L02-PAT003]
options: [{id: A, label: "1-4-0"}, {id: B, label: "4-1-0"}, {id: C, label: "4-0-1"}]
correct_option_ids: [C]
rationale: "Heard digit order four-zero-one; the distractors transpose."
feedback_correct: "Yes — 4-0-1."
feedback_incorrect: "Listen: four… zero… one."

id: A1-CP1-V007
section: V
type: word_icon
instruction_words: [look, tap]
stimulus_visual: "an envelope opening on a phone screen (C2 icon family)"
prompt_text: "Tap the words:"
reviews: [A1-C02-L02-V012, A1-C02-L02-V013]
options: [{id: A, label: "email address"}, {id: B, label: "phone number"}, {id: C, label: "first name"}]
correct_option_ids: [A]
rationale: "Envelope icon ↔ email address (C2 contact set)."
feedback_correct: "Yes — the email address."
feedback_incorrect: "The envelope — the email address."

id: A1-CP1-V008
section: V
type: situation_choice
instruction_words: [read, tap]
stimulus_visual: "two speech cards side by side: NINA: '4-0-1, 7-3-2.' · SAM: 'No — 4-0-1, 7-3-0!'"
prompt_text: "Two numbers! You say:"
reviews: [A1-C02-L01-V008]
options: [{id: A, label: "See you!"}, {id: B, label: "Can you repeat that, please?"}, {id: C, label: "Good morning!"}]
correct_option_ids: [B]
rationale: "Conflicting digits → the taught repair (C2-V008)."
feedback_correct: "Yes — ask for the repeat."
feedback_incorrect: "Two numbers! Ask again: 'Can you repeat that, please?'"

id: A1-CP1-V009
section: V
type: map_to_word
instruction_words: [look, tap]
stimulus_visual: "Kenya map card (C3 map-card family)"
prompt_text: "Tap the country:"
reviews: [A1-C03-L01-V014]
options: [{id: A, label: Egypt}, {id: B, label: Japan}, {id: C, label: Kenya}]
correct_option_ids: [C]
rationale: "Map shape ↔ country name (V014)."
feedback_correct: "Yes — Kenya."
feedback_incorrect: "That shape is Kenya."

id: A1-CP1-V010
section: V
type: image_word
instruction_words: [look, match, tap]
stimulus_visual: "a nurse at a clinic desk — scrubs, stethoscope-like badge (no cross), kind face"
prompt_text: "She is a:"
reviews: [A1-C03-L01-V020]
options: [{id: A, label: nurse}, {id: B, label: driver}, {id: C, label: cook}]
correct_option_ids: [A]
rationale: "Clinic setting + scrubs → nurse (V020); the art is gender-varied by design."
feedback_correct: "Yes — a nurse."
feedback_incorrect: "The clinic, the scrubs — a nurse."

id: A1-CP1-V011
section: V
type: word_icon
instruction_words: [look, tap]
stimulus_visual: "two figures laughing together, arms linked (C3 people art)"
prompt_text: "Maya and Sam are:"
reviews: [A1-C03-L01-V026, A1-C03-L01-V028]
options: [{id: A, label: people}, {id: B, label: friends}, {id: C, label: students}]
correct_option_ids: [B]
rationale: "Two named people with a warm bond → friends (V026); 'people' is true but
  general — the picture's meaning cue is the friendship."
feedback_correct: "Yes — friends."
feedback_incorrect: "Look at the two of them — friends!"

id: A1-CP1-V012
section: V
type: frame_icon
instruction_words: [look, tap]
stimulus_visual: "Rafael's profile card icon: portrait + small Brazil map"
prompt_text: "Line 2 of the card:"
reviews: [A1-C03-L01-V033, A1-C03-L01-V012]
options: [{id: A, label: "I'm a driver."}, {id: B, label: "My name is Rafael."}, {id: C, label: "I'm from Brazil."}]
correct_option_ids: [C]
rationale: "The map chip ↔ the from-frame (V033)."
feedback_correct: "Yes — 'I'm from Brazil.'"
feedback_incorrect: "The map line: 'I'm from Brazil.'"
```

### Grammar — A1-CP1-G001–012 (11 choice + 1 tile)

```yaml
id: A1-CP1-G001
section: G
type: form_choice
instruction_words: [read, tap]
stimulus_text: "I ___ a student."
reviews: [A1-C01-L02-G001, A1-C03-L01-V017]
options: [{id: A, label: am}, {id: B, label: is}, {id: C, label: are}]
correct_option_ids: [A]
rationale: "I takes am — the first taught chunk."
feedback_correct: "Yes — I am a student."
feedback_incorrect: "I → am. 'I'm a student.'"

id: A1-CP1-G002
section: G
type: contraction
instruction_words: [read, tap]
stimulus_text: "You are Maya. = "
reviews: [A1-C01-L02-G001]
options: [{id: A, label: "You's Maya."}, {id: B, label: "You're Maya."}, {id: C, label: "You am Maya."}]
correct_option_ids: [B]
rationale: "you are → you're (G001 contraction)."
feedback_correct: "Yes — You're Maya."
feedback_incorrect: "you are → you're."

id: A1-CP1-G003
section: G
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Maya and Sam ___ friends."
reviews: [A1-C03-L02-G007, A1-C03-L01-V026]
options: [{id: A, label: is}, {id: B, label: am}, {id: C, label: are}]
correct_option_ids: [C]
rationale: "Named pair = they → are."
feedback_correct: "Yes — Maya and Sam are friends."
feedback_incorrect: "Two people → are."

id: A1-CP1-G004
section: G
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Leo and Nina ___ from Spain. (no — Peru and Australia!)"
reviews: [A1-C03-L02-G007, A1-C03-L01-V015]
options: [{id: A, label: aren't}, {id: B, label: isn't}, {id: C, label: am not}]
correct_option_ids: [A]
rationale: "Plural they negative → aren't (G007); the bracket makes the negative true."
feedback_correct: "Yes — they aren't from Spain."
feedback_incorrect: "Two people, no → aren't."

id: A1-CP1-G005
section: G
type: short_answer
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD001
prompt_text: "Nina asks: 'How are you?' You say:"
reviews: [A1-C01-L02-G003, A1-C01-L02-V029]
options: [{id: A, label: "I is good."}, {id: B, label: "I'm good."}, {id: C, label: "I are good."}]
correct_option_ids: [B]
rationale: "The state answer takes I'm (I am) — the taught chain; the distractors are the
  is/are error forms."
feedback_correct: "Yes — I'm good."
feedback_incorrect: "I → am: I'm good."

id: A1-CP1-G006
section: G
type: form_choice
instruction_words: [read, tap]
stimulus_text: "A-M-A-R-A. ___ A-M-A-R-A."
reviews: [A1-C02-L02-G005]
options: [{id: A, label: "She's"}, {id: B, label: "Is"}, {id: C, label: "It's"}]
correct_option_ids: [C]
rationale: "Letters and digits take It's (G005) — she's would need a person referent, and
  the stimulus is a letter string."
feedback_correct: "Yes — It's A-M-A-R-A."
feedback_incorrect: "Letters take It's: 'It's A-M-A-R-A.'"

id: A1-CP1-G007
section: G
type: pronoun_reference
instruction_words: [read, tap]
stimulus_text: "Where is Alex from? — ___ from Canada."
reviews: [A1-C03-L02-G007, A1-C03-L01-V034]
options: [{id: A, label: "They're"}, {id: B, label: "She's"}, {id: C, label: "He's"}]
correct_option_ids: [A]
rationale: "Alex's pronouns are they/them (bible) — the taught referent discipline."
feedback_correct: "Yes — Alex? They're from Canada."
feedback_incorrect: "Alex is they: 'They're from Canada.'"

id: A1-CP1-G008
section: G
type: form_choice
instruction_words: [read, tap]
stimulus_text: "Leo — ___ phone number is 6-2-0, 1-5-4."
reviews: [A1-C03-L02-G008, A1-C02-L02-V011]
options: [{id: A, label: her}, {id: B, label: his}, {id: C, label: "their"}]
correct_option_ids: [B]
rationale: "Leo = he → his (G008)."
feedback_correct: "Yes — his phone number."
feedback_incorrect: "Leo is he → his."

id: A1-CP1-G009
section: G
type: article_choice
instruction_words: [read, tap]
stimulus_text: "Kenji is ___ engineer."
reviews: [A1-C03-L02-G009, A1-C03-L01-V021]
options: [{id: A, label: a}, {id: B, label: an}, {id: C, label: from}]
correct_option_ids: [B]
rationale: "Engineer starts with a vowel sound → an (G009, by sound)."
feedback_correct: "Yes — an engineer."
feedback_incorrect: "Vowel sound → an: 'an engineer.'"

id: A1-CP1-G010
section: G
type: frame_choice
instruction_words: [read, tap]
stimulus_text: "Kenji is ___ Japan."
reviews: [A1-C03-L01-V033, A1-C03-L01-V013]
options: [{id: A, label: an}, {id: B, label: a}, {id: C, label: from}]
correct_option_ids: [C]
rationale: "Country after the from-frame (clinic 2's door)."
feedback_correct: "Yes — Kenji is from Japan."
feedback_incorrect: "A country → from: 'from Japan.'"

id: A1-CP1-G011
section: G
type: short_answer
instruction_words: [read, tap]
stimulus_text: "Is Nina a teacher? — Yes, ___ is."
reviews: [A1-C03-L02-G007, A1-C03-L01-V018]
options: [{id: A, label: he}, {id: B, label: they}, {id: C, label: she}]
correct_option_ids: [C]
rationale: "Nina = she → Yes, she is (G007 short answers)."
feedback_correct: "Yes — she is a teacher."
feedback_incorrect: "Nina is she: 'Yes, she is.'"

id: A1-CP1-G012
section: G
type: tile_order
instruction_words: [put in order]
prompt_text: "The job question:"
tiles: ["you", "do", "What", "do?"]
correct_order: ["What", "do", "you", "do?"]
reviews: [A1-C03-L01-V035]
rationale: "Rebuilds the fixed job question in order (V035 as a frame)."
feedback_correct: "'What do you do?' — yes!"
feedback_incorrect: "First: What. Next: do. Then: you. Last: do?"
```

### Listening — A1-CP1-LS001–010 (10 across the three recordings)

```yaml
id: A1-CP1-LS001
section: LS
type: gist
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD001
prompt_text: "How many people?"
reviews: [A1-C01-L02-V028, A1-C02-L02-PAT003]
options: [{id: A, label: "one"}, {id: B, label: "two"}, {id: C, label: "three"}]
correct_option_ids: [B]
rationale: "Two voices — Sam and Nina (also the taught number word in use)."
feedback_correct: "Yes — two people."
feedback_incorrect: "Two voices: Sam and Nina."

id: A1-CP1-LS002
section: LS
type: detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD001
prompt_text: "Nina is:"
reviews: [A1-C01-L02-V017]
options: [{id: A, label: "not bad"}, {id: B, label: great}, {id: C, label: fine}]
correct_option_ids: [C]
rationale: "'I'm fine!' — the state word in Nina's last line."
feedback_correct: "Yes — 'I'm fine!'"
feedback_incorrect: "Nina's last line: 'I'm fine!'"

id: A1-CP1-LS003
section: LS
type: best_response
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD001
prompt_text: "Sam says: 'And you?' — Nina says:"
reviews: [A1-C01-L02-V030, A1-C01-L02-V029]
options: [{id: A, label: "I'm fine, thank you."}, {id: B, label: "My name is Nina."}, {id: C, label: "See you!"}]
correct_option_ids: [A]
rationale: "The And-you? handoff takes a state answer (the taught chain)."
feedback_correct: "Yes — the state answer."
feedback_incorrect: "'And you?' — you say how you are: 'I'm fine, thank you.'"

id: A1-CP1-LS004
section: LS
type: gist
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD001
prompt_text: "Time of day:"
reviews: [A1-C01-L01-V003, A1-C01-L01-V005]
options: [{id: A, asset: "sun-high park"}, {id: B, asset: "dusk lamps"}, {id: C, asset: "sun-low café with long shadows"}]
correct_option_ids: [C]
rationale: "Both voices say 'Good morning' — morning, and morning sun is low with long
  shadows (the same scene grammar as L1's RT001, where high sun = afternoon)."
feedback_correct: "Yes — morning."
feedback_incorrect: "Listen to the greeting: 'Good morning!'"

id: A1-CP1-LS005
section: LS
type: detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD002
prompt_text: "S-A-M. Sam's last name:"
reviews: [A1-C01-L02-V023, A1-C02-L01-PAT001]
options: [{id: A, label: Rivas}, {id: B, label: Rivera}, {id: C, label: Rivea}]
correct_option_ids: [B]
rationale: "R-I-V-E-R-A — the heard spelling of the canon last name."
feedback_correct: "Yes — Rivera."
feedback_incorrect: "Listen: R-I-V-E-R-A. Rivera!"

id: A1-CP1-LS006
section: LS
type: detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD002
prompt_text: "Sam's phone number:"
reviews: [A1-C02-L02-PAT002, A1-C02-L02-PAT003, A1-C02-L02-V010]
options: [{id: A, label: "4-0-1 · 7-3-2"}, {id: B, label: "4-0-1 · 7-2-3"}, {id: C, label: "1-4-0 · 7-3-2"}]
correct_option_ids: [A]
rationale: "Four-zero-one, seven-three-two — canon number, heard twice (Sam + Nina's read-back)."
feedback_correct: "Yes — 4-0-1, 7-3-2."
feedback_incorrect: "Listen to Nina's read-back: 4-0-1… 7-3-2."

id: A1-CP1-LS007
section: LS
type: repair_detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD002
prompt_text: "Nina reads the number back. Why?"
reviews: [A1-C02-L01-V008, A1-C02-L01-V002]
options: [{id: A, asset: "check icon (match the sheet)"}, {id: B, asset: "wave icon (say goodbye)"}, {id: C, asset: "map icon (ask a country)"}]
correct_option_ids: [A]
rationale: "The read-back checks the digits before they are written — the register routine from C2."
feedback_correct: "Yes — she checks the digits."
feedback_incorrect: "Nina checks: '4-0-1, 7-3-2. Thank you!'"

id: A1-CP1-LS008
section: LS
type: detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD003
prompt_text: "Kenji is from:"
reviews: [A1-C03-L01-V013, A1-C03-L01-V033]
options: [{id: A, label: Japan}, {id: B, label: Kenya}, {id: C, label: Brazil}]
correct_option_ids: [A]
rationale: "'I'm from Japan' — the from-frame detail."
feedback_correct: "Yes — Japan."
feedback_incorrect: "Listen: 'I'm from Japan.'"

id: A1-CP1-LS009
section: LS
type: detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD003
prompt_text: "Kenji is a:"
reviews: [A1-C03-L01-V021, A1-C03-L01-V036, A1-C03-L02-G009]
options: [{id: A, label: "a doctor"}, {id: B, label: "an engineer"}, {id: C, label: "a teacher"}]
correct_option_ids: [B]
rationale: "'I'm an engineer' — the job detail with its article."
feedback_correct: "Yes — an engineer."
feedback_incorrect: "Listen: 'I'm an engineer.'"

id: A1-CP1-LS010
section: LS
type: detail
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD003
prompt_text: "Kenji speaks:"
reviews: [A1-C03-L01-V030, A1-C03-L01-V006]
options: [{id: A, label: "Portuguese and English"}, {id: B, label: "Swahili and English"}, {id: C, label: "Japanese and English"}]
correct_option_ids: [C]
rationale: "'I speak Japanese and English' — the languages frame (recognition-level country data)."
feedback_correct: "Yes — Japanese and English."
feedback_incorrect: "Listen: 'I speak Japanese and English.'"
```

### Reading — A1-CP1-RD001–006 (two mini-texts)

**Text 1 — Rafael's profile card** (pinned beside Amara's; ILL009 art family):

> **RAFAEL COSTA**
> I'm Rafael. I'm from Brazil.
> I speak Portuguese and English.
> I'm a driver.

**Text 2 — Leo's message card** (the register genre, one row):

> **LEO NOVAK** · 6-2-0 1-5-4 · leo.novak@aroa.com

```yaml
id: A1-CP1-RD001
section: RD
type: profile_comprehension
instruction_words: [read, tap]
stimulus_visual: "Rafael's profile card (above)"
prompt_text: "Rafael is from:"
reviews: [A1-C03-L01-V012, A1-C03-L01-V033]
options: [{id: A, label: Kenya}, {id: B, label: Brazil}, {id: C, label: Japan}]
correct_option_ids: [B]
rationale: "Card line 2 — the from-frame."
feedback_correct: "Yes — Brazil."
feedback_incorrect: "Read line two: 'I'm from Brazil.'"

id: A1-CP1-RD002
section: RD
type: profile_comprehension
instruction_words: [read, tap]
stimulus_visual: "Rafael's profile card (above)"
prompt_text: "Rafael is a:"
reviews: [A1-C03-L01-V023, A1-C03-L01-V036]
options: [{id: A, label: "a cook"}, {id: B, label: "an engineer"}, {id: C, label: "a driver"}]
correct_option_ids: [C]
rationale: "Card line 4 — the a/an job frame."
feedback_correct: "Yes — a driver."
feedback_incorrect: "Read line four: 'I'm a driver.'"

id: A1-CP1-RD003
section: RD
type: profile_comprehension
instruction_words: [read, tap]
stimulus_visual: "Rafael's profile card (above)"
prompt_text: "Rafael speaks:"
reviews: [A1-C03-L01-V030, A1-C03-L01-V006]
options: [{id: A, label: "Portuguese and English"}, {id: B, label: "Spanish and English"}, {id: C, label: "Japanese and English"}]
correct_option_ids: [A]
rationale: "Card line 3 — the languages frame (Brazil record, recognition level)."
feedback_correct: "Yes — Portuguese and English."
feedback_incorrect: "Read line three: 'I speak Portuguese and English.'"

id: A1-CP1-RD004
section: RD
type: form_scan
instruction_words: [read, tap]
stimulus_visual: "Leo's message card (above)"
prompt_text: "Leo's phone number:"
reviews: [A1-C02-L02-PAT002, A1-C02-L02-PAT003, A1-C02-L02-V010]
options: [{id: A, label: "6-2-0 · 1-4-5"}, {id: B, label: "6-2-0 · 1-5-4"}, {id: C, label: "2-6-0 · 1-5-4"}]
correct_option_ids: [B]
rationale: "Card scan — Leo's canon digits."
feedback_correct: "Yes — 6-2-0, 1-5-4."
feedback_incorrect: "Read the middle group: 6-2-0, 1-5-4."

id: A1-CP1-RD005
section: RD
type: form_scan
instruction_words: [read, tap]
stimulus_visual: "Leo's message card (above)"
prompt_text: "leo.novak@aroa.com — the last name:"
reviews: [A1-C01-L02-V023, A1-C02-L02-V018]
options: [{id: A, label: Leo}, {id: B, label: Aroa}, {id: C, label: Novak}]
correct_option_ids: [C]
rationale: "Email-to-name parsing: leo = first name, novak = last name."
feedback_correct: "Yes — Novak, his last name."
feedback_incorrect: "leo.novak — first name, last name: Novak."

id: A1-CP1-RD006
section: RD
type: text_structure
instruction_words: [read, tap]
stimulus_visual: "Rafael's profile card (above)"
prompt_text: "Card line 2:"
reviews: [A1-C03-L01-V033, A1-C03-L01-V024]
options: [{id: A, label: "I'm Rafael."}, {id: B, label: "I'm a driver."}, {id: C, label: "I'm from Brazil."}]
correct_option_ids: [C]
rationale: "Line-order awareness: name (1) → from (2) → speaks (3) → job (4)."
feedback_correct: "Yes — line 2 is the from line."
feedback_incorrect: "Line 1 name, line 2 from, line 3 speaks, line 4 job."
```

### Discourse — A1-CP1-CN001–006

```yaml
id: A1-CP1-CN001
section: CN
type: best_next_turn
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD030          # Maya's canon introduce line, re-performed
prompt_text: "Maya says: 'Alex! This is my friend Sam.' Alex says:"
reviews: [A1-C01-L02-V027, A1-C03-L01-V029]
options: [{id: A, label: "Nice to meet you, Sam!"}, {id: B, label: "See you!"}, {id: C, label: "My name is Alex."}]
correct_option_ids: [A]
rationale: "The meeting formula answers an introduction."
feedback_correct: "Yes — 'Nice to meet you!'"
feedback_incorrect: "A new face! 'Nice to meet you!'"

id: A1-CP1-CN002
section: CN
type: sequence_choice
instruction_words: [read, tap]
prompt_text: "At the door, first you say:"
reviews: [A1-C01-L01-V001, A1-C01-L01-V003, A1-C01-L02-V026]
options: [{id: A, label: "'What's your name?'"}, {id: B, label: "'Good morning!'"}, {id: C, label: "'See you!'"}]
correct_option_ids: [B]
rationale: "Encounter order: greeting before questions; the farewell closes."
feedback_correct: "Yes — the greeting comes first."
feedback_incorrect: "First the greeting: 'Good morning!' Then the name."

id: A1-CP1-CN003
section: CN
type: repair_choice
instruction_words: [listen, tap]
stimulus_audio: A1-C04-AUD040          # Amara's fast name line, re-performed
prompt_text: "Fast! You say:"
reviews: [A1-C02-L01-V008, A1-C02-L01-V009]
options: [{id: A, label: "Please speak slowly."}, {id: B, label: "I'm from Kenya."}, {id: C, label: "See you!"}]
correct_option_ids: [A]
rationale: "Fast speech → the taught repair set; the slow-request fits a too-fast name."
feedback_correct: "Yes — 'Please speak slowly.'"
feedback_incorrect: "Too fast? 'Please speak slowly.'"

id: A1-CP1-CN004
section: CN
type: intent_icons
instruction_words: [listen, tap]
stimulus_audio: A1-CP1-AUD002
prompt_text: "'Your phone number, please?' — Tap:"
reviews: [A1-C02-L02-V017, A1-C02-L02-V010]
options: [{id: A, asset: "letters chip"}, {id: B, asset: "job-tools chip"}, {id: C, asset: "digits chip"}]
correct_option_ids: [C]
rationale: "The phone-number question maps to digits."
feedback_correct: "Yes — digits."
feedback_incorrect: "A phone number is digits!"

id: A1-CP1-CN005
section: CN
type: close_choice
instruction_words: [look, tap]
stimulus_visual: "the hall at day's end; Rafael waves from the door, bag on"
prompt_text: "You say:"
reviews: [A1-C01-L01-V006, A1-C01-L01-V008]
options: [{id: A, label: "Good morning!"}, {id: B, label: "See you!"}, {id: C, label: "What's your name?"}]
correct_option_ids: [B]
rationale: "Departure + wave → the taught farewell; the greeting opens, the farewell closes."
feedback_correct: "'See you!' — yes."
feedback_incorrect: "He is leaving — 'See you!'"

id: A1-CP1-CN006
section: CN
type: pragmatic_choice
instruction_words: [look, tap]
stimulus_visual: "Amara brings Rafael to you; she gestures toward him"
prompt_text: "Amara says: 'This is my friend Rafael.' You say:"
reviews: [A1-C01-L02-V027, A1-C03-L01-V031]
options: [{id: A, label: "Nice to meet you, Rafael!"}, {id: B, label: "See you, Amara!"}, {id: C, label: "My name is Rafael."}]
correct_option_ids: [A]
rationale: "Being introduced TO someone: you take the meeting formula; the distractors
  close the encounter or steal the introduced person's line."
feedback_correct: "Yes — 'Nice to meet you, Rafael!'"
feedback_incorrect: "You meet Rafael: 'Nice to meet you!'"
```

### Tile tasks — A1-CP1-W001–002

```yaml
id: A1-CP1-W001
section: W
type: tile_introduction
instruction_words: [tap, put in order, check]
prompt_text: "Your three lines for the badge test:"
reviews: [A1-C01-L02-V024, A1-C03-L01-V033, A1-C03-L01-V036]
slots:
  - {frame: "My name is ___.", bank: fictional-name bank (C3-L3 WR006), correct: any}
  - {frame: "I'm from ___.", bank: ten taught countries + skip chip, correct: any}
  - {frame: "I'm a/an ___.", bank: nine taught jobs, correct: any, article: app-supplied}
skip_path: "Any slot may close with 'Not today'; a full skip still completes the task."
scoring: "1 point on completion of three built-or-skipped lines (auto-check)."
rationale: "The greeter introduction, built fresh under test conditions."

id: A1-CP1-W002
section: W
type: tile_chain
instruction_words: [tap, put in order, check]
prompt_text: "Rafael — three lines:"
reviews: [A1-C03-L01-V029, A1-C03-L02-G007, A1-C03-L01-V033, A1-C03-L01-V036]
correct_sentences:
  - "This is my friend Rafael."
  - "He's from Brazil."
  - "He's a driver."
tile_bank: ["This is my friend Rafael.", "She's from Brazil.", "He's from Brazil.",
            "He's an driver.", "He's a driver.", "See you!"]
correct_tiles: ["This is my friend Rafael.", "He's from Brazil.", "He's a driver."]
scoring: "1 point (all three target tiles selected and ordered; distractors unused)."
rationale: "The introduce-a-friend chain with pronoun and article traps in the bank."
```

### Speaking mission — A1-CP1-SM01

```yaml
id: A1-CP1-SM01
section: SM
type: speaking_mission                 # voice path OR tap path — completion counts equally
instruction_words: [listen, say, record, play, check]   # tap path: listen, tap, check
scene: "The door, one last time: a neighbor silhouette waves (ILL012 variant, no new figure)."
model_audio: A1-C04-AUD048
voice_path:
  utterances_required: 4               # any 4 of the 6 mission moves
  moves:
    - {move: greeting, accepts: ["Good morning!", "Hello!", "Hi!"]}
    - {move: name_question, accepts: ["What's your name?"]}
    - {move: detail_question, accepts: ["Where are you from?", "What do you do?", "What's your phone number?"]}
    - {move: introduce, accepts: ["This is my friend ___.", "This is ___."]}
    - {move: spell_request, accepts: ["How do you spell that?"]}
    - {move: close, accepts: ["See you!", "Bye!", "Goodbye!"]}
  scoring: "Completion-based (pass/fail): 4+ accepted moves, any order; accent, latency,
    and retries never reduce the outcome (lens 12; C3 RP001 precedent)."
tap_path:
  nodes: "five tap choices, one per move family (greeting · name question · detail
    question · introduce · close), each with three clean taught-line options."
  scoring: "Same completion rule — 4+ correct taps."
privacy_note: "Recordings stay on device; nothing uploads; the replay is the learner's own."
rubric_note: "No phonetic scoring at A1 — the model plays, the learner self-checks
  ('Sounds like the model' / 'Again, please')."
```

**A1-C04-AUD048** — `sm01_model` · guide + Alex · learning_slow_clear

```text
GUIDE: (steady) Your lines. … Listen, then say.
ALEX:  (bright, model rhythm) Good morning! … What's your name? …
Where are you from? … This is my friend Amara. … See you!
```

### Alternate short form — A1-CP1-B001–015 (near-pass route)

Fifteen parallel items, three per section, fresh referents from the same canon. Own mini-recording: **A1-CP1-AUD004** (`cp1_b_form` · Leo + Maya · learning_slow_clear):

```text
LEO:  (friendly) Good afternoon, Maya!
MAYA: (warm) Hi, Leo! How are you?
LEO:  I'm okay, thank you! … And you?
MAYA: I'm great!
```

```yaml
b_form_items:
  - {id: A1-CP1-B001, section: V, type: image_to_chunk, stimulus: "sun-high park scene",
     prompt: "You say:", options: ["Good evening!", "Good afternoon!" *, "See you!"], reviews: [A1-C01-L01-V004]}
  - {id: A1-CP1-B002, section: V, type: audio_meaning, audio: A1-CP1-AUD004,
     prompt: "Maya is:", options: ["fine", "not bad", "great" *], reviews: [A1-C01-L02-V019]}
  - {id: A1-CP1-B003, section: V, type: map_to_word, stimulus: "Egypt map card",
     prompt: "Tap the country:", options: ["Egypt" *, "Spain", "India"], reviews: [A1-C03-L01-V010]}
  - {id: A1-CP1-B004, section: G, type: form_choice, stimulus: "Nina ___ from Peru.",
     options: ["are", "am", "is" *], reviews: [A1-C03-L02-G007, A1-C03-L01-V009]}
  - {id: A1-CP1-B005, section: G, type: article_choice, stimulus: "Maya is ___ nurse.",
     options: ["an", "a" *, "from"], reviews: [A1-C03-L02-G009, A1-C03-L01-V020]}
  - {id: A1-CP1-B006, section: G, type: pronoun_reference, stimulus: "Where is Maya from? — ___ from Egypt.",
     options: ["She's" *, "He's", "I'm"], reviews: [A1-C03-L02-G007, A1-C03-L01-V034]}
  - {id: A1-CP1-B007, section: LS, type: gist, audio: A1-CP1-AUD004,
     prompt: "Time of day:", options: ["morning", "evening", "afternoon" *], reviews: [A1-C01-L01-V004]}
  - {id: A1-CP1-B008, section: LS, type: detail, audio: A1-CP1-AUD004,
     prompt: "Leo is:", options: ["great", "okay" *, "fine"], reviews: [A1-C01-L02-V018]}
  - {id: A1-CP1-B009, section: LS, type: best_response, audio: A1-CP1-AUD004,
     prompt: "Leo says: 'And you?' Maya says:", options: ["I'm great!" *, "My name is Maya.", "See you!"], reviews: [A1-C01-L02-V030]}
  - {id: A1-CP1-B010, section: RD, type: form_scan, stimulus: "Maya's card: 5-5-5 2-0-1 · maya.haddad@aroa.com",
     prompt: "Maya's phone:", options: ["5-5-5 · 2-1-0", "5-5-5 · 1-2-0", "5-5-5 · 2-0-1" *], reviews: [A1-C02-L02-PAT002, A1-C02-L02-PAT003]}
  - {id: A1-CP1-B011, section: RD, type: profile_comprehension, stimulus: "Amara's card (C4-L2)",
     prompt: "Amara is an:", options: ["engineer", "office worker" *, "doctor"], reviews: [A1-C03-L01-V025]}
  - {id: A1-CP1-B012, section: RD, type: text_structure, stimulus: "Amara's card",
     prompt: "Line 3:", options: ["I speak Swahili and English." *, "I'm from Kenya.", "I'm an office worker."], reviews: [A1-C03-L01-V030]}
  - {id: A1-CP1-B013, section: CN, type: sequence_choice, prompt: "After 'What's your name?', you say:",
     options: ["See you!", "Good morning!", "How do you spell that?" *], reviews: [A1-C02-L01-V007]}
  - {id: A1-CP1-B014, section: CN, type: repair_choice, prompt: "Two digits, two cards. You say:",
     options: ["I'm fine!", "Can you repeat that, please?" *, "Nice to meet you!"], reviews: [A1-C02-L01-V008]}
  - {id: A1-CP1-B015, section: CN, type: pragmatic_choice, prompt: "You introduce Sam to Leo. You say:",
     options: ["Leo! This is my friend Sam." *, "Nice to meet you, Sam!", "See you, Leo!"], reviews: [A1-C03-L01-V029]}
key_convention: "* marks the correct option; option order is A/B/C as listed."
b_form_letters: "A5 · B5 · C5 — B003/B006/B009/B012/B015 at A; B001/B005/B008/B011/B014 at B; B002/B004/B007/B010/B013 at C."
```

### Parallel pool — A1-CP1-P001–012 (retries)

```yaml
parallel_pool:
  note: "Text/visual items by design (no new recordings in the retry pool); fresh canon
    referents only; one item per section pair."
  items:
    - {id: A1-CP1-P001, section: V, task: "evening lamps scene → 'Good evening!' (options: Good evening!* / Good morning! / Hi!)", reviews: [A1-C01-L01-V005]}
    - {id: A1-CP1-P002, section: V, task: "map card India → India (options: Spain / Egypt / India*)", reviews: [A1-C03-L01-V016]}
    - {id: A1-CP1-P003, section: G, task: "'Alex and Maya ___ friends.' → are (options: is / are* / am)", reviews: [A1-C03-L02-G007]}
    - {id: A1-CP1-P004, section: G, task: "'Sam is from ___.' → Mexico (options: a cook / an engineer / Mexico*)", reviews: [A1-C03-L01-V008, A1-C03-L01-V033]}
    - {id: A1-CP1-P005, section: G, task: "'Amara — ___ phone number is 5-5-5, 3-1-9.' → her (options: his / her* / their)", reviews: [A1-C03-L02-G008]}
    - {id: A1-CP1-P006, section: LS, task: "replay A1-CP1-AUD001, prompt 'Sam is:' → good (options: fine / good* / not bad)", reviews: [A1-C01-L02-V016]}
    - {id: A1-CP1-P007, section: LS, task: "replay A1-CP1-AUD003, prompt 'Kenji speaks:' → Japanese and English (options: Portuguese and English / Swahili and English / Japanese and English*)", reviews: [A1-C03-L01-V030]}
    - {id: A1-CP1-P008, section: RD, task: "Nina's card: 5-5-5 2-0-9 → digits (options: 5-5-5 · 2-0-9* / 5-5-5 · 2-9-0 / 5-5-5 · 9-0-2)", reviews: [A1-C02-L02-PAT002, A1-C02-L02-PAT003]}
    - {id: A1-CP1-P009, section: RD, task: "Kenji profile line 4 → 'I'm an engineer.' (options: I'm from Japan. / I'm an engineer.* / I'm Kenji.)", reviews: [A1-C03-L01-V021, A1-C03-L01-V036]}
    - {id: A1-CP1-P010, section: CN, task: "after 'I'm from Kenya.' → 'What do you do?' (options: See you! / What do you do?* / Nice to meet you!)", reviews: [A1-C03-L01-V035]}
    - {id: A1-CP1-P011, section: CN, task: "introduced: 'Leo, this is my friend Nina.' → 'Nice to meet you, Nina!' (options: See you! / My name is Leo. / Nice to meet you, Nina!*)", reviews: [A1-C01-L02-V027]}
    - {id: A1-CP1-P012, section: W, task: "tile chain for Kenji: 'This is my friend Kenji. / He's from Japan. / He's an engineer.' (bank includes She's… and a engineer slips)", reviews: [A1-C03-L01-V029, A1-C03-L01-V033, A1-C03-L01-V036]}
  pool_letters: "A2 · B4 · C5 over the 11 lettered items (P012 is a tile task) — a drawn
    pool, not a seated form; distribution reported for the audit trail."
  regeneration_rule: "Beyond the pool, the app regenerates from canon templates (greeting
    × scene; country × map; job × article; name/spelling; digits; profile line; introduce
    chain), drawing referents ONLY from bible canon — flagged for owner review before any
    generated item ships (no unregistered facts, ever)."
```

---

## §3 Results and next path (S28 · ILL015)

```yaml
results_routing:
  scored_points: 47                   # V12 + G11 + LS10 + RD6 + CN6 + W2
  component_floors: [V, G, LS, "conversation = CN6 + SM01 completion"]
  pass:
    rule: "≥80% of 47 (≥38 points) AND every component floor ≥70% AND SM01 completed"
    screen: "ILL015 — the helper badge with a full star ring. AUD050 (pass encouragement)."
    next: "Chapter 5 — My Family and the People I Know (Arc 2 opens)."
  near_pass:
    rule: "70–79% overall (33–37 points), or exactly one component floor missed"
    screen: "one dim star on the ring + the clinic icon"
    route: "rerun of the matching clinic (CL1 for be-agreement misses, CL2 for frame
      misses; V-floor misses route to the L1 retrieval set) + alternate short form
      B001–015; a B-form pass at ≥80% converts to PASS (parallel evidence, same gate)."
  below_70:
    rule: "<70% (<33 points), or two or more floors missed"
    screen: "the badge with an open hand icon — no shame framing, no red"
    route: "personalised review loop: per-section circuit of the weakest spans (L1
      retrieval set → CL1 → L2 retrieval set → CL2), then B-form, then a fresh retry."
  retries:
    rule: "Unlimited. First retry draws the P-pool; later retries follow the documented
      regeneration rule (canon-referent templates, owner-flagged). Never the same item
      twice in a row; retries are parallel, never punitive."
  honesty_note: "Latency, replays, hints, and the tap path never reduce scores. The app
    logs diagnostics; the gate reads points and completion only."
```

**AUD050** — `results_pass` · guide + Alex · learning_slow_clear

```text
GUIDE: (warm, steady) Checkpoint 1… complete! … Arc 1 — complete!
ALEX:  (bright) You're a greeter now! … My friend… my co-helper! … Okay!
```

**AUD051** — `results_near_or_below` · guide · learning_slow_clear

```text
GUIDE: (warm, never condescending) Good work. … Not done — not gone. …
One clinic, one short form. … Then again. … You and Aroa — no rush.
```

**AUD052** — `chapter_gate_audio` · guide + Alex · learning_slow_clear

```text
GUIDE: (warm) Chapter 4 is complete. … One arc, one badge, one map wall of friends.
ALEX:  (bright) Next: my family, my friends — Chapter 5! … See you there!
```

**AUD053** — `next_chapter_preview` · Nina · learning_slow_clear

```text
NINA: (patient, smiling) Chapter 5… photos! … My family, my friends. …
Who is this? … Come and see!
```

(`photos` rides as illustrated glue for the Ch5 hook; Nina's preview line is registered here first — Ch5 authors from the bible as always.)

---

## Encounter and review map (this lesson)

| Span | Targets retrieved | Where (cites) |
|---|---|---|
| C1 greetings/states/farewells | V001–V008 · V016–V020 · V026–V030 | V001–V004, V008, V011, LS001–LS004, CN002/005, RP001 T1, SM01 moves, B-form, P-pool |
| C1 grammar | G001–G003 | G001–G003, G005, LS003 |
| C2 alphabet/numbers/contact/repair | PAT001–005 · V007/V008/V017 (C2) | V005–V008, LS005–LS007, RD004/005, CN003/004, RP001 N2/N3, B-form |
| C2 grammar | G004–G006 | G006, V008 framing |
| C3 countries/languages/jobs | V012/V013/V016/V020/V021/V023/V025/V033/V036 | V009–V012, G009/G010, LS008–LS010, RD001–RD006, RP001 N4, W002, B-form, P-pool |
| C3 people/frames | V026/V029/V031/V032/V035 | CN001/CN006, W002, SM01, RP001 T5/T7 |
| C3 grammar | G007–G009 | G003/G004/G007–G011, V010 framing, W002 |

Checkpoint independence verified: all 46 items cite taught prerequisites via `reviews`; stimuli are the three fresh recordings, canon cards, and scenes — no D01 turn, no practice item, no roleplay line reappears as a checkpoint stimulus.

---

## Audio index — L3 (11 chapter scripts AUD043–053 + 4 checkpoint recordings)

| ID | slug | voice | style | used by |
|---|---|---|---|---|
| AUD043 | lesson3_open | guide + Alex | learning_slow_clear | S20 |
| AUD044 | rp_t2_name | Rafael | learning_slow_clear | RP001 T2, N2 |
| AUD045 | rp_t4_spell_phone | Rafael | learning_slow_clear | RP001 T4, N3 |
| AUD046 | rp_t6_origin_job | Rafael | learning_slow_clear | RP001 T6, N4 |
| AUD047 | rp_t8_meeting | Rafael + Amara | learning_slow_clear | RP001 T8, N5 |
| AUD048 | sm01_model | guide + Alex | learning_slow_clear | SM01 |
| AUD049 | checkpoint_intro | guide | learning_slow_clear | S23 |
| AUD050 | results_pass | guide + Alex | learning_slow_clear | S28 pass |
| AUD051 | results_near_or_below | guide | learning_slow_clear | S28 near/below |
| AUD052 | chapter_gate_audio | guide + Alex | learning_slow_clear | S28 wrap-up |
| AUD053 | next_chapter_preview | Nina | learning_slow_clear | S28 footer |
| A1-CP1-AUD001 | cp1_greetings | Sam + Nina | learning_slow_clear | LS001–LS004, V002, G005, P006 |
| A1-CP1-AUD002 | cp1_checkin | Nina + Sam | learning_slow_clear | LS005–LS007, V005/V006, CN004 |
| A1-CP1-AUD003 | cp1_profile | Kenji | learning_slow_clear | LS008–LS010, P007 |
| A1-CP1-AUD004 | cp1_b_form | Leo + Maya | learning_slow_clear | B002/B007–B009 |

Chapter audio total: **53 chapter scripts (AUD001–053) + 4 checkpoint recordings**. Two practice audios are re-performed inside the checkpoint as declared stimuli (AUD030/AUD040 for CN001/CN003) — these are reuse of *practice audio as stimulus*, flagged here for lens 4: the ITEMS are new; the audio is canon line re-performance, declared, not stimulus-sharing between checkpoint items.

---

## Illustration briefs — A1-C04-ILL012–016 (BLOCK COMPLETE, 16/16)

### ILL012 — RP001: Rafael at the door

```yaml
id: A1-C04-ILL012
purpose: "Mission roleplay scene base + SM01 door variant."
scene: "The Community House door from inside: Rafael in the doorway (denim jacket, yellow
  t-shirt, key ring), one hand raised in greeting, morning light spilling in; the learner's
  helper badge on the near table edge; Amara small by the notice board."
composition: "Door framing with light as a soft wedge; Rafael two-thirds, badge foreground
  corner, Amara soft-focus; the SM01 variant swaps Rafael for an anonymous neighbor
  silhouette (same pose, no face detail)."
must_show: [open door, Rafael waving, morning light, helper badge on table, Amara soft-focus]
must_not_show_extra: [text, logos, a depicted learner, door numbers]
continuity: "Rafael per bible newcomers table; badge design from C1-L2 S12; notice board
  from ILL005."
alt_text: "A man in a denim jacket waves from the open door of the community house; a
  helper badge lies on the table nearby."
embedding_slot: "S21/S22 hero, 3:2; SM01 variant S27"
status: placeholder
generation_prompt: "{STYLE} — an open community-house door seen from inside, a man in a
  denim jacket over a yellow t-shirt waving from the doorway in morning light, a blank
  name badge on a table edge in the foreground. MUST_SHOW: open door, waving figure,
  light wedge, badge. MUST_NOT_SHOW: {NEG}, text, door numbers, additional faces. ALT: A
  waving man at an open, sunlit community-house door."
```

### ILL013 — Checkpoint 1 cover

```yaml
id: A1-C04-ILL013
purpose: "Checkpoint cover — the test framed as the badge moment, never as threat."
scene: "The helper badge centered on the badge-table cloth, one confident star embossed
  above it; soft vignette of the hall behind (map wall edge, door light)."
composition: "Centered emblem composition, generous negative space; star in warm orange,
  never red; no clock, no countdown imagery."
must_show: [helper badge, one star above it, soft hall vignette]
must_not_show_extra: [clocks, timers, checkmarks, letters, numbers]
continuity: "Badge from C1-L2 S12; star shape from the ILL005 poster motif."
alt_text: "A helper badge with a single warm star above it, on the badge table."
embedding_slot: "S23 cover, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a blank name badge on a red lanyard centered on a cloth-
  covered table, one warm orange star floating above it, soft community-hall vignette
  behind. MUST_SHOW: badge, star, gentle depth. MUST_NOT_SHOW: {NEG}, clocks, timers,
  text. ALT: A badge with a star above it on a table."
```

### ILL014 — checkpoint listening strip

```yaml
id: A1-C04-ILL014
purpose: "Listening-section anchor — three recordings as three scene tiles."
scene: "A horizontal strip of three small connected scene tiles: (1) two figures greeting
  by a window with plants, (2) a desk with a register page and a raised finger (repeat!),
  (3) one figure with a small portfolio-card and a calm smile (profile talk)."
composition: "Even three-panel strip, thin connecting line, each tile with one clear
  focal figure; tiles light up per recording during the section."
must_show: [greeting tile, check-in tile, profile tile, connecting line]
must_not_show_extra: [letters, digits, speech bubbles with content, more than two figures per tile]
continuity: "Desk tile echoes ILL002/006; profile tile echoes ILL009's card genre."
alt_text: "A strip of three scene tiles: a greeting, a desk check-in, and a profile talk."
embedding_slot: "S25 persistent strip, 16:6"
status: placeholder
generation_prompt: "{STYLE} — a horizontal strip of three small connected illustrated
  tiles: two people greeting by a window, a check-in desk with a register page and a
  raised finger, and one person presenting a card. MUST_SHOW: three distinct tiles,
  connecting line, one focal figure each. MUST_NOT_SHOW: {NEG}, text, digits. ALT: A
  three-tile strip of a greeting, a check-in, and a profile talk."
```

### ILL015 — results: the ring of stars

```yaml
id: A1-C04-ILL015
purpose: "Results states — pass, near-pass, below — one art, three states."
scene: "The helper badge again, now with a ring of five small stars around it; states are
  app-layer: all five lit (pass), one dim (near-pass), one open outline (below — the
  outline reads as 'space to grow', never as a red mark)."
composition: "Same centered emblem as ILL013 for continuity; ring geometry even and calm."
must_show: [helper badge, ring of five star outlines]
must_not_show_extra: [red, crosses, clocks, letters]
continuity: "Direct continuation of ILL013's emblem."
alt_text: "A helper badge surrounded by a ring of five stars."
embedding_slot: "S28 hero, 1:1"
status: placeholder
generation_prompt: "{STYLE} — a blank name badge centered inside an even ring of five small
  star shapes, calm emblem composition, warm tones only. MUST_SHOW: badge, five-star ring.
  MUST_NOT_SHOW: {NEG}, red, crosses, text. ALT: A badge with a ring of five stars."
```

### ILL016 — wrap-up: the morning in one picture

```yaml
id: A1-C04-ILL016
purpose: "Arc-1 closing image — the whole welcome morning together."
scene: "The hall at late morning: the whole Arc-1 cast (Alex, Maya, Leo, Nina, Sam) plus
  Amara and Rafael gathered loosely around the badge table and the map wall; six dots
  visible; cups on the table; everyone mid-small-talk, warm and ordinary."
composition: "Group tableau in a gentle arc, no single hero; map wall left anchor, door
  light right; figures overlap naturally at small scale, faces simple."
must_show: [five cast members, Amara, Rafael, badge table, map wall with six dots, door light]
must_not_show_extra: [text, badges with writing, more than seven figures]
continuity: "All figures per model sheets/bible tables; map wall with SIX dots (ILL001);
  this image is the Arc-1 finale reference — Ch5+ may recall it."
alt_text: "Seven people gather warmly around a badge table beside a world map with six
  orange dots."
embedding_slot: "S28 wrap-up, 16:9"
status: placeholder
generation_prompt: "{STYLE} — a warm late-morning community-hall tableau: seven diverse
  people gathered loosely around a table with cups and blank badges, a world map with six
  orange dots on the wall behind, sunlight from an open door. MUST_SHOW: seven figures,
  table, dotted map wall, door light. MUST_NOT_SHOW: {NEG}, text, more figures, flags.
  ALT: Seven people gather around a table beside a dotted world map."
```

---

## Screens and UI/UX implementation notes (S20–S28)

| Screen | Content | UI/UX tips |
|---|---|---|
| S20 | Story + mission final card | AUD043; three stars lit, door star pulsing once (reduced-motion: static); "one thing left" framing — no countdown anywhere. |
| S21 | RP001 setup | ILL012 with the turn-cap shown as eight small dots; voice/tap path choice offered as equal buttons (never a hierarchy); guardrails summarized in one line. |
| S22 | RP001 run | One turn per card; Rafael's lines replayable any time; stall → single icon re-prompt; completion plays AUD047 tail + star; exit to pause banner. |
| S23 | Checkpoint cover | ILL013; section map (V·G·LS·RD·CN·W·SM) with honest time note "≈ 20–25 min"; save + resume mid-checkpoint; no exit-without-save. |
| S24 | V + G sections | One item per card, no back-navigation within the checkpoint (independence), but pause-and-resume allowed; digit tiles grouped 3+3. |
| S25 | LS section | ILL014 strip; each recording auto-plays once with its tile; replay button appears after response; transcripts release only after the section ends. |
| S26 | RD + CN sections | Cards render over canon card art; text lines pace-reveal on first read; no stimulus carries app-layer highlighting until a help rung fires. |
| S27 | W tiles + SM01 | W001 slots with skip chips; W002 bank with soft cross-outs on rung 1; SM01 voice/tap choice equal-weight; recording UI shows the pulse, never a waveform-judgment. |
| S28 | Results + routing + wrap-up | ILL015 states; score shown as stars + section bars (never a red percentage); near/below routes read as paths, not verdicts; ILL016 wrap-up + AUD052 + AUD053 preview; chapter gate message renders here. |

All screens: WCAG-AA, ≥44 pt targets, no color-only meaning, alt text, save at boundaries, reduced-motion variants, English-only chrome.

---

## Self-check (authoring session 14)

**Counts vs manifest** — roleplay 1/1 (RP001, 8-turn cap, 5 required + 3 optional slots, guardrails, N1–N5 alternative) · checkpoint 46/46 (V12 · G11+1 tile · LS10 · RD6 · CN6 = 45 choice + 1 tile) · tile tasks 2/2 (W001–002) · speaking mission 1/1 (SM01, dual path) · recordings 3/3 + B-form recording 1 · alternate form 15/15 (B001–015) · parallel pool 12/12 (P001–012 + regeneration rule) · results routing 1/1 · audio 15/15 (AUD043–053 + CP-AUD001–004) · illustration briefs 5/5 (ILL012–016; **block complete 16/16**) · screens 9/9 (S20–S28; chapter 28/28). Zero new ledger rows — verified. ✓

**Truncation scan** — 0 `TBD`/`TODO`; 0 continuation markers; every yaml block closed. ✓

**Answer-key balance audit** — Checkpoint 45 choice items, letters as written: V — A4 (V001/004/007/010) · B4 (V002/005/008/011) · C4 (V003/006/009/012). G — A3 (G001/004/007) · B4 (G002/005/008/009) · C4 (G003/006/010/011). LS — A4 (LS003/006/007/008) · B3 (LS001/005/009) · C3 (LS002/004/010). RD — A1 (RD003) · B2 (RD001/RD004) · C3 (RD002/RD005/RD006). CN — A3 (CN001/CN003/CN006) · B2 (CN002/CN005) · C1 (CN004). **Totals: A15 · B15 · C15.** B-form 15 items: **5/5/5** (audited in `b_form_letters`). P-pool: 2/4/5 over 11 lettered items (drawn pool, reported). RP001 N-nodes: A1/B2/C2. ✓

**Instruction-lexicon stage audit** — listen · look · tap · choose · match · say · repeat · put in order · first · next · last · one · two · again · correct · try again · read · answer · record · play · check — all stage-legal; "sort" unused; SM01's tap path needs no stage-4 words. ✓

**Red-team pass (in-session fixes recorded — 7, the busiest session of the chapter)** — (1) V006's key pointed at C while the correct value sat at A: options reordered; (2) V008 mixed an audio reference into a text-scenario item: rewritten as a clean text/visual situation item; (3) the G-block shipped with an inline "see fix note" correction trail on G005/G006: both records rewritten clean with correct keys; (4) LS004's key was semantically wrong (high sun ≠ morning): corrected to the sun-low scene with the scene-grammar rationale; (5) the B-form's first pass put all 15 keys at A with an unresolved draft note: options reordered to 5/5/5 and the note replaced with the audited distribution; (6) the P-pool's letters skewed 7/2/1: reordered to 2/4/5 and reported; (7) the closing verification grep caught the RD/CN blocks and the N-nodes off-plan (file 15/17/13; N-nodes 4/1/0) while the self-check claimed balance: RD005 and CN004 remapped B→C and N3/N4→C, N5→B, both breakdowns rewritten to match the file — the audit reads the file, never the intention.

**Lens spot-checks** — L1 dependencies: all 46+15+12 items cite taught prerequisites; Rafael's and Amara's lines stay inside taught frames; "I speak Portuguese and English" is taught recombination. L2 pedagogy: checkpoint follows the §9.4 section order; help ladders live in the app layer per checkpoint policy. L3: no new micro-sets (review). L4 assessment: checkpoint independence verified (three declared recordings only; practice-audio reuse for CN001/CN003 declared in the audio index); gate arithmetic checked: 47 points, 80% = 38, floors per component; B-form conversion rule stated. L5 audio: 15 scripts; challenge/learning split where required. L6 grounding: all facts canon (Sam's 4-0-1 7-3-2, Leo's card, Kenji's profile, Rafael's card registered in the bible this session). L7 test construction: 15/15/15 audited above. L8 inclusion: singular they maintained (G007); gender-varied job art; no name-derived pronoun inference (Amara/Rafael fixed in the bible). L9 sensitivity: origins voluntary; no status language; no `Good night` as option anywhere (N-node set and all 60+ option sets checked); no alcohol/gambling/dating. L10 continuity: ILL016 group scene matches the cast + newcomers; Nina's Ch5 preview line registered. L11 accessibility: 9 screens with tips; WCAG-AA; reduced-motion. L12: no typing; skip paths; SM01 dual path; latency/replays never scored. L13: verified above. L14: six catches, all fixed before the gate.

**Chapter close carried to the wrap-up** — QA report (`07_quality/A1_C04_QA_REPORT.md`), STATE.md consolidation, QA_STATUS rows, ILL register completion, and the chapter gate with the compact tip follow this lesson file.



