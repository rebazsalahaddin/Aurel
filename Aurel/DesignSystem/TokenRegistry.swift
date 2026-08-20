import SwiftUI
import UIKit

// MARK: - Design-token registry
//
// Test-visible index of the app's color tokens keyed by their exact CSS
// custom-property names, mirroring `Aurel/Resources/Design/design-tokens.json`
// (exported by `tools/export-design-tokens.mjs` from the three CSS source
// layers). `AurelTests/DesignTokenTests` gates this registry — and therefore
// every token the UI renders — against the evaluated CSS values.

/// Codable mirror of one `colors["--name"]` entry of design-tokens.json.
/// Theme-dependent tokens carry `light` + `dark`; everything else carries `value`.
struct TokenValue: Codable, Equatable {
    struct RGBA: Codable, Equatable {
        let r: Double
        let g: Double
        let b: Double
        let a: Double
    }

    var light: RGBA?
    var dark: RGBA?
    var value: RGBA?

    /// The resolved RGBA for a theme: `light`/`dark` when present, else `value`.
    func resolved(dark isDark: Bool) -> RGBA {
        if isDark, let dark { return dark }
        if !isDark, let light { return light }
        return value ?? RGBA(r: 0, g: 0, b: 0, a: 0)
    }
}

enum AUColorRegistry {
    /// The app's color tokens by exact CSS custom-property name — the UIColors
    /// the SwiftUI `Color.au*` tokens are built from.
    static let uiColorTokens: [String: UIColor] = [
        // Base roles — styles.css :root + `.aurel-dark`
        "--color-bg": Palette.bg,
        "--color-surface": Palette.surface,
        "--color-text": Palette.text,
        "--color-accent": Palette.accent,
        "--color-accent-2": Palette.accent2,
        "--color-divider": Palette.divider,
        // Neutral ramp — styles.css :root (constant across themes)
        "--color-neutral-100": UIColor(hex: Palette.neutralRamp[100]!),
        "--color-neutral-200": UIColor(hex: Palette.neutralRamp[200]!),
        "--color-neutral-300": UIColor(hex: Palette.neutralRamp[300]!),
        "--color-neutral-400": UIColor(hex: Palette.neutralRamp[400]!),
        "--color-neutral-500": UIColor(hex: Palette.neutralRamp[500]!),
        "--color-neutral-600": UIColor(hex: Palette.neutralRamp[600]!),
        "--color-neutral-700": UIColor(hex: Palette.neutralRamp[700]!),
        "--color-neutral-800": UIColor(hex: Palette.neutralRamp[800]!),
        "--color-neutral-900": UIColor(hex: Palette.neutralRamp[900]!),
        // Accent ramp — styles.css :root (constant across themes)
        "--color-accent-100": UIColor(hex: Palette.accentRamp[100]!),
        "--color-accent-200": UIColor(hex: Palette.accentRamp[200]!),
        "--color-accent-300": UIColor(hex: Palette.accentRamp[300]!),
        "--color-accent-400": UIColor(hex: Palette.accentRamp[400]!),
        "--color-accent-500": UIColor(hex: Palette.accentRamp[500]!),
        "--color-accent-600": UIColor(hex: Palette.accentRamp[600]!),
        "--color-accent-700": UIColor(hex: Palette.accentRamp[700]!),
        "--color-accent-800": UIColor(hex: Palette.accentRamp[800]!),
        "--color-accent-900": UIColor(hex: Palette.accentRamp[900]!),
        // Accent-2 ramp — styles.css :root (constant across themes)
        "--color-accent-2-100": UIColor(hex: Palette.accent2Ramp[100]!),
        "--color-accent-2-200": UIColor(hex: Palette.accent2Ramp[200]!),
        "--color-accent-2-300": UIColor(hex: Palette.accent2Ramp[300]!),
        "--color-accent-2-400": UIColor(hex: Palette.accent2Ramp[400]!),
        "--color-accent-2-500": UIColor(hex: Palette.accent2Ramp[500]!),
        "--color-accent-2-600": UIColor(hex: Palette.accent2Ramp[600]!),
        "--color-accent-2-700": UIColor(hex: Palette.accent2Ramp[700]!),
        "--color-accent-2-800": UIColor(hex: Palette.accent2Ramp[800]!),
        "--color-accent-2-900": UIColor(hex: Palette.accent2Ramp[900]!),
        // `--au-*` shell layer — Aurel.dc.html lines 20–21 and 51–52
        "--au-accent-text": AUColorTokens.accentText,
        "--au-sage-text": AUColorTokens.sageText,
        "--au-accent-press": AUColorTokens.accentPress,
        "--au-glow": AUColorTokens.glow,
        "--au-glow-2": AUColorTokens.glow2,
        "--au-hi": AUColorTokens.hi,
        "--au-edge": AUColorTokens.edge,
        "--au-fill": AUColorTokens.fill,
        "--au-err": AUColorTokens.err,
        "--au-err-bg": AUColorTokens.errBg,
        "--au-err-text": AUColorTokens.errText,
        "--au-ok-bg": AUColorTokens.okBg,
        "--au-ok-text": AUColorTokens.okText,
        "--au-ok-quiet": AUColorTokens.okQuiet,
        "--au-tint-bg": AUColorTokens.tintBg,
        "--au-tint-text": AUColorTokens.tintText,
        "--au-flat-bg": AUColorTokens.flatBg,
        "--au-flat-text": AUColorTokens.flatText,
        "--au-dune": AUColorTokens.dune,
        "--au-dune-2": AUColorTokens.dune2,
        "--au-dune-text": AUColorTokens.duneText,
    ]

    /// SwiftUI projection of the same tokens (the `Color` layer views use).
    static let colorTokens: [String: Color] = uiColorTokens.mapValues { Color($0) }

    /// Resolve a UIColor for one theme and read back its sRGB components.
    static func resolvedRGBA(_ c: UIColor, dark: Bool) -> (
        r: Double, g: Double, b: Double, a: Double
    ) {
        let resolved = c.resolvedColor(
            with: UITraitCollection(userInterfaceStyle: dark ? .dark : .light))
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        precondition(
            resolved.getRed(&r, green: &g, blue: &b, alpha: &a),
            "token did not resolve to an RGB color space")
        return (Double(r), Double(g), Double(b), Double(a))
    }
}
