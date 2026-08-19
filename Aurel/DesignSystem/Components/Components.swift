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
            .animation(.spring(response: 0.22, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ATapButtonStyle {
    static var auTap: ATapButtonStyle { ATapButtonStyle() }
}

// MARK: Buttons

/// `.au-btn` — 17/22 padding, 22 pt radius, Figtree 600 16.5.
struct APillButton: View {
    enum Variant {
        case primary     // .au-btn-primary
        case ghost       // .au-btn-ghost (glass)
        case quiet       // .au-btn-quiet (divider outline) — CourseScreen variant
        case dashed      // the "Start over" / "One more" outline
    }

    let title: String
    var variant: Variant = .primary
    var icon: AUIcon.Kind? = nil
    var compact: Bool = false   // 13/16 padding + 14.5 pt font (inline card buttons)
    var disabled: Bool = false
    let action: () -> Void

    @Environment(\.colorScheme) private var scheme

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let icon {
                    AUIcon(kind: icon, size: compact ? 14 : 16, color: fgColor)
                }
                Text(title)
                    .font(.figtree(.semibold, size: compact ? 14.5 : 16.5))
                    .tracking(0.2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, compact ? 13 : 17)
            .padding(.horizontal, compact ? 16 : 22)
            .background(background)
            .foregroundStyle(fgColor)
            .shadow(color: .black.opacity(shadowSpec.opacity), radius: shadowSpec.radius, y: shadowSpec.y)
            .overlay(alignment: .top) { hiLine }
        }
        .buttonStyle(.auTap)
        .disabled(disabled)
        .opacity(disabled ? 0.45 : 1)
    }

    @ViewBuilder
    private var background: some View {
        switch variant {
        case .primary:
            AUGradients.primaryButton(dark: scheme == .dark)
                .clipShape(RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous))
                .overlay(
                    // inset edge ring (rgba(96,46,16,.14))
                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                        .strokeBorder(Color(UIColor(hex: 0x602e10)).opacity(0.14), lineWidth: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                        .strokeBorder(.white.opacity(0.24), lineWidth: 1)
                        .blur(radius: 0.4)
                        .mask(Rectangle().frame(height: 1).frame(maxHeight: .infinity, alignment: .top))
                )
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
        switch variant {
        case .primary: .auPrimaryButtonText
        case .ghost, .quiet, .dashed: .auText.opacity(disabled ? 0.58 : 0.62)
        }
    }

    private var shadowSpec: (radius: CGFloat, y: CGFloat, opacity: Double) {
        switch variant {
        case .primary: (6, 3, scheme == .dark ? 0.28 : 0.18)
        default: (0, 0, 0)
        }
    }

    @ViewBuilder
    private var hiLine: some View {
        if variant == .primary {
            RoundedRectangle(cornerRadius: AURadius.btn - 1, style: .continuous)
                .fill(.white.opacity(0.24))
                .frame(height: 1)
                .padding(.horizontal, 3)
                .allowsHitTesting(false)
        }
    }
}

/// `.au-link` — accent text with the growing underline.
struct ALinkButton: View {
    let title: String
    let action: () -> Void
    @State private var hovered = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.figtree(.semibold, size: 14.5))
                .tracking(0.17)
                .foregroundStyle(Color.auAccentText)
                .padding(.vertical, 13)
                .overlay(alignment: .bottom) {
                    Capsule()
                        .fill(Color.auAccentText.opacity(0.45))
                        .frame(height: 1.5)
                        .padding(.bottom, 9)
                        .frame(width: hovered ? nil : 0)
                        .animation(reduceMotion ? nil : .easeInOut(duration: 0.26), value: hovered)
                }
        }
        .buttonStyle(.auTap)
        .onHover { hovered = $0 }
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
            .padding(padded ? EdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 18) : EdgeInsets())
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

    private var bg: Color { switch variant { case .ok: .auOkBg; case .flat: .auFlatBg; case .tint: .auTintBg } }
    private var fg: Color { switch variant { case .ok: .auOkQuiet; case .flat: .auFlatText; case .tint: .auTintText } }
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
                .transition(.asymmetric(
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
    init(seed: UInt64) { state = seed &* 6364136223846793005 &+ 1442695040888963407 }
    mutating func next() -> Double {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return Double((state >> 33) & 0xFFFFFFFF) / Double(UInt32.max)
    }
}

/// `.au-amb` — two drifting blurred color orbs behind content.
struct AmbientOrbs: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width, h = geo.size.height
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
    private func orb(size: CGFloat, center: CGPoint, color: Color, duration: Double, delay: Double = 0) -> some View {
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
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true).delay(delay)) {
                        drift = true
                    }
                }
        }
    }
}

// MARK: Illustration placeholder (`.au-ill`)

/// The honest illustration placeholder: candy-stripe accent field, dashed
/// accent border, the authored `ILL` id as kicker, `alt` as the caption.
/// (CourseScreen.dc.html line 44 + lines 98–101.)
struct IllustrationPlaceholder: View {
    let ill: IllustrationRef
    var height: CGFloat = 196
    var cornerRadius: CGFloat = 22
    var kickerSize: CGFloat = 9
    var captionSize: CGFloat = 12
    var fullBleed = false   // the S01 promise treatment: no radius, no side borders

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
                    .lineSpacing(captionSize * 0.45)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 300, alignment: .leading)
            }
            .padding(fullBleed ? 20 : 16)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: fullBleed ? 0 : cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: fullBleed ? 0 : cornerRadius, style: .continuous)
                .strokeBorder(
                    Color.auAccent.opacity(0.34),
                    style: StrokeStyle(lineWidth: 1, dash: [5, 4])
                )
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Illustration placeholder: \(ill.alt)")
    }

    /// `repeating-linear-gradient(135deg, accent 7% 0–9px, transparent 9–18px)`
    /// over `accent 5% + au-fill`.
    private struct StripeField: View {
        var body: some View {
            Canvas { context, size in
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(Color.auFill))
                var stripe = Path()
                let period: CGFloat = 18
                let dy = size.width  // 45° projection across the square extent
                var x0: CGFloat = -dy
                while x0 < size.width + dy {
                    stripe.move(to: CGPoint(x: x0, y: 0))
                    stripe.addLine(to: CGPoint(x: x0 + dy, y: dy))
                    stripe.addLine(to: CGPoint(x: x0 + dy + 9, y: dy))
                    stripe.addLine(to: CGPoint(x: x0 + 9, y: 0))
                    stripe.closeSubpath()
                    x0 += period
                }
                context.fill(stripe, with: .color(Color.auAccent.opacity(0.07)))
            }
            .allowsHitTesting(false)
        }
    }
}
