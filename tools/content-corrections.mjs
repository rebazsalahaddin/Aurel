// The documented content-drift ledger, made executable.
//
// design/ banks are never edited; english_course/ is the content authority.
// Every entry asserts the bank's CURRENT value (`expect`) before replacing it
// with the AUTHORED value (`value`), so a later design/ edit that touches a
// corrected field fails the export loudly ("prune this correction") instead
// of drifting silently. Defect IDs reference qa/defects.md.

export const CONTENT_CORRECTIONS = [
  // S1-005 · lesson titles (A1_C02_L02_LESSON.md:1, A1_C03_L03_LESSON.md:1)
  { chapter: 'A1-C02', lesson: 'L02', field: 'title',
    expect: 'Numbers, Contacts, and Are You…?',
    value: 'Big Numbers and Contact Details' },
  { chapter: 'A1-C03', lesson: 'L03', field: 'title',
    expect: 'Profile Cards and Your Dot',
    value: 'Profiles, Your Introduction, the Chapter Quiz' },

  // S1-006 · C2 Set C illustration assignments, V010–V018 — authored pairs
  // from the A1_C02_L02_LESSON.md vocab records (briefs: ILL018 phone ·
  // ILL019 email · ILL020 address · ILL021 at · ILL022 dot · ILL024 register)
  { chapter: 'A1-C02', card: 'V010', field: 'ill',
    expect: { id: 'A1-C02-ILL016', alt: "A simple phone lies on the register page beside Nina's pen" },
    value: { id: 'A1-C02-ILL018', alt: 'Maya holds up a simple rounded mobile phone with a blank screen' } },
  { chapter: 'A1-C02', card: 'V011', field: 'ill',
    expect: { id: 'A1-C02-ILL024', alt: 'The register page: a name row, a digits row and a message row' },
    value: { id: 'A1-C02-ILL018', alt: 'Nina points at the digits row of the open register' } },
  { chapter: 'A1-C02', card: 'V012', field: 'ill',
    expect: { id: 'A1-C02-ILL018', alt: 'A small envelope shape resting on the message row of the register' },
    value: { id: 'A1-C02-ILL019', alt: 'A paper envelope with a small closed flap flies toward an open laptop' } },
  { chapter: 'A1-C02', card: 'V013', field: 'ill',
    expect: { id: 'A1-C02-ILL024', alt: 'The message row of the register page, waiting to be filled' },
    value: { id: 'A1-C02-ILL019', alt: 'Nina underlines the email line of the open register' } },
  { chapter: 'A1-C02', card: 'V014', field: 'ill',
    expect: { id: 'A1-C02-ILL019', alt: 'A door with a small plate beside it, no letters shown' },
    value: { id: 'A1-C02-ILL020', alt: 'A small house with a blank plaque beside the door' } },
  { chapter: 'A1-C02', card: 'V015', field: 'ill',
    expect: { id: 'A1-C02-ILL020', alt: 'A round looping mark drawn on the message row' },
    value: { id: 'A1-C02-ILL021', alt: 'A hand with one finger pointing directly at a community-house door' } },
  { chapter: 'A1-C02', card: 'V016', field: 'ill',
    expect: { id: 'A1-C02-ILL021', alt: 'A single small round mark on the message row' },
    value: { id: 'A1-C02-ILL022', alt: 'One round dot sits between two blank word-tiles on a line' } },
  { chapter: 'A1-C02', card: 'V017', field: 'ill',
    expect: { id: 'A1-C02-ILL022', alt: 'Nina moves her pen to the digits row and looks up' },
    value: { id: 'A1-C02-ILL024', alt: 'Nina circles the digits row of the register with her pen and looks up' } },
  { chapter: 'A1-C02', card: 'V018', field: 'ill',
    expect: { id: 'A1-C02-ILL023', alt: 'Nina moves her pen to the message row and looks up' },
    value: { id: 'A1-C02-ILL024', alt: 'Nina circles the email line of the register with her pen and looks up' } },

  // S2-007 · C3 practice option order — the bank rotated the authored answer
  // into slot A (remapping the key); the authored order puts it at C.
  { chapter: 'A1-C03', item: 'PR-RD003', field: 'opts',
    expect: { opts: 'A:Their|B:His|C:Her', key: 'A' },
    value: { opts: [{ id: 'A', t: 'His' }, { id: 'B', t: 'Her' }, { id: 'C', t: 'Their' }], key: 'C' } },
  { chapter: 'A1-C03', item: 'PR-RD005', field: 'opts',
    expect: { opts: 'A:Nina|B:Maya|C:Kenji', key: 'A' },
    value: { opts: [{ id: 'A', t: 'Kenji' }, { id: 'B', t: 'Maya' }, { id: 'C', t: 'Nina' }], key: 'C' } },
  { chapter: 'A1-C03', item: 'PR-LS012', field: 'opts',
    expect: { opts: 'A:Japanese and English|B:Arabic and English|C:English and French', key: 'A' },
    value: { opts: [{ id: 'A', t: 'Arabic and English' }, { id: 'B', t: 'English and French' }, { id: 'C', t: 'Japanese and English' }], key: 'C' } },
  { chapter: 'A1-C03', item: 'PR-CV016', field: 'opts',
    expect: { opts: 'A:This is my friend Maya.|B:Her is Maya.|C:Nice to meet you too.', key: 'A' },
    value: { opts: [{ id: 'A', t: 'Her is Maya.' }, { id: 'B', t: 'Nice to meet you too.' }, { id: 'C', t: 'This is my friend Maya.' }], key: 'C' } },

  // S2-008 · feedback copy — authored strings verbatim (A1_C01 lesson records)
  { chapter: 'A1-C01', item: 'PR-V014', field: 'ok',
    expect: 'Yes — no!',
    value: 'Yes — no! 🙂' },
  { chapter: 'A1-C01', item: 'QZ-WR001', field: 'no',
    expect: 'The asking hook (?) ends the line.',
    value: 'The asking hook (? ) ends the line.' },

  // S2-009 · C2 V009 headword (A1_C02 vocab record spelling)
  { chapter: 'A1-C02', card: 'V009', field: 'w',
    expect: 'Please speak slowly',
    value: 'Please speak slowly.' },

  // S2-004(b) · QZ-N005 stimulus alt (A1_C02_L04_LESSON.md:764 ILL033 record)
  { chapter: 'A1-C02', item: 'QZ-N005', field: 'itemIllAlt',
    expect: 'Nine cups in a three-by-three grid',
    value: 'Exactly nine cups stand in a neat three-by-three grid on the table' },

  // S2-010 · card alts that paraphrase the authored alt_text (13 standalone
  // instances; V010–V018 above carry the other nine inside the ill swap)
  { chapter: 'A1-C01', card: 'V017', field: 'cardAlt',
    expect: 'Leo gives a gentle content nod with a soft small smile, feeling fine',
    value: 'Leo gives a gentle content nod with a soft smile, feeling fine' },
  { chapter: 'A1-C01', card: 'V019', field: 'cardAlt',
    expect: 'Alex raises both arms high with a big open smile, feeling great',
    value: 'Alex raises both arms with a big open smile, feeling great' },
  { chapter: 'A1-C01', card: 'V020', field: 'cardAlt',
    expect: 'Leo gives an easy shoulder shrug with open palms and a small friendly smile — not bad',
    value: 'Leo gives an easy shrug with a small friendly smile — not bad' },
  { chapter: 'A1-C01', card: 'V021', field: 'cardAlt',
    expect: 'A blank name badge pinned to a shirt with two empty line shapes — a shorter top line and a longer bottom line',
    value: 'A blank name badge pinned to a shirt, with two empty line shapes where names go' },
  { chapter: 'A1-C01', card: 'V024', field: 'cardAlt',
    expect: 'Alex gestures with an open hand toward the blank badge on their own chest while introducing themselves',
    value: 'Alex gestures toward the blank badge on their own chest while speaking' },
  { chapter: 'A1-C01', card: 'V026', field: 'cardAlt',
    expect: 'Maya leans slightly toward you with an open hand, asking a friendly question',
    value: 'Maya leans in with an open hand, asking a friendly question' },
  { chapter: 'A1-C01', card: 'V027', field: 'cardAlt',
    expect: 'Nina and Leo shake hands warmly at their first meeting, both smiling genuinely',
    value: 'Nina and Leo shake hands warmly at their first meeting, both smiling' },
  { chapter: 'A1-C02', card: 'V003', field: 'cardAlt',
    expect: 'Three sound dots sit widely spaced between two people',
    value: 'Three sound dots sit widely spaced between two calm faces' },
  { chapter: 'A1-C02', card: 'V004', field: 'cardAlt',
    expect: 'A loop arrow circles a play triangle',
    value: 'A circular loop arrow wraps around a small play triangle above two seated people' },
  { chapter: 'A1-C02', card: 'V007', field: 'cardAlt',
    expect: 'Nina tilts her head at the badge, pen ready',
    value: 'Nina tilts her head at a blank badge with her pen ready to write letters' },
  { chapter: 'A1-C02', card: 'V008', field: 'cardAlt',
    expect: 'A listener cups one hand at their ear while Nina leans in kindly',
    value: 'A learner cups a hand behind an ear and smiles politely while Nina leans in kindly' },
  { chapter: 'A1-C02', card: 'V009', field: 'cardAlt',
    expect: 'The sound dots stretch wide apart again',
    value: 'Nina speaks calmly with three sound dots spaced widely between her and a listener' },
  { chapter: 'A1-C03', card: 'V032', field: 'cardAlt',
    expect: 'Figure asking a question, one hand raised, question-shaped bubble (no letters)',
    value: 'figure asking a question, one hand raised, question-mark-shaped bubble (no letters)' },
];
