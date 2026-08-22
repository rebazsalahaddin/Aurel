# Aurel — Gap Analysis (Phase 3)

> Cross-reference of Phase 1 (`AUDIT_FINDINGS.md`) against Phase 2 (`MOBBIN_RESEARCH.md`). Per screen: (1) issues to fix [code citation], (2) improvements [Mobbin reference], (3) missing features/patterns [benchmark], (4) design-system changes required. Severity from `qa/defects.md` scale.

## 0. System-level gaps (apply before any screen work)

1. **Haptic feedback layer — missing entirely.** Dead Settings toggle (`ProgressProfileSettingsPaywall.swift:681-683`), zero generator call sites (audit A.5). Benchmark: every P2–P8 reference fires haptics at action moments. **Required:** `AUFeedback` service (success/miss/selection/toggle/complete patterns), gated by the existing `sw.haptics` preference + reduced-motion.
2. **Sound design layer — missing.** Dead toggle (`:680`). **Required:** tiny authored sound set (correct chime, soft miss thud, completion arpeggio, streak dawn), gated by `sw.sound`; audio session ducking under TTS.
3. **Motion system — one fade only.** `auScreenEntrance` (audit A.5) carries all transitions; verdicts/docks/hints/turns pop instantly. Benchmark P2/P6. **Required:** a motion spec (Phase 4 §2.6): transition tokens for state changes, screen-swap transitions, and choreography rules; all gated by reduce-motion.
4. **State-transition animations for dynamic content.** Lesson/scene/verdict state swaps unanimated (`PracticeScreen.swift:518-559`, `PracticeHubViews.swift` scene turns). Same benchmark.
5. **Data honesty pass.** Hard-coded/fake values: Result week dots (`QuickPracticeViews.swift:914-941`), streak "Since 15 August"/"Best 47" (`StreakBoardViews.swift:26,48`), Progress "Since 15 August"/"Last practised Thursday" (`ProgressProfileSettingsPaywall.swift:65,72`), review due labels (`PracticeHubViews.swift:916`), speak verdict (`AppRouter.swift:703`), leaderboard mock (`StreakBoardViews.swift:410-414`). **Required:** derive from SwiftData (`LearnerProfile`, `DayLog`, `LessonRecord`, `MistakeItem`) — the models already exist (`Persistence/Models.swift`).
6. **Dead controls.** "Forgot password" text (`LoginView.swift:61-67`), four notification toggles (`ProgressProfileSettingsPaywall.swift:694-715`), widget preview (`:720-742`). **Required:** wire UserNotifications (reminder at the chosen time; the honest dawn/sundown/milestone/cohort gates) or reframe copy; remove/replace the widget row until a widget extension exists.
7. **Device-adaptivity.** Fixed 874/790 min-heights (`QuickPracticeViews.swift:897`, `PracticeHubViews.swift:775,883`, `CoursePlayerView.swift:166`), absolute path coordinates (`HomeView.swift:486-506`). **Required:** available-height-driven layouts; AX-type stress test in the QA harness.
8. **Contrast verification.** Unmeasured dusk-art text tiers and 0.4–0.6 opacity metas (audit A.1, B26.10). **Required:** extend `qa/evidence/token-contrast.json` tooling to composite-on-art cases; fix any < 4.5:1 body / < 3:1 large.
9. **VoiceOver strategy.** No announcements for verdicts, steps, progress (audit B26.9). **Required:** AX assertions at: onboarding steps, player advance, verdict, streak change, chart summaries.
10. **Brand first-touch.** Empty app icon + blank launch screen (audit B26.6, `project.yml:40`). **Required:** authored app icon (dusk gradient + A mark) and branded launch screen.

## 1. Welcome (`WelcomeView.swift`)
1. **Fix:** blank launch flash before dusk hero (audit B1; `project.yml:40`).
2. **Improve:** launch→hero continuity [P9: Oura/Starling welcome].
3. **Add:** none — screen is at benchmark.
4. **DS:** launch-screen token set (dusk gradient stops).

## 2. Goal (`OnboardingViews.swift` — GoalView)
1. **Fix:** nothing broken.
2. **Improve:** selection haptic + row press feedback [P7: Oura goal]; stagger parity already present.
3. **Add:** "Step 1 of 2" VoiceOver announcement (design README requires it); visible cap feedback at the third goal pick (currently copy-only).
4. **DS:** `AUFeedback.selection` token.

## 3. Commit (`OnboardingViews.swift` — CommitView)
1. **Fix:** reminder choice has no consequence — wire or reframe (audit B3).
2. **Improve:** chip selection haptic [P7: Substack].
3. **Add:** reminder-time adjustment later in Settings (see 18).
4. **DS:** none beyond system haptics.

## 4. Plan (`OnboardingViews.swift` — PlanView)
1. **Fix:** nothing broken.
2. **Improve:** dusk-cream 0.62 contrast verification (audit B4).
3. **Add:** none.
4. **DS:** contrast-checked art-text tier.

## 5. Login (`LoginView.swift`)
1. **Fix:** dead "Forgot password" link — make it a Button with a real flow (audit B5, `:61-67`).
2. **Improve:** quiet secondary-sign-in pattern retained [P9: Starling].
3. **Add:** keyboard return-key flow email→password→submit; assertive error announcement; password visibility toggle.
4. **DS:** `AUField` error state (border + message slot).


## 6. Home (`HomeView.swift`)
1. **Fix:** fixed path coordinates risk AX-type collisions (`:486-506`); hand-tuned bottom clearance (`:24`).
2. **Improve:** current-stop emphasis treatment; first-reveal path draw-in; sequential node pop-in [P1: Duolingo path home, Babbel course home].
3. **Add:** scroll-linked sun travel on the day-arc (premium signature moment); locked-stop explainer affordance ("Why locked?" hint on tap, before the paywall — calm framing).
4. **DS:** path animation tokens; node emphasis ring spec.

## 7. Course player chrome (`CoursePlayerView.swift`)
1. **Fix:** `minHeight: 790` rigidity (`:166`); bare "Loading course…" (`:139-143`).
2. **Improve:** screen-swap transition (directional slide/fade matched to player progress) [P2: Duolingo exercise chrome]; progress-rail animation retained.
3. **Add:** "Lesson 1, screen 5 of 40" AX announcement on advance; authored loading treatment (paper + wordmark pulse).
4. **DS:** player transition token; loading state spec.

## 8. Player screens — Core (`CoreScreens.swift`)
1. **Fix:** placeholder stripe field is every lesson's first impression (audit B21) — art-direct the placeholder itself.
2. **Improve:** tap-anywhere advance + `PingDot` retained; add press haptic and continue-slide [P2].
3. **Add:** audio-playing state tint on card listen buttons (`WaveForm` exists — add active tint).
4. **DS:** placeholder illustration v2 spec (Phase 4 §2.7) — keeps ILL ID + alt contract, adds brand pattern.

## 9. Player screens — Practice renderer (`PracticeScreen.swift`)
1. **Fix:** **S2-011** order-item hints never surface (10/15 items carry authored hints; `qa/defects.md:71`); verdict/hint cards pop with no transition (`:518-559`).
2. **Improve:** docked verdict pattern — slide-up, color flood, verdict + CTA unified [P2: Duolingo, Quizlet]; success/miss haptics [P2].
3. **Add:** AX verdict announcement; hint-ladder entrance animation (staggered reveal).
4. **DS:** verdict dock motion spec; haptic pairing table.

## 10. Player screens — Assembly (`AssemblyScreens.swift`)
1. **Fix:** tile pick/unpick unanimated; "Undo all" feedback-less (audit B23).
2. **Improve:** tile insert/remove transitions (matched geometry, spring) [P1 node pop-in energy applied to chips]; undo haptic [P2].
3. **Add:** sentence-completion micro-celebration when the assembly is correct (calm: glow pulse + haptic, no confetti — governance).
4. **DS:** tile motion spec (insert/remove/reorder).

## 11. Player screens — Language (`LangScreens.swift`)
1. **Fix:** 0.34–0.42-opacity meta text contrast unverified (audit B24).
2. **Improve:** pronProduce shares Speak's mock-verdict issue (see §16) — same fix.
3. **Add:** grammar-table row tap-to-hear (audio affordance parity with cards); conversation turn-transition animation.
4. **DS:** meta-text opacity floor after the contrast pass.

## 12. Player screens — Assess (`AssessScreens.swift`)
1. **Fix:** nothing broken (audit B25).
2. **Improve:** quiz-results reveal animation (bars fill sequentially) [P4: Atoms/Babbel].
3. **Add:** AX summaries for the results breakdown; chapter-map entry pulse on the next chapter.
4. **DS:** chart-fill motion token.

## 13. Lesson runner (`QuickPracticeViews.swift` — LessonRunnerView)
1. **Fix:** verdict dock appears/disappears unanimated (audit B8); fixed `minHeight: 874` on Result (`:897`).
2. **Improve:** dock slide + spring [P2: Duolingo exercise]; auto-advance rhythm kept; verdict haptics.
3. **Add:** review-mode badge when running the mistake queue; keyboard-avoidance audit for order items.
4. **DS:** dock motion spec; badge token.

## 17. Review (`PracticeHubViews.swift` — ReviewView)
1. **Fix:** **S2** due labels are positional guesses (`:916`) — use `ReviewScheduler` dates.
2. **Improve:** due-badge styling by urgency [P4: Vocabulary due lists].
3. **Add:** none — conceptually ahead of benchmarks.
4. **DS:** due-badge token pair.

## 18. Progress (`ProgressProfileSettingsPaywall.swift` — ProgressView)
1. **Fix:** **S1** hard-coded dates/copy (`:65,72`); **S2** synthetic skill numbers (`:25-55`); 8-week chart provenance.
2. **Improve:** real `LessonRecord`/`DayLog` binding; AX chart summary [P4: Babbel/Vocabulary/Atoms].
3. **Add:** tap-through from skill rows to matching practice (partially wired — verify Conversation/Speaking paths).
4. **DS:** chart data contract.

## 19. Profile (same file — ProfileView)
1. **Fix:** static milestones copy.
2. **Improve:** row consistency pass [P8: Garmin profile rows].
3. **Add:** none required.
4. **DS:** none.

## 20. Settings (same file — SettingsView)
1. **Fix:** **S2** four dead toggles (`:680-715`); widget preview promises a missing product (`:720-742`).
2. **Improve:** toggle haptic + switch motion [P7 selection feedback]; slider value announcement.
3. **Add:** reminder time-picker row (chips as in Commit); notification-permission system flow on first enable.
4. **DS:** settings row motion spec.

## 21. Paywall (same file — PaywallView)
1. **Fix:** **S1** simulated purchase (`AppRouter.swift:724-732`) — label as demo or wire StoreKit (owner decision).
2. **Improve:** plan-selection border animation + haptic; CTA reflects plan [P5: Universe/Open/Docusign].
3. **Add:** purchase pending/failure/restore states (with StoreKit); manage-subscription deep link.
4. **DS:** plan-card selected-state spec.

## 22. SubscribeAccount (same file — SubscribeAccountView)
1. **Fix:** field styling inconsistent with Login (`:1337-1382`).
2. **Improve:** reuse `AUField`/`AUTextField` [P5: Docusign account step].
3. **Add:** field-level validation states; confirm-password.
4. **DS:** shared field component adoption.

## 23. Leaderboard (`StreakBoardViews.swift` — LeaderboardView)
1. **Fix:** **S2** mock board data (`:410-414`) — label as sample or wire cohort (owner decision; design README open decision #2).
2. **Improve:** "you" AX marker; my-row emphasis [P8: Strava/Garmin].
3. **Add:** none — deliberately subordinate by governance.
4. **DS:** my-row emphasis token.

## 24. Scene (`PracticeHubViews.swift` — SceneView)
1. **Fix:** turn advance unanimated (audit B13).
2. **Improve:** turn-transition slide/fade [P6: Speak conversation]; TTS-speaking indicator on the active turn.
3. **Add:** scene-complete calm moment (one line + haptic).
4. **DS:** conversation motion spec.

## 25. Stories hub (`PracticeHubViews.swift` — StoriesView)
1. **Fix:** nothing broken.
2. **Improve:** row stagger entrance [P1: Babbel hub rows — parity with our own onboarding stagger].
3. **Add:** none.
4. **DS:** reuse `auStagger`.

## 26. Offline / cross-cutting states
1. **Fix:** offline banner mounts on Home only — acceptable for bundled content (TTS is on-device).
2. **Improve:** none required.
3. **Add:** copy check that Speak's recognition is on-device (offline claim).
4. **DS:** none.

## Priority synthesis (feeds Phase 4 ordering)
1. **System layers first:** haptics + sound + motion specs + data honesty + AX assertions (gaps §0.1–0.5, §0.9) — these unlock every screen's fixes.
2. **Highest-value screens:** Practice renderer + Lesson runner (the product's core loop, P2), Home (first-run signature, P1), Speak (honesty S1), Result/Streak/Progress (data honesty S1s).
3. **Then:** chrome transitions, assembly/language/assess polish, onboarding AX, login/subscribe fixes, paywall states, leaderboard sample labeling, app icon + launch screen.


## 14. Result (`QuickPracticeViews.swift` — ResultView)
1. **Fix:** **S1** hard-coded week dots (`i == 0`, `:914-941`) — must derive from `DayLog`.
2. **Improve:** stat tiles + AX summaries [P4: Atoms/Babbel]; completion haptic + calm reveal choreography.
3. **Add:** share affordance optional — defer to owner.
4. **DS:** completion moment spec (Phase 4 §2.6).

## 15. Streak (`StreakBoardViews.swift` — StreakView)
1. **Fix:** **S1** "Since 15 August" hard-coded (`:26`); "Best 47" fake (`:48`).
2. **Improve:** today-cell ring emphasis; `DayLog`-driven cells [P3: Babbel/Duolingo streak].
3. **Add:** calm milestone moment at 7/30/100 days (authored line + dawn glow, no confetti).
4. **DS:** milestone moment spec.

## 16. Speak (`PracticeHubViews.swift` — SpeakView)
1. **Fix:** **S1** mock verdict — first take always "near" in error styling (`AppRouter.swift:703`, `SpeakView.swift:536-537,662-697`); `sin()` dummy waveforms (`:516-531`); `SpeechToText` service unused (grep-verified).
2. **Improve:** live amplitude waveform via `AVAudioRecorder` metering; recording ring [P6: Speak, ElevenLabs].
3. **Add:** mic-permission denied state + recovery path; wire `SpeechToText` for a real (clarity-only, non-accent) check, or honestly relabel the meter as takes without verdict coloring.
4. **DS:** recording-state motion spec; verdict copy tiers.
