#!/usr/bin/env node
// ElevenLabs course-audio generation through the Poe API.
//
// The tool parses the approved scripts in Archive/english_course, generates
// one offline AAC file per spoken line, and writes the catalog consumed by
// VoicePlayback. The Poe key is read from the gitignored root .env and is
// never passed through a shell command or copied into the app bundle.
//
// Usage:
//   node tools/generate-audio.mjs --dry --chapter all
//   node tools/generate-audio.mjs --only A1-C01-AUD002 --force
//   node tools/generate-audio.mjs --chapter all --force
//   node tools/generate-audio.mjs --verify

import {
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  renameSync,
  statSync,
  unlinkSync,
  writeFileSync,
} from 'node:fs';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const AUDIO_DIR = path.join(root, 'Aurel/Resources/Audio');
const RAW_DIR = path.join(root, 'tools/.audio-raw');
const ARCHIVE = path.join(root, 'Archive/english_course/04_A1_chapters');
const COURSE_JSON = path.join(root, 'Aurel/Resources/Course/a1-course.json');
const CATALOG_PATH = path.join(AUDIO_DIR, 'audio-catalog.json');
const MODEL = 'ElevenLabs-v2.5-Turbo';
const GENERATION_REVISION = 2;
const CHAPTERS = ['A1-C01', 'A1-C02', 'A1-C03', 'A1-C04'];

// Course character qualities mapped to voices supported by Poe's
// ElevenLabs-v2.5-Turbo bot. This is the approved course cast.
const VOICES = {
  GUIDE: 'Sarah',
  ALEX: 'Lily',
  MAYA: 'Jessica',
  LEO: 'George',
  NINA: 'Matilda',
  SAM: 'Brian',
  AMARA: 'River',
  RAFAEL: 'Will',
  KENJI: 'Monika Sogam',
};

const WPM_TARGET = {
  learning_slow_clear: [95, 115],
  challenge_natural_slow: [115, 140],
};

// Authored derivative: AUD044 explicitly reuses AUD043's twice-modeled lines.
const ALIASES = { 'A1-C01-AUD044': 'A1-C01-AUD043' };

// --- arguments --------------------------------------------------------------

const argv = process.argv.slice(2);
const dry = argv.includes('--dry');
const verifyOnly = argv.includes('--verify');
const force = argv.includes('--force');

function valueAfter(flag) {
  const index = argv.indexOf(flag);
  return index >= 0 ? argv[index + 1] : undefined;
}

const onlyValue = valueAfter('--only') ?? '';
const only = onlyValue ? new Set(onlyValue.split(',').map((value) => value.trim())) : null;
const explicitChapter = valueAfter('--chapter');
const chapterFilter = explicitChapter ?? (verifyOnly ? 'all' : 'A1-C01');
const chapters = chapterFilter === 'all' ? CHAPTERS : [chapterFilter];
const concurrency = Number.parseInt(valueAfter('--concurrency') ?? '6', 10);
if (!Number.isInteger(concurrency) || concurrency < 1 || concurrency > 8) {
  throw new Error('--concurrency must be an integer from 1 through 8.');
}

for (const chapter of chapters) {
  if (!CHAPTERS.includes(chapter)) {
    throw new Error(`Unsupported chapter "${chapter}". Use ${CHAPTERS.join(', ')} or all.`);
  }
}

// --- source parsing ---------------------------------------------------------

function spokenLines(script) {
  const lines = [];
  for (const rawLine of script.split('\n')) {
    const match = rawLine.match(/^\s*(?:T\d+\s+)?([A-Z][A-Z]+):\s*(.*)$/);
    if (match) {
      const speaker = match[1];
      const text = match[2].replace(/\([^)]*\)/g, ' ').replace(/\s+/g, ' ').trim();
      if (speaker !== 'YOU' && speaker !== 'LEARNER' && text) lines.push({ speaker, text });
      continue;
    }
    const continuation = rawLine.replace(/\([^)]*\)/g, ' ').replace(/\s+/g, ' ').trim();
    if (continuation && lines.length) {
      lines[lines.length - 1].text += ` ${continuation}`;
    }
  }
  return lines;
}

function c3WordAndQuizAssets(sourceFile) {
  // L1's approved word-model index is intentionally compact rather than 43
  // separate YAML records. These are its exact indexed model strings and the
  // seven inline blended-review scripts. L3 likewise declares its final quiz
  // takes inline beside the listening items.
  const models = {
    '002': ['GUIDE', 'country'],
    '003': ['GUIDE', 'city'],
    '004': ['GUIDE', 'from'],
    '005': ['GUIDE', 'language'],
    '006': ['GUIDE', 'English'],
    '007': ['GUIDE', 'speak'],
    '008': ['ALEX', 'Canada. … Canadian. … English and French.'],
    '009': ['SAM', 'Mexico. … Mexican. … Spanish and English.'],
    '010': ['NINA', 'Peru. … Peruvian. … Spanish.'],
    '011': ['MAYA', 'Egypt. … Egyptian. … Arabic and English.'],
    '012': ['LEO', 'Australia. … Australian. … English.'],
    '013': ['GUIDE', 'Brazil. … Brazilian. … Portuguese.'],
    '014': ['GUIDE', 'Japan. … Japanese. … Japanese.'],
    '015': ['GUIDE', 'Kenya. … Kenyan. … Swahili and English.'],
    '016': ['GUIDE', 'Spain. … Spanish. … Spanish.'],
    '017': ['GUIDE', 'India. … Indian. … Hindi and English.'],
    '018': ['GUIDE', 'student'],
    '019': ['GUIDE', 'teacher'],
    '020': ['GUIDE', 'doctor'],
    '021': ['GUIDE', 'nurse'],
    '022': ['GUIDE', 'engineer'],
    '023': ['GUIDE', 'designer'],
    '024': ['GUIDE', 'driver'],
    '025': ['GUIDE', 'cook'],
    '026': ['GUIDE', 'office worker'],
    '027': ['GUIDE', 'friend'],
    '028': ['GUIDE', 'person'],
    '029': ['GUIDE', 'people'],
    '030': ['GUIDE', 'This is.'],
    '031': ['GUIDE', 'They speak.'],
    '032': ['GUIDE', 'Nice to meet you too.'],
    '033': ['GUIDE', 'Where are you from?'],
    '034': ['GUIDE', "I'm from."],
    '035': ['GUIDE', 'Where is Alex from?'],
    '036': ['GUIDE', 'What do you do?'],
    '037': ['GUIDE', "I'm a. … I'm an."],
    '038': ['GUIDE', "country … city … from … language … English … speak … Now you: Canada is a country. Aroa is a city. I'm from … I speak English."],
    '039': ['GUIDE', "Canada — I'm from Canada … Mexico — I'm from Mexico … Peru — I'm from Peru … Egypt — I'm from Egypt … Australia — I'm from Australia. … Five dots on the wall!"],
    '040': ['GUIDE', 'Brazil · Portuguese … Japan · Japanese … Kenya · Swahili and English … Spain · Spanish … India · Hindi and English. … Ten countries, five dots on the wall — and one dot for you!'],
    '041': ['GUIDE', "student · teacher · doctor · nurse · engineer … I'm a student. I'm a teacher. I'm a doctor. I'm a nurse. I'm an engineer!"],
    '042': ['GUIDE', "designer · driver · cook · office worker … I'm a driver. I'm an office worker."],
    '043': ['GUIDE', 'friend · person · people'],
    '044': ['GUIDE', "Where are you from? … I'm from Peru. … Where is Alex from? … Alex is from Canada. … What do you do? … I'm a teacher! … I'm an engineer!"],
    '060': ['KENJI', "Hi! Nice to meet you! … I'm from Japan. … I'm an engineer. … Nice to meet you!"],
    '061': ['NINA', 'Look — five dots, and one space for you! … Take a dot. Your country goes here. … Share, if you like — and any country is okay.'],
    '062': ['MAYA', "Hi! I'm Maya. I'm from Egypt."],
    '063': ['KENJI', "I'm Kenji. I'm from Japan. I'm an engineer."],
    '064': ['NINA', 'Kenji — Japan.'],
    '065': ['SAM', "Hi! I'm Sam. I speak Spanish and English."],
    '066': ['GUIDE', 'Good morning!'],
    '067': ['SAM', 'four zero one, seven three two!'],
  };

  const assets = Object.entries(models).map(([number, [speaker, text]]) => ({
    id: `A1-C03-AUD${number}`,
    purpose: Number(number) >= 62 ? 'quiz_listening_take' : 'word_or_course_model',
    delivery: number === '067' ? 'challenge_natural_slow' : 'learning_slow_clear',
    lines: [{ speaker, text }],
    src: sourceFile,
  }));
  const byId = new Map(assets.map((asset) => [asset.id, asset]));
  byId.get('A1-C03-AUD042').lines = [
    { speaker: 'GUIDE', text: 'designer … driver … cook … office worker' },
    { speaker: 'ALEX', text: "I'm a designer!" },
    { speaker: 'LEO', text: "I'm a cook!" },
    { speaker: 'GUIDE', text: "I'm a driver. I'm an office worker." },
  ];
  byId.get('A1-C03-AUD043').lines = [
    { speaker: 'GUIDE', text: 'friend … person … people' },
    { speaker: 'MAYA', text: 'This is my friend Sam!' },
    { speaker: 'SAM', text: 'Nice to meet you!' },
    { speaker: 'LEO', text: 'Nice to meet you too.' },
  ];
  return assets;
}

function yamlAudioAssets(content, sourceFile) {
  const assets = [];
  const blockPattern = /```yaml\n([\s\S]*?)```/g;
  let blockMatch;
  while ((blockMatch = blockPattern.exec(content))) {
    const block = blockMatch[1];
    const id = block.match(/^id:\s*(A1-C\d{2}-AUD\d{3})\s*$/m)?.[1];
    if (!id) continue;
    const purpose = block.match(/^purpose:\s*([^#\n]+)/m)?.[1]?.trim() ?? 'course_audio';
    const delivery =
      block.match(/^delivery_style:\s*([a-z_]+)/m)?.[1] ?? 'learning_slow_clear';
    const scriptBody = block.match(/^script:\s*\|\s*\n((?: {2}.*(?:\n|$))*)/m)?.[1];
    if (!scriptBody) continue;
    const script = scriptBody.split('\n').map((line) => line.replace(/^ {2}/, '')).join('\n');
    const lines = spokenLines(script);
    if (lines.length) assets.push({ id, purpose, delivery, lines, src: sourceFile });
  }
  return assets;
}

function markdownAudioAssets(content, chapterId, sourceFile) {
  const metadata = new Map();
  const indexPattern = /^\|\s*(AUD\d{3}|A1-CP1-AUD\d{3})\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*(learning_slow_clear|challenge_natural_slow)\s*\|/gm;
  let indexMatch;
  while ((indexMatch = indexPattern.exec(content))) {
    const rawId = indexMatch[1];
    const id = rawId.startsWith('AUD') ? `${chapterId}-${rawId}` : rawId;
    metadata.set(id, { purpose: indexMatch[2].trim(), delivery: indexMatch[4] });
  }

  const assets = [];
  const textBlockPattern = /```text\n([\s\S]*?)```/g;
  let previousTextEnd = 0;
  let textMatch;
  while ((textMatch = textBlockPattern.exec(content))) {
    const between = content.slice(previousTextEnd, textMatch.index);
    const markerPattern = /\*\*((?:A1-C\d{2}-)?AUD\d{3}|A1-CP1-AUD\d{3})\*\*/g;
    const markers = [];
    let marker;
    while ((marker = markerPattern.exec(between))) markers.push(marker[1]);
    previousTextEnd = textBlockPattern.lastIndex;
    if (!markers.length) continue;

    // Only the marker paragraph closest to this text block belongs to it. A
    // dual learning/challenge header legitimately contributes two ids.
    const nearest = markers.slice(-2);
    const lines = spokenLines(textMatch[1]);
    if (!lines.length) continue;
    for (const rawId of nearest) {
      const id = rawId.startsWith('AUD') ? `${chapterId}-${rawId}` : rawId;
      const details = metadata.get(id) ?? {};
      assets.push({
        id,
        purpose: details.purpose ?? 'course_audio',
        delivery: details.delivery ?? 'learning_slow_clear',
        lines,
        src: sourceFile,
      });
    }
  }
  return assets;
}

function parseScripts(chapterId) {
  const directory = path.join(ARCHIVE, chapterId.replaceAll('-', '_'));
  const files = readdirSync(directory)
    .filter((file) => file.endsWith('_LESSON.md'))
    .sort()
    .map((file) => path.join(directory, file));
  const assets = new Map();

  for (const file of files) {
    const content = readFileSync(file, 'utf8');
    for (const sourceLine of content.split('\n')) {
      const match = sourceLine.match(
        /^\|\s*(A1-C\d{2}-AUD\d{3})\s*\|\s*([^|]+)\|\s*([^|]+)\|\s*(.+)\|\s*$/
      );
      if (!match) continue;

      const [, id, purposeRaw, deliveryRaw, scriptRaw] = match;
      const delivery = deliveryRaw.trim().split(/[ ·(]/)[0];
      const cleaned = scriptRaw
        .replace(/`[^`]*`/g, '')
        .replace(/\([^)]*\)/g, ' ')
        .trim();

      const lines = [];
      const segmentPattern = /([A-Z][A-Z]+):\s*"([^"]*)"|"([^"]+)"/g;
      let segment;
      while ((segment = segmentPattern.exec(cleaned))) {
        const speaker = segment[1] ?? 'GUIDE';
        const text = (segment[2] ?? segment[3]).trim();
        if (speaker !== 'YOU' && text) lines.push({ speaker, text });
      }

      if (!assets.has(id)) {
        assets.set(id, {
          id,
          purpose: purposeRaw.trim(),
          delivery,
          lines,
          src: path.basename(file),
        });
      }
    }

    if (chapterId === 'A1-C03') {
      for (const asset of yamlAudioAssets(content, path.basename(file))) {
        if (!assets.has(asset.id)) assets.set(asset.id, asset);
      }
    }
    if (chapterId === 'A1-C04') {
      for (const asset of markdownAudioAssets(content, chapterId, path.basename(file))) {
        if (!assets.has(asset.id)) assets.set(asset.id, asset);
      }
    }
  }

  if (chapterId === 'A1-C03') {
    for (const asset of c3WordAndQuizAssets('A1_C03 authored indexes and inline scripts')) {
      if (!assets.has(asset.id)) assets.set(asset.id, asset);
    }
    // AUD051 is explicitly a fresh challenge performance of AUD050's ten
    // authored turns, never a digitally sped-up edit.
    if (!assets.has('A1-C03-AUD051') && assets.has('A1-C03-AUD050')) {
      assets.set('A1-C03-AUD051', {
        ...assets.get('A1-C03-AUD050'),
        id: 'A1-C03-AUD051',
        purpose: 'conversation_model_challenge',
        delivery: 'challenge_natural_slow',
      });
    }
  }

  if (chapterId === 'A1-C04') {
    const additions = [
      ['A1-C04-AUD040', 'cv005_fast_name', 'challenge_natural_slow', 'AMARA', "Hi! My name is Amara Otieno."],
      ['A1-C04-AUD044', 'rp_t2_name', 'learning_slow_clear', 'RAFAEL', "Hi! I'm Rafael. Rafael Costa."],
      ['A1-C04-AUD045', 'rp_t4_spell_phone', 'learning_slow_clear', 'RAFAEL', 'R-A-F-A-E-L. … And my phone number: 6-1-8… 4-0-2.'],
      ['A1-C04-AUD046', 'rp_t6_origin_job', 'learning_slow_clear', 'RAFAEL', "I'm from Brazil. I'm a driver. … I speak Portuguese and English!"],
    ];
    for (const [id, purpose, delivery, speaker, text] of additions) {
      if (!assets.has(id)) assets.set(id, { id, purpose, delivery, lines: [{ speaker, text }], src: 'A1_C04 authored inline script' });
    }
    if (!assets.has('A1-C04-AUD047')) {
      assets.set('A1-C04-AUD047', {
        id: 'A1-C04-AUD047', purpose: 'rp_t8_meeting', delivery: 'learning_slow_clear',
        lines: [
          { speaker: 'RAFAEL', text: 'Nice to meet you!' },
          { speaker: 'AMARA', text: 'Nice to meet you too!' },
        ],
        src: 'A1_C04 roleplay ai_script',
      });
    }
  }
  return assets;
}

function plannedAssets(selectedChapters = chapters) {
  const assets = [];
  for (const chapter of selectedChapters) {
    for (const asset of parseScripts(chapter).values()) {
      if (only && !only.has(asset.id)) continue;
      if (asset.lines.length) assets.push(asset);
    }
  }
  return assets;
}

const jobs = plannedAssets();
const lineFileCount = jobs.reduce((total, asset) => total + asset.lines.length, 0);
console.log(
  `${dry ? '[dry] ' : ''}chapter(s) ${chapters.join(', ')}: ${jobs.length} assets, ` +
    `${lineFileCount} line files; cast ${Object.keys(VOICES).length} voices`
);

if (dry) {
  for (const asset of jobs) {
    const cast = asset.lines.map((line) => `${line.speaker}→${VOICES[line.speaker]}`).join(' ');
    const text = asset.lines.map((line) => `"${line.text}"`).join(' … ');
    console.log(`${asset.id}  [${asset.delivery}]  (${cast})  ${text}`);
  }
  process.exit(0);
}

// --- integrity verification -------------------------------------------------

function readCatalog() {
  if (!existsSync(CATALOG_PATH)) return { assets: [] };
  return JSON.parse(readFileSync(CATALOG_PATH, 'utf8'));
}

function fileDuration(file) {
  const output = execFileSync('afinfo', [file], { encoding: 'utf8' });
  const match = output.match(/estimated duration:\s*([\d.]+)\s*sec(?:onds?)?/i);
  const duration = Number.parseFloat(match?.[1] ?? '0');
  return Number.isFinite(duration) ? duration : 0;
}

function courseAudioReferences() {
  const chaptersJSON = JSON.parse(readFileSync(COURSE_JSON, 'utf8'));
  const references = new Set();

  function visit(value, chapterId, key = '') {
    if (Array.isArray(value)) {
      for (const child of value) visit(child, chapterId, key);
      return;
    }
    if (value && typeof value === 'object') {
      for (const [childKey, child] of Object.entries(value)) visit(child, chapterId, childKey);
      return;
    }
    if (typeof value !== 'string' || !['aud', 'lineAud', 'audioAsset'].includes(key)) return;
    if (!/^(?:A1-C\d{2}-)?AUD\d{3}$/.test(value)) return;
    references.add(value.includes('-AUD') ? value : `${chapterId}-${value}`);
  }

  for (const chapter of chaptersJSON) visit(chapter, chapter.id);
  return references;
}

function verifyCatalog() {
  const catalog = readCatalog();
  const byId = new Map(catalog.assets.map((asset) => [asset.id, asset]));
  const errors = [];

  for (const reference of courseAudioReferences()) {
    if (!byId.has(reference)) errors.push(`course reference missing from catalog: ${reference}`);
  }

  for (const asset of plannedAssets(CHAPTERS)) {
    const catalogAsset = byId.get(asset.id);
    if (!catalogAsset) {
      errors.push(`authored asset missing from catalog: ${asset.id}`);
      continue;
    }
    if (catalogAsset.lines.length !== asset.lines.length) {
      errors.push(
        `${asset.id}: catalog has ${catalogAsset.lines.length} lines, source has ${asset.lines.length}`
      );
    }
  }

  for (const asset of catalog.assets) {
    for (const line of asset.lines) {
      const file = path.join(AUDIO_DIR, line.file);
      if (!existsSync(file)) {
        errors.push(`${asset.id}: missing file ${line.file}`);
        continue;
      }
      if (statSync(file).size < 2_000) errors.push(`${asset.id}: suspiciously small ${line.file}`);
      const duration = fileDuration(file);
      if (duration < 0.15) errors.push(`${asset.id}: invalid duration for ${line.file}`);
      if (Math.abs(duration - line.dur) > 0.15) {
        errors.push(`${asset.id}: stale duration metadata for ${line.file}`);
      }
    }
  }

  if (errors.length) {
    console.error(`verification failed (${errors.length}):`);
    for (const error of errors) console.error(`  ${error}`);
    process.exitCode = 1;
    return;
  }

  const files = catalog.assets.reduce((total, asset) => total + asset.lines.length, 0);
  console.log(
    `verified: ${catalog.assets.length} catalog assets, ${files} mapped line entries, ` +
      `${courseAudioReferences().size} course references`
  );
}

if (verifyOnly) {
  verifyCatalog();
  process.exit(process.exitCode ?? 0);
}

// --- Poe generation ---------------------------------------------------------

const envFile = path.join(root, '.env');
const poeKey = existsSync(envFile)
  ? readFileSync(envFile, 'utf8').match(/^POE_API_KEY=(.+)$/m)?.[1]?.trim()
  : undefined;
if (!poeKey) {
  console.error('POE_API_KEY missing — add it to the gitignored root .env file.');
  process.exit(1);
}

function delay(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds));
}

function authoredSpeechText(text) {
  // Ellipses are the style guide's authored pause notation. Crucially, no
  // delivery instruction is prepended: prose instructions are spoken by the
  // v2.5 Poe bot and would contaminate the learner-facing take.
  return text.replace(/\s*…\s*/g, ' ... ').replace(/\s+/g, ' ').trim();
}

async function poeTts(text, voice) {
  const body = {
    model: MODEL,
    stream: false,
    messages: [{ role: 'user', content: `${authoredSpeechText(text)} --voice ${voice}` }],
  };

  for (let attempt = 1; attempt <= 3; attempt++) {
    try {
      const response = await fetch('https://api.poe.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${poeKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
        signal: AbortSignal.timeout(180_000),
      });
      const responseText = await response.text();
      if (!response.ok) throw new Error(`Poe HTTP ${response.status}: ${responseText.slice(0, 180)}`);
      const content = JSON.parse(responseText)?.choices?.[0]?.message?.content;
      const url = typeof content === 'string' ? content.match(/https?:\/\/[^\s)\]]+/)?.[0] : null;
      if (!url) throw new Error(`Poe returned no audio URL: ${String(content).slice(0, 180)}`);
      return url;
    } catch (error) {
      if (attempt === 3) throw error;
      const backoff = 4_000 * attempt;
      console.log(`  retry ${attempt} in ${backoff / 1000}s: ${String(error.message).slice(0, 120)}`);
      await delay(backoff);
    }
  }
  throw new Error('unreachable Poe retry state');
}

async function download(url, destination) {
  const response = await fetch(url, { redirect: 'follow', signal: AbortSignal.timeout(120_000) });
  if (!response.ok) throw new Error(`Audio download HTTP ${response.status}`);
  const bytes = Buffer.from(await response.arrayBuffer());
  if (bytes.length < 2_000) throw new Error(`Audio download was only ${bytes.length} bytes`);
  writeFileSync(destination, bytes);
}

function sha256(file) {
  return createHash('sha256').update(readFileSync(file)).digest('hex');
}

function wordCount(text) {
  return text.match(/[A-Za-z]+(?:['’][A-Za-z]+)?/g)?.length ?? 0;
}

async function mapConcurrent(items, limit, operation) {
  const results = new Array(items.length);
  let nextIndex = 0;
  async function worker() {
    while (nextIndex < items.length) {
      const index = nextIndex++;
      results[index] = await operation(items[index], index);
    }
  }
  await Promise.all(Array.from({ length: Math.min(limit, items.length) }, worker));
  return results;
}

function validGenerationMarker(file, output, line, voice) {
  if (!existsSync(file) || !existsSync(output)) return false;
  try {
    const marker = JSON.parse(readFileSync(file, 'utf8'));
    return marker.revision === GENERATION_REVISION
      && marker.text === line.text
      && marker.voice === voice
      && marker.sha256 === sha256(output);
  } catch {
    return false;
  }
}

mkdirSync(RAW_DIR, { recursive: true });
mkdirSync(AUDIO_DIR, { recursive: true });

const generatedAssets = [];
const pacingReview = [];
let generated = 0;
let cached = 0;

const lineJobs = jobs.flatMap((asset) =>
  asset.lines.map((line, index) => ({ asset, line, index }))
);
let completed = 0;
const renderedLines = await mapConcurrent(lineJobs, concurrency, async ({ asset, line, index }) => {
    const voice = VOICES[line.speaker];
    if (!voice) throw new Error(`${asset.id}: no approved voice for speaker ${line.speaker}`);

    const base = `${asset.id}_L${index + 1}`;
    const output = path.join(AUDIO_DIR, `${base}.m4a`);
    const temporaryOutput = path.join(AUDIO_DIR, `${base}.tmp.m4a`);
    const raw = path.join(RAW_DIR, `${base}.mp3`);
    const marker = path.join(RAW_DIR, `${base}.revision.json`);

    let duration = 0;
    if (!force && validGenerationMarker(marker, output, line, voice)) {
      duration = fileDuration(output);
      if (duration < 0.15) throw new Error(`${base}: cached file is invalid; rerun with --force`);
      cached++;
    } else {
      const audioURL = await poeTts(line.text, voice);
      await download(audioURL, raw);
      if (existsSync(temporaryOutput)) unlinkSync(temporaryOutput);
      execFileSync('afconvert', [
        '-f', 'm4af', '-d', 'aac', '-b', '96000', '-c', '1', raw, temporaryOutput,
      ]);
      duration = fileDuration(temporaryOutput);
      if (duration < 0.15) throw new Error(`${base}: generated take has no valid duration`);
      renameSync(temporaryOutput, output);
      writeFileSync(marker, JSON.stringify({
        revision: GENERATION_REVISION,
        text: line.text,
        voice,
        sha256: sha256(output),
      }));
      generated++;
      await delay(1_100);
    }

    const words = wordCount(line.text);
    const wpm = duration > 0.05 ? Math.round((words / duration) * 60) : 0;
    const target = WPM_TARGET[asset.delivery];
    // Very short models and explicit-pause lines do not produce meaningful
    // WPM readings; keep their real duration but omit false pace warnings.
    if (target && words >= 4 && !line.text.includes('…') && (wpm < target[0] || wpm > target[1])) {
      pacingReview.push(
        `${base}: ${wpm} wpm (target ${target[0]}–${target[1]}) "${line.text}"`
      );
    }

    const rendered = {
      file: `${base}.m4a`,
      speaker: line.speaker,
      voice,
      text: line.text,
      dur: Math.round(duration * 100) / 100,
      wpm,
      sha256: sha256(output),
    };
    completed++;
    console.log(`[${completed}/${lineJobs.length}] ${base} ✓ ${duration.toFixed(1)}s`);
    return rendered;
});

let renderedIndex = 0;
for (const asset of jobs) {
  const outputLines = renderedLines.slice(renderedIndex, renderedIndex + asset.lines.length);
  renderedIndex += asset.lines.length;
  const duration = outputLines.reduce((total, line) => total + line.dur, 0);
  generatedAssets.push({
    id: asset.id,
    purpose: asset.purpose,
    delivery: asset.delivery,
    src: asset.src,
    lines: outputLines,
    text: asset.lines.map((line) => line.text).join(' '),
    duration: Math.round(duration * 100) / 100,
  });
}

const previous = readCatalog();
const merged = new Map(previous.assets.map((asset) => [asset.id, asset]));
for (const asset of generatedAssets) merged.set(asset.id, asset);

for (const [alias, source] of Object.entries(ALIASES)) {
  if (only && !only.has(alias) && !only.has(source)) continue;
  const sourceAsset = merged.get(source);
  if (sourceAsset) merged.set(alias, { ...sourceAsset, id: alias, purpose: 'alias', aliasOf: source });
}

const catalog = {
  version: 2,
  generationRevision: GENERATION_REVISION,
  model: MODEL,
  generatedBy: 'tools/generate-audio.mjs',
  voices: VOICES,
  assets: [...merged.values()].sort((left, right) => left.id.localeCompare(right.id)),
};
const temporaryCatalog = `${CATALOG_PATH}.tmp`;
writeFileSync(temporaryCatalog, JSON.stringify(catalog, null, 2) + '\n');
renameSync(temporaryCatalog, CATALOG_PATH);

console.log(`\ndone: ${generated} generated, ${cached} cached → ${CATALOG_PATH}`);
if (pacingReview.length) {
  console.log(`\npacing review: ${pacingReview.length} longer lines outside their authored target`);
  for (const item of pacingReview.slice(0, 30)) console.log(`  ${item}`);
  if (pacingReview.length > 30) console.log(`  … and ${pacingReview.length - 30} more`);
}
