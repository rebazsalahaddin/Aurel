import SwiftUI

// MARK: - Core components
//
// Ports of the .au-btn / .au-card / .au-ill / .au-ping / .au-stag CSS layer
// (Aurel.dc.html lines 65–116, CourseScreen.dc.html lines 44–58).

// MARK: Press feedback (.au-tap)

struct ATapButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : 1.0)
            .offset(y: configuration.isPressed ? 1.5 : 0)
            .opacity(configuration.isPressed ? 0.94 : 1.0)
            .animation(AUMotion.press, value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == ATapButtonStyle {
    static var auTap: ATapButtonStyle { ATapButtonStyle() }
}

/// Truthful fallback for a service-backed route that is not executable in
/// this build. It contains one safe navigation action and no disabled form or
/// simulated transaction controls.
struct CapabilityUnavailableView: View {
    let title: String
    let message: String
    let buttonTitle: String
    let aid: String
    let action: () -> Void

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    AUIcon(kind: .lock, size: 34, color: .auAccentText)
                        .frame(width: 68, height: 68)
                        .background(Circle().fill(Color.auTintBg))
                        .padding(.bottom, 22)
                    Text(title.auLocalized)
                        .font(.caprasimo(size: 29))
                        .tracking(-0.58)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 11)
                    Text(message.auLocalized)
                        .font(.figtree(.regular, size: 14.5))
                        .auLine(14.5, 1.55)
                        .foregroundStyle(Color.auTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 28)
                    APillButton(title: buttonTitle, aid: "\(aid).back", action: action)
                }
                .frame(maxWidth: 342)
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity, minHeight: geo.size.height, alignment: .center)
            }
        }
        .background(Color.auBackground.ignoresSafeArea())
        .accessibilityIdentifier(aid)
        .auScreenEntrance()
    }
}

// MARK: Buttons

enum AUActionRole: String, CaseIterable, Sendable {
    case primary, secondary, text, destructive
}

enum AUSurfaceRole: String, CaseIterable, Sendable {
    case canvas, section, task, selectedTask, insetInfo, modal
}

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
    /// Named action hierarchy. When omitted, the existing visual variant maps
    /// to a deterministic semantic role for backward compatibility.
    var role: AUActionRole? = nil
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
        Button(action: {
            AUFeedback.press()
            action()
        }) {
            HStack(spacing: player ? 9 : 10) {
                if let icon {
                    AUIcon(kind: icon, size: compact ? 14 : (player ? 17 : 16), color: fgColor)
                }
                if let glyph {
                    AUBrandMark(kind: glyph, size: 18, tint: fgColor)
                }
                Text(title.auLocalized)
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
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.auPrimaryButtonFill)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color.auPrimaryButtonBorder.opacity(0.72), lineWidth: 1.2)
                )
        case .quiet where player:
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.auDivider, lineWidth: 1)
        case .primary where effectiveRole == .destructive:
            RoundedRectangle(cornerRadius: compact ? 16 : AURadius.btn, style: .continuous)
                .fill(Color.auErrText)
                .overlay(
                    RoundedRectangle(cornerRadius: compact ? 16 : AURadius.btn, style: .continuous)
                        .strokeBorder(Color.auErr.opacity(0.72), lineWidth: 1.2)
                )
        case .primary:
            // Accessible copper action role with a lighter ramp border.
            RoundedRectangle(cornerRadius: compact ? 16 : AURadius.btn, style: .continuous)
                .fill(Color.auPrimaryButtonFill)
                .overlay(
                    RoundedRectangle(cornerRadius: compact ? 16 : AURadius.btn, style: .continuous)
                        .strokeBorder(Color.auPrimaryButtonBorder.opacity(0.72), lineWidth: 1.2)
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
        if disabled { return .auText.opacity(0.32) }
        switch variant {
        case .primary: return Color(UIColor(hex: 0xfff8f0))
        // `.au-btn-quiet` in the player is full-strength text, not muted.
        case .quiet where player: return .auText
        case .ghost, .quiet, .dashed: return .auText
        }
    }

    private var effectiveRole: AUActionRole {
        if let role { return role }
        return switch variant {
        case .primary: .primary
        case .ghost, .quiet, .dashed: .secondary
        }
    }

    private var shadowSpec: (radius: CGFloat, y: CGFloat, opacity: Double) {
        if variant == .primary && !disabled {
            return (6, 3, 0.12)
        }
        return (0, 0, 0)
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
            Text(title.auLocalized)
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
        Button(action: {
            AUFeedback.press()
            action()
        }) {
            HStack(spacing: 12) {
                Text(title.auLocalized)
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
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: AURadius.key, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                    .mask(
                        Rectangle().frame(height: 1.5)
                            .frame(maxHeight: .infinity, alignment: .top)
                    )
            }
            .shadow(color: Color.black.opacity(0.14), radius: 8, y: 4)
        }
        .buttonStyle(.auTap)
        .accessibilityIdentifier(aid ?? "au.btn.\(title.auSlug)")
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
    var role: AUSurfaceRole = .task
    /// Chapter One's lesson cards reuse Home's recommendation glass. Other
    /// callers retain the established opaque surface.
    var glass: Bool? = nil
    @ViewBuilder let content: Content
    @Environment(\.auLessonGlassEnabled) private var lessonGlassEnabled

    private var usesGlass: Bool { glass ?? lessonGlassEnabled }

    @ViewBuilder
    var body: some View {
        if usesGlass {
            base
                .auPracticeGlass(radius: radius)
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(role == .selectedTask ? .isSelected : [])
                .accessibilityIdentifier("au.surface.\(role.rawValue)")
        } else {
            base
                .background(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .fill(surfaceFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(surfaceBorder, lineWidth: role == .selectedTask ? 1.5 : 1)
                )
                .overlay(alignment: .top) {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(Color.auHi, lineWidth: 1)
                        .mask(
                            Rectangle().frame(height: 1.5)
                                .frame(maxHeight: .infinity, alignment: .top)
                        )
                }
                .shadow(
                    color: Color(UIColor(hex: 0x4a301a)).opacity(shadowOpacity),
                    radius: role == .modal ? 14 : 5,
                    y: role == .modal ? 8 : 5
                )
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(role == .selectedTask ? .isSelected : [])
                .accessibilityIdentifier("au.surface.\(role.rawValue)")
        }
    }

    private var base: some View {
        content
            // 16/18 padding inside the 1 pt `--au-edge` hairline.
            .padding(
                padded ? EdgeInsets(top: 17, leading: 19, bottom: 17, trailing: 19) : EdgeInsets()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var surfaceFill: Color {
        switch role {
        case .canvas: .auBackground
        case .section, .task, .modal: .auFill
        case .selectedTask: .auTintBg
        case .insetInfo: .auFlatBg
        }
    }

    private var surfaceBorder: Color {
        role == .selectedTask ? .auAccent : .auEdge
    }

    private var shadowOpacity: Double {
        switch role {
        case .task: 0.09
        case .modal: 0.16
        case .canvas, .section, .selectedTask, .insetInfo: 0
        }
    }
}

// MARK: Tags

struct ATag: View {
    enum Variant { case ok, flat, tint }

    let text: String
    var variant: Variant = .flat

    var body: some View {
        Text(text.auLocalized)
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

/// `.au-stagger` — children rise in sequence (0.03 s + 0.05 s per index).
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
                .offset(y: revealed ? 0 : 12)
                .task {
                    let delay = min(0.02 + Double(index) * AUMotion.staggerDelay, 0.40)
                    try? await Task.sleep(for: .seconds(delay))
                    withAnimation(AUMotion.quick) { revealed = true }
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

// MARK: Live waveform (§3.16a — real amplitude, never decorative)

/// The shared renderer for recorded takes (F5): real amplitude history from
/// `AVAudioRecorder` metering, right-aligned like a tape rolling — shared by
/// the say-aloud screen and the pronProduce items (§3.11c). Before the first
/// take every bar sits at its quiet floor: an honest empty state, never a
/// fake wave. `progress` tints a playback scrub (the native line under TTS,
/// §3.16e); reduce-motion keeps the bars but drops the spring.
struct LiveWaveform: View {
    /// 0…1 amplitude samples, most recent last.
    let samples: [Double]
    var tint: Color
    /// 0…1 playback progress; bars up to it render at full tint.
    var progress: Double? = nil
    var barCount = 26
    var minBar: CGFloat = 3
    var maxBar: CGFloat = 27
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private func height(_ value: Double) -> CGFloat {
        minBar + CGFloat(max(0, min(1, value))) * (maxBar - minBar)
    }

    /// The right-aligned window of the last `barCount` samples (oldest
    /// first, zero-padded — the tape rolled in from silence).
    private var window: [Double] {
        let tail = Array(samples.suffix(barCount))
        return Array(repeating: 0, count: barCount - tail.count) + tail
    }

    var body: some View {
        HStack(spacing: 3) {
            ForEach(Array(window.enumerated()), id: \.offset) { i, value in
                Capsule()
                    .fill(barColor(at: i))
                    .frame(height: height(value))
                    .frame(maxHeight: .infinity, alignment: .center)
                    .animation(
                        AUMotion.animation(
                            .spring(response: 0.18, dampingFraction: 0.9),
                            reduceMotion: reduceMotion),
                        value: value
                    )
            }
        }
        .accessibilityHidden(true)
    }

    private func barColor(at index: Int) -> Color {
        guard let progress else { return tint }
        let edge = progress * Double(barCount)
        return Double(index) < edge ? tint : tint.opacity(0.22)
    }
}

// MARK: Recording ring (§3.16b — the live-take state)

/// The expanding ring around the mic button while the take window runs —
/// `--au-recording` = accent-2 ramp 600 (§2.1), a quiet heartbeat at the
/// recorded-speech state. Static under Reduce Motion.
struct RecordingRing: View {
    @State private var phase = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Circle()
            .strokeBorder(
                Color.auAccent2Ramp(600).opacity(phase ? 0 : 0.5), lineWidth: 2
            )
            .scaleEffect(phase ? 1.32 : 1.0)
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    .easeOut(duration: 1.1).repeatForever(autoreverses: false)
                ) {
                    phase = true
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

// MARK: `.au-paper` / Modern Minimalist Elegant Background
//
// A bespoke, editorial background: fluid hand-drawn fine-line curves,
// astrolabe celestial arcs, delicate harmonic dashed echoes, and subtle
// atmospheric ember/sage washes over tactile fine paper grain.
// Features ultra-smooth, whisper-quiet organic ambient breathing drift.

struct AUElegantBackground: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var subdued: Bool = false
    var showGrain: Bool = true
    var showAmbientWash: Bool = true

    @State private var phase: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            // Slow, harmonious ambient drift coordinates
            let driftY1 = reduceMotion ? 0 : sin(phase * .pi * 2) * 4.5
            let driftY2 = reduceMotion ? 0 : cos(phase * .pi * 2) * 3.5
            let driftX = reduceMotion ? 0 : sin(phase * .pi * 2 * 0.6) * 3.0

            ZStack {
                // Base ground
                Color.auBackground

                // Atmospheric ambient washes
                if showAmbientWash {
                    ZStack {
                        // Top-right warm ember wash
                        RadialGradient(
                            colors: [
                                Color.auAccent.opacity(
                                    (scheme == .dark ? 0.07 : 0.04) * (subdued ? 0.6 : 1.0)
                                ),
                                Color.clear,
                            ],
                            center: UnitPoint(
                                x: 0.95 + Double(driftX * 0.003),
                                y: 0.04 + Double(driftY1 * 0.003)
                            ),
                            startRadius: 0,
                            endRadius: max(w, h) * 0.62
                        )

                        // Bottom-left sage/olive whisper
                        RadialGradient(
                            colors: [
                                Color.auAccent2.opacity(
                                    (scheme == .dark ? 0.055 : 0.03) * (subdued ? 0.6 : 1.0)
                                ),
                                Color.clear,
                            ],
                            center: UnitPoint(
                                x: 0.04 - Double(driftX * 0.003),
                                y: 0.92 - Double(driftY2 * 0.003)
                            ),
                            startRadius: 0,
                            endRadius: max(w, h) * 0.52
                        )
                    }
                }

                // Modern minimalist vector line art
                Canvas { context, size in
                    let w = size.width
                    let h = size.height

                    // In subdued/lesson mode, line opacities are ultra-soft and ethereal
                    let alphaScale: Double = (subdued ? 0.42 : 1.0)

                    let primaryInk =
                        scheme == .dark
                        ? Color(UIColor(hex: 0xe8e2d8))
                        : Color(UIColor(hex: 0x2b221a))

                    let accentInk =
                        scheme == .dark
                        ? Color(UIColor(hex: 0xf5a56d))
                        : Color(UIColor(hex: 0xb55a22))

                    // 1. Upper sweeping horizon curve
                    var p1 = Path()
                    p1.move(to: CGPoint(x: -20, y: h * 0.16 + driftY1))
                    p1.addCurve(
                        to: CGPoint(x: w * 0.52, y: h * 0.23 + driftY2),
                        control1: CGPoint(x: w * 0.18, y: h * 0.12 + driftY1 * 0.5),
                        control2: CGPoint(x: w * 0.36, y: h * 0.25 + driftY2 * 0.8)
                    )
                    p1.addCurve(
                        to: CGPoint(x: w + 20, y: h * 0.18 + driftY1 * 0.7),
                        control1: CGPoint(x: w * 0.70, y: h * 0.21 + driftY2 * 0.6),
                        control2: CGPoint(x: w * 0.88, y: h * 0.14 + driftY1 * 0.4)
                    )
                    context.stroke(
                        p1,
                        with: .color(
                            primaryInk.opacity((scheme == .dark ? 0.12 : 0.075) * alphaScale)),
                        style: StrokeStyle(lineWidth: 0.9, lineCap: .round)
                    )

                    // 1b. Harmonic dashed echo
                    var p1b = Path()
                    p1b.move(to: CGPoint(x: -20, y: h * 0.185 + driftY1 * 0.9))
                    p1b.addCurve(
                        to: CGPoint(x: w * 0.49, y: h * 0.25 + driftY2 * 0.9),
                        control1: CGPoint(x: w * 0.16, y: h * 0.14 + driftY1 * 0.6),
                        control2: CGPoint(x: w * 0.34, y: h * 0.27 + driftY2 * 0.7)
                    )
                    p1b.addCurve(
                        to: CGPoint(x: w + 20, y: h * 0.21 + driftY1 * 0.8),
                        control1: CGPoint(x: w * 0.68, y: h * 0.23 + driftY2 * 0.5),
                        control2: CGPoint(x: w * 0.86, y: h * 0.17 + driftY1 * 0.5)
                    )
                    context.stroke(
                        p1b,
                        with: .color(
                            accentInk.opacity((scheme == .dark ? 0.10 : 0.06) * alphaScale)),
                        style: StrokeStyle(lineWidth: 0.8, lineCap: .round, dash: [2.5, 6.5])
                    )

                    // 2. Celestial / Astrolabe orbital arc from top right
                    var p2 = Path()
                    p2.addArc(
                        center: CGPoint(x: w * 0.90 + driftX, y: -h * 0.04 + driftY1 * 0.5),
                        radius: min(w, h) * 0.68,
                        startAngle: .degrees(45),
                        endAngle: .degrees(160),
                        clockwise: false
                    )
                    context.stroke(
                        p2,
                        with: .color(
                            primaryInk.opacity((scheme == .dark ? 0.10 : 0.06) * alphaScale)),
                        style: StrokeStyle(lineWidth: 0.85, lineCap: .round)
                    )

                    // 2b. Concentric micro arc with fine dashed pattern
                    var p2b = Path()
                    p2b.addArc(
                        center: CGPoint(x: w * 0.90 + driftX, y: -h * 0.04 + driftY1 * 0.5),
                        radius: min(w, h) * 0.82,
                        startAngle: .degrees(55),
                        endAngle: .degrees(145),
                        clockwise: false
                    )
                    context.stroke(
                        p2b,
                        with: .color(
                            accentInk.opacity((scheme == .dark ? 0.08 : 0.045) * alphaScale)),
                        style: StrokeStyle(lineWidth: 0.7, lineCap: .round, dash: [1.5, 8.0])
                    )

                    // 3. Mid-body topographic flow / acoustic wave
                    var p3 = Path()
                    p3.move(to: CGPoint(x: -20, y: h * 0.54 + driftY2))
                    p3.addCurve(
                        to: CGPoint(x: w * 0.50, y: h * 0.48 + driftY1),
                        control1: CGPoint(x: w * 0.16, y: h * 0.50 + driftY2 * 0.7),
                        control2: CGPoint(x: w * 0.34, y: h * 0.46 + driftY1 * 0.8)
                    )
                    p3.addCurve(
                        to: CGPoint(x: w + 20, y: h * 0.58 + driftY2 * 0.6),
                        control1: CGPoint(x: w * 0.68, y: h * 0.50 + driftY1 * 0.6),
                        control2: CGPoint(x: w * 0.86, y: h * 0.62 + driftY2 * 0.4)
                    )
                    context.stroke(
                        p3,
                        with: .color(
                            primaryInk.opacity((scheme == .dark ? 0.11 : 0.07) * alphaScale)),
                        style: StrokeStyle(lineWidth: 0.9, lineCap: .round)
                    )

                    // 4. Lower ascending dune contour
                    var p4 = Path()
                    p4.move(to: CGPoint(x: -20, y: h * 0.76 + driftY1 * 0.8))
                    p4.addCurve(
                        to: CGPoint(x: w * 0.56, y: h * 0.81 + driftY2 * 0.7),
                        control1: CGPoint(x: w * 0.20, y: h * 0.70 + driftY1 * 0.5),
                        control2: CGPoint(x: w * 0.40, y: h * 0.83 + driftY2 * 0.6)
                    )
                    p4.addCurve(
                        to: CGPoint(x: w + 20, y: h * 0.73 + driftY1 * 0.6),
                        control1: CGPoint(x: w * 0.74, y: h * 0.79 + driftY2 * 0.5),
                        control2: CGPoint(x: w * 0.90, y: h * 0.70 + driftY1 * 0.4)
                    )
                    context.stroke(
                        p4,
                        with: .color(
                            primaryInk.opacity((scheme == .dark ? 0.12 : 0.08) * alphaScale)),
                        style: StrokeStyle(lineWidth: 1.0, lineCap: .round)
                    )

                    // 4b. Secondary dune ridge with subtle dash cadence
                    var p4b = Path()
                    p4b.move(to: CGPoint(x: -20, y: h * 0.82 + driftY1 * 0.6))
                    p4b.addCurve(
                        to: CGPoint(x: w * 0.60, y: h * 0.86 + driftY2 * 0.5),
                        control1: CGPoint(x: w * 0.24, y: h * 0.78 + driftY1 * 0.4),
                        control2: CGPoint(x: w * 0.44, y: h * 0.88 + driftY2 * 0.5)
                    )
                    p4b.addCurve(
                        to: CGPoint(x: w + 20, y: h * 0.80 + driftY1 * 0.5),
                        control1: CGPoint(x: w * 0.76, y: h * 0.84 + driftY2 * 0.4),
                        control2: CGPoint(x: w * 0.92, y: h * 0.77 + driftY1 * 0.3)
                    )
                    context.stroke(
                        p4b,
                        with: .color(
                            accentInk.opacity((scheme == .dark ? 0.09 : 0.05) * alphaScale)),
                        style: StrokeStyle(lineWidth: 0.8, lineCap: .round, dash: [3, 7])
                    )
                }

                // Organic tactile paper grain
                if showGrain {
                    GrainOverlay(
                        opacity: (scheme == .dark ? 0.025 : 0.035) * (subdued ? 0.75 : 1.0))
                }
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(
                .easeInOut(duration: 16).repeatForever(autoreverses: true)
            ) {
                phase = 1.0
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// Backward-compatible wrapper for the warm tactile paper ground.
struct AUPaper: View {
    var subdued: Bool = false
    var body: some View {
        AUElegantBackground(subdued: subdued)
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

/// Resolves commissioned illustrations by their authored `ILL` id. Briefs
/// without a matching asset keep the honest dusk-paper placeholder.
struct IllustrationPlaceholder: View {
    let ill: IllustrationRef
    var height: CGFloat = 196
    var aspectRatio: CGFloat? = nil
    var cornerRadius: CGFloat = 22
    var kickerSize: CGFloat = 9
    var captionSize: CGFloat = 12
    var fullBleed = false  // the S01 promise treatment: no radius, no side borders

    private var learnerAlt: String {
        CourseTextContract.learnerText(ill.alt) ?? String(localized: "Illustration")
    }

    var body: some View {
        Group {
            if let aspectRatio {
                illustrationBody
                    .aspectRatio(aspectRatio, contentMode: .fit)
            } else {
                illustrationBody
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .frame(height: height)
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
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
    }

    @ViewBuilder
    private var illustrationBody: some View {
        if let artwork = UIImage(named: ill.id) {
            ZStack {
                Color.auFill

                Image(uiImage: artwork)
                    .resizable()
                    .scaledToFit()

                IllustrationCredentialOverlay(artworkID: ill.id)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(
                IllustrationCredentialOverlay.accessibilitySummary(for: ill.id)
                    .map { "\(learnerAlt). \($0)" } ?? learnerAlt
            )
        } else {
            // Honest placeholder (IMPROVEMENT_PLAN §2.8): the authored alt
            // caption stays visible so the learner knows what the scene will
            // depict once the commissioned asset lands — ids never leak.
            VStack(spacing: 7) {
                AUIcon(kind: .eye, size: 22, color: .auTextTertiary)
                    .accessibilityHidden(true)
                Text("Scene")
                    .font(.figtree(.bold, size: kickerSize))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auTextTertiary)
                Text(learnerAlt)
                    .font(.figtree(.regular, size: captionSize))
                    .auLine(captionSize, 1.4)
                    .foregroundStyle(Color.auTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 18)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(StripeField())
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(learnerAlt)
        }
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

/// Deterministic app-layer credentials for commissioned badge artwork. The
/// bitmap remains a reusable, text-free surface; names stay exact, accessible,
/// and independent of image-generation spelling.
private struct IllustrationCredentialOverlay: View {
    let artworkID: String

    private struct Placement: Identifiable {
        let id: String
        let first: String
        let last: String
        let x: CGFloat
        let firstY: CGFloat
        let lastY: CGFloat
        let firstWidth: CGFloat
        let lastWidth: CGFloat
        let firstScale: CGFloat
        let lastScale: CGFloat
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(placements) { placement in
                Text(placement.first)
                    .font(.figtree(.bold, size: proxy.size.width * placement.firstScale))
                    .tracking(0.05)
                    .lineLimit(1)
                    .minimumScaleFactor(0.35)
                    .foregroundStyle(Color.auText.opacity(0.86))
                    .frame(width: proxy.size.width * placement.firstWidth)
                    .position(
                        x: proxy.size.width * placement.x,
                        y: proxy.size.height * placement.firstY)

                Text(placement.last)
                    .font(.figtree(.semibold, size: proxy.size.width * placement.lastScale))
                    .tracking(0.20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.32)
                    .foregroundStyle(Color.auText.opacity(0.78))
                    .frame(width: proxy.size.width * placement.lastWidth)
                    .position(
                        x: proxy.size.width * placement.x,
                        y: proxy.size.height * placement.lastY)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    static func accessibilitySummary(for artworkID: String) -> String? {
        switch artworkID {
        case "A1-C01-ILL018":
            return "Badge fields: first name and last name."
        case "A1-C01-ILL019", "A1-C01-ILL020":
            return "Badges: Alex Kim and Maya Haddad."
        case "A1-C01-ILL021":
            return "Badges: Nina Petrova and Leo Novak."
        case "A1-C01-ILL022":
            return "Badges: Leo Novak and Maya Haddad."
        case "A1-C01-ILL023", "A1-C01-ILL024", "A1-C01-ILL025",
            "A1-C01-ILL026", "A1-C01-ILL027":
            return "Badges: Nina Petrova and Maya Haddad."
        case "A1-C01-ILL031":
            return "Badge: Sam Rivera."
        case "A1-C01-ILL032":
            return "Badges: Sam Rivera and Nina Petrova."
        default:
            return nil
        }
    }

    private var placements: [Placement] {
        switch artworkID {
        case "A1-C01-ILL018":
            return [
                Placement(
                    id: "schema", first: "FIRST NAME", last: "LAST NAME",
                    x: 0.500, firstY: 0.480, lastY: 0.615,
                    firstWidth: 0.235, lastWidth: 0.332,
                    firstScale: 0.0148, lastScale: 0.0148)
            ]
        case "A1-C01-ILL019":
            return [
                person("alex", "ALEX", "KIM", 0.299, 0.474, 0.501, 0.056),
                person("maya", "MAYA", "HADDAD", 0.720, 0.548, 0.581, 0.058),
            ]
        case "A1-C01-ILL020":
            return [
                person("alex", "ALEX", "KIM", 0.249, 0.445, 0.476, 0.060),
                person("maya", "MAYA", "HADDAD", 0.720, 0.535, 0.568, 0.057),
            ]
        case "A1-C01-ILL021":
            return [
                person("nina", "NINA", "PETROVA", 0.296, 0.468, 0.493, 0.052),
                person("leo", "LEO", "NOVAK", 0.698, 0.416, 0.441, 0.054),
            ]
        case "A1-C01-ILL022":
            return [
                person("leo", "LEO", "NOVAK", 0.245, 0.388, 0.414, 0.054),
                person("maya", "MAYA", "HADDAD", 0.717, 0.526, 0.551, 0.054),
            ]
        case "A1-C01-ILL023":
            return [
                person("nina", "NINA", "PETROVA", 0.283, 0.329, 0.356, 0.037),
                person("maya", "MAYA", "HADDAD", 0.730, 0.335, 0.364, 0.040),
            ]
        case "A1-C01-ILL024":
            return [
                person("nina", "NINA", "PETROVA", 0.289, 0.367, 0.397, 0.038),
                person("maya", "MAYA", "HADDAD", 0.716, 0.402, 0.437, 0.043),
            ]
        case "A1-C01-ILL025":
            return [
                person("nina", "NINA", "PETROVA", 0.333, 0.399, 0.432, 0.040),
                person("maya", "MAYA", "HADDAD", 0.699, 0.418, 0.452, 0.044),
            ]
        case "A1-C01-ILL026":
            return [
                person("nina", "NINA", "PETROVA", 0.337, 0.402, 0.435, 0.040),
                person("maya", "MAYA", "HADDAD", 0.699, 0.418, 0.452, 0.044),
            ]
        case "A1-C01-ILL027":
            return [
                person("nina", "NINA", "PETROVA", 0.253, 0.347, 0.376, 0.038),
                person("maya", "MAYA", "HADDAD", 0.719, 0.342, 0.374, 0.040),
            ]
        case "A1-C01-ILL031":
            return [person("sam", "SAM", "RIVERA", 0.421, 0.397, 0.419, 0.040)]
        case "A1-C01-ILL032":
            return [
                person("sam", "SAM", "RIVERA", 0.348, 0.544, 0.569, 0.044),
                person("nina", "NINA", "PETROVA", 0.691, 0.503, 0.529, 0.044),
            ]
        default:
            return []
        }
    }

    private func person(
        _ id: String, _ first: String, _ last: String,
        _ x: CGFloat, _ firstY: CGFloat, _ lastY: CGFloat, _ width: CGFloat
    ) -> Placement {
        Placement(
            id: id, first: first, last: last,
            x: x, firstY: firstY, lastY: lastY,
            firstWidth: width, lastWidth: width * 1.10,
            firstScale: 0.0095, lastScale: 0.0080)
    }
}

// MARK: - AUFlipCard (3D Interactive Flashcard)

struct AUFlipCard<Front: View, Back: View>: View {
    @Binding var isFlipped: Bool
    @ViewBuilder let front: () -> Front
    @ViewBuilder let back: () -> Back
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Group {
            if reduceMotion {
                if isFlipped { back() } else { front() }
            } else {
                ZStack {
                    front()
                        .modifier(AUFlipCardFace(angle: isFlipped ? 180 : 0, isFront: true))
                    back()
                        .modifier(AUFlipCardFace(angle: isFlipped ? 0 : -180, isFront: false))
                }
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .onTapGesture {
            AUFeedback.cardFlip()
            withAnimation(AUMotion.animation(AUMotion.cardFlip, reduceMotion: reduceMotion)) {
                isFlipped.toggle()
            }
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(
            isFlipped ? "Flashcard flipped, showing answer" : "Flashcard front, tap to flip"
        )
        .accessibilityValue(isFlipped ? "Answer" : "Question")
    }
}

private struct AUFlipCardFace: ViewModifier {
    let angle: Double
    let isFront: Bool

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.8
            )
            .opacity(abs(angle) < 90 ? 1 : 0)
            .accessibilityHidden(abs(angle) >= 90)
    }
}

// MARK: - AUCounterBadge (Dynamic Onboarding Selection Counter)

struct AUCounterBadge: View {
    let current: Int
    let maxCount: Int
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(current > 0 ? Color.auAccent : Color.auText.opacity(0.2))
                .frame(width: 7, height: 7)
            Text("\(current) of \(maxCount) selected")
                .font(.figtree(.semibold, size: 12))
                .monospacedDigit()
                .foregroundStyle(current > 0 ? Color.auAccentText : Color.auText.opacity(0.55))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(current > 0 ? Color.auTintBg : Color.auFill)
        )
        .overlay(
            Capsule()
                .strokeBorder(
                    current > 0 ? Color.auAccent.opacity(0.35) : Color.auEdge, lineWidth: 1)
        )
        .layoutPriority(1)
        .animation(AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion), value: current)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Selection count")
        .accessibilityValue("\(current) of \(maxCount)")
    }
}

// MARK: - Recommended next action

/// PH-02's shared answer to “what next and why”. Learn and Progress use the
/// same compact contract: one action with an explicit reason, duration, and
/// observable outcome.
struct AUNextActionCard: View {
    var eyebrow: String = String(localized: "Recommended next")
    let title: String
    let reason: String
    let duration: String
    let outcome: String
    let buttonTitle: String
    let aid: String
    var buttonAid: String? = nil
    let action: () -> Void

    var body: some View {
        ACard(radius: 26, role: .selectedTask) {
            VStack(alignment: .leading, spacing: 0) {
                Text(eyebrow.auLocalized)
                    .font(.figtree(.bold, size: 10.5))
                    .tracking(1.47)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auAccentText)
                    .padding(.bottom, 8)

                Text(title.auLocalized)
                    .font(.caprasimo(size: 21))
                    .auHeadLine(21, 1.2)
                    .accessibilityIdentifier("\(aid).title")

                Text(reason.auLocalized)
                    .font(.figtree(.regular, size: 13))
                    .auLine(13, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.top, 7)

                recommendationDetail(
                    icon: .clock, label: String(localized: "Duration"), value: duration
                )
                .padding(.top, 15)
                .accessibilityIdentifier("\(aid).duration")
                recommendationDetail(
                    icon: .sparkle, label: String(localized: "Outcome"), value: outcome
                )
                .padding(.top, 9)
                .accessibilityIdentifier("\(aid).outcome")

                APillButton(title: buttonTitle, aid: buttonAid ?? "\(aid).button", action: action)
                    .padding(.top, 17)
            }
        }
    }

    private func recommendationDetail(icon: AUIcon.Kind, label: String, value: String) -> some View
    {
        HStack(alignment: .top, spacing: 10) {
            AUIcon(kind: icon, size: 14, color: .auAccentText)
                .frame(width: 22, height: 22)
                .background(Circle().fill(Color.auTintBg))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(label.auLocalized)
                    .font(.figtree(.bold, size: 9.5))
                    .tracking(1.05)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auTextTertiary)
                Text(value.auLocalized)
                    .font(.figtree(.medium, size: 12.5))
                    .auLine(12.5, 1.4)
                    .foregroundStyle(Color.auText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - AUEmptyStateView (Warm Editorial Empty State)

struct AUEmptyStateView: View {
    let title: String
    let message: String
    var icon: AUIcon.Kind = .check
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.auTintBg)
                    .frame(width: 64, height: 64)
                AUIcon(kind: icon, size: 26, color: .auAccent)
            }
            .padding(.bottom, 4)

            Text(title.auLocalized)
                .font(.caprasimo(size: 20))
                .foregroundStyle(Color.auText)

            Text(message.auLocalized)
                .font(.figtree(.regular, size: 13.5))
                .auLine(13.5, 1.55)
                .foregroundStyle(Color.auTextSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 290)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle.auLocalized)
                        .font(.figtree(.semibold, size: 14))
                        .foregroundStyle(Color.auAccentText)
                        .padding(.top, 4)
                }
                .buttonStyle(.auTap)
            }
        }
        .padding(.vertical, 36)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.auFill.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.auEdge, style: StrokeStyle(lineWidth: 1, dash: [6, 5]))
        )
    }
}

// MARK: - AUShakeEffect (Credentials & Form Error Feedback)

struct AUShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX:
                    amount * sin(animatableData * .pi * shakesPerUnit),
                y: 0))
    }
}

// MARK: - AUConfirmDialog (Mid-Lesson Exit Confirmation Modal)

struct AUConfirmDialog: View {
    let title: String
    let message: String
    let confirmTitle: String
    let cancelTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.38)
                .ignoresSafeArea()
                .onTapGesture { onCancel() }

            VStack(spacing: 16) {
                Text(title.auLocalized)
                    .font(.caprasimo(size: 20))
                    .foregroundStyle(Color.auText)
                    .multilineTextAlignment(.center)

                Text(message.auLocalized)
                    .font(.figtree(.regular, size: 14))
                    .auLine(14, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.6))
                    .multilineTextAlignment(.center)

                VStack(spacing: 8) {
                    APillButton(title: confirmTitle, variant: .primary) {
                        onConfirm()
                    }
                    Button(action: onCancel) {
                        Text(cancelTitle.auLocalized)
                            .font(.figtree(.semibold, size: 14.5))
                            .foregroundStyle(Color.auText.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.auTap)
                }
                .padding(.top, 8)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.auSurface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(Color.auEdge, lineWidth: 1)
            )
            .auSoft()
            .padding(.horizontal, 28)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

// MARK: - Craft-overhaul primitives (qa/CRAFT_IMPROVEMENT_PLAN.md §2.4)

// MARK: Hit target (.auMinHitTarget)

/// Guarantees a 44×44pt hit area (HIG minimum) without enlarging the visual.
/// The view keeps its own size; an invisible contentShape expands tappability.
/// Apply to small icon buttons, chips, and text-link CTAs.
struct AUMinHitTarget: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
    }
}

extension View {
    func auMinHitTarget() -> some View {
        modifier(AUMinHitTarget())
    }
}

// MARK: Unified header (AUHeader)

/// One back/close header for every pushed flow — replaces the three ad-hoc
/// treatments (circled back, bare close, none) and the 70/74pt inset drift.
/// Inset is safe-area-relative; the button is its own accessible element
/// (fixes the StepHeader VoiceOver-swallowed Back, DEFECT C1).
struct AUHeader: View {
    enum Kind { case back, close }
    let kind: Kind
    var title: String? = nil
    var aid: String? = nil
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                AUFeedback.press()
                action()
            }) {
                AUIcon(kind: kind == .back ? .back : .close, size: 17, color: .auText)
                    .frame(width: 44, height: 44)
                    .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
            }
            .buttonStyle(.auTap)
            .accessibilityLabel(kind == .back ? "Back" : "Close")
            .accessibilityIdentifier(aid ?? "au.header.\(kind == .back ? "back" : "close")")

            if let title {
                Text(title.auLocalized)
                    .font(.figtree(.semibold, size: 12))
                    .tracking(1.2)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.auTextSecondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
    }
}

// MARK: Shared banner (AUBanner)

/// Error/info banner with an authored entrance — replaces the hard-cut
/// insert/remove on Login and Subscribe (DEFECT M9/G21). Animate the
/// `isPresented` binding with `withAnimation(AUMotion.flow, …)` at the call site.
struct AUBanner: View {
    enum Tone { case error, info }
    let text: String
    var tone: Tone = .error

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AUIcon(
                kind: tone == .error ? .warning : .sparkle, size: 13,
                color: tone == .error ? .auErrText : .auAccentText
            )
            .padding(.top, 2)
            Text(text.auLocalized)
                .font(.figtree(.medium, size: 13.5))
                .auLine(13.5, 1.45)
                .foregroundStyle(tone == .error ? Color.auErrText : Color.auAccentText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(tone == .error ? Color.auErrBg : Color.auTintBg)
        )
        .transition(
            .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .opacity
            )
        )
        .accessibilityIdentifier("au.banner.\(tone == .error ? "error" : "info")")
    }
}
