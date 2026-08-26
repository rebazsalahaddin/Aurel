#!/usr/bin/env node
// Content-conformance manifest exporter.
//
//   node tools/export-content-manifest.mjs
//
// Fence-scans english_course/04_A1_chapters (the content authority — read-only)
// into AurelTests/Fixtures/course-manifest.json, so ContentConformanceTests can
// join the authored records against the app's shipped Aurel/Resources/Course/
// a1-course.json without a YAML dependency.
//
// Scope: A1_C01–A1_C03 are parsed deeply (per-record field extraction); A1_C04
// and A1_C05 are reported as record counts only (owner decision 1: this QA run
// verifies C1–C3; design/ banks stop at C3). Blocks that cannot be parsed are
// recorded in parse.skipped with a reason and a file:line location — the gate
// metric is ZERO skipped records for C01–C03.
//
// The YAML in the lesson files is not strict (documented deviations: trailing
// parentheticals on `instruction`, folded multi-line flow maps, block sequences
// of flow maps, literal-block scalars), so parsing is tolerant per-field regex
// work — the same reader family tools/export-course-json.mjs uses for the C3
// quiz records. Nothing outside english_course/ is read; nothing inside it is
// written.

import { existsSync, readFileSync, writeFileSync, mkdirSync, readdirSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const activeCourseRoot = path.join(root, 'english_course', '04_A1_chapters');
const archivedCourseRoot = path.join(root, 'Archive', 'english_course', '04_A1_chapters');
const chaptersRoot = existsSync(activeCourseRoot) ? activeCourseRoot : archivedCourseRoot;
const deepDirs = ['A1_C01', 'A1_C02', 'A1_C03'];
const reportOnlyDirs = ['A1_C04', 'A1_C05'].filter((dir) =>
  existsSync(path.join(chaptersRoot, dir))
);
const deepSet = new Set(deepDirs);

const parse = {
  yamlBlocks: 0,
  jsonBlocks: 0,
  textBlocks: 0,
  blocksScanned: 0,
  skipped: [],
};

function fail(msg) {
  console.error(`manifest export failed: ${msg}`);
  process.exit(1);
}

// ── Tolerant reader (same family as export-course-json.mjs) ─────────────────
// Quotes open/close only at token boundaries (start, or after space , : [ {);
// a quote directly after a letter — He's, They're, isn't — is punctuation.

function quoteOpens(prev) {
  return prev === '' || /[\s,:[{]/.test(prev);
}

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

function openBrackets(str) {
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
}

// Reads the scalar starting at `text` (the rest of lines[i]), folding more-
// indented continuation lines while a quote/bracket stays open (the documented
// C3 fold at A1_C03_L03_LESSON.md:815–816 rides this), and — YAML plain-scalar
// rule — any further more-indented non-item line under a plain scalar.
function readScalar(text, lines, i) {
  let s = cleanLine(text);
  let j = i + 1;
  const plain = s !== '' && !'[{|"'.includes(s[0]) && !s.startsWith("'") ;
  while (j < lines.length && /^\s/.test(lines[j]) && !/^\s*- /.test(lines[j])) {
    if (!openBrackets(s) && !plain) break;
    if (!openBrackets(s)) {
      // Plain scalar: a deeper `KEY:` line starts a new mapping, not a fold.
      if (/^\s+[A-Za-z_][A-Za-z0-9_-]*:/.test(lines[j])) break;
    }
    s += ' ' + cleanLine(lines[j]);
    j++;
  }
  if (s === '') return { value: '', next: j };
  if (s === 'null' || s === '~') return { value: null, next: j };
  if (s === 'true') return { value: true, next: j };
  if (s === 'false') return { value: false, next: j };
  if (/^-?\d+(?:\.\d+)?$/.test(s)) return { value: Number(s), next: j };
  if (s.startsWith('[')) return { value: readFlowList(s.slice(1, -1)), next: j };
  if (s.startsWith('{')) {
    const map = {};
    for (const pair of splitTop(s.slice(1, -1), ',')) {
      const kv = /^([A-Za-z_][\w-]*):\s*(.*)$/.exec(pair);
      if (kv) map[kv[1]] = unquote(kv[2]);
    }
    return { value: map, next: j };
  }
  if (s === '|' || s === '>' || s === '>-' || s === '|-') {
    // Literal/folded block scalar: keep the indented body verbatim.
    const body = [];
    while (j < lines.length && (lines[j].startsWith('  ') || lines[j].trim() === '')) {
      body.push(lines[j].replace(/^  /, ''));
      j++;
    }
    return { value: body.join('\n').replace(/\n+$/, ''), next: j };
  }
  if (s[0] === '"' || s[0] === "'") {
    const inner = tryQuoted(s);
    if (inner !== null) return { value: inner, next: j };
  }
  return { value: s, next: j };
}

// A block value: either an indented `KEY: value` map, or a `- item` sequence.
function readBlockValue(lines, i) {
  const map = {};
  const seq = [];
  let j = i;
  let sawSeq = false, sawMap = false;
  while (j < lines.length) {
    const line = lines[j];
    if (line.trim() === '') { j++; continue; }
    if (!/^\s/.test(line)) break;
    const mm = /^\s+([A-Za-z_][A-Za-z0-9_-]*):(?:[ \t]+(.*))?$/.exec(line);
    if (mm) {
      if (sawSeq) break;
      sawMap = true;
      const val = mm[2] ?? '';
      if (cleanLine(val) === '') {
        // Nested block under this key — keep raw joined text (shallow fields only).
        let k = j + 1;
        const body = [];
        while (k < lines.length && /^\s{2,}/.test(lines[k])) { body.push(lines[k].trim()); k++; }
        map[mm[1]] = body.join(' ');
        j = k;
        continue;
      }
      const r = readScalar(val, lines, j);
      map[mm[1]] = r.value;
      j = r.next;
      continue;
    }
    const ms = /^\s+-\s*(.*)$/.exec(line);
    if (ms) {
      if (sawMap) break;
      sawSeq = true;
      const r = readScalar(ms[1], lines, j);
      seq.push(r.value);
      j = r.next;
      continue;
    }
    break;
  }
  if (sawSeq) return { value: seq, next: j };
  if (sawMap) return { value: map, next: j };
  return { value: null, next: j };
}

function parseYamlRecord(block) {
  const lines = block.split('\n');
  const rec = {};
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (line.trim() === '') { i++; continue; }
    const m = /^([A-Za-z_][A-Za-z0-9_-]*):(?:[ \t]+(.*))?$/.exec(line);
    if (!m) { i++; continue; } // stray prose inside a fence — tolerated
    const key = m[1];
    const val = m[2] ?? '';
    if (cleanLine(val) === '') {
      const r = readBlockValue(lines, i + 1);
      rec[key] = r.value === null ? '' : r.value;
      i = r.next;
      continue;
    }
    const r = readScalar(val, lines, i);
    rec[key] = r.value;
    i = r.next;
  }
  const idLine = lines.findIndex((l) => /^(id|package_id): /.test(l));
  rec.__lineOffset = Math.max(0, idLine);
  return rec;
}

// ── Field normalization ──────────────────────────────────────────────────────

// `instruction: "Listen. Choose." (ear icon + hand icon)` → the parenthetical
// is an authoring aside, not part of the learner string (A1_C01_L01:327 class).
function splitTrailingParenthetical(value) {
  if (typeof value !== 'string') return { value, aside: null };
  const m = /^(.*?)\s*\(([^()()]*(?:\([^()]*\)[^()()]*)*)\)\s*$/.exec(value);
  if (!m || m[1].trim() === '') return { value, aside: null };
  return { value: unquote(m[1].trim()), aside: m[2].trim() };
}

function audFromRef(value) {
  if (typeof value !== 'string') return null;
  const m = /\bA1-C\d\d-AUD\d+\b/.exec(value);
  return m ? m[0] : null;
}

function illFromRef(value) {
  if (typeof value !== 'string') return null;
  const m = /\bA1-C\d\d-ILL\d+\b/.exec(value);
  return m ? m[0] : null;
}

// Normalizes one options value (flow list of flow maps / block sequence / json
// array) into ordered {id, text?, ill?, asset?} entries.
function normalizeOptions(options) {
  if (!Array.isArray(options)) return null;
  return options.map((o) => {
    if (typeof o === 'string') return { text: o };
    if (typeof o !== 'object' || o === null) return { text: String(o) };
    const out = {};
    if (o.id !== undefined) out.id = String(o.id);
    if (typeof o.text === 'string') out.text = o.text;
    else if (typeof o.t === 'string') out.text = o.t;
    if (typeof o.illustration_asset_id === 'string' && o.illustration_asset_id !== 'null') {
      out.ill = o.illustration_asset_id;
    } else if (typeof o.asset === 'string') {
      out.asset = o.asset;
      const ill = illFromRef(o.asset);
      if (ill) out.ill = ill;
    }
    return out;
  });
}

function normalizeStimulus(stimulus) {
  if (stimulus === null || stimulus === undefined) return null;
  if (typeof stimulus === 'string') return { text: stimulus };
  if (typeof stimulus === 'object') {
    const out = {};
    if (typeof stimulus.text === 'string' && stimulus.text !== 'null') out.text = stimulus.text;
    if (typeof stimulus.audio_asset_id === 'string' && stimulus.audio_asset_id !== 'null') {
      out.audio = stimulus.audio_asset_id;
    } else if (typeof stimulus.audio_asset_ids === 'string' && stimulus.audio_asset_ids.startsWith('[')) {
      out.audios = readFlowList(stimulus.audio_asset_ids.slice(1, -1)).map((a) => String(a));
    }
    if (
      typeof stimulus.illustration_asset_id === 'string'
      && stimulus.illustration_asset_id !== 'null'
    ) {
      out.illustration = stimulus.illustration_asset_id;
    }
    return Object.keys(out).length ? out : null;
  }
  return null;
}

function stringOrNullOrUndefined(v) {
  return typeof v === 'string' ? v : null;
}

// Practice/quiz record → the normalized projection the conformance tests join
// against. Field aliases: C1/C2 quiz (json) `prompt`; C3 quiz `question` +
// string `stimulus`; C1/C2 practice `instruction` (+ `stimulus` flow map);
// C3 practice `instruction_words` + `stimulus`/`stimulus_audio`.
function normalizePracticeLike(rec, source) {
  const out = {
    id: rec.id,
    kind: null, // filled by caller
    source,
  };
  const component = stringOrNullOrUndefined(rec.component)
    ?? stringOrNullOrUndefined(rec.type);
  if (component) out.component = component;
  const subskill = stringOrNullOrUndefined(rec.subskill);
  if (subskill) out.subskill = subskill;
  const responseType = stringOrNullOrUndefined(rec.response_type);
  if (responseType) out.responseType = responseType;

  const instruction = splitTrailingParenthetical(stringOrNullOrUndefined(rec.instruction));
  if (instruction.value !== null) {
    out.instruction = instruction.value;
    if (instruction.aside) out.aside = instruction.aside;
  }
  if (Array.isArray(rec.instruction_words)) {
    out.instructionWords = rec.instruction_words.map((w) => String(w));
  }
  const prompt = stringOrNullOrUndefined(rec.prompt);
  if (prompt !== null) {
    // C1/C2 quiz prompts embed the instruction ("Look. Choose. The meeting
    // starts:") — keep verbatim; the bank splits it, so also expose the tail.
    out.prompt = prompt;
  }
  const question = stringOrNullOrUndefined(rec.question);
  if (question !== null) out.question = question;
  if (rec.stimulus !== undefined) {
    const s = normalizeStimulus(rec.stimulus);
    if (s) out.stimulus = s;
  }
  if (typeof rec.stimulus_audio === 'string') {
    out.stimulusAudio = audFromRef(rec.stimulus_audio) ?? rec.stimulus_audio;
  }
  const branchContext = stringOrNullOrUndefined(rec.branch_context);
  if (branchContext) out.branchContext = branchContext;
  if (rec.cumulative_flag === true) out.cumulative = true;
  const note = stringOrNullOrUndefined(rec.prerequisites_note);
  if (note) out.prerequisitesNote = note;

  const options = normalizeOptions(rec.options);
  if (options) out.options = options;
  else if (typeof rec.options === 'string' && rec.options) out.optionsNote = rec.options;
  if (Array.isArray(rec.tiles)) out.tiles = rec.tiles.map((t) => String(t));
  if (Array.isArray(rec.pairs)) out.pairs = rec.pairs;
  if (Array.isArray(rec.correct_order)) {
    out.correctOrder = rec.correct_order.map((t) => String(t));
  } else if (typeof rec.correct_order === 'string') {
    out.correctOrderNote = rec.correct_order;
  }
  if (rec.solution && typeof rec.solution === 'object') out.solution = rec.solution;

  if (Array.isArray(rec.correct_option_ids)) {
    out.key = rec.correct_option_ids.map((k) => String(k));
  } else if (typeof rec.correct_option_ids === 'string') {
    out.key = [rec.correct_option_ids];
  }
  const ok = stringOrNullOrUndefined(rec.feedback_correct);
  if (ok !== null) out.ok = ok;
  const no = stringOrNullOrUndefined(rec.feedback_incorrect);
  if (no !== null) out.no = no;
  if (Array.isArray(rec.hint_ladder)) out.hints = rec.hint_ladder.map((h) => String(h));
  if (typeof rec.estimated_seconds === 'number') out.secs = rec.estimated_seconds;
  if (Array.isArray(rec.accessibility_tags)) {
    out.a11y = rec.accessibility_tags.map((a) => String(a));
  }
  return out;
}

function normalizeVocab(rec, source) {
  const out = { id: rec.id, kind: 'vocab', source };
  const headword = stringOrNullOrUndefined(rec.headword_or_phrase);
  if (headword) out.headword = headword;
  const spelling = stringOrNullOrUndefined(rec.primary_spelling);
  if (spelling) out.spelling = spelling;
  const fn = stringOrNullOrUndefined(rec.part_of_speech_or_function);
  if (fn) out.fn = fn;
  const frame = stringOrNullOrUndefined(rec.core_collocation_or_frame);
  if (frame) out.frame = frame;
  if (Array.isArray(rec.audio_asset_ids) && rec.audio_asset_ids.length) {
    out.aud = rec.audio_asset_ids[0];
  } else if (typeof rec.audio_asset_ids === 'string') {
    out.aud = audFromRef(rec.audio_asset_ids);
  }
  const ill = stringOrNullOrUndefined(rec.illustration_asset_id);
  // Keep "" (C2 V005/V006: app-layer icon, no unique art by design) distinct
  // from a missing field.
  if (ill !== null) out.ill = ill;
  const alt = stringOrNullOrUndefined(rec.alt_text);
  if (alt) out.alt = alt;
  return out;
}

function normalizeIll(rec, source) {
  const out = { id: rec.id, kind: 'ill', source };
  const alt = stringOrNullOrUndefined(rec.alt_text);
  if (alt) out.alt = alt;
  const slot = stringOrNullOrUndefined(rec.embedding_slot);
  if (slot) out.embeddingSlot = slot;
  const semantic = stringOrNullOrUndefined(rec.semantic_target);
  if (semantic) out.semanticTarget = semantic;
  return out;
}

function normalizeShallow(rec, kind, source) {
  return { id: rec.id, kind, source };
}

// ── Record classification ───────────────────────────────────────────────────

const KIND_PATTERNS = [
  [/^A1-C\d\d-L\d\d-V\d+$/, 'vocab'],
  // C1/C2 "A1-C01-PR-V001" and C3 "A1-C03-L01-PR-V001" carry the PR- prefix;
  // C3's guided-writing records are "A1-C03-L03-WR001" without it.
  [/^A1-C\d\d(?:-L\d\d)?-PR-[A-Z]+\d+$/, 'practice'],
  [/^A1-C\d\d-L\d\d-WR\d+$/, 'practice'],
  [/^A1-C\d\d-QZ-[A-Z]+\d+$/, 'quiz'],
  [/^A1-C\d\d-ILL\d+$/, 'ill'],
  [/^A1-C\d\d-L\d\d-G\d+$/, 'grammar'],
  [/^A1-C\d\d-L\d\d-PAT\d+$/, 'pattern'],
  [/^A1-C\d\d-RP\d+$/, 'roleplay'],
  [/^A1-C\d\d-D\d+$/, 'dialogue'],
  [/^A1-C\d\d-AUD\d+$/, 'audio'],
  [/^A1-C\d\d-MISSION-[A-Z-]+$/, 'mission'],
  [/^A1-CP\d-[A-Z]+\d+$/, 'checkpoint'],
  [/^A1-C\d\d-CL\d-[A-Z]+\d+$/, 'clinic'],
  [/^A1-C\d\d-R[A-Z]+\d+$/, 'retrieval'],
];

function classify(id) {
  for (const [re, kind] of KIND_PATTERNS) if (re.test(id)) return kind;
  return 'other';
}

// Deep-record validation: a practice/quiz/vocab record whose load-bearing
// fields did not survive parsing is a parse failure for gate purposes — it
// goes to parse.skipped instead of silently degrading the conformance join.
// (Practice records may legitimately carry an EMPTY options list — the
// speak/record items — but the field itself must be present.)
function validateDeepRecord(normalized, raw) {
  const problems = [];
  if (normalized.kind === 'practice' || normalized.kind === 'quiz') {
    if (typeof raw.feedback_correct !== 'string') problems.push('no feedback_correct');
    if (typeof raw.feedback_incorrect !== 'string') problems.push('no feedback_incorrect');
    // Response mechanics vary by item family: choice (options + key), tile
    // order (tiles + correct_order), matching (pairs / correct_pairs /
    // correct_sort), icon-cued sort (solution), speak/record (empty
    // correct_option_ids / recording_prompt). A record with NONE of these and
    // no response_type defeated the parser.
    const mechanicFields = [
      'options', 'correct_option_ids', 'tiles', 'correct_order', 'pairs', 'solution',
      'correct_pairs', 'correct_sort', 'cards', 'recording_prompt', 'correct_response_example',
      'response_type', 'task', 'success_condition',
    ];
    const present = mechanicFields.filter((f) => raw[f] !== undefined && raw[f] !== null);
    if (present.length === 0) problems.push('no response mechanic field (options/tiles/pairs/…)');
  }
  if (normalized.kind === 'vocab') {
    if (typeof raw.primary_spelling !== 'string') problems.push('no primary_spelling');
    if (typeof raw.illustration_asset_id !== 'string') problems.push('no illustration_asset_id');
    if (typeof raw.alt_text !== 'string') problems.push('no alt_text');
  }
  return problems;
}

// ── MANIFEST.md expectations ─────────────────────────────────────────────────

function parseManifestExpectations(md) {
  const lines = md.split('\n');
  const out = { screensByLesson: {}, screenIds: [] };
  const title = /^#\s+A1-C\d\d\s+Manifest\s+—\s+(.+)$/.exec(lines[0] ?? '');
  if (title) out.title = title[1].replace(/\s*\([^()]*lessons?\)\s*$/, '').trim();
  const total = /^##\s+Screen inventory \((\d+) screens?\)$/.exec(md);
  if (total) out.screenInventoryTotal = Number(total[1]);

  let inInventory = false;
  for (const line of lines) {
    if (/^##\s+Screen inventory/.test(line)) { inInventory = true; continue; }
    if (inInventory && /^##\s/.test(line)) inInventory = false;
    if (!inInventory) continue;
    // "L1 (9): S01 promise · S02 story hook · …" — the id before each label.
    const lm = /^L(\d) \((\d+)\): (.+)$/.exec(line.trim());
    if (!lm) continue;
    const ids = [...lm[3].matchAll(/\bS\d+[a-z]?\b/g)].map((m) => m[0]);
    out.screensByLesson[`L0${lm[1]}`] = Number(lm[2]);
    for (const id of ids) out.screenIds.push(id);
  }
  if (!out.screenIds.length) {
    // C3-style per-lesson sections: "12 screens S01–S12", "~10 screens (S13–S22)".
    for (const lm of md.matchAll(/(\d+|\~\d+)?\s*screens?\s*\(?(S\d+)\s*[–—-]\s*(S\d+)\)?/g)) {
      const lo = Number(lm[2].slice(1));
      const hi = Number(lm[3].slice(1));
      for (let k = lo; k <= hi; k++) out.screenIds.push(`S${String(k).padStart(2, '0')}`);
    }
  }
  // Lesson order from the lesson map (table rows "L1 (V)" or sections "### L1").
  const order = [];
  for (const lm of md.matchAll(/(?:^|\*\*|### )L(\d)\b/g)) {
    const id = `L0${lm[1]}`;
    if (!order.includes(id)) order.push(id);
  }
  if (order.length) out.lessonOrder = order;
  // Authored quiz size where stated ("22-item mixed quiz (±2)" / "26-item mixed
  // quiz (24–30 band)" / "Form A in L3: 30–36 items").
  const q1 = /(\d+)-item mixed quiz/.exec(md);
  if (q1) out.quizItemCount = Number(q1[1]);
  return out;
}

// ── Per-chapter scan ─────────────────────────────────────────────────────────

function scanFences(md) {
  const fences = [];
  const re = /^```([a-z]*)[ \t]*$/gm;
  let hit;
  while ((hit = re.exec(md)) !== null) {
    const start = hit.index + hit[0].length;
    const end = md.indexOf('\n```', start);
    if (end < 0) break;
    const body = md.slice(start + 1, end); // drop the leading newline
    const line = md.slice(0, hit.index).split('\n').length; // fence line, 1-based
    fences.push({ info: hit[1] || '', body, line });
    re.lastIndex = end + 4;
  }
  return fences;
}

function scanChapter(dirName, deep) {
  const dir = path.join(chaptersRoot, dirName);
  const files = readdirSync(dir).filter((f) => f.endsWith('.md')).sort();
  const manifestFile = files.find((f) => /MANIFEST\.md$/.test(f));
  const chapter = { dir: dirName, lessons: [], recordCounts: {}, files: files.length };
  const deepRecords = { vocab: [], practice: [], quiz: [], ill: [] };
  const skippedHere = [];

  if (manifestFile) {
    const md = readFileSync(path.join(dir, manifestFile), 'utf8');
    chapter.manifest = parseManifestExpectations(md);
    chapter.title = chapter.manifest.title ?? null;
  }

  for (const file of files) {
    if (!/_LESSON\.md$/.test(file)) continue;
    const lessonMatch = /_(L\d\d)_LESSON\.md$/.exec(file);
    const md = readFileSync(path.join(dir, file), 'utf8');
    const h1 = md.split('\n')[0] ?? '';
    // "# A1-C01-L03 — Lesson 3: A Real First Meeting" / "# A1 — Chapter 3 —
    // Lesson 1 (A1-C03-L01) — Countries, Languages, Jobs"
    const tm = /—\s*(?:Lesson \d+:|Lesson \d+ \([^)]*\) —)\s*(.+)$/.exec(h1)
      ?? /Lesson \d+:\s*(.+)$/.exec(h1);
    const lesson = {
      file,
      id: lessonMatch ? lessonMatch[1] : null,
      order: lessonMatch ? Number(lessonMatch[1].slice(1)) : null,
      title: tm ? tm[1].trim() : null,
      handoff: file.replace('_LESSON.md', '_HANDOFF.md'),
    };
    const lessonCounts = {};
    const skip = (reason, file, line) => {
      const entry = {
        file: path.join('english_course/04_A1_chapters', dirName, file),
        line,
        reason,
      };
      parse.skipped.push(entry);
      skippedHere.push(entry);
    };

    for (const fence of scanFences(md)) {
      parse.blocksScanned++;
      if (fence.info === 'text' || fence.info === '') { parse.textBlocks++; continue; }
      const location = { file, line: fence.line + 1 };
      if (fence.info === 'json') {
        parse.jsonBlocks++;
        let obj;
        try {
          obj = JSON.parse(fence.body);
        } catch (err) {
          skip(`json block failed to parse: ${err.message}`, file, fence.line + 1);
          continue;
        }
        if (typeof obj !== 'object' || obj === null || typeof obj.id !== 'string') {
          skip('json block has no string id', file, fence.line + 1);
          continue;
        }
        const source = { file, line: fence.line + 1 };
        const kind = classify(obj.id);
        lessonCounts[kind] = (lessonCounts[kind] ?? 0) + 1;
        if (deep) accumulate(kind, obj, source, deepRecords, skip);
        continue;
      }
      if (fence.info !== 'yaml') { parse.textBlocks++; continue; }
      parse.yamlBlocks++;
      const rec = parseYamlRecord(fence.body);
      const id = typeof rec.id === 'string'
        ? rec.id
        : (typeof rec.package_id === 'string' ? rec.package_id : null);
      if (!id) {
        const firstField = /^([A-Za-z_][A-Za-z0-9_-]*):/.exec(fence.body);
        if (firstField && firstField[1] === 'lesson_id') {
          // Lesson-header metadata block (C3+ lesson files) — parseable, just
          // not an item record. Counted, not skipped.
          lessonCounts.lessonMeta = (lessonCounts.lessonMeta ?? 0) + 1;
          continue;
        }
        skip(
          `yaml block has no id:/package_id: field`
            + (firstField ? ` (first field: ${firstField[1]})` : ''),
          file,
          fence.line + 1
        );
        continue;
      }
      rec.id = id;
      const source = { file, line: fence.line + 1 + rec.__lineOffset };
      const kind = classify(id);
      lessonCounts[kind] = (lessonCounts[kind] ?? 0) + 1;
      if (deep) accumulate(kind, rec, source, deepRecords, skip);
    }
    lesson.recordCounts = Object.fromEntries(Object.entries(lessonCounts).sort());
    chapter.lessons.push(lesson);
  }

  if (deep) {
    chapter.records = deepRecords;
    for (const [kind, list] of Object.entries(deepRecords)) {
      chapter.recordCounts[kind] = list.length;
    }
  }
  chapter.lessons.sort((a, b) => (a.order ?? 99) - (b.order ?? 99));
  return { chapter, skippedHere };
}

function accumulate(kind, rec, source, deepRecords, skip) {
  switch (kind) {
    case 'vocab':
    case 'practice':
    case 'quiz': {
      const out = kind === 'vocab'
        ? normalizeVocab(rec, source)
        : normalizePracticeLike(rec, source);
      out.kind = kind;
      const problems = validateDeepRecord(out, rec);
      if (problems.length) {
        skip(`${kind} record ${rec.id} failed field validation: ${problems.join('; ')}`,
          source.file, source.line);
        return;
      }
      deepRecords[kind].push(out);
      break;
    }
    case 'ill': deepRecords.ill.push(normalizeIll(rec, source)); break;
    default: break; // grammar/pattern/dialogue/audio/roleplay/…: counted only
  }
}

// ── Deterministic serialization (sorted keys, 2-space, trailing newline) ─────

function sortedStringify(value, indent) {
  const pad = ' '.repeat(indent);
  const padSmall = ' '.repeat(Math.max(0, indent - 2));
  if (Array.isArray(value)) {
    if (value.length === 0) return '[]';
    const items = value.map((v) => pad + sortedStringify(v, indent + 2));
    return '[\n' + items.join(',\n') + '\n' + padSmall + ']';
  }
  if (value !== null && typeof value === 'object') {
    const keys = Object.keys(value).sort();
    if (keys.length === 0) return '{}';
    const items = keys.map(
      (k) => pad + JSON.stringify(k) + ': ' + sortedStringify(value[k], indent + 2)
    );
    return '{\n' + items.join(',\n') + '\n' + padSmall + '}';
  }
  if (value === undefined) return 'null';
  return JSON.stringify(value);
}

// ── Run ──────────────────────────────────────────────────────────────────────

const chapters = [];
for (const dirName of deepDirs) {
  const { chapter } = scanChapter(dirName, true);
  chapters.push(chapter);
}
const reportedOnly = {};
for (const dirName of reportOnlyDirs) {
  const { chapter } = scanChapter(dirName, false);
  reportedOnly[chapter.dir] = {
    id: chapter.dir.replace('_', '-'),
    lessons: chapter.lessons.map((l) => ({
      file: l.file,
      id: l.id,
      recordCounts: l.recordCounts,
      title: l.title,
    })),
    recordCounts: chapter.recordCounts,
    title: chapter.title,
  };
}

const deepSkipped = parse.skipped.filter((s) =>
  /^(?:Archive\/)?english_course\/04_A1_chapters\/A1_C0[123]\//.test(s.file)
);

const manifest = {
  chapters,
  generatedBy: 'tools/export-content-manifest.mjs',
  parse,
  reportedOnly,
  source: path.relative(root, chaptersRoot),
};

const destDir = path.join(root, 'AurelTests', 'Fixtures');
mkdirSync(destDir, { recursive: true });
const dest = path.join(destDir, 'course-manifest.json');
writeFileSync(dest, sortedStringify(manifest, 0) + '\n', 'utf8');

// ── Summary ─────────────────────────────────────────────────────────────────

const kindTotals = {};
for (const ch of chapters) {
  const counts = {};
  for (const l of ch.lessons) {
    for (const [k, n] of Object.entries(l.recordCounts)) counts[k] = (counts[k] ?? 0) + n;
  }
  for (const [k, n] of Object.entries(counts)) kindTotals[k] = (kindTotals[k] ?? 0) + n;
  const lessonLine = ch.lessons
    .map((l) => `${l.id} "${l.title}" (${Object.entries(l.recordCounts).map(([k, n]) => `${k}:${n}`).join(', ')})`)
    .join(' · ');
  console.log(`${ch.dir} "${ch.title}" — ${ch.manifest?.lessonOrder?.length ?? '?'} lessons in map`);
  console.log(`   ${lessonLine}`);
}
console.log('\ndeep-scan record totals (C01–C03):');
for (const k of Object.keys(kindTotals).sort()) console.log(`  ${k}: ${kindTotals[k]}`);
console.log('\nreported-only chapters (record counts, no deep verification):');
for (const [dir, ch] of Object.entries(reportedOnly)) {
  const totals = {};
  for (const l of ch.lessons) {
    for (const [k, n] of Object.entries(l.recordCounts)) totals[k] = (totals[k] ?? 0) + n;
  }
  console.log(`  ${dir} "${ch.title}": ${Object.entries(totals).map(([k, n]) => `${k}:${n}`).join(', ')}`);
}
console.log(
  `\nblocks scanned: ${parse.blocksScanned} (yaml ${parse.yamlBlocks}, json ${parse.jsonBlocks}, `
    + `text ${parse.textBlocks}) · skipped: ${parse.skipped.length} total, `
    + `${deepSkipped.length} in C01–C03`
);
for (const s of parse.skipped) console.log(`  SKIPPED ${s.file}:${s.line} — ${s.reason}`);
console.log(`wrote ${dest}`);

if (deepSkipped.length > 0) {
  console.error('gate metric FAILED: parse.skipped must be empty for C01–C03');
  process.exitCode = 1;
}
