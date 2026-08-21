import SwiftUI
import UIKit

// MARK: - Organic design tokens
//
// Ported 1:1 from:
//   design/_ds/organic-ae97cabc-b950-4085-bbfd-89c2fd51d81e/styles.css  (base + ramps)
//   design/Aurel.dc.html <style> lines 18–52                             (`.aurel-dark` + `--au-*` layer)
//   design/CourseScreen.dc.html <style> lines 20–22                      (player subset)
//
// Light/dark resolution uses UIColor dynamic providers so the tokens follow the
// system trait, and the in-app theme override (Settings → Appearance) maps onto
// the same trait via .preferredColorScheme at the root.
//
// `tools/export-design-tokens.mjs` evaluates those CSS layers into
// Aurel/Resources/Design/design-tokens.json, and AurelTests/DesignTokenTests
// gates the values here against it (exact names, resolved RGBA per theme).

// MARK: Hex helper

extension UIColor {
    convenience init(hex: UInt32) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: 1
        )
    }

    /// sRGB lerp — the Swift equivalent of CSS `color-mix(in srgb, a p%, b)`.
    func mixed(with fraction: CGFloat, of other: UIColor) -> UIColor {
        let f = max(0, min(1, fraction))
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        return UIColor(
            red: r1 + (r2 - r1) * f,
            green: g1 + (g2 - g1) * f,
            blue: b1 + (b2 - b1) * f,
            alpha: a1 + (a2 - a1) * f
        )
    }

    func alpha(_ a: CGFloat) -> UIColor {
        withAlphaComponent(a)
    }

    static func adaptive(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

// MARK: Spacing / radii — styles.css --space-* / --radius-* (+ app overrides)

enum AUSpace {
    static let s1: CGFloat = 4.4
    static let s2: CGFloat = 8.8
    static let s3: CGFloat = 13.2
    static let s4: CGFloat = 17.6
    static let s6: CGFloat = 26.4
    static let s8: CGFloat = 35.2
}

enum AURadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 28  // --radius-lg
    static let lgPadded: CGFloat = 32.2  // calc(--radius-lg * 1.15) used by .card/.dialog
    static let btn: CGFloat = 22  // .au-btn
    static let key: CGFloat = 24  // .au-key
    static let pill: CGFloat = 999
}

// MARK: Base palette (adaptive) — styles.css :root + .aurel-dark

/// Internal (not private) so `AUColorRegistry` and the token conformance tests
/// can reach the exact resolved values.
enum Palette {
    // Constant ramps (identical in light and dark — .aurel-dark does not override them)
    static let neutralRamp: [Int: UInt32] = [
        100: 0xf9f4ed, 200: 0xeee7db, 300: 0xdcd3c4, 400: 0xc0b6a5, 500: 0xa19786,
        600: 0x82796a, 700: 0x645c50, 800: 0x474238, 900: 0x2e2b25,
    ]
    static let accentRamp: [Int: UInt32] = [
        100: 0xfff2eb, 200: 0xffe1d0, 300: 0xffc6a5, 400: 0xf6a06b, 500: 0xd67f48,
        600: 0xb2622d, 700: 0x8c491a, 800: 0x643312, 900: 0x402310,
    ]
    static let accent2Ramp: [Int: UInt32] = [
        100: 0xf0fae1, 200: 0xe1eecc, 300: 0xccdbb2, 400: 0xaebf92, 500: 0x8fa073,
        600: 0x728157, 700: 0x56633f, 800: 0x3d472b, 900: 0x272e1b,
    ]

    // Pinned per-theme bases. CSS resolves `var(--color-*)` per theme, and
    // mixes/alphas must never bake in the ambient trait at definition time,
    // so both halves of every adaptive pair are explicit.
    static let bgLight = UIColor(hex: 0xf5ead8)
    static let bgDark = UIColor(hex: 0x1c1917)
    static let surfaceLight = UIColor(hex: 0xebddc5)
    static let surfaceDark = UIColor(hex: 0x272220)
    static let textLight = UIColor(hex: 0x201e1d)
    static let textDark = UIColor(hex: 0xf4ebdd)
    static let accentLight = UIColor(hex: 0xc67139)
    static let accentDark = UIColor(hex: 0xdc8b57)
    static let accent2Light = UIColor(hex: 0x7a8a5e)
    static let accent2Dark = UIColor(hex: 0xa3b383)

    // Adaptive base roles
    static let bg = UIColor.adaptive(light: bgLight, dark: bgDark)
    static let surface = UIColor.adaptive(light: surfaceLight, dark: surfaceDark)
    static let text = UIColor.adaptive(light: textLight, dark: textDark)
    static let accent = UIColor.adaptive(light: accentLight, dark: accentDark)
    static let accent2 = UIColor.adaptive(light: accent2Light, dark: accent2Dark)
    static let divider = UIColor.adaptive(light: textLight.alpha(0.16), dark: textDark.alpha(0.16))
}

// MARK: `--au-*` layer — UIColor tokens (Aurel.dc.html lines 20–21 and 51–52)
//
// Single source of truth: the SwiftUI `Color` tokens below and `AUColorRegistry`
// both derive from these, so the conformance tests exercise exactly the values
// views render. Alpha-bearing colors match CSS Color 5's premultiplied
// interpolation of `color-mix(in srgb, X p%, transparent)` — hue is kept and
// only alpha scales.

enum AUColorTokens {
    // .au-stage / .au-stage.aurel-dark — Aurel.dc.html lines 20–21
    static let accentText = UIColor.adaptive(
        light: .init(hex: Palette.accentRamp[700]!),
        dark: .init(hex: Palette.accentRamp[300]!))
    static let sageText = UIColor.adaptive(
        light: .init(hex: Palette.accent2Ramp[700]!),
        dark: .init(hex: Palette.accent2Ramp[300]!))
    static let accentPress = UIColor.adaptive(
        light: .init(hex: Palette.accentRamp[700]!),
        dark: .init(hex: Palette.accentRamp[400]!))

    // .au-stage / .au-stage.aurel-dark — Aurel.dc.html lines 51–52
    // `--au-glow` / `--au-glow-2` (ambient radial washes).
    static let glow = UIColor.adaptive(
        light: Palette.accentLight.alpha(0.85),
        dark: Palette.accentDark.alpha(0.24))
    static let glow2 = UIColor.adaptive(
        light: Palette.accent2Light.alpha(0.85),
        dark: Palette.accent2Dark.alpha(0.24))
    static let hi = UIColor.adaptive(light: .white.alpha(0.66), dark: .white.alpha(0.10))
    static let edge = UIColor.adaptive(
        light: Palette.textLight.alpha(0.08),
        dark: .white.alpha(0.08))
    static let fill = UIColor.adaptive(
        // color-mix(in srgb, #fffaf2 78%, var(--color-surface))
        light: Palette.surfaceLight.mixed(with: 0.78, of: UIColor(hex: 0xfffaf2)),
        // color-mix(in srgb, #fff 5.5%, var(--color-surface))
        dark: Palette.surfaceDark.mixed(with: 0.055, of: .white))
    static let err = UIColor.adaptive(light: .init(hex: 0xa34a3c), dark: .init(hex: 0xd97a67))
    static let errBg = UIColor.adaptive(
        light: .init(hex: 0xf9e8e3),
        dark: UIColor(hex: 0xd97a67).alpha(0.17))
    static let errText = UIColor.adaptive(
        light: .init(hex: 0x5f261e), dark: .init(hex: 0xffd6cb))
    static let okBg = UIColor.adaptive(
        light: .init(hex: Palette.accent2Ramp[100]!),
        dark: Palette.accent2Dark.alpha(0.16))
    static let okText = UIColor.adaptive(
        light: .init(hex: Palette.accent2Ramp[900]!), dark: .init(hex: 0xd6e2bd))
    static let okQuiet = UIColor.adaptive(
        light: .init(hex: Palette.accent2Ramp[800]!), dark: .init(hex: 0xc3d3a4))
    static let tintBg = UIColor.adaptive(
        light: .init(hex: Palette.accentRamp[100]!),
        dark: Palette.accentDark.alpha(0.15))
    static let tintText = UIColor.adaptive(
        light: .init(hex: Palette.accentRamp[800]!),
        dark: .init(hex: Palette.accentRamp[300]!))
    static let flatBg = UIColor.adaptive(
        light: .init(hex: Palette.neutralRamp[200]!),
        dark: Palette.textDark.alpha(0.10))
    static let flatText = UIColor.adaptive(
        light: .init(hex: Palette.neutralRamp[800]!),
        dark: Palette.textDark.alpha(0.72))
    static let dune = UIColor.adaptive(light: .init(hex: 0xcda67a), dark: .init(hex: 0x2a1d17))
    static let dune2 = UIColor.adaptive(light: .init(hex: 0xb98c5d), dark: .init(hex: 0x1a1210))
    static let duneText = UIColor.adaptive(
        light: .init(hex: 0x4a3220), dark: .init(hex: 0xf0e2cd))
}

// MARK: Color tokens

extension Color {
    // Base roles
    static let auBackground = Color(Palette.bg)
    static let auSurface = Color(Palette.surface)
    static let auText = Color(Palette.text)
    static let auAccent = Color(Palette.accent)
    static let auAccent2 = Color(Palette.accent2)
    static let auDivider = Color(Palette.divider)

    // Ramps (constant across themes)
    static func auNeutral(_ step: Int) -> Color {
        Color(UIColor(hex: Palette.neutralRamp[step] ?? 0))
    }

    static func auAccentRamp(_ step: Int) -> Color {
        Color(UIColor(hex: Palette.accentRamp[step] ?? 0))
    }

    static func auAccent2Ramp(_ step: Int) -> Color {
        Color(UIColor(hex: Palette.accent2Ramp[step] ?? 0))
    }

    // `--au-*` layer — thin wrappers over `AUColorTokens` (the single source of truth)
    static var auAccentText: Color { Color(AUColorTokens.accentText) }
    static var auSageText: Color { Color(AUColorTokens.sageText) }
    static var auAccentPress: Color { Color(AUColorTokens.accentPress) }
    static var auGlow: Color { Color(AUColorTokens.glow) }
    static var auGlow2: Color { Color(AUColorTokens.glow2) }
    static var auHi: Color { Color(AUColorTokens.hi) }
    static var auEdge: Color { Color(AUColorTokens.edge) }
    static var auFill: Color { Color(AUColorTokens.fill) }
    static var auErr: Color { Color(AUColorTokens.err) }
    static var auErrBg: Color { Color(AUColorTokens.errBg) }
    static var auErrText: Color { Color(AUColorTokens.errText) }
    static var auOkBg: Color { Color(AUColorTokens.okBg) }
    static var auOkText: Color { Color(AUColorTokens.okText) }
    static var auOkQuiet: Color { Color(AUColorTokens.okQuiet) }
    static var auTintBg: Color { Color(AUColorTokens.tintBg) }
    static var auTintText: Color { Color(AUColorTokens.tintText) }
    static var auFlatBg: Color { Color(AUColorTokens.flatBg) }
    static var auFlatText: Color { Color(AUColorTokens.flatText) }
    static var auDune: Color { Color(AUColorTokens.dune) }
    static var auDune2: Color { Color(AUColorTokens.dune2) }
    static var auDuneText: Color { Color(AUColorTokens.duneText) }

    /// Text color used on primary buttons (CSS `color:#fff8f0`).
    static let auPrimaryButtonText = Color(red: 1, green: 0.972, blue: 0.941)  // #fff8f0
}

// MARK: Gradients

enum AUGradients {
    /// `--au-sky` — the welcome/dawn sky.
    static var sky: LinearGradient {
        LinearGradient(
            stops: [
                .init(
                    color: Color(
                        UIColor.adaptive(light: .init(hex: 0xfdf2e0), dark: .init(hex: 0x161320))),
                    location: 0),
                .init(
                    color: Color(
                        UIColor.adaptive(light: .init(hex: 0xf8e3c2), dark: .init(hex: 0x231b26))),
                    location: 0.54),
                .init(
                    color: Color(
                        UIColor.adaptive(light: .init(hex: 0xf1d2a8), dark: .init(hex: 0x3c2620))),
                    location: 1),
            ],
            startPoint: .top, endPoint: .bottom
        )
    }

    /// `--au-glass` — 158° frosted surface.
    static func glass() -> LinearGradient {
        let top = UIColor.adaptive(
            light: Palette.surfaceLight.alpha(0.94), dark: .white.alpha(0.075))
        let bottom = UIColor.adaptive(
            light: Palette.surfaceLight.alpha(0.68), dark: .white.alpha(0.028))
        return LinearGradient(
            colors: [Color(top), Color(bottom)],
            startPoint: UnitPoint(x: 0.1, y: 0),  // ~158° top-right-ish
            endPoint: UnitPoint(x: 0.9, y: 1)
        )
    }

    /// `.au-btn-primary` — accent-600 top-lit through accent-700.
    static func primaryButton(dark: Bool) -> LinearGradient {
        let light = UIColor(hex: 0xb2622d)
        let mid = UIColor(hex: 0xb2622d)
        let deep = UIColor(hex: 0x8c491a)
        let mixBase: CGFloat = dark ? 0.82 : 0.93
        return LinearGradient(
            stops: [
                .init(color: Color(light.mixed(with: mixBase, of: .white)), location: 0),
                .init(color: Color(mid), location: dark ? 0.48 : 0.46),
                .init(color: Color(deep), location: 1),
            ],
            startPoint: .top, endPoint: .bottom
        )
    }
}

// MARK: Shadows — CSS values approximated (blur÷2 → SwiftUI radius)

extension View {
    /// `.au-lift` (cards).
    func auLift() -> some View {
        shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)
            .shadow(color: Color(UIColor(hex: 0x4a301a)).opacity(0.4), radius: 5, y: 5)
    }

    /// `--au-soft` (glass panels).
    func auSoft() -> some View {
        shadow(color: Color(UIColor(hex: 0x4a301a)).opacity(0.5), radius: 5, y: 5)
    }

    /// `--shadow-sm`.
    func auShadowSm() -> some View {
        shadow(color: Color(UIColor(hex: 0x2e2b25)).opacity(0.14), radius: 1, y: 1)
    }

    /// `--shadow-md`.
    func auShadowMd() -> some View {
        shadow(color: Color(UIColor(hex: 0x2e2b25)).opacity(0.16), radius: 5, y: 2)
    }

    /// `--shadow-lg`.
    func auShadowLg() -> some View {
        shadow(color: Color(UIColor(hex: 0x2e2b25)).opacity(0.22), radius: 16, y: 6)
    }
}

// MARK: - Scene art palette (S2-003)
//
// The CSS `--au-*` layer defines no custom properties for the dusk/sun art
// ramps — they are authored as raw hex at their use sites (Aurel.dc.html).
// Until the design system promotes them to real tokens (owner escalation —
// extending design/ is out of bounds for the app), these centralize each
// ramp value ONCE with its authored citation so feature code stops carrying
// literals. They are theme-fixed art colors: they must never be mapped onto
// adaptive tokens (e.g. `auAccent` flips in dark mode; the dusk does not).

enum AUSceneArt {
    /// #f7efe2 — the dusk cream (Aurel.dc.html paywall/plan/scene art, 22 uses).
    static let duskCream = Color(red: 0.969, green: 0.937, blue: 0.886)
    /// #fbfaf5 — foreground on accent-2 fills (Aurel.dc.html:999, 2138…).
    static let onAccent2 = Color(red: 0.984, green: 0.980, blue: 0.961)
    /// #120f0d — deep foreground on accent-2 fills.
    static let onAccent2Deep = Color(red: 0.071, green: 0.059, blue: 0.051)
    /// #fff7ee — foreground on accent-600 fills (Aurel.dc.html:76, 1006…).
    static let onAccent = Color(red: 1, green: 0.969, blue: 0.933)
    /// #f7e8d1 — dusk highlight tint.
    static let duskHighlight = Color(red: 0.969, green: 0.910, blue: 0.820)
    /// #e29256 — sun mid-tone (Aurel.dc.html:133, 2330).
    static let sunMid = Color(red: 0.886, green: 0.573, blue: 0.337)
    /// #c67139 — paywall sun deep stop (theme-fixed; NOT auAccent).
    static let sunDeep = Color(red: 0.776, green: 0.443, blue: 0.224)
    /// #22271a — deep green foreground (welcome art).
    static let deepGreen = Color(red: 0.133, green: 0.153, blue: 0.102)
}
