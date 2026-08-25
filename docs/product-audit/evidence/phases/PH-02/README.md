# PH-02 evidence — primary learning and information architecture

Implemented and focused-verified on 2026-08-25 for the user-authorized PH-02 scope.

## Outcome

- First use demonstrates Aurel with one contextual recognition task before setup; it records no speech and changes no durable course progress.
- The route states duration, natural pause, first outcome, Chapter One free/no-account scope, and optional voice behavior.
- Goal and 10/20-minute pace selections visibly change the first Learn recommendation.
- Learn, Practice, Progress, and You expose distinct jobs without adding a new service or curriculum.
- Learn and Progress use one reason/duration/outcome/action contract.
- Practice-evidence labels have stable completed-lesson thresholds and explicitly avoid test-score or permanent-mastery claims.
- Pending, due-review, completed-day, completed/free-scope, empty-milestone, unavailable-chapter, and offline states retain a valid next action.
- PH-02 source copy is localization-safe; the refreshed catalog compiles with 465 total keys.

## Focused verification

| Gate | Result | Result bundle |
|---|---|---|
| `PH02JourneyTests` | 10/10 passed | `/tmp/aurel-ph02-derived/Logs/Test/Test-Aurel-2026.08.25_15-39-31-+0300.xcresult` |
| Value-first onboarding journey | Passed | `/tmp/aurel-ph02-derived/Logs/Test/Test-Aurel-2026.08.25_15-29-38-+0300.xcresult` |
| Learn/Practice/Progress/You journey | Passed | `/tmp/aurel-ph02-derived/Logs/Test/Test-Aurel-2026.08.25_15-29-38-+0300.xcresult` |
| Source catalog compile | Passed; 465 keys | `/tmp/aurel-ph02-localization` |

The simulator target was iPhone 17 Pro on iOS 26.5. In accordance with the implementation request, verification was restricted to PH-02 behavior; no full application, all-screen, or all-lesson suite was run.

## Focused visual evidence

- [Value sample with recognized-answer feedback](screenshots/value-sample.png)
- [Learn recommendation with reason, duration, outcome, and action](screenshots/learn-recommendation.png)

Both captures come from the final focused debug build on the same iPhone 17 Pro simulator. They were reviewed for the PH-02 hierarchy and content contract only.

## Deterministic contracts covered

- Progress-free sample completion and skip.
- Back navigation and relaunch restoration at the value checkpoint.
- One onboarding-completion boundary and existing-learner bypass.
- Distinct goal reasons and pace-derived duration.
- Learn recommendations for normal, pending, due-review, completed-day, and completed/free-scope states.
- Stable evidence-level thresholds and Progress recovery routing.
- Four unique top-level jobs, correct leaderboard ownership, and tab-state preservation.

## Product validation protocol

The implemented route is ready for an accessibility-inclusive adult-learner review. A researcher should verify that participants can state, without prompting:

1. what the first lesson helps them do;
2. that a full lesson is about 20 minutes and can pause naturally near 10;
3. that Chapter One is free without an account;
4. that speaking is optional and the sample records nothing;
5. why the recommended lesson is next and what completing it changes.

Task observations should also record whether participants can skip, go back, resume after relaunch, and locate the distinct Learn, Practice, Progress, and You jobs. No participant results are claimed in this engineering evidence.

## Scope boundary

- No remote analytics, experiment service, notification delivery, account, commerce, widget, new curriculum, punitive mechanic, or PH-03 feature was added.
- Independent UX/learning-design approval, manual assistive-technology review, and broader launch regression remain external/PH-03 gates.
- The only repeated build warning is the repository’s existing traditional-headermap warning.
