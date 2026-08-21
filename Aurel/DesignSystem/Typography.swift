import CoreText
import SwiftUI
import UIKit

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
            var font =
                UIFont(name: familyName, size: size)
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
    /// Figtree at a design point size, scaled for the effective content size
    /// category (S1-001 — the authored text-size steps + system Dynamic Type).
    static func figtree(_ weight: Font.Weight = .regular, size: CGFloat) -> Font {
        Font(Figtree.uiFont(weight: weight, size: AUTypeScale.scaled(size)))
    }

    /// Caprasimo display at a design point size, scaled likewise.
    static func caprasimo(size: CGFloat) -> Font {
        Font(Caprasimo.uiFont(size: AUTypeScale.scaled(size)))
    }
}

// MARK: Design scale → Dynamic Type mapping (S1-001)
//
// The prototype sets a fixed body size (15px) with a `--au-type` zoom for its
// text-size setting (Aurel.dc.html:113,121,2757–2761 — five steps, multipliers
// [0.88, 0.94, 1, 1.18, 1.4]). Natively those steps map onto content-size
// categories; the effective category is the larger of the system setting and
// the in-app step, so a learner who needs AX sizes keeps them at any step.
// RootView keeps `step` (from the persisted `typeStep`) and
// `systemCategory` (from the `dynamicTypeSize` environment) current.

enum AUTypeScale {
    /// The authored five steps as content-size categories.
    static let stepCategories: [UIContentSizeCategory] = [
        .small, .medium, .large, .extraExtraExtraLarge, .accessibilityMedium,
    ]

    /// Category ordering, standard sizes then accessibility sizes.
    private static let ordered: [UIContentSizeCategory] = [
        .extraSmall, .small, .medium, .large, .extraLarge, .extraExtraLarge,
        .extraExtraExtraLarge, .accessibilityMedium, .accessibilityLarge,
        .accessibilityExtraLarge, .accessibilityExtraExtraLarge,
        .accessibilityExtraExtraExtraLarge,
    ]

    /// Lock-guarded mutable storage (same pattern as FontCache below — reads
    /// happen on the main thread during view updates, writes are rare).
    private final class Box: @unchecked Sendable {
        private let lock = NSLock()
        private var stepStorage: Int = 2  // 2 = Default (Aurel.dc.html:1743)
        private var systemStorage: UIContentSizeCategory = .large

        var step: Int {
            get {
                lock.lock()
                defer { lock.unlock() }
                return stepStorage
            }
            set {
                lock.lock()
                stepStorage = min(max(newValue, 0), stepCategories.count - 1)
                lock.unlock()
            }
        }

        var systemCategory: UIContentSizeCategory {
            get {
                lock.lock()
                defer { lock.unlock() }
                return systemStorage
            }
            set {
                lock.lock()
                systemStorage = newValue
                lock.unlock()
            }
        }
    }

    private static let box = Box()

    /// The in-app text-size step (0…4).
    static var step: Int {
        get { box.step }
        set { box.step = newValue }
    }

    /// The system content size category, kept current by RootView.
    static var systemCategory: UIContentSizeCategory {
        get { box.systemCategory }
        set { box.systemCategory = newValue }
    }

    /// The larger of the step category and the system category.
    static var effectiveCategory: UIContentSizeCategory {
        let stepCategory = stepCategories[step]
        return rank(stepCategory) >= rank(systemCategory) ? stepCategory : systemCategory
    }

    private static func rank(_ c: UIContentSizeCategory) -> Int {
        ordered.firstIndex(of: c) ?? ordered.count / 2
    }

    /// Map a design point size to the closest text style for scaling purposes.
    static func textStyle(forDesignSize size: CGFloat) -> UIFont.TextStyle {
        switch size {
        case ..<12: .caption2
        case ..<14: .caption1
        case ..<16: .footnote
        case ..<18: .body
        case ..<21: .callout
        // Inclusive at the design-scale boundaries: h3 (25px) is a .title3 and
        // h1 (42px) a .title1, not one style up.
        case ..<26: .title3
        case ..<33: .title2
        case ..<43: .title1
        default: .largeTitle
        }
    }

    /// Scale a design size for the effective content size category.
    static func scaled(_ size: CGFloat) -> CGFloat {
        let traits = UITraitCollection(preferredContentSizeCategory: effectiveCategory)
        return UIFontMetrics(forTextStyle: textStyle(forDesignSize: size))
            .scaledValue(for: size, compatibleWith: traits)
    }
}
