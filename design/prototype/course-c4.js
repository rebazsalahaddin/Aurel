/* A1-C04 — "Checkpoint Review 1: Welcome-Day Mission". Screen inventory S01–S28.
   Every string here is transcribed from english_course/04_A1_chapters/A1_C04/*.
   Review chapter: ZERO new targets (master prompt §9.4) — every item retrieves a
   Chapter 1–3 ledger row, cited in its own `reviews` field in the source. This
   chapter is fully authored, self-QA'd (07_quality/A1_C04_QA_REPORT.md: 12 pass,
   2 pass-after-fix) and complete — L1–L3, both clinics, the roleplay and
   Checkpoint 1 (46 choice + 2 tile + 1 speaking mission, gate 80/70) all exist in
   source. Some L2 sub-screens (guided-writing tiles, conversation rehearsal) are
   represented through their L1/L3 sibling components rather than redrawn 1:1 —
   every distinct operation and state is still designed (design prompt §16.3). */
(function () {
  var C = (window.AUREL_COURSE = window.AUREL_COURSE || { chapters: [] });
  var __guard = C.chapters.some(function (x) { return x.id === 'A1-C04'; });
  if (__guard) return;

  var ill = function (id, alt) { return { id: 'A1-C04-' + id, alt: alt }; };

  C.chapters.push({
    id: 'A1-C04', n: 4, arc: 'Meet and connect', title: 'Checkpoint Review 1: Welcome-Day Mission',
    mission: 'Join a second welcome morning, check in fast, meet two new neighbors, exchange details, introduce one person to another, and pass Checkpoint 1 — the Arc 1 gate.',
    canDos: ['greet and check in at welcome-morning speed', 'ask and answer origin, job, and contact details', 'introduce one person to another', 'complete the five-slot door mission', 'pass Checkpoint 1'],
    doNotTeach: ['possessive \u2019s', 'the definite article "the" as a target', 'past forms', 'new verbs', '"How many"', 'numbers above 20', 'whose/mine', 'nationality adjectives as productive items', "Sam's job (shop assistant)", 'the learner\u2019s own real origin or job asserted by the app'],
    lessons: [
      {
        id: 'L01', type: 'R', n: 1, title: 'Welcome Back: Hello, Spell It, Say It Again', time: '\u224820 min', pause: 'after the retrieval block, \u2248 minute 9',
        src: 'A1_C04_L01_LESSON.md',
        screens: [
          {
            id: 'S01', type: 'hook', label: 'Mission promise \u2014 a second welcome morning', step: 'STEP 1',
            lead: 'This chapter: retrieve everything from Chapters 1\u20133, meet two new neighbors, and pass Checkpoint 1 \u2014 no new words.',
            scene: 'The Community House door is open again \u2014 a welcome morning for new neighbors. Alex hands you a helper badge.',
            aud: 'A1-C04-AUD001', delivery: 'learning_slow_clear',
            ill: ill('ILL005', 'Notice board: a welcome-morning poster \u2014 sun, house, people, one star \u2014 Alex pinning it straight'),
            lines: [
              { sp: 'ALEX', t: "You're my friend! Look: one badge. It's your badge!" },
              { sp: 'GUIDE', t: 'Three steps, three lessons: today \u2014 hello, names, spelling, numbers, and one clinic on am/is/are. Lesson 2 \u2014 the welcome morning: sounds, forms, and frames. Lesson 3 \u2014 the mission and Checkpoint 1.' }
            ],
            scored: false,
            note: 'This lesson adds no new words \u2014 everything is retrieved, mixed, and used faster. Newcomers Amara Otieno and Rafael Costa are bible-registered before use; they do not speak this lesson.',
            tip: 'Full-bleed art with line-highlight sync; mission card shows three steps, one star each: \ud83d\udc4b Say hello \u00b7 \ud83d\udcdd Check in \u00b7 \ud83d\udc65 "This is my friend\u2026"',
            assets: ['A1-C04-AUD001', 'A1-C04-ILL005']
          },
          {
            id: 'S02', type: 'warmup', label: 'Recap carousel \u2014 diagnostic, unscored', step: 'STEP 2 \u00b7 \u22483 min',
            head: 'Three memories.', sub: 'Three pictures on the wall of everything Chapters 1\u20133 built. Unscored \u2014 used only to pick practice support.',
            frames: [
              { q: 'Nina \u2014 ?', icon: 'map', scene: 'ILL001 \u2014 map wall, six dots, one highlighted under Nina\u2019s region \u00b7 GUIDE: "Nina \u2014 Peru."', opts: ['Egypt', 'Peru', 'Canada'], key: 'Peru' },
              { q: 'Maya + Sam = ?', icon: 'ear', scene: 'AUD003 \u2014 MAYA: "This is my friend Sam."', opts: ['friends', 'teachers', 'students'], key: 'friends' },
              { q: 'Ten + ten = ?', icon: 'ear', scene: 'AUD004 \u2014 NINA (counting): "Ten\u2026 and ten\u2026 \u2026 twenty!"', opts: ['12', '11', '20'], key: '20' }
            ],
            note: 'RC001\u2013003 are diagnostic recap taps, not bank items \u2014 feedback names the fact, never "wrong". Beat C shows the badge table and the new welcome-morning poster (glue, untested).',
            tip: 'Three-beat carousel; one default replay per item; progress dots, not scores.',
            assets: ['A1-C04-AUD001–005', 'A1-C04-ILL001–003', 'A1-C04-ILL005']
          },
          {
            id: 'S03', type: 'practice', label: 'Cumulative retrieval \u2014 part 1 (Ch1 + Ch2)', step: 'STEP 3 \u00b7 \u22486 min',
            bank: 'A1-C04-RT001\u2013008 \u00b7 8 of 8 authored items shown',
            head: 'Faster, more mixed than Chapter 2 ever asked \u2014 exactly how the welcome morning fires it at you.',
            ladder: 'Help ladder: (1) replay, (2) highlight the frame or split the options, (3) answer with explanation.',
            items: [
              { id: 'RT001', instr: 'Listen. Tap.', icon: 'ear', scene: 'NINA: Good afternoon!', prompt: 'Morning \u00b7 afternoon \u00b7 evening?', opts: [{ id: 'A', t: 'morning scene' }, { id: 'B', t: 'afternoon scene' }, { id: 'C', t: 'evening scene' }], key: 'B', ok: "Good afternoon! The sun is high.", no: 'The sun is high \u2014 afternoon.' },
              { id: 'RT002', instr: 'Listen. Choose.', icon: 'ear', scene: 'MAYA: My name is Maya Haddad.', prompt: 'First name = ?', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Haddad' }, { id: 'C', t: 'Maya Haddad' }], key: 'A', ok: 'Maya is the first name.', no: 'Maya = first name. Haddad = last name.' },
              { id: 'RT003', instr: 'Listen. Choose.', icon: 'ear', scene: 'ALEX: Hi! How are you?', prompt: 'You say:', opts: [{ id: 'A', t: 'My name is Alex.' }, { id: 'B', t: 'See you!' }, { id: 'C', t: "I'm good, thank you. And you?" }], key: 'C', ok: 'And Alex says: "I\u2019m great."', no: "'How are you?' \u2014 you say: 'I'm good, thank you. And you?'" },
              { id: 'RT004', instr: 'Listen. Tap.', icon: 'ear', scene: 'NINA: Maya. M-A-Y-A.', prompt: 'Tap the name.', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Maia' }, { id: 'C', t: 'Mayha' }], key: 'A', ok: 'M-A-Y-A. Maya!', no: 'Listen: M\u2026 A\u2026 Y\u2026 A.' },
              { id: 'RT005', instr: 'Listen. Tap.', icon: 'ear', scene: 'LEO (quick): My phone number is 6-2-0\u2026 1-5-4.', prompt: 'Tap the phone number.', opts: [{ id: 'A', t: '6-2-0 \u00b7 1-4-5' }, { id: 'B', t: '6-2-0 \u00b7 1-5-4' }, { id: 'C', t: '2-6-0 \u00b7 1-5-4' }], key: 'B', ok: "Yes \u2014 6-2-0, 1-5-4. Leo's number.", no: 'Listen for the last group: one\u2026 five\u2026 four.' },
              { id: 'RT006', instr: 'Listen. Choose.', icon: 'ear', scene: "ALEX (fast): What's your email address?", prompt: 'Fast! You say:', opts: [{ id: 'A', t: 'Can you repeat that, please?' }, { id: 'B', t: 'How are you?' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Alex says it again \u2014 slowly.', no: "Too fast? Say: 'Can you repeat that, please?'" },
              { id: 'RT007', instr: 'Listen. Tap.', icon: 'ear', scene: 'NINA: Maya \u2014 your phone number, please? MAYA: 5-5-5\u2026 2-0-1.', prompt: "Tap Maya's card.", opts: [{ id: 'A', t: 'Nina Petrova \u00b7 5-5-5 2-0-9' }, { id: 'B', t: 'Leo Novak \u00b7 6-2-0 1-5-4' }, { id: 'C', t: 'Maya Haddad \u00b7 5-5-5 2-0-1' }], key: 'C', ok: "Yes \u2014 Maya's card: 5-5-5, 2-0-1.", no: "Listen: 'Five-five-five\u2026 two-zero-one.'" }
            ],
            tip: 'RT008 (a supported recording of the badge line: "Good morning! My name is ___. I\u2019m a ___.") is a tap-built, skippable, on-device recording \u2014 represented in the prototype by the Say-It-Aloud component, not redrawn here.',
            assets: ['A1-C04-AUD006–014']
          },
          {
            id: 'S04', type: 'practice', label: 'Clinic 1 \u2014 be + person-word agreement', step: 'STEP 4 \u00b7 \u22485\u20138 min',
            bank: 'A1-C04-CL1-002\u2013007 \u00b7 6 of 7 interactive items shown',
            head: 'One confusion: am / is / are with I \u00b7 you \u00b7 he \u00b7 she \u00b7 they \u00b7 we.',
            tip: 'The model plays first — six lines, six named referents, no response required — then these six checks. Absorbs C3-CLIN-A.',
            ladder: 'Exit criterion: 6 of 7 correct with no help above rung 2. A miss routes a parallel clinic tomorrow; Checkpoint 1 always re-samples this confusion.',
            items: [
              { id: 'CL1-002', instr: 'Listen. Tap.', icon: 'ear', scene: "MAYA: She's Nina.", prompt: 'Tap: she.', opts: [{ id: 'A', t: 'Leo' }, { id: 'B', t: 'Nina' }, { id: 'C', t: 'Sam' }], key: 'B', ok: 'She = Nina.', no: "The voice says 'She's Nina.'" },
              { id: 'CL1-003', instr: 'Read. Choose.', prompt: 'Nina ___ from Peru.', opts: [{ id: 'A', t: 'am' }, { id: 'B', t: 'are' }, { id: 'C', t: 'is' }], key: 'C', ok: "Nina is from Peru. She's from Peru.", no: 'One person (she) \u2192 is.' },
              { id: 'CL1-004', instr: 'Read. Choose.', prompt: 'Maya and Sam ___ friends.', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'is' }, { id: 'C', t: 'am' }], key: 'A', ok: "Maya and Sam are friends. They're friends.", no: 'Two people (they) \u2192 are.' },
              { id: 'CL1-005', instr: 'Read. Choose.', prompt: 'I ___ a student.', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'is' }, { id: 'C', t: 'am' }], key: 'C', ok: "I am a student. I'm a student.", no: "I \u2192 am. 'I'm a student.'" },
              { id: 'CL1-006', instr: 'Read. Choose.', prompt: "Leo isn't a doctor. He ___ a cook.", opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'is' }, { id: 'C', t: 'am' }], key: 'B', ok: "Leo is a cook. He isn't a doctor.", no: 'He \u2192 is.' },
              { id: 'CL1-007', instr: 'Listen. Put in order.', icon: 'ear', scene: "LEO: I'm from Australia.", kind: 'order', tiles: ['Australia', 'from', "I'm"], key: ["I'm", 'from', 'Australia'], ok: "'I'm from Australia.' Leo's line!", no: "First: I'm. Next: from. Last: Australia." }
            ],
            assets: ['A1-C04-AUD015–022', 'A1-C04-ILL004']
          }
        ]
      },
      {
        id: 'L02', type: 'R', n: 2, title: 'The Welcome Morning: Sounds, Forms, and Frames', time: '\u224820 min', pause: 'after the retrieval block, \u2248 minute 9',
        src: 'A1_C04_L02_LESSON.md',
        screens: [
          {
            id: 'S10', type: 'hook', label: 'Story \u2014 the morning arrives', step: 'STEP 1',
            lead: "Today's plan: countries \u2192 two doors (from vs a/an) \u2192 one long listen \u2192 a sheet and a card \u2192 your three lines \u2192 rehearsal.",
            scene: 'Sun on the Community House floor. The badge table is ready; your badge is on the table \u2014 first one.',
            aud: 'A1-C04-AUD026', delivery: 'learning_slow_clear',
            ill: ill('ILL005', 'The badge table and poster, morning light'),
            lines: [
              { sp: 'GUIDE', t: 'It is morning. The Community House is open! You and Alex \u2014 badges, table, poster. Ready?' },
              { sp: 'ALEX', t: "Okay! You're my friend, and today \u2014 you're the badge helper! You say hello. New people! New names!" }
            ],
            scored: false, note: 'Mission card step 1 (\ud83d\udc4b Say hello) earns its star today.',
            tip: 'Icon footer: \ud83c\udf0d country words \u2192 \ud83d\udeaa two doors \u2192 \ud83c\udfa7 one long listen \u2192 \ud83d\udcc4 a sheet and a card \u2192 \ud83d\udde3\ufe0f your three lines \u2192 \ud83e\udd1d rehearsal.',
            assets: ['A1-C04-AUD026', 'A1-C04-ILL005']
          },
          {
            id: 'S11', type: 'practice', label: 'Cumulative retrieval \u2014 part 2 (Ch3)', step: 'STEP 2 \u00b7 \u22486 min',
            bank: 'A1-C04-RT009\u2013016 \u00b7 8 of 8 authored items shown',
            head: 'Countries back-to-back with jobs, possessives back-to-back with the I\u2019m\u2026 frames \u2014 welcome-morning speed.',
            items: [
              { id: 'RT009', instr: 'Listen. Tap.', icon: 'ear', scene: "SAM: Hi! I'm Sam. I'm from Mexico.", prompt: 'Tap the country.', opts: [{ id: 'A', t: 'Mexico map card' }, { id: 'B', t: 'Brazil map card' }, { id: 'C', t: 'Spain map card' }], key: 'A', ok: "Mexico. Sam's country.", no: "Listen: 'Mexico.'" },
              { id: 'RT010', instr: 'Listen. Choose.', icon: 'ear', scene: 'NINA: Alex is from Canada. They speak English\u2026 and French.', prompt: 'Alex speaks:', opts: [{ id: 'A', t: 'English and Spanish' }, { id: 'B', t: 'English and Arabic' }, { id: 'C', t: 'English and French' }], key: 'C', ok: 'English and French.', no: 'Alex: English\u2026 and French.' },
              { id: 'RT011', instr: 'Look. Choose.', icon: 'eye', scene: 'Leo in the café kitchen \u2014 blue apron, pots, a pan.', prompt: 'Leo is a:', opts: [{ id: 'A', t: 'nurse' }, { id: 'B', t: 'cook' }, { id: 'C', t: 'driver' }], key: 'B', ok: 'Leo is a cook.', no: 'Pots, a pan, the kitchen \u2014 a cook!' },
              { id: 'RT012', instr: 'Read. Choose.', prompt: "Where is Nina from? \u2014 She's from ___.", opts: [{ id: 'A', t: 'Peru' }, { id: 'B', t: 'Egypt' }, { id: 'C', t: 'Kenya' }], key: 'A', ok: "Nina is from Peru. She's from Peru.", no: "Nina's dot is on Peru." },
              { id: 'RT013', instr: 'Read. Choose.', prompt: 'Nina \u2014 ___ email address: nina.petrova@aroa.com', opts: [{ id: 'A', t: 'his' }, { id: 'B', t: 'her' }, { id: 'C', t: 'their' }], key: 'B', ok: 'Her email address.', no: 'Nina is she \u2192 her.' },
              { id: 'RT014', instr: 'Read. Choose.', prompt: 'Kenji is ___ engineer.', opts: [{ id: 'A', t: 'a' }, { id: 'B', t: 'from' }, { id: 'C', t: 'an' }], key: 'C', ok: 'Kenji is an engineer.', no: "A job word takes an here. 'From' is for countries." },
              { id: 'RT015', instr: 'Listen. Choose.', icon: 'ear', scene: 'ALEX: And you \u2014 what do you do?', prompt: 'You say:', opts: [{ id: 'A', t: "I'm from Spain." }, { id: 'B', t: 'My name is Alex.' }, { id: 'C', t: "I'm a teacher." }], key: 'C', ok: "'What do you do?' \u2014 the job! 'I'm a teacher.'", no: "'What do you do?' asks the job." },
              { id: 'RT016', instr: 'Listen. Choose.', icon: 'ear', scene: 'MAYA: Alex! This is my friend Sam.', prompt: 'Alex says:', opts: [{ id: 'A', t: 'Nice to meet you, Sam!' }, { id: 'B', t: 'See you!' }, { id: 'C', t: 'Good morning!' }], key: 'A', ok: 'A new face! Nice to meet you!', no: 'The taught next line is the meeting formula.' }
            ],
            tip: 'RT014 is a deliberate diagnostic probe for clinic 2 \u2014 a miss routes into the clinic; it is never double-scored.',
            assets: ['A1-C04-AUD027–030']
          },
          {
            id: 'S12', type: 'practice', label: 'Clinic 2 \u2014 "I\u2019m from ___" vs "I\u2019m a/an ___"', step: 'STEP 3 \u00b7 \u22485\u20138 min',
            bank: 'A1-C04-CL2-002\u2013008 \u00b7 7 of 7 interactive items shown',
            head: 'The two doors of I\u2019m\u2026: country takes from; a job takes a/an, decided by sound.',
            tip: 'The model plays first — Maya + Kenji, both doors, twice, no response required. Absorbs C3-CLIN-C and C3-CLIN-D.',
            ladder: 'Exit criterion: 6 of 7 correct with no help above rung 2.',
            items: [
              { id: 'CL2-002', instr: 'Listen. Tap.', icon: 'ear', scene: "KENJI: I'm from Japan.", prompt: 'Tap: a country \u00b7 a job \u00b7 a phone number', opts: [{ id: 'A', t: 'country door' }, { id: 'B', t: 'job door' }, { id: 'C', t: 'phone card' }], key: 'A', ok: 'From + a country.', no: "'From' + a country. Japan!" },
              { id: 'CL2-003', instr: 'Read. Choose.', prompt: 'Leo is from ___.', opts: [{ id: 'A', t: 'a cook' }, { id: 'B', t: 'an engineer' }, { id: 'C', t: 'Australia' }], key: 'C', ok: 'Leo is from Australia.', no: "'From' + a country." },
              { id: 'CL2-004', instr: 'Read. Choose.', prompt: 'Maya is ___ nurse.', opts: [{ id: 'A', t: 'an' }, { id: 'B', t: 'a' }, { id: 'C', t: 'from' }], key: 'B', ok: 'Maya is a nurse.', no: 'Nurse \u2014 a consonant sound: a nurse.' },
              { id: 'CL2-005', instr: 'Read. Choose.', prompt: 'Amara is ___ office worker.', opts: [{ id: 'A', t: 'an' }, { id: 'B', t: 'a' }, { id: 'C', t: 'from' }], key: 'A', ok: 'Amara is an office worker.', no: 'Office \u2014 a vowel sound: an office worker.' },
              { id: 'CL2-006', instr: 'Listen. Put in order.', icon: 'ear', scene: "KENJI: I'm an engineer.", kind: 'order', tiles: ['engineer', "I'm", 'an'], key: ["I'm", 'an', 'engineer'], ok: "'I'm an engineer.' Kenji's line!", no: "First: I'm. Next: an. Last: engineer." },
              { id: 'CL2-007', instr: 'Listen. Choose.', icon: 'ear', scene: 'NINA: Where are you from?', prompt: 'You say:', opts: [{ id: 'A', t: "I'm a Kenya." }, { id: 'B', t: "I'm from Kenya." }, { id: 'C', t: "I'm an Kenya." }], key: 'B', ok: "'I'm from Kenya.'", no: "A country! 'I'm from Kenya.'" },
              { id: 'CL2-008', instr: 'Listen. Choose.', icon: 'ear', scene: 'NINA: And you \u2014 what do you do?', prompt: 'You say:', opts: [{ id: 'A', t: 'An driver.' }, { id: 'B', t: "I'm from a driver." }, { id: 'C', t: "I'm a driver." }], key: 'C', ok: "'I'm a driver.'", no: 'A job, with a.' }
            ],
            assets: ['A1-C04-AUD031–035', 'A1-C04-ILL010']
          },
          {
            id: 'S13', type: 'testlet', label: 'Integrated listening \u2014 Amara checks in', step: 'STEP 4 \u00b7 one long listen',
            rung: 'GIST \u2192 DETAIL \u2192 SPEAKER/TRANSFER', support: 'A1-C04-D01 \u2014 the door opens, a new neighbor walks in; listen once, all the way through', aud: 'A1-C04-AUD036', ids: 'LS001\u2013006',
            items: [
              { id: 'LS001', instr: 'Listen. Choose.', prompt: 'Who checks in?', opts: [{ id: 'A', t: 'Amara' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Alex' }], key: 'A', ok: 'Amara checks in.', no: 'The new name at the desk: Amara.' },
              { id: 'LS002', instr: 'Listen. Choose.', prompt: 'Where are they?', opts: [{ id: 'A', t: 'the café' }, { id: 'B', t: 'the check-in desk' }, { id: 'C', t: 'the park' }], key: 'B', ok: 'The check-in desk.', no: 'A desk, a register, badges.' },
              { id: 'LS003', instr: 'Listen. Choose.', prompt: "Amara's phone number:", opts: [{ id: 'A', t: '5-5-5 \u00b7 3-5-9' }, { id: 'B', t: '5-5-5 \u00b7 2-0-1' }, { id: 'C', t: '5-5-5 \u00b7 3-1-9' }], key: 'C', ok: '5-5-5, 3-1-9.', no: 'Listen for the last group: three\u2026 one\u2026 nine.' },
              { id: 'LS004', instr: 'Listen. Tap.', prompt: 'Tap the name.', opts: [{ id: 'A', t: 'AMARA' }, { id: 'B', t: 'AMRA' }, { id: 'C', t: 'AMARIA' }], key: 'A', ok: 'A-M-A-R-A. Amara!', no: 'Listen: A\u2026 M\u2026 A\u2026 R\u2026 A.' },
              { id: 'LS005', instr: 'Listen. Choose.', prompt: 'Who says: "This is my friend Sam."?', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Amara' }], key: 'B', ok: 'Maya \u2014 it is her friend Sam.', no: 'The warm voice in the middle: Maya.' },
              { id: 'LS006', instr: 'Listen. Choose.', prompt: 'Amara says:', opts: [{ id: 'A', t: 'Nice to meet you.' }, { id: 'B', t: 'My name is Amara.' }, { id: 'C', t: 'Nice to meet you too.' }], key: 'C', ok: 'Nice to meet you too!', no: 'Sam says it first \u2014 Amara answers with too.' }
            ],
            tip: 'One testlet on D01 (practice, not quiz), declared. Checkpoint 1 listens to three fresh recordings \u2014 none of them D01. Challenge take (AUD037) used for LS003/LS004.',
            assets: ['A1-C04-AUD036–037', 'A1-C04-ILL006–007']
          },
          {
            id: 'S14', type: 'reading', label: 'The day\u2019s sign-in sheet', step: 'STEP 5',
            kind: 'card', ids: 'A1-C04-L02-RD001–006',
            card: [
              'SIGN-IN SHEET · name · phone · email',
              'Maya Haddad · 5-5-5 2-0-1 · maya.haddad@aroa.com',
              'Leo Novak · 6-2-0 1-5-4 · leo.novak@aroa.com',
              'Nina Petrova · 5-5-5 2-0-9 · nina.petrova@aroa.com',
              'Amara Otieno · 5-5-5 3-1-9 · amara.otieno@aroa.com',
              '—',
              'PROFILE CARD · AMARA OTIENO (ILL009 art, app-rendered lines)',
              "I'm Amara. I'm from Kenya.",
              'I speak Swahili and English.',
              "I'm an office worker."
            ],
            note: 'Two text types on one screen: the C2 sign-in-sheet genre returns with four real morning rows, and the C3 profile-card genre returns on the notice board. RD001–003 scan the sheet; RD004–006 read the card.',
            items: [
              { id: 'A1-C04-L02-RD001', instr: 'Read. Tap.', icon: 'eye', prompt: "Leo's phone number:", opts: [{ id: 'A', t: '6-2-0 · 1-5-4' }, { id: 'B', t: '5-5-5 · 2-0-1' }, { id: 'C', t: '6-2-0 · 1-4-5' }], key: 'A', ok: 'Yes — 6-2-0, 1-5-4.', no: 'Find the Leo row. Read the digits: 6-2-0, 1-5-4.', a11y: ['dynamic_type_to_XL', 'no_audio_required'] },
              { id: 'A1-C04-L02-RD002', instr: 'Read. Tap.', icon: 'eye', prompt: 'leo.novak@aroa.com — who?', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Amara' }, { id: 'C', t: 'Leo' }], key: 'C', ok: 'Yes — Leo. His email.', no: 'Scan the email column down: Leo.' },
              { id: 'A1-C04-L02-RD003', instr: 'Read. Tap.', icon: 'eye', prompt: "Amara's email address:", opts: [{ id: 'A', t: 'amara.otieno@aroa.com' }, { id: 'B', t: 'amara.haddad@aroa.com' }, { id: 'C', t: 'maya.otieno@aroa.com' }], key: 'A', ok: 'Yes — amara.otieno@aroa.com.', no: "Amara's row: amara.otieno@…" },
              { id: 'A1-C04-L02-RD004', instr: 'Read. Tap.', icon: 'eye', prompt: 'Amara is from:', opts: [{ id: 'A', t: 'Egypt' }, { id: 'B', t: 'Kenya' }, { id: 'C', t: 'Japan' }], key: 'B', ok: 'Yes — Kenya.', no: "Read line two: 'I'm from Kenya.'" },
              { id: 'A1-C04-L02-RD005', instr: 'Read. Tap.', icon: 'eye', prompt: 'Amara is:', opts: [{ id: 'A', t: 'a nurse' }, { id: 'B', t: 'a driver' }, { id: 'C', t: 'an office worker' }], key: 'C', ok: 'Yes — an office worker.', no: "Read line four: 'I'm an office worker.'" },
              { id: 'A1-C04-L02-RD006', instr: 'Read. Tap.', icon: 'eye', prompt: 'Amara speaks:', opts: [{ id: 'A', t: 'Spanish and English' }, { id: 'B', t: 'Swahili and English' }, { id: 'C', t: 'English and French' }], key: 'B', ok: 'Yes — Swahili and English.', no: "Read line three: 'I speak Swahili and English.'" }
            ],
            tip: 'The C2 sign-in-sheet genre returns with real morning data \u2014 four rows, name \u00b7 phone \u00b7 email. The tile-writing (WR001\u2013004: the three-sentence self-introduction) and rehearsal taps (CV001\u2013006) that follow in the source are represented by the L1 supported-recording component and the L3 roleplay rehearsal, rather than redrawn as separate screens here.',
            assets: ['A1-C04-ILL008']
          }
        ]
      },
      {
        id: 'L03', type: 'M', n: 3, title: 'The Mission and Checkpoint 1', time: '20\u201325 min', pause: 'after the roleplay, \u2248 minute 8',
        src: 'A1_C04_L03_LESSON.md',
        screens: [
          {
            id: 'S20', type: 'hook', label: 'The last door', step: 'STEP 1',
            lead: 'One thing left: the door. A new friend is at the door. Your badge. Your lines. Your mission!',
            scene: 'The morning is full: the sheet holds four names, the wall holds six dots, Amara is at the notice board with Sam.',
            aud: 'A1-C04-AUD043', delivery: 'learning_slow_clear',
            ill: ill('ILL012', 'The door opens; Rafael waves; the learner\u2019s badge is on the table'),
            lines: [
              { sp: 'GUIDE', t: 'The morning is full. One thing now: the door. A new friend is at the door. Your badge. Your lines. Your mission!' },
              { sp: 'ALEX', t: "Okay! You're ready. I'm here \u2014 and Amara is here. Go!" }
            ],
            scored: false, note: '\u2b50\u2b50\u2b50 earned (hello \u00b7 check in \u00b7 this is my friend) \u2014 one star left: the door star. After the mission: Checkpoint 1, your Arc-1 test.',
            tip: 'Mission final card animates the third star as unearned, waiting.',
            assets: ['A1-C04-AUD043', 'A1-C04-ILL012']
          },
          {
            id: 'S21', type: 'roleplay', label: 'Roleplay \u2014 The Door', step: 'STEP 2',
            spec: 'A1-C04-RP001', partner: 'Rafael', turnLimit: 8,
            opener: 'Rafael arrives at the door \u2014 denim jacket, yellow t-shirt, key ring.',
            scenario: 'You are the greeter with a helper badge. Greet, check Rafael in (name spelling + phone digits), ask origin/job, introduce him to Amara, close.',
            checklist: ['greeting', 'name question', 'spelling request', 'origin question', 'introduction'],
            tileGroups: [
              { g: 'greeting', t: ['Good morning!', 'Hello!', 'Hi!'] },
              { g: 'name', t: ["What's your name?"] },
              { g: 'spelling', t: ['How do you spell that?'] },
              { g: 'origin', t: ['Where are you from?'] },
              { g: 'phone (optional)', t: ["What's your phone number?"] },
              { g: 'job (optional)', t: ['What do you do?'] },
              { g: 'introduce', t: ['This is my friend Rafael.', 'This is Rafael.'] },
              { g: 'close (optional)', t: ['See you!', 'Bye!', 'Goodbye!'] }
            ],
            transcript: [
              { sp: 'YOU', t: 'Good morning!' },
              { sp: 'RAFAEL', t: "Hi! I'm Rafael. Rafael Costa." },
              { sp: 'YOU', t: 'Rafael \u2014 how do you spell that?' },
              { sp: 'RAFAEL', t: 'R-A-F-A-E-L. And my phone number: 6-1-8\u2026 4-0-2.' },
              { sp: 'YOU', t: 'Thank you! Where are you from?' },
              { sp: 'RAFAEL', t: "I'm from Brazil. I'm a driver. I speak Portuguese and English!" },
              { sp: 'YOU', t: 'Amara! This is my friend Rafael.' },
              { sp: 'RAFAEL', t: 'Nice to meet you!' },
              { sp: 'AMARA', t: 'Nice to meet you too!' }
            ],
            branch: [
              'N1 — the door opens, Rafael waves → key: "Good morning!" (vs "See you!", "My name is Amara.")',
              'N2 — "Hi! I’m Rafael. Rafael Costa." → key: "How do you spell that?" (vs "How are you?", "See you!")',
              'N3 — "R-A-F-A-E-L. And my phone number: 6-1-8… 4-0-2." → key: RAFAEL · 6-1-8 4-0-2 (vs RAFEL, vs 6-8-1)',
              'N4 — "I’m from Brazil. I’m a driver." → key: Brazil + driver (vs Japan + engineer, vs Brazil + cook)',
              'N5 — Amara turns toward you → key: "This is my friend Rafael." (vs "See you!", vs "Nice to meet you, Amara!")'
            ],
            feedback: { strong: ['You greeted first.', 'You asked for the spelling and the origin.'], next: 'Introduce Rafael to Amara, then close.' },
            redirects: ['If the learner stalls 10 s: one repair offer ("My name is Rafael. R-A-F-A-E-L."), then the next slot re-prompts with icons.', 'A skipped required slot completes as a tap choice \u2014 no failure state inside practice; Checkpoint 1, not the roleplay, gates.'],
            partnerCard: 'Rafael Costa \u00b7 lively, medium-low \u00b7 speaks only taught frames \u00b7 one repair offer per stall \u00b7 never more than one question at a time.',
            success: ['all five required slots expressed, by voice or tap, within 8 turns'],
            guardrails: ['No immigration/status/job-pressure framing \u2014 origins are offered facts, never demanded.', 'No required typing.', '"Good night" never appears, not even as a distractor.'],
            scoring: 'Slots completed, not perfection. Feedback: one star on the mission card + Alex\u2019s "Okay!" line.',
            tip: 'Non-voice alternative path (N1\u2013N5) is equal in weight to the voice path \u2014 completion counts either way. Pause point after the roleplay; progress saves.',
            assets: ['A1-C04-AUD044–047', 'A1-C04-ILL012']
          },
          {
            id: 'S23', type: 'quiz', label: 'Checkpoint 1', step: 'STEP 3 \u00b7 20\u201325 min',
            mix: [['vocabulary', 12], ['grammar', 12], ['listening', 10], ['reading', 6], ['discourse', 6], ['tile tasks', 2], ['speaking mission', 1]],
            bank: 'A1-CP1-* \u00b7 47 scored points (45 choice + 2 tile) + 1 speaking mission \u00b7 100% cumulative by design \u2014 every item cites a Chapter 1\u20133 prerequisite. Three fresh recordings, none shared with D01 or any practice item.',
            note: 'Gate: \u226580% overall AND \u226570% in vocabulary, grammar, listening, and conversation, AND the speaking mission completed (voice or tap). Near-pass (70\u201379% or one floor missed) \u2192 clinic + the authored 15-item alternate form (A1-CP1-B001\u2013015). Below 70% \u2192 personalised review of the weakest span, then the alternate form. Unlimited retries use the authored 12-item parallel pool (A1-CP1-P001\u2013012) first.',
            items: [
              { id: 'A1-CP1-V001', instr: 'Look. Tap.', scene: 'A dusk street scene, warm lamps.', prompt: 'You say:', opts: [{ id: 'A', t: 'Good evening!' }, { id: 'B', t: 'Good morning!' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Good evening.', no: 'The lamps are on, the sky is orange.' },
              { id: 'A1-CP1-V003', instr: 'Read. Tap.', prompt: 'A new neighbor is at the door. First, you say:', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: "I'm a teacher." }, { id: 'C', t: "What's your name?" }], key: 'C', ok: 'Ask the name first.', no: 'A new face, a new name.' },
              { id: 'A1-CP1-V004', instr: 'Look. Tap.', scene: 'The hall door at day\u2019s end, bag on shoulder, a wave.', prompt: 'You say:', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Good morning!' }, { id: 'C', t: 'My name is Leo.' }], key: 'A', ok: 'See you! \u2014 yes.', no: 'A wave at the door.' },
              { id: 'A1-CP1-V007', instr: 'Look. Tap.', scene: 'An envelope opening on a phone screen.', prompt: 'Tap the words:', opts: [{ id: 'A', t: 'email address' }, { id: 'B', t: 'phone number' }, { id: 'C', t: 'first name' }], key: 'A', ok: 'The email address.', no: 'The envelope \u2014 the email address.' },
              { id: 'A1-CP1-V008', instr: 'Read. Tap.', scene: "NINA: 4-0-1, 7-3-2. SAM: No \u2014 4-0-1, 7-3-0!", prompt: 'Two numbers! You say:', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Can you repeat that, please?' }, { id: 'C', t: 'Good morning!' }], key: 'B', ok: 'Ask for the repeat.', no: 'Two numbers! Ask again.' },
              { id: 'A1-CP1-V009', instr: 'Look. Tap.', scene: 'Kenya map card.', prompt: 'Tap the country:', opts: [{ id: 'A', t: 'Egypt' }, { id: 'B', t: 'Japan' }, { id: 'C', t: 'Kenya' }], key: 'C', ok: 'Kenya.', no: 'That shape is Kenya.' },
              { id: 'A1-CP1-V010', instr: 'Look. Tap.', scene: 'A nurse at a clinic desk, scrubs, kind face.', prompt: 'She is a:', opts: [{ id: 'A', t: 'nurse' }, { id: 'B', t: 'driver' }, { id: 'C', t: 'cook' }], key: 'A', ok: 'A nurse.', no: 'The clinic, the scrubs.' },
              { id: 'A1-CP1-V011', instr: 'Look. Tap.', scene: 'Two figures laughing together, arms linked.', prompt: 'Maya and Sam are:', opts: [{ id: 'A', t: 'people' }, { id: 'B', t: 'friends' }, { id: 'C', t: 'students' }], key: 'B', ok: 'Friends.', no: 'Look at the two of them.' },
              { id: 'A1-CP1-V012', instr: 'Look. Tap.', scene: "Rafael's profile card icon: portrait + small Brazil map.", prompt: 'Line 2 of the card:', opts: [{ id: 'A', t: "I'm a driver." }, { id: 'B', t: 'My name is Rafael.' }, { id: 'C', t: "I'm from Brazil." }], key: 'C', ok: "'I'm from Brazil.'", no: 'The map line.' },
              { id: 'A1-CP1-G001', instr: 'Read. Choose.', prompt: 'I ___ a student.', opts: [{ id: 'A', t: 'am' }, { id: 'B', t: 'is' }, { id: 'C', t: 'are' }], key: 'A', ok: 'I am a student.', no: "I \u2192 am. 'I'm a student.'" },
              { id: 'A1-CP1-G003', instr: 'Read. Choose.', prompt: 'Maya and Sam ___ friends.', opts: [{ id: 'A', t: 'is' }, { id: 'B', t: 'am' }, { id: 'C', t: 'are' }], key: 'C', ok: 'Maya and Sam are friends.', no: 'Two people \u2192 are.' },
              { id: 'A1-CP1-G004', instr: 'Read. Choose.', prompt: 'Leo and Nina ___ from Spain. (no \u2014 Peru and Australia!)', opts: [{ id: 'A', t: "aren't" }, { id: 'B', t: "isn't" }, { id: 'C', t: 'am not' }], key: 'A', ok: "They aren't from Spain.", no: 'Two people, no \u2192 aren\u2019t.' },
              { id: 'A1-CP1-G007', instr: 'Read. Choose.', prompt: 'Where is Alex from? \u2014 ___ from Canada.', opts: [{ id: 'A', t: "They're" }, { id: 'B', t: "She's" }, { id: 'C', t: "He's" }], key: 'A', ok: "Alex? They're from Canada.", no: "Alex is they: 'They're from Canada.'" },
              { id: 'A1-CP1-G009', instr: 'Read. Choose.', prompt: 'Kenji is ___ engineer.', opts: [{ id: 'A', t: 'a' }, { id: 'B', t: 'an' }, { id: 'C', t: 'from' }], key: 'B', ok: 'An engineer.', no: 'Vowel sound \u2192 an.' },
              { id: 'A1-CP1-G011', instr: 'Read. Choose.', prompt: 'Is Nina a teacher? \u2014 Yes, ___ is.', opts: [{ id: 'A', t: 'he' }, { id: 'B', t: 'they' }, { id: 'C', t: 'she' }], key: 'C', ok: 'Yes, she is.', no: 'Nina is she.' },
              { id: 'A1-CP1-G012', instr: 'Put in order.', prompt: 'The job question:', kind: 'order', tiles: ['you', 'do', 'What', 'do?'], key: ['What', 'do', 'you', 'do?'], ok: "'What do you do?' \u2014 yes!", no: 'First: What. Next: do. Then: you. Last: do?' },
              { id: 'A1-CP1-LS001', instr: 'Listen. Choose.', scene: 'SAM: Good morning, Nina! NINA: Good morning, Sam! How are you? SAM: I\u2019m good, thank you! And you? NINA: I\u2019m fine!', prompt: 'How many people?', opts: [{ id: 'A', t: 'one' }, { id: 'B', t: 'two' }, { id: 'C', t: 'three' }], key: 'B', ok: 'Two people.', no: 'Two voices: Sam and Nina.' },
              { id: 'A1-CP1-LS004', instr: 'Listen. Choose.', prompt: 'Time of day:', opts: [{ id: 'A', t: 'sun-high park' }, { id: 'B', t: 'dusk lamps' }, { id: 'C', t: 'sun-low, long shadows' }], key: 'C', ok: 'Morning.', no: "Listen to the greeting: 'Good morning!'" },
              { id: 'A1-CP1-LS005', instr: 'Listen. Choose.', scene: "NINA: Your name, please? SAM: Sam. Sam Rivera. NINA: How do you spell that? SAM: S-A-M. R-I-V-E-R-A.", prompt: "Sam's last name:", opts: [{ id: 'A', t: 'Rivas' }, { id: 'B', t: 'Rivera' }, { id: 'C', t: 'Rivea' }], key: 'B', ok: 'Rivera.', no: 'Listen: R-I-V-E-R-A.' },
              { id: 'A1-CP1-LS008', instr: 'Listen. Choose.', scene: 'KENJI: Hi. I\u2019m Kenji. I\u2019m from Japan. I speak Japanese and English. I\u2019m an engineer.', prompt: 'Kenji is from:', opts: [{ id: 'A', t: 'Japan' }, { id: 'B', t: 'Kenya' }, { id: 'C', t: 'Brazil' }], key: 'A', ok: "'I'm from Japan.'", no: "Listen: 'I'm from Japan.'" },
              { id: 'A1-CP1-LS009', instr: 'Listen. Choose.', prompt: 'Kenji is a:', opts: [{ id: 'A', t: 'a doctor' }, { id: 'B', t: 'an engineer' }, { id: 'C', t: 'a teacher' }], key: 'B', ok: "'I'm an engineer.'", no: "Listen: 'I'm an engineer.'" },
              { id: 'A1-CP1-LS010', instr: 'Listen. Choose.', prompt: 'Kenji speaks:', opts: [{ id: 'A', t: 'Portuguese and English' }, { id: 'B', t: 'Swahili and English' }, { id: 'C', t: 'Japanese and English' }], key: 'C', ok: 'Japanese and English.', no: "Listen: 'I speak Japanese and English.'" },
              { id: 'A1-CP1-RD001', instr: 'Read. Choose.', scene: "RAFAEL COSTA card: I'm Rafael. I'm from Brazil. I speak Portuguese and English. I'm a driver.", prompt: 'Rafael is from:', opts: [{ id: 'A', t: 'Kenya' }, { id: 'B', t: 'Brazil' }, { id: 'C', t: 'Japan' }], key: 'B', ok: 'Card line 2.', no: "Read line two: 'I'm from Brazil.'" },
              { id: 'A1-CP1-RD002', instr: 'Read. Choose.', prompt: 'Rafael is a:', opts: [{ id: 'A', t: 'a cook' }, { id: 'B', t: 'an engineer' }, { id: 'C', t: 'a driver' }], key: 'C', ok: 'Card line 4.', no: "Read line four: 'I'm a driver.'" },
              { id: 'A1-CP1-RD004', instr: 'Read. Choose.', scene: 'LEO NOVAK \u00b7 6-2-0 1-5-4 \u00b7 leo.novak@aroa.com', prompt: "Leo's phone number:", opts: [{ id: 'A', t: '6-2-0 \u00b7 1-4-5' }, { id: 'B', t: '6-2-0 \u00b7 1-5-4' }, { id: 'C', t: '2-6-0 \u00b7 1-5-4' }], key: 'B', ok: '6-2-0, 1-5-4.', no: 'Read the middle group.' },
              { id: 'A1-CP1-RD006', instr: 'Read. Choose.', prompt: 'Card line 2:', opts: [{ id: 'A', t: "I'm Rafael." }, { id: 'B', t: "I'm a driver." }, { id: 'C', t: "I'm from Brazil." }], key: 'C', ok: 'Line 2 is the from line.', no: 'Line 1 name, line 2 from, line 3 speaks, line 4 job.' },
              { id: 'A1-CP1-CN001', instr: 'Listen. Choose.', scene: 'MAYA: Alex! This is my friend Sam.', prompt: 'Alex says:', opts: [{ id: 'A', t: 'Nice to meet you, Sam!' }, { id: 'B', t: 'See you!' }, { id: 'C', t: 'My name is Alex.' }], key: 'A', ok: 'Nice to meet you!', no: 'A new face!' },
              { id: 'A1-CP1-CN002', instr: 'Read. Choose.', prompt: 'At the door, first you say:', opts: [{ id: 'A', t: "What's your name?" }, { id: 'B', t: 'Good morning!' }, { id: 'C', t: 'See you!' }], key: 'B', ok: 'The greeting comes first.', no: 'First the greeting, then the name.' },
              { id: 'A1-CP1-CN005', instr: 'Look. Choose.', scene: 'The hall at day\u2019s end; Rafael waves from the door, bag on.', prompt: 'You say:', opts: [{ id: 'A', t: 'Good morning!' }, { id: 'B', t: 'See you!' }, { id: 'C', t: "What's your name?" }], key: 'B', ok: 'See you! \u2014 yes.', no: 'He is leaving.' },
              { id: 'A1-CP1-CN006', instr: 'Look. Choose.', scene: "Amara brings Rafael to you; she gestures toward him. AMARA: This is my friend Rafael.", prompt: 'You say:', opts: [{ id: 'A', t: 'Nice to meet you, Rafael!' }, { id: 'B', t: 'See you, Amara!' }, { id: 'C', t: 'My name is Rafael.' }], key: 'A', ok: 'Nice to meet you, Rafael!', no: 'You meet Rafael.' },
              { id: 'A1-CP1-W002', instr: 'Put in order.', prompt: 'Rafael \u2014 three lines:', kind: 'order', tiles: ['This is my friend Rafael.', "He's an driver.", "She's from Brazil.", "He's a driver.", "He's from Brazil."], key: ['This is my friend Rafael.', "He's from Brazil.", "He's a driver."], ok: 'All three built and ordered.', no: 'This is my friend Rafael \u2192 He\u2019s from Brazil \u2192 He\u2019s a driver.' }
            ],
            tip: 'A1-CP1-W001 (the learner\u2019s own three-line badge introduction, built from tiles with a skip path on every slot) and A1-CP1-SM01 (the speaking mission \u2014 4 of 6 taught moves, voice or tap, completion-scored, never phonetically scored) are represented by the existing tile-writing and Say-It-Aloud components. Recordings never upload; on-device only.',
            assets: ['A1-CP1-AUD001–004', 'A1-C04-ILL013–014']
          },
          {
            id: 'S28', type: 'results', label: 'Checkpoint 1 \u2014 results', step: 'STEP 4',
            rings: ['greet & check in', 'origin & job', 'introduce', 'the door mission', 'checkpoint passed'],
            strong: 'You checked in fast, asked for origin and job under speed, and introduced Rafael to Amara.',
            developing: 'The from/a-an doors still cross sometimes \u2014 the alternate form below re-checks it.',
            next: 'Chapter 5 \u2014 My Family and the People I Know.',
            score: 'Pass is \u226538 / 47 (80%), with \u226570% in vocabulary, grammar, listening and conversation.',
            gate: 'Near-pass (70\u201379%, or one floor missed) \u2192 the authored 15-item alternate form (A1-CP1-B001\u2013015). Below 70% \u2192 personalised review of the weakest span, then the alternate form. Unlimited retries use the authored 12-item parallel pool (A1-CP1-P001\u2013012) \u2014 never the same items twice in a row; generation beyond that pool is not approved without owner ratification. No permanent lock, no shaming language.',
            tip: 'Five can-do rings filling \u2014 Arc 1 complete on a pass. This is also the checkpoint that gates the Chapter 2\u20134 subscription boundary in the product\u2019s entitlement model, never announced as a sales moment on this screen.',
            assets: ['A1-C04-ILL015']
          },
          {
            id: 'S29', type: 'chapterMap', label: 'Chapter map / next', step: 'Wrap-up',
            head: 'Chapter 4 complete \u2014 Arc 1 complete!',
            body: 'You can check in, ask and answer origin and job under speed, and introduce one person to another. Checkpoint 1 is passed.',
            next: 'Chapter 5 \u2014 My Family and the People I Know (in progress \u2014 lessons 1\u20132 of 3 authored).',
            arc: 'Meet and connect', chapters: [{ n: 1, t: 'Hello! My Name Is Alex', s: 'done' }, { n: 2, t: 'Spell It and Share Your Details', s: 'done' }, { n: 3, t: 'Where Are You From?', s: 'done' }, { n: 4, t: 'Checkpoint Review 1', s: 'done' }],
            tip: 'The Arc 1 celebration is the richest but still calm \u2014 whole-cast group scene (ILL016), reduced-motion safe.',
            assets: ['A1-C04-ILL016']
          }
        ]
      }
    ]
  });
})();
