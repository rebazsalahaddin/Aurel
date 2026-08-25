# PH-01 content and schema migration map

## Screen envelope

| Concern | Compatibility/source field | Learner-facing field or behavior | Status |
|---|---|---|---|
| Title | `label` retained in `CourseScreenDebugMetadata.legacyLabel` | `displayTitle`, falling back to the kind's localized learner title | Complete across 131 screens |
| Outcome | Previously mixed into payload notes | Optional `outcome` → `learnerOutcome` | Decoder-compatible |
| Duration | Previously mixed into labels/copy | Optional `duration` → `learnerDuration` | Decoder-compatible |
| Instruction | Previously renderer-specific | Optional `instruction` → `learnerInstruction` | Decoder-compatible |
| Step/note/assets | `step`, `tip`, `assets` | Debug metadata only; never a release display fallback | Complete |
| Unknown kind | Raw `type` outside enum | `unknown` compatibility payload and learner-safe unavailable title | Preserved |

The decoder accepts both legacy and migrated envelopes. Stable chapter, lesson, screen, task, and option IDs are unchanged; persistence schema is unchanged.

## Copy boundary

`CourseTextContract` is the display boundary. It rejects or removes author-only screen ranges, course IDs, audio/illustration/roleplay IDs, dependency/production notes, and prototype language. Payload renderers use learner text or explicit learner guidance instead of author specifications.

The runtime suite additionally scans the visible text tree for `A1-C…`, `AUD…`, `ILL…`, and `RP…` tokens across every authored kind. Internal values remain available to decoding, fixture lookup, accessibility identifiers compiled for verification, and diagnostics.

## Structured practice compatibility

| Authored shape | Normalized interaction | Completion rule |
|---|---|---|
| Options / single key | Selectable options | Correct keyed option selected |
| Ordered tiles / sequence key | Tile assembly | Selected sequence reaches authored key length and order |
| Option-backed tile task | Choice task | Keyed option selected |
| Partial tile key with distractors | Bounded assembly | Authored key completed without requiring distractors |
| `pairs` | Cue-to-answer matching | Every pair matched |
| `sort` + baskets | Card-to-group assignment | Every card assigned to its keyed group |
| Speaking | Speak/type/skip-compatible action | Existing player completion contract |

Category matching tolerates authored singular/plural variants while preserving exact keyed answers. All normalized authored practice items are required to expose at least one deterministic interaction.

## Localization decision boundary

DEC-004 remains unresolved. PH-01 therefore establishes English as the source locale, a compiled `.xcstrings` catalog, and pseudolanguage layout coverage. Curriculum translation and additional launch locales are deferred until DEC-004 is approved; no translation is implied by this migration.
