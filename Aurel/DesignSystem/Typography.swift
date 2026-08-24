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

// MARK: CSS line-height → SwiftUI lineSpacing
//
// CSS `line-height: L` sets the whole line box to `L × font-size`. SwiftUI's
// `.lineSpacing` is the *gap added between* line boxes, so the authored value
// has to have the font's own line height subtracted from it — otherwise every
// multi-line block runs one natural leading too loose (Figtree 1.20 em,
// Caprasimo 1.147 em, from the bundled fonts' hhea tables).

enum AULeading {
    /// Figtree's natural line height as a multiple of the point size.
    static let figtree: CGFloat = 1.20
    /// Caprasimo's natural line height as a multiple of the point size.
    static let caprasimo: CGFloat = 1.147
}

extension View {
    /// CSS `line-height` for Figtree body copy authored at `size`.
    ///
    /// Two things have to happen for the block to occupy what CSS gives it:
    /// the *gap between* lines becomes `lineHeight − 1.20 em`, and the leftover
    /// half-leading is paid as vertical padding — CSS centres each glyph run in
    /// its line box, so even a single line is `lineHeight × size` tall.
    func auLine(_ size: CGFloat, _ lineHeight: CGFloat) -> some View {
        let extra = AUTypeScale.scaled(size) * (lineHeight - AULeading.figtree)
        return lineSpacing(max(0, extra)).padding(.vertical, extra / 2)
    }

    /// CSS `line-height` for a Caprasimo display line authored at `size`.
    func auHeadLine(_ size: CGFloat, _ lineHeight: CGFloat) -> some View {
        let extra = AUTypeScale.scaled(size) * (lineHeight - AULeading.caprasimo)
        return lineSpacing(max(0, extra)).padding(.vertical, extra / 2)
    }
}

/// Body copy laid out the way the prototype's CSS lays it out.
///
/// Two things SwiftUI's `Text` will not do:
///  * give a single line the full `line-height × size` box (CSS half-leading), and
///  * break lines *greedily*. SwiftUI penalises a short last line and pulls a
///    word down early, so authored paragraphs wrap one word sooner than the
///    prototype and the block gains a line.
///
/// A TextKit label with an explicit paragraph style does both exactly.
struct AUParagraph: View {
    let text: String
    var size: CGFloat
    var lineHeight: CGFloat = 1.55
    var weight: Font.Weight = .regular
    var tracking: CGFloat = 0
    var alignment: TextAlignment = .leading
    var color: Color = .auText

    var body: some View {
        LabelBox(
            text: text, font: Figtree.uiFont(weight: weight, size: AUTypeScale.scaled(size)),
            lineHeight: AUTypeScale.scaled(size) * lineHeight, tracking: tracking,
            alignment: alignment, color: UIColor(color)
        )
        .accessibilityLabel(text)
    }

    /// `UILabel` sized by SwiftUI's proposed width.
    private struct LabelBox: UIViewRepresentable {
        let text: String
        let font: UIFont
        let lineHeight: CGFloat
        let tracking: CGFloat
        let alignment: TextAlignment
        let color: UIColor

        func makeUIView(context: Context) -> UILabel {
            let label = UILabel()
            label.numberOfLines = 0
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.setContentHuggingPriority(.required, for: .vertical)
            return label
        }

        func updateUIView(_ label: UILabel, context: Context) {
            let style = NSMutableParagraphStyle()
            style.lineBreakMode = .byWordWrapping
            style.lineBreakStrategy = []  // greedy — the browser's algorithm
            style.minimumLineHeight = lineHeight
            style.maximumLineHeight = lineHeight
            style.alignment =
                switch alignment {
                case .center: .center
                case .trailing: .right
                default: .left
                }
            var attrs: [NSAttributedString.Key: Any] = [
                .font: font, .foregroundColor: color, .paragraphStyle: style,
                // CSS centres the glyphs in the line box; TextKit hangs them
                // from the top, so nudge them back down by the half-leading.
                .baselineOffset: (lineHeight - font.lineHeight) / 4,
            ]
            if tracking != 0 { attrs[.kern] = tracking }
            label.attributedText = NSAttributedString(string: text, attributes: attrs)
        }

        func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context)
            -> CGSize?
        {
            let w = proposal.width ?? uiView.intrinsicContentSize.width
            guard w > 0, w < .greatestFiniteMagnitude else { return nil }
            let fitted = uiView.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude))
            return CGSize(width: w, height: ceil(fitted.height))
        }
    }
}

/// A Caprasimo display heading whose hard line breaks keep the authored CSS
/// `line-height` even when it is *tighter* than the font's natural leading
/// (`.lineSpacing` cannot go negative, a `VStack` spacing can).
struct AUHeading: View {
    let text: String
    var size: CGFloat
    var lineHeight: CGFloat = 1.12
    var tracking: CGFloat = 0
    var color: Color = .auText

    private var lines: [String] { text.components(separatedBy: "\n") }

    var body: some View {
        let s = AUTypeScale.scaled(size)
        let extra = s * (lineHeight - AULeading.caprasimo)
        VStack(alignment: .leading, spacing: extra) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                // Each authored line takes the whole column, so a long one
                // wraps at the container width (SwiftUI would otherwise size
                // the whole block to the *widest authored line* and wrap early).
                Text(line)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, extra / 2)
        .font(.caprasimo(size: size))
        .tracking(tracking)
        .foregroundStyle(color)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(lines.joined(separator: " "))
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

// MARK: - AUTextToken (Apple Design Award Typography Scale)

enum AUTextToken {
    case displayHero     // 36pt Caprasimo Bold
    case displayLarge    // 29pt Caprasimo Bold
    case titleLarge      // 22pt Caprasimo Bold
    case titleMedium     // 18pt Caprasimo Bold
    case bodyLead        // 16.5pt Figtree Regular
    case bodyStandard    // 14.5pt Figtree Regular
    case bodyMedium      // 14.5pt Figtree Medium
    case captionBold     // 10.5pt Figtree Bold (Uppercase)
    case labelSmall      // 12.0pt Figtree SemiBold
    case statNumber      // 33.0pt Figtree Bold Monospaced
}

extension View {
    /// Fluid typographic scale clamp to prevent awkward wrapping on compact screens
    func auClampText(minScale: CGFloat = 0.85) -> some View {
        self
            .minimumScaleFactor(minScale)
            .lineLimit(nil)
    }
}

