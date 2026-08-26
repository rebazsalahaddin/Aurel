# English Course App — UI/UX, Audio & Feature Enhancement Prompt

You are a senior iOS engineer, world-class UX designer, audio implementation specialist, and educational app architect.

Your task is to improve the existing English Course App according to the requirements below.

IMPORTANT:
This is an enhancement task, NOT a redesign.

Preserve:
- Existing architecture.
- Existing visual identity.
- Existing successful user flows.
- Existing lesson structure.

Do not randomly create, remove, or restructure screens.

---

## PHASE 0 — COMPLETE PROJECT AUDIT

Before changing anything:

Analyze:

- Full project structure.
- Current UI implementation.
- Navigation.
- Components.
- Lesson screens.
- Audio system.
- Exercise system.
- Data models.
- Resources.

Understand how everything currently works.

Then create an implementation plan.

Wait for approval before coding.

---

## PHASE 1 — HOME SCREEN IMPROVEMENTS

### Replace Settings and You positions

Current:
Top-right gear icon = Settings

Change to:
Top-right icon = You/profile placeholder.

Tab bar:
You icon becomes Settings.

The profile icon should represent future avatar/profile functionality.

---

### Simplify Resume Lesson Area

The home screen should not feel crowded.

Replace multiple boxes with one clean lesson card.

Logic:

First-time user:
Show:
"Start Lesson 1"

Returning user:
Show:
"Resume Lesson X"

Include:
- Resume button.
- Restart lesson button inside the same card.

Do not create additional cards.

Maintain a clean premium design.

---

### Lesson Progress Animation

Review the circular/path progress animation.

Verify:

- Animation moves correctly after completing lessons.
- Progress follows the intended trajectory.
- Movement is smooth.
- No visual bugs exist.

Replace:
"Day 1"

With:
"Lesson 1 - Say Hello"

Remove:
"First half recommended lesson..." tooltip.

---

## PHASE 2 — AUDIO SYSTEM UPGRADE

Replace Apple robotic voices.

Use ElevenLabs high-quality voices.

Ask for required API credentials before implementation.

Requirements:

- Generate realistic HD voices.
- Follow pronunciation instructions from the course folder.
- Store generated audio locally.
- Allow offline playback.

Apply to:

- Lesson introductions.
- Conversations.
- Vocabulary cards.
- Listening exercises.
- Listen and choose exercises.

---

## PHASE 3 — TEXT HIGHLIGHT SYNCHRONIZATION

During audio playback:

Highlight the exact spoken word or sentence.

Example:

Audio says:
"Hello"

The "Hello" text should:
- Highlight.
- Animate smoothly.
- Guide user attention.

Animation should support learning.

---

## PHASE 4 — SPEAKING FEATURE IMPLEMENTATION

Fix the "Listen and Say" feature.

Current problem:
Microphone opens but functionality fails.

Implement:

1. Play reference ElevenLabs audio.
2. Record user's voice.
3. Analyze pronunciation.
4. Compare with reference.
5. Provide feedback.

Fix all related crashes and runtime errors.

---

## PHASE 5 — EXERCISE ACCURACY REVIEW

Review all exercises.

Verify:

- Images match questions.
- Audio matches text.
- Answers are correct.
- Illustrations are appropriate.
- Resources are correctly connected.

---

## PHASE 6 — TESTING METHOD

Do NOT test the entire app after every change.

After each phase test only:

- Modified screens.
- Modified components.
- Related interactions.

Verify:

- UI works.
- Navigation works.
- Audio works.
- Animations work.
- No crashes occur.

---

## EXECUTION CONTROL

Complete implementation in phases.

After every phase:

STOP.

Provide:

- Summary.
- Files changed.
- Testing results.
- Remaining issues.

Wait for approval before continuing.

Never proceed automatically.

Final objective:

Create a polished, modern, premium English learning application with excellent UX, realistic audio, effective learning interactions, and preserved design quality.
