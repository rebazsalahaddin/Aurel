# A1 — Chapter 3 — Lesson 3 (A1-C03-L03) — Profiles, Your Introduction, the Chapter Quiz

```yaml
lesson_id: A1-C03-L03
lesson_type: R+M                      # reading + writing + listening + roleplay + mission + quiz
chapter: 3                            # CHAPTER CLOSER
title: "Where Are You From? — Part 3: Profile Cards and Your Dot"
estimated_minutes: 20                 # quiz and mission self-paced after
prerequisites:
  lessons: [A1-C03-L01, A1-C03-L02]   # 36 vocab records + G007–G009 all taught
  verified_against: "LEXICAL_LEDGER.csv 86 taught · GRAMMAR_LEDGER.csv 9 taught (G001–G009)"
artifacts_manifest:
  reading_items: 8                    # PR-RD001–008, 3 profile cards + a roll-list (2 text types)
  guided_writing_items: 6             # WR001–006 (tiles + punctuation; no required typing)
  listening_items: 6                  # PR-LS011–016 (identity profiles + roll-call + transfer)
  conversation_prep_items: 4          # PR-CV013–016 (roleplay rehearsal)
  roleplay: 1                         # A1-C03-RP001, §10.9 contract + non-voice alternative
  mission: 1                          # "Your Dot on the Wall" (ILL034)
  quiz_form_A: 32                     # L5·N5·V5·G6·LS5·RD4·CN2; cumulative 8/32 = 25% (ceiling, flagged)
  clinic_seeds: 4                     # C3-CLIN-A…D (remediation map)
  spaced_review_export: 1
  audio_scripts: 11                   # A1-C03-AUD057…AUD067
  illustration_briefs: 6              # A1-C03-ILL031…ILL036 — C3 BLOCK COMPLETE (36/36)
  screens: 10                         # A1-C03-S23…S32
macro_definitions_for_F3:
  STYLE: >-
    Original modern editorial illustration, organic shapes, clean line work, restrained
    texture, generous negative space, cream background, warm orange and terracotta accents,
    soft brown lines, charcoal detail, one muted green and one muted blue as secondary
    support, WCAG-AA contrast, readable at small size
  NEG: >-
    photorealism, text, letters, numbers, logos, watermarks, clutter, glossy 3D,
    stereotypes, distorted hands, duplicate objects, flags, national symbols
bible_additions_this_lesson: "Kenji (one-off profile figure) + 4 known-facts rows —
  registered BEFORE authoring (§5.5)."
privacy_guardrail: >-
  The mission and roleplay NEVER request the learner's real origin, documents, or status.
  Any of the ten taught countries is a correct choice; a skip path exits with no penalty.
```

---

# S23 — Reading: three profile cards + the class roll

**Text type 1 — profile cards (fields are app-layer labels over textless art):**

| card | art | fields (app-layer) |
|---|---|---|
| MAYA | [ILL: A1-C03-ILL031 | alt: portrait of Maya in green scrubs with her star pin, smiling] | Name: Maya · Country: Egypt · Languages: Arabic and English · Job: nurse · Email: maya.haddad@aroa.com |
| KENJI | [ILL: A1-C03-ILL032 | alt: portrait of a calm man with short black hair and a blue jacket over a grey shirt] | Name: Kenji · Country: Japan · Languages: Japanese and English · Job: engineer |
| ALEX | [ILL: A1-C03-ILL033 | alt: portrait of Alex with round glasses and mustard sweater, sketchbook under one arm] | Name: Alex · Country: Canada · Languages: English and French · Job: designer · Email: alex.kim@aroa.com |

**Text type 2 — the class roll (a two-column list, app-layer):**

```
THE CLASS — 6 PEOPLE
Maya — Egypt — nurse        Kenji — Japan — engineer
Alex — Canada — designer    Nina — Peru — teacher
Leo — Australia — cook      Sam — Mexico — (no job listed)
```

Creator note: Sam's real job (shop assistant) is not in the taught nine, so his roll row lists country only — and RD007 turns that empty cell into the reading check.

## Reading items PR-RD001–008

```yaml
id: A1-C03-L03-PR-RD001
type: profile_detail                      # 3 options
instruction_words: [read, choose]
stimulus: "MAYA card"
question: "Maya is from ____."
options: [{id: A, text: Egypt}, {id: B, text: Spain}, {id: C, text: Kenya}]
correct_option_ids: [A]
distractor_rationales:
  B: "Spain — Spanish-speaking pull (Maya is not in the Spain group)"
  C: "Kenya — Swahili-and-English country; card says Arabic and English"
feedback_correct: "Egypt — card line 2."
feedback_incorrect: "Check the Country line on the card."
prerequisite_ids: [A1-C03-L01-V010]
```

```yaml
id: A1-C03-L03-PR-RD002
type: profile_detail                      # 3 options
instruction_words: [read, choose]
stimulus: "KENJI card"
question: "Kenji is a(n) ____."
options: [{id: A, text: cook}, {id: B, text: driver}, {id: C, text: engineer}]
correct_option_ids: [C]
distractor_rationales:
  A: "cook — Leo's job; wrong card"
  B: "driver — job-set neighbor"
feedback_correct: "An engineer — card line 4."
feedback_incorrect: "Check the Job line on the card."
prerequisite_ids: [A1-C03-L01-V021, A1-C03-L02-G009]
```

```yaml
id: A1-C03-L03-PR-RD003
type: profile_detail                      # 3 options
instruction_words: [read, choose]
stimulus: "ALEX card"
question: "____ email is alex.kim@aroa.com."
options: [{id: A, text: His}, {id: B, text: Her}, {id: C, text: Their}]
correct_option_ids: [C]
distractor_rationales:
  A: "Alex's word is they → their (bible)"
  B: "same — the person, not the picture, gives the word"
feedback_correct: "Their email — Alex is they."
feedback_incorrect: "Alex → they → their."
prerequisite_ids: [A1-C03-L02-G007, A1-C03-L02-G008]
```

```yaml
id: A1-C03-L03-PR-RD004
type: profile_detail                      # 3 options
instruction_words: [read, choose]
stimulus: "ALEX card"
question: "Alex speaks English and ____."
options: [{id: A, text: French}, {id: B, text: Arabic}, {id: C, text: Swahili}]
correct_option_ids: [A]
distractor_rationales:
  B: "Arabic — Maya's language; wrong card"
  C: "Swahili — Kenya's language; not on this card"
feedback_correct: "English and French — Canada's two official languages."
feedback_incorrect: "Check the Languages line."
prerequisite_ids: [A1-C03-L01-V007]
```

```yaml
id: A1-C03-L03-PR-RD005
type: roll_list_lookup                    # 3 options
instruction_words: [read, choose]
stimulus: "class roll"
question: "Who is the teacher?"
options: [{id: A, text: Kenji}, {id: B, text: Maya}, {id: C, text: Nina}]
correct_option_ids: [C]
distractor_rationales:
  A: "Kenji — the engineer row"
  B: "Maya — the nurse row is right above"
feedback_correct: "Nina — Peru, teacher."
feedback_incorrect: "Scan the job column, then read the name."
prerequisite_ids: [A1-C03-L01-V018]
```

```yaml
id: A1-C03-L03-PR-RD006
type: roll_list_lookup                    # 3 options
instruction_words: [read, choose]
stimulus: "class roll"
question: "Who is from Australia?"
options: [{id: A, text: Leo}, {id: B, text: Sam}, {id: C, text: Alex}]
correct_option_ids: [A]
distractor_rationales:
  B: "Sam — Mexico row neighbor"
  C: "Alex — Canada row neighbor"
feedback_correct: "Leo — Australia, cook."
feedback_incorrect: "Scan the country column, then read the name."
prerequisite_ids: [A1-C03-L01-V011]
```

```yaml
id: A1-C03-L03-PR-RD007
type: roll_list_inference                  # 3 options
instruction_words: [read, choose]
stimulus: "class roll (Sam row has no job listed)"
question: "The roll has six names. How many jobs are on the roll?" 
options: [{id: A, text: "six"}, {id: B, text: "five"}, {id: C, text: "ten"}]
correct_option_ids: [B]
distractor_rationales:
  A: "six — one per name; but Sam's row lists NO job"
  C: "ten — the countries count, not the jobs"
feedback_correct: "Five jobs — Sam's row has no job. Careful readers win!"
feedback_incorrect: "Count only the rows WITH a job word."
prerequisite_ids: [A1-C02-L02-PAT004, A1-C03-L01-V017–V025]
note: "reading CHECK item — the empty cell is the point, not a trick: the roll visibly
  shows five job words"
```

```yaml
id: A1-C03-L03-PR-RD008
type: match_person_profile                # 3-way match, all three cards
instruction_words: [read, match]
stimulus: "three shuffled mini-profiles (app-layer): 'a nurse from Egypt' · 'a designer
  from Canada' · 'an engineer from Japan' → match to MAYA / KENJI / ALEX cards"
target_ids: [A1-C03-L01-V020, A1-C03-L01-V022, A1-C03-L01-V021]
solution: {"a nurse from Egypt": MAYA, "a designer from Canada": ALEX, "an engineer from Japan": KENJI}
feedback_correct: "Person + country + job — the full profile read!"
feedback_incorrect: "Match the job word first, then the country."
prerequisite_ids: [A1-C03-L01-V007, A1-C03-L01-V010, A1-C03-L01-V013]
```

---

# S24 — Guided writing (WR001–006, tiles only — no required typing)

```yaml
id: A1-C03-L03-WR001
type: tile_sentence_build
instruction_words: [put, in, order]
tiles: [Maya, is, Egypt, from, This is, She]
target_sentence: "This is Maya. She is from Egypt."
alt_accepted: ["This is Maya. She's from Egypt."]
feedback_correct: "Introduce, then the country — two clean sentences."
feedback_incorrect: "First sentence: This is + name. Second: She is from + country."
prerequisite_ids: [A1-C03-L01-V029, A1-C03-L02-G007]
```

```yaml
id: A1-C03-L03-WR002
type: tile_sentence_build
instruction_words: [put, in, order]
tiles: [is, an, Kenji, engineer]
target_sentence: "Kenji is an engineer."
feedback_correct: "An before the vowel sound — engineer!"
feedback_incorrect: "Name first, then is, then an + job."
prerequisite_ids: [A1-C03-L02-G009]
```

```yaml
id: A1-C03-L03-WR003
type: word_bank_profile                   # 2 gaps, bank of 4 tiles
instruction_words: [choose]
frame: "I'm from ____. I speak ____."
bank: [Japan, Japanese, Swahili, India]
example_context: "KENJI card as model"
solution: {gap_1: Japan, gap_2: Japanese}
feedback_correct: "Country then language — Japan, Japanese."
feedback_incorrect: "Country word first (Japan), language word second (Japanese)."
prerequisite_ids: [A1-C03-L01-V013]
```

```yaml
id: A1-C03-L03-WR004
type: punctuation_choice                   # 3 options
instruction_words: [look, choose]
question: "Which one is correct?"
options:
  - {id: A, text: "what do you do"}
  - {id: B, text: "What do you do."}
  - {id: C, text: "What do you do?"}
correct_option_ids: [C]
distractor_rationales:
  A: "no capital start, no end mark"
  B: "capital yes, but a period ends statements — questions take ?"
feedback_correct: "Big W, question mark at the end!"
feedback_incorrect: "Questions start big and end with ?"
prerequisite_ids: [A1-C03-L01-V035, A1-C01-L03-WR002]   # C1 punctuation practice
```

```yaml
id: A1-C03-L03-WR005
type: tile_sentence_build
instruction_words: [put, in, order]
tiles: [Her, Maya., name, is]
target_sentence: "Her name is Maya."
feedback_correct: "Whose-word + thing + is + name."
feedback_incorrect: "her + name comes first."
prerequisite_ids: [A1-C03-L02-G008]
```

```yaml
id: A1-C03-L03-WR006
type: mission_profile_build                # ties to S29 mission; any correct combo accepted
instruction_words: [choose]
frame: "I'm ___. I'm from ___. I'm a student. I speak ___."
choices:
  name: "learner's safe fictional choice (bank: three neutral fictional names — Sam-style
    tap-in, never their real name required; a blank-name option is allowed)"
  country: "any of the ten taught countries"
  language: "any language named in this chapter (English always valid)"
success_condition: complete frame built from tiles
feedback_correct: "Your profile! Read it out loud — this is YOU, in English."
feedback_incorrect: "Every line needs one tile. I'm + name · from + country · a student."
prerequisite_ids: [A1-C03-L01-V033, A1-C03-L01-V035, A1-C03-L01-V036]
privacy_note: "Fictional name bank + skip option; nothing is stored beyond the app session."
```

---

# S25 — Identity listening (LS011–016)

```yaml
id: A1-C03-AUD057
purpose: identity_profile_intro
voices: [MAYA]
delivery_style: learning_slow_clear
script: |
  MAYA: Hi! I'm Maya. I'm from Egypt. I'm a nurse. I speak Arabic and English.
transcript_release: after_two_passes
qa_status: script_review
```

```yaml
id: A1-C03-AUD058
purpose: identity_profile_intro_new_voice
voices: [KENJI]
delivery_style: learning_slow_clear
script: |
  KENJI: Good afternoon. I'm Kenji. I'm from Japan. I'm an engineer. I speak Japanese and English.
transcript_release: after_two_passes
qa_status: script_review
```

```yaml
id: A1-C03-AUD059
purpose: class_roll_call
voices: [NINA]
delivery_style: learning_slow_clear
script: |
  NINA: Good morning, class! … Maya — Egypt. … Kenji — Japan. … Alex — Canada. … Leo — Australia.
transcript_release: after_two_passes
qa_status: script_review
```

```yaml
id: A1-C03-L03-PR-LS011
type: listening_detail                    # 3 options
instruction_words: [listen, choose]
stimulus_audio: A1-C03-AUD057
question: "Maya is a ____."
options: [{id: A, text: teacher}, {id: B, text: nurse}, {id: C, text: doctor}]
correct_option_ids: [B]
distractor_rationales:
  A: "teacher — Nina's job; roll-call pull"
  C: "doctor — the hospital pair"
feedback_correct: "A nurse — yes!"
feedback_incorrect: "Listen after 'I'm a …'."
prerequisite_ids: [A1-C03-AUD057]
```

```yaml
id: A1-C03-L03-PR-LS012
type: listening_detail                    # 3 options
instruction_words: [listen, choose]
stimulus_audio: A1-C03-AUD058
question: "Kenji speaks ____."
options: [{id: A, text: "Arabic and English"}, {id: B, text: "English and French"}, {id: C, text: "Japanese and English"}]
correct_option_ids: [C]
distractor_rationales:
  A: "Arabic and English — Maya's pair"
  B: "English and French — Alex's pair"
feedback_correct: "Japanese and English."
feedback_incorrect: "Listen for the two language words."
prerequisite_ids: [A1-C03-AUD058]
```

```yaml
id: A1-C03-L03-PR-LS013
type: listening_detail                    # 3 map options
instruction_words: [listen, tap]
stimulus_audio: A1-C03-AUD059 (replay, entry 3)
question: "Alex — where is Alex from?"
options: map cards — Canada / Japan / Egypt
correct_option_ids: [Canada]
distractor_rationales:
  Japan: "Kenji's entry, said just before"
  Egypt: "Maya's entry, the first one heard"
feedback_correct: "Canada!"
feedback_incorrect: "The roll moves fast — catch the name first, then the country."
prerequisite_ids: [A1-C03-AUD059]
```

```yaml
id: A1-C03-L03-PR-LS014
type: listening_detail                    # 3 options
instruction_words: [listen, choose]
stimulus_audio: A1-C03-AUD059 (replay, entry 4)
question: "Leo is from ____."
options: [{id: A, text: Australia}, {id: B, text: Canada}, {id: C, text: Mexico}]
correct_option_ids: [A]
distractor_rationales:
  B: "Canada — Alex's entry just before"
  C: "Mexico — Sam's country; not called in this roll"
feedback_correct: "Australia!"
feedback_incorrect: "Name first, country second — listen again."
prerequisite_ids: [A1-C03-AUD059]
```

```yaml
id: A1-C03-L03-PR-LS015
type: listening_detail_new_voice          # 3 options — the new voice again, longer line
instruction_words: [listen, choose]
stimulus_audio: "fresh take — KENJI: Nina is my teacher. She's from Peru. Her class is great!"
question: "Who is the teacher?"
options: [{id: A, text: Maya}, {id: B, text: Nina}, {id: C, text: Kenji}]
correct_option_ids: [B]
distractor_rationales:
  A: "Maya — the other woman in the chapter"
  C: "Kenji — the speaker himself"
feedback_correct: "Nina — she's from Peru."
feedback_incorrect: "The voice says 'my teacher' — then the name."
prerequisite_ids: [A1-C03-AUD058, A1-C03-L02-G008]
note: "'great' is a taught C1 word used as a warm closer; no new content words."
```

```yaml
id: A1-C03-L03-PR-LS016
type: listening_transfer                  # 3 options — newest combination
instruction_words: [listen, choose]
stimulus_audio: "fresh take — SAM: Kenji is my friend. He isn't from Mexico. He's from Japan!"
question: "Where is Kenji from?"
options: map cards — Japan / Mexico / Kenya
correct_option_ids: [Japan]
distractor_rationales:
  Mexico: "named in the negative line — the pull"
  Kenya: "sounds like Kenji's name start (KEN-)"
feedback_correct: "Japan — after isn't Mexico, the correction says it!"
feedback_incorrect: "Listen AFTER 'isn't' — corrections give the answer."
prerequisite_ids: [A1-C03-L02-G007, A1-C03-L01-V013]
```

---

# S26 — Roleplay rehearsal (CV013–016)

Scene setup: Kenji is new at the Community House. You welcome him. Four rehearsal taps, then the live roleplay.

```yaml
id: A1-C03-L03-PR-CV013
type: best_opener                         # 3 options
instruction_words: [choose]
stimulus: "KENJI walks in (ILL032 crop). Your first line?"
options:
  - {id: A, text: "See you!"}
  - {id: B, text: "Hi! Nice to meet you!"}
  - {id: C, text: "I'm from Peru."}
correct_option_ids: [B]
distractor_rationales:
  A: "farewell at a first meeting"
  C: "your own origin — nothing asked yet"
feedback_correct: "A greeting first — nice!"
feedback_incorrect: "First meetings open with a greeting."
prerequisite_ids: [A1-C01-L02-V027]
```

```yaml
id: A1-C03-L03-PR-CV014
type: question_choice                     # 3 options
instruction_words: [choose]
stimulus: "Now ask Kenji HIS country."
options:
  - {id: A, text: "Where are you from?"}
  - {id: B, text: "What do you do?"}
  - {id: C, text: "How are you?"}
correct_option_ids: [A]
distractor_rationales:
  B: "the job question — right talk, next beat"
  C: "state question — not the country beat"
feedback_correct: "Where are you from? — the country question."
feedback_incorrect: "You want his COUNTRY — which question asks that?"
prerequisite_ids: [A1-C03-L01-V032]
```

```yaml
id: A1-C03-L03-PR-CV015
type: question_choice                     # 3 options
instruction_words: [choose]
stimulus: "Now ask Kenji HIS job."
options:
  - {id: A, text: "Where is Kenji from?"}
  - {id: B, text: "What do you do?"}
  - {id: C, text: "Are you a teacher?"}
correct_option_ids: [B]
distractor_rationales:
  A: "country question — already asked"
  C: "a yes/no guess — possible, but the open job question is the taught frame"
feedback_correct: "What do you do? — the job question."
feedback_incorrect: "The open job question starts with What."
prerequisite_ids: [A1-C03-L01-V035]
```

```yaml
id: A1-C03-L03-PR-CV016
type: introduction_choice                 # 3 options
instruction_words: [look, choose]
stimulus: "MAYA photo appears. Introduce her to Kenji."
options:
  - {id: A, text: "Her is Maya."}
  - {id: B, text: "Nice to meet you too."}
  - {id: C, text: "This is my friend Maya."}
correct_option_ids: [C]
distractor_rationales:
  A: "possessive without a noun + wrong frame"
  B: "the REPLY line, not the introducing line"
feedback_correct: "This is my friend Maya. — introduction done!"
feedback_incorrect: "Show the person: This is + my friend + name."
prerequisite_ids: [A1-C03-L01-V029, A1-C03-L02-G008]
```

---

# S27 — Roleplay A1-C03-RP001: "Welcome Kenji" (§10.9 contract)

```yaml
id: A1-C03-RP001
scenario: "Kenji is new at the Community House. You welcome him: greet, ask his country,
  ask his job, introduce one friend (Maya, Leo, Nina, or Sam photo), close."
character_card:
  name: Kenji
  voice: new performer (AUD058 bank), calm, medium-low
  personality: warm, slightly formal, gives full answers
  never: asks about the learner's documents, status, or real address; stays on the
    taught frames; if the learner stalls, Kenji re-asks with a slower take (one retry)
turn_limit: 6
learner_turn_plan:
  - T1 learner: greeting
  - T2 learner: "Where are you from?" → Kenji: "I'm from Japan."
  - T3 learner: "What do you do?" → Kenji: "I'm an engineer."
  - T4 learner: introduces a cast friend by photo → Kenji: "Nice to meet you… !"
  - T5 learner: one follow-up (Is she a nurse? / Is he a cook? …) → Kenji short answer
  - T6 learner: close ("See you!" / "Nice to meet you!")
required_slots: [greeting, origin_question, job_question, friend_introduction, close]
success_criteria:
  - "all five required slots attempted within 6 turns"
  - "frames recognizable (from-frame, a/an-frame, This-is frame)"
  - "pronoun matches the introduced friend (he/she/they)"
voice_model: learning_slow_clear for Kenji; challenge_natural_slow in a replay round
non_voice_alternative:
  mode: branching_dialogue
  nodes:
    - N1: "Kenji waves. → tap: [Hi! Nice to meet you!] [See you!] [I'm from Peru.]"
    - N2: "Ask his country. → tap: [Where are you from?] [What do you do?] [How are you?]"
    - N3: "Ask his job. → tap: [What do you do?] [Where is Kenji from?] [Are you a teacher?]"
    - N4: "MAYA photo. → tap: [This is my friend Maya.] [Her is Maya.] [Nice to meet you too.]"
    - N5: "Close. → tap: [See you, Kenji!] [Bye, Kenji!] [Nice to meet you, Kenji!]"
          (design note: evening-farewell options are deliberately NOT offered — the
          Good-night-as-farewell trap never appears as a choice anywhere in A1)
  node_solution_keys: "same as CV013–016 rehearsals — the alternative IS the rehearsal path"
scoring: "slots completed, not perfection; unlimited retries; no time pressure"
guardrails:
  - "Kenji never asks the learner's real origin; if the learner offers a country, any of
    the ten is accepted with warmth"
  - "no required typing; all learner turns are tap or voice"
  - "failure path loops to the rehearsal (S26), never a dead end"
```

---

# S28 — Mission: "Your Dot on the Wall"

[ILL: A1-C03-ILL034 | alt: the map wall close-up — five orange dots and one empty space glowing softly; a hand hovers with a sixth dot]

```yaml
id: A1-C03-MISSION-DOT
setup_audio: |
  A1-C03-AUD061 — NINA: Look — five dots, and one space for you! … Take a dot. Your
  country goes here. … Share, if you like — and any country is okay.
steps:
  - M1: choose a country card (the ten taught; a world-five or cast-five — free choice)
  - M2: place the dot on that region of the wall map (tap-to-place; the region glows)
  - M3: build your profile (WR006 tiles): "I'm ___. I'm from ___. I'm a student. I speak ___."
  - M4: Nina reads your profile back (text-to-line assembly); Alex says the closing line
completion: "SIX DOTS! … You're on the wall. Welcome home, neighbor."
privacy_note: "the choice is a game move, not a claim — skip path places a plain orange
  dot with no country and completes the mission with full stars"
bible_fact: "the learner placed their dot (known-facts row added this lesson)"
```

---

# S29 — Chapter quiz, Form A (32 items) — §10.8 records

Sections: L5 · N5 · V5 · G6 · LS5 · RD4 · CN2. **Cumulative: 8/32 = 25.0%** (at the rule's ceiling — every flagged item cites its prerequisite): N001–N005 retrieve C2 number patterns; L005 retrieves C1; V004 retrieves C2 spelling; LS003 retrieves C2 repair. Pass = 80% overall + ≥70% per core section; unlimited retries; clinics follow.

## Listening (5)

```yaml
id: A1-C03-QZ-L001
type: listening_detail                    # 3 options; audio AUD062
stimulus_audio: A1-C03-AUD062 (MAYA: "Hi! I'm Maya. I'm from Egypt.")
question: "Where is Maya from?"
options: [{id: A, text: Egypt}, {id: B, text: Peru}, {id: C, text: Mexico}]
correct_option_ids: [A]
distractor_rationales: {B: "Peru — Nina's country", C: "Mexico — Sam's country"}
feedback_correct: "Egypt."
feedback_incorrect: "Listen for 'I'm from …'."
prerequisite_ids: [A1-C03-L01-V010]
```

```yaml
id: A1-C03-QZ-L002
type: listening_detail                    # 3 options; audio AUD063
stimulus_audio: A1-C03-AUD063 (KENJI: "I'm Kenji. I'm from Japan. I'm an engineer.")
question: "Kenji is a(n) ____."
options: [{id: A, text: cook}, {id: B, text: engineer}, {id: C, text: driver}]
correct_option_ids: [B]
distractor_rationales: {A: "cook — Leo's job", C: "driver — job-set neighbor"}
feedback_correct: "An engineer."
feedback_incorrect: "The job word comes after 'I'm an …'."
prerequisite_ids: [A1-C03-L01-V021]
```

```yaml
id: A1-C03-QZ-L003
type: listening_detail                    # 3 options; audio AUD064
stimulus_audio: A1-C03-AUD064 (NINA roll: "Kenji — Japan.")
question: "Kenji is from ____."
options: [{id: A, text: Canada}, {id: B, text: Kenya}, {id: C, text: Japan}]
correct_option_ids: [C]
distractor_rationales: {A: "Canada — Alex's entry", B: "Kenya — sounds like Kenji (KEN-)"}
feedback_correct: "Japan."
feedback_incorrect: "Name first, country second."
prerequisite_ids: [A1-C03-L01-V013]
```

```yaml
id: A1-C03-QZ-L004
type: listening_detail                    # 3 options; audio AUD065
stimulus_audio: A1-C03-AUD065 (SAM: "Hi! I'm Sam. I speak Spanish and English.")
question: "Sam speaks ____."
options: [{id: A, text: "Arabic and English"}, {id: B, text: "English and French"}, {id: C, text: "Spanish and English"}]
correct_option_ids: [C]
distractor_rationales: {A: "Maya's pair", B: "Alex's pair"}
feedback_correct: "Spanish and English."
feedback_incorrect: "Catch the two language words."
prerequisite_ids: [A1-C03-L01-V008]
```

```yaml
id: A1-C03-QZ-L005
type: listening_reply                     # 3 options; audio AUD066 — CUMULATIVE (C1)
cumulative_flag: true
prerequisites_note: "retrieves A1-C01-L01-V003 good morning"
stimulus_audio: A1-C03-AUD066 (GUIDE: "Good morning!")
question: "Choose the reply."
options: [{id: A, text: "Goodbye."}, {id: B, text: "Good morning."}, {id: C, text: "See you."}]
correct_option_ids: [B]
distractor_rationales: {A: "farewell into a greeting", C: "farewell into a greeting"}
feedback_correct: "Greeting meets greeting."
feedback_incorrect: "Morning greeting → morning greeting."
prerequisite_ids: [A1-C01-L01-V003]
```

## Numbers (5 — ALL cumulative, C2 patterns)

```yaml
id: A1-C03-QZ-N001
type: canon_digits_recall                 # 3 options
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L02-PAT002–005 + C2 contact canon (Nina's card)"
stimulus: "THE CARD: phone 5-5-5, 2-0-9 (text, from C2's message card)"
question: "Whose card is this?"
options: [{id: A, text: Nina}, {id: B, text: Maya}, {id: C, text: Sam}]
correct_option_ids: [A]
distractor_rationales: {B: "Maya — phone 5-5-5, 2-0-1 (one digit off!)", C: "Sam — phone 4-0-1, 7-3-2"}
feedback_correct: "Nina's card — two zero nine."
feedback_incorrect: "Compare the last three digits: 2-0-9."
prerequisite_ids: [A1-C02-L02-PAT003, A1-C02-L03-RD005]
```

```yaml
id: A1-C03-QZ-N002
type: canon_digits_recall                 # 3 options
cumulative_flag: true
prerequisites_note: "retrieves C2 numbers + Leo's canon phone"
stimulus: "6-2-0, 1-5-4"
question: "Whose phone number?"
options: [{id: A, text: Maya}, {id: B, text: Leo}, {id: C, text: Alex}]
correct_option_ids: [B]
distractor_rationales: {A: "Maya — 5-5-5, 2-0-1", C: "Alex — email canon, no phone taught"}
feedback_correct: "Leo — from the Chapter 2 check-in!"
feedback_incorrect: "Leo's number ends 1-5-4."
prerequisite_ids: [A1-C02-L04-AUD078]
```

```yaml
id: A1-C03-QZ-N003
type: number_identification               # 3 options
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L02-PAT004 (11–15) + PAT005 (16–20)"
stimulus: "tap the number you see: 13"
options: [{id: A, text: "3"}, {id: B, text: "13"}, {id: C, text: "12"}]
correct_option_ids: [B]
distractor_rationales:
  A: "3 — the ones digit only"
  C: "12 — the -teen neighbor"
authoring_note: "an early draft offered 30 as a distractor — above the taught 0–20 range;
  replaced with 12 (both slips stay inside taught numbers)"
feedback_correct: "13 — thirteen."
feedback_incorrect: "Thirteen: 1-3."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C03-QZ-N004
type: number_word_match                   # 3 options
cumulative_flag: true
prerequisites_note: "retrieves C2 numbers (confusable pair seven/seventeen)"
stimulus: "the word: seventeen"
question: "Tap the digits."
options: [{id: A, text: "7"}, {id: B, text: "11"}, {id: C, text: "17"}]
correct_option_ids: [C]
distractor_rationales: {A: "seven — the classic mishear", B: "eleven — the other -een neighbor"}
feedback_correct: "17 — seventeen."
feedback_incorrect: "Seventeen has the -teen: 17."
prerequisite_ids: [A1-C02-L02-PAT004]
```

```yaml
id: A1-C03-QZ-N005
type: number_identification               # 3 options
cumulative_flag: true
prerequisites_note: "retrieves C2 numbers (confusable pair two/twelve/twenty-range)"
stimulus: "tap the number you see: 12"
options: [{id: A, text: "2"}, {id: B, text: "10"}, {id: C, text: "12"}]
correct_option_ids: [C]
distractor_rationales:
  A: "2 — the first digit only (two/twelve mishear)"
  B: "10 — the ten/twelve neighbor"
feedback_correct: "12 — twelve."
feedback_incorrect: "Twelve: 1-2."
prerequisite_ids: [A1-C02-L02-PAT004]
```

## Vocabulary (5)

```yaml
id: A1-C03-QZ-V001
type: map_to_word                         # 3 options
stimulus: "ILL008 map card (Brazil region highlighted)"
question: "Which country?"
options: [{id: A, text: Spain}, {id: B, text: Brazil}, {id: C, text: India}]
correct_option_ids: [B]
distractor_rationales: {A: "Spain — southern-hemisphere shape pull", C: "India — big-region pull"}
feedback_correct: "Brazil!"
feedback_incorrect: "Look at the highlighted region's shape and place."
prerequisite_ids: [A1-C03-L01-V012]
```

```yaml
id: A1-C03-QZ-V002
type: image_to_word                       # 3 options
stimulus: "ILL020 job card (Leo at the café kitchen)"
question: "Leo is a ____."
options: [{id: A, text: cook}, {id: B, text: driver}, {id: C, text: doctor}]
correct_option_ids: [A]
distractor_rationales: {B: "driver — /-er/ word pull", C: "doctor — job-set neighbor"}
feedback_correct: "A cook!"
feedback_incorrect: "The café kitchen says cook."
prerequisite_ids: [A1-C03-L01-V024]
```

```yaml
id: A1-C03-QZ-V003
type: word_bank_gap                       # 3 tiles
stimulus: "One person. Ten ____."
options: [{id: A, text: people}, {id: B, text: person}, {id: C, text: friends}]
correct_option_ids: [A]
distractor_rationales: {B: "person = one; ten needs many", C: "friends — countable but the
  taught many-word for person is people"}
feedback_correct: "Ten people!"
feedback_incorrect: "Many persons = people."
prerequisite_ids: [A1-C03-L01-V028, A1-C02-L01-PAT003]
```

```yaml
id: A1-C03-QZ-V004
type: spelling_choice                     # 3 options — CUMULATIVE (C2)
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L01-V001 spell + PAT001 alphabet, on a C3 word"
stimulus: "How do you spell that? — the country: PERU"
options: [{id: A, text: P-R-E-U}, {id: B, text: P-E-R-O}, {id: C, text: P-E-R-U}]
correct_option_ids: [C]
distractor_rationales: {A: "letter-order swap (the C2 repair skill)", B: "last-vowel slip"}
feedback_correct: "P-E-R-U."
feedback_incorrect: "Say it slowly: Pe-ru."
prerequisite_ids: [A1-C02-L01-V001, A1-C02-L01-V007]
```

```yaml
id: A1-C03-QZ-V005
type: best_reply                          # 3 options
stimulus: 'MAYA: "Nice to meet you."'
options: [{id: A, text: "See you."}, {id: B, text: "Nice to meet you too."}, {id: C, text: "I'm good."}]
correct_option_ids: [B]
distractor_rationales: {A: "farewell at a first meeting", C: "state answer, no state question"}
feedback_correct: "Nice to meet you too!"
feedback_incorrect: "Return the meeting line — with too."
prerequisite_ids: [A1-C03-L01-V031]
```

## Grammar (6)

```yaml
id: A1-C03-QZ-G001
type: pronoun_form_choice                 # 3 options
stimulus: "Alex is my friend. ____ a designer."
options: [{id: A, text: He's}, {id: B, text: They're}, {id: C, text: She's}]
correct_option_ids: [B]
distractor_rationales: {A: "Alex's word is they (bible)", C: "same — person over picture"}
feedback_correct: "They're a designer."
feedback_incorrect: "Alex → they → they're."
prerequisite_ids: [A1-C03-L02-G007]
```

```yaml
id: A1-C03-QZ-G002
type: form_choice                         # 3 options
stimulus: "Where ____ Maya from?"
options: [{id: A, text: am}, {id: B, text: are}, {id: C, text: is}]
correct_option_ids: [C]
distractor_rationales: {A: "am — I only", B: "are — they/we/you"}
feedback_correct: "Where is Maya from? — Egypt."
feedback_incorrect: "One person → is."
prerequisite_ids: [A1-C03-L01-V034, A1-C03-L02-G007]
```

```yaml
id: A1-C03-QZ-G003
type: short_answer_choice                 # 3 options
stimulus: 'Are Maya and Sam from Mexico?'
options: [{id: A, text: "Yes, they are."}, {id: B, text: "No, she isn't."}, {id: C, text: "No, they aren't."}]
correct_option_ids: [C]
distractor_rationales: {A: "Maya is from Egypt — the pair is not both-Mexico", B: "she — the
  question says they (two people)"}
feedback_correct: "No, they aren't. Sam is — Maya isn't!"
feedback_incorrect: "Two people → they; and check Maya's country."
prerequisite_ids: [A1-C03-L02-G007, A1-C03-L01-V008, A1-C03-L01-V010]
```

```yaml
id: A1-C03-QZ-G004
type: possessive_choice                   # 3 options
stimulus: "LEO photo + phone icon: ____ phone is 6-2-0, 1-5-4."
options: [{id: A, text: His}, {id: B, text: Her}, {id: C, text: Our}]
correct_option_ids: [A]
distractor_rationales: {B: "her — Maya's word", C: "our — the group's word"}
feedback_correct: "His phone."
feedback_incorrect: "Leo → he → his."
prerequisite_ids: [A1-C03-L02-G008]
```

```yaml
id: A1-C03-QZ-G005
type: article_choice                      # 2 options
stimulus: "Maya is ____ nurse."
options: [{id: A, text: a}, {id: B, text: an}]
correct_option_ids: [A]
distractor_rationales: {B: "nurse starts with /n/ — a"}
feedback_correct: "A nurse — the sound decides."
feedback_incorrect: "NURSE starts /n/ → a."
prerequisite_ids: [A1-C03-L02-G009]
```

```yaml
id: A1-C03-QZ-G006
type: short_answer_choice                 # 3 options
stimulus: 'Is Nina a teacher?'
options: [{id: A, text: "Yes, she is."}, {id: B, text: "Yes, she are."}, {id: C, text: "Yes, he is."}]
correct_option_ids: [A]
distractor_rationales: {B: "she never takes are", C: "the question says she"}
feedback_correct: "Yes, she is!"
feedback_incorrect: "Copy the question's person: she."
prerequisite_ids: [A1-C03-L02-G007]
```

## Conversation (5)

```yaml
id: A1-C03-QZ-LS001
type: best_reply                          # 3 options
stimulus: 'SAM: "What do you do?"'
options: [{id: A, text: "I'm from Peru."}, {id: B, text: "I'm an engineer."}, {id: C, text: "My name is Peru."}]
correct_option_ids: [B]
distractor_rationales: {A: "from-frame; wrong question", C: "name-frame collision"}
feedback_correct: "I'm an engineer."
feedback_incorrect: "Job question → job frame."
prerequisite_ids: [A1-C03-L01-V035, A1-C03-L02-G009]
```

```yaml
id: A1-C03-QZ-LS002
type: best_next_turn                      # 3 options
stimulus: 'YOU: "This is my friend Kenji."'
options: [{id: A, text: "See you!"}, {id: B, text: "I'm good."}, {id: C, text: "Nice to meet you!"}]
correct_option_ids: [C]
distractor_rationales: {A: "farewell at an introduction", B: "state answer, no state question"}
feedback_correct: "Nice to meet you!"
feedback_incorrect: "A new person arrives — the meeting reply."
prerequisite_ids: [A1-C03-L01-V029, A1-C01-L02-V027]
```

```yaml
id: A1-C03-QZ-LS003
type: repair_choice                       # 3 options; audio AUD067 — CUMULATIVE (C2)
cumulative_flag: true
prerequisites_note: "retrieves A1-C02-L01-V008 Can you repeat that, please?"
stimulus_audio: A1-C03-AUD067 (SAM says his phone number fast: "four zero one, seven three two!")
question: "Too fast! What do you say?"
options: [{id: A, text: "Can you repeat that, please?"}, {id: B, text: "How do you spell that?"}, {id: C, text: "Nice to meet you too."}]
correct_option_ids: [A]
distractor_rationales: {B: "spelling repair — for WORDS, not numbers", C: "greeting reply; no greeting here"}
feedback_correct: "Can you repeat that, please? — the C2 repair lives!"
feedback_incorrect: "Numbers need a REPEAT, not a spelling."
prerequisite_ids: [A1-C02-L01-V008, A1-C02-L01-V007]
```

```yaml
id: A1-C03-QZ-LS004
type: intent_choice                       # 3 options
stimulus: 'ALEX: "Where is Nina from?"'
options: [{id: A, text: "Nina's job"}, {id: B, text: "Nina's country"}, {id: C, text: "Nina's name"}]
correct_option_ids: [B]
distractor_rationales: {A: "job questions ask What do you do?", C: "name questions ask What's your name?"}
feedback_correct: "Her country — Where + from."
feedback_incorrect: "WHERE asks a place."
prerequisite_ids: [A1-C03-L01-V034]
```

```yaml
id: A1-C03-QZ-LS005
type: constrained_branch                  # 3 options
branch_context: "YOU are from Brazil. Kenji asks…"
stimulus: 'KENJI: "Are you from Japan?"'
options: [{id: A, text: "Yes, I am."}, {id: B, text: "No, she isn't."}, {id: C, text: "No, I'm not. I'm from Brazil."}]
correct_option_ids: [C]
distractor_rationales: {A: "contradicts the branch fact", B: "she — the question says you"}
feedback_correct: "No, I'm not. I'm from Brazil — your facts, your answer."
feedback_incorrect: "Check WHO is asked and WHERE you are from."
prerequisite_ids: [A1-C02-L02-G004, A1-C03-L01-V012]
```

## Reading (4)

```yaml
id: A1-C03-QZ-RD001
type: profile_detail                      # 3 options
stimulus: "MAYA profile card"
question: "Maya's job?" → "Maya is a ____."
options: [{id: A, text: nurse}, {id: B, text: teacher}, {id: C, text: doctor}]
correct_option_ids: [A]
distractor_rationales: {B: "teacher — Nina's card neighbor", C: "doctor — the hospital pair"}
feedback_correct: "A nurse."
feedback_incorrect: "Read the Job line."
prerequisite_ids: [A1-C03-L01-V020]
```

```yaml
id: A1-C03-QZ-RD002
type: profile_detail                      # 3 options
stimulus: "KENJI profile card"
question: "Kenji is from ____."
options: [{id: A, text: Japan}, {id: B, text: Kenya}, {id: C, text: Canada}]
correct_option_ids: [A]
distractor_rationales: {B: "Kenya — KEN- sound pull", C: "Canada — Alex's card neighbor"}
feedback_correct: "Japan."
feedback_incorrect: "Read the Country line."
prerequisite_ids: [A1-C03-L01-V013]
```

```yaml
id: A1-C03-QZ-RD003
type: roll_list_lookup                    # 3 options
stimulus: "class roll"
question: "Who is the cook?"
options: [{id: A, text: Leo}, {id: B, text: Kenji}, {id: C, text: Sam}]
correct_option_ids: [A]
distractor_rationales: {B: "Kenji — engineer row", C: "Sam — no job on the roll!"}
feedback_correct: "Leo — Australia, cook."
feedback_incorrect: "Scan the job column."
prerequisite_ids: [A1-C03-L01-V024]
```

```yaml
id: A1-C03-QZ-RD004
type: profile_detail                      # 3 options
stimulus: "ALEX profile card"
question: "Alex speaks English and ____."
options: [{id: A, text: Arabic}, {id: B, text: French}, {id: C, text: Japanese}]
correct_option_ids: [B]
distractor_rationales: {A: "Arabic — Maya's card", C: "Japanese — Kenji's card"}
feedback_correct: "English and French."
feedback_incorrect: "Read the Languages line."
prerequisite_ids: [A1-C03-L01-V007]
```

## Culture & inclusion (2)

```yaml
id: A1-C03-QZ-CN001
type: fact_choice                         # 3 options
stimulus: "Canada's two official languages:"
options: [{id: A, text: "English only"}, {id: B, text: "English and French"}, {id: C, text: "French only"}]
correct_option_ids: [B]
distractor_rationales:
  A: "one-language claim — the inclusion rule says never"
  C: "one-language claim from the other side"
feedback_correct: "English and French — two official languages, one country."
feedback_incorrect: "Canada has TWO official languages."
prerequisite_ids: [A1-C03-L01-V007]
```

```yaml
id: A1-C03-QZ-CN002
type: fact_choice                         # 3 options
stimulus: "Kenji is from Japan. Kenji speaks ____."
options: [{id: A, text: Arabic}, {id: B, text: French}, {id: C, text: Japanese}]
correct_option_ids: [C]
distractor_rationales: {A: "Arabic — Egypt's language", B: "French — Canada's second language"}
feedback_correct: "Japanese — in Japan, they speak Japanese."
feedback_incorrect: "Japan's language is Japanese."
prerequisite_ids: [A1-C03-L01-V013]
```

---

# S30 — Results, remediation map, clinics

| clinic | trigger | seed items (author on request) | exit criterion |
|---|---|---|---|
| C3-CLIN-A "they is / they are" | G007 sort + G001/G005 misses | pronoun↔be mapping with cast cards | 8/10 correct on a fresh sort |
| C3-CLIN-B "his or her?" | G015–G021 pattern of misses | sound-first his/her drill + canon cards | 8/10 on a fresh possessive set |
| C3-CLIN-C "a or an?" | G023–G030 + QZ-G005 misses | ear-first trays (say the job, choose the tray) | 9/10 on the nine jobs |
| C3-CLIN-D "I'm from vs I'm a" | frame collisions (V010/V033/LS001 type) | question→frame routing drill | 8/10 on mixed frames |

Note: the C3 ILL block is COMPLETE (36/36) — clinic art would need a new allocation decision; the seeds above reuse chapter art.

# S31 — Spaced-review export (1/3/7/14/30 plan)

| target set | Ch4 (checkpoint 1) | later returns |
|---|---|---|
| all 36 L1 records | welcome-day mission + checkpoint quiz | jobs V017–025 → Ch7 routines; V035/V036 → Ch7 |
| G007–G009 | checkpoint grammar sweep | G008 → Ch5 G010 contrast; G009 → every job use |
| C2 patterns (0–20) | rolling (N sections) | C5 extends 21–100 |
| C1 chunks | greeting beats of the mission | Ch4 mission framing |

# S32 — Chapter complete

Stars for the three lessons; can-do checklist self-tap; preview of Chapter 4 (Checkpoint Review 1: Welcome-Day Mission — the whole first arc in one mission day).

---

# Audio index (AUD057–AUD067 — chapter block closes at 67)

| asset | purpose | script core |
|---|---|---|
| AUD057 | Maya identity intro | "I'm Maya. I'm from Egypt. I'm a nurse. I speak Arabic and English." |
| AUD058 | Kenji identity intro (NEW voice) | "I'm Kenji. I'm from Japan. I'm an engineer. I speak Japanese and English." |
| AUD059 | Nina class roll-call | Maya—Egypt · Kenji—Japan · Alex—Canada · Leo—Australia |
| AUD060 | RP001 character voice bank | Kenji greeting, answers, one slower retry take |
| AUD061 | Mission invite | Nina: five dots, one space, share-if-you-like |
| AUD062–066 | quiz L001–L005 takes | the five listening stimuli (one compact take each) |
| AUD067 | quiz LS003 take | Sam's fast phone number: "four zero one, seven three two!" |

---

# Illustration briefs ILL031–036 (block completes 36/36)

All: `status: placeholder` · `no_text_in_image: true` · card/portrait art is textless — every name, country, and job label is app-layer typography. Macros {STYLE}/{NEG} expand at F3.

| id | slot | subject + composition | generation_prompt core (single string after expansion) |
|---|---|---|---|
| A1-C03-ILL031 | Maya profile card | portrait, chest-up, scrubs + star pin | "{STYLE} SUBJECT: warm nurse portrait, dark brown wavy hair tied back, green scrubs, small star pin, warm smile. COMPOSITION: centered chest-up portrait card. MUST_SHOW: scrubs, star pin, smile. MUST_NOT_SHOW: {NEG}. ALT: portrait of Maya in her nurse scrubs with her star pin." |
| A1-C03-ILL032 | Kenji profile card | portrait, chest-up, blue jacket | "{STYLE} SUBJECT: calm engineer portrait, short black hair, blue jacket over grey shirt, gentle smile. COMPOSITION: centered chest-up portrait card, same framing as the Maya card. MUST_SHOW: blue jacket, calm smile. MUST_NOT_SHOW: {NEG}. ALT: portrait of Kenji in a blue jacket over a grey shirt." |
| A1-C03-ILL033 | Alex profile card | portrait, chest-up, glasses + sweater + sketchbook | "{STYLE} SUBJECT: bright designer portrait, short black hair, round glasses, mustard sweater, sketchbook under one arm. COMPOSITION: centered chest-up portrait card, same framing as the other two. MUST_SHOW: round glasses, sweater, sketchbook. MUST_NOT_SHOW: {NEG} plus any marks on the sketchbook. ALT: portrait of Alex with round glasses and a sketchbook." |
| A1-C03-ILL034 | mission wall | map wall close-up: five orange dots + one glowing empty space, hand with sixth dot | "{STYLE} SUBJECT: close-up of a wall world map with five orange dots and one softly glowing empty circle; a hand enters frame holding a sixth orange dot. COMPOSITION: wall fills the frame, hand lower-right. MUST_SHOW: five dots, one empty glowing circle, sixth dot in hand. MUST_NOT_SHOW: {NEG} plus any map text or borders drawn as lines with labels. ALT: a hand brings a sixth orange dot to the map wall's one empty space." |
| A1-C03-ILL035 | quiz skin 1 | ten country map cards in a festive arc | "{STYLE} SUBJECT: the ten chapter map cards (textless world maps, one orange region each) arranged in a gentle arc like cards on a table. COMPOSITION: arc across a cream field. MUST_SHOW: ten cards, ten different orange regions. MUST_NOT_SHOW: {NEG}. ALT: ten country map cards in an arc." |
| A1-C03-ILL036 | quiz skin 2 | nine job vignettes in a grid | "{STYLE} SUBJECT: the nine chapter job figures (student, teacher, doctor, nurse, engineer, designer, driver, cook, office worker) as small vignettes in a three-by-three grid. COMPOSITION: even grid, generous spacing. MUST_SHOW: nine distinct jobs, diverse and non-stereotyped. MUST_NOT_SHOW: {NEG} plus badges with marks. ALT: a three-by-three grid of the nine job vignettes." |

---

# Screen inventory and UI/UX tips (S23–S32)

| screen | content | UI/UX tips |
|---|---|---|
| A1-C03-S23 | reading: 3 profile cards + roll | cards swipeable; fields highlight on tap; roll uses two-column large type |
| A1-C03-S24 | RD001–008 | item stem scrolls WITH its card (evidence stays visible — no memory test disguised as reading) |
| A1-C03-S25 | WR001–006 | tiles only; punctuation item shows the three variants in large type; WR006 never requires real data |
| A1-C03-S26 | LS011–016 | transcripts hidden until answered; one default replay; roll-call replay offers per-entry replay |
| A1-C03-S27 | roleplay RP001 | voice OR branching alternative (N1–N5); Kenji retry offer after 8 s silence; no dead ends |
| A1-C03-S28 | mission: the dot | tap-to-place with region glow; skip path = plain dot, full stars; WR006 builds the profile |
| A1-C03-S29 | quiz Form A (32) | section headers with progress; L-section audio auto-plays once, replay allowed; no timer |
| A1-C03-S30 | results + clinics | per-section bars (pass ≥70%); clinic cards only appear for missed patterns |
| A1-C03-S31 | spaced review export | calendar-style return map; Ch4 checkpoint flagged |
| A1-C03-S32 | chapter complete | three lesson stars; can-do self-tap checklist; Ch4 preview card |

---

# Lesson self-check (lens pass at authoring time)

- **Counts:** 8 RD + 6 WR + 6 LS + 4 CV + 1 roleplay + 1 mission + 32 quiz + 4 clinic seeds + 1 spaced-review export + 11 audio (AUD057–067) + 6 ILL (ILL031–036, block complete) + 10 screens (S23–S32).
- **Cumulative rule:** 8/32 = 25.0% (ceiling of 15–25%), each flagged item citing its prerequisite: N001–N005 → C2 patterns/canon; L005 → C1 good morning; V004 → C2 spelling; LS003 → C2 repair.
- **Truncation scan:** zero unfinished fields; ellipses are sanctioned audio notation only. Two draft-stage artifacts (roll preamble note, WR003 bank) and two quiz draft blocks (N003, N005) were cleaned to single coherent records during authoring.
- **Answer-key balance:** audited by grep after writing — first pass 24 A / 15 B / 9 C; eight items remapped (RD003, RD005, LS012, CV016, N004, G002, LS002 → C; RD004 → B). Final: **16 A / 16 B / 16 C** across the 48 letter-keyed items.
- **Guardrails held:** no `Good night` anywhere (roleplay N5 documents the ban); numbers ≤20 only (N003 draft's "30" caught and replaced); no required typing; no real personal data (WR006 fictional name bank + skip); origins voluntary (mission + roleplay guardrails); flags never in art; Sam's untaught job kept off the roll's job column; bible-first for Kenji and all new facts.

