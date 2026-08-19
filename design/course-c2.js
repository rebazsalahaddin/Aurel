/* A1-C02 — "Spell It and Share Your Details". Screen inventory S01–S39 (+ the
   S25b/S31b pronunciation blocks, the S28b message-card reading and the S36a
   writing block named in the lesson files).
   Every string is transcribed from english_course/04_A1_chapters/A1_C02/*.
   Complete banks: vocabulary 36 (20 L1 + 16 L2) · grammar 30 · conversation 16 ·
   listening 16 · pronunciation 10 · reading 8 · guided writing 6 = 122 items +
   quiz Form A (26, of which 4 cumulative from Chapter 1). Multi-blank, matching and
   tap-sequence records are decomposed into the steps the renderer shows and keep
   their source ids. */
(function () {
  var C = (window.AUREL_COURSE = window.AUREL_COURSE || { chapters: [] });
  var __guard = C.chapters.some(function (x) { return x.id === 'A1-C02'; });
  if (__guard) return;
  var ill = function (id, alt) { return { id: 'A1-C02-' + id, alt: alt }; };

  var families = [
    { n: 1, letters: ['A', 'B', 'C', 'D', 'E', 'F'], aud: 'AUD011' },
    { n: 2, letters: ['G', 'H', 'I', 'J', 'K', 'L', 'M'], aud: 'AUD012' },
    { n: 3, letters: ['N', 'O', 'P', 'Q', 'R', 'S', 'T'], aud: 'AUD013' },
    { n: 4, letters: ['U', 'V', 'W', 'X', 'Y', 'Z'], aud: 'AUD014' }
  ];
  var letterNames = { A: '/eɪ/', B: '/biː/', C: '/siː/', D: '/diː/', E: '/iː/', F: '/ɛf/', G: '/dʒiː/', H: '/eɪtʃ/', I: '/aɪ/', J: '/dʒeɪ/', K: '/keɪ/', L: '/ɛl/', M: '/ɛm/', N: '/ɛn/', O: '/oʊ/', P: '/piː/', Q: '/kjuː/', R: '/ɑːr/', S: '/ɛs/', T: '/tiː/', U: '/juː/', V: '/viː/', W: '/ˈdʌbəljuː/', X: '/ɛks/', Y: '/waɪ/', Z: '/ziː/' };

  var nums05 = [
    { d: '0', w: 'zero', ipa: '/ˈzɪroʊ/', ill: ill('ILL004', 'An empty table — no cups at all') },
    { d: '1', w: 'one', ipa: '/wʌn/', ill: ill('ILL005', 'One cup stands alone on the table') },
    { d: '2', w: 'two', ipa: '/tuː/', ill: ill('ILL006', 'Two cups side by side on the same table') },
    { d: '3', w: 'three', ipa: '/θriː/', ill: ill('ILL007', 'Three cups in a row on the table') },
    { d: '4', w: 'four', ipa: '/fɔːr/', ill: ill('ILL008', 'Four pencils stand in a jar on the desk') },
    { d: '5', w: 'five', ipa: '/faɪv/', ill: ill('ILL009', 'Nina holds up one open hand, all five fingers raised, counting five cups') }
  ];
  var num = function (d, w, ipa) { return { d: d, w: w, ipa: ipa }; };
  var nums610 = [num('6', 'six', '/sɪks/'), num('7', 'seven', '/ˈsɛvən/'), num('8', 'eight', '/eɪt/'), num('9', 'nine', '/naɪn/'), num('10', 'ten', '/tɛn/')];
  var nums1115 = [num('11', 'eleven', '/ɪˈlɛvən/'), num('12', 'twelve', '/twɛlv/'), num('13', 'thirteen', '/ˌθɜːrˈtiːn/'), num('14', 'fourteen', '/ˌfɔːrˈtiːn/'), num('15', 'fifteen', '/ˌfɪfˈtiːn/')];
  var nums1620 = [num('16', 'sixteen', '/ˌsɪksˈtiːn/'), num('17', 'seventeen', '/ˌsɛvənˈtiːn/'), num('18', 'eighteen', '/ˌeɪˈtiːn/'), num('19', 'nineteen', '/ˌnaɪnˈtiːn/'), num('20', 'twenty', '/ˈtwɛnti/')];

  var repairCards = [
    { id: 'V001', w: 'spell', ipa: '/spel/', aud: 'AUD002', fn: 'action word — say or write letter by letter', ill: ill('ILL010', 'Nina points at four blank letter tiles one by one above a name badge while Maya holds it'), moment: 'Nina points at blank letter tiles one by one over Maya\'s badge' },
    { id: 'V002', w: 'repeat', ipa: '/rɪˈpiːt/', aud: 'AUD003', fn: 'action word — say it again', ill: ill('ILL011', 'Sound dots travel from a speaker to a listener, then echo back in a second row'), moment: 'Nina says "Maya" — sound dots travel to you, then travel back' },
    { id: 'V003', w: 'slow', ipa: '/sloʊ/', aud: 'AUD004', fn: 'describing word — not fast', ill: ill('ILL012', 'Three sound dots sit widely spaced between two people'), moment: 'Nina speaks; three dots sit WIDELY spaced between you' },
    { id: 'V004', w: 'again', ipa: '/əˈɡɛn/', aud: 'AUD005', fn: 'one more time', ill: ill('ILL013', 'A loop arrow circles a play triangle'), moment: 'Loop arrow circles the play triangle' },
    { id: 'V005', w: 'listen', ipa: '/ˈlɪsən/', aud: 'AUD006', fn: 'class action word (now learner content)', icon: 'ear', moment: 'Ear icon + Nina speaking' },
    { id: 'V006', w: 'say', ipa: '/seɪ/', aud: 'AUD007', fn: 'class action word (now learner content)', icon: 'mouth', moment: 'Mouth icon + your turn' },
    { id: 'V007', w: 'How do you spell that?', ipa: '/ˈhaʊ də jə ˈspɛl ðæt/', aud: 'AUD008', fn: 'repair chunk — the chapter question', chunk: true, ill: ill('ILL010', 'Nina tilts her head at the badge, pen ready'), moment: 'Nina tilts her head at the badge, pen ready' },
    { id: 'V008', w: 'Can you repeat that, please?', ipa: '/kən jə rɪˈpiːt ðæt pliːz/', aud: 'AUD009', fn: 'repair chunk — ask for it again', chunk: true, ill: ill('ILL014', 'A listener cups one hand at their ear while Nina leans in kindly'), moment: 'Your hand cups your ear; Nina leans in kindly' },
    { id: 'V009', w: 'Please speak slowly', ipa: '/pliːz ˈspiːk ˈsloʊli/', aud: 'AUD010', fn: 'repair chunk — ask for slower speech', chunk: true, ill: ill('ILL012', 'The sound dots stretch wide apart again'), moment: 'Dots stretch wide again' }
  ];

  var contact = [
    { id: 'V010', w: 'phone', ipa: '/foʊn/', aud: 'AUD046', fn: 'noun — the thing you call with', ill: ill('ILL016', 'A simple phone lies on the register page beside Nina\'s pen') },
    { id: 'V011', w: 'phone number', ipa: '/ˈfoʊn ˌnʌmbər/', aud: 'AUD047', fn: 'noun chunk — the digits row', ill: ill('ILL024', 'The register page: a name row, a digits row and a message row') },
    { id: 'V012', w: 'email', ipa: '/ˈiːmeɪl/', aud: 'AUD048', fn: 'noun — the message you send', ill: ill('ILL018', 'A small envelope shape resting on the message row of the register') },
    { id: 'V013', w: 'email address', ipa: '/ˈiːmeɪl ˌædrɛs/', aud: 'AUD049', fn: 'noun chunk — the message row', ill: ill('ILL024', 'The message row of the register page, waiting to be filled') },
    { id: 'V014', w: 'address', ipa: '/ˈædrɛs/', aud: 'AUD050', fn: 'noun — where something is sent', ill: ill('ILL019', 'A door with a small plate beside it, no letters shown') },
    { id: 'V015', w: 'at', ipa: '/æt/', aud: 'AUD051', fn: 'email symbol word (@)', symbol: '@', ill: ill('ILL020', 'A round looping mark drawn on the message row') },
    { id: 'V016', w: 'dot', ipa: '/dɑːt/', aud: 'AUD052', fn: 'email symbol word (.)', symbol: '.', ill: ill('ILL021', 'A single small round mark on the message row') },
    { id: 'V017', w: 'What\'s your phone number?', ipa: '/wʌts jʊr ˈfoʊn ˌnʌmbər/', aud: 'AUD053', fn: 'detail question chunk', chunk: true, ill: ill('ILL022', 'Nina moves her pen to the digits row and looks up') },
    { id: 'V018', w: 'What\'s your email address?', ipa: '/wʌts jʊr ˈiːmeɪl ˌædrɛs/', aud: 'AUD054', fn: 'detail question chunk', chunk: true, ill: ill('ILL023', 'Nina moves her pen to the message row and looks up') }
  ];

  /* ---------- L01 practice ---------- */
  var prLetters = [
    { id: 'PR-V001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD017', big: true, opts: [{ id: 'A', t: 'E' }, { id: 'B', t: 'A' }, { id: 'C', t: 'K' }], key: 'A', ok: 'Yes — E!', no: 'Listen again — the name is long /iː/.', hints: ['Play again and watch the chart — three letters light up.', 'A and K rhyme (ay, kay). The answer is the /iː/ letter.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-V002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD019', big: true, opts: [{ id: 'A', t: 'L' }, { id: 'B', t: 'M' }, { id: 'C', t: 'T' }], key: 'B', ok: 'Yes — M!', no: 'Listen for the last sound: e-mmm.', hints: ['Play again; say the three letter names with the audio.', 'The answer ends in m-m-m.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-V003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD022', big: true, opts: [{ id: 'A', t: 'M' }, { id: 'B', t: 'R' }, { id: 'C', t: 'S' }], key: 'C', ok: 'Yes — S!', no: 'The name ends in s-s-s.', hints: ['Play again; feel the last sound of each name.', 'One name ends like the first sound of \u2018sorry\u2019 — a taught word.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-V004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD015', big: true, confusable: 'all three end in long /iː/ — the first sound decides', opts: [{ id: 'A', t: 'B' }, { id: 'B', t: 'D' }, { id: 'C', t: 'E' }], key: 'A', ok: 'Yes — B! First sound b.', no: 'All three end in /iː/. Listen to the FIRST sound.', hints: ['Play again — hold the first sound: b-b-bee.', 'Say bee, dee, ee with the audio; tap the b-one.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-V005', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD021', big: true, opts: [{ id: 'A', t: 'I' }, { id: 'B', t: 'R' }, { id: 'C', t: 'A' }], key: 'B', ok: 'Yes — R!', no: 'The name opens wide and curls at the end: ahr.', hints: ['Play again; two of the options rhyme — A and I.', 'The name opens wide and curls at the end: ahr. Tap R.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-V006', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD018', big: true, opts: [{ id: 'A', t: 'A' }, { id: 'B', t: 'J' }, { id: 'C', t: 'H' }], key: 'C', ok: 'Yes — H!', no: 'A and J rhyme. The name ends in ch-ch.', hints: ['Play again — hold the ending.', 'The letter in \u2018hello\u2019 and \u2018hi\u2019 — the h-one.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-V007', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD016', big: true, confusable: 'the classic GA pair — B vs D, with P keeping the long-e family honest', opts: [{ id: 'A', t: 'B' }, { id: 'B', t: 'D' }, { id: 'C', t: 'P' }], key: 'B', ok: 'Yes — D! Your voice starts at once: d-d-dee.', no: 'All three end /iː/. B starts smooth and voiced; P starts with air; D starts with a d-touch.', hints: ['Put a hand on your throat; play it again — voice at the start = D or B, air = P.', 'Say dee — the tip of your tongue touches. That is D.'], secs: 25, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route', 'tactile_hint_optional'] },
    { id: 'PR-V008', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD020', big: true, confusable: 'M/N differ only in the final nasal sound', opts: [{ id: 'A', t: 'F' }, { id: 'B', t: 'N' }, { id: 'C', t: 'M' }], key: 'B', ok: 'Yes — N! The nose sound sits high: e-nnn.', no: 'M hums on the lips; N hums behind the teeth.', hints: ['Play again; touch your lips — if they close, it is M.', 'Say \u2018no\u2019 — it starts with this letter\'s sound.'], secs: 25, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route', 'tactile_hint_optional'] },
    { id: 'PR-V009', instr: 'Listen. Say.', icon: 'mouth', kind: 'speak', aud: 'AUD028', word: 'M · A · Y · A', ok: 'Maya! M, A, Y, A — perfect.', no: 'Try again — four letters: M, A, Y, A. Say them with Nina.', hints: ['Listen once more; echo each letter as it comes.', 'The chart shows M-A-Y-A glowing — say the four names.'], secs: 30, a11y: ['non_voice_alternative_tap_letters', 'replay_allowed_once', 'audio_required_transcript_after_response'] }
  ];

  var prNumWords = [
    { id: 'PR-V010', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD023', big: true, opts: [{ id: 'A', t: '2' }, { id: 'B', t: '3' }, { id: 'C', t: '4' }], key: 'A', ok: 'Yes — two!', no: 'Two ends in oooo — like \u2018you\u2019 without y.', hints: ['Play again and hold the ending.', 'The word rhymes with \u2018you\u2019 — tap its digit.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_digit_strip_route'] },
    { id: 'PR-V011', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD024', big: true, confusable: 'three /θ/ against two /t/ and four /f/', opts: [{ id: 'A', t: '2' }, { id: 'B', t: '3' }, { id: 'C', t: '4' }], key: 'B', ok: 'Yes — three! Tongue between the teeth: th-ree.', no: 'three starts with a soft th — air over the tongue.', hints: ['Play again; the first sound is not t and not f.', 'It is the count after two — three.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_digit_strip_route'] },
    { id: 'PR-V012', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD025', big: true, opts: [{ id: 'A', t: '5' }, { id: 'B', t: '4' }, { id: 'C', t: '3' }], key: 'A', ok: 'Yes — five!', no: 'Both f-words start alike; five ends in -ive, a tall /aɪ/.', hints: ['Play again; hold the middle of the word.', 'four is round (or); five is tall (eye).'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V013', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD026', big: true, opts: [{ id: 'A', t: '4' }, { id: 'B', t: '2' }, { id: 'C', t: '0' }], key: 'C', ok: 'Yes — zero! Two beats: ze-ro. No things.', no: 'Zero has two beats — the others have one.', hints: ['Play again and tap the table once per beat.', 'The two-beat word means no things at all.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V014', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL008', 'Four pencils stand in a jar on the desk'), opts: [{ id: 'A', t: '3' }, { id: 'B', t: '4' }, { id: 'C', t: '5' }], key: 'B', ok: 'Yes — four pencils!', no: 'Tap the picture: the pencils light up one by one. Count with the taps.', hints: ['Tap the picture — each pencil pulses in turn.', 'Count the pulses: one, two, three, four.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'tap_to_count_support', 'no_color_only_meaning'] },
    { id: 'PR-V015', instr: 'Look. Choose.', icon: 'eye', prompt: 'three', big: true, opts: [{ id: 'A', t: '2' }, { id: 'B', t: '4' }, { id: 'C', t: '3' }], key: 'C', ok: 'Yes — three = 3.', no: 'Look at the first letters: th- points to three.', hints: ['The word starts with th — the soft th number.', 'Say the word to yourself; now tap its digit.'], secs: 15, a11y: ['voiceover_reads_word', 'visual_only_construct'] },
    { id: 'PR-V016', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL010', 'Blank letter tiles above a name badge'), prompt: 'M, A, Y, A — letter by letter.', opts: [{ id: 'A', t: 'spell' }, { id: 'B', t: 'say' }, { id: 'C', t: 'listen' }], key: 'A', ok: 'Yes — spell: M, A, Y, A.', no: 'Letter by letter has its own word: spell.', hints: ['Look at the tiles — one letter at a time.', 'The word for letter-by-letter starts with sp-.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V017', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL013', 'A loop arrow circles a play triangle'), prompt: 'You want it one more time.', opts: [{ id: 'A', t: 'again' }, { id: 'B', t: 'slow' }, { id: 'C', t: 'spell' }], key: 'A', ok: 'Yes — again! One more time.', no: 'The loop arrow goes around: one more time = again.', hints: ['Look at the loop arrow in the picture.', 'In class you hear: \u2018Again!\u2019 — one more time.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V018', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL012', 'Three sound dots sit widely spaced between two people'), prompt: 'The words are very fast. You want ___ words.', opts: [{ id: 'A', t: 'spell' }, { id: 'B', t: 'again' }, { id: 'C', t: 'slow' }], key: 'C', ok: 'Yes — slow words. Nice and slow.', no: 'The dots sit far apart — space between the words: slow.', hints: ['Look at the space between the dots.', 'The opposite of fast is… slow.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V019', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL014', 'A listener cups one hand at their ear while Nina leans in kindly'), scene: 'Nina says her name one time, fast. You do not hear it.', opts: [{ id: 'A', t: 'Please speak slowly.' }, { id: 'B', t: 'How do you spell that?' }, { id: 'C', t: 'Can you repeat that, please?' }], key: 'C', ok: 'Yes! Ask to hear it again.', no: 'You did not hear the name — ask for it one more time.', hints: ['What do you need: the letters, the speed, or one more time?', 'The hand is behind the ear — you want it again.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-V020', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL010', 'Nina tilts her head at the badge, pen ready'), scene: 'You hear the name — “Maya.” — and you want to write it on the badge.', opts: [{ id: 'A', t: 'Can you repeat that, please?' }, { id: 'B', t: 'How do you spell that?' }, { id: 'C', t: 'Please speak slowly.' }], key: 'B', ok: 'Yes! The letters, please: How do you spell that?', no: 'You want to WRITE it — ask for the letters.', hints: ['The pen is over the badge — what does the pen need?', 'Letter by letter: the spell question.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] }
  ];

  /* ---------- L02 practice ---------- */
  var prVocab2 = [
    { id: 'PR-V021', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD034', big: true, opts: [{ id: 'A', t: '6' }, { id: 'B', t: '7' }, { id: 'C', t: '8' }], key: 'B', ok: 'Yes — seven!', no: 'Seven has two beats and ends in -en.', hints: ['Play again; hold the ending: se-venn.', 'Two beats, ends like eleven\'s ending.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'PR-V022', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD038', big: true, confusable: 'seven (2 beats) vs eleven (3 beats)', opts: [{ id: 'A', t: '7' }, { id: 'B', t: '11' }, { id: 'C', t: '10' }], key: 'B', ok: 'Yes — eleven! e-LE-ven.', no: 'Count the beats: se-ven (2) … e-le-ven (3).', hints: ['Play again; tap a beat per syllable.', 'The three-beat word starts with a little e-.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'PR-V023', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD043', big: true, confusable: 'six vs sixteen — the first part returns', opts: [{ id: 'A', t: '6' }, { id: 'B', t: '16' }, { id: 'C', t: '15' }], key: 'B', ok: 'Yes — sixteen! Six comes back.', no: 'The first part is six- and the word is long: six-TEEN.', hints: ['Play again; is the word short or long?', 'Long word starting with six → sixteen.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'PR-V024', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD047', big: true, confusable: 'two · twelve · twenty all start tw-', opts: [{ id: 'A', t: '2' }, { id: 'B', t: '12' }, { id: 'C', t: '20' }], key: 'C', ok: 'Yes — twenty! TWEN-ty.', no: 'All start with tw-. Twenty is two beats and ends in -ty… -ee.', hints: ['Play again; tap the beats.', 'Two beats, starts TWEN-: twenty.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'PR-V025', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL016', 'Seven cups stand on a tray beside the register page'), opts: [{ id: 'A', t: '6' }, { id: 'B', t: '7' }, { id: 'C', t: '8' }], key: 'B', ok: 'Yes — seven cups!', no: 'Tap the tray — the cups pulse one by one. Count the pulses.', hints: ['Tap the picture; count the pulses.', 'Six… and one more: seven.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'tap_to_count_support'] },
    { id: 'PR-V026', instr: 'Look. Choose.', icon: 'eye', prompt: 'thirteen', big: true, opts: [{ id: 'A', t: '3' }, { id: 'B', t: '13' }, { id: 'C', t: '12' }], key: 'B', ok: 'Yes — thirteen = 13.', no: 'Look for the three hiding inside: thir-TEEN.', hints: ['The word starts th-, like three.', 'Three + ten → thirteen → 13.'], secs: 15, a11y: ['voiceover_reads_word', 'visual_only_construct'] },
    { id: 'PR-V027', instr: 'Look. Choose.', icon: 'eye', prompt: 'twenty', big: true, opts: [{ id: 'A', t: '10' }, { id: 'B', t: '12' }, { id: 'C', t: '20' }], key: 'C', ok: 'Yes — twenty = 20.', no: 'tw- is the two-family: twen-ty → 20.', hints: ['The word starts tw-, like two.', 'The big round ten-and-ten word: twenty.'], secs: 15, a11y: ['voiceover_reads_word', 'visual_only_construct'] },
    { id: 'PR-V028', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL018', 'A phone beside the register\'s digits row'), prompt: 'You call Maya. You need her ___.', opts: [{ id: 'A', t: 'email address' }, { id: 'B', t: 'phone number' }, { id: 'C', t: 'slow' }], key: 'B', ok: 'Yes — her phone number!', no: 'Calling needs the digits: the phone number.', hints: ['Look at the phone in the picture.', 'What do you tap into a phone? Digits.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-V029', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL019', 'An envelope shape flying toward a laptop'), prompt: 'A message for Maya, on the computer: an ___.', opts: [{ id: 'A', t: 'address' }, { id: 'B', t: 'email' }, { id: 'C', t: 'again' }], key: 'B', ok: 'Yes — an email!', no: 'The envelope-to-laptop picture: the message is an email.', hints: ['Look at the envelope in the picture.', 'E-lectronic letter: e-mail.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-V030', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL020', 'A house with a small blank plaque beside the door'), prompt: 'Where is your home? Your ___, please.', opts: [{ id: 'A', t: 'name' }, { id: 'B', t: 'phone' }, { id: 'C', t: 'address' }], key: 'C', ok: 'Yes — your address!', no: 'The house picture: where you live is your address.', hints: ['Look at the house and its blank plaque.', 'Home place = address.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-V031', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD061', prompt: 'maya dot haddad ___ aroa dot com', opts: [{ id: 'A', t: 'dot' }, { id: 'B', t: 'at' }, { id: 'C', t: 'again' }], key: 'B', ok: 'Yes — at! Person AT place.', no: 'The big break takes at; the small stops take dot.', hints: ['Play again; hum along — where does the voice jump biggest?', 'maya dot haddad … AT … aroa dot com.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V032', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL022', 'A single small round mark between two name parts'), prompt: 'maya ___ haddad', opts: [{ id: 'A', t: 'spell' }, { id: 'B', t: 'at' }, { id: 'C', t: 'dot' }], key: 'C', ok: 'Yes — dot! maya DOT haddad.', no: 'Small round stop between parts = dot.', hints: ['Look at the round dot in the picture.', 'maya • haddad — say it with the dot.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-V033', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL024', 'Nina\'s pen circles the digits row of the register; she looks up'), opts: [{ id: 'A', t: 'What\'s your name?' }, { id: 'B', t: 'What\'s your phone number?' }, { id: 'C', t: 'How do you spell that?' }], key: 'B', ok: 'Yes! What\'s your phone number?', no: 'Follow the pen — it is on the numbers row.', hints: ['Look where the pen circles.', 'Digits row → the phone-number question.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-V034', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL024', 'Nina\'s pen circles the email line of the register; she looks up'), opts: [{ id: 'A', t: 'Can you repeat that, please?' }, { id: 'B', t: 'What\'s your phone number?' }, { id: 'C', t: 'What\'s your email address?' }], key: 'C', ok: 'Yes! What\'s your email address?', no: 'The pen is on the message row.', hints: ['Look where the pen circles.', 'Message row → the email question.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-V035', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD066', scene: 'Leo says his phone number ONE time, fast.', opts: [{ id: 'A', t: 'How do you spell that?' }, { id: 'B', t: 'Please speak slowly.' }, { id: 'C', t: 'Can you repeat that, please?' }], key: 'C', ok: 'Yes! Ask for it again.', no: 'The number flew by — ask to hear it one more time.', hints: ['Did you catch ANY of the digits? No → again.', 'The repeat question.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-V036', instr: 'Look. Choose.', icon: 'choose', prompt: 'Nina says \u2018Maya.\u2019 Your job: the same word after her.', opts: [{ id: 'A', t: 'Twenty!' }, { id: 'B', t: 'Sorry!' }, { id: 'C', t: 'Repeat!' }], key: 'C', ok: 'Yes — Repeat!', no: 'Her word, then your word: repeat.', hints: ['What is the echo word from Lesson 1?', 'The loop-arrow word: repeat.'], secs: 15, a11y: ['situation_frame_narrated'] }
  ];

  var prG2 = [
    { id: 'PR-G001', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL023', 'Nina checks the badge, pen ready'), prompt: '___ you Maya?', opts: [{ id: 'A', t: 'I\'m' }, { id: 'B', t: 'You\'re' }, { id: 'C', t: 'Are' }], key: 'C', ok: 'Yes — Are you Maya?', no: 'Checking goes the other way: Are you…?', hints: ['The checking word comes FIRST.', 'Are — then you.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-G002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD060', prompt: 'NINA (to YOU): “Are you Nina?”', opts: [{ id: 'A', t: 'Yes, I am.' }, { id: 'B', t: 'No, I\'m not!' }, { id: 'C', t: 'I\'m Maya.' }], key: 'B', ok: 'Yes — No, I\'m not! (Nina is Nina.)', no: 'Are you Nina? No! Say it: No, I\'m not.', hints: ['Listen again — who is Nina?', 'You are YOU → the no answer.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-G003', instr: 'Look. Choose.', icon: 'choose', prompt: 'Are you okay? — You say: ___', opts: [{ id: 'A', t: 'No, I are.' }, { id: 'B', t: 'Yes, I\'m.' }, { id: 'C', t: 'Yes, I am.' }], key: 'C', ok: 'Yes — I am okay: Yes, I am!', no: 'Finish the short answer: Yes, I AM.', hints: ['Say it slowly: Yes … I … am.', 'The little word at the end is am.'], secs: 15, a11y: ['malformed_option_feedback_explained'] },
    { id: 'PR-G004', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['you', 'Are', 'Maya', '?'], key: ['Are', 'you', 'Maya', '?'], ok: 'Are you Maya? — perfect question order.', no: 'Start with the checking word: Are.', hints: ['Which word asks? Start there.', 'Are → you → Maya → ?'], secs: 25, a11y: ['tap_only_no_drag', 'order_mechanics_demonstrated'] },
    { id: 'PR-G005', instr: 'Look. Choose.', icon: 'choose', prompt: 'Which one asks?', opts: [{ id: 'A', t: 'You are Maya.' }, { id: 'B', t: 'Are you Maya?' }, { id: 'C', t: 'You Maya are.' }], key: 'B', ok: 'Yes — Are you Maya? asks.', no: 'The question puts Are first.', hints: ['Read both aloud — which one checks?', 'Are-first is the asker.'], secs: 15, a11y: ['voiceover_reads_options'] },
    { id: 'PR-G006', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD060', opts: [{ id: 'A', t: 'Are Maya you?' }, { id: 'B', t: 'You are Maya?' }, { id: 'C', t: 'Are you Maya?' }], key: 'C', ok: 'Yes — that is the checking question.', no: 'Listen for the FIRST word: Are.', hints: ['Play again; catch word one.', 'Are… you… Maya.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-G007', instr: 'Look. Choose.', icon: 'choose', prompt: 'A new person waves. Nina asks: Are you ___?', opts: [{ id: 'A', t: 'I\'m' }, { id: 'B', t: 'okay' }, { id: 'C', t: 'Sam' }], key: 'C', ok: 'Yes — Are you Sam?', no: 'New face → check the name: Are you Sam?', hints: ['What does Nina not know about a new face?', 'The name: Sam.'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G008', instr: 'Look. Choose.', icon: 'choose', prompt: 'Nina asks: “Are you Sam Rivera?” You say: ___', opts: [{ id: 'A', t: 'Sorry!' }, { id: 'B', t: 'Yes, I am.' }, { id: 'C', t: 'No, I\'m not!' }], key: 'C', ok: 'Yes — No, I\'m not! Sam is Sam.', no: 'The badge is Sam\'s, not yours — answer with the no-answer.', hints: ['Whose name is on the badge?', 'Not yours → No, I\'m not!'], secs: 20, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G009', instr: 'Look. Choose.', icon: 'choose', prompt: 'NINA: “Are you Maya?” … MAYA: “___”', opts: [{ id: 'A', t: 'Yes, am I!' }, { id: 'B', t: 'Yes, I are!' }, { id: 'C', t: 'Yes, I am!' }], key: 'C', ok: 'Yes, I am! — Maya\'s line.', no: 'The yes-answer is Yes, I am — in that order.', hints: ['Say the two short answers from the model.', 'The yes one: Yes, I am.'], secs: 15, a11y: ['malformed_option_feedback_explained'] },
    { id: 'PR-G010', instr: 'Look. Choose the correct line.', icon: 'choose', prompt: 'Nina asks: “Are you Leo?” — Leo says: “Yes, I are.” Choose the fix:', opts: [{ id: 'A', t: 'Yes, you are I.' }, { id: 'B', t: 'Yes, I is.' }, { id: 'C', t: 'Yes, I am.' }], key: 'C', ok: 'Yes, I am — fixed!', no: 'I\'s word is am. Try the fix again.', hints: ['I am… you are… — which one fits Leo?', 'Swap the last word: am.'], secs: 15, a11y: ['malformed_option_feedback_explained'] },
    { id: 'PR-G011', instr: 'Look. Choose.', icon: 'choose', prompt: 'Nina points at the letter M. She says: ___ M!', opts: [{ id: 'A', t: 'You\'re' }, { id: 'B', t: 'I\'m' }, { id: 'C', t: 'It\'s' }], key: 'C', ok: 'Yes — It\'s M!', no: 'Not a person — the letter takes It\'s.', hints: ['Is M a person or a thing?', 'Things take It\'s.'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G012', instr: 'Look. Choose.', icon: 'choose', prompt: 'NINA: “What\'s your phone number?” … YOU: “___ 5-5-5, 2-0-1.”', opts: [{ id: 'A', t: 'It\'s' }, { id: 'B', t: 'I\'m' }, { id: 'C', t: 'You\'re' }], key: 'A', ok: 'Yes — It\'s 5-5-5, 2-0-1.', no: 'Numbers are things: It\'s.', hints: ['Person or detail?', 'Details: It\'s.'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G013', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD016', opts: [{ id: 'A', t: 'It\'s D!' }, { id: 'B', t: 'It\'s B!' }, { id: 'C', t: 'It\'s E!' }], key: 'A', ok: 'Yes — It\'s D!', no: 'The d-start letter: D.', hints: ['Play again; hold the first sound.', 'dee → D.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-G014', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['It', 'is'], key: ['It', 'is'], note: 'Authored as a tile-merge: the two tiles snap together and the little mark appears.', ok: 'It + is = It\'s. The little mark appears!', no: 'Push the two tiles together — the mark joins them.', hints: ['Say them fast: It is… It\'s.', 'The tiles snap together.'], secs: 20, a11y: ['tap_only_no_drag'] },
    { id: 'PR-G015', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD047', opts: [{ id: 'A', t: 'It\'s twenty!' }, { id: 'B', t: 'It\'s twelve!' }, { id: 'C', t: 'It\'s two!' }], key: 'A', ok: 'Yes — It\'s twenty!', no: 'Two beats, TWEN- first: twenty.', hints: ['Tap the beats with the audio.', 'The two-beat tw- word.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-G016', instr: 'Look. Choose.', icon: 'choose', prompt: 'NINA: “What\'s your email address?” — Which line answers?', opts: [{ id: 'A', t: 'It\'s maya dot haddad at aroa dot com.' }, { id: 'B', t: 'I\'m Maya.' }, { id: 'C', t: 'Yes, I am.' }], key: 'A', ok: 'Yes — the It\'s-answer fits the email question.', no: 'Match the question: email → It\'s + the address.', hints: ['What did Nina ask for?', 'The message address: It\'s…'], secs: 20, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G017', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['number', 'your', 'What\'s', 'phone', '?'], key: ['What\'s', 'your', 'phone', 'number', '?'], ok: 'What\'s your phone number? — the register question!', no: 'Start with the question word: What\'s.', hints: ['What\'s first.', 'What\'s → your → phone → number → ?'], secs: 25, a11y: ['tap_only_no_drag', 'order_mechanics_demonstrated'] },
    { id: 'PR-G018', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD061', opts: [{ id: 'A', t: 'It\'s 5-5-5, 2-0-1.' }, { id: 'B', t: 'I\'m 5-5-5, 2-0-1.' }, { id: 'C', t: 'You\'re 5-5-5, 2-0-1.' }], key: 'A', ok: 'Yes — It\'s 5-5-5, 2-0-1.', no: 'The first word of Maya\'s line: It\'s.', hints: ['Play again; catch word one.', 'It\'s… then the digits.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-G019', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL002', 'Maya\'s finished badge on the desk'), prompt: 'The badge says M-A-Y-A. Nina reads it: ___ Maya!', opts: [{ id: 'A', t: 'It\'s' }, { id: 'B', t: 'You\'re' }, { id: 'C', t: 'I\'m' }], key: 'A', ok: 'Yes — It\'s Maya! M-A-Y-A.', no: 'The badge-thing takes It\'s.', hints: ['Person speaking, or thing being read?', 'Things on badges: It\'s.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-G020', instr: 'Look. Choose.', icon: 'choose', prompt: 'NINA: “What\'s your phone number?” … YOU: “___”', opts: [{ id: 'A', t: 'It\'s 5-5-5, 2-0-1.' }, { id: 'B', t: 'Is 5-5-5, 2-0-1.' }, { id: 'C', t: 'My phone number.' }], key: 'A', ok: 'It\'s 5-5-5, 2-0-1 — the full answer!', no: 'Use the answer word: It\'s…', hints: ['How did Maya answer Nina?', 'It\'s, then the digits.'], secs: 15, a11y: ['malformed_option_feedback_explained'] },
    { id: 'PR-G021', instr: 'Look. Choose.', icon: 'eye', prompt: 'Listen! … Say! … Match! — Which one goes with the ear icon?', opts: [{ id: 'A', t: 'Listen!' }, { id: 'B', t: 'Say!' }, { id: 'C', t: 'Match!' }], key: 'A', ok: 'Yes — the ear listens!', no: 'Ear = the hearing word.', hints: ['What do ears do?', 'Listen!'], secs: 10, a11y: ['icon_system_established_C1_S03'] },
    { id: 'PR-G022', instr: 'Look. Choose.', icon: 'eye', prompt: 'Which one goes with the mouth icon?', opts: [{ id: 'A', t: 'Match!' }, { id: 'B', t: 'Say!' }, { id: 'C', t: 'Listen!' }], key: 'B', ok: 'Yes — the mouth says!', no: 'Mouth = the speaking word.', hints: ['What does the mouth do?', 'Say!'], secs: 10, a11y: ['icon_system_established_C1_S03'] },
    { id: 'PR-G023', instr: 'Look. Choose.', icon: 'choose', prompt: 'Nina says \u2018Maya.\u2019 Your job: the same word after her.', opts: [{ id: 'A', t: 'Repeat!' }, { id: 'B', t: 'Listen!' }, { id: 'C', t: 'Choose!' }], key: 'A', ok: 'Yes — Repeat!', no: 'Her word, then yours: the echo word.', hints: ['What is the echo action?', 'Repeat!'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G024', instr: 'Look. Choose.', icon: 'choose', prompt: 'Three cards. One card has a star. Your job: the star card.', opts: [{ id: 'A', t: 'Choose!' }, { id: 'B', t: 'Say!' }, { id: 'C', t: 'Match!' }], key: 'A', ok: 'Yes — Choose! The star card.', no: 'One card, one pick: choose.', hints: ['One card, not two — which action?', 'Choose!'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G025', instr: 'Look. Choose.', icon: 'choose', prompt: 'Two cards and two pictures. Your job: card to picture, picture to card.', opts: [{ id: 'A', t: 'Match!' }, { id: 'B', t: 'Repeat!' }, { id: 'C', t: 'Listen!' }], key: 'A', ok: 'Yes — Match! The pairs.', no: 'Two and two, pair them up: match.', hints: ['What do pairs do?', 'Match!'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G026', instr: 'Look. Choose the class word.', icon: 'eye', prompt: 'Which one is the class word?', opts: [{ id: 'A', t: 'Listen!' }, { id: 'B', t: 'Listening!' }, { id: 'C', t: 'Listens!' }], key: 'A', ok: 'Yes — Listen! One clean word.', no: 'The class word has no extra ending.', hints: ['Say it as Nina says it.', 'The flat word: Listen!'], secs: 15, a11y: ['malformed_option_feedback_explained'] },
    { id: 'PR-G027', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD062', opts: [{ id: 'A', t: 'Pick one card.' }, { id: 'B', t: 'Say the word.' }, { id: 'C', t: 'Ear on.' }], key: 'A', ok: 'Yes — choose: pick one card.', no: 'The word was Choose! — pick one.', hints: ['Play the chain again; which word came with the pointing finger?', 'Choose → pick.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'options_read_aloud_available'] },
    { id: 'PR-G028', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['please', 'Repeat', '!'], key: ['Repeat', 'please', '!'], ok: 'Repeat, please! — kind and clear.', no: 'The action word leads; please follows.', hints: ['Which tile is the action?', 'Repeat → please → !'], secs: 20, a11y: ['tap_only_no_drag'] },
    { id: 'PR-G029', instr: 'Look. Choose.', icon: 'choose', prompt: 'NINA: “___, Maya! The class listens to you.” … (Maya\'s turn to speak)', opts: [{ id: 'A', t: 'Say!' }, { id: 'B', t: 'Listen!' }, { id: 'C', t: 'Sorry!' }], key: 'A', ok: 'Say! — Maya\'s voice, Maya\'s turn.', no: 'Her mouth is the tool: the saying word.', hints: ['Whose turn is it — ears or mouth?', 'Say!'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-G030', instr: 'Look. Choose.', icon: 'choose', prompt: 'You want Maya\'s word one more time. Nina says: ___', opts: [{ id: 'A', t: 'Repeat!' }, { id: 'B', t: 'Listen!' }, { id: 'C', t: 'Twenty!' }], key: 'A', ok: 'Yes — Repeat! One more time.', no: 'Ask her mouth, not your ear: Repeat!', hints: ['Who must act — you or Maya?', 'Maya speaks again: Repeat!'], secs: 15, a11y: ['situation_frame_narrated'] }
  ];

  var pron2 = [
    { id: 'PR-P001', instr: 'Listen. Choose.', prompt: 'The pair chain plays G … J … G … J. Which letter is LAST?', aud: 'AUD063', opts: [{ id: 'A', t: 'J' }, { id: 'B', t: 'G' }, { id: 'C', t: 'A' }], note: 'G ends in eee; J ends in ay. The last one in the chain is the long-e letter: G.' },
    { id: 'PR-P002', instr: 'Listen. How many numbers?', prompt: 'The string plays in two chunks.', aud: 'AUD064', opts: [{ id: 'A', t: '3' }, { id: 'B', t: '6' }, { id: 'C', t: '9' }], note: '“Five, five, five” + “two, zero, one” = six digits, 3 + 3. Tap the table once per number — the beat zone is never timed.' },
    { id: 'PR-P003', instr: 'Listen. One beat or two?', prompt: 'Two number words play in sequence.', aud: 'AUD065', opts: [{ id: 'A', t: 'One — nine' }, { id: 'B', t: 'Two — nineteen' }, { id: 'C', t: 'Two — nine' }], note: 'nine-TEEN has two beats; the long ending makes the second beat. Receptive awareness only — no -ty word is named.' },
    { id: 'PR-P004', instr: 'Listen. Say.', word: '5-5-5, 2-0-1', aud: 'AUD064', note: 'Say the sample number with Nina, two chunks: five, five, five … two, zero, one. Ungraded — the non-voice route is tapping the six digits on the strip.' }
  ];

  /* ---------- L03 practice ---------- */
  var ls1 = [
    { id: 'PR-LS001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', prompt: 'Where are they?', opts: [{ id: 'A', t: 'at the check-in desk' }, { id: 'B', t: 'in the café' }, { id: 'C', t: 'in the park' }], key: 'A', ok: 'Yes — the check-in desk.', no: 'Where do people spell names and give numbers?', hints: ['Listen for the register words.', 'Badge. Number. Desk.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_1_dependence_documented'] },
    { id: 'PR-LS002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', prompt: 'What does Nina ask for first?', opts: [{ id: 'A', t: 'the email' }, { id: 'B', t: 'the name' }, { id: 'C', t: 'the cups' }], key: 'B', ok: 'Yes — the name comes first.', no: 'What did Nina ask before anything else?', hints: ['The register\'s FIRST row.', 'The name.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_1_dependence_documented'] },
    { id: 'PR-LS003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', prompt: 'How does the talk end?', opts: [{ id: 'A', t: 'with a spelling request' }, { id: 'B', t: 'with a repair' }, { id: 'C', t: 'with thanks and see you' }], key: 'C', ok: 'Yes — a warm close.', no: 'How did Maya\'s last line end?', hints: ['Listen to the LAST line.', 'Thank you + see you.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_1_dependence_documented'] }
  ];
  var ls2 = [
    { id: 'PR-LS004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD072', ill: ill('ILL027', 'A new arrival at the check-in desk with a blank badge'), prompt: 'Who is checking in?', opts: [{ id: 'A', t: 'Sam Rivera' }, { id: 'B', t: 'Alex Kim' }, { id: 'C', t: 'Leo Novak' }], key: 'A', ok: 'Yes — Sam Rivera.', no: 'Listen to the check-question again.', hints: ['The name has three beats: Ri-ve-ra.', 'Sam Rivera.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_2_dependence_documented'] },
    { id: 'PR-LS005', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD072', prompt: 'The FIRST chunk of Sam\'s number is:', opts: [{ id: 'A', t: '7-3-2' }, { id: 'B', t: '5-5-5' }, { id: 'C', t: '4-0-1' }], key: 'C', ok: 'Yes — 4-0-1 comes first.', no: 'The first three digits, after \u2018It\'s…\u2019', hints: ['Play again; stop right after \u2018It\'s…\u2019.', 'Four, zero, one.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_2_dependence_documented', 'visual_digit_strip_route'] },
    { id: 'PR-LS006', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD072', prompt: 'The SECOND chunk is:', opts: [{ id: 'A', t: '4-0-1' }, { id: 'B', t: '7-3-2' }, { id: 'C', t: '2-0-1' }], key: 'B', ok: 'Yes — 7-3-2.', no: 'The digits AFTER the pause.', hints: ['Two chunks — catch the second.', 'Seven, three, two.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_2_dependence_documented', 'visual_digit_strip_route'] },
    { id: 'PR-LS007', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD072', prompt: 'How many digits in all?', opts: [{ id: 'A', t: '3' }, { id: 'B', t: '5' }, { id: 'C', t: '6' }], key: 'C', ok: 'Yes — six, in two chunks.', no: 'Count both chunks: three and three.', hints: ['Tap a beat per digit.', '3 + 3 = 6.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_2_dependence_documented', 'visual_digit_strip_route'] }
  ];
  var ls3 = [
    { id: 'PR-LS008', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD073', prompt: 'What does Leo give?', opts: [{ id: 'A', t: 'his email address' }, { id: 'B', t: 'his phone number' }, { id: 'C', t: 'his name' }], key: 'A', ok: 'Yes — his email.', no: 'Digits or dots? He said dots.', hints: ['Listen for at and dot.', 'Email.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_3_dependence_documented'] },
    { id: 'PR-LS009', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD073', prompt: 'You caught nothing of Leo\'s fast email. You say:', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Can you repeat that, please?' }, { id: 'C', t: 'Yes, I am!' }], key: 'B', ok: 'Yes — ask again!', no: 'The email flew by. Ask for it once more.', hints: ['Did ANY of it land? No.', 'The repeat line.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_3_dependence_documented'] },
    { id: 'PR-LS010', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD073', prompt: 'Which word comes after “leo dot”?', opts: [{ id: 'A', t: 'kim' }, { id: 'B', t: 'aroa' }, { id: 'C', t: 'novak' }], key: 'C', ok: 'Yes — novak.', no: 'The dot-stop lands inside the name: leo • novak.', hints: ['Play again; hum the dots.', 'leo • ___ • at • aroa.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'testlet_3_dependence_documented'] },
    { id: 'PR-LS011 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD071', ill: ill('ILL026', 'The desk, the challenge take'), prompt: 'Who checks in?', opts: [{ id: 'A', t: 'Sam' }, { id: 'B', t: 'Alex' }, { id: 'C', t: 'Maya' }], key: 'B', ok: 'Yes — Alex, the email version.', no: 'Whose full name gets checked?', hints: ['Catch the badge-check name.', 'Alex Kim.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-LS012 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD071', prompt: 'What does Nina ask for?', opts: [{ id: 'A', t: 'the phone number' }, { id: 'B', t: 'the badge' }, { id: 'C', t: 'the email address' }], key: 'C', ok: 'Yes — the email question.', no: 'Listen for at and dot — which row?', hints: ['Dots or digits?', 'Email.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-LS013 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD074', prompt: 'The letters spell:', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Leo' }], key: 'A', ok: 'Yes — N, I, N, A: Nina.', no: 'Catch the first letter: N.', hints: ['Play again; hold letter one.', 'N… N… Nina.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-LS014 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD075', prompt: 'How many letters are spoken?', opts: [{ id: 'A', t: '4' }, { id: 'B', t: '3' }, { id: 'C', t: '5' }], key: 'A', ok: 'Yes — four: A, L, E, X.', no: 'Tap a beat per letter.', hints: ['A… L… E… X — count the beats.', 'Four.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'PR-LS015 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD076', prompt: 'Two lines play — which one ASKS?', opts: [{ id: 'A', t: 'You\'re Maya.' }, { id: 'B', t: 'Are you Maya?' }, { id: 'C', t: 'I\'m Maya.' }], key: 'B', ok: 'Yes — the voice lifts: Are you Maya?', no: 'The ASKING line starts with Are and rises.', hints: ['Play again; hum the tune of each.', 'The rising one asks.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-LS016 · transfer', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', prompt: 'Maya\'s line at turn 8 — what does she want?', opts: [{ id: 'A', t: 'to hear it again' }, { id: 'B', t: 'to say goodbye' }, { id: 'C', t: 'to write a badge' }], key: 'A', ok: 'Yes — one more time.', no: 'Her hand is at her ear.', hints: ['What follows her line? Nina says it again.', 'Hearing it again.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] }
  ];

  var cvOrder2 = [
    { id: 'PR-CV008', instr: 'Put in order.', target: 'The check-in spine — four turns.', tiles: ['What\'s your phone number?', 'Are you Maya Haddad?', 'It\'s 5-5-5, 2-0-1.', 'Yes, I am!'], key: ['Are you Maya Haddad?', 'Yes, I am!', 'What\'s your phone number?', 'It\'s 5-5-5, 2-0-1.'], ok: 'The check-in spine, in order!', no: 'Start with the badge check.', hints: ['First: the badge. Last: the digits.', 'Check → yes → ask → answer.'] },
    { id: 'PR-CV009', instr: 'Put in order.', target: 'Version E — the email check-in, six turns.', tiles: ['It\'s alex dot kim at aroa dot com.', 'Hi, Nina!', 'See you, Alex!', 'Yes, I am!', 'Are you Alex Kim?', 'What\'s your email address?'], key: ['Hi, Nina!', 'Are you Alex Kim?', 'Yes, I am!', 'What\'s your email address?', 'It\'s alex dot kim at aroa dot com.', 'See you, Alex!'], ok: 'The whole email check-in, in order!', no: 'Two greets? No — one hi, then the badge check.', hints: ['First and last are the greet and the close.', 'Check → yes → ask → answer → close.'] }
  ];

  var cvItems2 = [
    { id: 'PR-CV001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD070', bubbles: true, said: { sp: 'NINA', t: 'Are you Maya Haddad?' }, opts: [{ id: 'A', t: 'Yes, I am!' }, { id: 'B', t: 'It\'s 5-5-5, 2-0-1.' }, { id: 'C', t: 'See you!' }], key: 'A', ok: 'Yes — Yes, I am!', no: 'She asked a check-question. Give the yes-answer.', hints: ['Listen again — what KIND of question is it?', 'Are you…? → Yes, I am!'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-CV002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', bubbles: true, said: { sp: 'MAYA', t: 'H-A-D-D-A-D.' }, opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Thank you! … What\'s your phone number?' }, { id: 'C', t: 'Can you repeat that, please?' }], key: 'B', ok: 'Yes — thanks, then the next row: the phone number.', no: 'The register has more rows. What comes after the name?', hints: ['Look at the register rows: name → digits → message.', 'The digits-row question.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-CV003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', bubbles: true, said: { sp: 'NINA', t: '5-5-0, 2-1?' }, opts: [{ id: 'A', t: 'Yes, I am!' }, { id: 'B', t: 'See you!' }, { id: 'C', t: 'Can you repeat that, please?' }], key: 'C', ok: 'Yes — ask for it again!', no: 'The read-back was a blur. What fixes a blur?', hints: ['Did you catch her read-back? Neither did Maya.', 'The repeat question.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-CV004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD069', bubbles: true, said: { sp: 'MAYA', t: 'See you!' }, opts: [{ id: 'A', t: 'How do you spell that?' }, { id: 'B', t: 'Thank you, Maya! See you!' }, { id: 'C', t: 'What\'s your email address?' }], key: 'B', ok: 'Yes — a warm double close.', no: 'The check-in is done. Close it warmly.', hints: ['What is left to do? Nothing!', 'Thanks + see you.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-CV005', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL032', 'Maya\'s hand cups her ear at the desk'), prompt: 'What does Maya want?', opts: [{ id: 'A', t: 'She wants the letters.' }, { id: 'B', t: 'She is leaving.' }, { id: 'C', t: 'She wants to hear the number one more time.' }], key: 'C', ok: 'Yes — one more time, please.', no: 'The hand is at the ear — she wants to HEAR.', hints: ['Look at Maya\'s hand.', 'Ear = hear again.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-CV006', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD070', prompt: 'NINA: “What\'s your phone number?” — what does she want?', opts: [{ id: 'A', t: 'She wants the digits.' }, { id: 'B', t: 'She wants the badge.' }, { id: 'C', t: 'She wants the email.' }], key: 'A', ok: 'Yes — the digits.', no: 'Which register row does \u2018phone number\u2019 point at?', hints: ['Phone number — things you tap into a phone.', 'Digits.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'PR-CV007', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL028', 'Nina reads the digits back, rising voice, pen hovering'), prompt: 'What is Nina doing?', opts: [{ id: 'A', t: 'Nina says goodbye.' }, { id: 'B', t: 'Nina checks the number.' }, { id: 'C', t: 'Nina asks for letters.' }], key: 'B', ok: 'Yes — the read-back checks.', no: 'She repeats the digits with a question voice — a check.', hints: ['Why say the digits AGAIN?', 'To check them.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-CV010', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL028', 'The read-back on the register: 5-5-0, 2-1'), prompt: 'Nina\'s read-back says 5-5-0, 2-1 — WRONG. You:', opts: [{ id: 'A', t: 'Say nothing.' }, { id: 'B', t: 'Say goodbye.' }, { id: 'C', t: 'Say it again — five, five, five … two, zero, one.' }], key: 'C', ok: 'Yes — chunk it and repeat it.', no: 'The register would keep the WRONG number. Fix it.', hints: ['Is 5-5-0 right? No!', 'Say your number again, in two chunks.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-CV011', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL028', 'The read-back matches the card'), prompt: 'The read-back says 5-5-5, 2-0-1? — RIGHT. You:', opts: [{ id: 'A', t: 'Yes! Correct!' }, { id: 'B', t: 'Can you repeat that, please?' }, { id: 'C', t: 'Sorry!' }], key: 'A', ok: 'Yes! Correct! — the register is done.', no: 'She got it RIGHT. Confirm it.', hints: ['Compare her digits with yours.', 'They match — say yes.'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-CV012', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL032', 'A hand cups an ear — the read-back was a blur'), prompt: 'The read-back is a fast blur — you caught nothing. You:', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Please speak slowly.' }, { id: 'C', t: 'Yes, I am!' }], key: 'B', ok: 'Yes — ask for space between the words.', no: 'You caught only a blur — ask for slow.', hints: ['Did you catch NOTHING, or wrong digits?', 'Nothing clear → slowly.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'PR-CV013', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL031', 'Leo walks up to the check-in desk'), prompt: 'Leo is at the desk. Nina asks:', opts: [{ id: 'A', t: 'Are you Maya Haddad?' }, { id: 'B', t: 'Yes, I am!' }, { id: 'C', t: 'Are you Leo Novak?' }], key: 'C', ok: 'Yes — the check with LEO\'s name.', no: 'Who is standing at the desk? Use that name.', hints: ['Look at who arrived.', 'Leo → his full name.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV014', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL028', 'The pen moves to the message row for Maya'), prompt: 'Nina asks MAYA for her email this time. Maya says:', opts: [{ id: 'A', t: 'It\'s maya dot haddad at aroa dot com.' }, { id: 'B', t: 'What\'s your email address?' }, { id: 'C', t: 'It\'s 5-5-5, 2-0-1.' }], key: 'A', ok: 'Yes — the email answer for Maya.', no: 'The question was about email — give the email.', hints: ['Email or digits?', 'maya dot haddad at aroa dot com.'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'PR-CV015', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL023', 'Nina holds up YOUR badge and asks'), prompt: 'YOUR turn — Nina holds up your badge and asks. You say:', opts: [{ id: 'A', t: 'Can you repeat that, please?' }, { id: 'B', t: 'Yes, I am!' }, { id: 'C', t: 'It\'s alex dot kim at aroa dot com.' }], key: 'B', ok: 'Yes, I am! — ready for the mission.', no: 'The badge is YOURS. Claim it.', hints: ['Whose badge is up?', 'Yours → the yes-answer.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'PR-CV016', instr: 'Look. Choose.', icon: 'choose', ill: ill('ILL024', 'Your sample card beside the register'), prompt: 'Nina asks YOU: “What\'s your phone number?” Your sample card reads 5-5-5, 2-0-1.', opts: [{ id: 'A', t: 'How do you spell that?' }, { id: 'B', t: 'Yes, I am!' }, { id: 'C', t: 'It\'s 5-5-5, 2-0-1.' }], key: 'C', ok: 'It\'s 5-5-5, 2-0-1 — mission-ready.', no: 'Give the digits with the answer word It\'s.', hints: ['Read your sample card.', 'It\'s + the digits.'], secs: 15, a11y: ['situation_frame_narrated'] }
  ];

  var pron25b = [
    { id: 'PR-P005', instr: 'Listen. Tap the letters.', prompt: 'The string plays — tap the letters on the chart in order.', aud: 'AUD074', opts: [{ id: 'A', t: 'N' }, { id: 'B', t: 'I' }, { id: 'C', t: 'N' }, { id: 'D', t: 'A' }], note: 'The string is N-I-N-A. Take one letter at a time; the chart route is always available.' },
    { id: 'PR-P006', instr: 'Listen. Choose.', prompt: 'The string A-L-E-X plays — which letter is LAST?', aud: 'AUD075', opts: [{ id: 'A', t: 'A' }, { id: 'B', t: 'E' }, { id: 'C', t: 'X' }], note: 'The string ends on X — A is first, E is third. Say the string with the audio.' }
  ];
  var pron31b = [
    { id: 'PR-P007', word: 'Are you Maya?', aud: 'AUD076', note: 'Make it ASK — let the voice go UP at the end. Hum it first: da-da-DAH?' },
    { id: 'PR-P008', word: 'H-A-D-D-A-D', aud: 'AUD070', note: 'Spell Maya\'s family name with her — six letters, two at a time: H-A … D-D … A-D.' },
    { id: 'PR-P009', word: 'maya dot haddad at aroa dot com', aud: 'AUD061', note: 'Five parts. Say it in two halves: maya dot haddad / at aroa dot com. The big break is AT.' },
    { id: 'PR-P010', word: 'Can you repeat that, please?', aud: 'AUD070', note: 'Say it kindly — stress RE-peat, warm and slow. Tone is coached, never scored.' }
  ];

  var rdForm = [
    { id: 'PR-RD001', instr: 'Read. Choose.', icon: 'eye', prompt: 'First name:', opts: [{ id: 'A', t: 'Haddad' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Nina' }], key: 'B', ok: 'Yes — Maya comes first.', no: 'First name = the name people call you.', hints: ['Which name comes FIRST in the row?', 'Maya.'], secs: 15, a11y: ['voiceover_reads_form', 'visual_only_construct'] },
    { id: 'PR-RD002', instr: 'Read. Choose.', icon: 'eye', prompt: 'Last name:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Nina' }, { id: 'C', t: 'Haddad' }], key: 'C', ok: 'Yes — Haddad, the family name.', no: 'Last name = the family name at the end.', hints: ['Which name is at the END?', 'Haddad.'], secs: 15, a11y: ['voiceover_reads_form', 'visual_only_construct'] },
    { id: 'PR-RD003', instr: 'Read. Choose.', icon: 'eye', prompt: 'How many DOTS in the email?', opts: [{ id: 'A', t: '2' }, { id: 'B', t: '1' }, { id: 'C', t: '3' }], key: 'A', ok: 'Yes — two dots.', no: 'maya DOT haddad … aroa DOT com — count the small stops.', hints: ['Read it aloud in words.', 'Two small stops.'], secs: 15, a11y: ['voiceover_reads_form', 'visual_only_construct'] },
    { id: 'PR-RD004', instr: 'Read. Choose.', icon: 'eye', prompt: 'Which row has NUMBERS?', opts: [{ id: 'A', t: 'NAME' }, { id: 'B', t: 'PHONE' }, { id: 'C', t: 'EMAIL' }], key: 'B', ok: 'Yes — the PHONE row.', no: 'Find the row with digits only.', hints: ['Scan each row.', 'Digits live in the PHONE row.'], secs: 15, a11y: ['voiceover_reads_form', 'visual_only_construct'] }
  ];
  var rdCard = [
    { id: 'PR-RD005', instr: 'Read. Choose.', icon: 'eye', prompt: 'The card is from:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Alex' }, { id: 'C', t: 'Nina' }], key: 'C', ok: 'Yes — the card is Nina\'s.', no: 'Find the name line.', hints: ['Read line two.', 'Nina Petrova.'], secs: 15, a11y: ['voiceover_reads_card', 'visual_only_construct'] },
    { id: 'PR-RD006', instr: 'Read. Choose.', icon: 'eye', prompt: 'The LAST digit of Nina\'s phone number:', opts: [{ id: 'A', t: '9' }, { id: 'B', t: '2' }, { id: 'C', t: '5' }], key: 'A', ok: 'Yes — nine.', no: 'Read the digits right to left — the last one.', hints: ['Find the phone line.', '…2-0-9: the end digit.'], secs: 15, a11y: ['voiceover_reads_card', 'visual_only_construct'] },
    { id: 'PR-RD007', instr: 'Read. Choose.', icon: 'eye', prompt: 'Nina\'s email is:', opts: [{ id: 'A', t: 'nina.haddad@aroa.com' }, { id: 'B', t: 'nina.petrova@aroa.com' }, { id: 'C', t: 'maya.haddad@aroa.com' }], key: 'B', ok: 'Yes — nina dot petrova at aroa dot com.', no: 'Match HER first name with HER family name.', hints: ['Read line four.', 'nina.petrova.'], secs: 15, a11y: ['voiceover_reads_card', 'visual_only_construct'] },
    { id: 'PR-RD008', instr: 'Read. Choose.', icon: 'eye', prompt: '“See you!” is…', opts: [{ id: 'A', t: 'a name' }, { id: 'B', t: 'a number' }, { id: 'C', t: 'a goodbye line' }], key: 'C', ok: 'Yes — the card\'s little goodbye.', no: 'Where does the card END?', hints: ['Read the last line.', 'A goodbye.'], secs: 15, a11y: ['voiceover_reads_card', 'visual_only_construct'] }
  ];

  /* ---------- L04 ---------- */
  var quiz2 = [
    { id: 'QZ-L001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD021', big: true, opts: [{ id: 'A', t: 'R' }, { id: 'B', t: 'I' }, { id: 'C', t: 'A' }], key: 'A', ok: 'Yes — R!', no: 'The open ahr name: R.', hints: ['Play again; hold the first sound.', 'Two options rhyme. The r-one.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'QZ-L002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD022', big: true, opts: [{ id: 'A', t: 'M' }, { id: 'B', t: 'S' }, { id: 'C', t: 'X' }], key: 'B', ok: 'Yes — S!', no: 'The name ends in s-s-s.', hints: ['Play again; feel the last sound.', 'It ends like \u2018sorry\u2019 starts.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'QZ-L003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD017', big: true, opts: [{ id: 'A', t: 'B' }, { id: 'B', t: 'C' }, { id: 'C', t: 'E' }], key: 'C', ok: 'Yes — E! Just the pure long e.', no: 'Say the three: bee, see, ee. The answer has NO start.', hints: ['Play again; is there a consonant before the eee?', 'No consonant → E.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'QZ-L004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD020', big: true, opts: [{ id: 'A', t: 'L' }, { id: 'B', t: 'N' }, { id: 'C', t: 'F' }], key: 'B', ok: 'Yes — N!', no: 'M hums on the lips; N hums behind the teeth.', hints: ['Touch your lips — do they close?', 'No lip closure, nose on: N.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'QZ-L005', instr: 'Look. Choose the THIRD letter.', icon: 'eye', prompt: 'A L E X', big: true, opts: [{ id: 'A', t: 'E' }, { id: 'B', t: 'X' }, { id: 'C', t: 'L' }], key: 'A', ok: 'Yes — A, L, E: the third is E.', no: 'Point and count: one, two, three.', hints: ['Tap the letters one by one.', 'A… L… E.'], secs: 20, a11y: ['voiceover_reads_letters', 'visual_only_construct'] },
    { id: 'QZ-N001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD044', big: true, opts: [{ id: 'A', t: '7' }, { id: 'B', t: '16' }, { id: 'C', t: '17' }], key: 'C', ok: 'Yes — seventeen!', no: 'Which first part returns? se-…', hints: ['Play again; catch the first part.', 'se- + teen = 17.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'QZ-N002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD040', big: true, opts: [{ id: 'A', t: '13' }, { id: 'B', t: '3' }, { id: 'C', t: '12' }], key: 'A', ok: 'Yes — thirteen!', no: 'Long word, th- start: thir-teen.', hints: ['Short or long?', 'Long th- word → 13.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'QZ-N003', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD033', big: true, opts: [{ id: 'A', t: '10' }, { id: 'B', t: '6' }, { id: 'C', t: '16' }], key: 'B', ok: 'Yes — six! Short and clipped.', no: 'The -teen words are LONG. This one is short.', hints: ['Tap the beats.', 'One beat → 6.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'QZ-N004', instr: 'Look. Choose.', icon: 'eye', prompt: 'fifteen', big: true, opts: [{ id: 'A', t: '14' }, { id: 'B', t: '5' }, { id: 'C', t: '15' }], key: 'C', ok: 'Yes — fifteen = 15.', no: 'Find the five hiding inside: fif-.', hints: ['First part says five.', 'fif + teen → 15.'], secs: 15, a11y: ['voiceover_reads_word', 'visual_only_construct'] },
    { id: 'QZ-N005', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL033', 'Nine cups in a three-by-three grid'), opts: [{ id: 'A', t: '9' }, { id: 'B', t: '8' }, { id: 'C', t: '10' }], key: 'A', ok: 'Yes — nine! Three rows of three.', no: 'Tap the picture; count the pulses.', hints: ['Count one row: three.', 'Three rows of three = nine.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'tap_to_count_support'] },
    { id: 'QZ-V001', instr: 'Choose.', icon: 'choose', ill: ill('ILL014', 'A hand cups an ear as Nina leans in kindly'), prompt: 'Nina says her name one time. You do not hear it. You say:', opts: [{ id: 'A', t: 'Please speak slowly.' }, { id: 'B', t: 'Can you repeat that, please?' }, { id: 'C', t: 'What\'s your email address?' }], key: 'B', ok: 'Yes — ask for it again!', no: 'Nothing landed → one more time.', hints: ['New detail, or the same words again?', 'The repeat line.'], secs: 20, a11y: ['alt_text_construct_equivalent', 'situation_frame_narrated'] },
    { id: 'QZ-V002', instr: 'Look. Choose.', icon: 'eye', prompt: 'maya dot haddad ___ aroa dot com', opts: [{ id: 'A', t: 'dot' }, { id: 'B', t: 'spell' }, { id: 'C', t: 'at' }], key: 'C', ok: 'Yes — at! Person AT place.', no: 'The small stops have dot. The BIG break takes…', hints: ['Which break is biggest?', 'at.'], secs: 15, a11y: ['voiceover_reads_string'] },
    { id: 'QZ-V003', instr: 'Choose.', icon: 'choose', ill: ill('ILL020', 'A house with a small blank plaque beside the door'), prompt: 'Where is your home? Your ___.', opts: [{ id: 'A', t: 'address' }, { id: 'B', t: 'phone' }, { id: 'C', t: 'name' }], key: 'A', ok: 'Yes — your address!', no: 'The house picture: the home word.', hints: ['Look at the house.', 'address.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'QZ-V004 · cumulative C1', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL035', 'Lamps lit on a street in low amber light, the day ending'), opts: [{ id: 'A', t: 'good morning' }, { id: 'B', t: 'good evening' }, { id: 'C', t: 'good afternoon' }], key: 'B', ok: 'Yes — good evening!', no: 'Look at the light: the day is ENDING.', hints: ['Lamps on or sun high?', 'Evening.'], secs: 15, a11y: ['alt_text_construct_equivalent', 'no_color_only_meaning'] },
    { id: 'QZ-G001', instr: 'Choose.', icon: 'choose', ill: ill('ILL023', 'Nina checks a badge at the desk'), prompt: '___ you Leo?', opts: [{ id: 'A', t: 'Are' }, { id: 'B', t: 'You\'re' }, { id: 'C', t: 'I\'m' }], key: 'A', ok: 'Yes — Are you Leo?', no: 'Checking puts Are FIRST.', hints: ['Who asks?', 'Are.'], secs: 15, a11y: ['alt_text_construct_equivalent'] },
    { id: 'QZ-G002', instr: 'Choose.', icon: 'choose', prompt: 'Nina asks: “Are you Maya?” (to YOU). You say:', opts: [{ id: 'A', t: 'Yes, I am.' }, { id: 'B', t: 'No, I\'m not!' }, { id: 'C', t: 'I\'m Maya.' }], key: 'B', ok: 'Yes — No, I\'m not!', no: 'Are YOU Maya? No! Say it.', hints: ['Is the badge yours?', 'No, I\'m not!'], secs: 15, a11y: ['situation_frame_narrated'] },
    { id: 'QZ-G003', instr: 'Choose.', icon: 'choose', prompt: '“What\'s your phone number?” — “___ 4-0-1, 7-3-2.”', opts: [{ id: 'A', t: 'I\'m' }, { id: 'B', t: 'Is' }, { id: 'C', t: 'It\'s' }], key: 'C', ok: 'Yes — It\'s 4-0-1, 7-3-2.', no: 'Person or detail? Detail → It\'s.', hints: ['How did Sam answer?', 'It\'s.'], secs: 15, a11y: ['malformed_option_feedback_explained'] },
    { id: 'QZ-G004', instr: 'Put in order.', icon: 'choose', kind: 'order', tiles: ['address', 'email', 'your', 'What\'s', '?'], key: ['What\'s', 'your', 'email', 'address', '?'], ok: 'What\'s your email address? — the register\'s last question!', no: 'Start with the question word.', hints: ['What\'s first.', 'What\'s → your → email → address → ?'], secs: 25, a11y: ['tap_only_no_drag', 'order_mechanics_demonstrated'] },
    { id: 'QZ-G005', instr: 'Choose.', icon: 'choose', prompt: 'Which one ASKS?', opts: [{ id: 'A', t: 'You are Sam.' }, { id: 'B', t: 'Are you Sam?' }, { id: 'C', t: 'Sam are you.' }], key: 'B', ok: 'Yes — Are you Sam? asks.', no: 'The asker starts with Are.', hints: ['Read both aloud.', 'The Are-first one.'], secs: 15, a11y: ['voiceover_reads_options'] },
    { id: 'QZ-LS001', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD078', prompt: 'Leo\'s FIRST number chunk:', opts: [{ id: 'A', t: '6-2-0' }, { id: 'B', t: '1-5-4' }, { id: 'C', t: '5-5-5' }], key: 'A', ok: 'Yes — 6-2-0.', no: 'Stop right after \u2018It\'s…\u2019.', hints: ['Play again; catch the digits before the pause.', 'Six, two, zero.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'digit_strip_reference'] },
    { id: 'QZ-LS002', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD078', prompt: 'Nina\'s LAST line:', opts: [{ id: 'A', t: 'What\'s your phone number?' }, { id: 'B', t: 'Hello, Leo!' }, { id: 'C', t: 'Thank you, Leo!' }], key: 'C', ok: 'Yes — thank you!', no: 'Listen to the LAST line.', hints: ['The end, not the start.', 'Thank you, Leo!'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'QZ-LS003 · cumulative C1', instr: 'Listen. Choose.', icon: 'ear', aud: 'A1-C01-AUD007', prompt: 'What word do you hear?', opts: [{ id: 'A', t: 'hello' }, { id: 'B', t: 'goodbye' }, { id: 'C', t: 'sorry' }], key: 'B', ok: 'Yes — goodbye!', no: 'This word is for leaving.', hints: ['Play again; catch the ending -bye.', 'goodbye.'], secs: 15, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once'] },
    { id: 'QZ-LS004', instr: 'Listen. Choose.', icon: 'ear', aud: 'AUD028', prompt: 'The letters spell:', opts: [{ id: 'A', t: 'Maya' }, { id: 'B', t: 'Nina' }, { id: 'C', t: 'Leo' }], key: 'A', ok: 'Yes — Maya!', no: 'Catch the first letter: M.', hints: ['Hold letter one.', 'M → Maya.'], secs: 20, a11y: ['audio_required_transcript_after_response', 'replay_allowed_once', 'visual_letter_chart_route'] },
    { id: 'QZ-RD001', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL034', 'A fresh register form, surfaces blank for app-layer text'), prompt: 'Form — NAME: Sam Rivera · PHONE: 4-0-1, 7-3-2 · Sam\'s phone number is …', opts: [{ id: 'A', t: '5-5-5, 2-0-1' }, { id: 'B', t: '9-7-2-4-1-6' }, { id: 'C', t: '4-0-1, 7-3-2' }], key: 'C', ok: 'Yes — the row says it.', no: 'Find the PHONE row, read left to right.', hints: ['Which row has digits?', '4-0-1, 7-3-2.'], secs: 15, a11y: ['voiceover_reads_form', 'visual_only_construct'] },
    { id: 'QZ-RD002 · cumulative C1', instr: 'Look. Choose.', icon: 'eye', ill: ill('ILL034', 'A blank badge surface for app-layer text'), prompt: 'Badge: NINA PETROVA · The FIRST name is …', opts: [{ id: 'A', t: 'Nina' }, { id: 'B', t: 'Petrova' }, { id: 'C', t: 'Maya' }], key: 'A', ok: 'Yes — Nina.', no: 'Which name comes FIRST?', hints: ['Read the badge left to right.', 'Nina.'], secs: 15, a11y: ['voiceover_reads_badge', 'visual_only_construct'] },
    { id: 'QZ-CN001 · cumulative C1', instr: 'Choose the best next line.', icon: 'choose', prompt: 'ALEX: “Hello! What\'s your name?” … SAM: “My name is Sam.” … ALEX: “___”', opts: [{ id: 'A', t: 'See you!' }, { id: 'B', t: 'Nice to meet you!' }, { id: 'C', t: 'My name is Alex.' }], key: 'B', ok: 'Yes — Nice to meet you!', no: 'New name, new friend → the meet-line.', hints: ['The names are done. What do new friends say?', 'Nice to meet you!'], secs: 15, a11y: ['voiceover_reads_dialogue'] }
  ];

  var wr36 = [
    { id: 'PR-WR003', instr: 'Put in order.', target: 'Alex\'s email, in words.', tiles: ['kim', 'aroa', 'dot', 'alex', 'at', 'com', 'dot'], key: ['alex', 'dot', 'kim', 'at', 'aroa', 'dot', 'com'], ok: 'alex dot kim at aroa dot com — Alex\'s email, said right!', no: 'Begin with the first name; the dot joins the two name parts.', hints: ['Two name parts first.', 'alex • dot • kim … at … aroa • dot • com.'] },
    { id: 'PR-WR004', instr: 'Put in order.', target: 'The badge check for Sam.', tiles: ['you', 'Are', 'Rivera', 'Sam', '?'], key: ['Are', 'you', 'Sam', 'Rivera', '?'], ok: 'Are you Sam Rivera? — the desk\'s first question!', no: 'The checking word leads.', hints: ['First word asks.', 'Are → you → Sam → Rivera → ?'] },
    { id: 'PR-WR005', instr: 'Put in order.', target: 'The repair line.', tiles: ['you', 'Can', 'please?', 'that,', 'repeat'], key: ['Can', 'you', 'repeat', 'that,', 'please?'], ok: 'Can you repeat that, please? — your rescue line, built by hand.', no: 'Start with Can.', hints: ['Two little words first.', 'Can → you → repeat → that, → please?'] },
    { id: 'PR-WR006', instr: 'Put in order.', target: 'Nina\'s card line.', tiles: ['email', 'is', 'My', 'nina dot petrova at aroa dot com.'], key: ['My', 'email', 'is', 'nina dot petrova at aroa dot com.'], ok: 'My email is nina dot petrova at aroa dot com. — a whole card line!', no: 'Whose email? Mine → My.', hints: ['Start with My.', 'My → email → is → the address.'] }
  ];

  C.chapters.push({
    id: 'A1-C02', n: 2, arc: 'Meet and connect', title: 'Spell It and Share Your Details',
    mission: 'Check in at the Community House desk — spell a name, understand and give a fictional phone number and email.',
    canDos: ['C2-1 recognise and say A–Z', 'C2-2 spell a name and request repetition', 'C2-3 understand and say numbers 0–20', 'C2-4 exchange simple contact details', 'C2-5 ask for slower or repeated speech'],
    doNotTeach: ['numbers above 20', '-ty words', 'Good night', 'anything outside the cumulative ledger'],
    dataRule: 'No real personal data ever requested — all names, numbers and emails are fictional, app-layer text.',
    lessons: [
      {
        id: 'L01', type: 'V', n: 1, title: 'The Letters and the Numbers', time: '18–20 min', pause: 'after Practice A (≈11 min)',
        src: 'A1_C02_L01_LESSON.md',
        screens: [
          {
            id: 'S01', type: 'promise', label: 'Can-do promise', step: 'STEP 1 · 30 sec',
            ill: ill('ILL001', 'A sunny community-house desk with a notebook and pen; Nina sits ready to write, Alex waves at the door'),
            newToday: 'the letters A–Z · the numbers 0–5 · How do you spell that?', newTodayLabel: 'New today',
            canDos: ['You can say the letters.', 'You can say the numbers 0–5.', 'You can ask: How do you spell that?'],
            vo: 'You will learn to: say the letters A to Z; say the numbers zero to five; ask how do you spell that.',
            tip: 'Same promise pattern as C1-S01 for consistency: full-bleed illustration top 60%, three can-do lines with empty check-rings (filled at S11). The third line previews the chapter question in the learner\'s own voice at S09 — do not link out from here.',
            assets: ['A1-C02-ILL001']
          },
          {
            id: 'S02', type: 'hook', label: 'Story hook — the check-in desk', step: 'STEP 2 · 30–60 sec',
            scene: 'The morning after the welcome event. A small check-in desk with a notebook and blank badges. Nina runs the desk; Alex waves at the door; Maya is registering too.',
            aud: 'AUD001', delivery: 'learning_slow_clear',
            ill: ill('ILL002', 'Nina sits at a check-in desk with a notebook and blank badges; Alex waves from the door'),
            lines: [
              { sp: 'ALEX', t: 'Hello! … Good morning!', d: 'waving from the door' },
              { sp: 'NINA', t: 'Good morning, Alex!', d: 'at the desk, pen ready' },
              { sp: 'NINA', t: 'Welcome! … What\'s your name?', d: 'turning to you, warm · Welcome! = CHUNK:survival' },
              { sp: 'YOU', t: 'Maya.', d: 'tap-to-say; unvoiced in audio', learner: true },
              { sp: 'NINA', t: 'Maya! … How do you spell that?', d: 'kind, pen over a blank badge — the chapter question' },
              { sp: 'YOU', t: 'M … A … Y … A.', d: 'tap-to-say; unvoiced in audio', learner: true },
              { sp: 'NINA', t: 'Maya. … Thank you!', d: 'writes, smiles' }
            ],
            scored: false,
            plant: 'How do you spell that? appears here in context (encounter #0, story plant) and is formally taught at S09.',
            tip: 'One-tap big ear button; speaker glow per line (Nina\'s teal cardigan edge lights on her lines, Alex\'s glasses on his). The learner\'s two lines are tap-to-say moments: the app shows the words, pulses the mouth icon, waits for an optional echo — never blocks, never scores.',
            assets: ['A1-C02-AUD001', 'A1-C02-ILL002']
          },
          {
            id: 'S03', type: 'warmup', label: 'Carry-over warm-up', step: 'STEP 3 · 2–3 min',
            head: 'Say hello to Nina.', sub: 'Chapter 1, retrieved. Nothing new, nothing scored.',
            frames: [
              { q: 'Say hello to Nina.', icon: 'eye', scene: 'Morning light at the desk; Nina looks up', opts: ['good morning', 'good evening', 'goodbye'], key: 'good morning' },
              { q: 'You say:', icon: 'ear', aud: 'AUD001', scene: 'NINA: "What\'s your name?"', opts: ['My name is Maya.', 'I\'m good, thank you.', 'See you!'], key: 'My name is Maya.' },
              { q: 'You say:', icon: 'ear', aud: 'AUD001', scene: 'NINA: "How are you?"', opts: ['I\'m good, thank you.', 'My name is Nina.', 'Goodbye, Maya!'], key: 'I\'m good, thank you.' }
            ],
            rule: 'Distractors are all taught C1 language. Any tap gives warm feedback and the next frame; try again language only on the second wrong tap, then the correct card glows and advances.',
            tip: 'Frame each interaction on the same desk scene (ILL002 crop regions, no new art) so the warm-up reads as one continuous moment at the desk. Big option cards (min 60 pt tall), audio auto-plays once per frame, replay offered once. Chapter-1 rings visibly tick on the progress dial.',
            assets: ['A1-C02-ILL002']
          },
          {
            id: 'S04', type: 'alphabet', label: 'Letter time — the chart', step: 'STEP 4 · ≈1 min',
            head: 'Letter time.', rule: 'Every letter has a name. Big A and little a — one name: A.',
            ill: ill('ILL003', 'Nina stands beside a big blank board, one hand raised; a notebook waits on the desk'),
            letterNames: letterNames, families: families,
            note: 'GA model: Z = /ziː/. BrE "zed" is tagged variant metadata only; never mixed into audio or running text.',
            tip: 'The chart is a 6×5 grid — tap any cell to hear its name, any time, forever after (this chart is the course-wide reference; reuse it identically in L2/L3/quiz). Letter cards flip uppercase↔lowercase on tap. Echo moments never block: pulse the mouth icon 2 s, then auto-continue. Reduce-motion: replace the flip with a crossfade.',
            assets: ['A1-C02-AUD011–014', 'A1-C02-ILL003']
          },
          {
            id: 'S05', type: 'letterCards', label: 'Alphabet family cards', step: 'STEP 4b · ≈5 min',
            chip: 'the alphabet, in families',
            families: families, letterNames: letterNames,
            flow: 'hear (letter name) → look (the letter shape) → say (echo, ungraded) → next · ≈10–12 s per letter',
            tip: 'Same pager mechanics as C1-S04. Uppercase + lowercase always shown as a pair on one card; the chart icon stays in the corner as a one-tap reference.',
            assets: ['A1-C02-AUD011–022']
          },
          {
            id: 'S06', type: 'practice', label: 'Practice A — hear the letter', step: 'STEP 5 · ≈3 min',
            bank: 'PR-V001–V009 · items 1–3 use clearly different distractors, 4–6 tighten, 7–8 are the dedicated confusable pairs (B/D, M/N), 9 is the spelling chain · answer positions 6 A / 7 B / 6 C across the lesson',
            chartChip: true,
            items: prLetters,
            tip: 'One item per screen, big letter tiles (min 72 pt), progress dots at top. The chart icon sits in the corner on every item — tapping it opens the reference chart with audio (support, never scored). Confusable items add the optional "feel it" hint chip only after a first wrong tap — never before.',
            assets: ['A1-C02-AUD015–022', 'A1-C02-AUD028']
          },
          {
            id: 'S07', type: 'pause', label: 'Pause', step: 'PAUSE · ≈11 min in',
            head: 'The letters are yours.',
            ill: ill('ILL002', 'The check-in desk, calm, with the notebook open and the pen resting'),
            body: 'Done for now? Everything is saved. Or tap to go on — the numbers are next.', rings: 3, ringsFilled: 1,
            tip: 'Identical layout to C1-S06 (ritual consistency): full-bleed calm art, three status lines, one big continue button, no exit shaming. "Done for now?" auto-saves — returning learners land on this screen first.',
            assets: ['A1-C02-ILL002']
          },
          {
            id: 'S08', type: 'numbers', label: 'Numbers 0–5', step: 'STEP 6 · ≈4 min', chip: 'numbers 0–5',
            head: 'Nina counts on her fingers.', rule: 'Count the things: zero, one, two, three, four, five. Zero = no things.',
            nums: nums05, strip: ['0', '1', '2', '3', '4', '5'],
            flow: 'hear (word model) → look (count scene) → see the digit + word → say (echo, ungraded)',
            confusables: ['three starts /θ/ — often heard as t or f', 'four and five both start /f/', 'zero is the only two-beat word of the set'],
            tip: 'Count scenes are one art family (same table, same palette, one changing quantity — parallel salience). Tap the scene → the objects pulse one-by-one with the count audio (objects never animate on their own — reduced motion: numbered dot markers appear sequentially instead). The digit is large and always paired with the word; both app-layer text.',
            assets: ['A1-C02-AUD023–027', 'A1-C02-AUD030', 'A1-C02-ILL004–009']
          },
          {
            id: 'S09', type: 'cards', label: 'Repair words and chunks', step: 'STEP 6b · ≈4 min',
            chip: 'the little repair words', cards: repairCards, chunkRule: 'Chunk cards show the whole phrase with a "say it as one thing" link icon — never broken into words for tapping in this lesson.',
            tip: 'The nine cards run as one continuous desk story (frames crop ILL010–014 — no new art mid-flow). Word cards and chunk cards are visually distinct: word cards show ONE word; chunk cards show the whole phrase with a link icon. Echo moments ungraded, never blocking.',
            assets: ['A1-C02-AUD002–010', 'A1-C02-ILL010–014']
          },
          {
            id: 'S10', type: 'practice', label: 'Practice B — numbers, words, chunks', step: 'STEP 6c',
            bank: 'PR-V010–V020 · number items always show the digit row 0–5 as a bottom reference strip',
            digitStrip: ['0', '1', '2', '3', '4', '5'],
            items: prNumWords,
            tip: 'Same one-item-per-screen rhythm as S06. Situation items narrate their frame text aloud optionally (a small speaker chip) — the situation must never be harder to read than the target is to know.',
            assets: ['A1-C02-AUD023–026', 'A1-C02-ILL008', 'A1-C02-ILL010–014']
          },
          {
            id: 'S11', type: 'review', label: 'Blended review + progress', step: 'STEP 6d',
            head: 'The letters, the numbers, and the asking words.',
            lines: ['You can say the letters.', 'You can say the numbers 0–5.', 'You can ask: How do you spell that?'],
            gallery: repairCards, auds: ['AUD029 — alphabet blended', 'AUD030 — numbers blended', 'AUD031 — repair set blended'],
            keepCard: 'Keep one card — it comes back first in the next warm-up.',
            next: 'Next: numbers 6–20 and Are you…?', rings: 3, ringsFilled: 3,
            tip: 'Reuse C1-S09\'s review layout exactly (ritual consistency). The "keep one card" interaction is affective, not scored — it seeds the spaced-review scheduler\'s first interval. End card: a one-line honest preview, no lock.',
            assets: ['A1-C02-AUD029–031']
          }
        ]
      },
      {
        id: 'L02', type: 'V+G', n: 2, title: 'Numbers, Contacts, and Are You…?', time: '≈20 min',
        src: 'A1_C02_L02_LESSON.md',
        screens: [
          {
            id: 'S12', type: 'warmup', label: 'Warm-up — alphabet + 0–5', step: 'STEP 3 · ≈3 min',
            head: 'You know these.', sub: 'Three frames: echo, three one-tap rounds, and Leo\'s wobble.',
            story: 'Leo delivers twenty cups for the community classes; Nina counts them on her fingers (10 + 10).',
            frames: [
              { q: 'Listen. Repeat.', icon: 'loop', aud: 'AUD029', scene: 'Frame 1 — the echo frame never scores', opts: ['A B C D E F'], key: 'A B C D E F' },
              { q: 'Listen. Choose.', icon: 'ear', aud: 'AUD032', scene: 'Frame 2 — three one-tap rounds with the digit strip as reference', opts: ['three', 'five', 'zero'], key: 'five' },
              { q: 'You say:', icon: 'mouth', scene: 'Frame 3 — Leo drops a cup', opts: ['Sorry!', 'Thank you!', 'Yes!'], key: 'Sorry!' }
            ],
            tip: 'Same three-frame rhythm as C2-L01-S03. The echo frame never scores; frame 2 gives three one-tap rounds with the digit strip as reference. Frame 3\'s Sorry! moment resolves Leo\'s wobble with warmth — no blame framing anywhere. Story plays full-screen over ILL015 with per-speaker glow.',
            assets: ['A1-C02-AUD032', 'A1-C02-ILL015']
          },
          {
            id: 'S13', type: 'numbers', label: 'Numbers 6–10', step: 'STEP 4', pat: 'PAT003', chip: 'numbers 6–10',
            head: 'Five more.', nums: nums610, strip: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'], countAlong: 'Count-along at the range\'s end pulses the story-art cups one by one.',
            tip: 'One screen per range keeps the working-memory load at five members. The digit-word card pair is always "7 seven" style, app-layer text; tapping the digit replays the word model. The full number line 0–20 sits as a collapsible bottom strip from S13 onward (visual route for every number item).',
            assets: ['A1-C02-AUD033–037', 'A1-C02-ILL017']
          },
          {
            id: 'S14', type: 'numbers', label: 'Numbers 11–15', step: 'STEP 4b', pat: 'PAT004', chip: 'numbers 11–15',
            head: 'Five more.', nums: nums1115, strip: ['11', '12', '13', '14', '15'],
            note: 'Receptive awareness only that some number words end in a long /iː/ sound — no -ty words are named. The real -teen/-ty contrast belongs to Chapter 5.',
            tip: 'Same range mechanics as S13; the collapsible 0–20 line stays available.',
            assets: ['A1-C02-AUD038–042']
          },
          {
            id: 'S15', type: 'numbers', label: 'Numbers 16–20', step: 'STEP 4c', pat: 'PAT005', chip: 'numbers 16–20',
            head: 'Five more — and that is twenty.', nums: nums1620, strip: ['16', '17', '18', '19', '20'],
            note: 'Nothing above 20 productively in this course level.',
            tip: 'Same range mechanics as S13. The count-along closes on Leo\'s twenty cups (10 + 10).',
            assets: ['A1-C02-AUD043–045', 'A1-C02-ILL017']
          },
          {
            id: 'S16', type: 'cards', label: 'Contact-word cards', step: 'STEP 5 · ≈5 min',
            chip: 'the register', cards: contact,
            spoken: { said: 'maya dot haddad at aroa dot com', written: 'maya.haddad@aroa.com' },
            tip: 'Nine cards, one continuous register-filling story. The email cards show the spoken form in app-layer text with the written form appearing beside it on the final tap — the app, not the art, owns every symbol. Chunk cards keep the "say it as one thing" link icon from L01.',
            assets: ['A1-C02-AUD046–054', 'A1-C02-ILL016–024']
          },
          {
            id: 'S17', type: 'grammarModel', label: 'Grammar model — Are you…? / It\'s…', step: 'STEP 6',
            notice: [
              { aud: 'AUD060', task: 'Who says yes, and who says no?', chat: [{ sp: 'NINA', t: 'Are you Maya?', ask: true }, { sp: 'MAYA', t: 'Yes, I am!' }, { sp: 'NINA', t: 'Are you Leo?', ask: true }, { sp: 'MAYA', t: '(laughs) No, I\'m not!' }] },
              { aud: 'AUD061', task: 'Tap the answer word.', chat: [{ sp: 'NINA', t: 'What\'s your phone number, Maya?', ask: true }, { sp: 'MAYA', t: 'It\'s five, five, five … two, zero, one.' }, { sp: 'NINA', t: 'And your email address?', ask: true }, { sp: 'MAYA', t: 'It\'s maya dot haddad at aroa dot com.' }] },
              { aud: 'AUD062', task: 'One word, one action.', chat: [{ sp: 'NINA', t: 'Listen! … Say! … Repeat! … Choose! … Match!' }] }
            ],
            records: [
              { id: 'G004', title: 'Are you …?', pattern: 'Are you ___? → Yes, I am. / No, I\'m not.', errs: [['Yes, I\'m.', 'the short yes answer keeps the full word: Yes, I am.'], ['No, I not.', 'add the m: No, I\'m not.']] },
              { id: 'G005', title: 'It\'s …', pattern: 'What\'s your ___? → It\'s ___.', errs: [['I\'m M-A-Y-A.', 'letters take It\'s — I\'m is for people.'], ['Its 5-5-5.', 'the answer word has the little mark: It\'s.']] },
              { id: 'G006', title: 'Class words', pattern: 'Action word + (please) + !', errs: [['Listening! / Listens!', 'the class word is the flat form: Listen!']] }
            ],
            dockNote: 'Grammar screens show the pattern card in a fixed bottom dock — tappable any time, never scored.',
            tip: 'S17 plays each model with the pattern displayed under it — the ___ slot glows when spoken.',
            assets: ['A1-C02-AUD060–062']
          },
          {
            id: 'S18', type: 'practice', label: 'Guided grammar', step: 'STEP 6b',
            dock: 'Are you ___? → Yes, I am. / No, I\'m not.   ·   What\'s your ___? → It\'s ___.   ·   Action word + (please) + !',
            bank: 'PR-G001–G030 (G004 ten · G005 ten · G006 ten) · choice → tile order → contextual use, per grammar record, each with the same two-rung hint ladder',
            items: prG2,
            tip: 'S18\'s guided sequence walks choice → tile order → contextual use per grammar record, each with the same two-rung hint ladder as practice items. Keep the pattern dock available throughout.',
            assets: ['A1-C02-AUD060–062', 'A1-C02-AUD016', 'A1-C02-AUD047']
          },
          {
            id: 'S19', type: 'pronPerceive', label: 'Pronunciation — confusables', step: 'STEP 7',
            items: pron2,
            bank: 'PR-P001–P004 · letter confusables · chunked number strings · receptive -teen awareness (no -ty word named)',
            tip: 'Beat-tapping support is a tap-anywhere pulse zone, not a metronome — no timing accuracy is scored, ever. Non-voice route for the digit item: tap the six digits in order on the strip.',
            assets: ['A1-C02-AUD063–066']
          },
          {
            id: 'S20', type: 'practice', label: 'Mixed practice', step: 'STEP 8', interleave: true,
            bank: 'PR-V021–V036 (16 vocabulary items) interleaved with the remaining grammar items',
            items: prVocab2,
            tip: 'Interleave rule as C1-S18: never two same-skill items in a row. Number items keep the 0–20 strip; letter items keep the chart chip.',
            assets: ['A1-C02-AUD033–047', 'A1-C02-AUD061', 'A1-C02-AUD066', 'A1-C02-ILL016–024']
          },
          {
            id: 'S21', type: 'review', label: 'Micro-progress', step: 'STEP 9',
            head: 'Numbers to twenty, and the register words.',
            lines: ['You can say the numbers 0–20.', 'You can give a phone number.', 'You can give an email address.'],
            gallery: contact, auds: ['AUD067 — numbers blended', 'AUD068 — contact set blended'],
            next: 'Next: the check-in conversation — phone AND email versions.', rings: 3, ringsFilled: 2,
            tip: 'Same review ritual as L01-S11.',
            assets: ['A1-C02-AUD067', 'A1-C02-AUD068']
          }
        ]
      },
      {
        id: 'L03', type: 'C+R', n: 3, title: 'A Real Check-In', time: '18–20 min', pause: 'after the listening ladder (≈9 min)',
        src: 'A1_C02_L03_LESSON.md',
        screens: [
          {
            id: 'S22', type: 'conversation', label: 'Conversation play — phone version', step: 'STEP 10',
            pkg: 'A1-C02-D01 — The Check-In · Version P (learning take, phone)',
            scenario: 'Registering at the Community House check-in desk. Nina at the desk with Maya.',
            aud: 'AUD069', lineAud: 'AUD070', delivery: 'learning_slow_clear',
            panels: ['ILL025', 'ILL026', 'ILL027', 'ILL028', 'ILL029'],
            turns: [
              { n: 'T1', sp: 'NINA', t: 'Good morning! Welcome! … Are you Maya Haddad?', d: 'pen over the badge — badge check' },
              { n: 'T2', sp: 'MAYA', t: 'Yes, I am!' },
              { n: 'T3', sp: 'NINA', t: 'Great! … How do you spell Haddad?', d: 'kind, ready to write' },
              { n: 'T4', sp: 'MAYA', t: 'H-A-D-D-A-D.', d: 'evenly, letter by letter' },
              { n: 'T5', sp: 'NINA', t: 'Thank you! … What\'s your phone number?', d: 'pen to the digits row' },
              { n: 'T6', sp: 'MAYA', t: 'It\'s 5-5-5, 2-0-1.', d: 'two small chunks' },
              { n: 'T7', sp: 'NINA', t: '5-5-0, 2-1?', d: 'fast, uncertain read-back' },
              { n: 'T8', sp: 'MAYA', t: 'Can you repeat that, please?', d: 'hand cupped at ear — the repair' },
              { n: 'T9', sp: 'NINA', t: 'Five, five, five. … Two, zero, one.', d: 'slower, chunked, finger counting' },
              { n: 'T10', sp: 'MAYA', t: 'Yes! Thank you, Nina! See you!', d: 'waves, happy' }
            ],
            branch: ['WRONG read-back → say the number again, chunked', 'RIGHT read-back → confirm: "Yes! Correct!"', 'TOO FAST to check → repair: "Can you repeat that, please?" / "Please speak slowly."'],
            lock: 'Transcript unlocks after testlet 1 is scored.',
            tip: 'Storyboard player as C1-S20. All three read-back branches resolve to the same next beat — thanks and farewell. No branch strands the learner.',
            assets: ['A1-C02-AUD069', 'A1-C02-AUD070', 'A1-C02-ILL025–029']
          },
          {
            id: 'S23', type: 'testlet', label: 'Gist task', step: 'STEP 11 · testlet 1',
            rung: 'GIST', support: 'Storyboard visible throughout · items LS001–003 share one full listen; the replay is shared, not reset per item', aud: 'AUD069', ids: 'LS001–003',
            items: ls1,
            tip: 'Items share the full stimulus; dependence documented (each item probes a different layer of the SAME listen; replay shared).',
            assets: ['A1-C02-AUD069']
          },
          {
            id: 'S24', type: 'testlet', label: 'Detail task — Sam checks in', step: 'STEP 11b · testlet 2',
            rung: 'DETAIL', support: 'One fresh stimulus; items walk the digits in sequence', aud: 'AUD072', ids: 'LS004–007',
            note: 'AUD072 verbatim — NINA: "Hello! Are you Sam Rivera?" … SAM: "Yes, I am!" … NINA: "What\'s your phone number?" … SAM: "It\'s 4-0-1, 7-3-2." … NINA: "Thank you, Sam!"',
            digitStrip: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
            items: ls2,
            tip: 'Within-testlet dependence is intentional and documented: who → chunk 1 → chunk 2 → total.',
            assets: ['A1-C02-AUD072', 'A1-C02-ILL027']
          },
          {
            id: 'S25', type: 'testlet', label: 'Challenge take — email version', step: 'STEP 11c · testlet 3',
            rung: 'RESPONSE', support: 'Single fast stimulus; identify → respond → parse · AUD073 verbatim: LEO: "Ah! My email? It\'s leo dot novak at aroa dot com!"',
            aud: 'AUD073', delivery: 'challenge_natural_slow', ids: 'LS008–010 + transfer LS011–016',
            challenge: [
              { n: 'T1', sp: 'ALEX', t: 'Hi, Nina!' },
              { n: 'T2', sp: 'NINA', t: 'Hi, Alex! … Are you Alex Kim?', d: 'badge check' },
              { n: 'T3', sp: 'ALEX', t: 'Yes, I am!' },
              { n: 'T4', sp: 'NINA', t: 'What\'s your email address?', d: 'pen to the message row' },
              { n: 'T5', sp: 'ALEX', t: 'It\'s alex dot kim at aroa dot com.', d: 'natural, connected' },
              { n: 'T6', sp: 'NINA', t: 'Alex dot kim at aroa dot com?', d: 'read-back, rising voice' },
              { n: 'T7', sp: 'ALEX', t: 'Yes! … Okay! See you, Nina!' },
              { n: 'T8', sp: 'NINA', t: 'See you, Alex! … Thank you!' }
            ],
            items: ls3,
            tip: 'Plays once by default with one diagnostic replay; no imagery until after the response. The six transfer items (LS011–016) follow the ladder on the same screen, drawing on the challenge take, the spelled-name strings and the intonation pair.',
            assets: ['A1-C02-AUD071', 'A1-C02-AUD073–076', 'A1-C02-ILL026']
          },
          {
            id: 'S25b', type: 'pronPerceive', label: 'Pronunciation block — letter strings', step: 'STEP 11c · S25b',
            items: pron25b,
            bank: 'PR-P005 (tap the letters N-I-N-A on the chart) · PR-P006 (which letter is last in A-L-E-X)',
            tip: 'The chart route is the non-audio equivalent for both items; strings stay at four letters to keep working memory low.',
            assets: ['A1-C02-AUD074', 'A1-C02-AUD075']
          },
          {
            id: 'S26', type: 'order', label: 'Dialogue order', step: 'STEP 11d',
            demoWords: ['put in order', 'first', 'next', 'last'],
            ids: 'PR-CV008 (4 turns) · PR-CV009 (6 turns, email version)',
            tasks: cvOrder2,
            tip: 'Tap-in sequence with numbered badges, undo by re-tap — no dragging. Lines play via AUD070 before options appear.',
            assets: ['A1-C02-AUD070']
          },
          {
            id: 'S27', type: 'practice', label: 'Best next line', step: 'STEP 11e',
            ids: 'PR-CV001–CV007, CV010–CV016',
            bank: 'the conversation bank minus the two order tasks (S26) · next-turn, intent, branch, substitution and roleplay-prep items',
            items: cvItems2,
            tip: 'Chat-bubble stimulus with the desk frame; options as three reply bubbles. Branch cards keep their situation art so the read-back choice stays concrete.',
            assets: ['A1-C02-AUD069', 'A1-C02-AUD070', 'A1-C02-ILL023', 'A1-C02-ILL024', 'A1-C02-ILL028', 'A1-C02-ILL031', 'A1-C02-ILL032']
          },
          {
            id: 'S28', type: 'reading', label: 'Form reading', step: 'STEP 12',
            kind: 'form', ids: 'PR-RD001–004',
            form: { title: 'Community classes — register', rows: [['NAME', 'Maya Haddad'], ['PHONE', '5-5-5, 2-0-1'], ['EMAIL', 'maya.haddad@aroa.com']] },
            items: rdForm,
            tip: 'Reading text always renders in the app layer (never inside art), Dynamic Type to XL. A "listen to it" button appears only AFTER a correct response.',
            assets: ['A1-C02-ILL028']
          },
          {
            id: 'S28b', type: 'reading', label: 'Message-card reading', step: 'STEP 12 · text type 2',
            kind: 'card', ids: 'PR-RD005–008',
            card: ['Hello!', 'My name is Nina Petrova.', 'My phone number is 5-5-5, 2-0-9.', 'My email is nina.petrova@aroa.com.', 'See you!'],
            items: rdCard,
            tip: 'The second text type keeps the same reading rules — app-layer text over ILL029, no audio until after a correct response.',
            assets: ['A1-C02-ILL029']
          },
          {
            id: 'S29', type: 'emailAssembly', label: 'Email assembly', step: 'STEP 12b',
            id_: 'PR-WR001', instr: 'Put in order.',
            spoken: 'maya dot haddad at aroa dot com',
            tiles: ['aroa', 'maya', 'at', 'com', 'haddad', 'dot', 'dot'],
            key: ['maya', 'dot', 'haddad', 'at', 'aroa', 'dot', 'com'],
            written: 'maya.haddad@aroa.com',
            ok: 'maya dot haddad at aroa dot com — the whole email, said right!',
            no: 'Start with the name, then the small dot.',
            hints: ['Two name parts, one big break.', 'maya • dot • haddad … AT … aroa • dot • com.'],
            safety: 'Fictional address only. The app never asks for a real one.',
            tip: 'The spoken form sits above the tiles; the written form appears on completion. The app, not the art, owns every symbol.',
            assets: ['A1-C02-ILL030']
          },
          {
            id: 'S30', type: 'tiles', label: 'Tiles — phone details', step: 'STEP 12c',
            ids: 'PR-WR002',
            tasks: [
              { id: 'PR-WR002', instr: 'Put in order.', target: 'Nina\'s card frame, phone variant.', tiles: ['is', 'phone', 'My', '5-5-5, 2-0-1.', 'number'], key: ['My', 'phone', 'number', 'is', '5-5-5, 2-0-1.'], ok: 'My phone number is 5-5-5, 2-0-1. — your first details sentence!', no: 'Start with My.', hints: ['Whose number? Mine → My.', 'My → phone → number → is → digits.'] }
            ],
            tip: 'Same tile rules as C1-S29: capitalization and punctuation are real tiles; the finished line animates into a speech bubble at the desk.',
            assets: ['A1-C02-ILL030']
          },
          {
            id: 'S31', type: 'substitution', label: 'Substitution drill', step: 'STEP 12d',
            ids: 'A1-C02-D01 substitution table',
            slots: [
              { slot: 'Badge-check name', opts: ['Maya Haddad', 'Alex Kim', 'Leo Novak', 'Nina Petrova', 'Sam Rivera'] },
              { slot: 'Detail question', opts: ['What\'s your phone number?', 'What\'s your email address?'] },
              { slot: 'Detail answer', opts: ['It\'s 5-5-5, 2-0-1.', 'It\'s 4-0-1, 7-3-2.', 'It\'s alex dot kim at aroa dot com.', 'It\'s maya dot haddad at aroa dot com.'] },
              { slot: 'Repair line', opts: ['Can you repeat that, please?', 'Please speak slowly.'] }
            ],
            note: 'No new language enters through substitution — every cell is a taught record or a bible-fixed fictional datum.',
            tip: 'Echo bank AUD070 plays each chosen line so the learner hears the swap before reading it.',
            assets: ['A1-C02-AUD070']
          },
          {
            id: 'S31b', type: 'pronProduce', label: 'Pronunciation block — say it', step: 'STEP 12d · S31b',
            items: pron31b,
            bank: 'PR-P007–P010 · question intonation · the six-letter spelling · the spoken email · the repair line',
            tip: 'Model waveform + learner waveform stacked, replay for each, skip equal to record. Ungraded throughout; accent, speed and tone are coached, never scored.',
            assets: ['A1-C02-AUD061', 'A1-C02-AUD070', 'A1-C02-AUD076']
          }
        ]
      },
      {
        id: 'L04', type: 'M', n: 4, title: 'The Register Mission', time: '18–20 min',
        src: 'A1_C02_L04_LESSON.md',
        screens: [
          {
            id: 'S32', type: 'missionBrief', label: 'Mission brief', step: 'STEP 13',
            head: 'Your mission: check in at Nina\'s desk.',
            ill: ill('ILL025', 'Nina holds up a blank badge toward smiling Maya across the check-in desk'),
            checklist: ['Badge check — "Are you …?" → "Yes, I am!"', 'Spell your name — letter by letter', 'One detail — your phone number OR your email', 'The read-back — fix it, confirm it, or repair it', 'Close — "Thank you! See you!"'],
            card: { name: 'your choice (safe fictional)', phone: '5-5-5, 2-0-1', email: 'learner@aroa.com' },
            entries: ['Speak', 'Tap'],
            privacy: 'No real personal data, ever. The sample card is provided by the app.',
            tip: 'Five-slot checklist with empty rings (same component as the promise screens — rings fill live during the roleplay). The sample card is tappable mid-mission (a "peek card" that pauses the partner politely — Nina waits with a patient face). VoiceOver reads the checklist as one goal sentence.',
            assets: ['A1-C02-ILL025']
          },
          {
            id: 'S33', type: 'roleplay', label: 'AI roleplay', step: 'STEP 13b',
            spec: 'A1-C02-RP001', partner: 'Nina Petrova', turnLimit: 8,
            opener: 'Good morning! Welcome! … Are you Sam Rivera?',
            checklist: ['name confirmation', 'spelling', 'one detail', 'read-back resolved', 'close'],
            slots: ['name_confirmation', 'spelling', 'one_detail', 'read_back_resolution', 'close'],
            ceiling: 'Known-language ceiling: all of Chapter 1 and C02 L01–L03; nothing above number 20; no third-person be; no there-is.',
            tileGroups: [
              { g: 'confirm', t: ['Yes, I am!', 'No, I\'m not.'] },
              { g: 'spell', t: ['S-A-M', 'How do you spell that?'] },
              { g: 'detail', t: ['It\'s 5-5-5, 2-0-1.', 'It\'s learner@aroa.com'] },
              { g: 'repair', t: ['Can you repeat that, please?', 'Please speak slowly.'] },
              { g: 'close', t: ['Thank you! See you!'] }
            ],
            transcript: [
              { sp: 'NINA', t: 'Good morning! Welcome! … Are you Sam Rivera?' },
              { sp: 'YOU', t: 'Yes, I am!' },
              { sp: 'NINA', t: 'Great! … How do you spell that?' },
              { sp: 'YOU', t: 'S-A-M.' },
              { sp: 'NINA', t: 'Thank you! … What\'s your phone number?' }
            ],
            transcriptNote: 'One illustrative run, assembled from the spec\'s accepted_response_examples — not an authored script.',
            feedback: { strong: ['You confirmed the badge with Yes, I am.', 'You spelled your name letter by letter.'], next: 'Try the repair line when a read-back is wrong.' },
            redirects: ['Nina smiles and taps the register: "One detail, please — the phone number or the email!"', 'Nina holds up the badge card gently: "Name first — how do you spell that?"'],
            ends: ['Success: all five rings filled → Nina writes the last row: "Perfect! Welcome to the classes! See you!"', 'Safe stop: 8 turns or two redirects → Nina closes warmly: "Okay! Again tomorrow? See you!" — rings stay where earned; retry offered, never pushed'],
            fallback: 'Non-voice branching alternative — five nodes: N1 badge check (tap the yes-answer) → N2 spelling (tap the letters of your card name on the chart) → N3 detail choice (tap phone OR email) → N4 read-back event, deliberately WRONG (tap: repeat chunked / repair / confirm) → N5 the warm double close. Same rings, same end screens.',
            tip: 'Same chat-style roleplay component as C1-S31, with the peek card available and the five-dot checklist ribbon filling live. Safe-stop always visible.',
            assets: ['A1-C02-AUD070']
          },
          {
            id: 'S34', type: 'quizIntro', label: 'Quiz intro', step: 'STEP 14',
            head: '26 quick items', meta: ['about 8 minutes', 'you can pause any time'],
            promise: '4 items come back from Chapter 1. Nothing is lost if you stop. Retry as often as you like.',
            tip: 'Same honest framing as C1-S32. No streak or loss language anywhere.',
            assets: []
          },
          {
            id: 'S35', type: 'quiz', label: 'Quiz items', step: 'STEP 14b',
            mix: [['letters', 5], ['numbers', 5], ['vocabulary + repair', 4], ['grammar', 5], ['listening', 4], ['reading', 2], ['discourse', 1]],
            bank: 'Quiz Form A · 26 items · cumulative share 4 items retrieving Chapter 1 (15.4%, band 15–25%) · answer-key balance 9 A / 9 B / 7 C over the 25 choice items',
            note: 'Cumulative items are marked in their ids and cite A1-C01 prerequisites: QZ-V004 (good evening), QZ-LS003 (goodbye), QZ-RD002 (first name), QZ-CN001 (Nice to meet you).',
            items: quiz2,
            tip: 'Same delivery rules as C1-S33: one item per screen-swap, interleaved, quiet progress bar, transcripts only after the whole quiz.',
            assets: ['A1-C02-AUD078', 'A1-C02-ILL033–035']
          },
          {
            id: 'S36a', type: 'tiles', label: 'Guided writing — bank completion', step: 'STEP 15 · WR003–006',
            ids: 'PR-WR003–006',
            tasks: wr36,
            tip: 'Runs after the quiz as calm consolidation: word tiles are app-layer text, tap-sequence only, and nothing here feeds the gate.',
            assets: ['A1-C02-ILL014', 'A1-C02-ILL029–031']
          },
          {
            id: 'S36', type: 'results', label: 'Results', step: 'STEP 15',
            rings: ['letters', 'numbers', 'spell', 'details', 'repair'],
            strong: 'You can spell a name, give a number, and ask for a repeat.',
            developing: 'M and N are close in fast speech — the feel-it hint helps.',
            next: 'a four-minute letters-and-digits review, then Chapter 3!',
            score: 'Pass is ≥21 / 26', gate: 'Pass: 80% overall (21/26) AND ≥70% per core section (letters · numbers · vocab+repair · grammar · listening · reading). Near-pass (a single section 60–69% with overall ≥80%) → that clinic + alternate items. Below → personalised review. Unlimited parallel retries; no permanent lock; no loss framing.',
            tip: 'Identical layout family to C1-S34 (ritual consistency). Retry and continue buttons equal weight and size.',
            assets: []
          },
          {
            id: 'S37', type: 'remediation', label: 'Remediation pick', step: 'STEP 15b',
            head: 'Practice picks', sub: 'Take one, take all, or skip. The schedule adapts either way.',
            clinics: [
              { id: 'C2-CLIN-A', name: 'same-sound letters', benefit: 'B/D/E and M/N minimal pairs, by feel as well as by ear.', n: 8, trigger: 'letters section below 70%' },
              { id: 'C2-CLIN-B', name: 'the first part returns', benefit: 'three → thirTEEN, four → forTEEN, five → fifTEEN.', n: 6, trigger: 'number items on 11–15 wrong' },
              { id: 'C2-CLIN-C', name: 'six or sixteen?', benefit: 'One beat or two — sort the short from the long.', n: 8, trigger: '6-vs-16/17 confusion' },
              { id: 'C2-CLIN-D', name: 'dot and at', benefit: 'The email map: small stops and the big break.', n: 6, trigger: 'email items wrong' },
              { id: 'C2-CLIN-E', name: 'the check and the answer', benefit: 'Are-you vs You-are, with yes/no short answers.', n: 8, trigger: 'G004 items wrong' }
            ],
            pending: 'Clinic items are specified but authored on request as a follow-up micro-session; Form B likewise.',
            tip: 'Clinic cards use the warm palette, never red.',
            assets: []
          },
          {
            id: 'S38', type: 'reviewPlan', label: 'Review plan', step: 'STEP 15c',
            head: 'Your review week', sub: 'Short returns, spaced out. Notifications stay off unless you turn them on.',
            week: [{ d: 'Tue', t: 'Letters A–Z', on: true }, { d: 'Wed', t: '', on: false }, { d: 'Thu', t: 'Numbers 0–20', on: true }, { d: 'Fri', t: '', on: false }, { d: 'Sat', t: 'The check-in', on: true }, { d: 'Sun', t: '', on: false }, { d: 'Mon', t: 'Chapter 3 warm-up', on: true }],
            exports: [['Alphabet PAT001', 'C3 spelling countries, C4 Checkpoint 1, C5'], ['Numbers 0–20', 'C4, C5 (build to 100), C7 clock, C9 prices'], ['Repair chunks V007–V009', 'every conversation chapter; C4 and C9 formal retrieval'], ['Contact set V010–V018', 'C4 Checkpoint 1, C9 service, C10 address and directions'], ['G004 / G005', 'C3 Are you… from?, C4, C7 What time is it? → It\'s …'], ['Chapter 1 set (retrieved 4× this quiz)', 'continues on its own ledger schedule']],
            tip: 'Same calm week-strip as C1-S36.',
            assets: []
          },
          {
            id: 'S39', type: 'chapterMap', label: 'Chapter map / next', step: 'Wrap-up',
            head: 'Chapter 2 complete!',
            body: 'You can spell your name, give a phone number or an email, and ask for a repeat when speech is too fast.',
            next: 'Chapter 3 — Where Are You From?',
            arc: 'Meet and connect', chapters: [{ n: 1, t: 'Hello! My Name Is Alex', s: 'done' }, { n: 2, t: 'Spell It and Share Your Details', s: 'done' }, { n: 3, t: 'Where Are You From?', s: 'next' }, { n: 4, t: 'Checkpoint Review 1', s: 'locked' }],
            tip: 'S39\'s chapter map shows Ch1–2 filled, Ch3 next — one glance, no clutter.',
            assets: []
          }
        ]
      }
    ]
  });
})();
