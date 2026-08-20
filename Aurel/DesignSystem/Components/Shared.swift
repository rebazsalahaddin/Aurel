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

    var body: some View {
        ZStack {
            SVGPathShape(
                d:
                    "M32.7 4.9 C35.0 14.6 45.8 39.8 58.6 56.4 L50.2 56.4 C41.4 41.2 34.4 20.6 32.2 11.6 C31.0 17.6 22.8 41.2 15.0 56.4 L10.2 56.4 C18.4 40.4 30.4 14.4 32.7 4.9 Z"
            )
            // #f7efe2
            .fill(mono ? Color.auText : Color(red: 0.969, green: 0.937, blue: 0.886))
            SVGPathShape(d: "M24.2 43.4 A8 8 0 0 1 40.2 43.4 Z")
                // #e2925a
                .fill(mono ? Color.auAccent : Color(red: 0.886, green: 0.573, blue: 0.353))
            SVGPathShape(
                d: "M18.6 46.8 C26.6 43.4 37 42.2 45.4 42.6 C37 45.4 26.6 47.2 18.6 46.8 Z"
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
                .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886))
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.34 * 247.0 / 255), Color.white.opacity(0.05),
                        ], startPoint: .leading, endPoint: .trailing)
                )
                .frame(height: 1)
            Text("A1 · Foundation")
                .font(.figtree(.semibold, size: 10))
                .tracking(2)
                .textCase(.uppercase)
                .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.58))
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

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(Self.stars) { star in
                    Twinkle(
                        size: star.size, alpha: star.alpha, period: star.period, delay: star.delay
                    )
                    .position(
                        x: star.x / 402 * geo.size.width,
                        y: star.y / 874 * geo.size.height * 0.62  // .au-sky occupies the top 62%
                    )
                }
            }
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

/// The welcome dusk backdrop (line 127): night-to-amber gradient, stars,
/// glints, sun glow, three dune layers with rim light, grain, and the
/// darkening scrim. Theme-independent — the scene is always dusk.
struct WelcomeDusk: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    stops: duskStops,
                    startPoint: .top, endPoint: .bottom
                )

                AUStars()
                    .mask(
                        LinearGradient(
                            stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.52),
                                .init(color: .clear, location: 0.92),
                            ],
                            startPoint: .top, endPoint: .bottom
                        )
                    )

                AUGlint(size: 13).position(
                    x: 72 / 402 * geo.size.width, y: 116 / 874 * geo.size.height)
                AUGlint(size: 10, delay: 2.6).position(
                    x: 266 / 402 * geo.size.width, y: 58 / 874 * geo.size.height)
                AUGlint(size: 11, delay: 4.9).position(
                    x: 344 / 402 * geo.size.width, y: 168 / 874 * geo.size.height)
                AUGlint(size: 9, delay: 6.1).position(
                    x: 160 / 402 * geo.size.width, y: 198 / 874 * geo.size.height)

                // Sun
                Circle()
                    .fill(sunGradient)
                    .frame(width: 132, height: 132)
                    .position(x: 0.31 * geo.size.width, y: 0.56 * geo.size.height)
                    .modifier(SunRise())

                // Sun haze
                RadialGradient(
                    stops: [
                        .init(
                            color: Color(red: 0.941, green: 0.659, blue: 0.467).opacity(0.5),
                            location: 0),
                        .init(
                            color: Color(red: 0.776, green: 0.443, blue: 0.224).opacity(0.2),
                            location: 0.42),
                        .init(color: .clear, location: 0.72),
                    ],
                    center: UnitPoint(x: 0.31, y: 0.70), startRadius: 0,
                    endRadius: geo.size.width * 0.61
                )

                // Dunes (bottom third, stretched)
                GeometryReader { duneGeo in
                    ZStack(alignment: .bottom) {
                        DuneLayer(
                            fill: Color(UIColor(hex: 0x4a3220)),
                            rim: Color(UIColor(hex: 0xf0a877)).opacity(0.42), rimWidth: 1.2,
                            path: "M0 84 Q58 46 124 68 Q192 92 258 54 Q330 34 402 70")
                        DuneLayer(
                            fill: Color(UIColor(hex: 0x2c1e15)),
                            rim: Color(UIColor(hex: 0xe2925a)).opacity(0.2), rimWidth: 1,
                            path: "M0 126 Q76 84 152 112 Q224 140 292 100 Q350 76 402 118")
                        DuneLayer(
                            fill: Color(UIColor(hex: 0x15100d)), rim: .clear, rimWidth: 0,
                            path: "M0 172 Q90 136 174 160 Q246 180 316 148 Q360 130 402 166")
                    }
                    .frame(height: max(1, duneGeo.size.height * 0.33))
                }

                GrainOverlay()

                // Scrim
                LinearGradient(
                    stops: [
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.44),
                            location: 0),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.03),
                            location: 0.22),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.3),
                            location: 0.54),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.8),
                            location: 0.8),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.95),
                            location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

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

    private var sunGradient: RadialGradient {
        RadialGradient(
            stops: [
                .init(color: Color(UIColor(hex: 0xffd9a6)), location: 0),
                .init(color: Color(UIColor(hex: 0xf0a877)), location: 0.34),
                .init(color: Color(UIColor(hex: 0xd97f3f)), location: 0.62),
                .init(color: Color(UIColor(hex: 0xc67139)).opacity(0.1), location: 0.78),
                .init(color: .clear, location: 0.82),
            ],
            center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 66
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

/// One dune fill (+ optional rim stroke), authored in a 402×230 viewBox,
/// stretched to width with the bottom pinned.
struct DuneLayer: View {
    let fill: Color
    let rim: Color
    let rimWidth: CGFloat
    let path: String  // the authored top-edge path

    var body: some View {
        GeometryReader { geo in
            let scaleY = geo.size.height / 230
            ZStack(alignment: .top) {
                SVGPathShape(d: path)
                    .stroke(rim, style: StrokeStyle(lineWidth: rimWidth, lineCap: .round))
                    .scaleEffect(x: geo.size.width / 402, y: scaleY, anchor: .topLeading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .background(alignment: .top) {
                // Fill below the rim curve, to the bottom of the layer.
                GeometryReader { g in
                    DuneFillShape(curve: path)
                        .fill(fill)
                        .scaleEffect(
                            x: g.size.width / 402, y: g.size.height / 230, anchor: .topLeading)
                }
            }
        }
    }

    /// The rim curve closed down to the layer's bottom edge.
    private struct DuneFillShape: Shape {
        let curve: String

        func path(in rect: CGRect) -> Path {
            var p = SVGPathShape(d: curve).path(in: CGRect(x: 0, y: 0, width: 402, height: 230))
            p.addLine(to: CGPoint(x: 402, y: 230))
            p.addLine(to: CGPoint(x: 0, y: 230))
            p.closeSubpath()
            return p
        }
    }
}

/// The plan-screen dusk variant (line 379–389): deeper night, sage haze,
/// right-side sun, two dunes.
struct PlanDusk: View {
    var body: some View {
        GeometryReader { geo in
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

                AUStars()

                // Sage haze
                Ellipse()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color(red: 0.478, green: 0.541, blue: 0.369).opacity(0.7), .clear,
                            ], center: .center, startRadius: 0, endRadius: 300)
                    )
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.3)
                    .position(x: geo.size.width * 0.4, y: geo.size.height * 0.27)
                    .blur(radius: 48)
                    .opacity(0.34)

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
                            center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                    .position(x: geo.size.width * 0.70, y: geo.size.height * 0.52)
                    .modifier(WelcomeDusk.SunRise())

                GeometryReader { duneGeo in
                    ZStack(alignment: .bottom) {
                        DuneLayer(
                            fill: Color(UIColor(hex: 0x3a2718)), rim: .clear, rimWidth: 0,
                            path: "M0 70 Q84 34 166 58 Q242 80 310 46 Q358 28 402 56")
                        DuneLayer(
                            fill: Color(UIColor(hex: 0x1b1410)), rim: .clear, rimWidth: 0,
                            path: "M0 112 Q94 80 182 102 Q256 120 324 94 Q366 78 402 102")
                    }
                    .frame(height: max(1, duneGeo.size.height * 0.26))
                }

                GrainOverlay()

                LinearGradient(
                    stops: [
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.5),
                            location: 0),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.1),
                            location: 0.26),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.42),
                            location: 0.6),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.88),
                            location: 0.88),
                        .init(
                            color: Color(red: 0.063, green: 0.051, blue: 0.047).opacity(0.96),
                            location: 1),
                    ],
                    startPoint: .top, endPoint: .bottom
                )
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

// MARK: Step header (onboarding, lines 184–190)

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

            Text("\(step) of \(total)")
                .font(.figtree(.regular, size: 11.5))
                .foregroundStyle(Color.auText.opacity(0.45))
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(step) of \(total)")
    }
}

// MARK: Tab bar (lines 1550–1557)

/// The floating glass tab bar: Learn · Practice · Progress · You.
struct AUTabBar: View {
    @Environment(AppEnvironment.self) private var env
    let current: AppRouter.Screen

    var body: some View {
        HStack(spacing: 3) {
            tab(.home, icon: .learn, label: "Learn")
            tab(.stories, icon: .practice, label: "Practice")
            tab(.progress, icon: .progressBar, label: "Progress")
            tab(.profile, icon: .person, label: "You")
        }
        .padding(7)
        .background(AUGradients.glass(), in: RoundedRectangle(cornerRadius: 27, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 27, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .overlay(alignment: .top) {
            Rectangle().fill(Color.auHi).frame(height: 1).padding(.horizontal, 10).allowsHitTesting(
                false)
        }
        .shadow(
            color: Color(red: 0.149, green: 0.094, blue: 0.055).opacity(0.72), radius: 22, y: 10)
    }

    private enum TabIcon {
        case learn, practice, progressBar, person
    }

    private func tab(_ screen: AppRouter.Screen, icon: TabIcon, label: String) -> some View {
        let on = screen == current
        let tint: Color = on ? .auAccentText : Color.auText.opacity(0.55)
        return Button {
            env.router.nav(screen)
        } label: {
            VStack(spacing: 2) {
                tabIcon(icon, tint: tint)
                    .frame(height: 21)
                Text(label)
                    .font(.figtree(.bold, size: 10))
                    .tracking(0.1)
                    .foregroundStyle(tint)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 7)
            .background {
                if on {
                    Capsule().fill(Color.auText.opacity(0.06))
                }
            }
        }
        .buttonStyle(.auTap)
        .accessibilityLabel(label)
        .accessibilityAddTraits(on ? .isSelected : [])
    }

    @ViewBuilder
    private func tabIcon(_ icon: TabIcon, tint: Color) -> some View {
        switch icon {
        case .learn:
            SVGPathShape(d: "M4 10.5 12 4l8 6.5V20a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1z").stroke(
                tint, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
        case .practice:
            VStack(spacing: 1) {
                SVGPathShape(d: "M12 3 3 8l9 5 9-5z").stroke(
                    tint, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
                SVGPathShape(d: "M3 14l9 5 9-5").stroke(
                    tint, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
            }
        case .progressBar:
            SVGPathShape(d: "M4 19V11M10 19V5M16 19v-6M22 19H2").stroke(
                tint, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
        case .person:
            SVGPathShape(d: AUIcon.circle(cx: 12, cy: 8, r: 4) + "M4.5 20a7.5 7.5 0 0 1 15 0")
                .stroke(tint, style: StrokeStyle(lineWidth: 2.6, lineCap: .round, lineJoin: .round))
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
                .lineSpacing(2)
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
    @ViewBuilder var leading: () -> Leading
    @ViewBuilder var content: () -> Content
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                leading()
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(rowBackground)
        }
        .buttonStyle(.auTap)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    @ViewBuilder
    private var rowBackground: some View {
        let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)
        if selected {
            ZStack {
                shape.fill(
                    LinearGradient(
                        stops: [
                            .init(
                                color: Color.auSurface.mixed(with: 0.18, of: Color.auAccent),
                                location: 0),
                            .init(
                                color: Color.auSurface.mixed(with: 0.08, of: Color.auAccent),
                                location: 1),
                        ],
                        startPoint: UnitPoint(x: 0.1, y: 0), endPoint: UnitPoint(x: 0.9, y: 1)
                    )
                )
                shape.strokeBorder(Color.auAccent.opacity(0.58), lineWidth: 1)
            }
            .shadow(color: Color.auAccent.opacity(0.35), radius: 8, y: 3)
        } else {
            ZStack {
                shape.fill(Color.auFill)
                shape.strokeBorder(Color.auEdge, lineWidth: 1)
            }
            .auLift()
        }
    }
}
