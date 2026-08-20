#!/usr/bin/env node
// Export the authored course banks (design/course-c{1,2,3}.js) to JSON for the
// native app. The JS banks stay the source of truth — this is a mechanical
// transform, nothing is invented here.
//
//   node tools/export-course-json.mjs
//
// Writes Aurel/Resources/Course/a1-course.json and prints a summary so the
// Swift decode tests can pin the same counts.
//
// Chapter 3 closer: design/course-c3.js ships its last four screens (S29–S32)
// as `pending` placeholders ("not yet authored"), but english_course — the
// content authority — delivers the complete chapter closer in
// A1_C03_L03_LESSON.md: quiz Form A (32 §10.8 records), the results/gate rule,
// the four clinic seeds, the spaced-review export, and the chapter-complete
// wrap-up. replaceC3Quiz() below transcribes that authored content into the
// same screen-type shapes the C1/C2 chapter quizzes use (quizIntro → quiz →
// results → remediation → reviewPlan → chapterMap). Every learner-facing
// string is verbatim from the lesson; the "projection" comments record each
// field mapping, and the parser hard-fails on any count or shape mismatch —
// nothing is ever silently dropped or invented.

import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import vm from 'node:vm';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const banks = ['course-c1.js', 'course-c2.js', 'course-c3.js'];

const ctx = { window: {} };
vm.createContext(ctx);
for (const f of banks) {
  const code = readFileSync(path.join(root, 'design', f), 'utf8');
  vm.runInContext(code, ctx, { filename: f });
}

const course = ctx.window.AUREL_COURSE;
if (!course || !Array.isArray(course.chapters) || course.chapters.length === 0) {
  console.error('export failed: no chapters registered');
  process.exit(1);
}

// ── Chapter 3 quiz — parse the authored §10.8 records, replace S29–S32 ──────

const C3_LESSON = path.join(
  root, 'english_course', '04_A1_chapters', 'A1_C03', 'A1_C03_L03_LESSON.md');
// Lesson §S29 header: "Sections: L5 · N5 · V5 · G6 · LS5 · RD4 · CN2".
const C3_QUIZ_SPEC = { L: 5, N: 5, V: 5, G: 6, LS: 5, RD: 4, CN: 2 };
const C3_QUIZ_TOTAL = 32;

function fail(msg) {
  console.error(`export failed: ${msg}`);
  process.exit(1);
}

// Tolerant reader for the lesson's fenced ```yaml item records (C03 style).
// Handles: quoted scalars (single or double, multi-line folded), flow lists
// [a, b] and flow maps {A: "…"} (both may fold onto more-indented lines),
// block maps (indented `KEY: value` lines), trailing `# comments`, and plain
// scalars that merely contain quotes (RD001's `"Maya's job?" → "…"`).

// Quotes open/close only at token boundaries (start, or after space , : [ {);
// a quote directly after a letter — He's, They're, isn't — is punctuation.
function quoteOpens(prev) { return prev === '' || /[\s,:[{]/.test(prev); }

function stripComment(s) {
  let q = null, prev = '';
  for (let k = 0; k < s.length; k++) {
    const ch = s[k];
    if (q) {
      if (ch === q) { q = null; prev = '"'; }
      continue;
    }
    if ((ch === '"' || ch === "'") && quoteOpens(prev)) { q = ch; continue; }
    if (ch === '#' && (k === 0 || s[k - 1] === ' ')) return s.slice(0, k);
    if (ch !== ' ' && ch !== '\t') prev = ch;
  }
  return s;
}

function cleanLine(s) { return stripComment(s).trim(); }

function unquote(s) {
  const t = s.trim();
  if (t.length >= 2 && t[0] === '"' && t.endsWith('"')) return t.slice(1, -1);
  if (t.length >= 2 && t[0] === "'" && t.endsWith("'")) return t.slice(1, -1);
  return t;
}

function splitTop(s, sep) {
  const parts = [];
  let depth = 0, q = null, prev = '', cur = '';
  for (let k = 0; k < s.length; k++) {
    const ch = s[k];
    if (q) {
      cur += ch;
      if (ch === q) { q = null; prev = '"'; }
      continue;
    }
    if ((ch === '"' || ch === "'") && quoteOpens(prev)) { q = ch; cur += ch; continue; }
    if (ch === '[' || ch === '{') depth++;
    if (ch === ']' || ch === '}') depth--;
    if (ch === sep && depth === 0) { parts.push(cur); cur = ''; prev = ','; continue; }
    cur += ch;
    if (ch !== ' ' && ch !== '\t') prev = ch;
  }
  if (cur.trim() !== '') parts.push(cur);
  return parts.map((p) => p.trim()).filter((p) => p !== '');
}

function readFlowScalar(part) {
  const t = part.trim();
  if (t.startsWith('{')) {
    const obj = {};
    for (const pair of splitTop(t.slice(1, -1), ',')) {
      const kv = /^([A-Za-z_][\w-]*):\s*(.*)$/.exec(pair);
      if (kv) obj[kv[1]] = unquote(kv[2]);
    }
    return obj;
  }
  if (t.startsWith('"') || t.startsWith("'")) return unquote(t);
  return t;
}

function readFlowList(body) { return splitTop(body, ',').map(readFlowScalar); }

// `s` is a quoted scalar only when its last char closes the opening quote and
// no same-quote char sits between — `"Maya's job?" → "Maya is a ____."` is a
// plain scalar that merely contains quotes.
function tryQuoted(s) {
  const q = s[0];
  if (s[s.length - 1] !== q) return null;
  const inner = s.slice(1, -1);
  return inner.includes(q) ? null : inner;
}

// Reads the scalar starting at `text` (the rest of lines[i]), folding more
// indented continuation lines while a quote/bracket stays open.
function readScalar(text, lines, i) {
  let s = cleanLine(text);
  let j = i + 1;
  const openOf = (str) => {
    let q = null, prev = '', br = 0, br2 = 0;
    for (const ch of str) {
      if (q) {
        if (ch === q) { q = null; prev = '"'; }
        continue;
      }
      if ((ch === '"' || ch === "'") && quoteOpens(prev)) { q = ch; continue; }
      if (ch === '[') br++;
      if (ch === ']') br--;
      if (ch === '{') br2++;
      if (ch === '}') br2--;
      if (ch !== ' ' && ch !== '\t') prev = ch;
    }
    return q !== null || br > 0 || br2 > 0;
  };
  while (openOf(s) && j < lines.length) { s += ' ' + cleanLine(lines[j]); j++; }
  if (s.startsWith('[')) return { value: readFlowList(s.slice(1, -1)), next: j };
  if (s.startsWith('{')) {
    const map = {};
    for (const pair of splitTop(s.slice(1, -1), ',')) {
      const kv = /^([A-Za-z_][\w-]*):\s*(.*)$/.exec(pair);
      if (kv) map[kv[1]] = unquote(kv[2]);
    }
    return { value: map, next: j };
  }
  if (s === 'true') return { value: true, next: j };
  if (s === 'false') return { value: false, next: j };
  // Quoted scalar covering the whole value → unquote; a scalar that merely
  // starts with a quote and then continues (RD001's question) stays plain.
  if (s[0] === '"' || s[0] === "'") {
    const inner = tryQuoted(s);
    if (inner !== null) return { value: inner, next: j };
  }
  return { value: s, next: j };
}

function parseRecord(block, firstLineInFile) {
  const lines = block.split('\n');
  const rec = {};
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (!line.trim()) { i++; continue; }
    const m = /^([A-Za-z_][A-Za-z0-9_-]*):(?:[ \t]+(.*))?$/.exec(line);
    if (!m) { i++; continue; } // stray prose inside a fence — tolerated
    const key = m[1];
    const val = m[2] ?? '';
    if (cleanLine(val) === '') {
      // Block map: indented `KEY: value` lines under this key.
      const map = {};
      let j = i + 1;
      while (j < lines.length) {
        const mm = /^([ \t]+)([A-Za-z_][A-Za-z0-9_-]*):[ \t]+(.*)$/.exec(lines[j]);
        if (!mm) break;
        const r = readScalar(mm[3], lines, j);
        map[mm[2]] = r.value;
        j = r.next;
      }
      rec[key] = Object.keys(map).length ? map : '';
      i = j;
      continue;
    }
    const r = readScalar(val, lines, i);
    rec[key] = r.value;
    i = r.next;
  }
  const idLine = lines.findIndex((l) => /^id: /.test(l));
  rec.__line = firstLineInFile + Math.max(0, idLine);
  return rec;
}

function parseQuizRecords() {
  const md = readFileSync(C3_LESSON, 'utf8');
  const out = [];
  const fence = /```yaml\r?\n([\s\S]*?)```/g;
  let hit;
  while ((hit = fence.exec(md)) !== null) {
    const block = hit[1].endsWith('\n') ? hit[1].slice(0, -1) : hit[1];
    if (!/^id: A1-C03-QZ-/m.test(block)) continue;
    const before = md.slice(0, hit.index);
    const firstLine = before.split('\n').length; // 1-based line of the fence body
    out.push(parseRecord(block, firstLine));
  }
  return out;
}

// Authored item records carry no `prompt`/hint/secs/a11y fields (the C1/C2
// quiz records did). The instruction is projected from the authored modality
// onto the bank's fixed instruction lexicon; hints/secs/a11y are omitted
// because they are not authored. Audio ids come from `stimulus_audio`,
// illustration refs from an `ILL…` stimulus, answers from
// `correct_option_ids`, feedback from `feedback_correct/_incorrect`.

const C3_INSTR_BY_TYPE = {
  listening_detail: 'Listen. Choose.',
  listening_reply: 'Listen. Choose.',
  repair_choice: 'Listen. Choose.',
  profile_detail: 'Read. Choose.',
  roll_list_lookup: 'Read. Choose.',
  map_to_word: 'Look. Choose.',
  image_to_word: 'Look. Choose.',
  spelling_choice: 'Look. Choose.',
  canon_digits_recall: 'Look. Choose.',
  number_identification: 'Look. Tap.', // authored stimulus/question says "tap"
  number_word_match: 'Look. Tap.',
};

function instrFor(rec) {
  if (rec.stimulus_audio) return 'Listen. Choose.';
  return C3_INSTR_BY_TYPE[rec.type] ?? 'Choose.';
}

function iconFor(instr) {
  if (instr.startsWith('Listen')) return 'ear';
  if (instr.startsWith('Look') || instr.startsWith('Read')) return 'eye';
  return 'choose';
}

// C1/C2 render digit and letter-string quiz options in the large-print style
// (PracticeItem.big) — same option families here: N003–N005 digits, V004.
function bigFor(opts) {
  return opts.length > 0
    && opts.every((o) => /^[0-9]+$/.test(o.text) || /^[A-Z](?:-[A-Z])*$/.test(o.text));
}

function unquoteMaybe(s) {
  const t = s.trim();
  return (t.startsWith('"') && t.endsWith('"')) || (t.startsWith("'") && t.endsWith("'"))
    ? t.slice(1, -1)
    : t;
}

function promptFor(rec) {
  let stim = typeof rec.stimulus === 'string' ? rec.stimulus : null;
  let q = typeof rec.question === 'string' ? rec.question : null;
  if (q) {
    const arrow = q.indexOf(' → '); // RD001: `"Maya's job?" → "Maya is a ____."`
    if (arrow >= 0) q = q.slice(arrow + 3);
    q = unquoteMaybe(q);
  }
  if (stim && /^ILL\d+\b/.test(stim)) stim = null; // realized as the item art
  const parts = [];
  if (rec.branch_context) parts.push(rec.branch_context);
  if (stim) parts.push(stim);
  if (q) parts.push(q);
  if (parts.length === 0) fail(`quiz item ${rec.id} (line ${rec.__line}) has no stimulus or question`);
  return rec.branch_context ? parts.join(' ') : parts.join(' · ');
}

function projectQuizItem(rec, ills) {
  const item = {
    id: rec.id,
    instr: instrFor(rec),
    icon: iconFor(instrFor(rec)),
  };
  if (rec.stimulus_audio) {
    const aud = /^A1-C03-(AUD\d+)/.exec(rec.stimulus_audio);
    if (!aud) fail(`quiz item ${rec.id} (line ${rec.__line}): no AUD id in stimulus_audio`);
    item.aud = aud[1];
  }
  if (typeof rec.stimulus === 'string') {
    const ill = /^ILL(\d+)\b/.exec(rec.stimulus);
    if (ill) {
      const ref = ills.get(`A1-C03-ILL${ill[1]}`);
      if (!ref) fail(`quiz item ${rec.id} (line ${rec.__line}): ILL${ill[1]} not found in the chapter cards`);
      item.ill = ref;
    }
  }
  if (rec.cumulative_flag === true) item.cumulative = true;
  item.prompt = promptFor(rec);
  item.opts = rec.options.map((o) => ({ id: o.id, t: o.text }));
  if (bigFor(rec.options)) item.big = true;
  item.key = rec.correct_option_ids[0];
  item.ok = rec.feedback_correct;
  item.no = rec.feedback_incorrect;
  if (rec.prerequisites_note) item.note = rec.prerequisites_note;
  return item;
}

function chapterIllIndex(ch) {
  const map = new Map();
  for (const l of ch.lessons) {
    for (const s of l.screens ?? []) {
      if (s.type !== 'cards' || !Array.isArray(s.cards)) continue;
      for (const c of s.cards) if (c.ill && !map.has(c.ill.id)) map.set(c.ill.id, c.ill);
    }
  }
  return map;
}

function replaceC3Quiz(course) {
  const ch = course.chapters.find((c) => c.id === 'A1-C03');
  const l03 = ch?.lessons.find((l) => l.id === 'L03');
  if (!l03) fail('A1-C03 L03 not found in the banks');

  const records = parseQuizRecords();
  if (records.length !== C3_QUIZ_TOTAL) {
    fail(`C3 quiz: expected ${C3_QUIZ_TOTAL} authored records, parsed ${records.length}`
      + ` (${records.map((r) => `${r.id}@${r.__line}`).join(', ')})`);
  }

  const bySection = {};
  for (const rec of records) {
    const m = /^A1-C03-QZ-(L|N|V|G|LS|RD|CN)\d{3}$/.exec(rec.id);
    if (!m) fail(`C3 quiz: unexpected record id ${rec.id} (line ${rec.__line})`);
    bySection[m[1]] = (bySection[m[1]] ?? 0) + 1;
    if (!Array.isArray(rec.options) || rec.options.length < 2
      || rec.options.some((o) => !o.id || typeof o.text !== 'string')) {
      fail(`C3 quiz item ${rec.id} (line ${rec.__line}): malformed options`);
    }
    const ids = rec.options.map((o) => o.id);
    if (!Array.isArray(rec.correct_option_ids) || rec.correct_option_ids.length !== 1
      || !ids.includes(rec.correct_option_ids[0])) {
      fail(`C3 quiz item ${rec.id} (line ${rec.__line}): malformed correct_option_ids`);
    }
    if (typeof rec.feedback_correct !== 'string' || typeof rec.feedback_incorrect !== 'string') {
      fail(`C3 quiz item ${rec.id} (line ${rec.__line}): missing feedback`);
    }
    if (!rec.type) fail(`C3 quiz item ${rec.id} (line ${rec.__line}): missing type`);
  }
  for (const [sec, want] of Object.entries(C3_QUIZ_SPEC)) {
    if ((bySection[sec] ?? 0) !== want) {
      fail(`C3 quiz section ${sec}: expected ${want} items, parsed ${bySection[sec] ?? 0}`);
    }
  }

  const ills = chapterIllIndex(ch);
  const items = records.map((rec) => projectQuizItem(rec, ills));
  const balance = { A: 0, B: 0, C: 0 };
  for (const it of items) balance[it.key] = (balance[it.key] ?? 0) + 1;

  // The four pending placeholders (S29–S32) come out; the authored closer goes
  // in, encoded exactly like the C1/C2 chapter-end flows. All copy below is
  // transcribed from A1_C03_L03_LESSON.md §S29–S32 (+ the manifest quiz/gate
  // section); source lines cited per screen.
  const at = l03.screens.findIndex((s) => s.id === 'S29');
  const pending = l03.screens.filter((s) => s.type === 'pending').map((s) => s.id);
  if (at < 0 || pending.join(',') !== 'S29,S30,S31,S32') {
    fail(`C3 L03: expected pending S29–S32 to replace, found [${pending.join(', ')}]`);
  }

  const clinics = [
    { id: 'C3-CLIN-A', name: 'they is / they are', benefit: 'pronoun↔be mapping with cast cards — exit: 8/10 correct on a fresh sort', n: 10, trigger: 'G007 sort + G001/G005 misses' },
    { id: 'C3-CLIN-B', name: 'his or her?', benefit: 'sound-first his/her drill + canon cards — exit: 8/10 on a fresh possessive set', n: 10, trigger: 'G015–G021 pattern of misses' },
    { id: 'C3-CLIN-C', name: 'a or an?', benefit: 'ear-first trays (say the job, choose the tray) — exit: 9/10 on the nine jobs', n: 10, trigger: 'G023–G030 + QZ-G005 misses' },
    { id: 'C3-CLIN-D', name: "I'm from vs I'm a", benefit: 'question→frame routing drill — exit: 8/10 on mixed frames', n: 10, trigger: 'frame collisions (V010/V033/LS001 type)' }
  ];

  l03.screens.splice(at, 4,
    {
      // Lesson line 562: "S29 — Chapter quiz, Form A (32 items)"; line 564
      // carries the sections, the cumulative share, and the pass rule.
      id: 'S29', type: 'quizIntro', label: 'Quiz intro', step: 'STEP 16',
      head: 'Chapter quiz, Form A',
      meta: ['32 items', 'L5 · N5 · V5 · G6 · LS5 · RD4 · CN2', 'no timer'],
      promise: 'Cumulative: 8/32 = 25.0% — every flagged item cites its prerequisite. Pass = 80% overall + ≥70% per core section; unlimited retries; clinics follow.',
      tip: 'Same honest framing as C1-S32/C2-S34: the item count and the section mix up front, no timer, no streak or loss language.',
      assets: []
    },
    {
      // Lesson lines 566–1004: the 32 §10.8 records, section headers
      // Listening/Numbers/Vocabulary/Grammar/Conversation/Reading/Culture &
      // inclusion, in authored order.
      id: 'S29a', type: 'quiz', label: 'Quiz items', step: 'STEP 16b',
      mix: [['listening', 5], ['numbers', 5], ['vocabulary', 5], ['grammar', 6], ['conversation', 5], ['reading', 4], ['culture & inclusion', 2]],
      bank: `Quiz Form A · 32 items · cumulative share 8 items retrieving Chapter 1 and Chapter 2 (25.0%, band 15–25%) · answer-key balance ${balance.A} A / ${balance.B} B / ${balance.C} C over the 32 choice items`,
      note: 'Cumulative items are flagged in their records and cite A1-C01-* / A1-C02-* prerequisites: N001–N005 retrieve C2 number patterns; L005 retrieves C1; V004 retrieves C2 spelling; LS003 retrieves C2 repair.',
      items,
      tip: 'Section headers with progress; the L-section audio auto-plays once and replay is allowed; no timer. Same delivery rules as C1-S33/C2-S35: one item per screen-swap, quiet progress bar, transcripts only after the whole quiz.',
      assets: ['A1-C03-AUD062–067', 'A1-C03-ILL035', 'A1-C03-ILL036']
    },
    {
      // Lesson line 564 (pass rule) + line 1073 inventory row "per-section
      // bars (pass ≥70%)". "Pass is ≥26 / 32" is the C1/C2 score-line form of
      // the authored 80% rule (80% of 32 → 26). The lesson authors no
      // strong/developing/next copy — those fields stay absent rather than
      // carry invented lines.
      id: 'S30', type: 'results', label: 'Results', step: 'STEP 17',
      rings: ['listening', 'numbers', 'vocabulary', 'grammar', 'conversation', 'reading', 'culture & inclusion'],
      score: 'Pass is ≥26 / 32',
      gate: 'Pass = 80% overall + ≥70% per core section; unlimited retries; clinics follow.',
      tip: 'Per-section bars (pass ≥70%); identical layout family to C1-S34/C2-S36 — retry and continue get equal weight and size. Clinic cards only appear for missed patterns.',
      assets: []
    },
    {
      // Lesson lines 1010–1017: the four clinic rows, transcribed verbatim
      // (name · seed items · exit criterion · trigger; n is the fresh-set size
      // each exit criterion names). head/sub are the family copy the C3 bank
      // itself commits to in the pending S31 tip.
      id: 'S30a', type: 'remediation', label: 'Remediation pick', step: 'STEP 17b',
      head: 'Practice picks',
      sub: 'Take one, take all, or skip. The schedule adapts either way.',
      clinics,
      pending: 'Clinic seeds author on request — the seeds above reuse chapter art (the C3 ILL block is complete at 36/36).',
      tip: 'Clinic cards use the warm palette, never red. Same family as C1-S35/C2-S37.',
      assets: []
    },
    {
      // Lesson lines 1019–1026: the spaced-review export table. The authored
      // 1/3/7/14/30 intervals do not map onto the weekday week-strip, so the
      // strip stays empty; each exports row merges the table's two return
      // columns under their authored headers.
      id: 'S31', type: 'reviewPlan', label: 'Review plan', step: 'STEP 17c',
      head: 'Spaced-review export',
      sub: '1/3/7/14/30 plan',
      exports: [
        ['all 36 L1 records', 'Ch4 (checkpoint 1): welcome-day mission + checkpoint quiz · later returns: jobs V017–025 → Ch7 routines; V035/V036 → Ch7'],
        ['G007–G009', 'Ch4 (checkpoint 1): checkpoint grammar sweep · later returns: G008 → Ch5 G010 contrast; G009 → every job use'],
        ['C2 patterns (0–20)', 'Ch4 (checkpoint 1): rolling (N sections) · later returns: C5 extends 21–100'],
        ['C1 chunks', 'Ch4 (checkpoint 1): greeting beats of the mission · later returns: Ch4 mission framing']
      ],
      tip: 'Calendar-style return map; the Ch4 checkpoint is flagged. Same calm family as C1-S36/C2-S38.',
      assets: []
    },
    {
      // Lesson lines 1028–1030 + 1076: chapter complete — the three lesson
      // stars are the chapter rows filling done, the can-do checklist is the
      // body (the five manifest can-dos, verbatim), the Ch4 preview card ends
      // the arc. Chapter titles as established on C2-S39.
      id: 'S32', type: 'chapterMap', label: 'Chapter map / next', step: 'Wrap-up',
      head: 'Chapter 3 complete!',
      body: 'ask and answer origin · state language(s) · state role/job · introduce another person · understand short identity profiles',
      next: 'Chapter 4 — Checkpoint Review 1: Welcome-Day Mission',
      arc: 'Meet and connect',
      chapters: [
        { n: 1, t: 'Hello! My Name Is Alex', s: 'done' },
        { n: 2, t: 'Spell It and Share Your Details', s: 'done' },
        { n: 3, t: 'Where Are You From?', s: 'done' },
        { n: 4, t: 'Checkpoint Review 1', s: 'next' }
      ],
      tip: 'Chapter complete: three lesson stars (the chapter rows fill), can-do self-tap checklist (the body line), Ch4 preview card. Same ritual as C1-S37/C2-S39.',
      assets: []
    });

  delete l03.partial; // the closer is delivered — the placeholder marker is stale

  console.log(
    `C3 quiz: parsed ${records.length} §10.8 records `
    + `(line ${records[0].__line}–${records[records.length - 1].__line}), `
    + `key balance ${balance.A} A / ${balance.B} B / ${balance.C} C, `
    + `S29–S32 pending → quizIntro/quiz/results/remediation/reviewPlan/chapterMap`);
}

// ── run ─────────────────────────────────────────────────────────────────────

replaceC3Quiz(course);

const out = path.join(root, 'Aurel', 'Resources', 'Course');
mkdirSync(out, { recursive: true });
const dest = path.join(out, 'a1-course.json');
writeFileSync(dest, JSON.stringify(course.chapters, null, 1) + '\n');

// ── summary ────────────────────────────────────────────────────────────────
const screenTypes = new Map();
let screens = 0, practices = 0, quiz = 0;
for (const ch of course.chapters) {
  const chScreens = ch.lessons.reduce((n, l) => n + (l.screens?.length ?? 0), 0);
  screens += chScreens;
  console.log(`${ch.id} "${ch.title}" — ${ch.lessons.length} lessons, ${chScreens} screens`);
  for (const l of ch.lessons) {
    for (const s of l.screens ?? []) {
      screenTypes.set(s.type, (screenTypes.get(s.type) ?? 0) + 1);
      const count = (p) => (Array.isArray(s[p]) ? s[p].length : 0);
      practices += count('pr') + count('items') + count('bank') + count('bankA') + count('bankB') + count('quiz');
      quiz += count('quiz');
    }
  }
}
console.log('\nscreen types:', JSON.stringify(Object.fromEntries([...screenTypes.entries()].sort())));
console.log(`total screens: ${screens}`);
console.log(`wrote ${dest}`);
