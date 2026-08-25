# PH-00 after evidence

Captured on 2026-08-24 from the PH-00 implementation build. Filenames retain the Stage 1 screen IDs so before/after comparisons remain stable.

## Default-route captures

Device: iPhone 17, 402×874 points, dark appearance, default text size.

| Evidence | Verified state |
|---|---|
| [`SCR-003-commit-ph00.png`](SCR-003-commit-ph00.png) | Reminder controls replaced by truthful no-reminder release copy |
| [`SCR-006-home-ph00.png`](SCR-006-home-ph00.png) | Additional chapter card is unavailable and non-transactional |
| [`SCR-014-speak-ph00.png`](SCR-014-speak-ph00.png) | Speaking route retains equal type/skip alternatives |
| [`SCR-017-profile-ph00.png`](SCR-017-profile-ph00.png) | Account/help/commerce actions removed; included chapter scope is explicit |
| [`SCR-018-settings-ph00.png`](SCR-018-settings-ph00.png) | Only executable practice/appearance/reading/local-data settings remain |
| [`SCR-019-paywall-unavailable-ph00.png`](SCR-019-paywall-unavailable-ph00.png) | Direct paywall route is a truthful safe-area-aware availability state |
| [`SCR-020-subscribeAccount-unavailable-ph00.png`](SCR-020-subscribeAccount-unavailable-ph00.png) | Direct account-subscription route is non-transactional and safe-area-aware |

## Accessibility boundary captures

| Evidence | Configuration and result |
|---|---|
| [`STA-PH00-paywall-light-increased-contrast-iphone17.png`](STA-PH00-paywall-light-increased-contrast-iphone17.png) | iPhone 17, light, Increase Contrast, Reduce Motion; copy and CTA remain contained |
| [`STA-PH00-settings-light-increased-contrast-iphone17.png`](STA-PH00-settings-light-increased-contrast-iphone17.png) | iPhone 17, light, Increase Contrast, Reduce Motion; settings remain readable |
| [`STA-PH00-paywall-ax3xl-17e.png`](STA-PH00-paywall-ax3xl-17e.png) | iPhone 17e, 390×844, AX3XL; scroll content and CTA remain reachable |

Automated containment also passed on iPhone 17 Pro Max at 440×956 and AX3XL. Exact test bundles and limitations are recorded in [`../../04_IMPLEMENTATION_TRACKER.md`](../../04_IMPLEMENTATION_TRACKER.md).
