import SwiftUI

// MARK: - Shared scene pieces
//
// The Aurel wordmark, the dusk-scene backdrops (welcome + plan), stars,
// glints, step headers, the glass tab bar, and the offline banner — ported
// from Aurel.dc.html lines 125–176, 377–409, 1550–1557.

/// The Aurel "A over dune" wordmark (64-unit viewBox, tintable).
struct AULogoMark: View {
    var size: CGFloat = 27
    var mono: Bool = false  // true = all currentColor (home header)

    /// Authored viewBox — `<svg viewBox="0 0 64 64">` (Aurel.dc.html:147).
    fileprivate static let box = CGSize(width: 64, height: 64)

    var body: some View {
        ZStack {
            SVGPathShape(
                d:
                    "M32.7 4.9 C35.0 14.6 45.8 39.8 58.6 56.4 L50.2 56.4 C41.4 41.2 34.4 20.6 32.2 11.6 C31.0 17.6 22.8 41.2 15.0 56.4 L10.2 56.4 C18.4 40.4 30.4 14.4 32.7 4.9 Z",
                viewBox: Self.box
            )
            // #f7efe2
            .fill(mono ? Color.auText : Color(red: 0.969, green: 0.937, blue: 0.886))
            SVGPathShape(d: "M24.2 43.4 A8 8 0 0 1 40.2 43.4 Z", viewBox: Self.box)
                // #e2925a
                .fill(mono ? Color.auAccent : Color(red: 0.886, green: 0.573, blue: 0.353))
            SVGPathShape(
                d: "M18.6 46.8 C26.6 43.4 37 42.2 45.4 42.6 C37 45.4 26.6 47.2 18.6 46.8 Z",
                viewBox: Self.box
            )
            .fill(mono ? Color.auText : Color(red: 0.969, green: 0.937, blue: 0.886))
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

/// Wordmark row with the fading rule and level tag (welcome, line 146–155).
struct AUWordmarkRow: View {
    var body: some View {
        HStack(spacing: 11) {
            AULogoMark(size: 31)
            Text("Aurel")
                .font(.caprasimo(size: 21))
                .tracking(0.32)
                .foregroundStyle(AUSceneArt.duskCream)
                .fixedSize()
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            AUSceneArt.duskCream.opacity(0.34), AUSceneArt.duskCream.opacity(0.05),
                        ], startPoint: .leading, endPoint: .trailing)
                )
                .frame(height: 1)
            Text("A1 · Foundation")
                .font(.figtree(.semibold, size: 10))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(AUSceneArt.duskCream.opacity(0.58))
                .fixedSize()
        }
    }
}

// MARK: Stars + glints (lines 40–47, 128–132)

/// The twinkling star field — authored box-shadow positions.
struct AUStars: View {
    struct Star: Identifiable {
        let id: Int
        let x: CGFloat, y: CGFloat
        let size: CGFloat
        let alpha: CGFloat
        let period: Double
        let delay: Double
    }

    /// The s1–s4 layers from styles.css, transcribed.
    static let stars: [Star] = {
        var out: [Star] = []
        var id = 0
        func add(_ pts: [(CGFloat, CGFloat, CGFloat)], size: CGFloat, period: Double, delay: Double)
        {
            for (x, y, a) in pts {
                out.append(
                    Star(id: id, x: x, y: y, size: size, alpha: a, period: period, delay: delay))
                id += 1
            }
        }
        add(
            [
                (38, 74, 0.9), (142, 96, 0.8), (232, 108, 0.85), (334, 118, 0.75), (64, 148, 0.6),
                (300, 152, 0.7),
            ], size: 1.7, period: 4.2, delay: 0)
        add(
            [
                (96, 42, 0.62), (188, 54, 0.5), (286, 66, 0.58), (372, 82, 0.46), (20, 112, 0.5),
                (168, 130, 0.42), (256, 208, 0.4), (352, 176, 0.5),
            ], size: 1.7, period: 6.6, delay: 1.8)
        add(
            [
                (58, 34, 0.4), (124, 62, 0.32), (212, 30, 0.36), (268, 128, 0.3), (318, 44, 0.34),
                (84, 106, 0.28), (148, 168, 0.26), (228, 172, 0.24), (382, 138, 0.3),
                (12, 62, 0.26), (200, 88, 0.22), (356, 96, 0.28),
            ], size: 1.2, period: 3.1, delay: 0.9)
        add(
            [
                (44, 196, 0.3), (110, 232, 0.24), (182, 210, 0.2), (290, 238, 0.26),
                (346, 216, 0.22), (16, 168, 0.24),
            ], size: 1.4, period: 5.4, delay: 3.4)
        return out
    }()

    /// `.au-sky` is a `top:0;height:62%` box; the star offsets are raw px
    /// inside it (box-shadow offsets), and it carries its own fade mask
    /// (`#000 0, #000 52%, transparent 92%`).
    var fadeStart: CGFloat = 0.52
    var fadeEnd: CGFloat = 0.92

    var body: some View {
        GeometryReader { geo in
            let sx = geo.size.width / 402
            let sy = geo.size.height / 874
            ZStack(alignment: .topLeading) {
                Color.clear
                ForEach(Self.stars) { star in
                    Twinkle(
                        size: star.size, alpha: star.alpha, period: star.period, delay: star.delay
                    )
                    .position(x: star.x * sx, y: star.y * sy)
                }
            }
            .frame(height: geo.size.height * 0.62, alignment: .top)
            .mask(
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black, location: fadeStart),
                        .init(color: .clear, location: fadeEnd),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private struct Twinkle: View {
        let size: CGFloat, alpha: CGFloat, period: Double, delay: Double
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var bright = false

        var body: some View {
            Circle()
                .fill(Color(red: 1, green: 0.973, blue: 0.933))  // #fff8ee
                .frame(width: size, height: size)
                .opacity(reduceMotion ? 0.7 : (bright ? 1.0 : 0.22))
                .onAppear {
                    guard !reduceMotion else { return }
                    withAnimation(
                        .easeInOut(duration: period / 2).repeatForever(autoreverses: true).delay(
                            delay)
                    ) {
                        bright = true
                    }
                }
        }
    }
}

/// A drifting glint sparkle (lines 129–132).
struct AUGlint: View {
    var size: CGFloat = 13
    var delay: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var on = false

    var body: some View {
        AUIcon(kind: .sparkle, size: size, color: Color(red: 1, green: 0.973, blue: 0.933))
            .opacity(reduceMotion ? 0.9 : (on ? 0.9 : 0))
            .scaleEffect(reduceMotion ? 1 : (on ? 1 : 0.5))
            .rotationEffect(.degrees(on ? 12 : 0))
            .onAppear {
                guard !reduceMotion else { return }
                withAnimation(
                    .easeInOut(duration: 3.15).repeatForever(autoreverses: false).delay(delay)
                ) {
                    on = true
                }
            }
            .allowsHitTesting(false)
    }
}

// MARK: Dusk scenes

/// CSS `radial-gradient(<rx> <ry> at <cx> <cy>, …)` — an *elliptical* wash.
/// SwiftUI's `RadialGradient` is circular, so the circle is drawn at the
/// vertical radius and stretched horizontally, exactly as the ellipse does.
struct EllipseWash: View {
    let stops: [Gradient.Stop]
    let center: UnitPoint
    /// Full radii (not diameters) in points.
    let radii: CGSize

    var body: some View {
        GeometryReader { geo in
            let ry = max(radii.height, 1)
            RadialGradient(stops: stops, center: .center, startRadius: 0, endRadius: ry)
                .frame(width: ry * 2, height: ry * 2)
                .scaleEffect(x: max(radii.width, 1) / ry, y: 1)
                .position(x: center.x * geo.size.width, y: center.y * geo.size.height)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// The welcome dusk backdrop (Aurel.dc.html ~line 127): night→amber sky,
/// stars, glints, rising sun + haze, three SVG dunes (viewBox 402×230),
/// grain, and a light type scrim. Theme-independent — always dusk.
struct WelcomeDusk: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            // `<svg … style="bottom:0;width:100%;height:33%">` over viewBox 402×230
            // with preserveAspectRatio="none" — stretched, bottom-pinned.
            let duneH = max(1, h * 0.33)

            ZStack {
                // 1. Sky — authored stops, top → bottom.
                LinearGradient(stops: duskStops, startPoint: .top, endPoint: .bottom)

                // 2. `.au-sky` star field (carries its own 62%-box fade).
                AUStars()

                // 3. `.au-glint` sparkles — authored left/top, top-left anchored.
                AUGlint(size: 13).position(x: (72 + 6.5) / 402 * w, y: (116 + 6.5) / 874 * h)
                AUGlint(size: 10, delay: 2.6).position(
                    x: (266 + 5) / 402 * w, y: (58 + 5) / 874 * h)
                AUGlint(size: 11, delay: 4.9).position(
                    x: (344 + 5.5) / 402 * w, y: (168 + 5.5) / 874 * h)
                AUGlint(size: 9, delay: 6.1).position(
                    x: (160 + 4.5) / 402 * w, y: (198 + 4.5) / 874 * h)

                // 4. `.au-sun` — 132px disc, `left:31%` with `margin-left:-66px`
                // (so 31% is its centre) and `top:56%` (its top edge).
                Circle()
                    .fill(sunGradient)
                    .frame(width: 132, height: 132)
                    .blur(radius: 0.4)
                    .position(x: 0.31 * w, y: 0.56 * h + 66)
                    .modifier(SunRise())

                // 5. Horizon wash — radial-gradient(122% 38% at 31% 70%).
                EllipseWash(
                    stops: [
                        .init(color: Color(UIColor(hex: 0xf0a877)).opacity(0.5), location: 0),
                        .init(color: Color(UIColor(hex: 0xc67139)).opacity(0.2), location: 0.42),
                        .init(color: .clear, location: 0.72),
                    ],
                    center: UnitPoint(x: 0.31, y: 0.70),
                    radii: CGSize(width: w * 1.22, height: h * 0.38)
                )

                // 6. Dunes — design SVG viewBox 0 0 402 230, bottom-pinned.
                WelcomeDuneField()
                    .frame(width: w, height: duneH)
                    .frame(maxHeight: .infinity, alignment: .bottom)

                GrainOverlay()

                // 7. Type scrim — the authored bottom vignette, verbatim.
                LinearGradient(
                    stops: [
                        .init(color: scrimInk.opacity(0.44), location: 0),
                        .init(color: scrimInk.opacity(0.03), location: 0.22),
                        .init(color: scrimInk.opacity(0.30), location: 0.54),
                        .init(color: scrimInk.opacity(0.80), location: 0.80),
                        .init(color: scrimInk.opacity(0.95), location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            }
            .frame(width: w, height: h)
            .clipped()
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    /// rgba(16,13,12,…) — the authored vignette ink.
    private var scrimInk: Color { Color(UIColor(hex: 0x100d0c)) }

    private var duskStops: [Gradient.Stop] {
        [
            .init(color: Color(UIColor(hex: 0x13111a)), location: 0),
            .init(color: Color(UIColor(hex: 0x1a1620)), location: 0.22),
            .init(color: Color(UIColor(hex: 0x271e26)), location: 0.40),
            .init(color: Color(UIColor(hex: 0x3a2622)), location: 0.54),
            .init(color: Color(UIColor(hex: 0x5c351f)), location: 0.63),
            .init(color: Color(UIColor(hex: 0x94512a)), location: 0.71),
            .init(color: Color(UIColor(hex: 0xc67139)), location: 0.79),
            .init(color: Color(UIColor(hex: 0x8d4b22)), location: 0.92),
            .init(color: Color(UIColor(hex: 0x4d2915)), location: 1),
        ]
    }

    /// `radial-gradient(circle at 50% 42%, …)` on the 132px disc. CSS sizes an
    /// unkeyworded radial gradient to the *farthest corner*, which from
    /// (66, 55.4) in a 132×132 box is 101.1 — not the 66 radius of the disc.
    private var sunGradient: RadialGradient {
        RadialGradient(
            stops: [
                .init(color: Color(UIColor(hex: 0xffd9a6)), location: 0),
                .init(color: Color(UIColor(hex: 0xf0a877)), location: 0.34),
                .init(color: Color(UIColor(hex: 0xd97f3f)), location: 0.62),
                .init(color: Color(UIColor(hex: 0xc67139)).opacity(0.1), location: 0.78),
                .init(color: .clear, location: 0.82),
            ],
            center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 101.1
        )
    }

    struct SunRise: ViewModifier {
        @Environment(\.accessibilityReduceMotion) private var reduceMotion
        @State private var risen = false
        func body(content: Content) -> some View {
            content
                .offset(y: reduceMotion ? 0 : (risen ? 0 : 26))
                .onAppear {
                    guard !reduceMotion else { return }
                    withAnimation(.timingCurve(0.16, 0.84, 0.3, 1, duration: 1.25).delay(0.32)) {
                        risen = true
                    }
                }
        }
    }
}

/// Welcome dunes — three closed fills + two warm ridge strokes, authored as
/// the design SVG (`viewBox="0 0 402 230"`, paths end `V230 H0Z`).
struct WelcomeDuneField: View {
    var body: some View {
        ZStack {
            // Back ridge (lightest fill + bright rim).
            DuneSilhouette(
                ridge: "M0 84 Q58 46 124 68 Q192 92 258 54 Q330 34 402 70",
                fill: Color(UIColor(hex: 0x4a3220)),
                rim: Color(UIColor(hex: 0xf0a877)).opacity(0.42),
                rimWidth: 1.2
            )
            // Mid ridge.
            DuneSilhouette(
                ridge: "M0 126 Q76 84 152 112 Q224 140 292 100 Q350 76 402 118",
                fill: Color(UIColor(hex: 0x2c1e15)),
                rim: Color(UIColor(hex: 0xe2925a)).opacity(0.2),
                rimWidth: 1.0
            )
            // Foreground (deepest, no rim).
            DuneSilhouette(
                ridge: "M0 172 Q90 136 174 160 Q246 180 316 148 Q360 130 402 166",
                fill: Color(UIColor(hex: 0x15100d)),
                rim: .clear,
                rimWidth: 0
            )
        }
        .drawingGroup()  // flatten for clean anti-aliased ridges
    }
}

/// One dune: closed fill from ridge → bottom of the 402×230 design box,
/// optionally stroked along the ridge only. Coordinates are mapped into
/// the live rect inside `path(in:)` (no scaleEffect).
struct DuneSilhouette: View {
    let ridge: String
    let fill: Color
    let rim: Color
    let rimWidth: CGFloat
    /// The authored `viewBox` (welcome 402×230, plan 402×180).
    var box: CGSize = CGSize(width: 402, height: 230)

    var body: some View {
        ZStack {
            DuneFillShape(ridge: ridge, box: box).fill(fill)
            if rimWidth > 0 {
                DuneRidgeShape(ridge: ridge, box: box)
                    .stroke(
                        rim,
                        style: StrokeStyle(lineWidth: rimWidth, lineCap: .round, lineJoin: .round)
                    )
            }
        }
    }
}

/// Back-compat alias used by any remaining call sites.
typealias DuneLayer = DuneSilhouetteCompat
struct DuneSilhouetteCompat: View {
    let fill: Color
    let rim: Color
    let rimWidth: CGFloat
    let path: String
    var body: some View {
        DuneSilhouette(ridge: path, fill: fill, rim: rim, rimWidth: rimWidth)
    }
}

/// Ridge curve only (design units 402×230 → live rect).
private struct DuneRidgeShape: Shape {
    let ridge: String
    let box: CGSize

    func path(in rect: CGRect) -> Path {
        designPath(ridge, in: rect, box: box, closeToBottom: false)
    }
}

/// Ridge closed with `V230 H0 Z` (design SVG), then stretched into `rect`.
private struct DuneFillShape: Shape {
    let ridge: String
    let box: CGSize

    func path(in rect: CGRect) -> Path {
        designPath(ridge, in: rect, box: box, closeToBottom: true)
    }
}

/// Parse a design-space ridge (`M…Q…`) and map it into `rect`.
/// When `closeToBottom`, append the design close `→ (402,230) → (0,230) Z`.
private func designPath(_ ridge: String, in rect: CGRect, box: CGSize, closeToBottom: Bool)
    -> Path
{
    let design = CGRect(origin: .zero, size: box)
    var base = SVGPathShape(d: ridge, viewBox: box).path(in: design)
    if closeToBottom {
        base.addLine(to: CGPoint(x: box.width, y: box.height))
        base.addLine(to: CGPoint(x: 0, y: box.height))
        base.closeSubpath()
    }
    let sx = max(rect.width, 1) / box.width
    let sy = max(rect.height, 1) / box.height
    // Scale around origin, then shift into rect's origin.
    var tf = CGAffineTransform(scaleX: sx, y: sy)
    tf = tf.concatenating(CGAffineTransform(translationX: rect.minX, y: rect.minY))
    return base.applying(tf)
}

/// Plan-screen dusk (Aurel.dc.html ~line 379): deeper night, sage haze,
/// right-side sun, two dunes.
struct PlanDusk: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let duneH = max(1, h * 0.26)

            ZStack {
                LinearGradient(
                    stops: [
                        .init(color: Color(UIColor(hex: 0x15121a)), location: 0),
                        .init(color: Color(UIColor(hex: 0x1e1820)), location: 0.26),
                        .init(color: Color(UIColor(hex: 0x2d2126)), location: 0.46),
                        .init(color: Color(UIColor(hex: 0x452a1e)), location: 0.60),
                        .init(color: Color(UIColor(hex: 0x7c441f)), location: 0.71),
                        .init(color: Color(UIColor(hex: 0xb5642f)), location: 0.80),
                        .init(color: Color(UIColor(hex: 0xc67139)), location: 0.88),
                        .init(color: Color(UIColor(hex: 0x7a421e)), location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )

                // (The authored `.au-stars` class has no CSS in the design
                // system, so the plan sky renders without a star field.)

                // Sage haze — left:-10% top:12% 80%×30%, radial closest-side.
                Ellipse()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(
                                    color: Color(UIColor(hex: 0x7a8a5e)).opacity(0.7), location: 0),
                                .init(color: .clear, location: 0.72),
                            ],
                            center: .center, startRadius: 0, endRadius: w * 0.4)
                    )
                    .frame(width: w * 0.8, height: h * 0.3)
                    .position(x: w * 0.30, y: h * 0.27)
                    .blur(radius: 48)
                    .opacity(0.34)

                // `.au-sun` — 120px disc, `left:70%` (centre) / `top:52%` (top).
                Circle()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(color: Color(UIColor(hex: 0xffd9a6)), location: 0),
                                .init(color: Color(UIColor(hex: 0xf0a877)), location: 0.34),
                                .init(color: Color(UIColor(hex: 0xd97f3f)), location: 0.62),
                                .init(
                                    color: Color(UIColor(hex: 0xc67139)).opacity(0.1),
                                    location: 0.78),
                                .init(color: .clear, location: 0.82),
                            ],
                            // farthest-corner from (60, 50.4) in a 120×120 box
                            center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 91.9
                        )
                    )
                    .frame(width: 120, height: 120)
                    .position(x: w * 0.70, y: h * 0.52 + 60)
                    .modifier(WelcomeDusk.SunRise())

                // Two plan dunes — `viewBox="0 0 402 180"`, no ridge strokes.
                ZStack {
                    DuneSilhouette(
                        ridge: "M0 70 Q84 34 166 58 Q242 80 310 46 Q358 28 402 56",
                        fill: Color(UIColor(hex: 0x3a2718)),
                        rim: .clear,
                        rimWidth: 0,
                        box: CGSize(width: 402, height: 180)
                    )
                    DuneSilhouette(
                        ridge: "M0 112 Q94 80 182 102 Q256 120 324 94 Q366 78 402 102",
                        fill: Color(UIColor(hex: 0x1b1410)),
                        rim: .clear,
                        rimWidth: 0,
                        box: CGSize(width: 402, height: 180)
                    )
                }
                .frame(width: w, height: duneH)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .drawingGroup()

                GrainOverlay()

                LinearGradient(
                    stops: [
                        .init(color: planScrim.opacity(0.50), location: 0),
                        .init(color: planScrim.opacity(0.10), location: 0.26),
                        .init(color: planScrim.opacity(0.42), location: 0.60),
                        .init(color: planScrim.opacity(0.88), location: 0.88),
                        .init(color: planScrim.opacity(0.96), location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    /// rgba(16,13,12,…)
    private var planScrim: Color { Color(UIColor(hex: 0x100d0c)) }
}

// MARK: Step header (onboarding, lines 184–190)

/// A compact, non-wrapping position label for rails and paged content.
///
/// Progress rails are deliberately flexible; without an intrinsic, high-priority
/// counter they can squeeze the number into a one-character-wide column on
/// smaller phones. Keeping the count in a subtle badge makes both digits and
/// their relationship readable in every place the pattern appears.
struct AUProgressCounter: View {
    let current: Int
    let total: Int

    var body: some View {
        Text("\(current) / \(total)")
            .font(.figtree(.semibold, size: 11.5))
            .monospacedDigit()
            .foregroundStyle(Color.auTextSecondary)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .frame(minWidth: 46)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Capsule().fill(Color.auFill))
            .overlay(Capsule().strokeBorder(Color.auEdge, lineWidth: 1))
            .layoutPriority(2)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Item \(current) of \(total)")
    }
}

struct StepHeader: View {
    let step: Int  // 1-based
    let total: Int
    let back: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: back) {
                AUIcon(kind: .back, size: 17)
                    .frame(width: 44, height: 44)
                    .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
            }
            .buttonStyle(.auTap)
            .accessibilityLabel("Back")

            HStack(spacing: 10) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.auDivider)
                        Capsule()
                            .fill(Color.auAccent)
                            .frame(width: geo.size.width * CGFloat(step) / CGFloat(total))
                            .animation(.easeInOut(duration: 0.42), value: step)
                    }
                }
                .frame(height: 4)

                AUProgressCounter(current: step, total: total)
            }
            // The meter + count read as one AX element; the Back button above
            // is deliberately OUTSIDE this group so VoiceOver can reach it
            // (craft overhaul, DEFECT C1).
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Step \(step) of \(total)")
        }
    }
}

// MARK: Tab bar (lines 1550–1557)

/// The floating glass tab bar: Learn · Practice · Progress · You.
struct AUTabBar: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let current: AppRouter.Screen

    private var selectedIndex: Int {
        switch AppRouter.topLevelSection(for: current) {
        case .learn: 0
        case .practice: 1
        case .progress: 2
        case .you: 3
        case nil: 0
        }
    }

    var body: some View {
        GeometryReader { geo in
            let innerWidth = geo.size.width - 14
            let tabWidth = innerWidth / 4

            ZStack(alignment: .leading) {
                // Sliding accent indicator (.au-tab-ind)
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.auPrimaryButtonFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(Color.auPrimaryButtonBorder.opacity(0.72), lineWidth: 1.2)
                    )
                    .frame(width: tabWidth, height: geo.size.height - 14)
                    .offset(x: 7 + CGFloat(selectedIndex) * tabWidth, y: 0)
                    .animation(
                        AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion),
                        value: selectedIndex
                    )

                HStack(spacing: 0) {
                    tab(.home, icon: .learn, label: "Learn", width: tabWidth)
                    tab(.stories, icon: .practice, label: "Practice", width: tabWidth)
                    tab(.progress, icon: .progressBar, label: "Progress", width: tabWidth)
                    tab(.settings, icon: .gear, label: "Settings", width: tabWidth)
                }
                .padding(7)
            }
        }
        .frame(height: 62)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground).opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.14), radius: 18, x: 0, y: 8)
    }

    private enum TabIcon {
        case learn, practice, progressBar, gear
    }

    private func tab(_ screen: AppRouter.Screen, icon: TabIcon, label: String, width: CGFloat)
        -> some View
    {
        let targetSection = AppRouter.topLevelSection(for: screen)
        let on = targetSection == AppRouter.topLevelSection(for: current)
        let tint: Color = on ? Color.white : Color.auText.opacity(0.62)
        return Button {
            AUFeedback.selection()
            withAnimation(AUMotion.animation(AUMotion.flow, reduceMotion: reduceMotion)) {
                env.router.nav(screen)
            }
        } label: {
            VStack(spacing: 4) {
                tabIcon(icon, tint: tint)
                    .frame(width: 21, height: 21)
                    .scaleEffect(on ? 1.08 : 1.0)
                    .offset(y: on ? -1 : 0)
                    .opacity(on ? 1.0 : 0.90)
                    .animation(
                        AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                        value: on
                    )
                Text(label.auLocalized)
                    .font(.figtree(.bold, size: 10))
                    .tracking(0.1)
                    .foregroundStyle(tint)
                    .opacity(on ? 1.0 : 0.72)
            }
            .frame(width: width, height: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label.auLocalized)
        .accessibilityHint(targetSection?.purpose.auLocalized ?? "")
        .accessibilityAddTraits(on ? .isSelected : [])
        .accessibilityIdentifier("au.tab.\(label.auSlug)")
    }

    @ViewBuilder
    private func tabIcon(_ icon: TabIcon, tint: Color) -> some View {
        // 2.6 viewBox units on a 24-unit box drawn at 21 pt.
        let stroke = StrokeStyle(lineWidth: 2.6 * 21 / 24, lineCap: .round, lineJoin: .round)
        switch icon {
        case .learn:
            SVGPathShape(d: "M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z")
                .stroke(tint, style: stroke)
        case .practice:
            // Two sub-paths of one 24×24 icon — not a stack of two icons.
            SVGPathShape(d: "M12 3 3 8l9 5 9-5zM3 14l9 5 9-5")
                .stroke(tint, style: stroke)
        case .progressBar:
            SVGPathShape(d: "M4 19V11M10 19V5M16 19v-6M22 19H2")
                .stroke(tint, style: stroke)
        case .gear:
            // The design system's settings glyph (AUIcon .gear) as one
            // stroke path: hub circle + ray ticks.
            SVGPathShape(
                d: AUIcon.circle(cx: 12, cy: 12, r: 3.2)
                    + "M12 3v2.4M12 18.6V21M4.2 7.5l2 1.2M17.8 15.3l2 1.2M4.2 16.5l2-1.2M17.8 8.7l2-1.2"
            )
            .stroke(tint, style: stroke)
        }
    }
}

// MARK: Offline banner (lines 453–457)

struct OfflineBanner: View {
    var body: some View {
        HStack(spacing: 11) {
            AUIcon(kind: .offline, size: 16, color: .auText.opacity(0.6))
            Text("Working offline — today's lesson is already here.")
                .font(.figtree(.regular, size: 12.5))
                .auLine(12.5, 1.4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.auFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .auLift()
        .accessibilityElement(children: .combine)
    }
}

// MARK: Selectable row (the selTint pattern)

/// A card row that tints when selected (goals, levels, commit options).
struct SelectableRow<Leading: View, Content: View>: View {
    var selected: Bool
    /// UI-test identifier (e.g. `au.goal.work`).
    var aid: String? = nil
    /// The authored block padding (goal/commit 16, placement 15).
    var vPad: CGFloat = 16
    /// Disables the tap without changing the resting look (placement A2–B2).
    var inert: Bool = false
    @ViewBuilder var leading: () -> Leading
    @ViewBuilder var content: () -> Content
    var action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: {
            AUFeedback.selection()
            action()
        }) {
            HStack(spacing: 14) {
                leading()
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            // `box-sizing:border-box` + `border:1px` — the authored 18/vPad
            // padding sits *inside* the hairline, so the box is 2 pt taller
            // and wider than the padding alone.
            .padding(.horizontal, 19)
            .padding(.vertical, vPad + 1)
            .background(rowBackground)
            // Craft overhaul O4/O5: selection state settles with the quick
            // spring instead of a hard cut (opacity-only under Reduce Motion).
            .scaleEffect(selected ? 1.01 : 1.0)
            .animation(
                AUMotion.animation(AUMotion.quick, reduceMotion: reduceMotion),
                value: selected
            )
        }
        .disabled(inert)
        .buttonStyle(.auTap)
        .accessibilityAddTraits(selected ? .isSelected : [])
        .accessibilityIdentifier(aid ?? "au.row")
    }

    @ViewBuilder
    private var rowBackground: some View {
        AUSelectSurface(selected: selected, radius: 24)
    }
}

/// The authored "picked" surface shared by the goal / level / commit rows and
/// the reminder chips: a 158° accent-tinted wash inside an accent hairline
/// when selected, the plain `.au-card` otherwise.
struct AUSelectSurface: View {
    let selected: Bool
    var radius: CGFloat = 24

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        if selected {
            ZStack {
                shape.fill(
                    AUGradients.angled(
                        158,
                        stops: [
                            .init(
                                color: Color.auSurface.mixed(with: 0.18, of: Color.auAccent),
                                location: 0),
                            .init(
                                color: Color.auSurface.mixed(with: 0.08, of: Color.auAccent),
                                location: 1),
                        ])
                )
                // inset 0 0 0 1px accent/.2, then the 1px accent/.58 border
                shape.strokeBorder(Color.auAccent.opacity(0.2), lineWidth: 1)
                shape.strokeBorder(Color.auAccent.opacity(0.58), lineWidth: 1)
            }
            // 0 6px 16px -12px accent/.85 — the -12 spread keeps it a whisper.
            .shadow(color: Color.auAccent.opacity(0.32), radius: 3, y: 5)
        } else {
            ZStack {
                shape.fill(Color.auFill)
                shape.strokeBorder(Color.auEdge, lineWidth: 1)
            }
            .auLift()
        }
    }
}

// MARK: - LadderSheet (CEFR Curriculum Ladder Modal Sheet)

struct LadderSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("The CEFR Ladder")
                        .font(.caprasimo(size: 26))
                        .foregroundStyle(Color.auText)
                        .padding(.top, 12)

                    Text(
                        "Aurel takes you from zero to confident Foundation English (A1), with progressive chapters written for adult learners."
                    )
                    .font(.figtree(.regular, size: 14))
                    .auLine(14, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.6))
                    .padding(.bottom, 8)

                    VStack(spacing: 0) {
                        ladderRow(
                            level: "A1", title: "Foundation · 4 chapters", status: "Available",
                            isActive: true)
                        ladderRow(
                            level: "A2", title: "Elementary", status: "Unavailable", isActive: false
                        )
                        ladderRow(
                            level: "B1", title: "Intermediate", status: "Unavailable",
                            isActive: false)
                        ladderRow(
                            level: "B2", title: "Upper Intermediate", status: "Unavailable",
                            isActive: false)
                        ladderRow(
                            level: "C1", title: "Advanced Mastery", status: "Unavailable",
                            isActive: false, divider: false)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .auLift()
                }
                .padding(24)
            }
            .background(Color.auBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.figtree(.semibold, size: 15))
                        .foregroundStyle(Color.auAccentText)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func ladderRow(
        level: String, title: String, status: String, isActive: Bool, divider: Bool = true
    ) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Text(level)
                    .font(.caprasimo(size: 19))
                    .frame(width: 38, alignment: .leading)
                    .foregroundStyle(isActive ? Color.auAccent : Color.auText.opacity(0.35))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title.auLocalized)
                        .font(.figtree(.semibold, size: 14.5))
                        .foregroundStyle(Color.auText)
                    Text(status.auLocalized)
                        .font(.figtree(.regular, size: 12))
                        .foregroundStyle(isActive ? Color.auAccentText : Color.auText.opacity(0.45))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if isActive {
                    Text("Here")
                        .font(.figtree(.bold, size: 11))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.auAccent))
                        .foregroundStyle(Color.auBackground)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)

            if divider {
                Divider().overlay(Color.auDivider)
            }
        }
    }
}

// MARK: - ForgotPasswordSheet (Password Recovery Modal)

struct ForgotPasswordSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var sent: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                if !sent {
                    Text("Reset your password")
                        .font(.caprasimo(size: 24))
                        .foregroundStyle(Color.auText)
                        .padding(.top, 8)

                    Text(
                        "Enter the email associated with your Aurel account and we'll send you a password reset link."
                    )
                    .font(.figtree(.regular, size: 14))
                    .auLine(14, 1.5)
                    .foregroundStyle(Color.auText.opacity(0.6))

                    TextField("you@example.com", text: $email)
                        .font(.figtree(.medium, size: 15))
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding(.horizontal, 18)
                        .frame(minHeight: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous).fill(
                                Color.auFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(
                                Color.auEdge, lineWidth: 1)
                        )
                        .padding(.top, 4)

                    Spacer()

                    APillButton(
                        title: "Send reset link",
                        disabled: email.trimmingCharacters(in: .whitespaces).isEmpty
                    ) {
                        AUFeedback.correct()
                        withAnimation { sent = true }
                    }
                } else {
                    VStack(spacing: 14) {
                        Spacer()
                        Circle()
                            .fill(Color.auOkBg)
                            .frame(width: 64, height: 64)
                            .overlay {
                                AUIcon(kind: .check, size: 24, color: .auOkText)
                            }
                            .scaleEffect(sent ? 1.0 : 0.4)
                            .animation(.spring(response: 0.38, dampingFraction: 0.65), value: sent)

                        Text("Reset link sent")
                            .font(.caprasimo(size: 22))

                        Text(
                            "Check your inbox for instructions to reset your password. It may take a minute to arrive."
                        )
                        .font(.figtree(.regular, size: 14))
                        .auLine(14, 1.5)
                        .foregroundStyle(Color.auText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)

                        Spacer()

                        APillButton(title: "Back to sign in") {
                            dismiss()
                        }
                    }
                }
            }
            .padding(24)
            .background(Color.auBackground.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .font(.figtree(.semibold, size: 15))
                        .foregroundStyle(Color.auText.opacity(0.6))
                }
            }
        }
        .presentationDetents([.fraction(0.48), .large])
    }
}
