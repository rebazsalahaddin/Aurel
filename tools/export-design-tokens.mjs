#!/usr/bin/env node
// Exports the Aurel design tokens from the three CSS source layers into
// Aurel/Resources/Design/design-tokens.json.
//
// Layers (cascade order: base < shell < player):
//   base   — design/_ds/organic-ae97cabc-b950-4085-bbfd-89c2fd51d81e/styles.css (:root)
//   shell  — design/Aurel.dc.html <style> (.aurel-dark, .au-stage, .au-stage.aurel-dark)
//   player — design/CourseScreen.dc.html <style> (.aurel-dark, .au-wrap, .au-wrap.aurel-dark)
//
// Values are EVALUATED, not copied: var() references resolve through the layer
// cascade per theme, and color-mix(in srgb, ...) interpolates per channel on
// premultiplied sRGB values (CSS Color 5 semantics for rectangular spaces) —
// which is what mixing with `transparent` must do to keep hue.
//
// The shell (Aurel.dc.html) is the canonical --au-* layer; CourseScreen.dc.html
// re-declares a subset in a parallel document, so its resolved values are
// recorded per token under "variants.player" whenever they differ.
//
// Zero dependencies, deterministic output: sorted keys, 2-space indent,
// trailing newline, all floats rounded to 4 decimals.

import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const ROOT = dirname(dirname(fileURLToPath(import.meta.url)));
const FILES = {
  base: join(ROOT, "design/_ds/organic-ae97cabc-b950-4085-bbfd-89c2fd51d81e/styles.css"),
  shell: join(ROOT, "design/Aurel.dc.html"),
  player: join(ROOT, "design/CourseScreen.dc.html"),
};
const LABELS = {
  base: "design/_ds/organic-ae97cabc-b950-4085-bbfd-89c2fd51d81e/styles.css",
  shell: "design/Aurel.dc.html",
  player: "design/CourseScreen.dc.html",
};
const OUT_PATH = join(ROOT, "Aurel/Resources/Design/design-tokens.json");

class TokenError extends Error {}

// ─────────────────────────────────────────────────────────────────────────────
// CSS parsing — top-level rules via brace matching, declarations per rule
// ─────────────────────────────────────────────────────────────────────────────

/** Blank comments out (keeping newlines) so byte offsets and lines stay stable. */
function stripComments(css) {
  return css.replace(/\/\*[\s\S]*?\*\//g, (m) => m.replace(/[^\n]/g, " "));
}

function lineOf(text, index) {
  let line = 1;
  for (let i = 0; i < index && i < text.length; i++) {
    if (text.charCodeAt(i) === 10) line++;
  }
  return line;
}

/**
 * Extract top-level rules. @media/@keyframes blocks collapse into one skipped
 * rule — inner braces are consumed by depth matching, so nested selectors
 * never leak out as separate rules.
 */
function extractRules(css) {
  const rules = [];
  let cursor = 0;
  while (cursor < css.length) {
    const open = css.indexOf("{", cursor);
    if (open < 0) break;
    const rawSelector = css.slice(cursor, open);
    const selector = rawSelector.slice(rawSelector.lastIndexOf(";") + 1).trim();
    let depth = 1;
    let close = open + 1;
    while (close < css.length && depth > 0) {
      const ch = css[close];
      if (ch === "{") depth++;
      else if (ch === "}") depth--;
      close++;
    }
    if (depth !== 0) throw new TokenError(`unbalanced braces at offset ${open}`);
    rules.push({ selector, body: css.slice(open + 1, close - 1), bodyOffset: open + 1 });
    cursor = close;
  }
  return rules;
}

/** Split a declaration body into {name, raw, index} records (index → css text). */
function declarationsOf(rule) {
  const decls = [];
  let depth = 0;
  let start = 0;
  for (let i = 0; i <= rule.body.length; i++) {
    const ch = rule.body[i];
    if (ch === "(") depth++;
    else if (ch === ")") depth--;
    if ((ch === ";" || i === rule.body.length) && depth === 0) {
      const chunk = rule.body.slice(start, i);
      const chunkAt = start;
      start = i + 1;
      const m = chunk.match(/^[ \t\r\n]*(--[a-zA-Z0-9-]+)[ \t]*:[ \t]*([\s\S]*?)[ \t\r\n]*$/);
      if (!m) continue;
      const leading = chunk.length - chunk.trimStart().length;
      decls.push({ name: m[1], raw: m[2], index: rule.bodyOffset + chunkAt + leading });
    }
  }
  return decls;
}

/** Inline <style> content of a dc.html file + the 1-based file line it starts on. */
function styleBlockOf(html, file) {
  const open = html.indexOf("<style>");
  const close = html.indexOf("</style>");
  if (open < 0 || close < 0) throw new TokenError(`${LABELS[file]}: no <style> block`);
  const raw = html.slice(open + 7, close);
  const lead = raw.length - raw.replace(/^\s+/, "").length;
  return {
    css: stripComments(raw.slice(lead)),
    firstLine: lineOf(html, open + 7 + lead),
  };
}

/**
 * Collect the declarations of the given selectors from one source.
 * Repeated selectors merge in source order (CSS: later declarations win).
 */
function captureSelectors(text, file, selectors) {
  const merged = new Map();
  for (const rule of extractRules(text.css)) {
    const scope = selectors.get(rule.selector);
    if (!scope) continue;
    for (const decl of declarationsOf(rule)) {
      merged.set(decl.name, {
        name: decl.name,
        raw: decl.raw,
        file,
        line: text.firstLine + lineOf(text.css, decl.index) - 1,
        scope,
      });
    }
  }
  return merged;
}

/** Overlay captured maps (later layers override; all declarations kept). */
function mergeCaptured(maps) {
  const merged = new Map();
  for (const map of maps) {
    for (const [name, decl] of map) merged.set(name, decl);
  }
  return merged;
}

/** Find the winning declaration for `name` (last map that defines it). */
function findDecl(name, maps) {
  for (let i = maps.length - 1; i >= 0; i--) {
    const decl = maps[i].get(name);
    if (decl) return decl;
  }
  throw new TokenError(`no declaration found for ${name}`);
}

// ─────────────────────────────────────────────────────────────────────────────
// Value evaluation
// ─────────────────────────────────────────────────────────────────────────────

function splitTopLevel(str, sep) {
  const parts = [];
  let depth = 0;
  let current = "";
  for (const ch of str) {
    if (ch === "(") depth++;
    else if (ch === ")") depth--;
    if (ch === sep && depth === 0) {
      parts.push(current);
      current = "";
    } else {
      current += ch;
    }
  }
  if (current.trim() !== "") parts.push(current);
  return parts.map((p) => p.trim()).filter((p) => p !== "");
}

const HEX = /^#([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/;
const RGB_FN = /^rgba?\(\s*([\d.]+)(%)?\s*,\s*([\d.]+)(%)?\s*,\s*([\d.]+)(%)?\s*(?:,\s*([\d.]+)(%)?\s*)?\)$/;

/**
 * Parse a literal color. `transparent` → rgba(0,0,0,0). Anything else —
 * including named colors — fails loudly with the file:line context.
 */
function parseColor(expr, ctx) {
  const s = expr.trim();
  if (s === "transparent") return { r: 0, g: 0, b: 0, a: 0 };
  if (HEX.test(s)) {
    let hex = s.slice(1);
    if (hex.length === 3) hex = [...hex].map((c) => c + c).join("");
    const value = parseInt(hex, 16);
    if (hex.length === 6) {
      return { r: ((value >> 16) & 0xff) / 255, g: ((value >> 8) & 0xff) / 255, b: (value & 0xff) / 255, a: 1 };
    }
    return {
      r: ((value >>> 24) & 0xff) / 255,
      g: ((value >>> 16) & 0xff) / 255,
      b: ((value >>> 8) & 0xff) / 255,
      a: (value & 0xff) / 255,
    };
  }
  const m = s.match(RGB_FN);
  if (m) {
    const chan = (v, pct) => (pct ? parseFloat(v) / 100 : parseFloat(v) / 255);
    let alpha = 1;
    if (m[7] !== undefined) alpha = parseFloat(m[7]) / (m[8] ? 100 : 1);
    return { r: chan(m[1], m[2]), g: chan(m[3], m[4]), b: chan(m[5], m[6]), a: alpha };
  }
  throw new TokenError(
    `${ctx}: named or unparseable color "${s}" — only #hex, rgb(), rgba() and ` +
      `transparent may appear in the sources`
  );
}

function parseColorMix(expr, ctx) {
  const inner = expr.slice("color-mix(".length, expr.length - 1);
  const header = inner.match(/^in\s+([a-z-]+)\s*,\s*/);
  if (!header || header[1] !== "srgb") {
    throw new TokenError(`${ctx}: unsupported color-mix interpolation space in "${expr}"`);
  }
  const legs = splitTopLevel(inner.slice(header[0].length), ",");
  if (legs.length !== 2) throw new TokenError(`${ctx}: expected two color legs in "${expr}"`);
  const leg = (text) => {
    const pm = text.match(/\s+(-?[\d.]+)\s*%\s*$/);
    return {
      color: parseColorExpr(pm ? text.slice(0, pm.index) : text, ctx),
      pct: pm ? parseFloat(pm[1]) / 100 : null,
    };
  };
  const first = leg(legs[0]);
  const second = leg(legs[1]);
  let p1 = first.pct;
  let p2 = second.pct;
  if (p1 === null && p2 === null) {
    p1 = 0.5;
    p2 = 0.5;
  } else if (p1 === null) {
    p1 = 1 - p2;
  } else if (p2 === null) {
    p2 = 1 - p1;
  } else {
    const total = p1 + p2;
    p1 /= total;
    p2 /= total;
  }
  // CSS Color 5: rectangular-space interpolation runs on premultiplied
  // channels and the result is un-premultiplied, so mixing with `transparent`
  // keeps hue (the app's UIColor.alpha(...) mirrors this).
  const a = first.color.a * p1 + second.color.a * p2;
  const channel = (k) => {
    const premultiplied = first.color[k] * first.color.a * p1 + second.color[k] * second.color.a * p2;
    return a > 0 ? premultiplied / a : 0;
  };
  return { r: channel("r"), g: channel("g"), b: channel("b"), a };
}

function parseColorExpr(expr, ctx) {
  const s = expr.trim();
  if (s.startsWith("color-mix(") && s.endsWith(")")) return parseColorMix(s, ctx);
  return parseColor(s, ctx);
}

function parseShadow(value, ctx) {
  return splitTopLevel(value, ",").map((layer) => {
    const dims = [];
    let rest = layer;
    let m;
    while ((m = rest.match(/^(-?[\d.]+)(px)?\s+/)) !== null) {
      if (!m[2] && m[1] !== "0") throw new TokenError(`${ctx}: unitless length "${m[1]}" in "${layer}"`);
      dims.push(parseFloat(m[1]));
      rest = rest.slice(m[0].length);
    }
    if (dims.length < 2 || dims.length > 4) {
      throw new TokenError(`${ctx}: unparseable shadow layer "${layer}"`);
    }
    return {
      x: dims[0],
      y: dims[1],
      blur: dims.length > 2 ? dims[2] : 0,
      spread: dims.length > 3 ? dims[3] : 0,
      color: parseColorExpr(rest, ctx),
    };
  });
}

function parseGradient(expr, ctx) {
  const inner = expr.slice("linear-gradient(".length, expr.length - 1);
  const parts = splitTopLevel(inner, ",");
  const angleMatch = parts[0].match(/^(-?[\d.]+)deg$/);
  const stopParts = angleMatch ? parts.slice(1) : parts;
  const stops = stopParts.map((text) => {
    const pm = text.match(/\s+(-?[\d.]+)\s*%\s*$/);
    return {
      color: parseColorExpr(pm ? text.slice(0, pm.index) : text, ctx),
      position: pm ? parseFloat(pm[1]) / 100 : null,
    };
  });
  if (stops.length < 2) throw new TokenError(`${ctx}: gradient with fewer than two stops in "${expr}"`);
  return { angle: angleMatch ? parseFloat(angleMatch[1]) : 180, stops };
}

/** Resolve var() references through the scope map (token substitution, as CSS). */
function resolveVars(raw, scope, ctx) {
  let value = raw;
  for (let guard = 0; guard < 16; guard++) {
    const m = value.match(/var\(\s*(--[a-zA-Z0-9-]+)\s*(?:,\s*([^()]+?)\s*)?\)/);
    if (!m) return value.trim();
    const ref = scope.get(m[1]);
    if (ref === undefined) {
      if (m[2] !== undefined) {
        value = value.replace(m[0], m[2]);
        continue;
      }
      throw new TokenError(`${ctx}: unresolved var("${m[1]}")`);
    }
    value = value.replace(m[0], ref);
  }
  throw new TokenError(`${ctx}: var() cycle or nesting too deep in "${raw}"`);
}

const META_PREFIXES = ["--font-", "--space-", "--radius-"];

/** Evaluate one declaration within a scope → {kind, ...}. */
function evaluate(decl, scope) {
  const ctx = `${LABELS[decl.file]}:${decl.line} ${decl.name}`;
  if (META_PREFIXES.some((p) => decl.name.startsWith(p))) return { kind: "meta", raw: decl.raw };
  const value = resolveVars(decl.raw, scope, ctx);
  if (value.startsWith("linear-gradient(")) return { kind: "gradient", ...parseGradient(value, ctx) };
  if (/^(-?[\d.]+(?:px)?\s+)+/.test(value)) return { kind: "shadow", layers: parseShadow(value, ctx) };
  return { kind: "color", color: parseColorExpr(value, ctx) };
}

/** Shape an evaluated token for the JSON (colors, shadow layers, gradient stops). */
function payloadOf(evaluated) {
  if (evaluated.kind === "color") return rgbaOf(evaluated.color);
  if (evaluated.kind === "shadow") {
    return evaluated.layers.map((layer) => ({
      blur: layer.blur,
      color: rgbaOf(layer.color),
      spread: layer.spread,
      x: layer.x,
      y: layer.y,
    }));
  }
  return {
    angle: evaluated.angle,
    stops: evaluated.stops.map((stop) => ({ color: rgbaOf(stop.color), position: stop.position })),
  };
}

function rgbaOf(rgba) {
  return { r: rgba.r, g: rgba.g, b: rgba.b, a: rgba.a };
}

// ─────────────────────────────────────────────────────────────────────────────
// Output shaping — deterministic JSON
// ─────────────────────────────────────────────────────────────────────────────

function round4(x) {
  const v = Math.round((x + Number.EPSILON) * 10000) / 10000;
  return Object.is(v, -0) ? 0 : v;
}

function deepRound(value) {
  if (typeof value === "number") return round4(value);
  if (Array.isArray(value)) return value.map(deepRound);
  if (value && typeof value === "object") {
    const out = {};
    for (const k of Object.keys(value)) out[k] = deepRound(value[k]);
    return out;
  }
  return value;
}

function stableStringify(value) {
  const walk = (v) => {
    if (Array.isArray(v)) return v.map(walk);
    if (v && typeof v === "object") {
      const out = {};
      for (const k of Object.keys(v).sort()) out[k] = walk(v[k]);
      return out;
    }
    return v;
  };
  return `${JSON.stringify(walk(value), null, 2)}\n`;
}

function assembleEntry(lightEval, darkEval, declarations, variants) {
  if (lightEval.kind === "meta" || darkEval.kind === "meta") return null;
  if (lightEval.kind !== darkEval.kind) {
    throw new TokenError(`token kind differs between themes: ${lightEval.kind} vs ${darkEval.kind}`);
  }
  const light = deepRound(payloadOf(lightEval));
  const dark = deepRound(payloadOf(darkEval));
  const themeDependent = JSON.stringify(light) !== JSON.stringify(dark);
  const entry = { themeDependent, source: declarations[0] ?? null, declarations };
  if (themeDependent) {
    entry.light = light;
    entry.dark = dark;
  } else {
    entry.value = light;
  }
  if (variants) entry.variants = variants;
  return entry;
}

// ─────────────────────────────────────────────────────────────────────────────
// Main
// ─────────────────────────────────────────────────────────────────────────────

function main() {
  // ── Base layer (:root custom props + typography rules) ──────────────────
  const baseCss = stripComments(readFileSync(FILES.base, "utf8"));
  const baseDecls = new Map();
  const typographySizes = {};
  for (const rule of extractRules(baseCss)) {
    if (rule.selector === ":root") {
      for (const decl of declarationsOf(rule)) {
        baseDecls.set(decl.name, {
          name: decl.name,
          raw: decl.raw,
          file: "base",
          line: lineOf(baseCss, decl.index),
          scope: "base",
        });
      }
    } else if (/^h[1-6]$/.test(rule.selector)) {
      const size = rule.body.match(/font-size:\s*([\d.]+)px/);
      if (size) typographySizes[rule.selector] = parseFloat(size[1]);
    } else if (rule.selector === "body") {
      const size = rule.body.match(/font-size:\s*([\d.]+)px/);
      if (size) typographySizes.body = parseFloat(size[1]);
    }
  }
  if (Object.keys(typographySizes).length !== 7) {
    throw new TokenError(`${LABELS.base}: could not derive all typography sizes`);
  }

  // ── Shell layer (Aurel.dc.html) ──────────────────────────────────────────
  const shellHtml = readFileSync(FILES.shell, "utf8");
  const shellText = styleBlockOf(shellHtml, "shell");
  const shellDarkBase = captureSelectors(shellText, "shell", new Map([[".aurel-dark", "base-dark"]]));
  const shellStage = captureSelectors(shellText, "shell", new Map([[".au-stage", "shell"]]));
  const shellStageDark = captureSelectors(shellText, "shell", new Map([[".au-stage.aurel-dark", "shell-dark"]]));

  // ── Player layer (CourseScreen.dc.html) ─────────────────────────────────
  const playerHtml = readFileSync(FILES.player, "utf8");
  const playerText = styleBlockOf(playerHtml, "player");
  const playerDarkBase = captureSelectors(playerText, "player", new Map([[".aurel-dark", "base-dark"]]));
  const playerWrap = captureSelectors(playerText, "player", new Map([[".au-wrap", "player"]]));
  const playerWrapDark = captureSelectors(playerText, "player", new Map([[".au-wrap.aurel-dark", "player-dark"]]));

  // ── Cascades (name → raw value) ─────────────────────────────────────────
  const shellLightMap = mergeCaptured([baseDecls, shellStage]);
  const shellDarkMap = mergeCaptured([baseDecls, shellDarkBase, shellStageDark]);
  const playerLightMap = mergeCaptured([baseDecls, playerWrap]);
  const playerDarkMap = mergeCaptured([baseDecls, playerDarkBase, playerWrapDark]);

  const scopeOf = (map) => new Map([...map].map(([name, decl]) => [name, decl.raw]));
  const shellLightScope = scopeOf(shellLightMap);
  const shellDarkScope = scopeOf(shellDarkMap);
  const playerLightScope = scopeOf(playerLightMap);
  const playerDarkScope = scopeOf(playerDarkMap);

  // Canonical names: everything the base + shell cascade defines.
  const canonicalNames = new Set([...shellLightMap.keys(), ...shellDarkMap.keys()]);

  const colors = {};
  const shadows = {};
  const gradients = {};
  for (const name of [...canonicalNames].sort()) {
    if (META_PREFIXES.some((p) => name.startsWith(p))) continue;

    const lightEval = evaluate(findDecl(name, [baseDecls, shellStage]), shellLightScope);
    const darkEval = evaluate(findDecl(name, [baseDecls, shellDarkBase, shellStageDark]), shellDarkScope);

    // Declaration trail across every layer that mentions the token.
    const seen = new Set();
    const declarations = [];
    for (const source of [baseDecls, shellDarkBase, shellStage, shellStageDark, playerDarkBase, playerWrap, playerWrapDark]) {
      const decl = source.get(name);
      if (!decl) continue;
      const key = `${LABELS[decl.file]}:${decl.line}`;
      if (seen.has(key)) continue;
      seen.add(key);
      declarations.push({ file: LABELS[decl.file], line: decl.line, scope: decl.scope });
    }

    // Player variants (parallel document — not a continuation of the cascade).
    let variants = null;
    if (playerLightMap.has(name) || playerDarkMap.has(name)) {
      const pLight = deepRound(
        payloadOf(evaluate(findDecl(name, [baseDecls, playerWrap]), playerLightScope))
      );
      const pDark = deepRound(
        payloadOf(evaluate(findDecl(name, [baseDecls, playerDarkBase, playerWrapDark]), playerDarkScope))
      );
      const lLight = deepRound(payloadOf(lightEval));
      const lDark = deepRound(payloadOf(darkEval));
      if (JSON.stringify(pLight) !== JSON.stringify(lLight) || JSON.stringify(pDark) !== JSON.stringify(lDark)) {
        variants = { player: { light: pLight, dark: pDark } };
      }
    }

    const entry = assembleEntry(lightEval, darkEval, declarations, variants);
    if (!entry) continue;
    if (lightEval.kind === "color") colors[name] = entry;
    else if (lightEval.kind === "shadow") shadows[name] = entry;
    else if (lightEval.kind === "gradient") gradients[name] = entry;
  }

  // ── Meta sections ───────────────────────────────────────────────────────
  const space = {};
  const radius = {};
  for (const [name, decl] of baseDecls) {
    if (name.startsWith("--space-")) space[name.slice(8)] = parseFloat(decl.raw);
    if (name.startsWith("--radius-")) radius[name.slice(9)] = parseFloat(decl.raw);
  }
  if (Object.keys(space).length !== 6 || Object.keys(radius).length !== 3) {
    throw new TokenError(`${LABELS.base}: could not derive all --space-*/--radius-* values`);
  }

  const typeZoomMatch = shellHtml.match(/typeZoom:\s*\[([^\]]*)\]\s*\[/);
  if (!typeZoomMatch) throw new TokenError(`${LABELS.shell}: typeZoom literal array not found`);
  const typeZoom = typeZoomMatch[1].split(",").map((s) => parseFloat(s.trim()));
  if (typeZoom.length !== 5 || typeZoom.some((n) => Number.isNaN(n))) {
    throw new TokenError(`${LABELS.shell}: unparseable typeZoom array "${typeZoomMatch[1]}"`);
  }

  const firstFamily = (stack) => stack.split(",")[0].trim().replace(/^["']|["']$/g, "");
  const typography = {
    body: typographySizes.body,
    fontBody: firstFamily(baseDecls.get("--font-body")?.raw ?? ""),
    fontHeading: firstFamily(baseDecls.get("--font-heading")?.raw ?? ""),
    h1: typographySizes.h1,
    h2: typographySizes.h2,
    h3: typographySizes.h3,
    h4: typographySizes.h4,
    h5: typographySizes.h5,
    h6: typographySizes.h6,
  };
  for (const [key, value] of Object.entries(typography)) {
    if (value === "" || value === undefined || Number.isNaN(value)) {
      throw new TokenError(`${LABELS.base}: could not derive typography.${key}`);
    }
  }

  const document = deepRound({
    colors,
    gradients,
    radius,
    shadows,
    space,
    typography,
    typeZoom,
  });

  mkdirSync(dirname(OUT_PATH), { recursive: true });
  writeFileSync(OUT_PATH, stableStringify(document), "utf8");
  console.log(
    `${OUT_PATH}\n  ${Object.keys(colors).length} color tokens · ${Object.keys(shadows).length} shadow tokens · ` +
      `${Object.keys(gradients).length} gradients · typeZoom [${typeZoom.join(", ")}]`
  );
}

main();
