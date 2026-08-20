import SwiftUI
import UIKit

// MARK: - Organic design tokens
//
// Ported 1:1 from:
//   design/_ds/organic-ae97cabc-b950-4085-bbfd-89c2fd51d81e/styles.css  (base + ramps)
//   design/Aurel.dc.html <style> lines 18–52                             (`.aurel-dark` + `--au-*` layer)
//
// Light/dark resolution uses UIColor dynamic providers so the tokens follow the
// system trait, and the in-app theme override (Settings → Appearance) maps onto
// the same trait via .preferredColorScheme at the root.

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

private enum Palette {
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

    // Adaptive base roles
    static let bg = UIColor.adaptive(light: .init(hex: 0xf5ead8), dark: .init(hex: 0x1c1917))
    static let surface = UIColor.adaptive(light: .init(hex: 0xebddc5), dark: .init(hex: 0x272220))
    static let text = UIColor.adaptive(light: .init(hex: 0x201e1d), dark: .init(hex: 0xf4ebdd))
    static let accent = UIColor.adaptive(light: .init(hex: 0xc67139), dark: .init(hex: 0xdc8b57))
    static let accent2 = UIColor.adaptive(light: .init(hex: 0x7a8a5e), dark: .init(hex: 0xa3b383))
    static let divider = UIColor.adaptive(
        light: UIColor(hex: 0x201e1d).alpha(0.16),
        dark: UIColor(red: 244 / 255, green: 235 / 255, blue: 221 / 255, alpha: 0.16)
    )
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

    // `--au-accent-text / --au-sage-text / --au-accent-press` (Aurel.dc.html lines 20–21)
    static var auAccentText: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accentRamp[700]!),
                dark: .init(hex: Palette.accentRamp[300]!)))
    }
    static var auSageText: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accent2Ramp[700]!),
                dark: .init(hex: Palette.accent2Ramp[300]!)))
    }
    static var auAccentPress: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accentRamp[700]!),
                dark: .init(hex: Palette.accentRamp[400]!)))
    }

    // `--au-*` feedback surfaces (Aurel.dc.html lines 51–52)
    private static var errUIColor: UIColor {
        .adaptive(light: .init(hex: 0xa34a3c), dark: .init(hex: 0xd97a67))
    }

    static var auErr: Color { Color(errUIColor) }
    static var auErrBg: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: 0xf9e8e3),
                dark: UIColor(hex: 0xd97a67).alpha(0.17)
            ))
    }
    static var auErrText: Color {
        Color(UIColor.adaptive(light: .init(hex: 0x5f261e), dark: .init(hex: 0xffd6cb)))
    }
    static var auOkBg: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accent2Ramp[100]!),
                dark: Palette.accent2UIColor.alpha(0.16)
            ))
    }
    static var auOkText: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accent2Ramp[900]!), dark: .init(hex: 0xd6e2bd)))
    }
    static var auOkQuiet: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accent2Ramp[800]!), dark: .init(hex: 0xc3d3a4)))
    }
    static var auTintBg: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accentRamp[100]!),
                dark: Palette.accentUIColor.alpha(0.15)
            ))
    }
    static var auTintText: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.accentRamp[800]!),
                dark: .init(hex: Palette.accentRamp[300]!)))
    }
    static var auFlatBg: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.neutralRamp[200]!),
                dark: Palette.text.alpha(0.10)
            ))
    }
    static var auFlatText: Color {
        Color(
            UIColor.adaptive(
                light: .init(hex: Palette.neutralRamp[800]!),
                dark: Palette.text.alpha(0.72)
            ))
    }

    // Glass / edges / highlights
    static var auHi: Color {
        Color(UIColor.adaptive(light: .white.alpha(0.66), dark: .white.alpha(0.10)))
    }
    static var auEdge: Color {
        Color(
            UIColor.adaptive(
                light: UIColor(hex: 0x201e1d).alpha(0.08),
                dark: .white.alpha(0.08)
            ))
    }
    static var auFill: Color {
        Color(
            UIColor.adaptive(
                // #fffaf2 78% + surface
                light: UIColor(hex: 0xfffaf2).mixed(with: 0.78, of: Palette.surface),
                // #fff 5.5% + surface
                dark: .white.mixed(with: 0.055, of: Palette.surface)
            ))
    }

    // Dune scene
    static var auDune: Color {
        Color(UIColor.adaptive(light: .init(hex: 0xcda67a), dark: .init(hex: 0x2a1d17)))
    }
    static var auDune2: Color {
        Color(UIColor.adaptive(light: .init(hex: 0xb98c5d), dark: .init(hex: 0x1a1210)))
    }
    static var auDuneText: Color {
        Color(UIColor.adaptive(light: .init(hex: 0x4a3220), dark: .init(hex: 0xf0e2cd)))
    }

    /// Text color used on primary buttons (CSS `color:#fff8f0`).
    static let auPrimaryButtonText = Color(red: 1, green: 0.972, blue: 0.941)  // #fff8f0
}

extension Palette {
    /// UIColor (not adaptive) for the raw ramp bases used in alpha mixes.
    fileprivate static var accent2UIColor: UIColor { UIColor(hex: 0x7a8a5e) }
    fileprivate static var accentUIColor: UIColor { UIColor(hex: 0xc67139) }
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
        let top = UIColor.adaptive(light: Palette.surface.alpha(0.94), dark: .white.alpha(0.075))
        let bottom = UIColor.adaptive(light: Palette.surface.alpha(0.68), dark: .white.alpha(0.028))
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
