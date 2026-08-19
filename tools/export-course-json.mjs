#!/usr/bin/env node
// Export the authored course banks (design/course-c{1,2,3}.js) to JSON for the
// native app. The JS banks stay the source of truth — this is a mechanical
// transform, nothing is invented here.
//
//   node tools/export-course-json.mjs
//
// Writes Aurel/Resources/Course/a1-course.json and prints a summary so the
// Swift decode tests can pin the same counts.

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
