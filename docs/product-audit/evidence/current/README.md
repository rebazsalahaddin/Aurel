# Current-app evidence manifest

- **Status:** Observed unless a row says otherwise
- **Captured:** 2026-08-24, Asia/Baghdad
- **Build:** Aurel 0.1.0 (1), bundle `com.aurel.app`, current worktree at `6b43f1c331d14a6e8ae46840da95cac4e9c0cbc1`
- **Default capture configuration:** iPhone 17e simulator, iOS 26.5, portrait, 1170×2532 pixels, system/light appearance, default app text step, English locale
- **Boundary configuration:** iPhone 17 Pro Max simulator, iOS 26.5, portrait, 1320×2868 pixels; Accessibility XXXL or dark appearance as named
- **Route method:** `-AUREL_TEST_START <route>`. `AppRouter` documents this as a pure verification route that does not persist onboarding state.
- **Data state:** Isolated simulator data created by the audit test run; no real credentials or private user data. Some captures therefore show a completed first lesson. This is intentional and is noted in the current-state report.

## Screenshot inventory

| ID | File | Route/state | Reproduction note |
|---|---|---|---|
| SCR-001 | `SCR-001-welcome.png` | Welcome / first-launch entry | Verification route `welcome` |
| SCR-002 | `SCR-002-goal.png` | Goal selection / two selected | Verification route `goal`; data state has two selected goals |
| SCR-003 | `SCR-003-commit.png` | Commitment and reminder | Verification route `commit` |
| SCR-004 | `SCR-004-plan.png` | Plan preview | Verification route `plan` |
| SCR-005 | `SCR-005-login.png` | Returning-user sign in | Verification route `login` |
| SCR-006 | `SCR-006-home.png` | Home after lesson 1 | Verification route `home` |
| SCR-007 | `SCR-007-course.png` | Bound course player, first authored screen | Verification route `course` |
| SCR-008 | `SCR-008-lesson.png` | Quick-practice card runner | Verification route `lesson` |
| SCR-009 | `SCR-009-result.png` | Lesson completion/result | Verification route `result` |
| SCR-010 | `SCR-010-streak.png` | Streak detail | Verification route `streak` |
| SCR-011 | `SCR-011-leaderboard.png` | Sample Cedar Group | Verification route `leaderboard` |
| SCR-012 | `SCR-012-stories.png` | Practice hub and story list | Verification route `stories` |
| SCR-013 | `SCR-013-scene.png` | Scene role-play | Verification route `scene` |
| SCR-014 | `SCR-014-speak.png` | Say-it-aloud, idle | Verification route `speak` |
| SCR-015 | `SCR-015-review.png` | Review empty state | Verification route `review` |
| SCR-016 | `SCR-016-progress.png` | Progress, partially populated | Verification route `progress` |
| SCR-017 | `SCR-017-profile.png` | Guest profile, populated | Verification route `profile` |
| SCR-018 | `SCR-018-settings.png` | Settings, top | Verification route `settings` |
| SCR-019 | `SCR-019-paywall.png` | Paywall, initial scroll position | Verification route `paywall` |
| SCR-020 | `SCR-020-subscribeAccount.png` | Create-account subscription form | Verification route `subscribeAccount` |
| STA-024 | `STA-024-settings-axxxl-pro-max.png` | Settings at Accessibility XXXL | Pro Max launch arguments include `UICTContentSizeCategoryAccessibilityXXXL` |
| STA-025 | `STA-025-home-dark-pro-max.png` | Home in dark appearance | Pro Max simulator set to dark appearance, verification route `home` |

## Baseline verification records

The raw `.xcresult` bundles are in the audit-only derived-data path `/private/tmp/aurel-product-audit-derived/Logs/Test/` and are not copied into the repository because they are large, transient build artifacts.

| Check | Result | Evidence location |
|---|---|---|
| Debug build, iPhone 17 Pro | Passed | Terminal result; `BUILD SUCCEEDED` |
| `AurelTests` | 93 passed, 0 failed | `Test-Aurel-2026.08.24_21-54-56-+0300.xcresult` |
| `SmokeSuite` | 4 passed, 0 failed | `Test-Aurel-2026.08.24_21-56-07-+0300.xcresult` |
| `MilestoneSuite` | 4 passed, 1 failed | `Test-Aurel-2026.08.24_21-57-32-+0300.xcresult` |
| AX3XL on iPhone 17 Pro Max | 1 passed, 0 failed | `Test-Aurel-2026.08.24_22-16-00-+0300.xcresult` |

The milestone failure is `test5SecondLessonEndToEnd`. Its attachment and log show the UI walker selecting `au.player.tile.0`, `.1`, and `.2` repeatedly until its 480-second deadline. Static inspection at `AurelUITests/MilestoneSuite.swift:117-137` and `:151-156` shows that the order helper returns `true` immediately after selecting tiles, before the walker can press the now-enabled continuation control. This is recorded as a verification-harness defect, not proof that the product lesson itself dead-ends.
