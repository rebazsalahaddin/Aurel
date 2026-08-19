import SwiftUI
import UIKit
import CoreText

// MARK: - Typography
//
// The Organic system pairs Caprasimo (display, single weight) with Figtree
// (body). Figtree ships as a variable font; weights are resolved through the
// `wght` variation axis and cached. All sizes are design points that callers
// scale with @ScaledMetric / UIFontMetrics so Dynamic Type reflow works.

/// Immutable boxed cache — Swift 6 forbids unprotected mutable statics.
/// Thread-safe via NSLock, hence `@unchecked Sendable`.
private final class FontCache: @unchecked Sendable {
    private let lock = NSLock()
    private var storage: [Int: UIFont] = [:]

    func font(forKey key: Int, make: () -> UIFont) -> UIFont {
        lock.lock()
        if let hit = storage[key] {
            lock.unlock()
            return hit
        }
        lock.unlock()
        let font = make()
        lock.lock()
        storage[key] = font
        lock.unlock()
        return font
    }
}

enum Figtree {
    static let familyName = "Figtree"
    private static let cache = FontCache()

    /// Design weight → raw `wght` axis value.
    static func axisValue(for weight: Font.Weight) -> Double {
        switch weight {
        case .ultraLight: 200
        case .light: 300
        case .regular: 400
        case .medium: 500
        case .semibold: 600
        case .bold: 700
        case .heavy: 800
        case .black: 900
        default: 400
        }
    }

    private static func uiWeight(for weight: Font.Weight) -> UIFont.Weight {
        switch weight {
        case .ultraLight: .ultraLight
        case .light: .light
        case .regular: .regular
        case .medium: .medium
        case .semibold: .semibold
        case .bold: .bold
        case .heavy: .heavy
        case .black: .black
        default: .regular
        }
    }

    static func uiFont(weight: Font.Weight = .regular, size: CGFloat) -> UIFont {
        let wght = axisValue(for: weight)
        let key = Int(wght) &* 10_000 &+ Int(size * 10)
        return cache.font(forKey: key) {
            var font = UIFont(name: familyName, size: size)
                ?? UIFont.systemFont(ofSize: size, weight: uiWeight(for: weight))

            // Static-instance route — the app bundles named static weights
            // (Figtree-Regular/Medium/SemiBold/Bold/ExtraBold).
            let instanceNames: [Double: String] = [
                200: "Figtree-Regular", 300: "Figtree-Regular", 400: "Figtree-Regular",
                500: "Figtree-Medium", 600: "Figtree-SemiBold",
                700: "Figtree-Bold", 800: "Figtree-ExtraBold", 900: "Figtree-ExtraBold",
            ]
            if let name = instanceNames[wght], let named = UIFont(name: name, size: size) {
                font = named
            } else if let base = UIFont(name: familyName, size: size) {
                // Variation-axis route.
                // The `wght` variation axis tag (kCTFontVariationWght is not exposed to Swift).
                let wghtAxis = "wght" as CFString
                let attrs: [UIFontDescriptor.AttributeName: Any] = [
                    UIFontDescriptor.AttributeName(rawValue: kCTFontVariationAttribute as String):
                        [wghtAxis as AnyHashable: wght] as CFDictionary
                ]
                let descriptor = base.fontDescriptor.addingAttributes(attrs)
                let varied = UIFont(descriptor: descriptor, size: size)
                // Only keep the variation result if it actually changed something
                // (the descriptor API silently returns the base font when unsupported).
                if varied != base || Int(wght) == 400 {
                    font = varied
                }
            }
            return font
        }
    }
}

enum Caprasimo {
    static let familyName = "Caprasimo"
    static func uiFont(size: CGFloat) -> UIFont {
        UIFont(name: familyName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
}

// MARK: SwiftUI conveniences

extension Font {
    /// Figtree at a design point size.
    static func figtree(_ weight: Font.Weight = .regular, size: CGFloat) -> Font {
        Font(Figtree.uiFont(weight: weight, size: size))
    }

    /// Caprasimo display at a design point size.
    static func caprasimo(size: CGFloat) -> Font {
        Font(Caprasimo.uiFont(size: size))
    }
}

// MARK: Design scale → Dynamic Type mapping
//
// The prototype sets a fixed body size (15px) with a `--au-type` zoom for its
// text-size setting. Natively we map design sizes onto UIFontMetrics text
// styles so every label reflows with the user's content size category; the
// Settings screen's text-size control (standard/large/x-large) maps onto
// UIContentSizeCategory the same way the prototype's zoom multiplier did.

enum AUTypeScale {
    /// Map a design point size to the closest text style for scaling purposes.
    static func textStyle(forDesignSize size: CGFloat) -> UIFont.TextStyle {
        switch size {
        case ..<12: .caption2
        case ..<14: .caption1
        case ..<16: .footnote
        case ..<18: .body
        case ..<21: .callout
        case ..<25: .title3
        case ..<33: .title2
        case ..<42: .title1
        default: .largeTitle
        }
    }

    /// Scale a design size for the current content size category.
    @MainActor
    static func scaled(_ size: CGFloat) -> CGFloat {
        UIFontMetrics(forTextStyle: textStyle(forDesignSize: size))
            .scaledValue(for: size)
    }
}
