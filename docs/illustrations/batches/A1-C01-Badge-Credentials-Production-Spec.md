# Aurel Illustration Production Specification — A1-C01 Badge Credentials

**Status:** Production specification frozen 2026-08-28  
**Scope:** Chapter 1 badge-bearing assets `ILL018–ILL021`, `ILL023–ILL027`, `ILL029`, and `ILL031–ILL033`, plus continuity correction `ILL022`  
**Purpose:** ensure every visible teaching badge carries accurate, readable, accessible credential information without AI-generated spelling risk or assessment-answer leakage

## Authoritative credential matrix

| Character | First name | Last name | Full name |
|---|---|---|---|
| Alex Kim | `ALEX` | `KIM` | `Alex Kim` |
| Maya Haddad | `MAYA` | `HADDAD` | `Maya Haddad` |
| Leo Novak | `LEO` | `NOVAK` | `Leo Novak` |
| Nina Petrova | `NINA` | `PETROVA` | `Nina Petrova` |
| Sam Rivera | `SAM` | `RIVERA` | `Sam Rivera` |

The Character and Visual Bible is the single source of truth. No alternate spelling, abbreviated family name, inferred title, job, number, address, nationality, or additional credential may be introduced.

## Accuracy policy

- Generated bitmap pixels remain free of letters and names. Exact credential text is native SwiftUI typography so every character is deterministic, localizable, accessible, and manually verifiable.
- Generic schema asset `ILL018` displays the field labels `FIRST NAME` and `LAST NAME`, never an invented person.
- Identity scenes display the correct first/last pair for each visible badge:
  - `ILL019–ILL020`: Alex Kim and Maya Haddad.
  - `ILL021`: Nina Petrova and Leo Novak.
  - `ILL022`: Leo Novak and Maya Haddad.
  - `ILL023–ILL027`: Nina Petrova and Maya Haddad.
  - `ILL031`: Sam Rivera.
  - `ILL032`: Sam Rivera and Nina Petrova.
- `ILL029` retains its existing exact app-layer Maya Haddad / Leo Novak credentials.
- `ILL033` is answer-sensitive. `QZ-G001` and `QZ-LS001` show only the accurate field labels `FIRST NAME` / `LAST NAME`; `QZ-RD001` shows `SAM` / `RIVERA`. This preserves assessment validity while eliminating an unexplained blank badge.
- Accessibility labels must convey the same information visible on screen and must not disclose values hidden for an unanswered assessment item.

## Artwork corrections

### A1-C01-ILL021 — Nina and Leo first meeting

Edit the accepted production master only to add one blank, matte-cream, two-slot badge to Nina's teal cardigan and one matching badge to Leo's striped shirt. Badges must be nearly frontal, unobstructed, and large enough for short native text. Preserve every face, hairstyle, expression, hand, handshake, finger, body proportion, garment, background element, camera position, crop, light direction, palette, and texture. Do not redraw or move the handshake.

### A1-C01-ILL022 — Leo and Maya reciprocal question

Edit the accepted production master only to add one blank, matte-cream, two-slot badge to Leo's striped shirt and one matching badge to Maya's olive jacket. Badges must be nearly frontal, unobstructed, and large enough for short native text. Preserve every face, hairstyle, expression, hand, gesture, finger, body proportion, garment, cup, table element, background element, camera position, crop, light direction, palette, and texture.

## Renderer requirements

- Credential placement scales from the exact 16:9 image geometry, never from fixed screen pixels.
- Full-name scene overlays live inside `IllustrationPlaceholder` so cards, practice items, image options, storyboard panels, quiz images, and thumbnails stay consistent.
- Existing reading-surface overlays remain the owner of `ILL029` credentials to avoid duplicate text.
- Field/value text uses high-contrast charcoal, one line per slot, `lineLimit(1)`, and conservative minimum scaling. No text may escape a badge face.
- Small incidental badges may use compact uppercase typography, but spelling must remain exact at every rendered size.

## QA gates

1. Inspect every source edit at full resolution for identity drift, anatomy, handshake/gesture preservation, badge count, badge perspective, line-slot blankness, and text artifacts.
2. Validate all credential strings against the matrix above and inspect their exact placement in active 2x and 3x catalog renditions.
3. Exercise the real S12 name-card pager (`ILL018–ILL021`), S15 reciprocal-question pager (`ILL022`), S20 storyboard (`ILL023–ILL027`), S27 badge reading (`ILL029`), and S33 quiz (`ILL031–ILL033`) on compact, standard, and large iPhones.
4. Verify the generic schema, every named badge pair, Sam's field-only assessment states, Sam's populated reading state, accessibility equivalence, thumbnail behavior, clipping, and Dynamic Type compatibility.
5. Preserve prior production masters and active renditions before replacement; archive the final prompts, accepted source masters, output hashes, screenshots, and build result.
