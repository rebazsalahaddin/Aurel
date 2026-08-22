import SwiftUI

// MARK: - Core components
//
// Ports of the .au-btn / .au-card / .au-ill / .au-ping / .au-stag CSS layer
// (Aurel.dc.html lines 65–116, CourseScreen.dc.html lines 44–58).

// MARK: Press feedback (.au-tap)

struct ATapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.972 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(
                .spring(response: 0.22, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ATapButtonStyle {
    static var auTap: ATapButtonStyle { ATapButtonStyle() }
}

// MARK: Buttons

/// `.au-btn` — 17/22 padding, 22 pt radius, Figtree 600 16.5.
struct APillButton: View {
    enum Variant {
        case primary  // .au-btn-primary
        case ghost  // .au-btn-ghost (glass)
        case quiet  // .au-btn-quiet (divider outline) — CourseScreen variant
        case dashed  // the "Start over" / "One more" outline
    }

    let title: String
    var variant: Variant = .primary
    var icon: AUIcon.Kind? = nil
    /// A non-icon-set glyph (the Apple / Google marks on the sign-in buttons).
    var glyph: AUBrandMark.Kind? = nil
    var compact: Bool = false  // 13/16 padding + 14.5 pt font (inline card buttons)
    /// The chapter player's own `.au-btn` (CourseScreen.dc.html line 78):
    /// 16/20 padding, 20 pt radius, Figtree 600 16, flat accent-600 fill.
    var player: Bool = false
    var disabled: Bool = false
    /// UI-test identifier; defaults to a slug of the title (`au.btn.begin-the-path`).
    var aid: String? = nil
    let action: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: action) {
            HStack(spacing: player ? 9 : 10) {
                if let icon {
                    AUIcon(kind: icon, size: compact ? 14 : (player ? 17 : 16), color: fgColor)
                }
                if let glyph {
                    AUBrandMark(kind: glyph, size: 18, tint: fgColor)
                }
                Text(title)
                    .font(.figtree(.semibold, size: compact ? 14.5 : (player ? 16 : 16.5)))
                    .tracking(player ? 0.19 : 0.2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, compact ? 13 : (player ? 16 : 17))
            .padding(.horizontal, compact ? 16 : (player ? 20 : 22))
            .background(background)
            .foregroundStyle(fgColor)
            .shadow(
                color: .black.opacity(shadowSpec.opacity), radius: shadowSpec.radius,
                y: shadowSpec.y
            )
            .overlay(alignment: .top) { hiLine }
        }
        .buttonStyle(.auTap)
        .disabled(disabled)
        .accessibilityIdentifier(aid ?? "au.btn.\(title.auSlug)")
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case _ where disabled:
            // `.au-btn-primary:disabled` — flat text-tint fill, inset hairline.
            RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                .fill(Color.auText.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                        .strokeBorder(Color.auText.opacity(0.09), lineWidth: 1)
                )
        case .primary where player:
            // Flat accent-600 in player
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.auAccentRamp(600))
        case .quiet where player:
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.auDivider, lineWidth: 1)
        case .primary:
            // .au-btn-primary: flat accent-700 fill (#8c491a), no shadow
            RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                .fill(Color.auAccentRamp(700))
        case .ghost:
            AUGradients.glass()
                .clipShape(RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                        .strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .auSoft()
        case .quiet:
            RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                .fill(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                        .strokeBorder(Color.auDivider, lineWidth: 1)
                )
        case .dashed:
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .strokeBorder(
                    Color.auText.opacity(0.2),
                    style: StrokeStyle(lineWidth: 1, dash: [5, 4])
                )
        }
    }

    private var fgColor: Color {
        if disabled { return .auText.opacity(0.32) }
        switch variant {
        case .primary: return Color(UIColor(hex: 0xfff8f0))
        // `.au-btn-quiet` in the player is full-strength text, not muted.
        case .quiet where player: return .auText
        case .ghost, .quiet, .dashed: return .auText
        }
    }

    private var shadowSpec: (radius: CGFloat, y: CGFloat, opacity: Double) {
        (0, 0, 0)
    }

    @ViewBuilder
    private var hiLine: some View {
        EmptyView()
    }
}

/// The two brand marks on the sign-in buttons, transcribed from the authored
/// SVGs (Aurel.dc.html lines 438–443).
struct AUBrandMark: View {
    enum Kind { case apple, google }

    let kind: Kind
    var size: CGFloat = 18
    var tint: Color = .auText

    var body: some View {
        Group {
            switch kind {
            case .apple:
                SVGPathShape(
                    d:
                        "M17.05 12.54c-.03-2.66 2.17-3.94 2.27-4.01-1.24-1.81-3.16-2.06-3.84-2.09-1.63-.17-3.19.96-4.02.96-.83 0-2.11-.94-3.47-.91-1.78.03-3.43 1.04-4.34 2.63-1.85 3.21-.47 7.95 1.33 10.55.88 1.27 1.93 2.7 3.3 2.65 1.32-.05 1.82-.86 3.42-.86 1.6 0 2.05.86 3.45.83 1.43-.02 2.33-1.3 3.2-2.58 1.01-1.48 1.43-2.91 1.45-2.98-.03-.01-2.78-1.07-2.81-4.19M14.6 4.72c.73-.89 1.22-2.12 1.09-3.35-1.05.04-2.32.7-3.07 1.58-.67.78-1.26 2.03-1.1 3.23 1.17.09 2.36-.6 3.08-1.46"
                )
                .fill(tint)
            case .google:
                ZStack {
                    ForEach(Array(Self.googlePaths.enumerated()), id: \.offset) { _, part in
                        SVGPathShape(d: part.d, viewBox: CGSize(width: 48, height: 48))
                            .fill(part.color)
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    private static let googlePaths: [(d: String, color: Color)] = [
        (
            "M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5",
            Color(UIColor(hex: 0xEA4335))
        ),
        (
            "M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65",
            Color(UIColor(hex: 0x4285F4))
        ),
        (
            "M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.97-6.19C.92 16.46 0 20.12 0 24s.92 7.54 2.56 10.78z",
            Color(UIColor(hex: 0xFBBC05))
        ),
        (
            "M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48",
            Color(UIColor(hex: 0x34A853))
        ),
    ]
}

/// `.au-link` — accent text with the growing underline.
struct ALinkButton: View {
    let title: String
    /// UI-test identifier; defaults to a slug of the title (`au.link.sign-in`).
    var aid: String? = nil
    /// Overrides `--au-accent-text` (the plan screen tints it dusk cream).
    var tint: Color? = nil
    let action: () -> Void
    @State private var hovered = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.figtree(.semibold, size: 14.5))
                .tracking(0.17)
                .foregroundStyle(tint ?? Color.auAccentText)
                // `.au-link { width:100%; padding:13px }` — centred in the column.
                .frame(maxWidth: .infinity)
                .padding(13)
                .contentShape(Rectangle())
                .overlay(alignment: .bottom) {
                    Capsule()
                        .fill((tint ?? Color.auAccentText).opacity(0.45))
                        .frame(height: 1.5)
                        .padding(.bottom, 9)
                        .frame(width: hovered ? nil : 0)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 0.26), value: hovered)
                }
        }
        .buttonStyle(.auTap)
        .onHover { hovered = $0 }
        .accessibilityIdentifier(aid ?? "au.link.\(title.auSlug)")
    }
}

/// `.au-key` — radius 24, accent fill `#8c491a`, Figtree 700 16.5, knob 46×46 with radius 17, `#fff8f0` bg and `#643312` arrow icon.
struct AUKeyButton: View {
    let title: String
    var aid: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.figtree(.bold, size: 16.5))
                    .tracking(0.08)
                    .foregroundStyle(Color(UIColor(hex: 0xfff7ee)))
                    .frame(maxWidth: .infinity, alignment: .leading)
                // knob
                AUIcon(kind: .arrow, size: 19, color: Color.auAccentRamp(800))
                    .frame(width: 46, height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 17, style: .continuous)
                            .fill(Color(UIColor(hex: 0xfff8f0)))
                    )
            }
            .padding(.leading, 24)
            .padding(.trailing, 8)
            .padding(.vertical, 7)
            .background(Color.auAccentRamp(700))
            .clipShape(RoundedRectangle(cornerRadius: AURadius.key, style: .continuous))
        }
        .buttonStyle(.auTap)
        .accessibilityIdentifier(aid ?? "au.btn.\(title.auSlug)")
    }
}

/// Word sheet bottom drawer (radius 32 top corners, grab handle, Caprasimo 27 word, 40×40 audio, IPA, stress, Function gloss, In-context frame).
struct WordSheetView: View {
    let word: String
    let ipa: String
    let stress: String
    let fn: String
    let frame: String
    let onAudio: () -> Void
    let onClose: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.42)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(alignment: .leading, spacing: 0) {
                Capsule()
                    .fill(Color.auText.opacity(0.14))
                    .frame(width: 38, height: 4)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)

                HStack(alignment: .firstTextBaseline) {
                    Text(word)
                        .font(.caprasimo(size: 27))
                        .tracking(-0.54)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: onAudio) {
                        AUIcon(kind: .ear, size: 17, color: .auAccentText)
                            .frame(width: 40, height: 40)
                            .background(Circle().strokeBorder(Color.auEdge, lineWidth: 1))
                    }
                    .buttonStyle(.auTap)
                    .accessibilityLabel("Hear this word")
                }
                .padding(.bottom, 6)

                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(ipa)
                        .font(.caprasimo(size: 15))
                        .foregroundStyle(Color.auText.opacity(0.62))
                    Text(stress)
                        .font(.figtree(.regular, size: 11.5))
                        .foregroundStyle(Color.auText.opacity(0.45))
                }
                .padding(.bottom, 18)

                VStack(alignment: .leading, spacing: 4) {
                    Text("FUNCTION")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.33)
                        .foregroundStyle(Color.auText.opacity(0.45))
                    Text(fn)
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.45)
                }
                .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18).strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .padding(.bottom, 12)

                VStack(alignment: .leading, spacing: 4) {
                    Text("IN CONTEXT")
                        .font(.figtree(.bold, size: 9.5))
                        .tracking(1.33)
                        .foregroundStyle(Color.auText.opacity(0.45))
                    Text(frame)
                        .font(.figtree(.semibold, size: 14))
                        .auLine(14, 1.45)
                }
                .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18).strokeBorder(Color.auEdge, lineWidth: 1))
            }
            .padding(EdgeInsets(top: 10, leading: 24, bottom: 34, trailing: 24))
            .background(
                UnevenRoundedRectangle(
                    topLeadingRadius: 32, bottomLeadingRadius: 0, bottomTrailingRadius: 0,
                    topTrailingRadius: 32, style: .continuous
                )
                .fill(Color.auBackground)
                .shadow(color: Color(UIColor(hex: 0x18120e)).opacity(0.55), radius: 22, y: -18)
            )
        }
        .ignoresSafeArea()
    }
}

extension String {
    /// "Begin the path" → "begin-the-path" (for derived UI-test identifiers).
    var auSlug: String {
        lowercased()
            .replacingOccurrences(of: "&", with: " and ")
            .replacingOccurrences(of: "'", with: "")
            .filter { $0.isLetter || $0.isNumber || $0 == " " || $0 == "-" }
            .replacingOccurrences(of: " ", with: "-")
    }
}

// MARK: Cards

/// `.au-card` — au-fill surface, edge hairline, lift shadow.
struct ACard<Content: View>: View {
    var radius: CGFloat = AURadius.lg
    var padded = true
    @ViewBuilder let content: Content

    var body: some View {
        content
            // 16/18 padding inside the 1 pt `--au-edge` hairline.
            .padding(
                padded ? EdgeInsets(top: 17, leading: 19, bottom: 17, trailing: 19) : EdgeInsets()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(Color.auFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(Color.auEdge, lineWidth: 1)
            )
            .auLift()
    }
}

// MARK: Tags

struct ATag: View {
    enum Variant { case ok, flat, tint }

    let text: String
    var variant: Variant = .flat

    var body: some View {
        Text(text)
            .font(.figtree(.bold, size: 9.5))
            .tracking(1.1)
            .textCase(.uppercase)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(bg))
            .foregroundStyle(fg)
    }

    private var bg: Color {
        switch variant {
        case .ok: .auOkBg
        case .flat: .auFlatBg
        case .tint: .auTintBg
        }
    }
    private var fg: Color {
        switch variant {
        case .ok: .auOkQuiet
        case .flat: .auFlatText
        case .tint: .auTintText
        }
    }
}

// MARK: Motion

/// `.au-screen` — the per-screen entrance (opacity + 13 pt rise, .44 s).
/// Applied to screen roots inside animated containers; reduces to nothing
/// under prefers-reduced-motion.
struct ScreenEntrance: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .offset(y: 13)),
                        removal: .opacity
                    ))
        }
    }
}

/// `.au-stagger` — children rise in sequence (0.03 s + 0.06 s per index).
struct StaggerItem: ViewModifier {
    let index: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content.modifier(RevealOnTask(index: index))
        }
    }

    private struct RevealOnTask: ViewModifier {
        let index: Int
        @State private var revealed = false

        func body(content: Content) -> some View {
            content
                .opacity(revealed ? 1 : 0)
                .offset(y: revealed ? 0 : 13)
                .task {
                    let delay = min(0.03 + Double(index) * 0.06, 0.43)
                    try? await Task.sleep(for: .seconds(delay))
                    withAnimation(.easeOut(duration: 0.52)) { revealed = true }
                }
        }
    }
}

extension View {
    func auScreenEntrance() -> some View { modifier(ScreenEntrance()) }
    func auStagger(_ index: Int) -> some View { modifier(StaggerItem(index: index)) }
}

/// `.au-ping` — the pulsing ring on "Tap anywhere to go on".
struct PingDot: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            if !reduceMotion {
                PingRing()
            }
            Circle()
                .fill(Color.auAccent)
                .frame(width: 9, height: 9)
        }
        .frame(width: 21, height: 21)
        .accessibilityHidden(true)
    }

    /// auPulse: scale 1→1.5 while fading .5→0, 2.2 s loop.
    private struct PingRing: View {
        @State private var phase = false

        var body: some View {
            Circle()
                .stroke(Color.auAccent, lineWidth: 2)
                .scaleEffect(phase ? 1.5 : 1)
                .opacity(phase ? 0 : 0.5)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false)) {
                        phase = true
                    }
                }
        }
    }
}

// MARK: Ambience

/// `.au-grain` — the SVG-turbulence noise tile, overlay-blended at ~6%.
struct GrainOverlay: View {
    var opacity: Double = 0.06

    var body: some View {
        GeometryReader { geo in
            Canvas { context, _ in
                var generator = SeededRandom(seed: 85)
                let tileSize = 180.0
                for x in stride(from: 0, to: geo.size.width, by: tileSize) {
                    for y in stride(from: 0, to: geo.size.height, by: tileSize) {
                        for _ in 0..<600 {
                            let px = x + CGFloat(generator.next()) * tileSize
                            let py = y + CGFloat(generator.next()) * tileSize
                            let a = Double(generator.next()) * 0.9
                            context.fill(
                                Path(CGRect(x: px, y: py, width: 1, height: 1)),
                                with: .color(.white.opacity(a))
                            )
                        }
                    }
                }
            }
            .allowsHitTesting(false)
        }
        .opacity(opacity)
        .blendMode(.overlay)
        .accessibilityHidden(true)
    }
}

/// Deterministic noise so the grain doesn't shimmer between frames.
struct SeededRandom: Sendable {
    private var state: UInt64
    init(seed: UInt64) { state = seed &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407 }
    mutating func next() -> Double {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return Double((state >> 33) & 0xFFFF_FFFF) / Double(UInt32.max)
    }
}

/// `.au-amb` — two drifting blurred color orbs behind content.
struct AmbientOrbs: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                orb(
                    size: 320, center: CGPoint(x: w + 110 - 160, y: -130 + 160),
                    color: Color.auAccent.opacity(0.62), duration: 24
                )
                orb(
                    size: 280, center: CGPoint(x: -130 + 140, y: h - 60 - 140),
                    color: Color.auAccent2.opacity(0.55), duration: 31, delay: 9
                )
            }
        }
        .blur(radius: 64)
        .opacity(0.16)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private func orb(
        size: CGFloat, center: CGPoint, color: Color, duration: Double, delay: Double = 0
    ) -> some View {
        if reduceMotion {
            Circle().fill(color).frame(width: size, height: size).position(center)
        } else {
            DriftingOrb(size: size, color: color, duration: duration, delay: delay, center: center)
        }
    }

    private struct DriftingOrb: View {
        let size: CGFloat, color: Color, duration: Double, delay: Double, center: CGPoint
        @State private var drift = false

        var body: some View {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(drift ? 1.08 : 1)
                .offset(x: drift ? 14 : 0, y: drift ? -11 : 0)
                .position(center)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: duration).repeatForever(autoreverses: true).delay(
                            delay)
                    ) {
                        drift = true
                    }
                }
        }
    }
}

// MARK: `.au-paper` — the warm paper ground (Aurel.dc.html lines 105–108)

/// Two corner washes (`::before`) plus the dune/arc line art (`::after`,
/// a 514×620 SVG pinned `left/right:-56px; bottom:-190px`, radial-masked).
/// Sits behind the content of goal / placement / commit / assess / lesson.
struct AUPaper: View {
    /// The line-art `d` strings with their authored stroke opacities.
    private static let lines: [(d: String, opacity: Double, dashed: Bool)] = [
        ("M0 470 C86 452 168 448 254 458 C340 468 430 484 514 470", 0.5, false),
        ("M0 512 C92 496 176 492 262 500 C348 508 434 522 514 510", 0.34, false),
        ("M0 556 C96 542 184 538 268 544 C352 550 436 562 514 552", 0.2, false),
        ("M40 470 A104 104 0 0 1 248 470", 0.3, false),
        ("M-16 470 A160 160 0 0 1 304 470", 0.22, false),
        ("M-76 470 A220 220 0 0 1 364 470", 0.16, false),
        ("M-140 470 A284 284 0 0 1 428 470", 0.11, false),
        ("M300 128 C336 176 366 236 380 300", 0.26, true),
        ("M356 96 C398 152 432 222 448 296", 0.16, true),
    ]

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let artW = w + 112  // left:-56 + right:-56
            let artH: CGFloat = 620

            ZStack {
                // ::before — accent wash from the top-right, sage from bottom-left.
                ZStack {
                    EllipseWash(
                        stops: [
                            .init(color: Color.auAccent.opacity(0.11), location: 0),
                            .init(color: .clear, location: 0.68),
                        ],
                        center: UnitPoint(x: 0.92, y: -0.08),
                        radii: CGSize(width: w * 1.28, height: h * 0.54)
                    )
                    EllipseWash(
                        stops: [
                            .init(color: Color.auAccent2.opacity(0.10), location: 0),
                            .init(color: .clear, location: 0.70),
                        ],
                        center: UnitPoint(x: -0.12, y: 1.06),
                        radii: CGSize(width: w * 1.04, height: h * 0.46)
                    )
                }
                .opacity(scheme == .dark ? 0.8 : 1)

                // ::after — the dune / contour line art.
                ZStack {
                    ForEach(Array(Self.lines.enumerated()), id: \.offset) { _, line in
                        SVGPathShape(d: line.d, viewBox: CGSize(width: 514, height: 620))
                            .stroke(
                                inkColor.opacity(line.opacity),
                                style: StrokeStyle(
                                    lineWidth: 1.15, lineCap: .round, lineJoin: .round,
                                    dash: line.dashed ? [2, 7] : [])
                            )
                    }
                }
                .frame(width: artW, height: artH)
                .mask(
                    EllipseWash(
                        stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black.opacity(0.5), location: 0.46),
                            .init(color: .clear, location: 0.78),
                        ],
                        center: UnitPoint(x: 0.24, y: 0.96),
                        radii: CGSize(width: artW * 0.72, height: artH * 0.78)
                    )
                    .frame(width: artW, height: artH)
                )
                .opacity(scheme == .dark ? 0.3 : 0.5)
                .offset(x: -56, y: h + 190 - artH)
                .frame(width: w, height: h, alignment: .topLeading)
            }
            .frame(width: w, height: h)
            .clipped()
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    /// `stroke='%23231f1c'`; `.aurel-dark` inverts the whole layer.
    private var inkColor: Color {
        scheme == .dark
            ? Color(UIColor(hex: 0xdce0e3))  // invert(1) of #231f1c
            : Color(UIColor(hex: 0x231f1c))
    }
}

/// `.au-contour` — the repeating topographic line tile (402×340), masked to
/// the middle band. Used with `.au-amb` on the result screen.
struct AUContour: View {
    private static let rows: [[CGFloat]] = [
        [13.8, 24.7, 25.6, 18.6, 15.1, 13.6, 12.3, 18.4, 27.2],
        [63.0, 67.0, 56.0, 49.4, 47.5, 45.1, 53.0, 67.4, 65.1],
        [108.9, 94.5, 83.8, 81.5, 78.2, 86.5, 106.6, 107.1, 85.1],
        [130.3, 121.9, 120.4, 118.5, 122.5, 135.7, 138.5, 124.4, 115.5],
        [156.6, 154.2, 152.1, 155.9, 173.4, 180.5, 162.4, 147.3, 152.5],
        [192.8, 192.0, 193.4, 203.9, 210.2, 200.0, 188.8, 191.0, 196.8],
        [225.7, 226.8, 240.5, 251.8, 239.3, 221.4, 222.7, 231.9, 236.4],
        [265.4, 272.7, 280.7, 274.8, 262.9, 262.3, 268.4, 271.4, 275.4],
        [308.3, 321.5, 315.2, 296.7, 293.4, 302.8, 308.0, 313.1, 318.1],
    ]
    /// x positions: -20, 35, 90, … 420 (55 pt apart).
    private static let xs: [CGFloat] = (0..<9).map { -20 + CGFloat($0) * 55 }

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Canvas { context, size in
            let tile = CGSize(width: 402, height: 340)
            let ink =
                scheme == .dark
                ? Color.white.opacity(0.34) : Color(UIColor(hex: 0x201e1d)).opacity(0.34)
            var y0: CGFloat = 0
            while y0 < size.height {
                var x0: CGFloat = 0
                while x0 < size.width {
                    for row in Self.rows {
                        var p = Path()
                        for (i, y) in row.enumerated() {
                            let pt = CGPoint(x: x0 + Self.xs[i], y: y0 + y)
                            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
                        }
                        context.stroke(p, with: .color(ink), lineWidth: 1)
                    }
                    x0 += tile.width
                }
                y0 += tile.height
            }
        }
        .mask(
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.16),
                    .init(color: .black, location: 0.62),
                    .init(color: .clear, location: 0.96),
                ], startPoint: .top, endPoint: .bottom)
        )
        .opacity(scheme == .dark ? 0.085 : 0.13)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// `.au-rays` — the slow conic sunburst above the result screen.
struct AURays: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var spin = false

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let c = CGPoint(x: size.width / 2, y: size.height / 2)
                let r = size.width
                // repeating-conic-gradient: 3.4° lit, 9.6° dark, period 13°.
                var a: Double = 0
                while a < 360 {
                    var wedge = Path()
                    wedge.move(to: c)
                    wedge.addArc(
                        center: c, radius: r, startAngle: .degrees(a - 90),
                        endAngle: .degrees(a + 3.4 - 90), clockwise: false)
                    wedge.closeSubpath()
                    context.fill(wedge, with: .color(Color.auAccent.opacity(0.46)))
                    a += 13
                }
            }
            .frame(width: 540, height: 540)
            .mask(
                RadialGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black.opacity(0.45), location: 0.32),
                        .init(color: .clear, location: 0.60),
                    ], center: .center, startRadius: 0, endRadius: 270
                )
                .frame(width: 540, height: 540)
            )
            .rotationEffect(.degrees(spin ? 360 : 0))
            .position(x: geo.size.width / 2, y: -150 + 270)
        }
        .opacity(0.55)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) { spin = true }
        }
    }
}

// MARK: Illustration placeholder (`.au-ill`)

/// The honest illustration placeholder (v2, IMPROVEMENT_PLAN.md §2.8):
/// dusk-paper wash with a faint accent hatch and a hairline inset — the
/// authored `ILL` id stays the kicker, `alt` stays the caption.
/// (Honesty contract from CourseScreen.dc.html line 44 + lines 98–101.)
struct IllustrationPlaceholder: View {
    let ill: IllustrationRef
    var height: CGFloat = 196
    var cornerRadius: CGFloat = 22
    var kickerSize: CGFloat = 9
    var captionSize: CGFloat = 12
    var fullBleed = false  // the S01 promise treatment: no radius, no side borders

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            StripeField()
            VStack(alignment: .leading, spacing: fullBleed ? 7 : 6) {
                Text(ill.id)
                    .font(.figtree(.bold, size: kickerSize))
                    .tracking(1.6)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)
                Text(ill.alt)
                    .font(.figtree(.regular, size: captionSize))
                    .foregroundStyle(Color.auText.opacity(0.6))
                    .auLine(captionSize, 1.45)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 300, alignment: .leading)
            }
            .padding(fullBleed ? 20 : 16)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: fullBleed ? 0 : cornerRadius, style: .continuous))
        .overlay(alignment: .bottom) {
            if fullBleed {
                // `border-left:0;border-right:0;border-top:0` — bottom rule
                // only; v2 swaps the dashed wireframe rule for a hairline.
                Rectangle()
                    .fill(Color.auAccentRamp(300).opacity(0.55))
                    .frame(height: 1)
                    .padding(.horizontal, 10)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.auAccentRamp(300).opacity(0.55), lineWidth: 1)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Illustration placeholder: \(ill.alt)")
    }

    /// v2 (IMPROVEMENT_PLAN.md §2.8): the candy-stripe wireframe becomes a
    /// dusk-paper wash — warm light from the top-leading corner, a
    /// sun-warm floor, and the stripe's descendant: a fainter 135° accent
    /// hatch. Theme-adaptive through `auFill`; the washes use the
    /// theme-fixed art ramps at low opacity so the field reads as authored
    /// art direction while the commissioned assets are still pending.
    private struct StripeField: View {
        var body: some View {
            ZStack {
                Color.auFill
                LinearGradient(
                    stops: [
                        .init(color: AUSceneArt.duskCream.opacity(0.55), location: 0),
                        .init(color: AUSceneArt.duskCream.opacity(0.18), location: 0.45),
                        .init(color: .clear, location: 1),
                    ],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0.6),
                        .init(color: AUSceneArt.sunMid.opacity(0.10), location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
                Canvas { context, size in
                    var hatch = Path()
                    let period: CGFloat = 26
                    let dy = size.width  // 45° projection across the square extent
                    var x0: CGFloat = -dy
                    while x0 < size.width + dy {
                        hatch.move(to: CGPoint(x: x0, y: 0))
                        hatch.addLine(to: CGPoint(x: x0 + dy, y: dy))
                        hatch.addLine(to: CGPoint(x: x0 + dy + 1.5, y: dy))
                        hatch.addLine(to: CGPoint(x: x0 + 1.5, y: 0))
                        hatch.closeSubpath()
                        x0 += period
                    }
                    context.fill(hatch, with: .color(Color.auAccent.opacity(0.07)))
                }
                .allowsHitTesting(false)
            }
        }
    }
}
