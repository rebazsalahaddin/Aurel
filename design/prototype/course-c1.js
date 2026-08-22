/* A1-C01 — "Hello! My Name Is Alex". Screen inventory S01–S37 (+ the S23b/S26b
   pronunciation blocks and the S34a writing block named in the lesson files).
   Every string here is transcribed from english_course/04_A1_chapters/A1_C01/*.
   Complete banks: vocabulary 36 · grammar 30 · conversation 16 · listening 16 ·
   pronunciation 10 · reading 8 · guided writing 6 = 122 practice items + quiz Form A (22).
   Where one authored record is a multi-blank, matching or multi-trial task, it is
   decomposed into the steps the one-item-per-screen renderer shows and keeps its
   source id (e.g. 'PR-G030 · blank 1'). */
(function () {
  var C = (window.AUREL_COURSE = window.AUREL_COURSE || { chapters: [] });
  var __guard = C.chapters.some(function (x) { return x.id === 'A1-C01'; });
  if (__guard) return;

  var ill = function (id, alt) { return { id: 'A1-C01-' + id, alt: alt }; };
  var chr = function (id, alt) { return { id: 'A1-CHAR-' + id, alt: alt }; };

  /* ---------- L01 ---------- */
  var setA = [
    { id: 'V001', w: 'hello', ipa: '/həˈloʊ/', stress: 'second syllable', aud: 'AUD002', ill: ill('ILL005', 'Two young adults wave hello to each other with big friendly smiles'), fn: 'greeting word (any time of day)', frame: 'Hello + name — Hello, Maya!' },
    { id: 'V002', w: 'hi', ipa: '/haɪ/', stress: 'monosyllable', aud: 'AUD003', ill: ill('ILL005', 'Two friends wave hello in a relaxed, friendly way'), fn: 'greeting word (informal, any time)', frame: 'Hi + name — Hi, Maya!' },
    { id: 'V003', w: 'good morning', ipa: '/ˌɡʊd ˈmɔːrnɪŋ/', stress: 'stress on morning', aud: 'AUD004', ill: ill('ILL002', 'In soft morning light, Maya stands at a welcome table with steaming cups while Alex arrives waving'), fn: 'time-fixed greeting chunk (until midday)', frame: 'Good morning + name' },
    { id: 'V004', w: 'good afternoon', ipa: '/ˌɡʊd ˌæftərˈnuːn/', stress: 'stress on noon syllable', aud: 'AUD005', ill: ill('ILL003', 'Under a high bright sun, Nina waves to Leo at a café terrace window'), fn: 'time-fixed greeting chunk (midday to evening)', frame: 'Good afternoon + name' },
    { id: 'V005', w: 'good evening', ipa: '/ˌɡʊd ˈiːvnɪŋ/', stress: 'stress on evening', aud: 'AUD006', ill: ill('ILL004', 'On a darkening street lit by warm lamps, two neighbors wave to each other'), fn: 'time-fixed greeting chunk (after sunset)', frame: 'Good evening + name' },
    { id: 'V006', w: 'goodbye', ipa: '/ˌɡʊdˈbaɪ/', stress: 'stress on bye', aud: 'AUD007', ill: ill('ILL006', 'One person steps out a doorway, turning back to wave goodbye'), fn: 'farewell word (any time)', frame: 'Goodbye + name — Goodbye, Alex!' },
    { id: 'V007', w: 'bye', ipa: '/baɪ/', stress: 'monosyllable', aud: 'AUD008', ill: ill('ILL006', 'A friend waves bye while stepping away through a doorway'), fn: 'farewell word (informal, any time)', frame: 'Bye + name — Bye, Leo!' },
    { id: 'V008', w: 'see you', ipa: '/ˈsiː juː/', stress: 'stress on see', aud: 'AUD009', ill: ill('ILL007', 'Two friends walk away from each other down a park path, turning to wave'), fn: 'farewell chunk (implies meeting again)', frame: 'See you + time word — See you tomorrow!' }
  ];
  var setB = [
    { id: 'V009', w: 'please', ipa: '/pliːz/', stress: 'monosyllable', aud: 'AUD010', ill: ill('ILL008', 'Maya offers a cup with both hands and a warm, asking expression'), fn: 'politeness word added to requests', frame: '(request) + please — One coffee, please.' },
    { id: 'V010', w: 'thank you', ipa: '/ˈθæŋk juː/', stress: 'stress on thank', aud: 'AUD011', ill: ill('ILL009', 'Alex receives a cup from Maya, smiling warmly with one hand at his chest'), fn: 'politeness chunk for gratitude', frame: 'Thank you + name — Thank you, Maya!' },
    { id: 'V011', w: 'thanks', ipa: '/θæŋks/', stress: 'monosyllable', aud: 'AUD012', ill: ill('ILL009', 'A friend gives a friendly one-word thanks with a smile and small wave'), fn: 'informal gratitude word', frame: 'Thanks + name — Thanks, Leo!' },
    { id: 'V012', w: 'sorry', ipa: '/ˈsɑːri/', stress: 'first syllable', aud: 'AUD013', ill: ill('ILL010', 'Leo looks concerned with one hand raised as his notebook falls at his feet'), fn: 'apology word for small problems', frame: 'Sorry! / Sorry + name' },
    { id: 'V013', w: 'excuse me', ipa: '/ɪkˈskjuːz miː/', stress: 'stress on skju', aud: 'AUD014', ill: ill('ILL011', 'Nina leans politely to one side with an open hand as she passes between two people on a narrow path'), fn: 'politeness chunk to pass or get attention', frame: 'Excuse me + question' },
    { id: 'V014', w: 'yes', ipa: '/jes/', stress: 'monosyllable', aud: 'AUD015', ill: ill('ILL012', 'A smiling person nods yes, head tilted down then up'), fn: 'answer word (positive)', frame: 'Yes + short answer' },
    { id: 'V015', w: 'no', ipa: '/noʊ/', stress: 'monosyllable', aud: 'AUD016', ill: ill('ILL012', 'A calm person gently shakes their head no with a soft open-palm gesture'), fn: 'answer word (negative)', frame: 'No + short answer' }
  ];

  var prA = [
    { id: 'PR-V001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD002', opts: [{ id: 'A', t: 'hello' }, { id: 'B', t: 'goodbye' }, { id: 'C', t: 'see you' }], key: 'A', ok: 'Yes — hello!', no: 'Listen again — the word starts the meeting.', hints: ['Play again and watch the wave picture light up.', 'One option is for leaving — tap the ear once more and choose the hello card.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD007', opts: [{ id: 'A', t: 'good morning' }, { id: 'B', t: 'hello' }, { id: 'C', t: 'goodbye' }], key: 'C', ok: 'Yes — goodbye!', no: 'This word is for leaving. Listen for the ending sound -bye.', hints: ['Play again; the doorway-wave picture lights up.', 'Two options greet. Choose the leaving word.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V003', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL002', 'In soft morning light with a low sun and long shadows, Maya arrives at a welcome table with steaming cups while Alex waves'), opts: [{ id: 'A', t: 'good evening' }, { id: 'B', t: 'good morning' }, { id: 'C', t: 'good afternoon' }], key: 'B', ok: 'Yes — good morning!', no: 'Look at the sun. It is low. The day starts — morning.', hints: ['Look again at the sun and the shadows.', 'The sky is light and the sun is low — not dark, not high.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'no_color_only_meaning'] },
    { id: 'PR-V004', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL004', 'On a darkening street lit by warm lamps, two neighbors wave to each other'), opts: [{ id: 'A', t: 'good evening' }, { id: 'B', t: 'good afternoon' }, { id: 'C', t: 'good morning' }], key: 'A', ok: 'Yes — good evening!', no: 'The lamps are on and the sky is dark — evening.', hints: ['Look at the sky and the lamps.', 'Bright sky options are wrong here.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'no_color_only_meaning'] },
    { id: 'PR-V005', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL007', 'Two friends walk away from each other down a park path, turning to wave'), opts: [{ id: 'A', t: 'hello' }, { id: 'B', t: 'good morning' }, { id: 'C', t: 'see you' }], key: 'C', ok: 'Yes — see you!', no: 'The two friends walk away. They look back. Leaving words.', hints: ['Look at their feet — walking away.', 'One option is a leaving word.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V006', instr: 'Listen. Match.', icon: 'ear', aud: 'AUD004', kind: 'image', opts: [{ id: 'A', ill: ill('ILL004', 'Dark street, warm lamps — evening') }, { id: 'B', ill: ill('ILL002', 'Low sun, long shadows — morning') }, { id: 'C', ill: ill('ILL003', 'High bright sun, café terrace — afternoon') }], key: 'B', ok: 'Yes — good morning is for the morning sun.', no: 'Listen again. Morning sun is low.', hints: ['Play again and listen for mor-.', 'One picture is dark. Two are light. Listen for the low-sun word.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'PR-V007', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL006', 'One person steps out a doorway, turning back to wave goodbye'), opts: [{ id: 'A', t: 'bye' }, { id: 'B', t: 'hi' }, { id: 'C', t: 'hello' }], key: 'A', ok: 'Yes — bye!', no: 'The friend is leaving. Use a leaving word.', hints: ['Look — is the friend coming in or going out?', 'Two words are for meeting. Choose the leaving word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V008', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD009', opts: [{ id: 'A', t: 'good morning' }, { id: 'B', t: 'see you' }, { id: 'C', t: 'thank you' }], key: 'B', ok: 'Yes — see you!', no: 'Two words — a leaving chunk. Listen again.', hints: ['Play again; the park-path picture lights up.', 'One option thanks. Two options leave. Listen for two words.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V009', instr: 'Listen. Say.', icon: 'mouth', kind: 'speak', aud: 'AUD002', ill: ill('ILL005', 'Two young adults wave hello to each other with big friendly smiles'), word: 'hello', ok: 'Nice! Your hello is recorded. Play both.', no: 'Listen one more time, then try again. Or skip — you can say it later.', hints: ['Play the model twice; watch the mouth icon.', 'Say it with the audio together.'], secs: 25, a11y: ['non_voice_alternative_tap_word', 'mic_optional_never_blocks'] }
  ];
  var prB = [
    { id: 'PR-V010', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD011', opts: [{ id: 'A', t: 'sorry' }, { id: 'B', t: 'please' }, { id: 'C', t: 'thank you' }], key: 'C', ok: 'Yes — thank you!', no: 'This word thanks someone. Listen for th-.', hints: ['Play again; the receiving-cup picture lights up.', 'One word asks. One word is for problems. Choose the thanks word.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V011', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL010', 'Leo looks concerned with one hand raised as his notebook falls at his feet'), opts: [{ id: 'A', t: 'sorry' }, { id: 'B', t: 'excuse me' }, { id: 'C', t: 'thank you' }], key: 'A', ok: 'Yes — sorry!', no: 'Something fell — a small problem. Which word fits a problem?', hints: ['Look at the notebook on the ground.', 'One word is only for passing by. Remove it.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V012', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL011', 'Nina leans politely to one side with an open hand as she passes between two people on a narrow path'), opts: [{ id: 'A', t: 'thank you' }, { id: 'B', t: 'excuse me' }, { id: 'C', t: 'sorry' }], key: 'B', ok: 'Yes — excuse me!', no: 'She only walks past. Nothing falls, nothing is given.', hints: ['Look — is anything dropped or given?', 'Remove the problem-word. Remove the thanks-word.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V013', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL009', 'Alex receives a cup from Maya, smiling warmly with one hand at his chest'), opts: [{ id: 'A', t: 'thank you' }, { id: 'B', t: 'bye' }, { id: 'C', t: 'good morning' }], key: 'A', ok: 'Yes — thank you!', no: 'Maya gives. Alex gets. Which word is for getting?', hints: ['Look at the hands — one gives, one gets.', 'Two options are hellos and goodbyes. Remove them.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V014', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD016', opts: [{ id: 'A', t: 'yes' }, { id: 'B', t: 'please' }, { id: 'C', t: 'no' }], key: 'C', ok: 'Yes — no!', no: 'The word starts with n-. Listen again.', hints: ['Play again; the head-shake half of the pair picture lights up.', 'Remove the asking-word. Then listen: y- or n-?'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V015', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL006', 'One person steps out a doorway, turning back to wave goodbye'), opts: [{ id: 'A', t: 'thank you' }, { id: 'B', t: 'goodbye' }, { id: 'C', t: 'good morning' }], key: 'B', ok: 'Yes — goodbye!', no: 'The friend walks out. Leaving word needed.', hints: ['Look at the door and the feet.', 'One option greets. One thanks. Choose the leaving word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V016', instr: 'Listen. Say.', icon: 'mouth', kind: 'speak', aud: 'AUD010', ill: ill('ILL008', 'Maya offers a cup with both hands and a warm, asking expression'), word: 'please', ok: 'Recorded! Play both and listen.', no: 'Try again, or skip — no points lost.', hints: ['Play the model twice.', 'Say it together with the audio.'], secs: 25, a11y: ['non_voice_alternative_tap_word', 'mic_optional_never_blocks'] }
  ];

  /* ---------- L02 ---------- */
  var setC = [
    { id: 'V016', w: 'good', ipa: '/ɡʊd/', aud: 'AUD020', face: 'good', ill: ill('ILL013', 'Maya smiles warmly with relaxed shoulders, feeling good'), fn: 'state word (positive)' },
    { id: 'V017', w: 'fine', ipa: '/faɪn/', aud: 'AUD021', face: 'fine', ill: ill('ILL014', 'Leo gives a gentle content nod with a soft small smile, feeling fine'), fn: 'state word (calm positive)' },
    { id: 'V018', w: 'okay', ipa: '/ˌoʊˈkeɪ/', aud: 'AUD022', face: 'okay', ill: ill('ILL015', 'Nina holds one hand level in a so-so tilt with a small neutral smile, feeling okay'), fn: 'state word (neutral positive)' },
    { id: 'V019', w: 'great', ipa: '/ɡreɪt/', aud: 'AUD023', face: 'great', ill: ill('ILL016', 'Alex raises both arms high with a big open smile, feeling great'), fn: 'state word (strong positive)' },
    { id: 'V020', w: 'not bad', ipa: '/ˌnɑːt ˈbæd/', aud: 'AUD024', face: 'not bad', ill: ill('ILL017', 'Leo gives an easy shoulder shrug with open palms and a small friendly smile — not bad'), fn: 'greeting-state chunk (mild positive)' }
  ];
  var setD = [
    { id: 'V021', w: 'name', ipa: '/neɪm/', aud: 'AUD025', ill: ill('ILL018', 'A blank name badge pinned to a shirt with two empty line shapes — a shorter top line and a longer bottom line'), fn: 'noun (the word someone is called)', badge: 'both' },
    { id: 'V022', w: 'first name', ipa: '/ˌfɜːrst ˈneɪm/', aud: 'AUD026', ill: ill('ILL018', 'On a blank name badge, the top shorter line is softly highlighted — the first name line'), fn: 'noun chunk (given name)', badge: 'top' },
    { id: 'V023', w: 'last name', ipa: '/ˌlæst ˈneɪm/', aud: 'AUD027', ill: ill('ILL018', 'On a blank name badge, the lower longer line is softly highlighted — the last name line'), fn: 'noun chunk (family name)', badge: 'bottom' },
    { id: 'V024', w: 'My name is …', ipa: '/maɪ ˈneɪm ɪz/', aud: 'AUD028', ill: ill('ILL019', 'Alex gestures with an open hand toward the blank badge on their own chest while introducing themselves'), fn: 'introduction chunk', chunk: true },
    { id: 'V025', w: 'I\'m …', ipa: '/aɪm/', aud: 'AUD029', ill: ill('ILL019', 'Maya introduces herself with a light friendly wave and a small smile'), fn: 'introduction chunk (short friendly form)', chunk: true },
    { id: 'V026', w: 'What\'s your name?', ipa: '/ˈwʌts jər ˈneɪm/', aud: 'AUD030', ill: ill('ILL020', 'Maya leans slightly toward you with an open hand, asking a friendly question'), fn: 'name question chunk', chunk: true },
    { id: 'V027', w: 'Nice to meet you', ipa: '/ˌnaɪs tə ˈmiːt juː/', aud: 'AUD031', ill: ill('ILL021', 'Nina and Leo shake hands warmly at their first meeting, both smiling genuinely'), fn: 'first-meeting chunk', chunk: true }
  ];
  var setE = [
    { id: 'V028', w: 'How are you?', ipa: '/ˈhaʊ ɑːr juː/', aud: 'AUD032', ill: ill('ILL022', 'Maya looks at Leo with warm care, one gentle open hand toward him as she asks how he is'), fn: 'state question chunk', chunk: true },
    { id: 'V029', w: 'I\'m good/fine/okay', ipa: '/aɪm ɡʊd/', aud: 'AUD033', ill: ill('ILL013', 'A smiling face card anchors the I\'m good answer family'), fn: 'state answer chunk family', chunk: true },
    { id: 'V030', w: 'And you?', ipa: '/ˈænd juː/', aud: 'AUD034', ill: ill('ILL022', 'The open caring hand turns back toward the first speaker — and you?'), fn: 'return-question chunk', chunk: true }
  ];

  /* S10 warm-up — AUD019 plays the six L1 words in sequence; each frame shows three
     word-cards from the S09 gallery. Targets and mechanic are authored; the triads are
     drawn from Sets A/B (the lesson fixes the words, not the distractor sets). */
  var warmFrames = [
    { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', opts: ['hello', 'goodbye', 'please'], key: 'hello' },
    { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', opts: ['excuse me', 'thank you', 'good morning'], key: 'thank you' },
    { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', opts: ['good evening', 'good afternoon', 'good morning'], key: 'good evening' },
    { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', opts: ['hi', 'yes', 'bye'], key: 'bye' },
    { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', opts: ['sorry', 'thanks', 'no'], key: 'sorry' },
    { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', opts: ['good evening', 'see you', 'please'], key: 'see you' }
  ];

  /* S14 — grammar bank PR-G001–G030 (runs here and across S18) */
  var prG = [
    { id: 'PR-G001', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL019', 'Alex gestures with an open hand toward the blank badge on their own chest'), prompt: '___ Alex.', opts: [{ id: 'A', t: 'I\'m' }, { id: 'B', t: 'You\'re' }, { id: 'C', t: 'My' }], key: 'A', ok: 'Yes — I\'m Alex!', no: 'Alex talks about ALEX. Which word means the speaker?', hints: ['Look at the finger — self or other?', 'One option needs a noun after it.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-G002', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL020', 'Maya leans slightly toward you with an open hand, speaking to the person in front of her'), prompt: '___ Maya!', opts: [{ id: 'A', t: 'My' }, { id: 'B', t: 'I\'m' }, { id: 'C', t: 'You\'re' }], key: 'C', ok: 'Yes — You\'re Maya!', no: 'Maya talks about the OTHER person.', hints: ['Who is Maya talking about?', 'One option needs a noun after it.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-G003', instr: 'Look. Choose.', icon: 'choose', prompt: 'I am Alex. → short friendly form:', opts: [{ id: 'A', t: 'Alex I\'m.' }, { id: 'B', t: 'I\'m Alex.' }, { id: 'C', t: 'I Alex.' }], key: 'B', ok: 'Yes — two words join: I\'m!', no: 'Join I + am. Keep the order.', hints: ['Say it fast — the two words melt together.', 'One option lost am completely.'], secs: 15, a11y: [] },
    { id: 'PR-G004', instr: 'Look. Choose.', icon: 'choose', prompt: 'You are Maya. → short friendly form:', opts: [{ id: 'A', t: 'You Maya.' }, { id: 'B', t: 'You\'re Maya.' }, { id: 'C', t: 'You is Maya.' }], key: 'B', ok: 'Yes — You\'re Maya!', no: 'Join you + are.', hints: ['Say it fast.', 'Never is with you.'], secs: 15, a11y: [] },
    { id: 'PR-G005', instr: 'Look. Choose.', icon: 'choose', prompt: 'I\'m Leo. → long form:', opts: [{ id: 'A', t: 'I am Leo.' }, { id: 'B', t: 'I Leo.' }, { id: 'C', t: 'My Leo.' }], key: 'A', ok: 'Yes — I am Leo!', no: 'Open the short word back to two.', hints: ['I\'m = two words.', 'One option has no verb.'], secs: 15, a11y: [] },
    { id: 'PR-G006', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL019', 'Alex points across at Maya while speaking'), prompt: 'Alex points at Maya: \u2018___ Maya!\u2019', opts: [{ id: 'A', t: 'I\'m' }, { id: 'B', t: 'You\'re' }, { id: 'C', t: 'I\'m not' }], key: 'B', ok: 'Yes — you\'re for the other person.', no: 'The finger points at MAYA.', hints: ['Self or other?', 'One option is a not-form for later.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-G007', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD033', prompt: 'MAYA: \u2018___ good!\u2019', opts: [{ id: 'A', t: 'You\'re' }, { id: 'B', t: 'I\'m' }, { id: 'C', t: 'My' }], key: 'B', ok: 'Yes — I\'m good!', no: 'Whose feeling? Maya\'s own.', hints: ['Replay — whose voice?', 'One option needs a noun.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-G008', instr: 'Look. Choose.', icon: 'choose', prompt: 'I am → one joined word:', opts: [{ id: 'A', t: 'Im' }, { id: 'B', t: 'I\'m' }, { id: 'C', t: 'I \u2019m' }], key: 'B', ok: 'Yes — I\'m, with the little hook.', no: 'The hook (\u2019) sits where the a flew away.', hints: ['Count: I + am = 3 letters lost one.', 'One option has no hook at all.'], secs: 15, a11y: [] },
    { id: 'PR-G009', instr: 'Look. Choose.', icon: 'choose', prompt: 'you are → one joined word:', opts: [{ id: 'A', t: 'Your' }, { id: 'B', t: 'Youre' }, { id: 'C', t: 'You\'re' }], key: 'C', ok: 'Yes — you\'re, with the hook.', no: 'Two words join with a hook. Your is the other word — before a noun.', hints: ['Say you are, then join.', 'One option belongs before name.'], secs: 20, a11y: [] },
    { id: 'PR-G010', instr: 'Look. Choose.', icon: 'choose', prompt: 'I ___ good.', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'is' }, { id: 'C', t: 'am' }], key: 'C', ok: 'Yes — I am good!', no: 'With I, use am.', hints: ['Say: I am… good!', 'One option belongs with you.'], secs: 15, a11y: [] },
    { id: 'PR-G011', instr: 'Look. Choose.', icon: 'choose', prompt: 'You ___ fine.', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'am' }, { id: 'C', t: 'is' }], key: 'A', ok: 'Yes — You are fine!', no: 'With you, use are.', hints: ['Say: You are… fine!', 'One option belongs with I.'], secs: 15, a11y: [] },
    { id: 'PR-G012', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['I\'m', 'Maya', '.'], key: ['I\'m', 'Maya', '.'], ok: 'I\'m Maya. — done!', no: 'Start with the joined word.', hints: ['Which tile is the speaker?', 'The dot goes last.'], secs: 20, a11y: ['tap_only_no_drag'] },
    { id: 'PR-G013', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL018', 'A blank name badge with the speaker\'s own badge glowing softly'), prompt: '___ name is Alex.', opts: [{ id: 'A', t: 'My' }, { id: 'B', t: 'Your' }, { id: 'C', t: 'And' }], key: 'A', ok: 'Yes — my name!', no: 'Whose badge glows? The speaker\'s own.', hints: ['Look at the glowing badge.', 'One option is not a badge word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-G014', instr: 'Look. Choose.', icon: 'choose', prompt: 'Maya to Alex: \u2018___ name is Alex.\u2019', opts: [{ id: 'A', t: 'My' }, { id: 'B', t: 'Your' }, { id: 'C', t: 'I\'m' }], key: 'B', ok: 'Yes — your name, Alex!', no: 'Maya talks about Alex\'s badge.', hints: ['Whose badge? Alex\'s. Maya speaks ABOUT it.', 'One option means the speaker\'s own.'], secs: 20, a11y: [] },
    { id: 'PR-G015', instr: 'Look. Choose.', icon: 'choose', prompt: 'My name ___ Leo.', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'is' }, { id: 'C', t: 'am' }], key: 'B', ok: 'Yes — My name is Leo!', no: 'name pairs with is.', hints: ['Say it: my name is…', 'I and you each own one of the other options.'], secs: 15, a11y: [] },
    { id: 'PR-G016', instr: 'Look. Choose.', icon: 'choose', prompt: 'What\'s ____ name?', opts: [{ id: 'A', t: 'you' }, { id: 'B', t: 'my' }, { id: 'C', t: 'your' }], key: 'C', ok: 'Yes — What\'s YOUR name?', no: 'You ask about THEIR badge.', hints: ['Point outward — whose name do you ask?', 'One option is not a badge word.'], secs: 15, a11y: [] },
    { id: 'PR-G017', instr: 'Look. Choose.', icon: 'choose', prompt: 'Nina points at her own badge: \u2018____ name is Nina.\u2019', opts: [{ id: 'A', t: 'Your' }, { id: 'B', t: 'My' }, { id: 'C', t: 'And' }], key: 'B', ok: 'Yes — my name is Nina!', no: 'Her OWN badge.', hints: ['Self or other?', 'One option is not a badge word.'], secs: 15, a11y: [] },
    { id: 'PR-G018', instr: 'Look. Choose.', icon: 'choose', prompt: 'Nina points at YOU: \u2018What\'s ____ name?\u2019', opts: [{ id: 'A', t: 'my' }, { id: 'B', t: 'your' }, { id: 'C', t: 'I\'m' }], key: 'B', ok: 'Yes — YOUR name!', no: 'She points at YOU.', hints: ['Follow the finger.', 'One option is not a badge word.'], secs: 15, a11y: [] },
    { id: 'PR-G019', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['My', 'name', 'is', 'Maya', '.'], key: ['My', 'name', 'is', 'Maya', '.'], ok: 'My name is Maya. — perfect!', no: 'Start with the badge word.', hints: ['Which two tiles go first together?', 'is comes before the name.'], secs: 25, a11y: ['tap_only_no_drag'] },
    { id: 'PR-G020', instr: 'Look. Choose.', icon: 'choose', prompt: 'One is correct:', opts: [{ id: 'A', t: 'Me name is Alex.' }, { id: 'B', t: 'My name Alex.' }, { id: 'C', t: 'My name is Alex.' }], key: 'C', ok: 'Yes — My name is Alex!', no: 'Check the badge word and the little verb.', hints: ['Read each aloud.', 'Two options are missing one piece each.'], secs: 20, a11y: [] },
    { id: 'PR-G021', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD030', opts: [{ id: 'A', t: 'I\'m fine.' }, { id: 'B', t: 'My name is Alex.' }, { id: 'C', t: 'Goodbye!' }], key: 'B', ok: 'Yes — name for name.', no: 'A NAME question wants a NAME.', hints: ['Replay; listen for name.', 'Remove the goodbye.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-G022', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD032', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'My name is Maya.' }, { id: 'C', t: 'I\'m fine, thank you!' }], key: 'C', ok: 'Yes — feeling for feeling.', no: 'A HOW question wants a feeling word.', hints: ['Replay; listen for how.', 'Remove the name answer.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-G023', instr: 'Look. Choose.', icon: 'choose', prompt: 'You want the NAME. Choose the question:', opts: [{ id: 'A', t: 'How are you?' }, { id: 'B', t: 'Nice to meet you.' }, { id: 'C', t: 'What\'s your name?' }], key: 'C', ok: 'Yes — the name question!', no: 'Which question asks for a NAME?', hints: ['Look for the question marks.', 'One asks feelings.'], secs: 15, a11y: [] },
    { id: 'PR-G024', instr: 'Look. Choose.', icon: 'choose', prompt: 'You want the FEELING. Choose the question:', opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'How are you?' }, { id: 'C', t: 'Nice to meet you.' }], key: 'B', ok: 'Yes — the caring question!', no: 'Which question asks HOW?', hints: ['Look for the question marks.', 'One asks names.'], secs: 15, a11y: [] },
    { id: 'PR-G025', instr: 'Look. Choose.', icon: 'choose', prompt: 'Leo: \u2018I\'m Leo.\u2019 You:', opts: [{ id: 'A', t: 'Nice to meet you!' }, { id: 'B', t: 'And you?' }, { id: 'C', t: 'My name is Leo.' }], key: 'A', ok: 'Yes — meet him warmly!', no: 'A first meeting just happened.', hints: ['Is anyone leaving? Is a question open?', 'One option repeats Leo\'s own name.'], secs: 20, a11y: [] },
    { id: 'PR-G026', instr: 'Look. Choose.', icon: 'choose', prompt: 'Maya: \u2018I\'m good! And you?\u2019 You:', opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'I\'m okay, thank you!' }, { id: 'C', t: 'You\'re welcome!' }], key: 'B', ok: 'Yes — your turn to give your feeling!', no: 'Maya asked YOU how you are.', hints: ['What kind of question is open?', 'One option answers a thanks.'], secs: 20, a11y: [] },
    { id: 'PR-G027', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['Hello! What\'s your name?', 'Hi! My name is Maya.', 'Nice to meet you, Maya!', 'How are you?'], key: ['Hello! What\'s your name?', 'Hi! My name is Maya.', 'Nice to meet you, Maya!', 'How are you?'], ok: 'A perfect first meeting!', no: 'Start with the question for a name.', hints: ['Which line asks first?', 'The meeting words come after the name.'], secs: 40, a11y: ['tap_only_no_drag'] },
    { id: 'PR-G028', instr: 'Look. Choose.', icon: 'choose', prompt: 'One is correct:', opts: [{ id: 'A', t: 'i\'m alex.' }, { id: 'B', t: 'I\'m Alex.' }, { id: 'C', t: 'I\'m Alex' }], key: 'B', ok: 'Yes — big I, big name, full stop!', no: 'Check the big letters and the end dot.', hints: ['Point at each letter size.', 'One option has no end dot.'], secs: 20, a11y: [] },
    { id: 'PR-G029', instr: 'Look. Choose.', icon: 'choose', prompt: 'Which one ASKS? Choose the line with the hook (?)', opts: [{ id: 'A', t: 'My name is Leo.' }, { id: 'B', t: 'Nice to meet you.' }, { id: 'C', t: 'What\'s your name?' }], key: 'C', ok: 'Yes — the hook means asking!', no: 'Look at the very end of each line.', hints: ['Find the ? symbol.', 'Two lines end with a dot.'], secs: 15, a11y: [] },
    { id: 'PR-G030 · blank 1', instr: 'Look. Choose. One.', icon: 'choose', aud: 'AUD040', ill: ill('ILL022', 'Maya looks at Leo with warm care, one gentle open hand toward him'), prompt: 'A: \u2018Hello! How are you?\u2019 B: \u2018____, thank you! ____?\u2019 — blank one:', opts: [{ id: 'A', t: 'I\'m good' }, { id: 'B', t: 'My name' }, { id: 'C', t: 'Goodbye' }], key: 'A', ok: 'Yes — a feeling first!', no: 'First give a feeling, then bounce the question.', hints: ['Play the model dialogue again.', 'Blank 1 answers How are you?'], secs: 30, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-G030 · blank 2', instr: 'Look. Choose. Two.', icon: 'choose', aud: 'AUD040', ill: ill('ILL022', 'The open caring hand turns back toward the first speaker'), prompt: 'A: \u2018Hello! How are you?\u2019 B: \u2018I\'m good, thank you! ____?\u2019 — blank two:', opts: [{ id: 'A', t: 'And you' }, { id: 'B', t: 'Nice to meet you' }, { id: 'C', t: 'You\'re' }], key: 'A', ok: 'Yes — answer, then ask back!', no: 'After your answer, bounce the question back.', hints: ['Play the model dialogue again.', 'Blank 2 must end with a question mark.'], secs: 30, a11y: ['audio_required_transcript_after_response'] }
  ];

  /* S18 — vocabulary bank PR-V017–V036, interleaved with the remaining grammar items */
  var prCDE = [
    { id: 'PR-V017', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD020', opts: [{ id: 'A', t: 'good' }, { id: 'B', t: 'great' }, { id: 'C', t: 'not bad' }], key: 'A', ok: 'Yes — good!', no: 'A happy word — not the strongest one. Listen again.', hints: ['Replay; the good face lights up.', 'One word is very strong. Remove it.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V018', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD023', opts: [{ id: 'A', t: 'fine' }, { id: 'B', t: 'great' }, { id: 'C', t: 'good' }], key: 'B', ok: 'Yes — great!', no: 'This word is the STRONG happy word.', hints: ['Replay; the arms-up face lights up.', 'Remove the calm word.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V019', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL016', 'Alex raises both arms high with a big open smile, feeling great'), opts: [{ id: 'A', t: 'good' }, { id: 'B', t: 'okay' }, { id: 'C', t: 'great' }], key: 'C', ok: 'Yes — great!', no: 'Look at the arms — they are UP. Strong word.', hints: ['Look at the arms and the smile size.', 'The middle hand is a different face.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'no_color_only_meaning'] },
    { id: 'PR-V020', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL017', 'Leo gives an easy shoulder shrug with open palms and a small friendly smile'), opts: [{ id: 'A', t: 'not bad' }, { id: 'B', t: 'great' }, { id: 'C', t: 'fine' }], key: 'A', ok: 'Yes — not bad!', no: 'The shoulders go up easy — a happy middle answer.', hints: ['Look at the shoulders.', 'Remove the strongest word.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V021', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL015', 'Nina holds one hand level in a so-so tilt with a small neutral smile'), opts: [{ id: 'A', t: 'great' }, { id: 'B', t: 'okay' }, { id: 'C', t: 'good' }], key: 'B', ok: 'Yes — okay!', no: 'The hand is level — in the middle.', hints: ['Look at the hand — is it up, level, or down?', 'Remove the arms-up word.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V022', instr: 'Listen. Match.', icon: 'ear', aud: 'AUD024', kind: 'image', opts: [{ id: 'A', ill: ill('ILL013', 'Warm full smile, arms down — good') }, { id: 'B', ill: ill('ILL016', 'Both arms raised high — great') }, { id: 'C', ill: ill('ILL017', 'Easy shrug with open palms — not bad') }], key: 'C', ok: 'Yes — not bad, with the easy shrug.', no: 'Listen again — a happy middle word.', hints: ['Replay; faces light up in order.', 'Two faces have big energy. Remove one.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'PR-V023', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD032', opts: [{ id: 'A', t: 'I\'m good, thank you!' }, { id: 'B', t: 'My name is Maya.' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Yes — a feeling answer for a feeling question.', no: 'The question asks HOW you are. Give a feeling word.', hints: ['Replay the question; listen for how.', 'Remove the goodbye.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V024', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD030', opts: [{ id: 'A', t: 'I\'m fine.' }, { id: 'B', t: 'My name is Alex.' }, { id: 'C', t: 'Good morning!' }], key: 'B', ok: 'Yes — a name for a name question.', no: 'The question asks for a NAME.', hints: ['Replay; listen for name.', 'Remove the feeling answer.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V025', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL021', 'Nina and Leo shake hands warmly at their first meeting, both smiling genuinely'), opts: [{ id: 'A', t: 'sorry' }, { id: 'B', t: 'goodbye' }, { id: 'C', t: 'Nice to meet you' }], key: 'C', ok: 'Yes — nice to meet you!', no: 'Two people meet for the FIRST time.', hints: ['Look at the hands — they meet.', 'Remove the leaving word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V026', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL018', 'A blank name badge pinned to a shirt with two empty line shapes'), opts: [{ id: 'A', t: 'name' }, { id: 'B', t: 'hello' }, { id: 'C', t: 'thanks' }], key: 'A', ok: 'Yes — a name badge!', no: 'What does the badge carry? One word.', hints: ['Look where the badge points.', 'Two words are spoken, one word is ON the badge.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V027', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD026', opts: [{ id: 'A', t: 'good morning' }, { id: 'B', t: 'first name' }, { id: 'C', t: 'last name' }], key: 'B', ok: 'Yes — first name!', no: 'Listen for FIRST — the top line.', hints: ['Replay; the top badge line glows.', 'Two options are badge lines. Listen for the first sound f-.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V028', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD027', opts: [{ id: 'A', t: 'last name' }, { id: 'B', t: 'nice to meet you' }, { id: 'C', t: 'first name' }], key: 'A', ok: 'Yes — last name!', no: 'Listen for LAST — the bottom line.', hints: ['Replay; the bottom badge line glows.', 'Listen for the l- at the start.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V029', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD021', opts: [{ id: 'A', t: 'name' }, { id: 'B', t: 'great' }, { id: 'C', t: 'fine' }], key: 'C', ok: 'Yes — fine!', no: 'A calm happy word. Listen again.', hints: ['Replay; the calm nod face lights up.', 'Remove the arms-up word.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V030', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL019', 'Alex gestures with an open hand toward the blank badge on their own chest'), opts: [{ id: 'A', t: 'My name is Alex.' }, { id: 'B', t: 'Your name is Alex.' }, { id: 'C', t: 'I\'m good, Alex.' }], key: 'A', ok: 'Yes — my badge, my name!', no: 'Alex points at ALEX\'s badge. Whose name?', hints: ['Look where the finger points.', 'Remove the feeling answer.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V031', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL020', 'Maya leans slightly toward you with an open hand, asking a friendly question'), opts: [{ id: 'A', t: 'My name is Maya.' }, { id: 'B', t: 'What\'s your name?' }, { id: 'C', t: 'How are you?' }], key: 'B', ok: 'Yes — she asks the name question!', no: 'Her hand opens with a QUESTION. Which one asks a name?', hints: ['Look at the hand and the question mark hint.', 'Remove the feeling question.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V032', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL022', 'Maya looks at Leo with warm care, one gentle open hand toward him'), opts: [{ id: 'A', t: 'How are you?' }, { id: 'B', t: 'Nice to meet you.' }, { id: 'C', t: 'Goodbye.' }], key: 'A', ok: 'Yes — the caring question!', no: 'She looks with care and asks a feeling question.', hints: ['Look at her face and hand.', 'Two options are not questions.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V033', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD029', opts: [{ id: 'A', t: 'You\'re welcome!' }, { id: 'B', t: 'See you, Maya!' }, { id: 'C', t: 'Nice to meet you!' }], key: 'C', ok: 'Yes — meet them warmly!', no: 'Maya gives her name for the first time. What do you say?', hints: ['Replay; the handshake scene lights up.', 'Remove the leaving words.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V034', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD033', opts: [{ id: 'A', t: 'thank you' }, { id: 'B', t: 'And you?' }, { id: 'C', t: 'my name' }], key: 'B', ok: 'Yes — and you? The question bounces back!', no: 'After your answer, ask back. Two small words.', hints: ['Replay the end; the hand turns back.', 'Remove the thanks word.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-V035', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL013', 'Maya smiles warmly with relaxed shoulders, arms down'), opts: [{ id: 'A', t: 'bye' }, { id: 'B', t: 'not bad' }, { id: 'C', t: 'good' }], key: 'C', ok: 'Yes — good!', no: 'A happy face without a shrug. Which feeling word?', hints: ['Compare with the shrug face.', 'Remove the leaving word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V036 · pair 1', instr: 'Match.', icon: 'match', aud: 'AUD020', kind: 'pair', pairs: [['good', 'warm smile, arms down'], ['okay', 'level so-so hand'], ['great', 'both arms up']], opts: [{ id: 'A', ill: ill('ILL013', 'Warm full smile, arms down') }, { id: 'B', ill: ill('ILL015', 'Level so-so hand') }, { id: 'C', ill: ill('ILL016', 'Both arms raised high') }], key: 'A', ok: 'Good — the warm smile!', no: 'Replay the word, then look at the arms and smile.', hints: ['Play each word; one face lights at a time.', 'Start with arms-up — that is great.'], secs: 15, a11y: ['tap_only_matching_no_drag', 'alt_text_parallel_options'] },
    { id: 'PR-V036 · pair 2', instr: 'Match.', icon: 'match', aud: 'AUD022', kind: 'pair', pairs: [['okay', 'level so-so hand']], opts: [{ id: 'A', ill: ill('ILL013', 'Warm full smile, arms down') }, { id: 'B', ill: ill('ILL015', 'Level so-so hand') }, { id: 'C', ill: ill('ILL016', 'Both arms raised high') }], key: 'B', ok: 'Okay — the level hand!', no: 'Replay the word, then look at the hand.', hints: ['Play the word again.', 'The middle hand is okay.'], secs: 15, a11y: ['tap_only_matching_no_drag', 'alt_text_parallel_options'] },
    { id: 'PR-V036 · pair 3', instr: 'Match.', icon: 'match', aud: 'AUD023', kind: 'pair', pairs: [['great', 'both arms up']], opts: [{ id: 'A', ill: ill('ILL013', 'Warm full smile, arms down') }, { id: 'B', ill: ill('ILL015', 'Level so-so hand') }, { id: 'C', ill: ill('ILL016', 'Both arms raised high') }], key: 'C', ok: 'All three! Calm okay, happy good, strong great.', no: 'Replay a word, then look at the arms and smile.', hints: ['Play each word; one face lights at a time.', 'Arms-up is great.'], secs: 15, a11y: ['tap_only_matching_no_drag', 'alt_text_parallel_options'] }
  ];

  /* S16 — perception trials (P001 six intonation pairs · P002 six contraction trials) */
  var pronPerceive = [
    { id: 'PR-P001 · 1', instr: 'Listen. Choose.', prompt: 'You\'re Maya.', aud: 'AUD041', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Falling voice — telling. Statements fall; friendly questions rise.' },
    { id: 'PR-P001 · 2', instr: 'Listen. Choose.', prompt: 'You\'re Maya?', aud: 'AUD041', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Rising voice — asking.' },
    { id: 'PR-P001 · 3', instr: 'Listen. Choose.', prompt: 'I\'m Leo.', aud: 'AUD041', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Falling — telling.' },
    { id: 'PR-P001 · 4', instr: 'Listen. Choose.', prompt: 'I\'m Leo?', aud: 'AUD041', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Rising — asking.' },
    { id: 'PR-P001 · 5', instr: 'Listen. Choose.', prompt: 'My name is Nina.', aud: 'AUD041', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Falling — telling. Feedback: “Listen to the END of the voice.”' },
    { id: 'PR-P001 · 6', instr: 'Listen. Choose.', prompt: 'What\'s your name?', aud: 'AUD041', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Rising — asking. Scored per pair, ungraded overall.' },
    { id: 'PR-P002 · 1', instr: 'Listen. Choose.', prompt: 'One word or two?', aud: 'AUD042', opts: [{ id: 'A', t: 'I am' }, { id: 'B', t: 'I\'m' }], note: 'Trial 1 plays the full form: I am.' },
    { id: 'PR-P002 · 2', instr: 'Listen. Choose.', prompt: 'One word or two?', aud: 'AUD042', opts: [{ id: 'A', t: 'I am' }, { id: 'B', t: 'I\'m' }], note: 'Trial 2 plays the joined form: I\'m.' },
    { id: 'PR-P002 · 3', instr: 'Listen. Choose.', prompt: 'One word or two?', aud: 'AUD042', opts: [{ id: 'A', t: 'You are' }, { id: 'B', t: 'You\'re' }], note: 'Trial 3 plays the full form: You are.' },
    { id: 'PR-P002 · 4', instr: 'Listen. Choose.', prompt: 'One word or two?', aud: 'AUD042', opts: [{ id: 'A', t: 'You are' }, { id: 'B', t: 'You\'re' }], note: 'Trial 4 plays the joined form: You\'re.' },
    { id: 'PR-P002 · 5', instr: 'Listen. Choose.', prompt: 'One word or two?', aud: 'AUD042', opts: [{ id: 'A', t: 'What is' }, { id: 'B', t: 'What\'s' }], note: 'Trial 5 plays the full form: What is.' },
    { id: 'PR-P002 · 6', instr: 'Listen. Choose.', prompt: 'One word or two?', aud: 'AUD042', opts: [{ id: 'A', t: 'What is' }, { id: 'B', t: 'What\'s' }], note: 'Trial 6 plays the joined form: What\'s. “One joined word sounds shorter.”' }
  ];

  /* ---------- L03 ---------- */
  var ls1 = [
    { id: 'PR-LS001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD043', prompt: 'How many people talk?', opts: [{ id: 'A', ill: ill('ILL025', 'Two speakers face each other across the welcome table') }, { id: 'B', t: 'three people' }, { id: 'C', t: 'four people' }], key: 'A', ok: 'Yes — two people talk.', no: 'Listen again — count the voices.', hints: ['Play again; the speaker chips glow per turn.', 'Two names are spoken. Count them.'], secs: 30, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-LS002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD043', prompt: 'What kind of talk is this?', opts: [{ id: 'A', t: 'first meeting' }, { id: 'B', t: 'goodbye talk' }, { id: 'C', t: 'sorry talk' }], key: 'A', ok: 'Yes — a first meeting!', no: 'They ask names and meet. What kind of talk is that?', hints: ['Listen for What\'s your name?', 'Remove the problem-talk option.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD043', kind: 'image', prompt: 'What time of day is it?', opts: [{ id: 'A', ill: ill('ILL002', 'Low morning sun, long shadows at the welcome table') }, { id: 'B', ill: ill('ILL004', 'Dark street, warm lamps — evening') }, { id: 'C', ill: ill('ILL003', 'High bright sun, café terrace — afternoon') }], key: 'A', ok: 'Yes — morning!', no: 'Listen for the time greeting.', hints: ['Replay T1.', 'Two greetings are said. Which time?'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] }
  ];
  var ls2 = [
    { id: 'PR-LS004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD046', ill: ill('ILL018', 'A blank name badge with two empty lines'), prompt: 'First name:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Nina' }, { id: 'C', t: 'Leo' }], key: 'B', ok: 'Yes — Nina!', no: 'Listen to the words after My name is.', hints: ['Replay the name line.', 'The FIRST name comes before the family name.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-LS005', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD046', ill: ill('ILL018', 'A blank name badge, the lower longer line glowing'), prompt: 'Last name:', opts: [{ id: 'A', t: 'Petrova' }, { id: 'B', t: 'Nina' }, { id: 'C', t: 'Haddad' }], key: 'A', ok: 'Yes — Petrova!', no: 'The LAST name comes last. Listen again.', hints: ['Replay; the bottom badge line glows.', 'One option is the first name.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS006', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD046', prompt: 'What does Alex say after the name?', opts: [{ id: 'A', t: 'Nice to meet you!' }, { id: 'B', t: 'Goodbye!' }, { id: 'C', t: 'Sorry!' }], key: 'A', ok: 'Yes — the meeting words!', no: 'A first meeting just happened.', hints: ['Replay Alex\'s second line.', 'Remove the leaving word.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS007', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD046', prompt: 'Nina\'s last word:', opts: [{ id: 'A', t: 'please' }, { id: 'B', t: 'Thank you!' }, { id: 'C', t: 'Excuse me' }], key: 'B', ok: 'Yes — thank you!', no: 'The LAST word Nina says.', hints: ['Replay the final line.', 'Two words ask or pass. Remove them.'], secs: 15, a11y: ['audio_required_transcript_after_response'] }
  ];
  var ls3 = [
    { id: 'PR-LS008', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD045', ill: ill('ILL028', 'A café terrace in bright afternoon light'), prompt: 'What time of day is it?', opts: [{ id: 'A', t: 'morning' }, { id: 'B', t: 'afternoon' }, { id: 'C', t: 'evening' }], key: 'B', ok: 'Yes — afternoon!', no: 'Listen to the FIRST greeting.', hints: ['One replay is allowed — listen for the time word.', 'Remove the answer that matches the morning event.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-LS009', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD045', prompt: 'How is Leo?', opts: [{ id: 'A', t: 'great' }, { id: 'B', t: 'I\'m fine' }, { id: 'C', t: 'Not bad!' }], key: 'C', ok: 'Yes — not bad!', no: 'Listen for LEO\'s feeling word (the man).', hints: ['Replay; the male voice answers near the end.', 'One state belongs to Maya.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS010', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD045', prompt: 'Leo\'s last line:', opts: [{ id: 'A', t: 'Excuse me — see you!' }, { id: 'B', t: 'Nice to meet you!' }, { id: 'C', t: 'Good morning!' }], key: 'A', ok: 'Yes — a polite exit!', no: 'The LAST line is the exit.', hints: ['Replay the final line.', 'Two options start the talk, one ends it.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS011 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD030', opts: [{ id: 'A', t: 'I\'m fine.' }, { id: 'B', t: 'My name is Sam.' }, { id: 'C', t: 'See you!' }], key: 'B', ok: 'Yes — a name answers a name question!', no: 'The question wants a NAME.', hints: ['Replay the question.', 'Remove the goodbye.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS012 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD032', opts: [{ id: 'A', t: 'Not bad, thank you! And you?' }, { id: 'B', t: 'My name is Sam.' }, { id: 'C', t: 'Good afternoon!' }], key: 'A', ok: 'Yes — a feeling answer and the ask-back!', no: 'The question wants a FEELING.', hints: ['Replay the question.', 'Remove the name answer.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS013 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', prompt: 'Line model: “Nice to meet you, Nina!”', opts: [{ id: 'A', t: 'Nice to meet you, Maya!' }, { id: 'B', t: 'Bye, Maya!' }, { id: 'C', t: 'I\'m okay, Maya.' }], key: 'A', ok: 'Yes — meeting words return meeting words!', no: 'A first meeting is happening.', hints: ['Replay the line.', 'Remove the leaving word.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS014 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', prompt: 'Line model: “I\'m Leo.”', opts: [{ id: 'A', t: 'Nice to meet you, Leo!' }, { id: 'B', t: 'My name is Leo.' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Yes — meet Leo warmly!', no: 'Leo just gave HIS name for the first time.', hints: ['Replay the line.', 'One option repeats Leo\'s name as your own.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-LS015 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', kind: 'image', prompt: 'T8: “I\'m fine! Excuse me, Nina — see you!” What happens next?', opts: [{ id: 'A', ill: ill('ILL027', 'Maya steps politely away toward the table') }, { id: 'B', ill: ill('ILL021', 'A first-meeting handshake') }, { id: 'C', ill: ill('ILL005', 'Two people wave hello') }], key: 'A', ok: 'Yes — she politely steps away!', no: 'Her words END the talk. What happens after?', hints: ['Replay the last line.', 'Two pictures START meetings.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'PR-LS016 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD045', prompt: 'C6: “I\'m great, thank you! And you?” Leo answers:', opts: [{ id: 'A', t: 'Not bad!' }, { id: 'B', t: 'My name is Leo.' }, { id: 'C', t: 'Good afternoon!' }], key: 'A', ok: 'Yes — the question bounces back and he answers!', no: 'The question asked HOW he is.', hints: ['Replay the end of Maya\'s line.', 'Remove the name and the greeting.'], secs: 20, a11y: ['audio_required_transcript_after_response'] }
  ];

  var cvOrder = [
    { id: 'PR-CV003', instr: 'Put in order. First. Next. Last.', target: 'A short first meeting (panel ILL025).', tiles: ['Hi! What\'s your name?', 'My name is Maya.', 'Nice to meet you, Maya!', 'How are you?'], key: ['Hi! What\'s your name?', 'My name is Maya.', 'Nice to meet you, Maya!', 'How are you?'], ok: 'A perfect mini meeting!', no: 'Start with the question for a name.', hints: ['Which line asks first?', 'The state question comes last.'] },
    { id: 'PR-CV004', instr: 'Put in order. First. Next. Last.', target: 'The model dialogue, first six turns (panel ILL023).', tiles: ['Hi! Good morning!', 'Good morning! Welcome!', 'Thank you! What\'s your name?', 'My name is Maya. I\'m Maya.', 'Nice to meet you, Maya! I\'m Nina.', 'How are you?'], key: ['Hi! Good morning!', 'Good morning! Welcome!', 'Thank you! What\'s your name?', 'My name is Maya. I\'m Maya.', 'Nice to meet you, Maya! I\'m Nina.', 'How are you?'], ok: 'The whole opening — in order!', no: 'Two greetings open the talk.', hints: ['Play the model once more.', 'The name question follows the welcome.'] },
    { id: 'PR-CV015', instr: 'Put in order. First. Next. Last.', target: 'The challenge take — the café meeting (ILL028).', tiles: ['Hello! Good afternoon!', 'My name is Leo. I\'m Leo.', 'Nice to meet you, Leo! I\'m Maya.', 'How are you?', 'I\'m great, thank you! And you?'], key: ['Hello! Good afternoon!', 'My name is Leo. I\'m Leo.', 'Nice to meet you, Leo! I\'m Maya.', 'How are you?', 'I\'m great, thank you! And you?'], ok: 'The café meeting — in order!', no: 'Two lines open: the greeting and the name question group.', hints: ['Play the challenge take once more.', 'The ask-back comes last.'] }
  ];

  var cvItems = [
    { id: 'PR-CV001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD002', prompt: 'You hear: “Hello!”', opts: [{ id: 'A', t: 'Bye!' }, { id: 'B', t: 'Hi!' }, { id: 'C', t: 'Thank you!' }], key: 'B', ok: 'Yes — hello back!', no: 'A hello wants a hello.', hints: ['Replay the greeting.', 'Remove the goodbye.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-CV002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD030', prompt: 'What does she want?', opts: [{ id: 'A', t: 'she wants a name' }, { id: 'B', t: 'she wants to leave' }, { id: 'C', t: 'she says thank you' }], key: 'A', ok: 'Yes — she asks for a name!', no: 'Listen to the question word.', hints: ['Replay; listen for name.', 'Remove the goodbye idea.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-CV005', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD033', prompt: 'Nina says: “I\'m good!” Choose ANOTHER true answer:', opts: [{ id: 'A', t: 'I\'m great!' }, { id: 'B', t: 'I\'m Maya.' }, { id: 'C', t: 'My name' }], key: 'A', ok: 'Yes — any feeling word works in the frame!', no: 'The frame I\'m ___ takes a FEELING.', hints: ['Look at the state strip.', 'Remove the name answer.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-CV006 · card 1', instr: 'Match.', icon: 'match', prompt: '“My name is Sam.” — which question does this card answer?', opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'How are you?' }], key: 'A', ok: 'Name words for name questions!', no: 'Ask: does the card give a NAME or a FEELING?', hints: ['Read the card aloud with each question.', 'I\'m works for both — check what follows it.'], secs: 12, a11y: ['tap_only_no_drag'] },
    { id: 'PR-CV006 · card 2', instr: 'Match.', icon: 'match', prompt: '“I\'m Nina.” — which question does this card answer?', opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'How are you?' }], key: 'A', ok: 'A name after I\'m — a name reply!', no: 'I\'m works for both — check what follows it.', hints: ['What follows I\'m — a name or a feeling?', 'Nina is a name.'], secs: 12, a11y: ['tap_only_no_drag'] },
    { id: 'PR-CV006 · card 3', instr: 'Match.', icon: 'match', prompt: '“I\'m good.” — which question does this card answer?', opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'How are you?' }], key: 'B', ok: 'Feeling words for feeling questions!', no: 'Ask: does the card give a NAME or a FEELING?', hints: ['What follows I\'m — a name or a feeling?', 'good is a feeling.'], secs: 12, a11y: ['tap_only_no_drag'] },
    { id: 'PR-CV006 · card 4', instr: 'Match.', icon: 'match', prompt: '“Not bad!” — which question does this card answer?', opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'How are you?' }], key: 'B', ok: 'Name words for name questions; feeling words for feeling questions!', no: 'Ask: does the card give a NAME or a FEELING?', hints: ['Read the card aloud with each question.', 'The shrug word is a feeling.'], secs: 12, a11y: ['tap_only_no_drag'] },
    { id: 'PR-CV007', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', bubbles: true, said: { sp: 'LEO', t: 'My name is Leo.' }, opts: [{ id: 'A', t: 'Nice to meet you, Leo!' }, { id: 'B', t: 'And you?' }, { id: 'C', t: 'You\'re welcome!' }], key: 'A', ok: 'Yes — meet him warmly!', no: 'A first meeting just happened.', hints: ['Was a question asked?', 'One option answers a thanks.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-CV008', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', bubbles: true, said: { sp: 'MAYA', t: 'I\'m fine! And you?' }, opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'I\'m okay, thank you!' }, { id: 'C', t: 'Goodbye!' }], key: 'B', ok: 'Yes — your feeling, then done!', no: 'The question asked YOU.', hints: ['Which question is open?', 'Remove the new question.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'PR-CV009', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL004', 'On a darkening street lit by warm lamps, two neighbors meet'), prompt: 'The meeting starts. Choose:', opts: [{ id: 'A', t: 'Good evening!' }, { id: 'B', t: 'Good morning!' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Yes — good evening!', no: 'Look at the sky and the lamps. The meeting STARTS.', hints: ['Day or night?', 'Remove the goodbye.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV010', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL007', 'Two friends walk away from each other down a park path, turning to wave'), prompt: 'The meeting ends. Choose:', opts: [{ id: 'A', t: 'Hello!' }, { id: 'B', t: 'See you!' }, { id: 'C', t: 'What\'s your name?' }], key: 'B', ok: 'Yes — see you!', no: 'They walk AWAY.', hints: ['Look at the feet.', 'Two options open a talk.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV011', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL027', 'Maya steps politely away toward the table'), prompt: 'Maya goes to the table. She says ___ first.', opts: [{ id: 'A', t: 'Excuse me' }, { id: 'B', t: 'I\'m fine' }, { id: 'C', t: 'Good morning' }], key: 'A', ok: 'Yes — excuse me!', no: 'She steps PAST to leave politely.', hints: ['Look — she moves away.', 'One option is a feeling word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV012', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL027', 'A polite step away from the conversation'), prompt: 'Nina has no time. Her polite close:', opts: [{ id: 'A', t: 'Hello!' }, { id: 'B', t: 'What\'s your name?' }, { id: 'C', t: 'Excuse me — see you!' }], key: 'C', ok: 'Yes — the polite exit!', no: 'She has NO time — end the talk kindly.', hints: ['Does she open or close?', 'Remove the question.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV013', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', kind: 'image', prompt: 'Who says Welcome!?', opts: [{ id: 'A', ill: chr('ILL002', 'Maya Haddad — the helper at the table') }, { id: 'B', ill: chr('ILL004', 'Nina Petrova — the arriving guest') }, { id: 'C', ill: chr('ILL003', 'Leo Novak') }], key: 'A', ok: 'Yes — Maya welcomes!', no: 'The HELPER at the table says welcome.', hints: ['Replay T2 with the panel showing.', 'Two speakers: who arrives, who helps?'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'PR-CV014 · blank 1', instr: 'Look. Choose. One.', icon: 'choose', ill: ill('ILL020', 'Maya leans slightly toward you with an open hand, asking'), prompt: 'MAYA: “Hi! What\'s your name?” YOU: ____', opts: [{ id: 'A', t: 'My name is Sam.' }, { id: 'B', t: 'I\'m fine.' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Your name — the right answer for a name question.', no: 'Give your NAME, then your FEELING.', hints: ['Check which question each blank follows.', 'Blank 1 answers What\'s your name?'], secs: 40, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV014 · blank 2', instr: 'Look. Choose. Two.', icon: 'choose', ill: ill('ILL020', 'Maya asks the second question'), prompt: 'MAYA: “Nice to meet you! How are you?” YOU: ____', opts: [{ id: 'A', t: 'My name is Sam.' }, { id: 'B', t: 'I\'m okay, thank you!' }, { id: 'C', t: 'Good morning!' }], key: 'B', ok: 'You just held up your end of the meeting!', no: 'Give your NAME, then your FEELING.', hints: ['Check which question each blank follows.', 'Blank 2 answers How are you?'], secs: 40, a11y: ['alt_text_construct_equivalent'] }
  ];

  var pron23b = [
    { id: 'PR-P005', instr: 'Listen. Choose.', prompt: 'Tap the strong word: What\'s your name?', aud: 'AUD030', opts: [{ id: 'A', t: 'What\'s' }, { id: 'B', t: 'your' }, { id: 'C', t: 'name' }], note: 'The last word carries the stress — NAME. “Small words stay small.”' },
    { id: 'PR-P006', instr: 'Listen. Choose.', prompt: 'Telling \u2198 or asking \u2197? Four lines.', aud: 'AUD044', opts: [{ id: 'A', t: 'telling \u2198' }, { id: 'B', t: 'asking \u2197' }], note: 'Trials: “My name is Maya.” \u2198 · “How are you?” \u2197 · “I\'m good.” \u2198 · “And you?” \u2197' },
    { id: 'PR-P009', instr: 'Listen. Choose.', prompt: 'Tap the strong word: Nice to meet you.', aud: 'AUD031', opts: [{ id: 'A', t: 'Nice' }, { id: 'B', t: 'meet' }, { id: 'C', t: 'you' }], note: 'Stress lands on meet — the BIG word is in the middle.' }
  ];
  var pron26b = [
    { id: 'PR-CV016', word: 'Nice to meet you, Nina!', aud: 'AUD044', note: 'Make MEET the big word. Ungraded — record, play both, compare. Skip costs nothing.' },
    { id: 'PR-P007', word: 'My name is Nina Petrova. · Thank you!', aud: 'AUD046', note: 'Say Nina Petrova first, then the whole line. Next: try it with YOUR name.' },
    { id: 'PR-P008', word: 'Excuse me, Nina — see you!', aud: 'AUD044', note: 'Keep it light and friendly, not sad.' },
    { id: 'PR-P010', word: 'My name is ___. I\'m ___.', aud: 'AUD038', note: 'Use your own name. Keep the voice down at the end for telling. Private playback.' }
  ];

  var rd1 = [
    { id: 'PR-RD001', instr: 'Read. Choose.', icon: 'eye', prompt: 'Badge: MAYA HADDAD · First name:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Haddad' }, { id: 'C', t: 'Leo' }], key: 'A', ok: 'Yes — Maya!', no: 'The TOP word is the first name.', hints: ['Point to the top word.', 'One name is from the other badge.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'PR-RD002', instr: 'Read. Choose.', icon: 'eye', prompt: 'Badge: MAYA HADDAD · Last name:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Leo' }, { id: 'C', t: 'Haddad' }], key: 'C', ok: 'Yes — Haddad!', no: 'The BOTTOM word is the last name.', hints: ['Point to the bottom word.', 'One option is Maya herself.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'PR-RD003', instr: 'Read. Choose.', icon: 'eye', prompt: 'Badge: LEO NOVAK · First name:', opts: [{ id: 'A', t: 'Novak' }, { id: 'B', t: 'Leo' }, { id: 'C', t: 'Maya' }], key: 'B', ok: 'Yes — Leo!', no: 'The TOP word on this badge.', hints: ['Point to the top word.', 'One option is from Maya\'s badge.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'PR-RD004', instr: 'Read. Choose.', icon: 'eye', prompt: 'Badge: LEO NOVAK · Last name:', opts: [{ id: 'A', t: 'Novak' }, { id: 'B', t: 'Leo' }, { id: 'C', t: 'Haddad' }], key: 'A', ok: 'Yes — Novak!', no: 'The BOTTOM word on this badge.', hints: ['Point to the bottom word.', 'One option belongs to Maya.'], secs: 15, a11y: ['dynamic_type_to_XL'] }
  ];
  var rd2 = [
    { id: 'PR-RD005', instr: 'Read. Choose.', icon: 'eye', prompt: 'The card is from:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Alex' }, { id: 'C', t: 'Nina' }], key: 'B', ok: 'Yes — Alex\'s card!', no: 'Read the second line.', hints: ['Find My name is…', 'Two options are helpers, one is the host.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'PR-RD006', instr: 'Read. Choose.', icon: 'eye', prompt: 'The card says:', opts: [{ id: 'A', t: 'a name' }, { id: 'B', t: 'a goodbye' }, { id: 'C', t: 'a question' }], key: 'A', ok: 'Yes — it gives a name!', no: 'Look for a ? or a farewell word.', hints: ['Point at the end marks.', 'Welcome is a hello word.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'PR-RD007 · scene 1', instr: 'Match.', icon: 'match', ill: ill('ILL002', 'Low morning sun with long shadows'), prompt: 'Greeting board — which label fits this scene?', opts: [{ id: 'A', t: 'Good morning!' }, { id: 'B', t: 'Good evening!' }], key: 'A', ok: 'Morning sun — matched!', no: 'Look at the sky and the lamps.', hints: ['Say each greeting with each scene.', 'The dark scene is not morning.'], secs: 15, a11y: ['tap_only_matching_no_drag', 'alt_text_construct_equivalent'] },
    { id: 'PR-RD007 · scene 2', instr: 'Match.', icon: 'match', ill: ill('ILL004', 'A dark street lit by warm lamps'), prompt: 'Greeting board — which label fits this scene?', opts: [{ id: 'A', t: 'Good morning!' }, { id: 'B', t: 'Good evening!' }], key: 'B', ok: 'Morning sun, evening lamps — matched!', no: 'Look at the sky and the lamps.', hints: ['Say each greeting with each scene.', 'The dark scene is not morning.'], secs: 15, a11y: ['tap_only_matching_no_drag', 'alt_text_construct_equivalent'] },
    { id: 'PR-RD008', instr: 'Read. Choose.', icon: 'eye', ill: ill('ILL018', 'A blank badge under the written question'), prompt: 'Written: “What\'s your name?” · Your line:', opts: [{ id: 'A', t: 'My name is Sam.' }, { id: 'B', t: 'I\'m fine, thank you!' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Yes — you read the question and answered it!', no: 'Read the question again — what does it want?', hints: ['Find the word name in the question.', 'Remove the goodbye.'], secs: 20, a11y: ['dynamic_type_to_XL'] }
  ];

  /* ---------- L04 ---------- */
  var quiz = [
    { id: 'QZ-V001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD012', opts: [{ id: 'A', t: 'thanks' }, { id: 'B', t: 'sorry' }, { id: 'C', t: 'hello' }], key: 'A', ok: 'Yes — thanks!', no: 'One small word for a small thank-you.', hints: ['Replay; the receiving picture lights up.', 'One option is a greeting. Remove it.'], secs: 15, a11y: ['audio_required_transcript_after_response'] },
    { id: 'QZ-V002', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL031', 'A smiling person with short curly dark hair walks toward an open shop door, waving hello'), prompt: 'The meeting starts:', opts: [{ id: 'A', t: 'Goodbye!' }, { id: 'B', t: 'Hello!' }, { id: 'C', t: 'See you!' }], key: 'B', ok: 'Yes — hello starts the meeting!', no: 'The person ARRIVES. Which words open a meeting?', hints: ['Look at the feet and the door.', 'Two options end talks.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'QZ-V003', instr: 'Listen. Match.', icon: 'ear', aud: 'AUD006', kind: 'image', opts: [{ id: 'A', ill: ill('ILL002', 'Low rising sun, long shadows') }, { id: 'B', ill: ill('ILL004', 'Dark sky, warm lamps') }, { id: 'C', ill: ill('ILL003', 'High sun, café terrace') }], key: 'B', ok: 'Yes — evening!', no: 'Listen for the time word, then look at the sky.', hints: ['Replay; one scene lights up per word.', 'Two scenes are daylight.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'QZ-V004', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL032', 'Sam gives a small box with both hands to Nina, who receives it with a warm smile'), prompt: 'Nina gets the box. Nina says:', opts: [{ id: 'A', t: 'Excuse me' }, { id: 'B', t: 'Sorry!' }, { id: 'C', t: 'Thank you!' }], key: 'C', ok: 'Yes — thank you!', no: 'Nina GETS the box. Which word is for getting?', hints: ['Look at the hands — give and get.', 'One word is only for problems.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'QZ-V005', instr: 'Listen. Match.', icon: 'ear', aud: 'AUD022', kind: 'image', opts: [{ id: 'A', ill: ill('ILL016', 'Both arms raised high') }, { id: 'B', ill: ill('ILL015', 'Level so-so hand') }, { id: 'C', ill: ill('ILL013', 'Full warm smile') }], key: 'B', ok: 'Yes — okay!', no: 'Listen again — a middle word.', hints: ['Replay; faces light up in order.', 'One face has arms high. Remove it.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'QZ-V006', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL034', 'The same street corner three times: low rising sun, high midday sun, and a dark sky with warm lamps'), prompt: 'Panel three (dark sky):', opts: [{ id: 'A', t: 'Good morning!' }, { id: 'B', t: 'Good evening!' }, { id: 'C', t: 'Bye!' }], key: 'B', ok: 'Yes — good evening!', no: 'Find the dark panel. Its sky and lamps ask for one greeting.', hints: ['Look at panel three\'s sky and lamps.', 'Remove the goodbye.'], secs: 20, a11y: ['alt_text_construct_equivalent'] },
    { id: 'QZ-G001', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL033', 'A blank name badge with two empty lines pinned to a green t-shirt'), prompt: 'Sam\'s badge. Sam says: \u2018____ name is Sam.\u2019', opts: [{ id: 'A', t: 'My' }, { id: 'B', t: 'Your' }, { id: 'C', t: 'And' }], key: 'A', ok: 'Yes — my!', no: 'Whose badge? Sam\'s OWN badge.', hints: ['Self or other?', 'One option is not a badge word.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'QZ-G002', instr: 'Look. Choose.', icon: 'choose', prompt: 'I ___ Sam.', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'is' }, { id: 'C', t: 'am' }], key: 'C', ok: 'Yes — I am Sam!', no: 'With I, use am.', hints: ['Say it aloud: I am…', 'One option belongs with you.'], secs: 15, a11y: [] },
    { id: 'QZ-G003', instr: 'Look. Choose.', icon: 'choose', prompt: 'You ___ Sam!', opts: [{ id: 'A', t: 'are' }, { id: 'B', t: 'am' }, { id: 'C', t: 'is' }], key: 'A', ok: 'Yes — You are Sam!', no: 'With you, use are.', hints: ['Say it aloud: You are…', 'One option belongs with I.'], secs: 15, a11y: [] },
    { id: 'QZ-G004', instr: 'Look. Choose.', icon: 'choose', prompt: 'What\'s ____ name?', opts: [{ id: 'A', t: 'my' }, { id: 'B', t: 'you' }, { id: 'C', t: 'your' }], key: 'C', ok: 'Yes — What\'s your name?', no: 'You ask about THEIR name.', hints: ['Point outward — whose name?', 'One option needs are after it.'], secs: 15, a11y: [] },
    { id: 'QZ-G005', instr: 'Look. Choose.', icon: 'choose', prompt: 'I am Sam. → short friendly form: ____ Sam.', opts: [{ id: 'A', t: 'I\'m' }, { id: 'B', t: 'Im' }, { id: 'C', t: 'I' }], key: 'A', ok: 'Yes — I\'m Sam!', no: 'Join I and am — keep the little hook.', hints: ['Say it fast — two words melt.', 'One option lost the hook; one lost the verb.'], secs: 15, a11y: [] },
    { id: 'QZ-G006', instr: 'Look. Choose.', icon: 'choose', prompt: 'One is correct:', opts: [{ id: 'A', t: 'Me name is Sam.' }, { id: 'B', t: 'My name is Sam.' }, { id: 'C', t: 'My name Sam.' }], key: 'B', ok: 'Yes — perfect introduction!', no: 'Check the badge word and the little verb.', hints: ['Read each aloud.', 'Two options each miss one piece.'], secs: 20, a11y: [] },
    { id: 'QZ-LS001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD047', ill: ill('ILL033', 'Sam\'s blank badge on a green t-shirt'), prompt: 'First name:', opts: [{ id: 'A', t: 'Sam' }, { id: 'B', t: 'Rivera' }, { id: 'C', t: 'Maya' }], key: 'A', ok: 'Yes — Sam!', no: 'Listen to the words after My name is.', hints: ['Replay the first line.', 'The FIRST name comes first.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'QZ-LS002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD047', prompt: 'How is Sam?', opts: [{ id: 'A', t: 'great' }, { id: 'B', t: 'okay' }, { id: 'C', t: 'fine' }], key: 'B', ok: 'Yes — okay!', no: 'Listen for SAM\'s feeling word (the man).', hints: ['Replay Sam\'s second line.', 'One state belongs to Maya.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'QZ-LS003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD043', prompt: 'Who says \u2018Excuse me\u2019?', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Alex' }, { id: 'C', t: 'Maya' }], key: 'C', ok: 'Yes — Maya politely exits!', no: 'Listen to the END of the dialogue — who steps away?', hints: ['Replay the last line.', 'The speaker says a NAME after excuse me — whose?'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'QZ-LS004', instr: 'Listen. Match.', icon: 'ear', aud: 'AUD045', kind: 'image', prompt: 'Where are they?', opts: [{ id: 'A', ill: ill('ILL028', 'The café terrace in afternoon light') }, { id: 'B', ill: ill('ILL001', 'The community hall welcome event') }, { id: 'C', ill: ill('ILL007', 'The park path farewell') }], key: 'A', ok: 'Yes — the café!', no: 'Good afternoon + Leo + Maya — where did they meet?', hints: ['Replay the opening line.', 'Two scenes are from the morning event.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'alt_text_parallel_options'] },
    { id: 'QZ-RD001', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL033', 'Sam\'s badge, app-layer text SAM RIVERA'), prompt: 'Badge: SAM RIVERA · Last name:', opts: [{ id: 'A', t: 'Sam' }, { id: 'B', t: 'Rivera' }, { id: 'C', t: 'Kim' }], key: 'B', ok: 'Yes — Rivera!', no: 'The BOTTOM word is the last name.', hints: ['Point to the bottom word.', 'One option is Alex\'s family name.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'QZ-RD002', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL030', 'A two-line welcome card surface'), prompt: 'Card: “Welcome! / My name is Maya. / Nice to meet you.” · The card is from:', opts: [{ id: 'A', t: 'Alex' }, { id: 'B', t: 'Leo' }, { id: 'C', t: 'Maya' }], key: 'C', ok: 'Yes — Maya\'s card!', no: 'Read the middle line.', hints: ['Find My name is…', 'Two names are other cast members.'], secs: 15, a11y: ['dynamic_type_to_XL'] },
    { id: 'QZ-CN001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD032', bubbles: true, said: { sp: 'MAYA', t: 'How are you?' }, opts: [{ id: 'A', t: 'My name is Sam.' }, { id: 'B', t: 'I\'m fine, thank you! And you?' }, { id: 'C', t: 'Good afternoon!' }], key: 'B', ok: 'Yes — feeling plus the ask-back!', no: 'The question asks HOW you are.', hints: ['Replay the question.', 'Remove the name answer.'], secs: 20, a11y: ['audio_required_transcript_after_response'] },
    { id: 'QZ-CN002', instr: 'Put in order. First. Next. Last.', icon: 'choose', kind: 'order', ill: ill('ILL032', 'Sam and Nina at the welcome table'), tiles: ['Hello! What\'s your name?', 'My name is Sam.', 'Nice to meet you, Sam!', 'How are you?'], key: ['Hello! What\'s your name?', 'My name is Sam.', 'Nice to meet you, Sam!', 'How are you?'], ok: 'A brand-new meeting, in perfect order!', no: 'Start with the name question.', hints: ['Which line asks first?', 'The state question ends the sequence.'], secs: 45, a11y: ['tap_only_no_drag'] },
    { id: 'QZ-WR001', instr: 'Put in order.', icon: 'choose', kind: 'order', aud: 'AUD030', ill: ill('ILL020', 'Maya asking the name question'), tiles: ['What\'s', 'your', 'name', '?'], key: ['What\'s', 'your', 'name', '?'], ok: 'What\'s your name? — with the asking hook!', no: 'The asking hook (?) ends the line.', hints: ['Play the model and point.', 'The hook goes last.'], secs: 30, a11y: ['tap_only_no_drag'] },
    { id: 'QZ-WR002', instr: 'Look. Choose.', icon: 'choose', prompt: 'One is correct:', opts: [{ id: 'A', t: 'my name is sam.' }, { id: 'B', t: 'My name is Sam.' }, { id: 'C', t: 'My Name Is Sam.' }], key: 'B', ok: 'Yes — big M, big Sam, small others!', no: 'Check which words are BIG.', hints: ['Point at each letter size.', 'One option has no big letters at all.'], secs: 20, a11y: [] }
  ];

  var wr34 = [
    { id: 'PR-WR003', instr: 'Look. Choose.', target: 'Nice to meet you ___', opts: [{ id: '.', t: '.' }, { id: '?', t: '?' }, { id: '!', t: '!' }], key: '.', ok: 'Yes — it tells, so it ends with the dot.', no: 'The voice goes DOWN — a telling dot.', hints: ['Say it — up or down at the end?', 'The asking hook is for questions.'] },
    { id: 'PR-WR004 · line 1', instr: 'Look. Choose. One.', target: 'Build YOUR two-line welcome card — line one:', opts: [{ id: 'Welcome!', t: 'Welcome!' }, { id: 'See you!', t: 'See you!' }, { id: 'Sorry!', t: 'Sorry!' }], key: 'Welcome!', ok: 'Line one says hello to everyone.', no: 'Line 1 says hello to everyone; line 2 gives your name.', hints: ['Which line works for EVERY reader?', 'Line 2 must give a name.'] },
    { id: 'PR-WR004 · line 2', instr: 'Look. Choose. Two.', target: 'Build YOUR two-line welcome card — line two:', opts: [{ id: 'My name is Sam.', t: 'My name is Sam.' }, { id: 'I\'m fine.', t: 'I\'m fine.' }, { id: 'How are you?', t: 'How are you?' }], key: 'My name is Sam.', ok: 'Your card is ready for the table!', no: 'Line 2 must give a name.', hints: ['Which line works for EVERY reader?', 'Line 2 must give a name.'] },
    { id: 'PR-WR005', instr: 'Put in order.', target: 'Sam\'s badge (ILL033).', tiles: ['My', 'first', 'name', 'is', 'Sam', '.'], key: ['My', 'first', 'name', 'is', 'Sam', '.'], ok: 'My first name is Sam. — six tiles, one sentence!', no: 'Start with the badge words.', hints: ['Which three words sit together on the badge?', 'The dot goes last.'] },
    { id: 'PR-WR006', instr: 'Put in order.', target: 'AUD029 — “I\'m Maya.” as the model.', tiles: ['I\'m', 'Nina', '.'], key: ['I\'m', 'Nina', '.'], ok: 'I\'m Nina. — short and friendly!', no: 'The joined word comes first.', hints: ['Play the model.', 'The dot goes last.'] }
  ];

  C.chapters.push({
    id: 'A1-C01', n: 1, arc: 'Meet and connect', title: 'Hello! My Name Is Alex',
    mission: 'At the Community House welcome event, greet a recurring character, exchange names, ask how the person is, and close politely.',
    canDos: ['C1-1 time-appropriate greetings and farewells', 'C1-4 basic politeness', 'C1-2 say and ask a name', 'C1-3 ask and answer How are you?'],
    doNotTeach: ['Good night as a greeting', 'anything outside the cumulative ledger'],
    lessons: [
      {
        id: 'L01', type: 'V', n: 1, title: 'Say Hello', time: '18–20 min', pause: 'after Practice A (≈10 min)',
        src: 'A1_C01_L01_LESSON.md',
        screens: [
          {
            id: 'S01', type: 'promise', label: 'Can-do promise', step: 'STEP 1 · 30 sec',
            ill: ill('ILL001', 'A bright community hall with a welcome table; a person with round glasses waves from the door'),
            newToday: 'hello · goodbye · thank you · sorry', newTodayLabel: 'New words today',
            canDos: ['You can say hello.', 'You can say goodbye.', 'You can say thank you.'],
            vo: 'You will learn to: greet people; say thank you and sorry; say goodbye.',
            tip: 'Goal is an instant, low-text promise of competence. Full-bleed illustration top 60%, three can-do lines below with check-ring icons (empty rings that will fill at S09). Tap-anywhere-to-continue with a subtle pulsing affordance; no buttons to read.',
            assets: ['A1-C01-ILL001']
          },
          {
            id: 'S02', type: 'hook', label: 'Story hook', step: 'STEP 2 · 30–60 sec',
            scene: 'Sunny morning outside the Aroa Community House. A welcome table with cups. Alex stands at the door; Maya arrives to help.',
            aud: 'AUD001', delivery: 'learning_slow_clear',
            ill: ill('ILL001', 'A bright community hall with a welcome table; Alex waves from the door while Maya arranges cups'),
            lines: [
              { sp: 'ALEX', t: 'Hello!', d: 'warm, waving' },
              { sp: 'MAYA', t: 'Hi, Alex!', d: 'smiling, arriving' },
              { sp: 'ALEX', t: 'Hi, Maya! … Good morning!' },
              { sp: 'MAYA', t: 'Good morning, Alex!', d: 'setting down cups' },
              { sp: 'ALEX', t: 'Thank you, Maya! …' },
              { sp: 'MAYA', t: 'You\'re welcome!', d: 'CHUNK:survival — shown by Maya\'s happy nod; not a target' }
            ],
            scored: false,
            tip: 'One-tap play with big ear button; illustration animates subtly per speaker (Alex\'s badge glows on their line) to bind sound→speaker. Auto-advance to S03 after playback ends + 1.5 s. Replay freely offered (hook is unscored). Captions OFF by default; a "show words" toggle appears only after one full playback.',
            assets: ['A1-C01-AUD001', 'A1-C01-ILL001']
          },
          {
            id: 'S03', type: 'orientation', label: 'First-run orientation', step: 'STEP 3 · 2–3 min',
            intro: 'Teaches the app\'s five core interactions by demonstration, using only the hook audio and art — zero new language.',
            demos: [
              { icon: 'ear', word: 'listen', demo: 'AUD001 replays; ear icon pulses with the audio' },
              { icon: 'eye', word: 'look', demo: 'Camera pans across ILL001; eye icon pulses' },
              { icon: 'tap', word: 'tap', demo: 'An animated finger taps the play button' },
              { icon: 'choose', word: 'choose', demo: 'Three cups appear; finger selects the one Maya holds; it lifts and settles' },
              { icon: 'mouth', word: 'match · say · repeat', demo: '"Hello" card pairs with wave image; mouth icon invites echo; loop arrow replays one word' }
            ],
            tip: 'The five demos are one horizontally paged flow with a dot progress bar; each "try" is a single large target (min 60×60 pt), failure impossible (any tap advances with gentle confirmation). Reduce-motion replaces pans with crossfades. The icons used here (ear, eye, finger, hand-select, mouth, loop) must be the same icons used across the whole course.',
            assets: ['A1-C01-AUD001', 'A1-C01-ILL001']
          },
          {
            id: 'S04', type: 'cards', label: 'Set A cards — open and close', step: 'STEP 4 · ≈5 min',
            chip: 'Set A · greetings and farewells', cards: setA, encounter: 'Encounter #1 of 4',
            tip: 'Horizontal card pager (swipe or auto-advance after audio); each card = illustration (60%), word (large, Dynamic-Type aware), ear + mouth buttons. Tap ear = replay word model; tap mouth = record echo (ungraded, skippable — mic permission notice shown once, with a clear "not now" path that never blocks progress). Progress dots for 8 cards.',
            assets: ['A1-C01-AUD002–009', 'A1-C01-ILL002–007']
          },
          {
            id: 'S05', type: 'practice', label: 'Micro-practice A', step: 'STEP 5 · ≈3 min',
            items: prA, bank: 'PR-V001–V009 · 8 choice + 1 speak · answer positions A5/B5/C4 across the lesson',
            tip: 'One item per screen-swap; big option cards. Instant non-punitive feedback via the S03 icon language (green check + chime / soft arrow for retry). Correct-answer position rotates by the item records — never render a fixed layout. Hint rung 1 auto-offers after first incorrect tap; rung 2 after second. Replay visible on all audio items. Reduce-motion: no card shake — colour + icon + sound with a text fallback.',
            assets: ['A1-C01-AUD002/004/007/009/016', 'A1-C01-ILL002/004/006/007']
          },
          {
            id: 'S06', type: 'pause', label: 'Pause', step: 'PAUSE · ≈10 min in',
            head: 'Good work! Two new word groups today.',
            ill: ill('ILL001', 'the welcome hall, now with a few cups on the table'),
            body: 'Take a break — or tap to go on. Progress saved automatically.', rings: 3, ringsFilled: 3,
            tip: 'True save-state checkpoint; the lesson resumes at S07 even after app kill. Break affordance is equal in visual weight to continue (rest is never framed as failure). Show three filled mini-rings (promise kept so far).',
            assets: ['A1-C01-ILL001']
          },
          {
            id: 'S07', type: 'cards', label: 'Set B cards — little kind words', step: 'STEP 6 · ≈5 min',
            chip: 'kind words', cards: setB, encounter: 'Encounter #1 for Set B',
            tip: 'Identical pager mechanics as S04 (consistency lowers load); the only difference is a small "kind words" chapter chip so the learner senses progress through a second group. Mic still optional.',
            assets: ['A1-C01-AUD010–016', 'A1-C01-ILL008–012']
          },
          {
            id: 'S08', type: 'practice', label: 'Micro-practice B', step: 'STEP 6b · ≈2–3 min',
            items: prB, bank: 'PR-V010–V016 · 6 choice + 1 speak',
            tip: 'Same mechanics as S05. Mixed illustrated and audio-only items keep interleaving (audio → image → situation) so no single strategy carries multiple items in a row.',
            assets: ['A1-C01-AUD010/011/016', 'A1-C01-ILL006/009/010/011']
          },
          {
            id: 'S09', type: 'review', label: 'Blended review + progress', step: 'STEP 6c · ≈2 min',
            head: '15 new words!', lines: ['You can say hello.', 'You can say thank you.', 'You can say goodbye.'],
            gallery: setA.concat(setB), auds: ['AUD017 — Set A sequence', 'AUD018 — Set B sequence'],
            next: 'Next lesson: your name — I\'m Alex!', rings: 3, ringsFilled: 3,
            tip: 'Celebratory but brief (2 s animation, mutable, reduce-motion safe). The gallery doubles as a free-play recap: tapping any card replays its word model. Streak/XP intentionally absent from this screen — the reward is the filled can-do rings.',
            assets: ['A1-C01-AUD017', 'A1-C01-AUD018']
          }
        ]
      },
      {
        id: 'L02', type: 'G', n: 2, title: 'You and Your Name', time: '≈20 min', pause: 'after S14',
        src: 'A1_C01_L02_LESSON.md',
        screens: [
          {
            id: 'S10', type: 'warmup', label: 'Warm-up retrieval', step: 'STEP 3 · 2–3 min',
            head: 'You know these.', sub: 'Encounter #4 for Sets A and B — memory, not teaching.',
            gallery: setA.concat(setB), dots: 6,
            frames: warmFrames,
            bank: 'AUD019 plays six L1 words in sequence: hello · thank you · good evening · bye · sorry · see you',
            tip: 'Reuse the S09 gallery visuals exactly (consistency signals "you know this"). One replay per word before hints; progress dots ×6. This screen proves memory, not teaching — keep it under 3 minutes even with retries.',
            assets: ['A1-C01-AUD019']
          },
          {
            id: 'S11', type: 'cards', label: 'Set C cards — states', step: 'STEP 4 · ≈4 min',
            chip: 'how you are', cards: setC, strengthStrip: ['fine', 'okay', 'not bad', 'good', 'great'],
            tip: 'The five state faces render side-by-side at the top of each card as a strength strip (calm → strong: fine · okay · not bad · good · great), with the current card\'s face highlighted. The strip is the lesson\'s key visual schema and returns in S18 practice and the L3 dialogue. Faces differ by posture and arm position, never by colour alone.',
            assets: ['A1-C01-AUD020–024', 'A1-C01-ILL013–017']
          },
          {
            id: 'S12', type: 'cards', label: 'Set D cards — names', step: 'STEP 5 · ≈4 min',
            chip: 'names and badges', cards: setD, badgeSchema: true,
            story: 'Everyone clips on blank name badges.',
            tip: 'Badges (ILL018) introduce a two-line schematic the app reuses for every "identity" visual in Chapters 1–3 — keep its geometry identical everywhere. Chunk cards show the whole chunk as one tappable unit (no word-by-word highlighting yet); the ear button plays the full chunk, never single words, so learners store it whole.',
            assets: ['A1-C01-AUD025–031', 'A1-C01-ILL018–021']
          },
          {
            id: 'S13', type: 'grammarModel', label: 'Grammar model — notice first', step: 'STEP 6 · ≈4 min',
            notice: [
              { aud: 'AUD038', task: 'Tap the different word in each pair.', pairs: [['I am', 'I\'m'], ['you are', 'you\'re']] },
              { aud: 'AUD039', task: 'Tap the badge the speaker means.', pairs: [['my name', 'MY badge'], ['your name', 'YOUR badge']] },
              { aud: 'AUD040', task: 'Who asks?', chat: [{ sp: 'MAYA', t: 'Hello! What\'s your name?', ask: true }, { sp: 'ALEX', t: 'My name is Alex. I\'m Alex.' }, { sp: 'MAYA', t: 'Nice to meet you, Alex! How are you?', ask: true }, { sp: 'ALEX', t: 'I\'m good, thank you! … And you?' }, { sp: 'MAYA', t: 'I\'m fine!' }] }
            ],
            records: [
              { id: 'G001', title: 'I\'m · You\'re', pattern: 'I am → I\'m   ·   You are → You\'re', errs: [['I Alex.', 'add am — I\'m Alex.'], ['I is Alex.', 'with I, use am.'], ['You is Maya.', 'with you, use are.']] },
              { id: 'G002', title: 'My name · Your name', pattern: 'my name = MY badge · your name = YOUR badge', errs: [['Me name is Alex.', 'me → my.'], ['My name Alex.', 'add is.'], ['My name is Maya. (said TO Maya about her)', 'talking about her badge → Your name is Maya.']] },
              { id: 'G003', title: 'Two friendly questions', pattern: 'ask → answer → ask back: And you?', errs: [['How are you? — My name is Maya.', 'name question ↔ name answer; state question ↔ state answer.'], ['What\'s your name? — I\'m fine.', 'a name answer fits a name question.']] }
            ],
            tip: 'Notice-before-rule: the screen plays first; pattern text reveals only after the learner completes two tap-to-spot interactions. Pattern display = one line per form pair, generous type, contractions joined with "→". The chunk dialogue renders as a two-speaker chat with the asking turn outlined — never colour-only.',
            assets: ['A1-C01-AUD038', 'A1-C01-AUD039', 'A1-C01-AUD040']
          },
          {
            id: 'S14', type: 'practice', label: 'Guided grammar', step: 'STEP 6b',
            dock: 'I am → I\'m · you are → you\'re · my name / your name · ask → answer → ask back',
            bank: 'PR-G001–G030 (30 items) run here and across S18 · error classes: missing-be, wrong-person, wrong-direction, chunk-swap',
            items: prG,
            tip: 'Errors never end an item: wrong tap → the relevant pattern line glows softly + one retry; second miss → hint rung 2 removes one option; third → answer with explanation, then a near-transfer twin item is queued. Keep the pattern display docked (collapsible) during practice so support stays one tap away.',
            assets: ['A1-C01-AUD030/032/033/040', 'A1-C01-ILL018–020', 'A1-C01-ILL022']
          },
          {
            id: 'S15', type: 'cards', label: 'Set E cards + G003 model', step: 'STEP 6c · ≈3 min',
            chip: 'ask → answer → ask back', cards: setE, flowDots: ['ask', 'answer', 'ask back'], preAud: 'AUD040',
            tip: 'Play AUD040 first (whole meeting dialogue), then the three Set-E cards unbundle the two questions + the return. The "ask → answer → ask back" flow is shown as three linked dots that fill as each chunk plays — this diagram is reused verbatim in the L3 conversation screen.',
            assets: ['A1-C01-AUD032–034', 'A1-C01-AUD040', 'A1-C01-ILL013', 'A1-C01-ILL022']
          },
          {
            id: 'S16', type: 'pronPerceive', label: 'Pronunciation — hear and choose', step: 'STEP 7 · 3–4 min',
            items: pronPerceive,
            bank: 'PR-P001 · 6 intonation pairs (AUD041) · PR-P002 · 6 contraction trials (AUD042) — scored per trial, ungraded overall',
            tip: 'Arrows are the only new symbols (introduced by demo). No accent scoring anywhere.',
            assets: ['A1-C01-AUD041', 'A1-C01-AUD042']
          },
          {
            id: 'S17', type: 'pronProduce', label: 'Pronunciation — say and record', step: 'STEP 7b',
            items: [
              { id: 'PR-P003', word: 'I\'m Alex.', aud: 'AUD038', note: 'Make the voice go down at the end. Say just “I\'m Alex.” — down at the end.' },
              { id: 'PR-P004', word: 'What\'s your name?', aud: 'AUD030', note: 'Let the voice go UP on name. Say only “your name?” — up at the end.' }
            ],
            tip: 'Recording screens show model waveform + learner waveform stacked, replay buttons for each, and a skip that is visually equal to record (never a trap). No accent scoring anywhere; only the one actionable note per record.',
            assets: ['A1-C01-AUD038', 'A1-C01-AUD030', 'A1-C01-ILL019', 'A1-C01-ILL020']
          },
          {
            id: 'S18', type: 'practice', label: 'Practice C/D/E', step: 'STEP 8',
            interleave: true, dock: 'ask → answer → ask back',
            bank: 'PR-V017–V036 (20 vocabulary items) interleaved with the remaining PR-G items · never two same-skill items in a row · answer positions this lesson: A 19 · B 19 · C 18',
            items: prCDE,
            tip: 'Interleave rule: never two same-skill items in a row (sequence stored in the activity config, not by the renderer). Grammar items keep the docked pattern bar; conversation items show the two-face chat frame introduced at S15. The matching item uses tap-pair selection — no dragging.',
            assets: ['A1-C01-ILL013–022', 'A1-C01-AUD020–033']
          },
          {
            id: 'S19', type: 'review', label: 'Micro-progress', step: 'STEP 9',
            head: 'You can say your name!', lines: ['You can say your name!', 'You can ask a name!', 'You can ask How are you?'],
            gallery: setC.concat(setD, setE), auds: ['AUD035 — Set C', 'AUD036 — Set D', 'AUD037 — Set E'],
            next: 'Next lesson: listen and talk — a real first meeting!', rings: 3, ringsFilled: 2, flowDots: ['ask', 'answer', 'ask back'],
            tip: 'Fill the second promise ring; keep the L1-style free-play gallery (tap card → replay model). The "ask → answer → ask back" three-dot diagram animates once more. No quiz yet — the mixed quiz belongs to Lesson 4.',
            assets: ['A1-C01-AUD035–037']
          }
        ]
      },
      {
        id: 'L03', type: 'C+R', n: 3, title: 'A Real First Meeting', time: '≈20 min', pause: 'after the listening ladder (S23)',
        src: 'A1_C01_L03_LESSON.md',
        screens: [
          {
            id: 'S20', type: 'conversation', label: 'Conversation play', step: 'STEP 10',
            pkg: 'A1-C01-D01 — First Meeting at the Welcome Table',
            scenario: 'The welcome table outside the Aroa Community House, morning. Nina arrives; Maya helps at the table.',
            aud: 'AUD043', lineAud: 'AUD044', delivery: 'learning_slow_clear',
            panels: ['ILL023', 'ILL024', 'ILL025', 'ILL026', 'ILL027'],
            turns: [
              { n: 'T1', sp: 'NINA', t: 'Hi! Good morning!' },
              { n: 'T2', sp: 'MAYA', t: 'Good morning! Welcome!', tag: 'CHUNK:survival' },
              { n: 'T3', sp: 'NINA', t: 'Thank you! What\'s your name?' },
              { n: 'T4', sp: 'MAYA', t: 'My name is Maya. I\'m Maya.' },
              { n: 'T5', sp: 'NINA', t: 'Nice to meet you, Maya! I\'m Nina.' },
              { n: 'T6', sp: 'MAYA', t: 'Nice to meet you, Nina! How are you?' },
              { n: 'T7', sp: 'NINA', t: 'I\'m good, thank you! And you?' },
              { n: 'T8', sp: 'MAYA', t: 'I\'m fine! Excuse me, Nina — see you!' }
            ],
            branch: ['time branch: morning / afternoon / evening greeting (three dialogue skins)', 'state branch: five state answers — all accepted, varied across retries', 'close branch: see you / goodbye / bye; a "no time" exit adds Excuse me', 'register branch: formal My name is … vs friendly I\'m … — both always accepted'],
            lock: 'Transcript unlocks after testlet 1 is scored.',
            tip: 'Storyboard player: five panels crossfade per speaker; big play/pause; speaker chip glows per turn. Captions hidden until testlet 1 is scored (then a "show words" toggle unlocks). Free replay (unscored model). Line-mode button jumps to AUD044 per-line playback for rehearsal.',
            assets: ['A1-C01-AUD043', 'A1-C01-AUD044', 'A1-C01-ILL023–027']
          },
          {
            id: 'S21', type: 'testlet', label: 'Gist task', step: 'STEP 11 · testlet 1',
            rung: 'GIST', support: 'Storyboard visible throughout · stimulus AUD043 · items share the stimulus (dependence documented)', aud: 'AUD043', ids: 'LS001–003',
            items: ls1,
            unlock: 'Transcript unlocks here, line by line, each tappable to replay AUD044.',
            tip: 'Ladder difficulty is engineered by support, not speed tricks: S21 shows the storyboard during gist questions. Timer absent throughout; latency never scored.',
            assets: ['A1-C01-AUD043', 'A1-C01-ILL025', 'A1-C01-ILL002–004']
          },
          {
            id: 'S22', type: 'testlet', label: 'Detail task', step: 'STEP 11 · testlet 2',
            rung: 'DETAIL', support: 'Stripped to the badge icon — no storyboard · AUD046: ALEX “Hello! What\'s your name?” · NINA “My name is Nina Petrova.” · ALEX “Nice to meet you, Nina!” · NINA “Thank you!”',
            aud: 'AUD046', ids: 'LS004–007',
            items: ls2,
            unlock: 'The testlet ends with its transcript unlocking, line by line, tappable to replay AUD044.',
            tip: 'S22 strips to the badge icon. Each testlet ends with its transcript unlocking (line-by-line, tappable to replay AUD044).',
            assets: ['A1-C01-AUD046', 'A1-C01-ILL018']
          },
          {
            id: 'S23', type: 'testlet', label: 'Challenge take', step: 'STEP 11 · testlet 3',
            rung: 'RESPONSE', support: 'One play by default · one diagnostic replay, never penalized · no imagery until after the response',
            aud: 'AUD045', delivery: 'challenge_natural_slow · ≈120–130 wpm', ids: 'LS008–010 + transfer LS011–016',
            challenge: [
              { n: 'C1', sp: 'LEO', t: 'Hello! Good afternoon!' },
              { n: 'C2', sp: 'MAYA', t: 'Good afternoon! What\'s your name?' },
              { n: 'C3', sp: 'LEO', t: 'My name is Leo. I\'m Leo.' },
              { n: 'C4', sp: 'MAYA', t: 'Nice to meet you, Leo! I\'m Maya.' },
              { n: 'C5', sp: 'LEO', t: 'Nice to meet you, Maya! How are you?' },
              { n: 'C6', sp: 'MAYA', t: 'I\'m great, thank you! And you?' },
              { n: 'C7', sp: 'LEO', t: 'Not bad! Excuse me, Maya — see you!' }
            ],
            items: ls3,
            tip: 'S23 plays once by default with one diagnostic replay (never penalized) and no imagery until after the response. The six transfer/response items (LS011–016) follow the ladder on the same screen, using word and line models rather than the full take.',
            assets: ['A1-C01-AUD045', 'A1-C01-AUD044', 'A1-C01-AUD030', 'A1-C01-AUD032', 'A1-C01-ILL028']
          },
          {
            id: 'S23b', type: 'pronPerceive', label: 'Pronunciation block — stress and intonation', step: 'STEP 11 · S23b',
            items: pron23b,
            bank: 'PR-P005 · P006 · P009 — perception, ungraded, no accent scoring',
            tip: 'Arrows and the "big word" size hint are the only symbols; both were demonstrated before first use. Perception items are scored per trial and never contribute to a gate.',
            assets: ['A1-C01-AUD030', 'A1-C01-AUD044', 'A1-C01-AUD031']
          },
          {
            id: 'S24', type: 'order', label: 'Dialogue order', step: 'STEP 11b',
            demoWords: ['put in order', 'first', 'next', 'last'],
            ids: 'PR-CV003, CV004, CV015',
            tasks: cvOrder,
            tip: 'Tiles listed vertically, tapped in sequence, numbered badges appear as chosen, undo by re-tap — no dragging. All conversation items play their line via AUD044 before options appear (listen-first, then read).',
            assets: ['A1-C01-AUD044', 'A1-C01-ILL023', 'A1-C01-ILL025', 'A1-C01-ILL028']
          },
          {
            id: 'S25', type: 'practice', label: 'Best next line', step: 'STEP 11c',
            ids: 'PR-CV001, CV002, CV005–CV014',
            bank: 'the conversation bank minus the three order tasks (S24) and the echo task (S26b)',
            items: cvItems,
            tip: 'Chat-bubble stimulus with the two-face frame; options as three reply bubbles. Scene items keep their illustration; the two-blank item runs as its two authored blanks in sequence.',
            assets: ['A1-C01-AUD044', 'A1-C01-AUD002', 'A1-C01-AUD030', 'A1-C01-AUD033', 'A1-C01-ILL004', 'A1-C01-ILL007', 'A1-C01-ILL020', 'A1-C01-ILL027']
          },
          {
            id: 'S26', type: 'substitution', label: 'Substitution drill', step: 'STEP 11d',
            ids: 'A1-C01-D01 substitution table',
            slots: [
              { slot: 'Opening greeting', opts: ['Hi!', 'Hello!', 'Good morning!', 'Good afternoon!', 'Good evening!'] },
              { slot: 'Name giving', opts: ['My name is Nina Petrova.', 'I\'m Nina.'] },
              { slot: 'State answer', opts: ['I\'m good.', 'I\'m fine.', 'I\'m okay.', 'I\'m great.', 'Not bad!'] },
              { slot: 'Ask-back', opts: ['And you?'] },
              { slot: 'Polite close', opts: ['Excuse me — see you!', 'Goodbye!', 'Bye!'] }
            ],
            strip: ['fine', 'okay', 'not bad', 'good', 'great'],
            tip: 'The state strip and badge schema return; the two-column sort uses tap-in / tap-out. All cells use taught language only.',
            assets: ['A1-C01-AUD044']
          },
          {
            id: 'S26b', type: 'pronProduce', label: 'Pronunciation block — say it', step: 'STEP 11d · S26b',
            items: pron26b,
            bank: 'PR-CV016 · P007 · P008 · P010 — record, play both, compare; skip is always equal to record',
            tip: 'Model waveform + learner waveform stacked, replay for each, and a skip that is visually equal to record. Ungraded; one actionable note per record; no accent scoring anywhere.',
            assets: ['A1-C01-AUD044', 'A1-C01-AUD046', 'A1-C01-AUD038', 'A1-C01-ILL018–021']
          },
          {
            id: 'S27', type: 'reading', label: 'Badge reading', step: 'STEP 12',
            kind: 'badges', ids: 'PR-RD001–004',
            badges: [{ first: 'MAYA', last: 'HADDAD' }, { first: 'LEO', last: 'NOVAK' }],
            items: rd1,
            listenAfter: 'A "listen to it" button appears AFTER a correct response.',
            tip: 'Reading text always renders in the app layer (never inside art) with Dynamic Type to XL; badges use the ILL018 geometry so the schema transfers. RD tasks auto-play nothing by default (reading measures reading) — but a "listen to it" button appears after a correct response, linking the written word to its audio model.',
            assets: ['A1-C01-ILL029']
          },
          {
            id: 'S28', type: 'reading', label: 'Welcome card, greeting board', step: 'STEP 12b',
            kind: 'card', ids: 'PR-RD005–008',
            card: ['Welcome!', 'My name is Alex.'],
            items: rd2,
            tip: 'Same reading rules as S27 — app-layer text, no audio until after a correct response. The greeting-by-time board pairs the two scene panels with their tappable labels.',
            assets: ['A1-C01-ILL030', 'A1-C01-ILL002', 'A1-C01-ILL004', 'A1-C01-ILL018']
          },
          {
            id: 'S29', type: 'tiles', label: 'Tile writing', step: 'STEP 12c',
            ids: 'PR-WR001–002',
            tasks: [
              { id: 'PR-WR001', instr: 'Put in order.', target: 'AUD028 model · ILL019 self-introduction', tiles: ['My', 'name', 'is', 'Sam', '.'], key: ['My', 'name', 'is', 'Sam', '.'], ok: 'My name is Sam. — you wrote your first sentence!', no: 'Start with the badge word.', hints: ['Which two words sit together on the badge?', 'The dot goes last.'] },
              { id: 'PR-WR002', instr: 'Put in order.', target: 'AUD031 model · ILL021 first meeting', tiles: ['Nice', 'to', 'meet', 'you', '.'], key: ['Nice', 'to', 'meet', 'you', '.'], ok: 'Nice to meet you. — meeting words on the page!', no: 'Say it first — the order is the sound.', hints: ['Play the model and point to each tile.', 'The dot goes last.'] }
            ],
            tip: 'Tiles show capitalization and the period as real tiles (they are content here, not decoration). Correct assembly triggers the written line animating into a speech bubble above the speaker in the scene — writing instantly becomes communication. Keyboard/speech input OFF by default; the tap path is the only required path.',
            assets: ['A1-C01-ILL019', 'A1-C01-ILL021', 'A1-C01-AUD028', 'A1-C01-AUD031']
          }
        ]
      },
      {
        id: 'L04', type: 'M', n: 4, title: 'The Welcome Mission', time: '≈20 min',
        src: 'A1_C01_L04_LESSON.md',
        screens: [
          {
            id: 'S30', type: 'missionBrief', label: 'Mission brief', step: 'STEP 13',
            head: 'Your mission: go to the welcome event.',
            body: 'Maya is at the table. Say hello. Give your name. Ask Maya\'s name. Ask how she is. Close politely.',
            ill: ill('ILL023', 'Nina walks toward the welcome table where Maya waits, waving, in morning light'),
            checklist: ['greet', 'give your name', 'ask a name', 'one How are you? exchange', 'polite close'],
            entries: ['Speak', 'Tap'],
            privacy: 'Mic permission is requested here with a plain privacy notice. Voice is processed on-device where possible, deletable, and never required.',
            tip: 'Frame the mission as the story payoff, not a test: the five checklist items mirror the AUD043 dialogue beats exactly. Offer two equal entry buttons — "Speak" (mic) and "Tap" (branching fallback) — same size, same colour family; the choice is recorded for analytics but never judged.',
            assets: ['A1-C01-ILL023']
          },
          {
            id: 'S31', type: 'roleplay', label: 'AI roleplay', step: 'STEP 13b',
            spec: 'A1-C01-RP001', partner: 'Maya Haddad', turnLimit: 8,
            opener: 'Hello! Welcome! What\'s your name?',
            checklist: ['greet', 'give your name', 'ask a name', 'How are you?', 'polite close'],
            slots: ['learner_name', 'name_exchange_completed', 'one_state_exchange'],
            ceiling: 'Known-language ceiling: ledger status taught (V001–V030, G001–G003) + the survival chunk "You\'re welcome!"',
            tileGroups: [
              { g: 'greeting', t: ['Hello!', 'Hi!', 'Good morning!'] },
              { g: 'name', t: ['My name is …', 'I\'m …'] },
              { g: 'state', t: ['I\'m good, thank you!', 'Not bad!', 'And you?'] },
              { g: 'close', t: ['Thank you! See you!', 'Bye, Maya!'] }
            ],
            transcript: [
              { sp: 'MAYA', t: 'Hello! Welcome! What\'s your name?' },
              { sp: 'YOU', t: 'My name is Sam.' },
              { sp: 'MAYA', t: 'Nice to meet you, Sam! How are you?' },
              { sp: 'YOU', t: 'I\'m good, thank you! And you?' },
              { sp: 'MAYA', t: 'I\'m fine! Nice to meet you, Sam! See you!' }
            ],
            transcriptNote: 'One illustrative run, assembled from the spec\'s accepted_response_examples and the success end-condition — not an authored script.',
            feedback: { strong: ['You gave your name clearly.', 'You asked Maya\'s name.'], next: 'Try And you? after your state.' },
            redirects: ['Maya smiles: "Nice! … What\'s your name?"', 'Maya waves gently: "Excuse me! … See you!" (roleplay ends safely; retry offered)'],
            ends: ['Success: all required slots within 8 turns → Maya: "Nice to meet you, <name>! See you!" + the checklist fills', 'Safe stop: 8 turns used, two redirects used, or the learner taps stop → friendly close, partial checklist kept, retry always offered'],
            fallback: 'Non-voice branching alternative — four tile steps mirroring CV014: ① choose greeting (5 options) ② build My name is … with an editable name tile ③ choose the question to ask Maya ④ choose a close. Maya\'s replies come from the AUD044 line models.',
            tip: 'Chat-style roleplay view: Maya\'s face + speech bubble (tappable replay), learner\'s turn via mic button or tile picker. Checklist sits as a compact ribbon of five dots that fill live. Safe-stop button always visible, labeled with the loop-arrow icon. After the roleplay, the transcript is fully visible and each Maya line replays on tap.',
            assets: ['A1-C01-AUD044']
          },
          {
            id: 'S32', type: 'quizIntro', label: 'Quiz intro', step: 'STEP 14',
            head: '22 quick items', meta: ['about 7 minutes', 'you can pause any time'],
            promise: 'No streaks. Nothing is lost if you stop. You can retry as often as you like.',
            tip: 'S32 sets expectations honestly: "22 quick items · about 7 minutes · you can pause" with the pause-anywhere guarantee and no streak/loss framing.',
            assets: []
          },
          {
            id: 'S33', type: 'quiz', label: 'Quiz items', step: 'STEP 14b',
            mix: [['vocabulary', 6], ['grammar', 6], ['listening', 4], ['reading', 2], ['discourse', 2], ['guided writing', 2]],
            bank: 'Quiz Form A · 22 items · all current-chapter (the 15–25% cumulative rule activates from Chapter 2)',
            note: 'One skill per screen-swap; no section headers that reveal the skill mix; item order interleaved (V-G-LS-V-CN-G-…). Listening items: single default replay; transcript unlocks only for review AFTER the whole quiz.',
            items: quiz,
            tip: 'S33 renders one item per screen-swap, interleaved skills, correct-position rotation, no section reveals. A quiet progress bar (no countdown). VoiceOver: prompt → options in listed order; tile tasks number each tile as tapped.',
            assets: ['A1-C01-AUD047', 'A1-C01-ILL031–034', 'A1-C01-AUD043', 'A1-C01-AUD045']
          },
          {
            id: 'S34a', type: 'tiles', label: 'Guided writing — consolidation', step: 'STEP 15 · S34a',
            ids: 'PR-WR003–006',
            tasks: wr34,
            tip: 'Runs before the results summary as calm-down consolidation. All tile interactions are tap-sequence; Dynamic Type throughout; nothing here feeds the gate.',
            assets: ['A1-C01-ILL030', 'A1-C01-ILL033', 'A1-C01-ILL019', 'A1-C01-AUD029']
          },
          {
            id: 'S34', type: 'results', label: 'Results', step: 'STEP 15',
            rings: ['greet', 'thank', 'name', 'ask', 'state'],
            strong: 'You can greet, give your name, and say how you are.',
            developing: 'Morning and evening greetings are close — the sun pictures help.',
            next: 'the four-minute sun-and-sky review, then Chapter 2!',
            score: 'Pass is ≥18 / 22', gate: 'Pass: ≥80% overall and no core section below 70% (vocabulary ≥5/6 · grammar ≥5/6 · listening ≥3/4 · discourse 2/2). Near-pass routes to a clinic plus Form B. Unlimited retries with parallel content. No permanent lock. Mission completion — voice or tap — is required alongside the quiz for the chapter badge.',
            tip: 'Show the five can-do rings from S01 filling, strengths first, one developing area max, one next step. No percentages-as-judgment; the number is available behind a tap for interested learners. Retry and continue buttons are equally weighted visually — no dark pattern.',
            assets: []
          },
          {
            id: 'S35', type: 'remediation', label: 'Remediation pick', step: 'STEP 15b',
            head: 'Practice picks', sub: 'Take one, take all, or skip. The schedule adapts either way.',
            clinics: [
              { id: 'C1-CLIN-A', name: 'sun-and-sky', benefit: 'Tell morning, afternoon and evening apart.', n: 8, trigger: 'any 2 errors in time greetings' },
              { id: 'C1-CLIN-B', name: 'whose-badge', benefit: 'my name or your name — point at the right badge.', n: 8, trigger: '≥2 direction errors' },
              { id: 'C1-CLIN-C', name: 'self-or-other', benefit: 'I\'m or you\'re, without thinking.', n: 6, trigger: '≥2 person errors' },
              { id: 'C1-CLIN-D', name: 'name-or-feeling', benefit: 'Match the answer to the question.', n: 8, trigger: '≥2 chunk-swap errors' },
              { id: 'C1-CLIN-E', name: 'names-and-feelings', benefit: 'Catch names and states in fast speech.', n: 6, trigger: '≥2 listening errors' }
            ],
            pending: 'Clinic items are specified but not yet authored — they activate on first learner need or on owner request.',
            tip: 'Remediation is offered as "practice picks" with icon + one-line benefit — never a red failure screen. The learner may skip everything; the schedule adapts either way.',
            assets: []
          },
          {
            id: 'S36', type: 'reviewPlan', label: 'Review plan', step: 'STEP 15c',
            head: 'Your review week', sub: 'Short returns, spaced out. Notifications stay off unless you turn them on.',
            week: [{ d: 'Tue', t: 'Sets A + B', on: true }, { d: 'Wed', t: '', on: false }, { d: 'Thu', t: 'Names + states', on: true }, { d: 'Fri', t: '', on: false }, { d: 'Sat', t: 'The first meeting', on: true }, { d: 'Sun', t: '', on: false }, { d: 'Mon', t: 'Chapter 2 warm-up', on: true }],
            exports: [['Set A greetings/farewells', 'Ch2 warm-ups, Ch4 retrieval 1, Checkpoint 1'], ['Set B politeness', 'Ch2 check-in conversation, Ch4, Ch9/10 service language'], ['Set C states', 'Ch2 warm-up, Ch4, Ch11 plans'], ['Set D identity/chunks', 'Ch2 spelling/forms, Ch3 profiles, Checkpoint 1'], ['Set E state questions', 'Ch4, Ch11 invitations'], ['G001–G003', 'Ch2 Are you…?, Ch3 full be paradigm']],
            tip: 'S36 shows the review plan as a calm week-strip (no streak shaming; optional notifications off by default).',
            assets: []
          },
          {
            id: 'S37', type: 'chapterMap', label: 'Chapter map / next', step: 'Wrap-up',
            head: 'Chapter 1 complete!',
            body: 'You can say hello, give your name, ask how someone is, and close politely — in a real first meeting.',
            next: 'Chapter 2 — Spell It and Share Your Details.',
            arc: 'Meet and connect', chapters: [{ n: 1, t: 'Hello! My Name Is Alex', s: 'done' }, { n: 2, t: 'Spell It and Share Your Details', s: 'next' }, { n: 3, t: 'Where Are You From?', s: 'locked' }, { n: 4, t: 'Checkpoint Review 1', s: 'locked' }],
            tip: 'S37 is the celebration peak: brief (≤3 s), mutable, reduced-motion safe; the chapter map shows Arc 1 (Chapters 1–4) with Chapter 1 filled — story progress, not point totals.',
            assets: []
          }
        ]
      }
    ]
  });
})();
