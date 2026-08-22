# Aurel — Mobbin Research (Phase 2)

> Pattern library extracted from award-winning and top-rated iOS apps via the Mobbin MCP server. Every reference cites app + screen. Research lens: the owner's "Evolve the language" decision — keep the paper-and-dusk brand and calm governance; take only patterns that raise craft, feedback quality, and state completeness.

## 2.1 Category & screen types researched

**Category:** self-study language learning (CEFR A1 English), calm/premium positioning.
**Screen families researched:** onboarding & first-run · goal personalization · course-path home · lesson exercise/quiz feedback · streak/habit · progress statistics · leaderboards · speaking/pronunciation practice · paywalls · sign-in. (Settings, profile, and empty/error states were sampled through these families; Aurel's own Settings/Profile are already structurally at parity.)

## 2.2–2.3 Pattern library (with citations)

### P1 — Winding path home
**References:** Duolingo — home path ([screens/673d73bb](https://mobbin.com/screens/673d73bb-bb22-4481-8f14-7cf966c9e7bd)); Babbel — course home ([screens/832f5742](https://mobbin.com/screens/832f5742-a189-409a-8bb1-06f5ed82bb60)); Duolingo ABC — path ([screens/2cbb1330](https://mobbin.com/screens/2cbb1330-0850-49e9-8392-8ad83f4096e8)).
- **Layout:** serpentine vertical path of circular nodes; current node enlarged with a floating "START" bubble; done nodes carry checkmarks; section header cards interrupt the path.
- **Interaction:** tap the current node to enter; completed nodes replayable; locked nodes inert with lock glyph.
- **Micro-interaction:** the path draws in on first load; nodes pop in sequentially.
- **Premium detail:** the current-node bubble is the single most gaze-guiding element on the screen — nothing else competes.
- **Take for Aurel:** our authored winding path + `LessonPathNode` already matches this shape (`HomeView.swift:330+`). Adopt: (a) a floating "current stop" emphasis (adapt our `PingRingStroke` pulse), (b) first-reveal path-drawing animation of `WindingPathShape` (trim animation), (c) sequential node pop-in.

### P2 — Docked verdict banner in exercises
**References:** Duolingo — multiple-choice exercise ([screens/57d38f9d](https://mobbin.com/screens/57d38f9d-5bee-42f9-96f8-85b05f3bf835)); Speak — exercise ([screens/a3172182](https://mobbin.com/screens/a3172182-bc3b-40ce-b408-67984896f50b)); Quizlet — study ([screens/4f303c97](https://mobbin.com/screens/4f303c97-3a12-49ee-83ab-97254c04e17b)).
- **Layout:** feedback banner docked to the bottom edge, full-width solid fill (success green / error red), leading icon, bold headline, trailing CONTINUE button — one container for verdict + next action.
- **Interaction:** answering slides the banner up over the options; CONTINUE lives inside the banner (the thumb stays in place).
- **Micro-interaction:** banner slide + color flood + haptic fire together — color communicates before text is read.
- **Take for Aurel:** our verdict dock (`QuickPracticeViews.swift:41-68`) and verdict cards (`PracticeScreen.swift:518-533`) exist but pop in with no transition. Adopt: slide-up + fade with matched spring; verdict + CTA unified in the dock on player screens; paired success/miss haptics (light impact for success, a softer double-pulse for miss). Do NOT adopt the saturated error fill — our `auErrBg` wash keeps the calm.

### P3 — Streak & habit calendar
**References:** Babbel — streak ([screens/9a4520f9](https://mobbin.com/screens/9a4520f9-45cc-4473-bacb-410dabe093c8)); Duolingo — streak ([screens/801382ea](https://mobbin.com/screens/801382ea-9bcc-4fd6-b461-a14b36161486)); CapWords — streak ([screens/698e946d](https://mobbin.com/screens/698e946d-2671-4af6-a2f2-4c50d8a76aec)).
- **Layout:** streak count hero; week strip (7 day-cells with done/today/future states); month calendar below.
- **Micro-interaction:** today's cell carries a ring/pulse; completed days fill with a celebration-free check.
- **Take for Aurel:** our `StreakView` week dots + month grid exist (`StreakBoardViews.swift`). Adopt: today-cell ring emphasis; data-drive every cell from `DayLog`; keep our milestone numeral (96 pt Caprasimo is stronger than all three references).

### P4 — Progress statistics
**References:** Babbel — progress ([screens/65435f22](https://mobbin.com/screens/65435f22-30a8-440c-9868-8fb64d41c7e9)); Vocabulary — stats ([screens/ab8cfc23](https://mobbin.com/screens/ab8cfc23-fe79-4778-84ee-ddc2895aab55)); Atoms — progress ([screens/fec5430a](https://mobbin.com/screens/fec5430a-a635-4747-8f05-615e9a6fac58)).
- **Layout:** stat tiles row (big numeral + caps label), activity chart (weekly bars), skill/mastery list with progress fills.
- **Take for Aurel:** structure already matches (`ProgressView`). Adopt: real data binding from `LessonRecord`/`DayLog`; accessible chart summary ("8 weeks · 14 lessons · 62 words kept"); no fake history.


### P5 — Paywall plan selection
**References:** Universe — paywall ([screens/a3e314c6](https://mobbin.com/screens/a3e314c6-50b5-4ff3-a704-15232b3c60f1)); Open — paywall ([screens/9638967e](https://mobbin.com/screens/9638967e-59d8-42e5-a19c-a97896be8a52)); Docusign — upgrade ([screens/55456f19](https://mobbin.com/screens/55456f19-449e-4adc-99b6-582f09d2c74d)).
- **Layout:** hero value-prop, feature checklist with icons, two plan cards (annual preselected, "best value" badge), full-width CTA, restore + legal footnote.
- **Micro-interaction:** plan selection animates the border/fill; CTA reflects the selected plan.
- **Take for Aurel:** our Paywall structure matches. Adopt: selected-plan border animation + haptic; CTA text reflecting the chosen plan; keep the honest no-price copy until StoreKit lands, then swap in StoreKit prices.

### P6 — Speaking practice canvas
**References:** Speak — speaking exercise ([screens/3e01c79e](https://mobbin.com/screens/3e01c79e-3175-4df8-9fc6-91966389ffb3)); ElevenLabs — voice recorder ([screens/8cae62f8](https://mobbin.com/screens/8cae62f8-a59e-4423-901a-8d3e49fa32de)); Perplexity — voice mode ([screens/c343a912](https://mobbin.com/screens/c343a912-29df-4a9f-88da-916fc04802e6)).
- **Layout:** calm canvas, prompt text centered and large, a **live amplitude waveform reacting to the actual voice**, big mic button with an animated recording ring, post-take transcript/verdict.
- **Micro-interaction:** waveform shows real input level; recording ring expands with elapsed time; playback scrubs the waveform.
- **Take for Aurel:** adopt live amplitude via `AVAudioRecorder` metering (replacing the `sin()` dummies, `PracticeHubViews.swift:516-531`); recording ring; mic-permission-denied state with recovery path. Verdict copy stays non-punitive — the first-take "near" in error red must go (our own governance).

### P7 — Goal/personalization onboarding
**References:** Oura — onboarding goal ([screens/de098313](https://mobbin.com/screens/de098313-b52d-4e72-a02c-c9e65c958305)); Sesame — onboarding ([screens/8450ffeb](https://mobbin.com/screens/8450ffeb-c0db-43f4-85b8-c77b979cacc3)); Substack — interests ([screens/fbb0f72a](https://mobbin.com/screens/fbb0f72a-66db-4e8b-beb0-dd79ddf29a11)).
- **Layout:** one question per screen; large selectable cards (icon + title + one-line payoff); progress dots or step meter at top; Continue fixed at bottom.
- **Micro-interaction:** selection has immediate state change + haptic; cards stagger in.
- **Take for Aurel:** Goal/Commit already match this pattern (`OnboardingViews.swift`). Adopt: selection haptic; VoiceOver "Step 1 of 2" announcement; visible cap feedback when picking a third goal.

### P8 — Leaderboard
**References:** Strava — leaderboard ([screens/0208fae7](https://mobbin.com/screens/0208fae7-8d33-4d85-8270-f8d371facc83)); Garmin Connect — leaderboard ([screens/c4a2065f](https://mobbin.com/screens/c4a2065f-afdd-498f-9574-6807d06eb709)); Grab — rewards leaderboard ([screens/12f217fa](https://mobbin.com/screens/12f217fa-3a69-4415-b42a-92191201a520)).
- **Layout:** ranked rows (rank numeral, avatar, name, score); my-row visually elevated; top-3 get distinct treatment.
- **Take for Aurel:** keep our rules-first, opt-in framing (more honest than all three references). Adopt: "you" accessibility marker on my-row; top-3 rank numerals in accent (partially present, `StreakBoardViews.swift:428`).

### P9 — Welcome / first-run hero
**References:** Oura — welcome ([screens/d1e9091b](https://mobbin.com/screens/d1e9091b-7b5d-424b-b9eb-9807f03bb488)); Starling — welcome ([screens/75822066](https://mobbin.com/screens/75822066-882d-4a6c-bc29-1d5f45d1e11b)); Wispr Flow — welcome ([screens/7dcabff0](https://mobbin.com/screens/7dcabff0-a543-4190-b9c0-afdcdc1b718f)).
- **Layout:** full-bleed brand moment; one-line value prop; single primary CTA; quiet secondary sign-in; **launch-screen continuity** (icon/launch color matches the first screen).
- **Take for Aurel:** our Welcome is already the strongest screen. Adopt only: a branded launch screen (dusk gradient + wordmark) to kill the white flash (audit B1).


## 2.4 Reference map — our screens → best references

| Our screen (file) | Best references (app + screen) | Exactly what to take |
|---|---|---|
| Welcome (`WelcomeView.swift`) | P9: Oura welcome; Starling welcome | Branded launch screen continuity; keep everything else |
| Goal (`OnboardingViews.swift`) | P7: Oura onboarding goal; Sesame onboarding | Selection haptic; step announcements; cap feedback |
| Commit (`OnboardingViews.swift`) | P7: Substack interests | Same as Goal |
| Plan (`OnboardingViews.swift`) | P9: Starling welcome (value-summary rhythm) | Stagger choreography parity; nothing structural |
| Login (`LoginView.swift`) | P9: Starling welcome (secondary-sign-in quietness) | Make "Forgot password" a real button; field focus flow |
| Home (`HomeView.swift`) | P1: Duolingo path home; Babbel course home | Current-stop emphasis; path draw-in; node pop-in |
| Course chrome (`CoursePlayerView.swift`) | P2: Duolingo exercise chrome | Screen-swap transitions; progress announcements |
| Player screens (`Screens/*.swift`) | P2: Duolingo/Speak/Quizlet exercise patterns | Docked verdict with slide + haptic; unified verdict+CTA; S2-011 hint surfacing |
| Lesson runner (`QuickPracticeViews.swift`) | P2: Duolingo exercise; Quizlet study | Dock slide animation; verdict haptics; review-mode badge |
| Result (`QuickPracticeViews.swift`) | P4: Atoms/Babbel stat tiles | Real week dots from `DayLog`; completion haptic; stat-tile AX summaries |
| Streak (`StreakBoardViews.swift`) | P3: Babbel streak; Duolingo streak | Today-cell ring; `DayLog`-driven cells; calm milestone moment |
| Leaderboard (`StreakBoardViews.swift`) | P8: Strava; Garmin leaderboards | "You" AX marker; my-row emphasis; top-3 treatment |
| Stories hub (`PracticeHubViews.swift`) | P1: Babbel course home (hub rows) | Stagger entrance; live sub-states (already authored) |
| Scene (`PracticeHubViews.swift`) | P6: Speak conversation exercise | Turn-transition animation; TTS-speaking state indicator |
| Speak (`PracticeHubViews.swift`) | P6: Speak; ElevenLabs recorder | Live waveform; recording ring; permission-denied state; honest verdict |
| Review (`PracticeHubViews.swift`) | P4: Vocabulary stats (due lists) | Real due dates from `ReviewScheduler`; due-badge styling |
| Progress (`ProgressProfileSettingsPaywall.swift`) | P4: Babbel/Vocabulary/Atoms stats | Real data; AX chart summary; remove fake history |
| Profile (same file) | P8: Garmin profile rows | Row consistency; nothing structural |
| Settings (same file) | — (structural parity already) | Wire the four dead toggles; time-picker for reminder |
| Paywall (same file) | P5: Universe; Open; Docusign | Plan-selection animation + haptic; CTA reflects plan; StoreKit states when wired |
| SubscribeAccount (same file) | P5: Docusign account step | Field styling consistency with Login; validation states |

**Cross-cutting takeaways (all references):** every reference app *feels* alive at the moment of action — color + motion + haptic fire together (P2), state changes are always animated (P1, P5, P6), and no reference ships dead controls or fake data. This confirms the Phase 1 diagnosis: Aurel's gap is execution depth (feedback + state craft + data honesty), not identity.
