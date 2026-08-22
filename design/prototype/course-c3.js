/* A1-C03 — "Where Are You From?". Screen inventory S01–S32.
   Every string here is transcribed from english_course/04_A1_chapters/A1_C03/*.
   Audited 2026-08-20: the chapter is complete in the source (A1_C03_QA_REPORT.md,
   STATE.md) — L01 (S01–S12), L02 (S13–S22) and L03 (S23–S32, incl. quiz Form A,
   results, clinic seeds and the spaced-review export) are all transcribed here. */
(function () {
  var C = (window.AUREL_COURSE = window.AUREL_COURSE || { chapters: [] });
  var __guard = C.chapters.some(function (x) { return x.id === 'A1-C03'; });
  if (__guard) return;

  var ill = function (id, alt) { return { id: 'A1-C03-' + id, alt: alt }; };

  /* ---------- L01 · Micro-set A: the origin frame (V001–V006) ---------- */
  var setA = [
    { id: 'V001', w: 'country', ipa: '/ˈkʌn.tri/', stress: '● ○  COUN-try', aud: 'AUD002', ill: ill('ILL002', 'Open landscape with rolling fields and distant hills under a cream sky'), fn: 'noun — a big place, one name on the map', frame: 'One country, one dot. · Canada is a country.' },
    { id: 'V002', w: 'city', ipa: '/ˈsɪt.i/', stress: '● ○  CI-ty', aud: 'AUD003', ill: ill('ILL002', 'Small city with streets, houses, and a park corner under a soft sky'), fn: 'noun — a place with streets and houses', frame: 'Aroa is a city.' },
    { id: 'V003', w: 'from', ipa: '/frʌm/', stress: 'one strong syllable (weak /frəm/ in fast speech)', aud: 'AUD004', ill: ill('ILL001', 'Hand placing an orange dot on a world map while a figure waves'), fn: 'preposition in the fixed frame — says your place', frame: "I'm from Peru. · Where are you from?" },
    { id: 'V004', w: 'language', ipa: '/ˈlæŋ.ɡwɪdʒ/', stress: '● ○○  LAN-guage', aud: 'AUD005', ill: ill('ILL001', 'Two empty rounded speech bubbles floating over talking figures'), fn: 'noun — what people speak', frame: 'I speak Arabic and English. Two languages!' },
    { id: 'V005', w: 'English', ipa: '/ˈɪŋ.ɡlɪʃ/', stress: '● ○  ENG-lish', aud: 'AUD006', ill: ill('ILL001', 'Man at a map wall saying a line into a blank speech bubble'), fn: 'noun — a language name, always capitalized', frame: 'I speak English.' },
    { id: 'V006', w: 'speak', ipa: '/spiːk/', stress: '●  SPEAK', aud: 'AUD007', ill: ill('ILL001', 'Figure speaking warmly beside two empty speech bubbles'), fn: 'verb — frames only (I speak … / They speak …)', frame: 'I speak Arabic and English. · They speak Spanish.' }
  ];

  /* ---------- L01 · Micro-set B: the cast five countries (V007–V011) ---------- */
  var setB = [
    { id: 'V007', w: 'Canada', ipa: '/ˈkæn.ə.də/', stress: '● ○ ○  CA-na-da', aud: 'AUD008', ill: ill('ILL003', "Simplified world map with Canada's region filled in warm orange"), fn: 'country · Canadian · English and French', frame: "ALEX: I'm from Canada. I speak English and French." },
    { id: 'V008', w: 'Mexico', ipa: '/ˈmɛk.sɪ.koʊ/', stress: '● ○ ○  ME-xi-co', aud: 'AUD009', ill: ill('ILL004', "Simplified world map with Mexico's region filled in warm orange"), fn: 'country · Mexican · Spanish and English', frame: "SAM: I'm from Mexico — Spanish and English." },
    { id: 'V009', w: 'Peru', ipa: '/pəˈruː/', stress: '○ ●  pe-RU', aud: 'AUD010', ill: ill('ILL005', "Simplified world map with Peru's region filled in warm orange"), fn: 'country · Peruvian · Spanish', frame: "NINA: I'm from Peru. I speak Spanish." },
    { id: 'V010', w: 'Egypt', ipa: '/ˈiː.dʒɪpt/', stress: '● ●  EE-gypt', aud: 'AUD011', ill: ill('ILL006', "Simplified world map with Egypt's region filled in warm orange"), fn: 'country · Egyptian · Arabic and English', frame: "MAYA: I'm from Egypt. I speak Arabic and English." },
    { id: 'V011', w: 'Australia', ipa: '/ɔːˈstreɪl.jə/', stress: '○ ● ○  au-STRA-lia', aud: 'AUD012', ill: ill('ILL007', "Simplified world map with Australia's region filled in warm orange"), fn: 'country · Australian · English', frame: "LEO: I'm from Australia. I speak English." }
  ];

  /* ---------- L01 · Micro-set C: the world five countries (V012–V016) ---------- */
  var setC = [
    { id: 'V012', w: 'Brazil', ipa: '/brəˈzɪl/', stress: '○ ●  bra-ZIL', aud: 'AUD013', ill: ill('ILL008', "Simplified world map with Brazil's region filled in warm orange"), fn: 'country · Brazilian · Portuguese', frame: 'Brazil · They speak Portuguese.' },
    { id: 'V013', w: 'Japan', ipa: '/dʒəˈpæn/', stress: '○ ●  Ja-PAN', aud: 'AUD014', ill: ill('ILL009', "Simplified world map with Japan's region filled in warm orange"), fn: 'country · Japanese · Japanese', frame: 'Japan · They speak Japanese.' },
    { id: 'V014', w: 'Kenya', ipa: '/ˈkɛn.jə/', stress: '● ○  KEN-ya', aud: 'AUD015', ill: ill('ILL010', "Simplified world map with Kenya's region filled in warm orange"), fn: 'country · Kenyan · Swahili and English', frame: 'Kenya · They speak Swahili and English.' },
    { id: 'V015', w: 'Spain', ipa: '/speɪn/', stress: '●  SPAIN', aud: 'AUD016', ill: ill('ILL011', "Simplified world map with Spain's region filled in warm orange"), fn: 'country · Spanish · Spanish', frame: 'Spain · They speak Spanish.' },
    { id: 'V016', w: 'India', ipa: '/ˈɪn.di.ə/', stress: '● ○ ○  IN-di-a', aud: 'AUD017', ill: ill('ILL012', "Simplified world map with India's region filled in warm orange"), fn: 'country · Indian · Hindi and English — and many more', frame: 'India · They speak Hindi and English.' }
  ];

  /* ---------- L01 · Micro-sets D + E: jobs (V017–V025; E attached to D's screen) ---------- */
  var jobs = [
    { id: 'V017', w: 'student', ipa: '/ˈstuː.dənt/', stress: '● ○  STU-dent', aud: 'AUD018', ill: ill('ILL013', 'Adult man with dark skin seated at a class table, notebook open, phone beside it'), fn: 'job word — a person who studies', frame: "GUIDE: I'm a student." },
    { id: 'V018', w: 'teacher', ipa: '/ˈtiː.tʃɚ/', stress: '● ○  TEA-cher', aud: 'AUD019', ill: ill('ILL014', 'Nina, grey-streaked hair in a low bun and teal cardigan, gesturing at a blank board'), fn: "job word — Nina's job", frame: "NINA: I'm a teacher." },
    { id: 'V019', w: 'doctor', ipa: '/ˈdɑːk.tɚ/', stress: '● ○  DOC-tor', aud: 'AUD020', ill: ill('ILL015', 'Woman doctor in a coat with a stethoscope, smiling, hospital corridor behind'), fn: 'job word — a person who helps sick people', frame: "GUIDE: I'm a doctor." },
    { id: 'V020', w: 'nurse', ipa: '/nɚs/', stress: '●  NURSE', aud: 'AUD021', ill: ill('ILL016', 'Maya, dark brown wavy hair tied back, green scrubs, small star pin, warm smile'), fn: "job word — Maya's job", frame: "MAYA: I'm a nurse." },
    { id: 'V021', w: 'engineer', ipa: '/ˌen.dʒəˈnɪr/', stress: '○ ○ ●  en-gi-NEER', aud: 'AUD022', ill: ill('ILL017', 'Man with glasses and a hard hat holding a tablet, scaffolding softly behind'), fn: 'job word — designs and builds things', frame: "GUIDE: I'm an engineer." },
    { id: 'V022', w: 'designer', ipa: '/dɪˈzaɪ.nɚ/', stress: '○ ● ○  de-SIG-ner', aud: 'AUD023', ill: ill('ILL018', 'Alex, short black hair, round glasses, mustard sweater, drawing in a sketchbook at a café table'), fn: "attached set E · job word — Alex's job", frame: "ALEX: I'm a designer." },
    { id: 'V023', w: 'driver', ipa: '/ˈdraɪ.vɚ/', stress: '● ○  DRI-ver', aud: 'AUD024', ill: ill('ILL019', 'Woman bus driver with braids at the wheel of a small city bus, morning light'), fn: 'attached set E · job word — drives a bus, a taxi, a truck', frame: "GUIDE: I'm a driver." },
    { id: 'V024', w: 'cook', ipa: '/kʊk/', stress: '●  COOK', aud: 'AUD025', ill: ill('ILL020', 'Leo, tall with curly auburn hair and beard, blue apron over striped shirt, at a café kitchen counter'), fn: "attached set E · job word — Leo's job", frame: "LEO: I'm a cook." },
    { id: 'V025', w: 'office worker', ipa: '/ˈɔː.fɪs ˈwɚ.kɚ/', stress: '● ○ ● ○  OF-fice WOR-ker', aud: 'AUD026', ill: ill('ILL021', 'Man with light olive skin at a tidy desk, laptop open, blank lanyard around his neck'), fn: 'attached set E · two-word job phrase', frame: "GUIDE: I'm an office worker." }
  ];

  /* ---------- L01 · Micro-sets F + G: people, introducing, the two big questions ---------- */
  var setF = [
    { id: 'V026', w: 'friend', ipa: '/frend/', stress: '●  FRIEND', aud: 'AUD027', ill: ill('ILL022', 'Maya smiling, one hand open toward Sam beside the dotted map wall'), fn: 'noun — a person you like', frame: 'This is my friend Sam.' },
    { id: 'V027', w: 'person', ipa: '/ˈpɚ.sən/', stress: '● ○  PER-son', aud: 'AUD028', ill: ill('ILL022', 'One figure standing alone beside the map wall'), fn: 'noun (singular) — one human', frame: 'one person' },
    { id: 'V028', w: 'people', ipa: '/ˈpiː.pəl/', stress: '● ○  PEO-ple', aud: 'AUD029', ill: ill('ILL001', 'Five figures standing together beside the dotted map wall'), fn: 'noun (plural) — many persons', frame: 'People from many countries. · People from ten countries!' },
    { id: 'V029', w: 'This is …', ipa: '/ˈðɪs ɪz/', stress: '● ●  THIS IS (linking: this-iz)', aud: 'AUD030', ill: ill('ILL022', 'Open-hand introducing gesture between two smiling figures'), fn: 'chunk — presents one person to others', frame: 'This is my friend Sam. / This is Maya.', chunk: true },
    { id: 'V030', w: 'They speak …', ipa: '/ðeɪ ˈspiːk/', stress: '○ ●  they SPEAK', aud: 'AUD031', ill: ill('ILL010', 'Three small empty speech bubbles over a world-map card'), fn: "chunk — a place's language", frame: 'Kenya · They speak Swahili and English.', chunk: true },
    { id: 'V031', w: 'Nice to meet you too', ipa: '/ˌnaɪs tə ˈmiːt ju ˈtuː/', stress: '○ ○ ● ○ ●  nice to MEET you TOO', aud: 'AUD032', ill: ill('ILL022', 'Two figures exchanging warm greetings, speech bubbles crossing'), fn: "chunk — the reply to Chapter 1's Nice to meet you", frame: 'SAM: Nice to meet you! … LEO: Nice to meet you too.', chunk: true }
  ];
  var setG = [
    { id: 'V032', w: 'Where are you from?', ipa: '/ˈwɛr ɚ ju ˈfrʌm/', stress: '● ○ ○ ●  WHERE are you FROM', aud: 'AUD033', ill: ill('ILL001', 'Figure asking a question, one hand raised, question-shaped bubble (no letters)'), fn: "chunk — asks a person's country", frame: "Where are you from? … I'm from Egypt.", chunk: true },
    { id: 'V033', w: "I'm from …", ipa: '/aɪm frʌm/', stress: "● ●  I'm FROM (country word strongest)", aud: 'AUD034', ill: ill('ILL005', 'Orange dot landing on a world-map card, a waving figure beside it'), fn: 'chunk — states your country', frame: "I'm from Peru.", chunk: true },
    { id: 'V034', w: 'Where is Alex from?', ipa: '/ˈwɛr ɪz ˈæl.ɪks frʌm/', stress: '● ● ○ ●  WHERE is A-LEX FROM', aud: 'AUD035', ill: ill('ILL003', 'Photo card and map card side by side, question bubble between them'), fn: 'chunk — 3rd-person origin question, FIXED FRAME (paradigm is G007 in L2)', frame: 'Where is Alex from? … Alex is from Canada.', chunk: true },
    { id: 'V035', w: 'What do you do?', ipa: '/ˈwʌt də ju ˈduː/', stress: '● ○ ○ ●  WHAT do you DO', aud: 'AUD036', ill: ill('ILL016', 'Question bubble over a nurse card'), fn: 'chunk [CHUNK:survival] — asks a job', frame: "What do you do? … I'm a nurse.", chunk: true },
    { id: 'V036', w: "I'm a/an …", ipa: '/aɪm ə / aɪm ən/', stress: "● ○  I'm a … (job word carries the beat)", aud: 'AUD037', ill: ill('ILL013', 'Frame tiles above a student card'), fn: 'chunk — job answer frame; the a-vs-an sound rule is G009 in L2', frame: "I'm a student. / I'm an engineer.", chunk: true }
  ];

  C.chapters.push({
    id: 'A1-C03', n: 3, arc: 'Meet and connect', title: 'Where Are You From?',
    mission: 'Meet two recurring characters, share country/language information, state a job/role, and introduce another person.',
    canDos: ['ask and answer origin', 'state language(s)', 'state role/job', 'introduce another person', 'understand short identity profiles'],
    doNotTeach: ['shop assistant (Sam\'s job)', 'Where do you live?', 'nationality adjectives as productive grammar', 'the a/an rule before L2', 'he/she/they as analysed pronouns before L2', 'countries or languages beyond the roster', 'flags as any semantic cue', 'immigration or status questions of any kind', 'present simple beyond the two lexical frames'],
    lessons: [
      {
        id: 'L01', type: 'V', n: 1, title: 'Countries, Languages, Jobs', time: '≈20 min', pause: 'after Set B practice (≈9 min)',
        src: 'A1_C03_L01_LESSON.md',
        screens: [
          {
            id: 'S01', type: 'hook', label: 'Story hook — Neighbors Around the World', step: 'STEP 1 · 60–90 sec',
            lead: 'This chapter: ask and answer "Where are you from?", say your languages, say your job, introduce a friend, and understand short identity profiles.',
            scene: 'The morning after the Chapter 2 check-in, in the Community House big hall. A big world-map wall with orange dots. Sam\'s dot stickers come from his corner shop.',
            aud: 'AUD001', delivery: 'learning_slow_clear',
            ill: ill('ILL001', 'Nina, Alex, Maya, Leo and Sam stand beside a big world-map wall with orange dots; Sam holds a sheet of orange dot stickers'),
            lines: [
              { sp: 'NINA', t: 'Good morning! Welcome to your first community class.' },
              { sp: 'ALEX', t: 'Okay! Look at this! … A big map, and orange dots!' },
              { sp: 'NINA', t: 'One orange dot … for one country. Maya, first?', d: 'warm' },
              { sp: 'MAYA', t: "Good, good. I'm from Egypt. I speak Arabic and English." },
              { sp: 'NINA', t: 'Egypt. … One dot.' },
              { sp: 'LEO', t: "Ah! My turn. I'm from Australia. I speak English." },
              { sp: 'ALEX', t: "I'm from Canada. I speak English and French." },
              { sp: 'NINA', t: "And I'm from Peru. I speak Spanish." },
              { sp: 'MAYA', t: 'Look! … This is my friend Sam.' },
              { sp: 'SAM', t: "Hi! I'm Sam. I'm from Mexico — Spanish and English. Nice to meet you!" },
              { sp: 'LEO', t: 'Nice to meet you too.' },
              { sp: 'ALEX', t: 'Five dots! … And you? Where are you from?' },
              { sp: 'NINA', t: 'Share, if you like. Your dot goes here next time.', d: 'warm — origin-sharing is voluntary' }
            ],
            scored: false,
            note: 'Mission seed: the empty space on the wall (one unused dot) is for the learner — they place it in the L3 mission. No character asks about status, documents, or residence.',
            tip: 'Full-bleed art with line-highlight sync; replay always visible; captions off by default (audio-first), tap-to-reveal. Country names are slightly emphasized in the take, never isolated robotically.',
            assets: ['A1-C03-AUD001', 'A1-C03-ILL001']
          },
          {
            id: 'S02', type: 'warmup', label: 'Warm-up — retrieval only', step: 'STEP 2 · ≈2 min',
            head: 'You know these.', sub: 'Three quick taps, one per prior target. Icon-cued, no new language.',
            frames: [
              { q: 'Listen. Choose.', icon: 'ear', scene: 'WU1 — retrieves A1-C01-L01-V003 good morning · audio: "Good morning."', opts: ['Good morning.', 'Goodbye.', 'See you.'], key: 'Good morning.' },
              { q: 'Listen. Choose.', icon: 'ear', scene: 'WU2 — retrieves the C2 alphabet + How do you spell that? · audio + photo of Maya', opts: ['M-A-Y-A', 'M-A-Y-O', 'M-Y-A-A'], key: 'M-A-Y-A' },
              { q: 'Listen. Choose.', icon: 'ear', scene: 'WU3 — retrieves C2 numbers · LEO: "My phone number is six two zero … one five four."', opts: ['6-2-0, 1-5-4', '6-2-0, 1-4-5', '6-0-2, 1-5-4'], key: '6-2-0, 1-5-4' }
            ],
            note: 'WU1–WU3 are warm-up retrieval, not bank items: they carry feedback lines only ("Correct! / Try again — listen one more time.").',
            tip: 'Three-tap ribbon; one default replay per item; progress dots, not scores.',
            assets: []
          },
          {
            id: 'S03', type: 'cards', label: 'Set A teach — the origin frame', step: 'STEP 3 · ≈3 min',
            chip: 'country · city · from · language · English · speak', cards: setA,
            tip: 'Card carousel; split art ILL002 (fields half / streets half); each card ≤7 s of audio; thumb-scroll snap. Every card shows one frame line reused from the hook.',
            assets: ['A1-C03-AUD002–007', 'A1-C03-ILL002']
          },
          {
            id: 'S04', type: 'practice', label: 'Set A practice', step: 'STEP 3b',
            bank: 'PR-V001–V006 · 6 of 6 authored items shown',
            ladder: 'Help ladder: (1) replay audio, (2) highlight the frame, (3) show the hook line. Feedback always names the rule, never "wrong".',
            items: [
              { id: 'PR-V001', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD002', kind: 'image', opts: [{ id: 'A', ill: ill('ILL002', 'ILL002 left half — fields and hills') }, { id: 'B', ill: ill('ILL002', 'ILL002 right half — streets and houses') }], key: 'A', ok: 'Yes — country: fields, hills, very big.', no: 'Listen one more time. City has streets. Country is fields and hills.', a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
              { id: 'PR-V002', instr: 'Listen. Choose.', icon: 'ear', scene: 'GUIDE: I\'m from Canada. … from! … from', opts: [{ id: 'A', t: 'from' }, { id: 'B', t: 'friend' }, { id: 'C', t: 'fine' }], key: 'A', ok: "From! I'm FROM Canada.", no: "The word says your place: I'm ____ Canada. Try again.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V003', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL002', 'City half — streets and houses'), opts: [{ id: 'A', t: 'country' }, { id: 'B', t: 'city' }, { id: 'C', t: 'language' }], key: 'B', ok: 'City — streets and houses. Aroa is a city.', no: 'Look at the picture: streets and houses. Which word is that?', a11y: ['alt_text_construct_equivalent'] },
              { id: 'PR-V004', instr: 'Choose.', icon: 'choose', prompt: 'Kenya · They ____ English and Swahili.', opts: [{ id: 'A', t: 'say' }, { id: 'B', t: 'listen' }, { id: 'C', t: 'speak' }], key: 'C', ok: 'They speak English and Swahili. Speak + language!', no: 'A language goes with speak. Try again.', a11y: ['no_audio_required'] },
              { id: 'PR-V005', instr: 'Listen. Tap.', icon: 'ear', scene: 'NINA: Hi! I\'m Nina. I\'m from Peru.', kind: 'image', opts: [{ id: 'A', ill: ill('ILL005', 'Peru map card') }, { id: 'B', ill: ill('ILL011', 'Spain map card') }, { id: 'C', ill: ill('ILL004', 'Mexico map card') }], key: 'A', ok: 'Peru! Nina is from Peru. (She speaks Spanish.)', no: "Listen for the country word at the end: I'm from …", a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
              { id: 'PR-V006', instr: 'Look. Choose.', icon: 'eye', cumulative: true, prompt: 'GUIDE: How do you spell that? … language', opts: [{ id: 'A', t: 'langwige' }, { id: 'B', t: 'language' }, { id: 'C', t: 'langauge' }], key: 'B', ok: 'language. L-A-N-G-U-A-G-E.', no: 'Say it slowly, then look again: lan-guage.', a11y: ['no_audio_required', 'dynamic_type_to_XL'] }
            ],
            blended: 'AUD038 — GUIDE: country … city … from … language … English … speak … Now you: Canada is a country. Aroa is a city. I\'m from … I speak English.',
            tip: 'Tap-first cards. PR-V006 is the cumulative item — it retrieves the Chapter 2 spelling skill inside a Chapter 3 word.',
            assets: ['A1-C03-AUD002–007', 'A1-C03-AUD038']
          },
          {
            id: 'S05', type: 'cards', label: 'Set B teach — the cast five countries', step: 'STEP 4 · ≈4 min',
            chip: 'Canada · Mexico · Peru · Egypt · Australia', cards: setB,
            artRule: 'One shared visual grammar for all ten map cards (ILL003–012): simplified, textless world map in soft browns on cream; the country region filled warm orange; no borders with labels, no flags, no text. Region shape and position carry the meaning as well as colour.',
            tip: 'Five map cards; tap-to-flip the triple (country / nationality / languages); the cast member\'s hook line replays on each card in first person. Nationality adjectives and language names stay recognition-level — the productive target is the country name inside "I\'m from …".',
            assets: ['A1-C03-AUD008–012', 'A1-C03-ILL003–007']
          },
          {
            id: 'S06', type: 'practice', label: 'Set B practice + pause', step: 'STEP 4b',
            bank: 'PR-V007–V012 · 6 of 6 authored items shown',
            items: [
              { id: 'PR-V007', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: '5 map cards (ILL003–007) ↔ 5 country words', pairs: [['ILL003', 'Canada'], ['ILL004', 'Mexico'], ['ILL005', 'Peru'], ['ILL006', 'Egypt'], ['ILL007', 'Australia']], key: 'all five', ok: 'All five! The cast five.', no: 'Listen to the word, then look at the map shape and place.', a11y: ['tap_only_no_drag', 'no_positional_key'] },
              { id: 'PR-V008', instr: 'Listen. Tap.', icon: 'ear', scene: "MAYA: Hi! I'm Maya. I'm from Egypt.", kind: 'image', opts: [{ id: 'A', ill: ill('ILL009', 'Japan map card') }, { id: 'B', ill: ill('ILL004', 'Mexico map card') }, { id: 'C', ill: ill('ILL006', 'Egypt map card') }], key: 'C', ok: 'Egypt! Maya is from Egypt.', no: "Listen for the country word: I'm from …", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V009', instr: 'Choose.', icon: 'choose', prompt: 'Where is Alex from?', opts: [{ id: 'A', t: 'Canada' }, { id: 'B', t: 'Egypt' }, { id: 'C', t: 'Mexico' }], key: 'A', ok: 'Alex is from Canada. (English and French!)', no: 'Remember the hook: Alex speaks English and French.', a11y: ['no_audio_required'] },
              { id: 'PR-V010', instr: 'Choose.', icon: 'choose', scene: 'GUIDE: Where are you from?', opts: [{ id: 'A', t: 'My name is Mexico.' }, { id: 'B', t: "I'm from Mexico." }, { id: 'C', t: "I'm Mexico." }], key: 'B', ok: "I'm from Mexico. From + country!", no: 'The question asks your place, not your name. Use from.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V011', instr: 'Choose.', icon: 'choose', prompt: 'Canada · They speak English and ____.', opts: [{ id: 'A', t: 'Swahili' }, { id: 'B', t: 'Japanese' }, { id: 'C', t: 'French' }], key: 'C', ok: "English and French — Canada's two official languages.", no: "Listen to Alex's line again: English and …", a11y: ['no_audio_required'] },
              { id: 'PR-V012', instr: 'Listen. Tap.', icon: 'ear', scene: "SAM: Hi! I'm Sam. I'm from Mexico.", kind: 'image', opts: [{ id: 'A', ill: ill('ILL004', 'Mexico map card') }, { id: 'B', ill: ill('ILL005', 'Peru map card') }, { id: 'C', ill: ill('ILL003', 'Canada map card') }], key: 'A', ok: 'Mexico! Sam is from Mexico.', no: 'Sam speaks Spanish and English — but where is he from? Listen again.', a11y: ['audio_required_transcript_after_response'] }
            ],
            pauseCard: { head: 'Five dots on the wall!', body: 'Take a break — or one more time? Everything is saved either way.', at: '≈ minute 9' },
            blended: 'AUD039 — GUIDE: Canada — I\'m from Canada … Mexico — I\'m from Mexico … Peru — I\'m from Peru … Egypt — I\'m from Egypt … Australia — I\'m from Australia. … Five dots on the wall!',
            tip: 'The pause card sits at the end of this screen (≈ minute 9) with [continue] / [break]. Break exits cleanly; resume returns the learner to this card.',
            assets: ['A1-C03-AUD039', 'A1-C03-ILL003–007']
          },
          {
            id: 'S07', type: 'cards', label: 'Set C teach — the world five countries', step: 'STEP 5 · ≈4 min',
            chip: 'Brazil · Japan · Kenya · Spain · India', cards: setC,
            tip: 'Same card grammar as S05 for consistency, plus an optional "world tour" auto-sequence. These five have no cast owner, so the guide voice carries them: "Brazil — they speak Portuguese!" Ten countries across six continents; every card carries a creator note that the country has more languages and identities than the card names.',
            assets: ['A1-C03-AUD013–017', 'A1-C03-ILL008–012']
          },
          {
            id: 'S08', type: 'practice', label: 'Set C practice + pronunciation 1', step: 'STEP 5b',
            bank: 'PR-V013–V017 + PR-P001 · 6 of 6 authored items shown',
            items: [
              { id: 'PR-V013', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: '5 map cards (ILL008–012) ↔ 5 country words', pairs: [['ILL008', 'Brazil'], ['ILL009', 'Japan'], ['ILL010', 'Kenya'], ['ILL011', 'Spain'], ['ILL012', 'India']], key: 'all five', ok: 'Five more! Ten countries now.', no: 'Say the word, then look at the map shape and place.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-V014', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD016', kind: 'image', opts: [{ id: 'A', ill: ill('ILL008', 'Brazil map card') }, { id: 'B', ill: ill('ILL011', 'Spain map card') }, { id: 'C', ill: ill('ILL012', 'India map card') }], key: 'B', ok: 'Spain — SPAIN, one strong part.', no: 'One part, strong: SPAIN. Find it on the map.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V015', instr: 'Choose.', icon: 'choose', prompt: 'Japan · They speak ____.', opts: [{ id: 'A', t: 'Arabic' }, { id: 'B', t: 'Spanish' }, { id: 'C', t: 'Japanese' }], key: 'C', ok: 'Japanese — in Japan, they speak Japanese.', no: 'Same word twice: Japan → Japanese. Look again.', a11y: ['no_audio_required'] },
              { id: 'PR-V016', instr: 'Choose.', icon: 'choose', prompt: 'Where is Leo from?', opts: [{ id: 'A', t: 'Australia' }, { id: 'B', t: 'Canada' }, { id: 'C', t: 'Egypt' }], key: 'A', ok: 'Australia! Leo is from Australia.', no: 'Leo speaks English only — remember who speaks two languages.', a11y: ['no_audio_required'] },
              { id: 'PR-V017', instr: '', icon: 'tap', kind: 'sort', prompt: 'Two baskets, icon-cued by a demo animation: person-at-work · map-region. Five tiles: teacher · Brazil · driver · Spain · nurse', baskets: [{ icon: 'person at work', t: 'teacher · driver · nurse' }, { icon: 'map region', t: 'Brazil · Spain' }], key: 'jobs to the person basket, countries to the map basket', ok: 'Jobs — what people do. Countries — places on the map.', no: 'Look at the tile: a job is work a person does; a country is a place.', a11y: ['icon_cued_no_instruction_word', 'tap_only_no_drag'], note: '"sort" is NOT used as an instruction word — it is not in the controlled lexicon. The two-basket demo animation carries the meaning.' },
              { id: 'PR-P001', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD013', prompt: 'Tap the strong part: ○ ● or ● ○', opts: [{ id: 'A', t: 'BRA-zil (first part strong)' }, { id: 'B', t: 'bra-ZIL (second part strong)' }], key: 'B', ok: 'bra-ZIL — the last part is strong, like pe-RU.', no: 'Listen again — the strong part is at the end.', a11y: ['audio_required_transcript_after_response', 'stress_dots_min_44pt'] }
            ],
            blended: 'AUD040 — GUIDE: Brazil · Portuguese … Japan · Japanese … Kenya · Swahili and English … Spain · Spanish … India · Hindi and English. … Ten countries, five dots on the wall — and one dot for you!',
            tip: 'Stress dots render large (≥44 pt targets); colour plus position, never colour alone.',
            assets: ['A1-C03-AUD013–017', 'A1-C03-AUD040']
          },
          {
            id: 'S09', type: 'cards', label: 'Jobs teach — sets D + E', step: 'STEP 6 · ≈5 min',
            chip: 'nine jobs · set E attached', cards: jobs,
            attachedNote: 'Set E (designer, driver, cook, office worker) is 4 items — below the 5-item floor — so it is attached to Set D\'s teach block. Two of the four arrive with a cast voice and face (Leo the cook, Alex the designer).',
            frameNote: 'All lines use the fixed frame "I\'m a/an …" (V036). The a/an CHOICE rule is not taught until G009 in Lesson 2 — the article arrives inside the frame, never as a decision.',
            tip: 'Nine cards in one scroll, cast cards first (known faces anchor the set). ILL013–021.',
            assets: ['A1-C03-AUD018–026', 'A1-C03-ILL013–021']
          },
          {
            id: 'S10', type: 'practice', label: 'Jobs practice + pronunciation 2', step: 'STEP 6b',
            bank: 'PR-V018–V027 + PR-P002 · 11 of 11 authored items shown',
            items: [
              { id: 'PR-V018', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: '5 job cards (ILL013–017) ↔ 5 job words', pairs: [['ILL013', 'student'], ['ILL014', 'teacher'], ['ILL015', 'doctor'], ['ILL016', 'nurse'], ['ILL017', 'engineer']], key: 'all five', ok: 'Five jobs! And four more next.', no: 'Look at what the person holds and where they are — then match.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-V019', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD022', opts: [{ id: 'A', t: 'nurse' }, { id: 'B', t: 'engineer' }, { id: 'C', t: 'doctor' }], key: 'B', ok: 'en-gi-NEER — three parts, strong last.', no: 'Three parts, strong at the end. Listen once more.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V020', instr: 'Listen. Choose.', icon: 'ear', scene: "MAYA: Hi! I'm Maya. I'm a nurse.", opts: [{ id: 'A', t: 'teacher' }, { id: 'B', t: 'doctor' }, { id: 'C', t: 'nurse' }], key: 'C', ok: 'Maya is a nurse!', no: "Listen to the end: I'm a …", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V021', instr: 'Listen. Tap.', icon: 'ear', scene: "NINA: Good morning! I'm Nina. I'm a teacher.", kind: 'image', opts: [{ id: 'A', ill: ill('ILL014', 'Teacher card — Nina at the board') }, { id: 'B', ill: ill('ILL013', 'Student card') }, { id: 'C', ill: ill('ILL021', 'Office worker card') }], key: 'A', ok: 'Nina is a teacher.', no: 'Nina teaches — find the person at the front of the class.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V022', instr: 'Choose.', icon: 'choose', scene: 'SAM: Hi! What do you do?', opts: [{ id: 'A', t: "I'm student." }, { id: 'B', t: "I'm a student." }, { id: 'C', t: 'My name is a student.' }], key: 'B', ok: "I'm a student. Jobs take a/an.", no: "The question asks your job. Use I'm a + job.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V023', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: '4 job cards (ILL018–021) ↔ 4 job words — attached set E', pairs: [['ILL018', 'designer'], ['ILL019', 'driver'], ['ILL020', 'cook'], ['ILL021', 'office worker']], key: 'all four', ok: 'Nine jobs — the full set!', no: 'Look for the known faces: Alex designs, Leo cooks.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-V024', instr: 'Listen. Choose.', icon: 'ear', scene: "LEO: Ah! I'm Leo. I'm a cook.", opts: [{ id: 'A', t: 'driver' }, { id: 'B', t: 'designer' }, { id: 'C', t: 'cook' }], key: 'C', ok: 'Leo is a cook — at the café!', no: 'Leo works in the café kitchen. Listen for the job word.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V025', instr: 'Listen. Tap.', icon: 'ear', scene: "ALEX: Okay! I'm Alex. I'm a designer.", kind: 'image', opts: [{ id: 'A', ill: ill('ILL018', 'Designer card — Alex with sketchbook') }, { id: 'B', ill: ill('ILL019', 'Driver card') }, { id: 'C', ill: ill('ILL015', 'Doctor card') }], key: 'A', ok: 'Alex is a designer.', no: 'Alex draws and plans — look for the sketchbook.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V026', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD026', opts: [{ id: 'A', t: 'teacher' }, { id: 'B', t: 'office worker' }, { id: 'C', t: 'student' }], key: 'B', ok: 'OF-fice WOR-ker — two words, two strong firsts.', no: 'Two words — say them back and look again.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V027', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD024', kind: 'image', opts: [{ id: 'A', ill: ill('ILL020', 'Cook card') }, { id: 'B', ill: ill('ILL013', 'Student card') }, { id: 'C', ill: ill('ILL019', 'Driver card') }], key: 'C', ok: 'DRI-ver — at the wheel!', no: 'Listen for the /-er/ ending and find the person at work.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-P002', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD022', prompt: 'Three dot-patterns: ● ○ ○ / ○ ● ○ / ○ ○ ●', opts: [{ id: 'A', t: 'EN-gi-neer (first strong)' }, { id: 'B', t: 'en-GI-neer (middle strong)' }, { id: 'C', t: 'en-gi-NEER (last strong)' }], key: 'C', ok: 'en-gi-NEER — the strong part is LAST.', no: 'Listen once more — the strong part is at the end.', a11y: ['audio_required_transcript_after_response', 'stress_dots_min_44pt'] }
            ],
            blended: 'AUD041 — GUIDE: student · teacher · doctor · nurse · engineer … I\'m a student. I\'m a teacher. I\'m a doctor. I\'m a nurse. I\'m an engineer! · AUD042 — designer · driver · cook · office worker … ALEX: I\'m a designer! … LEO: I\'m a cook! … GUIDE: I\'m a driver. I\'m an office worker.',
            tip: 'Audio items allow one default replay. The basket icons in PR-V017 match the S09 card art exactly.',
            assets: ['A1-C03-AUD018–026', 'A1-C03-AUD041', 'A1-C03-AUD042']
          },
          {
            id: 'S11', type: 'cards', label: 'Chunks teach — sets F + G', step: 'STEP 7 · ≈4 min',
            chip: 'people, introducing, and the two big questions', cards: setF.concat(setG),
            panels: ['Panel F — people + introducing, centred on ILL022 with the hook exchange replayed: MAYA: Look! This is my friend Sam. / SAM: Nice to meet you! / LEO: Nice to meet you too.', 'Panel G — the "question machine": each card shows the frame as highlighted tiles over its hook line.'],
            upgrade: 'C1 upgrade callout: you already say "Nice to meet you" — today it grows a tail: "too."',
            tip: 'Two panels; frame tiles highlight FROM and too in orange. Chunk cards keep the "say it as one thing" link icon.',
            assets: ['A1-C03-AUD027–037', 'A1-C03-ILL022']
          },
          {
            id: 'S12', type: 'practice', label: 'Chunks practice + pronunciation 3–4 + close', step: 'STEP 7b',
            bank: 'PR-V028–V036 + PR-P003 + PR-P004 · 11 of 11 authored items shown',
            items: [
              { id: 'PR-V028', instr: 'Choose.', icon: 'choose', prompt: 'One person. … Ten ____.', opts: [{ id: 'A', t: 'person' }, { id: 'B', t: 'people' }], key: 'B', ok: 'One person, ten people!', no: 'Ten = many. Which word is many?', a11y: ['no_audio_required'] },
              { id: 'PR-V029', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL022', 'Photo card of Sam, cropped from the map-wall scene'), prompt: 'This is ____.', opts: [{ id: 'A', t: 'Sam' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Alex' }], key: 'A', ok: "This is Sam. Maya's friend!", no: "Look at WHO Maya's hand points to — the person she shows.", a11y: ['alt_text_construct_equivalent'] },
              { id: 'PR-V030', instr: 'Put in order.', icon: 'tap', kind: 'order', tiles: ['too', 'Nice', 'meet', 'you', 'to'], key: ['Nice', 'to', 'meet', 'you', 'too'], ok: "Nice to meet you TOO — the answer with 'also you' inside!", no: 'First word: Nice. Last word: too. Try again.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-V031', instr: 'Choose.', icon: 'choose', scene: 'SAM: Nice to meet you!', opts: [{ id: 'A', t: "I'm good." }, { id: 'B', t: 'Nice to meet you too.' }, { id: 'C', t: 'See you.' }], key: 'B', ok: 'Nice to meet you too!', no: 'This is a first meeting. Give the meeting reply back.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V032', instr: 'Choose.', icon: 'choose', prompt: 'Kenya · They speak ____ and English.', opts: [{ id: 'A', t: 'English' }, { id: 'B', t: 'Arabic' }, { id: 'C', t: 'Swahili' }], key: 'C', ok: "Swahili and English — Kenya's two official languages.", no: 'One language is already in the sentence. Which is the OTHER one?', a11y: ['no_audio_required'] },
              { id: 'PR-V033', instr: 'Choose.', icon: 'choose', scene: 'NINA: Where are you from?', opts: [{ id: 'A', t: "I'm from Canada." }, { id: 'B', t: "I'm a Canada." }, { id: 'C', t: 'My name is Canada.' }], key: 'A', ok: "I'm from Canada. From + country!", no: 'The question asks your PLACE. Use from.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V034', instr: 'Listen. Tap.', icon: 'ear', scene: "ALEX: Okay! I'm Alex. I'm from Canada.", kind: 'image', opts: [{ id: 'A', ill: ill('ILL006', 'Egypt map card') }, { id: 'B', ill: ill('ILL003', 'Canada map card') }, { id: 'C', ill: ill('ILL004', 'Mexico map card') }], key: 'B', ok: 'Alex is from Canada — English and French!', no: 'Where is Alex from? Listen for the country word.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-V035', instr: 'Put in order.', icon: 'tap', kind: 'order', tiles: ['from', 'are', 'you', 'Where'], key: ['Where', 'are', 'you', 'from'], ok: "Where are you from? — the lesson's big question!", no: 'First word asks the place: Where. Try again.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-V036', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL017', 'Engineer card with a question bubble: What do you do?'), opts: [{ id: 'A', t: "I'm a driver." }, { id: 'B', t: "I'm an office worker." }, { id: 'C', t: "I'm an engineer." }], key: 'C', ok: "I'm an engineer!", no: 'Look at the hat and the building site behind — which job is that?', a11y: ['alt_text_construct_equivalent'] },
              { id: 'PR-P003', instr: 'Listen. Tap.', icon: 'ear', scene: "GUIDE: I'm from CANADA. (country word stressed)", prompt: "Three tiles: I'm · from · Canada — tap the STRONG word", opts: [{ id: 'A', t: "I'm" }, { id: 'B', t: 'from' }, { id: 'C', t: 'Canada' }], key: 'C', ok: "CANADA! The country word carries the big beat — it's the new information.", no: 'Listen for the BIGGEST beat — the new word, the country.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-P004', instr: '', icon: 'mic', kind: 'speak', aud: 'AUD034', word: "I'm from + any country of the ten", ok: 'You said it! Your dot can go on the wall in Lesson 3.', no: 'Listen to the model once more, then try again — slow is fine.', a11y: ['icon_cued_no_instruction_word', 'mic_optional_never_blocks', 'never_scored', 'visible_skip'], note: 'Supported recording, icon-cued (the word "record" is stage 4 and activates in L2). The activity offers the ten taught countries only. The learner\'s real nationality is never asked, stored, or inferred; a skip button exits with no penalty.' }
            ],
            blended: 'AUD043 — GUIDE: friend · person · people … MAYA: This is my friend Sam! … SAM: Nice to meet you! … LEO: Nice to meet you too. · AUD044 — Where are you from? … I\'m from Peru. … Where is Alex from? … Alex is from Canada. … What do you do? … I\'m a teacher! … I\'m an engineer!',
            close: 'Stars for the three micro-set clusters. Next lesson: he, she, they, we — and the whole family of am/is/are.',
            tip: 'The mic activity is icon-only with a visible skip. The close card previews L2 with stars, not scores.',
            assets: ['A1-C03-AUD034', 'A1-C03-AUD043', 'A1-C03-AUD044']
          }
        ]
      },
      {
        id: 'L02', type: 'G+C', n: 2, title: 'He, She, They, We', time: '≈20 min', pause: 'after the possessives practice (≈9 min)',
        src: 'A1_C03_L02_LESSON.md',
        screens: [
          {
            id: 'S13', type: 'grammarModel', label: 'G007 teach 1 — the whole family of be', step: 'STEP 8',
            ill: ill('ILL023', 'Nina, Leo, Maya, Alex and Sam stand in a row beside the map wall, each with one empty speech bubble'),
            notice: [
              { aud: 'AUD045', task: "Sam says: He's from Australia. — WHO is from Australia?", chat: [
                { sp: 'SAM', t: "Leo is my friend. He's from Australia." },
                { sp: 'SAM', t: "Maya is my friend. She's from Egypt." },
                { sp: 'SAM', t: "Alex is my friend. They're from Canada." },
                { sp: 'SAM', t: "Nina and Maya are friends. They're from Peru and Egypt." },
                { sp: 'SAM', t: "And we — the class! … We're from ten countries!" }
              ] }
            ],
            paradigm: [
              ['I', 'I am', "I'm", "I'm from Peru."],
              ['you', 'you are', "you're", "You're from Mexico."],
              ['he', 'he is', "he's", "He's from Australia."],
              ['she', 'she is', "she's", "She's from Egypt."],
              ['they (one person, Alex)', 'they are', "they're", "They're from Canada."],
              ['they (two people)', 'they are', "they're", "They're from Peru and Egypt."],
              ['we', 'we are', "we're", "We're from ten countries."]
            ],
            explain: 'One person you point to: he or she. Alex: they. Two people: they. You + other people: we. After he/she say is. After they/we/you say are.',
            more: "More examples, all cast facts: She's a teacher. (Nina) · He's a cook. (Leo) · They're a designer. (Alex) · We're a class.",
            records: [
              { id: 'G007', title: 'He, she, they, we — the whole family of be', pattern: "he/she + is → he's/she's · they/we + are → they're/we're · not: isn't/aren't", errs: [['they is', 'they ARE — even for one person: Alex, they ARE a designer.'], ["she's from Egypt? as a question", 'questions flip: IS she from Egypt?'], ['he from Australia', 'He IS from Australia — be never disappears.']] }
            ],
            dockNote: 'The paradigm table is app-layer typography over textless art; tap a row to hear its line. Contractions are highlighted in orange, never spelled out in the audio.',
            notYet: 'Not yet allowed: past was/were · any verb besides be · it for people · questions beyond Is/Are/Where-from and the fixed chunk set.',
            tip: 'Teaching order per §10.5: example → meaning question → more examples → highlighted pattern → concise explanation → choice → tile order → contextual use → conversation transfer → later retrieval.',
            assets: ['A1-C03-AUD045', 'A1-C03-ILL023']
          },
          {
            id: 'S14', type: 'grammarModel', label: "G007 teach 2 — isn't, aren't, Is/Are…?", step: 'STEP 8b',
            ill: ill('ILL024', 'Sam smiles and softly waves a "no" hand beside the Mexico map card; Maya points at the Egypt card'),
            notice: [
              { aud: 'AUD046', task: 'Two people? Which word do you hear?', chat: [
                { sp: 'SAM', t: "I'm not from Peru. … I'm from Mexico!" },
                { sp: 'MAYA', t: "Sam isn't from Peru. He's from Mexico." },
                { sp: 'MAYA', t: "Alex and I aren't from Spain. … Alex is from Canada, and I'm from Egypt." },
                { sp: 'SAM', t: "Two people? Use aren't. … They aren't from Spain." }
              ] },
              { aud: 'AUD047', task: 'Which voice goes UP, and which goes DOWN?', chat: [
                { sp: 'ALEX', t: 'Is Leo from Australia?', ask: true },
                { sp: 'MAYA', t: 'Yes, he is!' },
                { sp: 'ALEX', t: 'Is Maya from Peru?', ask: true },
                { sp: 'MAYA', t: "No, she isn't. I'm from Egypt!" },
                { sp: 'ALEX', t: 'Are they from Kenya?', ask: true },
                { sp: 'MAYA', t: 'Yes, they are.' },
                { sp: 'GUIDE', t: 'The voice goes UP on the question … and DOWN on the answer. Is she a nurse? … Yes, she is.' }
              ] }
            ],
            patternTiles: ['Is + he/she …? ↑', 'Are + they/we …? ↑', 'Yes, he is. / No, she isn\'t.', 'Yes, they are. / No, they aren\'t.'],
            records: [
              { id: 'G007b', title: 'Negatives and questions', pattern: "isn't (one person) · aren't (two or more) · Is/Are + person …? + short answer", errs: [['Sam aren\'t from Peru.', "one person → isn't."], ['They isn\'t from Spain.', "two people → aren't."]] }
            ],
            dockNote: 'Up/down arrow glyphs sit over ILL025 as app-layer typography; one-tap replay per pair. The illustrations carry no crosses or X marks — a friendly no-gesture instead.',
            tip: 'Questions and short answers arrive together so the answer rhythm is learned with the question shape, never separately.',
            assets: ['A1-C03-AUD046', 'A1-C03-AUD047', 'A1-C03-ILL024', 'A1-C03-ILL025']
          },
          {
            id: 'S15', type: 'practice', label: 'G007 practice', step: 'STEP 8c',
            dock: "he/she + is → he's/she's   ·   they/we/you + are → they're/we're   ·   not: isn't / aren't",
            bank: 'PR-G001–G014 · 14 of 14 authored items shown, run in two rounds',
            ladder: 'Help ladder: replay → pattern row → example.',
            items: [
              { id: 'PR-G001', instr: '', icon: 'tap', kind: 'sort', prompt: 'Three baskets, icon-cued by a demo animation: am · is · are. Six frame tiles: I ___ from Peru. · Leo ___ from Australia. · Maya and Sam ___ friends. · We ___ a class. · Alex ___ a designer. · You ___ from Mexico.', baskets: [{ icon: 'am', t: 'I' }, { icon: 'is', t: 'Leo · Alex' }, { icon: 'are', t: 'Maya and Sam · We · You' }], key: 'am with I; is with one name; are with they/we/you', ok: 'is with he/she/one-name · are with they/we/you!', no: 'Say the sentence with the name first — the sound tells you: one Leo… is.', a11y: ['icon_cued_no_instruction_word', 'tap_only_no_drag'], note: 'Canon note: the Alex tile goes to IS because "Alex" is ONE NAME. The PRONOUN for Alex is they + ARE (PR-G005). The two items sit far apart with different art — the contrast is deliberate.' },
              { id: 'PR-G002', instr: 'Choose.', icon: 'choose', prompt: 'LEO (photo): ____ from Australia.', opts: [{ id: 'A', t: 'Leo is' }, { id: 'B', t: 'Leo am' }, { id: 'C', t: 'Leo are' }], key: 'A', ok: 'Leo is from Australia. One name → is.', no: "One person's name → is.", a11y: ['no_audio_required'] },
              { id: 'PR-G003', instr: 'Choose.', icon: 'choose', prompt: 'MAYA AND SAM (photo pair): ____ friends.', opts: [{ id: 'A', t: 'Maya and Sam is' }, { id: 'B', t: 'Maya and Sam are' }, { id: 'C', t: 'Maya and Sam am' }], key: 'B', ok: 'Two people → are. Maya and Sam are friends.', no: 'Count the people: two → are.', a11y: ['no_audio_required'] },
              { id: 'PR-G004', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: 'full form ↔ short form', pairs: [['he is', "he's"], ['she is', "she's"], ['they are', "they're"], ['we are', "we're"], ['I am', "I'm"], ['you are', "you're"]], key: 'all six', ok: "The little mark ' is the short form. Fast, natural English!", no: 'Listen to the model — the short form keeps the same first word.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-G005', instr: 'Choose.', icon: 'choose', prompt: 'ALEX is my friend. ____ a designer.', opts: [{ id: 'A', t: "They're" }, { id: 'B', t: "He's" }, { id: 'C', t: "She's" }], key: 'A', ok: "Alex is they: They're a designer.", no: "Alex's word is THEY (you met this in Chapter 1!). Try again.", a11y: ['no_audio_required'], note: 'Singular-they keystone. Pronouns come from the person, not the picture — the referent is named explicitly on every card.' },
              { id: 'PR-G006', instr: 'Choose.', icon: 'choose', prompt: 'SAM (photo) + Peru map card crossed softly: Sam ____ from Peru.', opts: [{ id: 'A', t: "aren't" }, { id: 'B', t: "isn't" }, { id: 'C', t: "'m not" }], key: 'B', ok: "Sam isn't from Peru. He's from Mexico!", no: "One person → isn't.", a11y: ['no_audio_required'] },
              { id: 'PR-G007', instr: 'Choose.', icon: 'choose', prompt: 'MAYA AND LEO (photo pair) + Spain map card: They ____ from Spain.', opts: [{ id: 'A', t: "isn't" }, { id: 'B', t: "'m not" }, { id: 'C', t: "aren't" }], key: 'C', ok: "They aren't from Spain. Maya's from Egypt and Leo's from Australia.", no: "Two people → aren't.", a11y: ['no_audio_required'] },
              { id: 'PR-G008', instr: 'Choose.', icon: 'choose', prompt: '____ she from Kenya?', opts: [{ id: 'A', t: 'Are' }, { id: 'B', t: 'Is' }, { id: 'C', t: 'Am' }], key: 'B', ok: 'Is she from Kenya? — Yes, she is!', no: 'she → is.', a11y: ['no_audio_required'] },
              { id: 'PR-G009', instr: 'Choose.', icon: 'choose', scene: 'ALEX: Is Leo from Australia?', opts: [{ id: 'A', t: 'Yes, she is.' }, { id: 'B', t: 'Yes, he are.' }, { id: 'C', t: 'Yes, he is.' }], key: 'C', ok: "Yes, he is! Leo's from Australia.", no: 'Listen to the question word: Is HE…?', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-G010', instr: 'Choose.', icon: 'choose', scene: 'SAM: Is Maya from Peru?', opts: [{ id: 'A', t: 'Yes, she is.' }, { id: 'B', t: "No, she isn't." }, { id: 'C', t: "No, he isn't." }], key: 'B', ok: "No, she isn't. She's from Egypt!", no: "Two cast facts to check: Maya's country, and the pronoun.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-G011', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: 'photo cards ↔ person words — every referent is named on its card', pairs: [['MAYA', 'she'], ['LEO', 'he'], ['ALEX', 'they (Alex)'], ['MAYA AND SAM', 'they (two)'], ['YOU AND THE CLASS', 'we']], key: 'all five', ok: 'Every pronoun has its person — and Alex is they.', no: 'Look at the name(s) on the card, not the picture alone.', a11y: ['tap_only_no_drag', 'referent_named_explicitly'] },
              { id: 'PR-G012', instr: 'Choose.', icon: 'choose', prompt: 'Where ____ Nina from?', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'am' }, { id: 'C', t: 'is' }], key: 'C', ok: "Where is Nina from? — She's from Peru.", no: 'One person → is.', a11y: ['no_audio_required'] },
              { id: 'PR-G013', instr: 'Put in order.', icon: 'tap', kind: 'order', tiles: ["isn't", 'He', 'Australia', 'from'], key: ['He', "isn't", 'from', 'Australia'], ok: "He isn't from Australia — Sam isn't; Leo is!", no: 'Start with the person word: He.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-G014', instr: 'Choose.', icon: 'choose', prompt: 'THE CLASS (photo, all five cast + learner): We ____ from ten countries.', opts: [{ id: 'A', t: 'am' }, { id: 'B', t: 'is' }, { id: 'C', t: 'are' }], key: 'C', ok: "We're from ten countries!", no: 'We = many people → are.', a11y: ['no_audio_required'] }
            ],
            tip: 'Sort baskets reuse the S13 art. Keep the pattern dock available throughout — tappable any time, never scored.',
            assets: ['A1-C03-AUD045–047', 'A1-C03-ILL023']
          },
          {
            id: 'S16', type: 'practice', label: 'G008 teach + practice — his, her, their, our', step: 'STEP 9',
            teach: {
              ill: ill('ILL026', 'Five friends stand in a loose circle; soft arcs connect each person to the things they point at'),
              notice: [{ aud: 'AUD048', task: 'Maya says: OUR teacher. Who is our?', chat: [
                { sp: 'MAYA', t: 'This is Leo. … His name is Leo. His phone is six two zero … one five four.' },
                { sp: 'SAM', t: 'And Maya! … Her email is maya dot haddad at aroa dot com.' },
                { sp: 'MAYA', t: 'Alex — their email is alex dot kim at aroa dot com.' },
                { sp: 'SAM', t: 'And Nina! Nina is our teacher. … Our class is from ten countries!' }
              ] }],
              patternTiles: ['my · your (Chapter 1!)', '→ his · her · their · our', 'the set is complete now'],
              explain: "his = a man's or boy's, her = a woman's or girl's, their = Alex's AND two people's, our = we + you. The word after says WHAT: name, phone, email, country, job, teacher.",
              records: [{ id: 'G008', title: 'His, her, their, our — whose is it?', pattern: 'he→his · she→her · they→their · we→our · + noun', errs: [['His is Sam.', 'His NAME is Sam — a noun must follow.'], ['her/his sound confusion', 'the /h/ is pronounced, even though it looks soft.'], ["Maya's country", 'at A1: Her country. The possessive \u2019s is G010 in Chapter 5.']] }],
              notYet: "Not yet allowed: possessive 's (Maya's) · whose · mine/yours/his as standalone forms.",
              canon: 'Canon check: Leo 6-2-0 1-5-4 ✓ · maya.haddad@aroa.com ✓ · alex.kim@aroa.com ✓ — all bible-fixed before use.'
            },
            bank: 'PR-G015–G022 · 8 of 8 authored items shown',
            items: [
              { id: 'PR-G015', instr: 'Choose.', icon: 'choose', prompt: 'LEO photo + phone icon: ____ phone is 6-2-0, 1-5-4.', opts: [{ id: 'A', t: 'Her' }, { id: 'B', t: 'Their' }, { id: 'C', t: 'His' }], key: 'C', ok: "His phone! Leo's number — from Chapter 2.", no: 'Leo → he → his.', a11y: ['no_audio_required'] },
              { id: 'PR-G016', instr: 'Choose.', icon: 'choose', prompt: 'MAYA photo + email icon: ____ email is maya.haddad@aroa.com.', opts: [{ id: 'A', t: 'His' }, { id: 'B', t: 'Our' }, { id: 'C', t: 'Her' }], key: 'C', ok: 'Her email — maya.haddad@aroa.com!', no: 'Maya → she → her.', a11y: ['no_audio_required'] },
              { id: 'PR-G017', instr: 'Choose.', icon: 'choose', prompt: 'ALEX photo + email icon: ____ email is alex.kim@aroa.com.', opts: [{ id: 'A', t: 'Their' }, { id: 'B', t: 'His' }, { id: 'C', t: 'Her' }], key: 'A', ok: 'Their email — alex.kim@aroa.com!', no: 'Alex is they → their.', a11y: ['no_audio_required'], note: 'The photo never overrides the name — pronouns come from the person.' },
              { id: 'PR-G018', instr: 'Choose.', icon: 'choose', prompt: 'CLASS photo + NINA at the front: Nina is ____ teacher.', opts: [{ id: 'A', t: 'our' }, { id: 'B', t: 'their' }, { id: 'C', t: 'her' }], key: 'A', ok: 'Nina is our teacher!', no: 'You are in the class → our.', a11y: ['no_audio_required'] },
              { id: 'PR-G019', instr: '', icon: 'tap', kind: 'sort', prompt: 'Four baskets, icon-cued: his · her · their · our. Cards: LEO+phone · MAYA+email · ALEX+email · CLASS+Nina · MAYA AND SAM+map card · YOU+name tag', baskets: [{ icon: 'his', t: 'LEO' }, { icon: 'her', t: 'MAYA' }, { icon: 'their', t: 'ALEX · MAYA AND SAM' }, { icon: 'our', t: 'CLASS · YOU' }], key: 'whose-word matches the named person on each card', ok: 'Whose? his, her, their, our!', no: 'Whose card is it? Say the name, then the little word.', a11y: ['icon_cued_no_instruction_word', 'tap_only_no_drag'] },
              { id: 'PR-G020', instr: 'Choose.', icon: 'choose', scene: 'The guide plays a learner line: HIS IS SAM.', opts: [{ id: 'A', t: 'His name is Sam.' }, { id: 'B', t: 'Her name is Sam.' }, { id: 'C', t: 'He name is Sam.' }], key: 'A', ok: 'His NAME is Sam. A thing-word must follow!', no: 'his + what? Name, phone, email, country…', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-G021', instr: 'Choose.', icon: 'choose', prompt: 'MAYA photo + EGYPT map card: Egypt is ____ country.', opts: [{ id: 'A', t: 'their' }, { id: 'B', t: 'her' }, { id: 'C', t: 'our' }], key: 'B', ok: "Egypt is her country. Maya's from Egypt!", no: 'One woman → her.', a11y: ['no_audio_required'] },
              { id: 'PR-G022', instr: 'Match.', icon: 'match', kind: 'pairs', prompt: 'person word ↔ whose-word', pairs: [['he', 'his'], ['she', 'her'], ['they', 'their'], ['we', 'our'], ['I', 'my'], ['you', 'your']], key: 'all six', ok: 'The full family: my, your, his, her, their, our!', no: 'Each person word has its own whose-word.', a11y: ['tap_only_no_drag'] }
            ],
            pauseCard: { head: 'Halfway!', body: 'The be family and the whose-words are yours. Take a break — or keep going?', at: '≈ minute 9' },
            tip: 'The possessive-circle art animates its arcs on tap. No contractions in this record — a deliberate relief point after G007.',
            assets: ['A1-C03-AUD048', 'A1-C03-ILL026']
          },
          {
            id: 'S17', type: 'practice', label: 'G009 teach + practice — a or an?', step: 'STEP 10',
            teach: {
              ill: ill('ILL027', 'Nine small job illustrations arranged on two trays; one tray holds a group of seven, the other a group of two'),
              notice: [{ aud: 'AUD049', task: 'Why an engineer? Because engineer STARTS WITH…', chat: [
                { sp: 'GUIDE', t: 'A student … a teacher … a doctor … a nurse … a designer … a driver … a cook.' },
                { sp: 'GUIDE', t: 'And now listen to the first SOUND: … an engineer … an office worker.' },
                { sp: 'GUIDE', t: 'A — when the word starts with a consonant sound. … An — when it starts with a vowel sound. … The sound decides, not the letter!' }
              ] }],
              patternTiles: ['consonant sound → a + job', 'vowel sound → an + job'],
              explain: 'an + vowel sound (a-e-i-o-u sounds). a + every other sound. Jobs say who you are: I\'m a cook. I\'m an engineer.',
              records: [{ id: 'G009', title: 'A or an? — your ears decide', pattern: 'consonant sound → a + job · vowel sound → an + job', errs: [["I'm teacher", "I'm A teacher — the little word is not optional in English."], ['an teacher / a engineer', 'mixing by letter, not sound. an goes before vowel SOUNDS.']] }],
              notYet: 'Not yet allowed: the · a/an with plurals · letter-vs-sound traps outside the nine jobs.'
            },
            bank: 'PR-G023–G030 · 8 of 8 authored items shown',
            items: [
              { id: 'PR-G023', instr: 'Choose.', icon: 'choose', prompt: "I'm ____ engineer.", opts: [{ id: 'A', t: 'a' }, { id: 'B', t: 'an' }], key: 'B', ok: 'an engineer — the sound decides!', no: 'Say the next word: EN-gineer. Vowel sound first → an.', a11y: ['no_audio_required'] },
              { id: 'PR-G024', instr: 'Choose.', icon: 'choose', prompt: "She's ____ nurse.", opts: [{ id: 'A', t: 'an' }, { id: 'B', t: 'a' }], key: 'B', ok: 'a nurse — like Maya!', no: 'NURSE starts with /n/ → a.', a11y: ['no_audio_required'] },
              { id: 'PR-G025', instr: 'Choose.', icon: 'choose', prompt: "He's ____ office worker.", opts: [{ id: 'A', t: 'a' }, { id: 'B', t: 'an' }], key: 'B', ok: 'an office worker!', no: 'OF-fice — vowel sound first → an.', a11y: ['no_audio_required'] },
              { id: 'PR-G026', instr: 'Choose.', icon: 'choose', prompt: 'Leo is ____ cook.', opts: [{ id: 'A', t: 'an' }, { id: 'B', t: 'a' }], key: 'B', ok: 'a cook — Leo at the café!', no: 'COOK starts with /k/ → a.', a11y: ['no_audio_required'] },
              { id: 'PR-G027', instr: '', icon: 'tap', kind: 'sort', prompt: 'Two trays, icon-cued (an ear icon sits on the an tray): nine job tiles → tray a or tray an', baskets: [{ icon: 'a', t: 'student · teacher · doctor · nurse · designer · driver · cook' }, { icon: 'an', t: 'engineer · office worker' }], key: 'seven to a, two to an', ok: 'Seven and two — the sounds split the nine!', no: 'Say the job out loud — vowel sound at the start → an tray.', a11y: ['icon_cued_no_instruction_word', 'tap_only_no_drag'] },
              { id: 'PR-G028', instr: 'Choose.', icon: 'choose', scene: "The guide plays a learner line: I'M AN TEACHER.", opts: [{ id: 'A', t: "I'm a teacher." }, { id: 'B', t: "I'm an teacher." }, { id: 'C', t: "I'm teacher." }], key: 'A', ok: 'a teacher! TEA-cher starts with /t/.', no: 'Listen to the first sound of the job word.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-G029', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL015', 'Doctor job card with a question bubble: What do you do?'), opts: [{ id: 'A', t: "I'm from Spain." }, { id: 'B', t: "I'm an office worker." }, { id: 'C', t: "I'm a doctor." }], key: 'C', ok: "I'm a doctor!", no: 'Match the card and keep the little word a.', a11y: ['alt_text_construct_equivalent'] },
              { id: 'PR-G030', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL017', 'Engineer job card (woman, glasses, hard hat) with a question bubble: What do you do?'), opts: [{ id: 'A', t: "I'm a driver." }, { id: 'B', t: "I'm an engineer." }, { id: 'C', t: "I'm a engineer." }], key: 'B', ok: "I'm an engineer!", no: 'The hat and tablet say engineer — and its sound says an.', a11y: ['alt_text_construct_equivalent'] }
            ],
            tip: 'Two-tray art with an ear icon on the an-tray; sound-first feedback plays the job word before the article.',
            assets: ['A1-C03-AUD049', 'A1-C03-ILL027']
          },
          {
            id: 'S18', type: 'conversation', label: 'Conversation play — At the Corner Shop', step: 'STEP 11',
            pkg: 'A1-C03-D01 — At the Corner Shop · learning take',
            scenario: 'The Aroa corner shop where Sam works, the same afternoon as the map wall. Sam behind the counter; Alex shops; Sam shows a photo of Maya.',
            aud: 'AUD050', lineAud: 'AUD050', delivery: 'learning_slow_clear',
            panels: ['ILL028', 'ILL029'],
            turns: [
              { n: 'T01', sp: 'SAM', t: 'Hi! Welcome to the shop! … Alex is here.' },
              { n: 'T02', sp: 'ALEX', t: 'Hi! Sam — are you from Mexico?' },
              { n: 'T03', sp: 'SAM', t: 'Yes, I am! … And you? Where are you from?' },
              { n: 'T04', sp: 'ALEX', t: "I'm from Canada. I speak English and French." },
              { n: 'T05', sp: 'SAM', t: 'Two languages! Okay, okay! … What do you do?' },
              { n: 'T06', sp: 'ALEX', t: "I'm a designer. … Look!", d: 'shows tablet' },
              { n: 'T07', sp: 'SAM', t: 'Nice! … And this — this is my friend Maya.', d: 'shows photo' },
              { n: 'T08', sp: 'ALEX', t: 'Is she a nurse?' },
              { n: 'T09', sp: 'SAM', t: "Yes, she is! She's from Egypt. Her languages are Arabic and English." },
              { n: 'T10', sp: 'ALEX', t: "Your friends! They're from ten countries. … See you, Sam!" }
            ],
            map: [['Are you …? + short answer', 'T02, T03 — G004 retrieval'], ['Where are you from?', 'T03 — V032'], ["I'm from …", 'T04 — V033'], ['speak + languages', 'T04, T09 — V006'], ['What do you do?', 'T05 — V035'], ["I'm a/an …", 'T06 — V036 + G009'], ['This is my friend …', 'T07 — V029'], ['Is he/she …? + short answer', 'T08, T09 — G007 NEW'], ["she's (3rd person)", 'T09 — G007'], ['her (possessive)', 'T09 — G008'], ["they're", 'T10 — G007'], ['your', 'T10 — G002 retrieval']],
            challengeNote: 'AUD051 is the challenge take: the same 10 turns re-performed at ≈120–130 wpm with fully blended contractions — never a sped-up edit of the learning take. It stays gated behind the learning take.',
            lock: 'Listen first. The transcript releases on pass 3.',
            tip: 'Turn-by-turn chips; the challenge take is gated behind the learning take. Two recurring cast voices run every chapter frame in one exchange — the §9.3 "meet two recurring characters" mission link.',
            assets: ['A1-C03-AUD050', 'A1-C03-AUD051', 'A1-C03-ILL028', 'A1-C03-ILL029']
          },
          {
            id: 'S19', type: 'practice', label: 'Conversation practice', step: 'STEP 11b',
            bank: 'PR-CV001–CV012 · 12 of 12 authored items shown',
            items: [
              { id: 'PR-CV001', instr: 'Listen. Choose.', icon: 'ear', scene: 'SAM: Where are you from?', opts: [{ id: 'A', t: "I'm a student." }, { id: 'B', t: 'My name is Kenya.' }, { id: 'C', t: "I'm from Kenya." }], key: 'C', ok: "I'm from Kenya. Place question, place answer.", no: 'WHERE asks a place. Use from.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV002', instr: 'Listen. Choose.', icon: 'ear', scene: 'ALEX: What do you do?', opts: [{ id: 'A', t: "I'm from Spain." }, { id: 'B', t: 'Nice to meet you too.' }, { id: 'C', t: "I'm a driver." }], key: 'C', ok: "I'm a driver. Job question, job answer!", no: "This question asks WORK. I'm a/an + job.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV003', instr: 'Listen. Choose.', icon: 'ear', scene: 'SAM: This is my friend Maya.', opts: [{ id: 'A', t: 'Nice to meet you!' }, { id: 'B', t: 'See you!' }, { id: 'C', t: "I'm good." }], key: 'A', ok: 'Nice to meet you! The first-meeting reply.', no: 'Someone new is in front of you — give the meeting reply.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV004', instr: 'Listen. Choose.', icon: 'ear', scene: 'D01-T08 (Alex): Is she a nurse?', prompt: 'What does Alex ask about?', opts: [{ id: 'A', t: 'her job' }, { id: 'B', t: 'her name' }, { id: 'C', t: 'her country' }], key: 'A', ok: 'A job question! Is she a + job?', no: "What comes after 'Is she a…'? A job word.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV005', instr: 'Listen. Choose.', icon: 'ear', scene: 'D01-T03 (Sam): And you? Where are you from?', prompt: 'What does Sam ask about?', opts: [{ id: 'A', t: 'your job' }, { id: 'B', t: 'your country' }, { id: 'C', t: 'your phone number' }], key: 'B', ok: 'Your country! Where + from.', no: 'WHERE = place. It wants your country.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV006', instr: 'Listen. Choose.', icon: 'ear', scene: "D01-T10 (Alex): Your friends! They're from ten countries.", prompt: 'What does the line count?', opts: [{ id: 'A', t: 'one city' }, { id: 'B', t: 'two jobs' }, { id: 'C', t: 'many countries' }], key: 'C', ok: 'Ten countries! Many places, many friends.', no: 'Ten = the count of countries.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV007', instr: 'Put in order.', icon: 'tap', kind: 'order', tiles: ['SAM: Yes, I am! And you?', 'ALEX: See you, Sam!', 'SAM: Hi! Welcome to the shop!', 'ALEX: Hi! Sam — are you from Mexico?'], key: ['SAM: Hi! Welcome to the shop!', 'ALEX: Hi! Sam — are you from Mexico?', 'SAM: Yes, I am! And you?', 'ALEX: See you, Sam!'], ok: 'Greet → ask → answer → close. Every good talk!', no: 'Which line STARTS a talk? Put it first.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-CV008', instr: 'Put in order.', icon: 'tap', kind: 'order', tiles: ['Nice to meet you too.', 'This is my friend Maya.', 'Nice to meet you!'], key: ['This is my friend Maya.', 'Nice to meet you!', 'Nice to meet you too.'], ok: 'Introduce → meet → meet-back. The three-step welcome!', no: 'The introduction comes first — someone must BE introduced.', a11y: ['tap_only_no_drag'] },
              { id: 'PR-CV009', instr: 'Listen. Choose.', icon: 'ear', prompt: 'YOU are from Japan. Sam asks…', scene: 'SAM: Are you from Mexico?', opts: [{ id: 'A', t: "No, I'm not. I'm from Japan." }, { id: 'B', t: 'Yes, I am.' }, { id: 'C', t: "No, she isn't." }], key: 'A', ok: "No, I'm not. I'm from Japan — your facts, your answer.", no: 'Check WHO is asked and WHERE you are from.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV010', instr: 'Listen. Choose.', icon: 'ear', prompt: 'About Leo — the café cook.', scene: 'ALEX: Is Leo a cook?', opts: [{ id: 'A', t: 'Yes, he is.' }, { id: 'B', t: 'Yes, she is.' }, { id: 'C', t: "No, he isn't." }], key: 'A', ok: 'Yes, he is! Leo cooks at the café.', no: 'Two checks: the pronoun (he) and the fact (cook).', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV011', instr: 'Listen. Choose.', icon: 'ear', prompt: 'Your card says: STUDENT.', scene: 'ALEX: What do you do?', opts: [{ id: 'A', t: "I'm from Spain." }, { id: 'B', t: "I'm a student." }, { id: 'C', t: "I'm an office worker." }], key: 'B', ok: "I'm a student!", no: 'Read your card — and use the job frame.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-CV012', instr: 'Listen. Choose.', icon: 'ear', prompt: "Maya shows you a photo: 'This is my friend Sam.'", scene: 'MAYA: This is my friend Sam.', opts: [{ id: 'A', t: "I'm good, Sam." }, { id: 'B', t: 'See you, Sam.' }, { id: 'C', t: 'Nice to meet you, Sam!' }], key: 'C', ok: 'Nice to meet you, Sam!', no: 'First meeting → the meeting reply.', a11y: ['audio_required_transcript_after_response'] }
            ],
            tip: 'Branch items show a context card plus the photo; one default replay. The branch prompt bank is AUD056.',
            assets: ['A1-C03-AUD050', 'A1-C03-AUD056']
          },
          {
            id: 'S20', type: 'testlet', label: 'Listening ladder', step: 'STEP 11c',
            rung: 'GIST → DETAIL → RESPONSE → TRANSFER', support: 'Three testlets, shared stimuli, one default replay per item',
            ill: ill('ILL030', 'The community-class room seen from the door — a few chairs, the dotted map wall, morning light'),
            ids: 'LS001–LS010',
            groups: [
              { n: 'Testlet A', stim: 'AUD050 — D01 learning take', ids: 'LS001–004', note: 'Shared stimulus; dependence documented — each item probes a different layer of the same listen.' },
              { n: 'Testlet B', stim: 'AUD051 — D01 challenge take', ids: 'LS005–006', note: 'A fresh recording at ≈120–130 wpm, never a sped-up edit.' },
              { n: 'Testlet C', stim: 'AUD052 — fresh mini-dialogue (Maya + Sam, 6 turns)', ids: 'LS007–010', note: 'Transfer rung: new voice pairing, new combination. Every line is taught frames only — no untaught glue.' }
            ],
            transferScript: [
              { sp: 'MAYA', t: 'Good afternoon, Sam!' },
              { sp: 'SAM', t: 'Hi, Maya! Is Leo from Australia?' },
              { sp: 'MAYA', t: "Yes, he is! And Nina — she's from Peru." },
              { sp: 'SAM', t: 'And Alex? Is Alex from Egypt?' },
              { sp: 'MAYA', t: "No, Alex isn't from Egypt. Alex is from Canada!" },
              { sp: 'SAM', t: "Okay, okay! Our class — we're from ten countries!" }
            ],
            items: [
              { id: 'PR-LS001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD050', prompt: 'What is this?', opts: [{ id: 'A', t: 'two friends at the shop' }, { id: 'B', t: 'a class at the Community House' }, { id: 'C', t: 'a doctor and a nurse at the hospital' }], key: 'A', ok: 'Sam and Alex — at the corner shop.', no: 'Where are the voices? Listen to the first line.', a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
              { id: 'PR-LS002', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD050', prompt: 'Where is Alex from? (replay, T03–T04)', kind: 'image', opts: [{ id: 'A', ill: ill('ILL003', 'Canada map card') }, { id: 'B', ill: ill('ILL006', 'Egypt map card') }, { id: 'C', ill: ill('ILL004', 'Mexico map card') }], key: 'A', ok: 'Alex is from Canada.', no: "Listen for 'I'm from …' after 'Where are you from?'", a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
              { id: 'PR-LS003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD050', prompt: 'Alex is a ____. (replay, T05–T06)', opts: [{ id: 'A', t: 'driver' }, { id: 'B', t: 'designer' }, { id: 'C', t: 'cook' }], key: 'B', ok: 'A designer — with the tablet!', no: "'What do you do?' — then listen for the job word.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD050', prompt: 'Maya is a ____. (replay, T07–T09)', opts: [{ id: 'A', t: 'teacher' }, { id: 'B', t: 'nurse' }, { id: 'C', t: 'doctor' }], key: 'B', ok: 'A nurse — yes, she is!', no: "'Is she a nurse?' — what was the answer?", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS005', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD051', prompt: 'Who is from Egypt?', opts: [{ id: 'A', t: 'Alex' }, { id: 'B', t: 'Leo' }, { id: 'C', t: 'Maya' }], key: 'C', ok: "Maya — she's from Egypt.", no: 'Faster voices — listen for the country words.', a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
              { id: 'PR-LS006', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD051', prompt: "Who says 'two languages' in the talk?", opts: [{ id: 'A', t: 'Leo' }, { id: 'B', t: 'Sam' }, { id: 'C', t: 'Alex' }], key: 'B', ok: "Sam says it — about Alex's two languages!", no: "Listen for the words 'two languages' — whose voice says them?", a11y: ['audio_required_transcript_after_response'], note: 'Rewritten in-session to the who-SAYS-it form: the original "who speaks two languages?" had three correct answers.' },
              { id: 'PR-LS007', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD052', prompt: 'Is Leo from Australia? (replay, T02)', opts: [{ id: 'A', t: 'Yes, he is.' }, { id: 'B', t: "No, he isn't." }, { id: 'C', t: 'Yes, she is.' }], key: 'A', ok: 'Yes, he is!', no: "The short answer copies the question's person word.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS008', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD052', prompt: 'Where is Alex from? (replay, T04–T05)', kind: 'image', opts: [{ id: 'A', ill: ill('ILL003', 'Canada map card') }, { id: 'B', ill: ill('ILL006', 'Egypt map card') }, { id: 'C', ill: ill('ILL005', 'Peru map card') }], key: 'A', ok: "Canada! Alex isn't from Egypt.", no: "Listen after 'isn't from Egypt' — the correction says the country.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS009', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD052', prompt: "We're from ten countries — who is we? (replay, T06)", opts: [{ id: 'A', t: 'Sam and Maya only' }, { id: 'B', t: 'the class' }, { id: 'C', t: 'Leo and Nina only' }], key: 'B', ok: "The class! Sam says: our class, we're from ten countries.", no: "Listen for 'our class' — we is bigger than two.", a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS010', instr: 'Listen. Choose.', icon: 'ear', scene: "Fresh single line — NINA: Leo is my friend. He's a cook.", prompt: "Leo's job?", opts: [{ id: 'A', t: 'teacher' }, { id: 'B', t: 'driver' }, { id: 'C', t: 'cook' }], key: 'C', ok: "A cook — he's! New voice, same grammar.", no: "Whose job is asked? LEO's — not the speaker's.", a11y: ['audio_required_transcript_after_response'] }
            ],
            tip: 'Testlet headers carry the shared-stimulus note; transcripts stay hidden until answered; replays are logged and never penalized.',
            assets: ['A1-C03-AUD050', 'A1-C03-AUD051', 'A1-C03-AUD052', 'A1-C03-ILL030']
          },
          {
            id: 'S21', type: 'pronPerceive', label: 'Pronunciation — contractions and question voice', step: 'STEP 12',
            items: [
              { id: 'PR-P005', instr: 'Listen. Tap.', prompt: "Which one? (AUD053 line 1, item 3)", aud: 'AUD053', opts: [{ id: 'A', t: "he's" }, { id: 'B', t: "she's" }], key: 'A', note: "/h/ against /ʃ/ — air from an open mouth against a shush." },
              { id: 'PR-P006', instr: 'Listen. Tap.', prompt: "GUIDE: Maya and Leo aren't from Spain. — which word?", opts: [{ id: 'A', t: "aren't" }, { id: 'B', t: "isn't" }], key: 'A', note: 'Count the people you heard: two → aren\'t.' },
              { id: 'PR-P007', instr: 'Say. Repeat.', prompt: 'Say the short form after each full form: she is → she\'s · he is → he\'s · they are → they\'re · we are → we\'re', aud: 'AUD055', opts: [], key: '', note: 'Supported production, self-paced, never scored. Any natural attempt counts.' },
              { id: 'PR-P008', instr: 'Listen. Tap.', prompt: 'Arrow up or arrow down? (AUD054 pair 1 — Is she a nurse?)', aud: 'AUD054', opts: [{ id: 'A', t: 'question — voice UP' }, { id: 'B', t: 'answer — voice DOWN' }], key: 'A', note: 'Arrows only on the first pass — no text.' },
              { id: 'PR-P009', instr: 'Listen. Record. Play. Check.', prompt: "Record: No, he isn't. — with the DOWN voice. Model: GUIDE: Is Leo from Peru? … No, he isn't.", opts: [], key: '', note: "Stage-4 instruction words (record / play / check) activate here for the first time. Replayable, never scored." },
              { id: 'PR-P010', instr: 'Listen. Tap.', prompt: 'Which one? (AUD053 line 2, item 2)', aud: 'AUD053', opts: [{ id: 'A', t: "we're" }, { id: 'B', t: "they're" }], key: 'A', note: '/w/ against /ð/ — round lips first against tongue first.' }
            ],
            tip: 'Intonation uses arrows, not text. The mic uses the stage-4 demo. All production is self-paced; no accent scoring, ever.',
            assets: ['A1-C03-AUD053', 'A1-C03-AUD054', 'A1-C03-AUD055']
          },
          {
            id: 'S22', type: 'review', label: 'Lesson close', step: 'STEP 12b',
            head: 'You can talk about OTHER people now.',
            lines: ["he's, she's, they're, we're", 'his, her, their, our', 'a cook, an engineer'],
            gallery: setG, auds: ['AUD053 — minimal-pair chain', 'AUD055 — contraction drill'],
            sweep: 'Retrieval sweep before the close card: three mixed taps — one be-form, one possessive, one article.',
            next: 'Next lesson: profile cards, your introduction roleplay, and the chapter quiz. Your dot goes on the wall!',
            rings: 3, ringsFilled: 3,
            tip: 'Same review ritual as C1-S09 and C2-S11. Three taps, then one honest preview card — no lock, no score.',
            assets: ['A1-C03-AUD053', 'A1-C03-AUD055']
          }
        ]
      },
      {
        id: 'L03', type: 'R+M', n: 3, title: 'Profile Cards and Your Dot', time: '≈20 min · quiz and mission self-paced after',
        src: 'A1_C03_L03_LESSON.md',
        screens: [
          {
            id: 'S23', type: 'reading', label: 'Reading — three profile cards + the class roll', step: 'STEP 13',
            kind: 'profiles', ids: 'PR-RD001–008',
            profiles: [
              { n: 'MAYA', ill: ill('ILL031', 'Portrait of Maya in green scrubs with her star pin, smiling'), rows: [['NAME', 'Maya'], ['COUNTRY', 'Egypt'], ['LANGUAGES', 'Arabic and English'], ['JOB', 'nurse'], ['EMAIL', 'maya.haddad@aroa.com']] },
              { n: 'KENJI', ill: ill('ILL032', 'Portrait of a calm man with short black hair and a blue jacket over a grey shirt'), rows: [['NAME', 'Kenji'], ['COUNTRY', 'Japan'], ['LANGUAGES', 'Japanese and English'], ['JOB', 'engineer']] },
              { n: 'ALEX', ill: ill('ILL033', 'Portrait of Alex with round glasses and mustard sweater, sketchbook under one arm'), rows: [['NAME', 'Alex'], ['COUNTRY', 'Canada'], ['LANGUAGES', 'English and French'], ['JOB', 'designer'], ['EMAIL', 'alex.kim@aroa.com']] }
            ],
            form: { title: 'The class — 6 people', rows: [['MAYA', 'Egypt — nurse'], ['KENJI', 'Japan — engineer'], ['ALEX', 'Canada — designer'], ['NINA', 'Peru — teacher'], ['LEO', 'Australia — cook'], ['SAM', 'Mexico — (no job listed)']] },
            note: "Sam's real job (shop assistant) is not in the taught nine, so his roll row lists country only — and RD007 turns that empty cell into the reading check.",
            items: [
              { id: 'PR-RD001', instr: 'Read. Choose.', icon: 'eye', prompt: 'MAYA card · Maya is from ____.', opts: [{ id: 'A', t: 'Egypt' }, { id: 'B', t: 'Spain' }, { id: 'C', t: 'Kenya' }], key: 'A', ok: 'Egypt — card line 2.', no: 'Check the Country line on the card.', a11y: ['dynamic_type_to_XL', 'no_audio_required'] },
              { id: 'PR-RD002', instr: 'Read. Choose.', icon: 'eye', prompt: 'KENJI card · Kenji is a(n) ____.', opts: [{ id: 'A', t: 'cook' }, { id: 'B', t: 'driver' }, { id: 'C', t: 'engineer' }], key: 'C', ok: 'An engineer — card line 4.', no: 'Check the Job line on the card.', a11y: ['dynamic_type_to_XL'] },
              { id: 'PR-RD003', instr: 'Read. Choose.', icon: 'eye', prompt: 'ALEX card · ____ email is alex.kim@aroa.com.', opts: [{ id: 'A', t: 'Their' }, { id: 'B', t: 'His' }, { id: 'C', t: 'Her' }], key: 'A', ok: 'Their email — Alex is they.', no: 'Alex → they → their.', a11y: ['dynamic_type_to_XL'] },
              { id: 'PR-RD004', instr: 'Read. Choose.', icon: 'eye', prompt: 'ALEX card · Alex speaks English and ____.', opts: [{ id: 'A', t: 'French' }, { id: 'B', t: 'Arabic' }, { id: 'C', t: 'Swahili' }], key: 'A', ok: "English and French — Canada's two official languages.", no: 'Check the Languages line.', a11y: ['dynamic_type_to_XL'] },
              { id: 'PR-RD005', instr: 'Read. Choose.', icon: 'eye', prompt: 'Class roll · Who is the teacher?', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Kenji' }], key: 'A', ok: 'Nina — Peru, teacher.', no: 'Scan the job column, then read the name.', a11y: ['dynamic_type_to_XL'] },
              { id: 'PR-RD006', instr: 'Read. Choose.', icon: 'eye', prompt: 'Class roll · Who is from Australia?', opts: [{ id: 'A', t: 'Leo' }, { id: 'B', t: 'Sam' }, { id: 'C', t: 'Alex' }], key: 'A', ok: 'Leo — Australia, cook.', no: 'Scan the country column, then read the name.', a11y: ['dynamic_type_to_XL'] },
              { id: 'PR-RD007', instr: 'Read. Choose.', icon: 'eye', prompt: 'Class roll · The roll has six names. How many jobs are on the roll?', opts: [{ id: 'A', t: 'six' }, { id: 'B', t: 'five' }, { id: 'C', t: 'ten' }], key: 'B', ok: "Five jobs — Sam's row has no job. Careful readers win!", no: 'Count only the rows WITH a job word.', a11y: ['dynamic_type_to_XL'], note: 'A reading CHECK item — the empty cell is the point, not a trick: the roll visibly shows five job words.' },
              { id: 'PR-RD008', instr: 'Read. Match.', icon: 'match', kind: 'pairs', prompt: 'Three shuffled mini-profiles ↔ the three cards', pairs: [['a nurse from Egypt', 'MAYA'], ['a designer from Canada', 'ALEX'], ['an engineer from Japan', 'KENJI']], key: 'all three', ok: 'Person + country + job — the full profile read!', no: 'Match the job word first, then the country.', a11y: ['tap_only_no_drag'] }
            ],
            tip: 'Two text types on one screen: profile cards and a two-column roll list. All reading text renders in the app layer — never inside the art — and scales to Dynamic Type XL.',
            assets: ['A1-C03-ILL031', 'A1-C03-ILL032', 'A1-C03-ILL033']
          },
          {
            id: 'S24', type: 'tiles', label: 'Guided writing — tiles only', step: 'STEP 13b',
            ids: 'WR001–WR006',
            tasks: [
              { id: 'WR001', instr: 'Put in order.', tiles: ['Maya', 'is', 'Egypt', 'from', 'This is', 'She'], key: ['This is', 'Maya', 'She', 'is', 'from', 'Egypt'], ok: 'Introduce, then the country — two clean sentences.', no: 'First sentence: This is + name. Second: She is from + country.', target: 'This is Maya. She is from Egypt.', alt: "Also accepted: This is Maya. She's from Egypt." },
              { id: 'WR002', instr: 'Put in order.', tiles: ['is', 'an', 'Kenji', 'engineer'], key: ['Kenji', 'is', 'an', 'engineer'], ok: 'An before the vowel sound — engineer!', no: 'Name first, then is, then an + job.', target: 'Kenji is an engineer.' },
              { id: 'WR003', instr: 'Choose.', tiles: ['Japan', 'Japanese', 'Swahili', 'India'], key: ['Japan', 'Japanese'], ok: 'Country then language — Japan, Japanese.', no: 'Country word first (Japan), language word second (Japanese).', target: "I'm from ____. I speak ____. — modelled on the KENJI card" },
              { id: 'WR004', instr: 'Look. Choose.', opts: [{ id: 'A', t: 'what do you do' }, { id: 'B', t: 'What do you do.' }, { id: 'C', t: 'What do you do?' }], key: 'C', ok: 'Big W, question mark at the end!', no: 'Questions start big and end with ?', target: 'Which one is correct?' },
              { id: 'WR005', instr: 'Put in order.', tiles: ['Her', 'Maya.', 'name', 'is'], key: ['Her', 'name', 'is', 'Maya.'], ok: 'Whose-word + thing + is + name.', no: 'her + name comes first.', target: 'Her name is Maya.' },
              { id: 'WR006', instr: 'Choose.', tiles: ['name (fictional bank)', 'any of the ten countries', 'a student', 'any language of the chapter'], key: ['name', 'country', 'a student', 'language'], ok: 'Your profile! Read it out loud — this is YOU, in English.', no: "Every line needs one tile. I'm + name · from + country · a student.", target: "I'm ___. I'm from ___. I'm a student. I speak ___.", privacy: 'A three-name fictional bank plus a blank-name option; the real name is never required and nothing is stored beyond the session. This task feeds the S28 mission.' }
            ],
            tip: 'No required typing anywhere: capitalization and punctuation are real tiles. WR006 accepts any correct combination — the choice is a game move, not a claim.',
            assets: []
          },
          {
            id: 'S25', type: 'testlet', label: 'Identity listening', step: 'STEP 13c',
            rung: 'DETAIL → TRANSFER', support: 'Profile intros, a roll-call, and two fresh transfer lines', ids: 'PR-LS011–016',
            groups: [
              { n: 'Profiles', stim: 'AUD057 (Maya) · AUD058 (Kenji — new performer)', ids: 'LS011–012', note: 'Kenji joins the "second intelligible voices" bank for later levels.' },
              { n: 'Roll-call', stim: 'AUD059 — NINA calls the class', ids: 'LS013–014', note: 'The roll moves fast: catch the name first, then the country.' },
              { n: 'Transfer', stim: 'Two fresh takes (Kenji, then Sam)', ids: 'LS015–016', note: 'Newest combinations; no new content words.' }
            ],
            scripts: [
              { id: 'AUD057', sp: 'MAYA', t: "Hi! I'm Maya. I'm from Egypt. I'm a nurse. I speak Arabic and English." },
              { id: 'AUD058', sp: 'KENJI', t: "Good afternoon. I'm Kenji. I'm from Japan. I'm an engineer. I speak Japanese and English." },
              { id: 'AUD059', sp: 'NINA', t: 'Good morning, class! … Maya — Egypt. … Kenji — Japan. … Alex — Canada. … Leo — Australia.' }
            ],
            items: [
              { id: 'PR-LS011', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD057', prompt: 'Maya is a ____.', opts: [{ id: 'A', t: 'teacher' }, { id: 'B', t: 'nurse' }, { id: 'C', t: 'doctor' }], key: 'B', ok: 'A nurse — yes!', no: "Listen after 'I'm a …'.", a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
              { id: 'PR-LS012', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD058', prompt: 'Kenji speaks ____.', opts: [{ id: 'A', t: 'Japanese and English' }, { id: 'B', t: 'Arabic and English' }, { id: 'C', t: 'English and French' }], key: 'A', ok: 'Japanese and English.', no: 'Listen for the two language words.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS013', instr: 'Listen. Tap.', icon: 'ear', aud: 'AUD059', prompt: 'Alex — where is Alex from? (replay, entry 3)', kind: 'image', opts: [{ id: 'A', ill: ill('ILL003', 'Canada map card') }, { id: 'B', ill: ill('ILL009', 'Japan map card') }, { id: 'C', ill: ill('ILL006', 'Egypt map card') }], key: 'A', ok: 'Canada!', no: 'The roll moves fast — catch the name first, then the country.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS014', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD059', prompt: 'Leo is from ____. (replay, entry 4)', opts: [{ id: 'A', t: 'Australia' }, { id: 'B', t: 'Canada' }, { id: 'C', t: 'Mexico' }], key: 'A', ok: 'Australia!', no: 'Name first, country second — listen again.', a11y: ['audio_required_transcript_after_response'] },
              { id: 'PR-LS015', instr: 'Listen. Choose.', icon: 'ear', scene: "Fresh take — KENJI: Nina is my teacher. She's from Peru. Her class is great!", prompt: 'Who is the teacher?', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Nina' }, { id: 'C', t: 'Kenji' }], key: 'B', ok: "Nina — she's from Peru.", no: "The voice says 'my teacher' — then the name.", a11y: ['audio_required_transcript_after_response'], note: "'great' is a taught C1 word used as a warm closer; no new content words." },
              { id: 'PR-LS016', instr: 'Listen. Choose.', icon: 'ear', scene: "Fresh take — SAM: Kenji is my friend. He isn't from Mexico. He's from Japan!", prompt: 'Where is Kenji from?', kind: 'image', opts: [{ id: 'A', ill: ill('ILL009', 'Japan map card') }, { id: 'B', ill: ill('ILL004', 'Mexico map card') }, { id: 'C', ill: ill('ILL010', 'Kenya map card') }], key: 'A', ok: "Japan — after isn't Mexico, the correction says it!", no: "Listen AFTER 'isn't' — corrections give the answer.", a11y: ['audio_required_transcript_after_response'] }
            ],
            tip: 'Transcripts release only after the scored response; one replay by default, logged and never penalized.',
            assets: ['A1-C03-AUD057', 'A1-C03-AUD058', 'A1-C03-AUD059']
          },
          {
            id: 'S26', type: 'practice', label: 'Roleplay rehearsal', step: 'STEP 14',
            bank: 'PR-CV013–016 · 4 of 4 authored items shown',
            head: 'Kenji is new at the Community House. You welcome him.',
            items: [
              { id: 'PR-CV013', instr: 'Choose.', icon: 'choose', ill: ill('ILL032', 'Kenji walks in — portrait crop'), prompt: 'Your first line?', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Hi! Nice to meet you!' }, { id: 'C', t: "I'm from Peru." }], key: 'B', ok: 'A greeting first — nice!', no: 'First meetings open with a greeting.', a11y: ['alt_text_construct_equivalent'] },
              { id: 'PR-CV014', instr: 'Choose.', icon: 'choose', prompt: 'Now ask Kenji HIS country.', opts: [{ id: 'A', t: 'Where are you from?' }, { id: 'B', t: 'What do you do?' }, { id: 'C', t: 'How are you?' }], key: 'A', ok: 'Where are you from? — the country question.', no: 'You want his COUNTRY — which question asks that?', a11y: ['no_audio_required'] },
              { id: 'PR-CV015', instr: 'Choose.', icon: 'choose', prompt: 'Now ask Kenji HIS job.', opts: [{ id: 'A', t: 'Where is Kenji from?' }, { id: 'B', t: 'What do you do?' }, { id: 'C', t: 'Are you a teacher?' }], key: 'B', ok: 'What do you do? — the job question.', no: 'The open job question starts with What.', a11y: ['no_audio_required'] },
              { id: 'PR-CV016', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL029', "A hand holds up a photo of Maya in her nurse scrubs"), prompt: 'Introduce her to Kenji.', opts: [{ id: 'A', t: 'This is my friend Maya.' }, { id: 'B', t: 'Her is Maya.' }, { id: 'C', t: 'Nice to meet you too.' }], key: 'A', ok: 'This is my friend Maya. — introduction done!', no: 'Show the person: This is + my friend + name.', a11y: ['alt_text_construct_equivalent'] }
            ],
            tip: 'Four rehearsal taps, then the live roleplay. These four items ARE the non-voice alternative path for RP001 — the tap route and the voice route are the same content.',
            assets: ['A1-C03-ILL029', 'A1-C03-ILL032']
          },
          {
            id: 'S27', type: 'roleplay', label: 'Roleplay — Welcome Kenji', step: 'STEP 14b',
            spec: 'A1-C03-RP001', partner: 'Kenji', turnLimit: 6,
            opener: 'Kenji waves.',
            scenario: 'Kenji is new at the Community House. You welcome him: greet, ask his country, ask his job, introduce one friend, close.',
            checklist: ['greeting', 'origin question', 'job question', 'friend introduction', 'close'],
            tileGroups: [
              { g: 'greeting', t: ['Hi! Nice to meet you!'] },
              { g: 'origin', t: ['Where are you from?'] },
              { g: 'job', t: ['What do you do?'] },
              { g: 'introduce', t: ['This is my friend Maya.', 'This is my friend Leo.', 'This is my friend Nina.', 'This is my friend Sam.'] },
              { g: 'follow-up', t: ['Is she a nurse?', 'Is he a cook?', 'Are they a designer?'] },
              { g: 'close', t: ['See you, Kenji!', 'Bye, Kenji!', 'Nice to meet you, Kenji!'] }
            ],
            transcript: [
              { sp: 'YOU', t: 'Hi! Nice to meet you!' },
              { sp: 'KENJI', t: 'Good afternoon. Nice to meet you too.' },
              { sp: 'YOU', t: 'Where are you from?' },
              { sp: 'KENJI', t: "I'm from Japan." },
              { sp: 'YOU', t: 'What do you do?' },
              { sp: 'KENJI', t: "I'm an engineer." }
            ],
            feedback: { strong: ['You opened with a greeting.', 'You asked the country question and the job question.'], next: 'Introduce one friend by photo, then close.' },
            redirects: ['If the learner stalls, Kenji re-asks with a slower take (one retry).', 'The failure path loops back to the S26 rehearsal — never a dead end.'],
            partnerCard: 'Kenji · new performer, calm and medium-low · warm, slightly formal, gives full answers · never asks about the learner\'s documents, status, or real address.',
            success: ['all five required slots attempted within 6 turns', 'frames recognizable (from-frame, a/an-frame, This-is frame)', 'pronoun matches the introduced friend (he/she/they)'],
            guardrails: ['Kenji never asks the learner\'s real origin; if the learner offers a country, any of the ten is accepted with warmth.', 'No required typing — every learner turn is tap or voice.', '"Good night" is never shown as an option, not even as a distractor.'],
            scoring: 'Slots completed, not perfection. Unlimited retries; no time pressure.',
            tip: 'Voice model is learning_slow_clear for Kenji, with challenge_natural_slow in a replay round. The branching tap path mirrors CV013–016 exactly and is equal in weight to the voice path.',
            assets: ['A1-C03-AUD058']
          },
          {
            id: 'S28', type: 'missionBrief', label: 'Mission — Your Dot on the Wall', step: 'STEP 15',
            head: 'Your mission: put your dot on the wall.',
            ill: ill('ILL034', 'The map wall close-up — five orange dots and one empty space glowing softly; a hand hovers with a sixth dot'),
            setup: 'AUD061 — NINA: Look — five dots, and one space for you! … Take a dot. Your country goes here. … Share, if you like — and any country is okay.',
            checklist: ['Choose a country card — any of the ten', 'Place the dot on that region of the wall map', 'Build your profile from tiles (WR006)', 'Nina reads your profile back; Alex says the closing line'],
            card: { name: 'your choice (safe fictional, or blank)', phone: '—', email: '—' },
            entries: ['Speak', 'Tap'],
            completion: "SIX DOTS! … You're on the wall. Welcome home, neighbor.",
            privacy: 'The choice is a game move, not a claim. The skip path places a plain orange dot with no country and completes the mission with full stars. The app never asks for the learner\'s real origin, documents, or status.',
            tip: 'Tap-to-place: the chosen map region glows. Four-step checklist with empty rings that fill live, the same component family as the promise screens.',
            assets: ['A1-C03-AUD061', 'A1-C03-ILL034']
          },
          {
            id: 'S29', type: 'quiz', label: 'Quiz — Form A', step: 'STEP 16',
            mix: [['listening', 5], ['numbers', 5], ['vocabulary', 5], ['grammar', 6], ['discourse', 5], ['reading', 4], ['culture', 2]],
            bank: 'Quiz Form A · 32 items · 8 cumulative (25.0%, band ceiling) retrieving Chapter 1 + Chapter 2 targets',
            note: 'One item per screen-swap, interleaved sections, no headers revealing the skill mix. Listening: one default replay; transcripts release only after the whole quiz.',
            items: [
              { id: 'A1-C03-QZ-L004', instr: 'Listen. Choose.', scene: "SAM: Hi! I'm Sam. I speak Spanish and English.", prompt: 'Sam speaks ____.', opts: [{ id: 'A', t: 'Arabic and English' }, { id: 'B', t: 'English and French' }, { id: 'C', t: 'Spanish and English' }], key: 'C', ok: 'Spanish and English.', no: 'Catch the two language words.' },
              { id: 'A1-C03-QZ-L005', instr: 'Listen. Choose.', scene: 'GUIDE: Good morning!', prompt: 'Choose the reply.', opts: [{ id: 'A', t: 'Goodbye.' }, { id: 'B', t: 'Good morning.' }, { id: 'C', t: 'See you.' }], key: 'B', ok: 'Greeting meets greeting.', no: 'Morning greeting → morning greeting.', cumulative: true },
              { id: 'A1-C03-QZ-N001', instr: 'Look. Choose.', prompt: 'The card: phone 5-5-5, 2-0-9. Whose card is this?', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Sam' }], key: 'A', ok: "Nina's card — two zero nine.", no: 'Compare the last three digits: 2-0-9.', cumulative: true },
              { id: 'A1-C03-QZ-N002', instr: 'Look. Choose.', prompt: 'Whose phone number: 6-2-0, 1-5-4?', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Leo' }, { id: 'C', t: 'Alex' }], key: 'B', ok: 'Leo — from the Chapter 2 check-in!', no: "Leo's number ends 1-5-4.", cumulative: true },
              { id: 'A1-C03-QZ-N003', instr: 'Look. Tap.', prompt: 'Tap the number you see: 13', opts: [{ id: 'A', t: '3' }, { id: 'B', t: '13' }, { id: 'C', t: '12' }], key: 'B', ok: 'Thirteen.', no: 'Thirteen: 1-3.', cumulative: true },
              { id: 'A1-C03-QZ-N004', instr: 'Look. Choose.', prompt: 'The word: seventeen. Tap the digits.', opts: [{ id: 'A', t: '7' }, { id: 'B', t: '11' }, { id: 'C', t: '17' }], key: 'C', ok: 'Seventeen has the -teen: 17.', no: 'Not quite — seventeen has the -teen.', cumulative: true },
              { id: 'A1-C03-QZ-N005', instr: 'Look. Tap.', prompt: 'Tap the number you see: 12', opts: [{ id: 'A', t: '2' }, { id: 'B', t: '10' }, { id: 'C', t: '12' }], key: 'C', ok: 'Twelve: 1-2.', no: 'Twelve: 1-2.', cumulative: true },
              { id: 'A1-C03-QZ-V001', instr: 'Look. Choose.', prompt: 'Map card, Brazil region highlighted. Which country?', opts: [{ id: 'A', t: 'Spain' }, { id: 'B', t: 'Brazil' }, { id: 'C', t: 'India' }], key: 'B', ok: 'Brazil!', no: "Look at the highlighted region's shape and place." },
              { id: 'A1-C03-QZ-V002', instr: 'Look. Choose.', prompt: 'Leo, at the café kitchen. Leo is a ____.', opts: [{ id: 'A', t: 'cook' }, { id: 'B', t: 'driver' }, { id: 'C', t: 'doctor' }], key: 'A', ok: 'A cook!', no: 'The café kitchen says cook.' },
              { id: 'A1-C03-QZ-V003', instr: 'Choose.', prompt: 'One person. Ten ____.', opts: [{ id: 'A', t: 'people' }, { id: 'B', t: 'person' }, { id: 'C', t: 'friends' }], key: 'A', ok: 'Ten people!', no: 'Many persons = people.' },
              { id: 'A1-C03-QZ-V004', instr: 'Choose.', prompt: 'How do you spell that? — the country: PERU', opts: [{ id: 'A', t: 'P-R-E-U' }, { id: 'B', t: 'P-E-R-O' }, { id: 'C', t: 'P-E-R-U' }], key: 'C', ok: 'P-E-R-U.', no: 'Say it slowly: Pe-ru.', cumulative: true },
              { id: 'A1-C03-QZ-V005', instr: 'Choose.', prompt: 'MAYA: "Nice to meet you." You say:', opts: [{ id: 'A', t: 'See you.' }, { id: 'B', t: 'Nice to meet you too.' }, { id: 'C', t: "I'm good." }], key: 'B', ok: 'Nice to meet you too!', no: 'Return the meeting line — with too.' },
              { id: 'A1-C03-QZ-G001', instr: 'Choose.', prompt: 'Alex is my friend. ____ a designer.', opts: [{ id: 'A', t: "He's" }, { id: 'B', t: "They're" }, { id: 'C', t: "She's" }], key: 'B', ok: "They're a designer.", no: 'Alex → they → they\u2019re.' },
              { id: 'A1-C03-QZ-G002', instr: 'Choose.', prompt: 'Where ____ Maya from?', opts: [{ id: 'A', t: 'am' }, { id: 'B', t: 'are' }, { id: 'C', t: 'is' }], key: 'C', ok: 'Where is Maya from? — Egypt.', no: 'One person → is.' },
              { id: 'A1-C03-QZ-G003', instr: 'Choose.', prompt: 'Are Maya and Sam from Mexico?', opts: [{ id: 'A', t: 'Yes, they are.' }, { id: 'B', t: "No, she isn't." }, { id: 'C', t: "No, they aren't." }], key: 'C', ok: "No, they aren't. Sam is — Maya isn't!", no: 'Two people → they; and check Maya\u2019s country.' },
              { id: 'A1-C03-QZ-G004', instr: 'Choose.', prompt: 'Leo, phone icon: ____ phone is 6-2-0, 1-5-4.', opts: [{ id: 'A', t: 'His' }, { id: 'B', t: 'Her' }, { id: 'C', t: 'Our' }], key: 'A', ok: 'His phone.', no: 'Leo → he → his.' },
              { id: 'A1-C03-QZ-G005', instr: 'Choose.', prompt: 'Maya is ____ nurse.', opts: [{ id: 'A', t: 'a' }, { id: 'B', t: 'an' }], key: 'A', ok: 'A nurse — the sound decides.', no: 'NURSE starts /n/ → a.' },
              { id: 'A1-C03-QZ-G006', instr: 'Choose.', prompt: 'Is Nina a teacher?', opts: [{ id: 'A', t: 'Yes, she is.' }, { id: 'B', t: 'Yes, she are.' }, { id: 'C', t: 'Yes, he is.' }], key: 'A', ok: 'Yes, she is!', no: "Copy the question's person: she." },
              { id: 'A1-C03-QZ-LS001', instr: 'Choose.', prompt: 'SAM: "What do you do?" You say:', opts: [{ id: 'A', t: "I'm from Peru." }, { id: 'B', t: "I'm an engineer." }, { id: 'C', t: 'My name is Peru.' }], key: 'B', ok: "I'm an engineer.", no: 'Job question → job frame.' },
              { id: 'A1-C03-QZ-LS002', instr: 'Choose.', prompt: 'YOU: "This is my friend Kenji." Sam says:', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: "I'm good." }, { id: 'C', t: 'Nice to meet you!' }], key: 'C', ok: 'Nice to meet you!', no: 'A new person arrives — the meeting reply.' },
              { id: 'A1-C03-QZ-LS003', instr: 'Listen. Choose.', scene: 'SAM (fast): four zero one, seven three two!', prompt: 'Too fast! What do you say?', opts: [{ id: 'A', t: 'Can you repeat that, please?' }, { id: 'B', t: 'How do you spell that?' }, { id: 'C', t: 'Nice to meet you too.' }], key: 'A', ok: 'Can you repeat that, please? — the C2 repair lives!', no: 'Numbers need a REPEAT, not a spelling.', cumulative: true },
              { id: 'A1-C03-QZ-LS004', instr: 'Choose.', prompt: 'ALEX: "Where is Nina from?" — that asks:', opts: [{ id: 'A', t: "Nina's job" }, { id: 'B', t: "Nina's country" }, { id: 'C', t: "Nina's name" }], key: 'B', ok: 'Her country — Where + from.', no: 'WHERE asks a place.' },
              { id: 'A1-C03-QZ-LS005', instr: 'Choose.', prompt: "You are from Brazil. KENJI: \"Are you from Japan?\"", opts: [{ id: 'A', t: 'Yes, I am.' }, { id: 'B', t: "No, she isn't." }, { id: 'C', t: "No, I'm not. I'm from Brazil." }], key: 'C', ok: "No, I'm not. I'm from Brazil — your facts, your answer.", no: 'Check WHO is asked and WHERE you are from.' },
              { id: 'A1-C03-QZ-RD001', instr: 'Read. Choose.', prompt: "Maya's profile card. Maya is a ____.", opts: [{ id: 'A', t: 'nurse' }, { id: 'B', t: 'teacher' }, { id: 'C', t: 'doctor' }], key: 'A', ok: 'A nurse.', no: 'Read the Job line.' },
              { id: 'A1-C03-QZ-RD002', instr: 'Read. Choose.', prompt: "Kenji's profile card. Kenji is from ____.", opts: [{ id: 'A', t: 'Japan' }, { id: 'B', t: 'Kenya' }, { id: 'C', t: 'Canada' }], key: 'A', ok: 'Japan.', no: 'Read the Country line.' },
              { id: 'A1-C03-QZ-RD003', instr: 'Read. Choose.', prompt: 'The class roll. Who is the cook?', opts: [{ id: 'A', t: 'Leo' }, { id: 'B', t: 'Kenji' }, { id: 'C', t: 'Sam' }], key: 'A', ok: 'Leo — Australia, cook.', no: 'Scan the job column.' },
              { id: 'A1-C03-QZ-RD004', instr: 'Read. Choose.', prompt: "Alex's profile card. Alex speaks English and ____.", opts: [{ id: 'A', t: 'Arabic' }, { id: 'B', t: 'French' }, { id: 'C', t: 'Japanese' }], key: 'B', ok: 'English and French.', no: 'Read the Languages line.' },
              { id: 'A1-C03-QZ-CN001', instr: 'Choose.', prompt: "Canada's two official languages:", opts: [{ id: 'A', t: 'English only' }, { id: 'B', t: 'English and French' }, { id: 'C', t: 'French only' }], key: 'B', ok: 'English and French — two official languages, one country.', no: 'Canada has TWO official languages.' },
              { id: 'A1-C03-QZ-CN002', instr: 'Choose.', prompt: 'Kenji is from Japan. Kenji speaks ____.', opts: [{ id: 'A', t: 'Arabic' }, { id: 'B', t: 'French' }, { id: 'C', t: 'Japanese' }], key: 'C', ok: "Japanese — in Japan, they speak Japanese.", no: "Japan's language is Japanese." }
            ],
            tip: 'One item per screen-swap, interleaved skills, correct-position rotation, no section reveals. A quiet progress bar (no countdown). Answer-key balance audited: 16 A / 16 B / 16 C across the full 48 letter-keyed items.',
            assets: ['A1-C03-AUD062–067', 'A1-C03-ILL035–036']
          },
          {
            id: 'S30', type: 'results', label: 'Results', step: 'STEP 16b',
            rings: ['origin', 'language', 'job', 'introduce', 'profiles'],
            strong: 'You can ask and answer where someone is from, and say a job.',
            developing: "'I'm from ___' and 'I'm a/an ___' still mix sometimes — Checkpoint 1 comes back to this.",
            next: 'Chapter 4 — Checkpoint Review 1: Welcome-Day Mission.',
            score: 'Pass is ≥26 / 32', gate: 'Pass: ≥80% overall and no core section below 70%. Near-pass routes to a clinic seed plus retry; below routes to personalised review. Unlimited retries with parallel content. No permanent lock. Mission completion (S28) is required alongside the quiz for the chapter badge.',
            tip: 'Five can-do rings filling, strengths first, one developing area max, one next step. No percentages-as-judgment; the number sits behind a tap. Retry and continue are equally weighted — no dark pattern.',
            clinics: [
              { id: 'C3-CLIN-A', name: 'they is / they are', benefit: 'Match the person word to am, is, or are, every time.', n: 8, trigger: 'be-agreement misses' },
              { id: 'C3-CLIN-B', name: 'his or her?', benefit: 'Pick the right possessive without stopping to think.', n: 8, trigger: 'possessive misses' },
              { id: 'C3-CLIN-C', name: 'a or an?', benefit: 'Hear the first sound, choose the article.', n: 9, trigger: 'article misses' },
              { id: 'C3-CLIN-D', name: "I'm from vs I'm a", benefit: 'Route the question to the right frame — country or job.', n: 8, trigger: 'frame-collision misses' }
            ],
            pending: 'Clinic items are seeded specifications; full item sets are authored on first learner need or owner request (owner note carried in the chapter QA report).',
            assets: []
          },
          {
            id: 'S31', type: 'reviewPlan', label: 'Review plan', step: 'STEP 16c',
            head: 'Your review week', sub: 'Short returns, spaced out. Notifications stay off unless you turn them on.',
            week: [{ d: 'Tue', t: 'Origins + languages', on: true }, { d: 'Wed', t: '', on: false }, { d: 'Thu', t: 'Jobs + a/an', on: true }, { d: 'Fri', t: '', on: false }, { d: 'Sat', t: 'Introductions', on: true }, { d: 'Sun', t: '', on: false }, { d: 'Mon', t: 'Chapter 4 warm-up', on: true }],
            exports: [['All 36 L1 records', 'Welcome-day mission + Checkpoint 1'], ['G007–G009', 'Checkpoint grammar sweep; G008 → Ch5 contrast, G009 → every job use'], ['C2 patterns (0–20)', 'Rolling; C5 extends 21–100'], ['C1 chunks', 'Greeting beats of the Ch4 mission framing']],
            tip: 'A calm week-strip, no streak shaming, optional notifications off by default — the same component family as C1-S36 and C2-S38.',
            assets: []
          },
          {
            id: 'S32', type: 'chapterMap', label: 'Chapter map / next', step: 'Wrap-up',
            head: 'Chapter 3 complete!',
            body: 'You can ask and answer where someone is from, name a language, say a job, and introduce someone else.',
            next: 'Chapter 4 — Checkpoint Review 1: Welcome-Day Mission.',
            arc: 'Meet and connect', chapters: [{ n: 1, t: 'Hello! My Name Is Alex', s: 'done' }, { n: 2, t: 'Spell It and Share Your Details', s: 'done' }, { n: 3, t: 'Where Are You From?', s: 'done' }, { n: 4, t: 'Checkpoint Review 1', s: 'next' }],
            tip: 'The celebration peak: brief, mutable, reduced-motion safe. The chapter map shows Arc 1 with Chapters 1–3 filled and Checkpoint 1 next — story progress, not point totals.',
            assets: []
          }
        ]
      }
    ]
  });
})();
