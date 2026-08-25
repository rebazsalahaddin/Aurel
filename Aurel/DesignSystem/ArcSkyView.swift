import SwiftUI

// MARK: - Day arc (Aurel.dc.html lines 492–528 + 2142–2147, 2324–2346)
//
// The home card's sky, drawn as a cinematic pre-dawn scene rather than a
// flat diagram. Back to front: a tiered dawn sky under a night veil that
// lifts as the day advances, a twinkling star field with glinting bright
// stars, a warm band of light pooling on the horizon, a breathing glow that
// follows the sun, three rim-lit dune ridges for atmospheric depth, a dashed
// guide arc under a gradient progress arc with a glowing comet tip,
// Dawn/Sundown milestone nodes at the arc's endpoints, a layered breathing
// sun that rises from behind the dune on first reveal, and glass status
// chips resting on the dune. All geometry is authored in a 354×118 viewBox
// and stretched to width (preserveAspectRatio=none).

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
        CGPoint(x: auBezier(arcT, 26, 177, 328), y: auBezier(arcT, 84, -22, 84) - 12)
    }
}

/// The sky panel itself — a cinematic pre-dawn scene rather than a flat
/// diagram. Back to front: a tiered dawn sky under a night veil that lifts
/// as the day advances, a twinkling star field with glinting bright stars,
/// a warm band of light pooling on the horizon, a breathing glow that
/// follows the sun, three rim-lit dune ridges for atmospheric depth, a
/// dashed guide arc under a gradient progress arc with a glowing comet tip,
/// Dawn/Sundown milestone nodes, a layered breathing sun that rises from
/// behind the dune on first reveal, and glass status chips resting on the
/// dune. All geometry is authored in a 354×118 viewBox and stretched to
/// width (preserveAspectRatio=none).
struct ArcSkyView: View {
    let state: DayArcState
    var height: CGFloat = 126

    /// §3.6(c): scroll-linked sun travel, 0…0.3 of the arc. The sun drifts
    /// along its arc as the home screen scrolls (data-driven `arcT` plus
    /// this travel); the progress stroke stays data-honest at `arcT`.
    /// Reduce-motion callers pass 0 (static sun).
    var sunTravel: Double = 0

    /// The sun's effective arc position — data plus scroll travel.
    private var sunT: Double { min(1, max(0, state.arcT + sunTravel)) }

    /// Sun position in the 354×118 viewBox space at the effective t.
    private var sunPoint: CGPoint {
        CGPoint(x: auBezier(sunT, 26, 177, 328), y: auBezier(sunT, 84, -22, 84) - 12)
    }

    // Chips: (done, label, meta)
    var dawnDone: Bool = false
    var dawnMeta: String = ""
    var sundownDone: Bool = false
    var sundownMeta: String = ""

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// First-reveal choreography — the sun rises from behind the dune.
    @State private var appeared = false

    /// The half of the day that is "now" — the first unfinished half.
    private var dawnActive: Bool { !dawnDone }
    private var sundownActive: Bool { dawnDone && !sundownDone }

    /// How much of the night still hangs over the sky: full at dawn, lifting
    /// as the day advances (a touch faster than the arc itself, so midday
    /// reads fully lit).
    private var nightT: Double { max(0, 1 - state.arcT * 1.15) }

    /// Rim light on the dune crests — a warm pool centred under the sun, so
    /// the ridges catch the light where the day currently stands.
    private var rimLight: LinearGradient {
        let fx = min(1, max(0.08, sunPoint.x / 354))
        return LinearGradient(
            stops: [
                .init(color: .clear, location: max(0, fx - 0.32)),
                .init(color: AUSceneArt.duskHighlight.opacity(0.5), location: fx),
                .init(color: .clear, location: min(1, fx + 0.32)),
            ],
            startPoint: .leading, endPoint: .trailing
        )
    }

    /// The day's full path — quietest at its ends, clearest overhead.
    private var guideStroke: LinearGradient {
        LinearGradient(
            colors: [
                Color.auDuneText.opacity(0.10),
                Color.auDuneText.opacity(0.30),
                Color.auDuneText.opacity(0.10),
            ],
            startPoint: .leading, endPoint: .trailing
        )
    }

    var body: some View {
        GeometryReader { geo in
            let w = max(geo.size.width, 1)
            let h = max(geo.size.height, 1)
            let sx = w / 354
            let sy = h / 118

            ZStack(alignment: .topLeading) {
                skyBackground

                // Design-space layer (354×118), stretched to the live card
                // width. Decorative — hidden from accessibility; the chips
                // below carry the meaning.
                ZStack(alignment: .topLeading) {
                    StarField(visible: 1 - state.arcT, reduceMotion: reduceMotion)

                    // The day's full path — quietest at its ends, clearest
                    // overhead; drawn behind all dunes so its ends dip into
                    // the sand and the arc reads as the sun's route, not
                    // a wire.
                    ArcTrack()
                        .stroke(
                            guideStroke,
                            style: StrokeStyle(lineWidth: 1.3, lineCap: .round, dash: [2, 6.5])
                        )

                    SunMark(reduceMotion: reduceMotion)
                        .frame(width: 26.6, height: 26.6)
                        // On first reveal the sun rises out of the dune line;
                        // from then on it tracks the day's progress exactly.
                        .offset(y: appeared ? 0 : 16)
                        .opacity(appeared ? 1 : 0)
                        .position(x: sunPoint.x, y: sunPoint.y)
                        .animation(
                            AUMotion.animation(AUMotion.hero, reduceMotion: reduceMotion),
                            value: state.arcT
                        )
                        // §3.6(c): the sun also tracks scroll — follow the
                        // travel value without re-triggering the data spring.
                        .animation(
                            AUMotion.animation(
                                .easeInOut(duration: 0.35), reduceMotion: reduceMotion),
                            value: sunTravel)

                    // All mountain / dune layers rendered in front of the globe
                    // and guide track for complete atmospheric depth.
                    DuneShape(variant: .far)
                        .fill(Color.auDune.opacity(0.35))
                    DuneShape(variant: .back)
                        .fill(Color.auDune)
                        .overlay { DuneShape(variant: .back).stroke(rimLight, lineWidth: 0.8) }
                    DuneShape(variant: .front)
                        .fill(Color.auDune2)
                        .overlay { DuneShape(variant: .front).stroke(rimLight, lineWidth: 0.9) }

                    // The night lifting as the day advances — deepest at
                    // zenith, thinning into the horizon's warmth.
                    LinearGradient(
                        stops: [
                            .init(color: Color.auBackground.opacity(0.60), location: 0),
                            .init(color: Color.auBackground.opacity(0.28), location: 0.45),
                            .init(color: .clear, location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                    .opacity(nightT * 0.55)
                    .animation(
                        AUMotion.animation(
                            .easeInOut(duration: 1.2), reduceMotion: reduceMotion),
                        value: state.arcT
                    )
                    .allowsHitTesting(false)

                    // A quiet vignette keeps the eye inside the frame.
                    RadialGradient(
                        stops: [
                            .init(color: .clear, location: 0.55),
                            .init(color: Color.black.opacity(0.16), location: 1),
                        ],
                        center: .center, startRadius: 8, endRadius: 210
                    )
                    .allowsHitTesting(false)
                }
                .frame(width: 354, height: 118, alignment: .topLeading)
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                .frame(width: w, height: h, alignment: .topLeading)
                .accessibilityHidden(true)

                // Dawn / Sundown chips sit on the live card with clearance
                // from the dawn sun endpoint while maximizing text room.
                HStack(alignment: .center, spacing: 8) {
                    chip(done: dawnDone, active: dawnActive, label: "Dawn", meta: dawnMeta)
                        .modifier(ChipEntrance(delay: 0.16))
                    Spacer(minLength: 6)
                    chip(
                        done: sundownDone, active: sundownActive,
                        label: "Sundown", meta: sundownMeta
                    )
                    .modifier(ChipEntrance(delay: 0.28))
                }
                .padding(.leading, 38)
                .padding(.trailing, 14)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .animation(
                    AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion), value: dawnDone
                )
                .animation(
                    AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                    value: sundownDone)
            }
            .onAppear {
                guard !reduceMotion, !appeared else { return }
                withAnimation(.easeOut(duration: 1.1)) { appeared = true }
            }
        }
        .frame(height: height)
        .clipped()
        .overlay { GrainOverlay(opacity: 0.05) }
    }

    // MARK: Scene pieces

    /// A milestone node at one end of the arc: a quiet hollow ring while the
    /// half is pending, a filled glowing disc once it is done. These anchor
    /// the arc's ends semantically — the sun departs from Dawn and arrives
    /// at Sundown.
    @ViewBuilder
    private func milestone(at point: CGPoint, done: Bool) -> some View {
        ZStack {
            if done {
                Circle()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(color: Color.auAccent.opacity(0.40), location: 0),
                                .init(color: Color.auAccent.opacity(0.14), location: 0.6),
                                .init(color: .clear, location: 1),
                            ],
                            center: .center, startRadius: 0, endRadius: 9
                        )
                    )
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(Color.auAccent)
                    .frame(width: 9.5, height: 9.5)
                    .overlay(
                        Circle().strokeBorder(AUSceneArt.onAccent.opacity(0.5), lineWidth: 0.8)
                    )
                    .shadow(color: Color.auAccent.opacity(0.55), radius: 3, x: 0, y: 0)
            } else {
                Circle()
                    .fill(Color.auDuneText.opacity(0.10))
                    .frame(width: 9, height: 9)
                Circle()
                    .strokeBorder(Color.auDuneText.opacity(0.35), lineWidth: 1)
                    .frame(width: 9, height: 9)
            }
        }
        .position(point)
        .animation(
            AUMotion.animation(AUMotion.celebration, reduceMotion: reduceMotion), value: done)
    }

    /// arcSky gradient tiers (authored values, theme-independent):
    /// arcs ≥ 100 golden, ≥ 30 mid, else the default sky. Each tier carries
    /// an extra lifted mid-sky stop so the zenith reads deeper than the
    /// authored horizon warmth.
    @ViewBuilder
    private var skyBackground: some View {
        if state.arcsCompleted >= 100 {
            LinearGradient(
                stops: [
                    .init(color: Color(UIColor(hex: 0xefe6cf)), location: 0),
                    .init(color: Color(UIColor(hex: 0xfdf6e6)), location: 0.38),
                    .init(color: Color(UIColor(hex: 0xf6e7c4)), location: 0.72),
                    .init(color: Color(UIColor(hex: 0xe9cfa4)), location: 1),
                ], startPoint: .top, endPoint: .bottom)
        } else if state.arcsCompleted >= 30 {
            LinearGradient(
                stops: [
                    .init(color: Color(UIColor(hex: 0xf2e0cd)), location: 0),
                    .init(color: Color(UIColor(hex: 0xfbf1e2)), location: 0.42),
                    .init(color: Color(UIColor(hex: 0xf6ddc6)), location: 0.74),
                    .init(color: Color(UIColor(hex: 0xeec7ab)), location: 1),
                ], startPoint: .top, endPoint: .bottom)
        } else {
            AUGradients.sky
        }
    }

    /// A chip is one semantic unit: status mark, half-name, and its meta
    /// ("done", "nothing due", …). Done reads as settled glass with a check;
    /// the active half glows gently with the accent and a pinging ring — the
    /// scene's "now" indicator; a quiet half waits. Reads as one AX element.
    private func chip(done: Bool, active: Bool, label: String, meta: String) -> some View {
        HStack(spacing: 6) {
            if done {
                AUIcon(kind: .check, size: 10, color: .auDuneText)
            }

            Text(label.auLocalized)
                .font(.figtree(.bold, size: 9.5))
                .tracking(1.33)
                .textCase(.uppercase)
                .opacity(done || active ? 0.95 : 0.6)
                .fixedSize(horizontal: true, vertical: false)
            Text(meta)
                .font(.figtree(done ? .semibold : .regular, size: 11))
                .opacity(done || active ? 0.8 : 0.55)
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(0.85)
        }
        .foregroundStyle(Color.auDuneText)
        .padding(.horizontal, 10)
        .padding(.vertical, 4.5)
        .background(
            Capsule()
                .fill(.ultraThinMaterial.opacity(0.35))
        )
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.07), location: 0),
                            .init(color: Color.white.opacity(0.01), location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
        )
        .overlay(
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        stops: [
                            .init(color: Color.white.opacity(0.20), location: 0),
                            .init(color: Color.white.opacity(0.05), location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 0.6
                )
        )
        .animation(AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion), value: done)
        .animation(AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion), value: active)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label): \(done ? "done" : meta)")
    }

    /// `M0 88 Q66 70 130 82 Q196 94 262 76 Q318 62 354 78 V118 H0 Z` (back)
    /// and `M0 104 Q78 88 148 98 Q214 108 278 92 Q326 80 354 94 V118 H0 Z`
    /// (front). The far ridge sits above the back dune for depth.
    private struct DuneShape: Shape {
        enum Variant { case far, back, front }
        var variant: Variant = .back

        func path(in rect: CGRect) -> Path {
            var p = Path()
            switch variant {
            case .far:
                p.move(to: CGPoint(x: 0, y: 80))
                p.addQuadCurve(to: CGPoint(x: 160, y: 72), control: CGPoint(x: 80, y: 64))
                p.addQuadCurve(to: CGPoint(x: 354, y: 66), control: CGPoint(x: 250, y: 82))
            case .back:
                p.move(to: CGPoint(x: 0, y: 76))
                p.addQuadCurve(to: CGPoint(x: 130, y: 82), control: CGPoint(x: 60, y: 66))
                p.addQuadCurve(to: CGPoint(x: 262, y: 76), control: CGPoint(x: 196, y: 94))
                p.addQuadCurve(to: CGPoint(x: 354, y: 78), control: CGPoint(x: 318, y: 62))
            case .front:
                p.move(to: CGPoint(x: 0, y: 104))
                p.addQuadCurve(to: CGPoint(x: 148, y: 98), control: CGPoint(x: 78, y: 88))
                p.addQuadCurve(to: CGPoint(x: 278, y: 92), control: CGPoint(x: 214, y: 108))
                p.addQuadCurve(to: CGPoint(x: 354, y: 94), control: CGPoint(x: 326, y: 80))
            }
            p.addLine(to: CGPoint(x: 354, y: 118))
            p.addLine(to: CGPoint(x: 0, y: 118))
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

    /// The sun: a crisp radial disc with specular lift and a soft transparent pulsing glow.
    private struct SunMark: View {
        let reduceMotion: Bool
        @State private var pingOn = false

        var body: some View {
            ZStack {
                // Soft pulse halo behind the globe (10% stronger)
                if !reduceMotion {
                    Circle()
                        .fill(Color(UIColor(hex: 0xb25f1f)).opacity(0.24))
                        .frame(width: 42.4, height: 42.4)
                        .modifier(PulseHalo())
                        .allowsHitTesting(false)
                }

                // Persistent ring pulse marking active globe (10% stronger)
                if !reduceMotion {
                    Circle()
                        .strokeBorder(
                            Color(UIColor(hex: 0xf29858)).opacity(pingOn ? 0 : 0.33),
                            lineWidth: pingOn ? 0.65 : 1.5
                        )
                        .scaleEffect(pingOn ? 1.45 : 1)
                        .frame(width: 26.6, height: 26.6)
                        .allowsHitTesting(false)
                        .onAppear {
                            withAnimation(
                                .easeOut(duration: 2.2).repeatForever(autoreverses: false)
                            ) { pingOn = true }
                        }
                }

                // Core disc (10% larger)
                Circle()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(color: Color(UIColor(hex: 0xfff6e0)), location: 0),
                                .init(color: Color(UIColor(hex: 0xf9d29b)), location: 0.34),
                                .init(color: Color(UIColor(hex: 0xee9d58)), location: 0.66),
                                .init(color: Color(UIColor(hex: 0xb25f1f)), location: 1.0),
                            ],
                            center: UnitPoint(x: 0.5, y: 0.42),
                            startRadius: 0, endRadius: 13.3
                        )
                    )
                    .overlay(
                        Circle().strokeBorder(
                            Color(UIColor(hex: 0xf29858)).opacity(0.66), lineWidth: 1.3)
                    )
                    .shadow(
                        color: Color(UIColor(hex: 0xee9d58)).opacity(0.35), radius: 6, x: 0, y: 0
                    )
                    .frame(width: 26.6, height: 26.6)

            }
            .allowsHitTesting(false)
        }
    }

    /// A four-point sparkle (north–south–east–west tapered petals).
    private struct SparkleMark: Shape {
        func path(in rect: CGRect) -> Path {
            var p = Path()
            let c = CGPoint(x: rect.midX, y: rect.midY)
            let r = min(rect.width, rect.height) / 2
            let w = r * 0.28
            p.move(to: CGPoint(x: c.x, y: c.y - r))
            p.addQuadCurve(to: CGPoint(x: c.x, y: c.y + r), control: CGPoint(x: c.x + w, y: c.y))
            p.addQuadCurve(to: CGPoint(x: c.x, y: c.y - r), control: CGPoint(x: c.x - w, y: c.y))
            p.move(to: CGPoint(x: c.x - r, y: c.y))
            p.addQuadCurve(to: CGPoint(x: c.x + r, y: c.y), control: CGPoint(x: c.x, y: c.y + w))
            p.addQuadCurve(to: CGPoint(x: c.x - r, y: c.y), control: CGPoint(x: c.x, y: c.y - w))
            return p
        }
    }

    /// Pre-dawn stars. The field's opacity is tied to the day's progress —
    /// full at dawn (arcT 0), dissolved by midday — and each star twinkles
    /// on its own staggered, deterministic rhythm. Two bright stars carry a
    /// four-point glint. Static under Reduce Motion.
    private struct StarField: View {
        let visible: Double
        let reduceMotion: Bool
        @State private var twinkle = false

        /// (position, size, glint) in the 354×118 design space, authored to
        /// keep clear of the arc's apex.
        private let stars: [(point: CGPoint, size: Double, glint: Bool)] = [
            (CGPoint(x: 52, y: 20), 1.4, false),
            (CGPoint(x: 96, y: 12), 1.0, false),
            (CGPoint(x: 148, y: 24), 1.6, true),
            (CGPoint(x: 205, y: 9), 1.1, false),
            (CGPoint(x: 246, y: 22), 1.4, false),
            (CGPoint(x: 292, y: 13), 1.0, false),
            (CGPoint(x: 322, y: 30), 1.3, false),
            (CGPoint(x: 74, y: 36), 1.0, false),
            (CGPoint(x: 178, y: 40), 1.0, false),
            (CGPoint(x: 268, y: 42), 1.2, false),
            (CGPoint(x: 40, y: 52), 0.9, false),
            (CGPoint(x: 128, y: 46), 0.8, false),
            (CGPoint(x: 224, y: 48), 0.9, false),
            (CGPoint(x: 306, y: 50), 0.8, false),
            (CGPoint(x: 116, y: 60), 0.7, false),
            (CGPoint(x: 250, y: 60), 0.7, false),
        ]

        var body: some View {
            ZStack {
                ForEach(Array(stars.enumerated()), id: \.offset) { i, star in
                    ZStack {
                        Circle()
                            .fill(Color.auDuneText)
                            .frame(width: star.size, height: star.size)
                        if star.glint {
                            SparkleMark()
                                .fill(Color.auDuneText.opacity(0.8))
                                .frame(width: star.size * 5, height: star.size * 5)
                        }
                    }
                    .position(star.point)
                    .opacity(twinkle ? 0.9 : 0.35)
                    .animation(
                        reduceMotion
                            ? nil
                            : .easeInOut(duration: 2.2 + Double(i % 3) * 0.6)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.31),
                        value: twinkle
                    )
                }
            }
            .opacity(max(0, min(1, visible)) * 0.75)
            .onAppear { twinkle = true }
            .allowsHitTesting(false)
        }
    }

    /// The active half's dot emits a slow expanding ring — "this is now".
    private struct PingRing: ViewModifier {
        @State private var ping = false

        func body(content: Content) -> some View {
            content
                .scaleEffect(ping ? 2.6 : 1)
                .opacity(ping ? 0 : 0.75)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.2).repeatForever(autoreverses: false)) {
                        ping = true
                    }
                }
        }
    }

    /// Chip entrance — a soft rise from the dune, staggered per chip. Static
    /// under Reduce Motion.
    private struct ChipEntrance: ViewModifier {
        let delay: Double
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var shown = false

        func body(content: Content) -> some View {
            if reduceMotion {
                content
            } else {
                content
                    .offset(y: shown ? 0 : 10)
                    .scaleEffect(shown ? 1 : 0.92)
                    .opacity(shown ? 1 : 0)
                    .task {
                        try? await Task.sleep(for: .seconds(delay))
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.72)) {
                            shown = true
                        }
                    }
            }
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
        Button(action: {
            AUFeedback.press()
            action()
        }) {
            ZStack {
                switch state {
                case .open:
                    // Halo sits behind the disc (design: absolute sibling, not clipped).
                    if !reduceMotion {
                        Circle().fill(Color(UIColor(hex: 0xb25f1f)).opacity(0.35))
                            .frame(width: size + 20, height: size + 20)
                            .modifier(PulseHalo())
                            .allowsHitTesting(false)
                    }
                    // Persistent ring pulse marking "you are here"
                    if !reduceMotion {
                        Circle()
                            .strokeBorder(
                                Color(UIColor(hex: 0xb25f1f)).opacity(pingOn ? 0 : 0.55),
                                lineWidth: pingOn ? 0.75 : 2.5
                            )
                            .scaleEffect(pingOn ? 1.22 : 1)
                            .frame(width: size, height: size)
                            .allowsHitTesting(false)
                            .onAppear {
                                withAnimation(
                                    .easeOut(duration: 2.2).repeatForever(autoreverses: false)
                                ) { pingOn = true }
                            }
                    }
                    Circle()
                        .fill(Color.auPrimaryButtonFill)
                        .overlay(
                            Circle().strokeBorder(
                                Color.auPrimaryButtonBorder.opacity(0.72), lineWidth: 1.2)
                        )
                        .overlay(
                            VStack(spacing: 2) {
                                AUIcon(
                                    kind: .play, size: 26,
                                    color: Color(red: 1, green: 0.965, blue: 0.918))
                                Text(cta)
                                    .font(.figtree(.bold, size: 10))
                                    .tracking(1.2)
                                    .textCase(.uppercase)
                            }
                            .foregroundStyle(Color(red: 1, green: 0.965, blue: 0.918))
                        )
                        .shadow(color: Color.auPrimaryButtonFill.opacity(0.35), radius: 12, y: 6)
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
                                        color: Color.auAccent2Ramp(600).opacity(0.85),
                                        location: 1),
                                ],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .overlay(Circle().strokeBorder(Color.white.opacity(0.25), lineWidth: 1))
                        .overlay(
                            AUIcon(
                                kind: .check, size: min(30, size * 0.4),
                                color: Color(red: 0.984, green: 0.98, blue: 0.961))
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 6, y: 3)
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
}

/// auPulse halo on active nodes and the sun globe.
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
