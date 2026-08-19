# Audio Style Guide

This project produces **scripts only**. No recordings exist; `recording_filename` values are planned names; every record starts at `qa_status: script_review`.

## Voices

| Voice | Used for | Direction |
|---|---|---|
| Guide voice (uncredited, neutral GA) | instructions, prompts, corrections | warm, unhurried, encouraging; never condescending |
| Alex (they/them) | cast lines | bright, mid-high, quick but clear |
| Maya (she/her) | cast lines | warm, medium, calm |
| Leo (he/him) | cast lines | lower, relaxed, friendly |
| Nina (she/her) | cast lines | clear, evenly paced, patient |
| Sam (he/him) | cast lines | mid-range, quick, cheerful (speaking since C1-L4; table row added C3-L1 to close a guide gap) |
| Amara (she/her) | one-off newcomer lines, C4 | warm-bright, medium pace (new performer; registered with her bible entry before first use) |
| Rafael (he/him) | one-off newcomer lines, C4 | lively, medium-low (new performer; registered with his bible entry before first use) |

Casting note (for the human production stage): professional performers or qualified English teachers; consistent character voices across all assets; General American model per `DECISIONS.md`.

## Delivery styles (enum — use exactly these)

- `learning_slow_clear` — slow-clear natural speech: slower than conversational, fully natural prosody, no word-by-word robotic delivery, no digital stretching. Used for instruction, models, and learning takes.
- `challenge_natural_slow` — a **fresh recording** of equivalent content: slightly faster, connected, reduced support. Never a sped-up edit of the learning take.
- `level_natural` — natural rate; reserved for later levels (not A1 core except unscored A2 preview).

## pacing targets (A1)

- Learning takes: ≈ 100–110 wpm; pauses 400–600 ms at thought boundaries; key words (names, numbers, times, prices) slightly emphasized, never isolated robotically.
- Challenge takes: ≈ 120–130 wpm.
- Word-model assets: item once, 300 ms pause, item once more with natural intonation.

## Script notation (inside `script` fields)

- `…` = pause 400–600 ms; `…!` = emphatic but friendly stress on the preceding word.
- `(warm)` `(surprised)` `(apologetic)` = emotion context for the performer.
- Speaker labels only in dialogue scripts: `ALEX:`, `MAYA:`, `LEO:`, `NINA:`, `GUIDE:`.

## Integrity rules

- Listening tests listening: transcripts hidden until `transcript_release` conditions (§10.7) are met.
- One default replay permitted on listening items; replays logged diagnostically, never penalized.
- Music/sound effects never mask speech; ducked or absent under voice.
- Names, numbers, times, prices, and contractions are verified character-by-character before a script leaves `script_review`.

## Planned filename convention

`<ASSET_ID>_<style>_<take>.wav` (e.g., `A1-C01-AUD001_learning_take1.wav`) — assigned at recording time; referenced here as planned names only.
