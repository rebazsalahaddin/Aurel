# PH-03 evidence — local-first launch hardening

Date: 2026-08-25  
Scope: REC-003 and REC-012 for the authorized local-first release posture

## Result

PH-03 engineering is complete for the in-repository scope. The app keeps every unconfigured external capability unavailable, uses one semantic lesson-feedback contract across the chapter player and Quick Practice, handles playback/capture interruptions safely, completes the touched Reduce Motion paths, bundles an explicit privacy manifest, and passes an optimized Release simulator build.

## Focused automated evidence

- Result bundle: `/tmp/aurel-ph03-derived/Logs/Test/Test-Aurel-2026.08.25_16-09-46-+0300.xcresult`
- Tests: 4 passed, 0 failed, 0 unexpected
- Covered: feedback meaning and next action; retry-before-reveal; accessible announcement content; playback-to-recording handoff; interrupted-take cleanup; release capability defaults; privacy manifest declarations; project configuration; 131-screen bundled-course load under a 2-second ceiling
- Measured bundled-course load: 0.010 seconds in the focused simulator run

## Release evidence

- Optimized simulator product: `/private/tmp/aurel-ph03-release/Build/Release-iphonesimulator/Aurel.app`
- Build result: succeeded
- `PrivacyInfo.xcprivacy`: present in the product and parseable; the empty required-reason API key is correctly omitted
- Debug verification launch hooks: absent from the optimized executable
- Source localization catalog and property lists: parseable

## Deliberate test boundary

No complete unit suite, exhaustive renderer walk, all-lesson traversal, all-screen visual matrix, or broad UI suite was repeated. PH-00 through PH-02 already carry that approved evidence, and this pass selectively tested only PH-03 changes.

No claim is made for real-device audio interruption behavior, manual assistive-technology review, independent privacy/accessibility audit, or unavailable external-service lifecycles. StoreKit products, account/backend configuration, legal/support destinations, notifications/email, and widget assets were not provided; those capabilities remain truthfully unavailable rather than simulated.
