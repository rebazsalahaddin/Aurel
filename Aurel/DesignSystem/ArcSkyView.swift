import SwiftUI

// MARK: - Day arc (Aurel.dc.html lines 492–528 + 2142–2147, 2324–2346)
//
// The home card's sky: a quadratic arc the sun travels as the day's two
// halves complete, over two dune fills. All geometry is authored in a
// 354×118 viewBox and stretched to width (preserveAspectRatio=none).

/// bez(t, a, b, c) — quadratic bezier at t for endpoints a/c and control b.
func auBezier(_ t: Double, _ a: Double, _ b: Double, _ c: Double) -> Double {
    let u = 1 - t
    return u * u * a + 2 * u * t * b + t * t * c
}

/// Pure logic for the day-arc card, ported from renderVals.
struct DayArcState: Equatable, Sendable {
    var dayLesson: Bool  // first half (lesson) done
    var dayRecall: Bool  // second half (review) done
    var dueNow: Int  // words due back
    var arcsCompleted: Int  // lifetime completed day-arcs

    /// arcT = !dayLesson ? 0 : ((dayRecall || dueNow === 0) ? 1 : 0.5)
    var arcT: Double {
        if !dayLesson { return 0 }
        return (dayRecall || dueNow == 0) ? 1 : 0.5
    }

    /// Sun position in the 354×118 viewBox space.
    var sunPoint: CGPoint {
        CGPoint(x: auBezier(arcT, 26, 177, 328), y: auBezier(arcT, 84, -22, 84))
    }

    /// stroke-dashoffset for the progress arc (pathLength 100).
    var arcOffset: Int { 100 - Int((arcT * 100).rounded()) }
}

/// The sky panel itself — gradients, dunes, arcs, travelling sun, and the
/// Dawn/Sundown chips that sit on the dune.
struct ArcSkyView: View {
    let state: DayArcState
    var height: CGFloat = 118

    /// §3.6(c): scroll-linked sun travel, 0…0.3 of the arc. The sun drifts
    /// along its arc as the home screen scrolls (data-driven `arcT` plus
    /// this travel); the progress stroke stays data-honest at `arcT`.
    /// Reduce-motion callers pass 0 (static sun).
    var sunTravel: Double = 0

    /// The sun's effective arc position — data plus scroll travel.
    private var sunT: Double { min(1, max(0, state.arcT + sunTravel)) }

    /// Sun position in the 354×118 viewBox space at the effective t.
    private var sunPoint: CGPoint {
        CGPoint(x: auBezier(sunT, 26, 177, 328), y: auBezier(sunT, 84, -22, 84))
    }

    // Chips: (done, label, meta)
    var dawnDone: Bool = false
    var dawnMeta: String = ""
    var sundownDone: Bool = false
    var sundownMeta: String = ""

    var body: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1)
            let h = max(geo.size.height, 1)
            let sx = w / 354
            let sy = h / 118

            ZStack(alignment: .topLeading) {
                skyBackground

                // Design-space layer (354×118), stretched to the live card width.
                ZStack(alignment: .topLeading) {
                    DuneShape()
                        .fill(Color.auDune)
                    DuneShape(back: false)
                        .fill(Color.auDune2)

                    ArcTrack()
                        .stroke(
                            Color.auText.opacity(0.15),
                            style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 7])
                        )
                    ArcTrack()
                        .trim(from: 0, to: state.arcT)
                        .stroke(
                            Color.auAccent.opacity(0.8),
                            style: StrokeStyle(lineWidth: 2, lineCap: .round)
                        )
                        .animation(.easeInOut(duration: 0.9), value: state.arcT)

                    SunMark()
                        .frame(width: 34, height: 34)
                        .position(x: sunPoint.x, y: sunPoint.y)
                        .animation(.easeInOut(duration: 0.9), value: state.arcT)
                        // §3.6(c): the sun also tracks scroll — follow the
                        // travel value without re-triggering the data spring.
                        .animation(.easeInOut(duration: 0.35), value: sunTravel)
                }
                .frame(width: 354, height: 118, alignment: .topLeading)
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                .frame(width: w, height: h, alignment: .topLeading)

                // Dawn / Sundown chips sit on the live card (not design-scaled text).
                HStack(alignment: .center) {
                    chip(done: dawnDone, label: "Dawn", meta: dawnMeta)
                    Spacer(minLength: 8)
                    chip(done: sundownDone, label: "Sundown", meta: sundownMeta)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 11)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(height: height)
        .clipped()
    }

    /// arcSky gradient tiers (authored values, theme-independent):
    /// arcs ≥ 100 golden, ≥ 30 mid, else the default sky.
    @ViewBuilder
    private var skyBackground: some View {
        if state.arcsCompleted >= 100 {
            LinearGradient(
                stops: [
                    .init(color: Color(UIColor(hex: 0xfdf6e6)), location: 0),
                    .init(color: Color(UIColor(hex: 0xf6e7c4)), location: 0.46),
                    .init(color: Color(UIColor(hex: 0xe9cfa4)), location: 1),
                ], startPoint: .top, endPoint: .bottom)
        } else if state.arcsCompleted >= 30 {
            LinearGradient(
                stops: [
                    .init(color: Color(UIColor(hex: 0xfbf1e2)), location: 0),
                    .init(color: Color(UIColor(hex: 0xf6ddc6)), location: 0.5),
                    .init(color: Color(UIColor(hex: 0xeec7ab)), location: 1),
                ], startPoint: .top, endPoint: .bottom)
        } else {
            AUGradients.sky
        }
    }

    private func chip(done: Bool, label: String, meta: String) -> some View {
        HStack(spacing: 6) {
            if done {
                AUIcon(kind: .check, size: 12, color: .auDuneText)
            }
            Text(label)
                .font(.figtree(.bold, size: 9.5))
                .tracking(1.33)
                .textCase(.uppercase)
                .opacity(0.85)
            Text(meta)
                .font(.figtree(.regular, size: 11))
                .opacity(0.7)
        }
        .foregroundStyle(Color.auDuneText)
    }

    /// `M0 88 Q66 70 130 82 Q196 94 262 76 Q318 62 354 78 V118 H0 Z` (front)
    /// and `M0 104 Q78 88 148 98 Q214 108 278 92 Q326 80 354 94 V118 H0 Z`.
    private struct DuneShape: Shape {
        var back = true

        func path(in rect: CGRect) -> Path {
            var p = Path()
            if back {
                p.move(to: CGPoint(x: 0, y: 88))
                p.addQuadCurve(to: CGPoint(x: 130, y: 82), control: CGPoint(x: 66, y: 70))
                p.addQuadCurve(to: CGPoint(x: 262, y: 76), control: CGPoint(x: 196, y: 94))
                p.addQuadCurve(to: CGPoint(x: 354, y: 78), control: CGPoint(x: 318, y: 62))
                p.addLine(to: CGPoint(x: 354, y: 118))
                p.addLine(to: CGPoint(x: 0, y: 118))
            } else {
                p.move(to: CGPoint(x: 0, y: 104))
                p.addQuadCurve(to: CGPoint(x: 148, y: 98), control: CGPoint(x: 78, y: 88))
                p.addQuadCurve(to: CGPoint(x: 278, y: 92), control: CGPoint(x: 214, y: 108))
                p.addQuadCurve(to: CGPoint(x: 354, y: 94), control: CGPoint(x: 326, y: 80))
                p.addLine(to: CGPoint(x: 354, y: 118))
                p.addLine(to: CGPoint(x: 0, y: 118))
            }
            p.closeSubpath()
            return p
        }
    }

    /// `M26 84 Q177 -22 328 84`.
    private struct ArcTrack: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            p.move(to: CGPoint(x: 26, y: 84))
            p.addQuadCurve(to: CGPoint(x: 328, y: 84), control: CGPoint(x: 177, y: -22))
            return p
        }
    }

    /// The sun: radial gradient with a warm glow.
    private struct SunMark: View {
        var body: some View {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(color: Color(UIColor(hex: 0xfff1d4)), location: 0),
                                .init(color: Color(UIColor(hex: 0xf7c489)), location: 0.38),
                                .init(color: Color(UIColor(hex: 0xe08f4c)), location: 0.68),
                                .init(
                                    color: Color(UIColor(hex: 0xe08f4c)).opacity(0.16),
                                    location: 0.82),
                                .init(color: .clear, location: 0.86),
                            ],
                            center: UnitPoint(x: 0.5, y: 0.42),
                            startRadius: 0, endRadius: 17
                        )
                    )
                    .shadow(color: Color.auAccent.opacity(0.34), radius: 13, x: 0, y: 0)
            }
            .allowsHitTesting(false)
        }
    }
}

// MARK: - Lesson path node (mkNode, Aurel.dc.html lines 2122–2141)

/// One stop on the home lesson path: open (breathing accent sun-disc with
/// halo), done (sage disc with check), or locked (dashed glass with lock).
/// Labels sit beside the disc in `HomeView` (design absolute placements) —
/// this view is the disc only, centered on the stop via translate(-50%,-50%).
struct LessonPathNode: View {
    enum NodeState { case open, done, locked }

    let state: NodeState
    let index: Int
    var cta: String = ""
    let label: String
    let meta: String
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    /// §3.6(b): drives the persistent ring pulse on the open stop.
    @State private var pingOn = false

    /// Disc diameter from mkNode (open 94; done/locked per-stop sizes).
    private var size: CGFloat {
        switch state {
        case .open: 94
        case .done: [74, 70, 74, 70, 72][min(index, 4)]
        case .locked: [72, 70, 74, 68, 72][min(index, 4)]
        }
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                switch state {
                case .open:
                    // Halo sits behind the disc (design: absolute sibling, not clipped).
                    if !reduceMotion {
                        Circle().fill(Color.auAccent)
                            .frame(width: size + 20, height: size + 20)
                            .modifier(PulseHalo())
                            .allowsHitTesting(false)
                    }
                    // §3.6(b): the open stop also carries a persistent ring
                    // pulse — a stroke that swells and fades, marking
                    // "you are here" without sound or motion excess.
                    if !reduceMotion {
                        Circle()
                            .strokeBorder(Color.auAccent.opacity(pingOn ? 0 : 0.55), lineWidth: pingOn ? 0.75 : 2.5)
                            .scaleEffect(pingOn ? 1.22 : 1)
                            .frame(width: size, height: size)
                            .allowsHitTesting(false)
                            .onAppear {
                                withAnimation(
                                    .easeOut(duration: 1.9).repeatForever(autoreverses: false)
                                ) { pingOn = true }
                            }
                    }
                    Circle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(color: Color.auAccent.opacity(0.8), location: 0),
                                    .init(color: Color.auAccent.opacity(0.9), location: 0.52),
                                    // accent-800 (#643312) — the authored stop is
                                    // the deep *amber*, not the sage ramp.
                                    .init(
                                        color: Color.auAccentRamp(800).opacity(0.92),
                                        location: 1),
                                ],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .overlay(Circle().strokeBorder(.white.opacity(0.28), lineWidth: 1))
                        .overlay(
                            VStack(spacing: 2) {
                                AUIcon(
                                    kind: .play, size: 26,
                                    color: Color(red: 1, green: 0.965, blue: 0.918))  // #fff6ea
                                Text(cta)
                                    .font(.figtree(.bold, size: 10))
                                    .tracking(1.2)
                                    .textCase(.uppercase)
                            }
                            .foregroundStyle(Color(red: 1, green: 0.965, blue: 0.918))
                        )
                        .frame(width: size, height: size)
                case .done:
                    Circle()
                        .fill(
                            LinearGradient(
                                stops: [
                                    .init(
                                        color: Color.auAccent2Ramp(500).mixed(
                                            with: 0.26, of: .white), location: 0),
                                    .init(color: Color.auAccent2Ramp(500), location: 0.55),
                                    .init(
                                        color: Color.auAccent2Ramp(600).opacity(0.8),
                                        location: 1),
                                ],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .overlay(
                            AUIcon(
                                kind: .check, size: min(30, size * 0.4),
                                color: Color(red: 0.984, green: 0.98, blue: 0.961))  // #fbfaf5
                        )
                        .frame(width: size, height: size)
                case .locked:
                    Circle()
                        .fill(Color.auFill.opacity(0.72))
                        .overlay(
                            Circle().strokeBorder(
                                Color.auText.opacity(0.18),
                                style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])
                            )
                        )
                        .overlay(
                            AUIcon(kind: .lock, size: 19, color: .auText.opacity(0.38))
                        )
                        .frame(width: size, height: size)
                }
            }
            // Keep layout box = disc size so `.position` centers on the stop
            // (halo paints outside without shifting the layout origin).
            .frame(width: size, height: size)
        }
        .buttonStyle(.auTap)
        // §3.6(f): each stop is one AX element — label + state + meta read
        // together ("Lesson 2, Names. You are here."). The open stop carries
        // the "You are here" marker (§3.6(b)).
        .accessibilityLabel("Lesson \(index + 1), \(label). \(axState)")
        .accessibilityHint(meta)
        .accessibilityIdentifier("au.home.node.\(index)")
    }

    /// The stop's state, spoken as part of its AX label.
    private var axState: String {
        switch state {
        case .open: "You are here"
        case .done: "Complete"
        case .locked: "Locked"
        }
    }

    /// auPulse halo on the open node.
    private struct PulseHalo: ViewModifier {
        @State private var on = false
        func body(content: Content) -> some View {
            content
                .scaleEffect(on ? 1.18 : 1)
                .opacity(on ? 0 : 0.45)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.8).repeatForever(autoreverses: false)) {
                        on = true
                    }
                }
        }
    }

    /// auBreath on the open node.
    private struct Breath: ViewModifier {
        let enabled: Bool
        @State private var on = false
        func body(content: Content) -> some View {
            content
                .scaleEffect(enabled && on ? 1.04 : 1)
                .onAppear {
                    guard enabled else { return }
                    withAnimation(.easeInOut(duration: 3.8).repeatForever(autoreverses: true)) {
                        on = true
                    }
                }
        }
    }
}

// MARK: - Week dots (Aurel.dc.html lines 2111–2115)

/// M T W T F S S — today lit with the accent gradient, rest quiet.
struct WeekDots: View {
    var todayIndex: Int = 0

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(["M", "T", "W", "T", "F", "S", "S"].enumerated()), id: \.offset) {
                i, label in
                Text(label)
                    .font(.figtree(.semibold, size: 12))
                    .frame(width: 34, height: 34)
                    .background {
                        if i == todayIndex {
                            Capsule().fill(
                                LinearGradient(
                                    colors: [
                                        Color.auAccent.mixed(with: 0.26, of: .white),
                                        Color.auAccent,
                                    ],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                        } else {
                            Capsule().fill(Color.auText.opacity(0.10))
                        }
                    }
                    .foregroundStyle(i == todayIndex ? Color.auPrimaryButtonText : Color.auText)
                    .modifier(PopIn(delay: 0.06 + Double(i) * 0.055))
            }
        }
    }
}

extension Color {
    /// color-mix helper on SwiftUI colors (sRGB space).
    func mixed(with fraction: Double, of other: Color) -> Color {
        Color(UIColor(self).mixed(with: CGFloat(fraction), of: UIColor(other)))
    }
}

/// auPop — 0.86 scale + hidden → settle, with the authored easing.
struct PopIn: ViewModifier {
    let delay: Double
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var shown = false

    func body(content: Content) -> some View {
        if reduceMotion {
            content
        } else {
            content
                .scaleEffect(shown ? 1 : 0.86)
                .opacity(shown ? 1 : 0)
                .task {
                    try? await Task.sleep(for: .seconds(delay))
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.7)) { shown = true }
                }
        }
    }
}
