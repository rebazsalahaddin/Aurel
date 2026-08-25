# PH-01 component and renderer catalog

This catalog records the governed component contract implemented in PH-01. It is an implementation map, not a visual redesign specification.

## Renderer families

| Family | Authored kinds | Runtime evidence |
|---|---|---|
| Opening | `promise`, `hook`, `orientation`, `pause` | Per-kind render/exit; `promise` representative at AX3XL + Reduce Motion |
| Cards | `cards`, `letterCards`, `alphabet`, `numbers` | Per-kind render/exit; `cards` representative at AX3XL + Reduce Motion |
| Practice | `warmup`, `practice`, `testlet`, `reading`, `quiz` | Per-kind render/exit; `practice` representative and explicit selected-state semantics |
| Grammar | `grammarModel` | Per-kind and representative AX3XL + Reduce Motion |
| Assembly | `substitution`, `tiles`, `order`, `emailAssembly` | Per-kind render/exit; `tiles` representative; deterministic key-path checks |
| Pronunciation | `pronPerceive`, `pronProduce` | Per-kind render/exit; `pronPerceive` representative |
| Conversation | `conversation` | Per-kind and representative; learner title/scene contract |
| Mission | `missionBrief`, `roleplay` | Per-kind; `missionBrief` representative; roleplay safe-stop journey |
| Assessment | `quizIntro`, `results`, `remediation`, `reviewPlan`, `chapterMap` | Per-kind; `results` representative |
| Review | `review` | Per-kind and representative |

`pending` remains a compatibility renderer and `unknown` remains a forward-decode guard; neither is an authored shipping kind.

## Semantic surface roles

| Role | Intended use |
|---|---|
| `canvas` | Full route/player background |
| `section` | Major grouped content |
| `task` | Interactive exercise/card surface |
| `selectedTask` | Selected exercise state with non-color semantics |
| `insetInfo` | Supporting information or explanation |
| `modal` | Modal/floating content |

## Semantic action roles

| Role | Intended use |
|---|---|
| `primary` | One principal forward action |
| `secondary` | Alternative or paired action |
| `text` | Low-emphasis inline action |
| `destructive` | Destructive confirmation only |

The roles are pinned by `PH01FoundationTests.testSemanticComponentRolesAreStable`. Selected options expose selected traits and text values in addition to color. Primary tabs keep stable identifiers: `au.tab.learn`, `au.tab.practice`, `au.tab.progress`, and `au.tab.you`.

## Accessibility and motion contract

- Player roots expose `au.player.kind.<kind>` and a hittable `au.player.close` exit.
- Pairing and sorting controls expose stable cue/answer identifiers and textual selected/matched values.
- Roleplay exposes stable `Speak` and `Safe stop` actions; restart is named separately for assistive technology.
- Pseudolanguage, AX3XL, Increase Contrast, and Reduce Motion checks run on common, compact, and large iPhone boundaries.
- Motion uses the shared reduced-motion-aware `AUMotion` contract.
- Renderer validation favors semantic assertions over fragile pixel snapshots; screenshots are retained as review evidence.
