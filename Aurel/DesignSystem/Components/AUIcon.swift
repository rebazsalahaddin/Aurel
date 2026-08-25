import SwiftUI

// MARK: - SVG path mini-parser
//
// Renders the authored icon geometry verbatim: the `d` strings below are copied
// exactly from the design files' <symbol> definitions, so stroke weights and
// curves match the prototype. Supports M L H V C S Q T A Z (and lowercase),
// implicit command repetition, and the arc endpoint parameterization.

struct SVGPathShape: Shape {
    let d: String
    /// The authored `viewBox` the `d` string's coordinates live in. The icon set
    /// is drawn on 24×24, but the scene art (logo mark 64×64, dune fields
    /// 402×230, the home path canvas) is authored on its own box — passing the
    /// wrong one silently scales the geometry off-screen.
    var viewBox: CGSize = CGSize(width: 24, height: 24)

    private enum Token {
        case command(Character)
        case number(CGFloat)
    }

    private static let tokenPattern = try! NSRegularExpression(
        pattern: "([MLHVCSQTAZmlhvcsqtaz])|(-?\\d*\\.?\\d+(?:[eE][-+]?\\d+)?)")

    private static func lex(_ d: String) -> [Token] {
        var tokens: [Token] = []
        let range = NSRange(d.startIndex..., in: d)
        for m in tokenPattern.matches(in: d, range: range) {
            if let r = Range(m.range(at: 1), in: d), let c = String(d[r]).first {
                tokens.append(.command(c))
            } else if let r = Range(m.range(at: 2), in: d), let v = Double(d[r]) {
                tokens.append(.number(CGFloat(v)))
            }
        }
        return tokens
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var startX: CGFloat = 0
        var startY: CGFloat = 0
        let tokens = Self.lex(d)
        var i = 0
        var lastCmd: Character?
        // Smooth-curve state (SVG S/s reflect the previous C/S control point;
        // T/t reflect the previous Q/T control). Reset by any other command.
        var lastC2: CGPoint?
        var lastQ: CGPoint?

        func num() -> CGFloat {
            defer { i += 1 }
            guard i < tokens.count, case .number(let n) = tokens[i] else { return 0 }
            return n
        }

        while i < tokens.count {
            let cmd: Character
            if case .command(let c) = tokens[i] {
                cmd = c
                i += 1
            } else if let l = lastCmd {
                cmd = l
            } else {
                i += 1
                continue
            }
            lastCmd = cmd
            switch cmd {
            case "M", "m":
                let rel = cmd == "m"
                // Per the SVG spec, pairs after the first in an M sequence are
                // implicit LINETOs, not additional movetos.
                var first = true
                while i < tokens.count, case .number = tokens[i] {
                    let nx = rel ? x + num() : num()
                    let ny = rel ? y + num() : num()
                    if first {
                        startX = nx
                        startY = ny
                        path.move(to: CGPoint(x: nx, y: ny))
                        first = false
                    } else {
                        path.addLine(to: CGPoint(x: nx, y: ny))
                    }
                    x = nx
                    y = ny
                }
                lastC2 = nil
                lastQ = nil
            case "L":
                x = num()
                y = num()
                path.addLine(to: CGPoint(x: x, y: y))
                lastC2 = nil
                lastQ = nil
            case "l":
                x += num()
                y += num()
                path.addLine(to: CGPoint(x: x, y: y))
                lastC2 = nil
                lastQ = nil
            case "H":
                x = num()
                path.addLine(to: CGPoint(x: x, y: y))
                lastC2 = nil
                lastQ = nil
            case "h":
                x += num()
                path.addLine(to: CGPoint(x: x, y: y))
                lastC2 = nil
                lastQ = nil
            case "V":
                y = num()
                path.addLine(to: CGPoint(x: x, y: y))
                lastC2 = nil
                lastQ = nil
            case "v":
                y += num()
                path.addLine(to: CGPoint(x: x, y: y))
                lastC2 = nil
                lastQ = nil
            case "C":
                let c1 = CGPoint(x: num(), y: num())
                let c2 = CGPoint(x: num(), y: num())
                x = num()
                y = num()
                path.addCurve(to: CGPoint(x: x, y: y), control1: c1, control2: c2)
                lastC2 = c2
                lastQ = nil
            case "c":
                let c1 = CGPoint(x: x + num(), y: y + num())
                let c2 = CGPoint(x: x + num(), y: y + num())
                x += num()
                y += num()
                path.addCurve(to: CGPoint(x: x, y: y), control1: c1, control2: c2)
                lastC2 = c2
                lastQ = nil
            case "S", "s":
                let rel = cmd == "s"
                let c2 =
                    rel
                    ? CGPoint(x: x + num(), y: y + num()) : CGPoint(x: num(), y: num())
                let to =
                    rel
                    ? CGPoint(x: x + num(), y: y + num()) : CGPoint(x: num(), y: num())
                let here = CGPoint(x: x, y: y)
                let c1 = lastC2.map { CGPoint(x: 2 * here.x - $0.x, y: 2 * here.y - $0.y) } ?? here
                path.addCurve(to: to, control1: c1, control2: c2)
                x = to.x
                y = to.y
                lastC2 = c2
                lastQ = nil
            case "Q":
                let c = CGPoint(x: num(), y: num())
                x = num()
                y = num()
                path.addQuadCurve(to: CGPoint(x: x, y: y), control: c)
                lastQ = c
                lastC2 = nil
            case "q":
                let c = CGPoint(x: x + num(), y: y + num())
                x += num()
                y += num()
                path.addQuadCurve(to: CGPoint(x: x, y: y), control: c)
                lastQ = c
                lastC2 = nil
            case "T", "t":
                let rel = cmd == "t"
                let to =
                    rel
                    ? CGPoint(x: x + num(), y: y + num()) : CGPoint(x: num(), y: num())
                let here = CGPoint(x: x, y: y)
                let c = lastQ.map { CGPoint(x: 2 * here.x - $0.x, y: 2 * here.y - $0.y) } ?? here
                path.addQuadCurve(to: to, control: c)
                x = to.x
                y = to.y
                lastQ = c
                lastC2 = nil
            case "A":
                let rx = num()
                _ = num()
                _ = num()
                let largeArc = num()
                let sweep = num()
                let x2 = num()
                let y2 = num()
                addArc(
                    to: &path, from: CGPoint(x: x, y: y), to: CGPoint(x: x2, y: y2), radius: rx,
                    largeArc: largeArc > 0, sweep: sweep > 0)
                x = x2
                y = y2
                lastC2 = nil
                lastQ = nil
            case "a":
                let rx = num()
                _ = num()
                _ = num()
                let largeArc = num()
                let sweep = num()
                let dx = num()
                let dy = num()
                addArc(
                    to: &path, from: CGPoint(x: x, y: y), to: CGPoint(x: x + dx, y: y + dy),
                    radius: rx, largeArc: largeArc > 0, sweep: sweep > 0)
                x += dx
                y += dy
                lastC2 = nil
                lastQ = nil
            case "Z", "z":
                path.addLine(to: CGPoint(x: startX, y: startY))
                path.closeSubpath()
                lastC2 = nil
                lastQ = nil
            default:
                // Unknown command: skip the token so parsing always advances.
                i += 1
            }
        }
        // Scale the authored viewBox into the destination rect.
        let scaleX = rect.width / max(viewBox.width, 0.001)
        let scaleY = rect.height / max(viewBox.height, 0.001)
        let tf = CGAffineTransform(scaleX: scaleX, y: scaleY)
            .concatenating(CGAffineTransform(translationX: rect.minX, y: rect.minY))
        return path.applying(tf)
    }

    /// SVG elliptical arc (endpoint parameterization) → center parameterization.
    /// Only circular arcs appear in the icon set, which keeps this simple.
    private func addArc(
        to path: inout Path, from p1: CGPoint, to p2: CGPoint, radius r: CGFloat,
        largeArc: Bool, sweep: Bool
    ) {
        let mid = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
        let dx = p2.x - p1.x
        let dy = p2.y - p1.y
        let dist = max((dx * dx + dy * dy).squareRoot(), 0.001)
        let r = max(r, dist / 2)
        let h = max((r * r - (dist / 2) * (dist / 2)).squareRoot(), 0)
        // Endpoint → centre parameterization (SVG F.6.5): the perpendicular
        // offset is positive when the large-arc and sweep flags differ.
        let sign: CGFloat = (largeArc != sweep) ? 1 : -1
        let off = CGPoint(x: -dy / dist * h * sign, y: dx / dist * h * sign)
        let center = CGPoint(x: mid.x + off.x, y: mid.y + off.y)
        let startAngle = atan2(p1.y - center.y, p1.x - center.x)
        let endAngle = atan2(p2.y - center.y, p2.x - center.x)
        path.addArc(
            center: center, radius: r, startAngle: Angle(radians: Double(startAngle)),
            endAngle: Angle(radians: Double(endAngle)), clockwise: !sweep)
    }
}

// MARK: - The icon set

struct AUIcon: View {
    enum Kind {
        case ear, eye, tap, choose, match, mouth, loop
        case check, arrow, close, back
        case play, mic, link, lock
        case gear, offline, sparkle, flame, trophy
        case pencil, star, chevron, chevronDown
        case speech, reviewLoop, camera, alert, clock, warning
        case sun, moon
    }

    /// One authored sub-path: the `d` string plus whether it fills or strokes.
    let kind: Kind
    var size: CGFloat = 16
    var color: Color = .auText

    var body: some View {
        // Authored `stroke-width` is in viewBox units; SVG scales it with the
        // artwork, so a 2.6 stroke on a 24-unit box drawn at 17 pt renders at
        // 1.84 pt — not 2.6.
        ZStack {
            ForEach(Array(Self.subpaths(kind).enumerated()), id: \.offset) { _, sub in
                let box = CGSize(width: sub.box, height: sub.box)
                if sub.fill {
                    SVGPathShape(d: sub.d, viewBox: box).fill(color)
                } else {
                    SVGPathShape(d: sub.d, viewBox: box)
                        .stroke(
                            color,
                            style: StrokeStyle(
                                lineWidth: sub.strokeWidth * size / sub.box, lineCap: .round,
                                lineJoin: .round))
                }
            }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    // d strings are copied verbatim from the design files' <symbol> defs
    // (CourseScreen.dc.html lines 63–79, Aurel.dc.html lines 455/471/129).
    // Internal (not fileprivate) so the SVGPathShape regression tests can
    // sweep every authored path.
    struct Sub {
        let d: String
        let fill: Bool
        let strokeWidth: CGFloat
        /// The authored viewBox side (the icon set is 24; the glint sparkle
        /// is drawn on 14).
        var box: CGFloat = 24
    }

    static func subpaths(_ kind: Kind) -> [Sub] {
        switch kind {
        case .ear:
            return [
                Sub(
                    d:
                        "M6.5 9a5.5 5.5 0 0 1 11 0c0 2.2-1.4 3.2-2.4 4.3-.9 1-1.1 1.9-1.1 3a2.5 2.5 0 0 1-5 0",
                    fill: false, strokeWidth: 1.9),
                Sub(d: "M9.8 9.2a2.3 2.3 0 0 1 4.4.6", fill: false, strokeWidth: 1.9),
            ]
        case .eye:
            return [
                Sub(
                    d: "M2.5 12S6 5.8 12 5.8 21.5 12 21.5 12 18 18.2 12 18.2 2.5 12 2.5 12Z",
                    fill: false, strokeWidth: 1.9),
                Sub(d: circle(cx: 12, cy: 12, r: 2.9), fill: false, strokeWidth: 1.9),
            ]
        case .tap:
            return [
                Sub(d: "M9 11V5.5a1.8 1.8 0 0 1 3.6 0V13", fill: false, strokeWidth: 1.9),
                Sub(d: "M12.6 10.4a1.7 1.7 0 0 1 3.4 0v1.4", fill: false, strokeWidth: 1.9),
                Sub(
                    d:
                        "M16 11.4a1.7 1.7 0 0 1 3.4 0v3.4c0 3-2.2 5.4-5.4 5.4h-1.3c-2 0-3.2-.8-4.2-2.3L6 14.4a1.7 1.7 0 0 1 2.7-2l1.3 1.6",
                    fill: false, strokeWidth: 1.9),
            ]
        case .choose:
            return [
                Sub(d: rrect(x: 3, y: 4.5, w: 7, h: 7, r: 2), fill: false, strokeWidth: 1.9),
                Sub(d: rrect(x: 14, y: 4.5, w: 7, h: 7, r: 2), fill: false, strokeWidth: 1.9),
                Sub(d: "M6.5 15v4.5", fill: false, strokeWidth: 1.9),
                Sub(d: "M17.5 14.4l1.9 1.9-1.9 1.9-1.9-1.9Z", fill: false, strokeWidth: 1.9),
            ]
        case .match:
            return [
                Sub(
                    d: "M10 13.5a3.6 3.6 0 0 0 5.2.3l2.6-2.6a3.6 3.6 0 1 0-5.1-5.1L11.4 7.4",
                    fill: false, strokeWidth: 1.9),
                Sub(
                    d: "M14 10.5a3.6 3.6 0 0 0-5.2-.3l-2.6 2.6a3.6 3.6 0 1 0 5.1 5.1l1.3-1.3",
                    fill: false, strokeWidth: 1.9),
            ]
        case .mouth:
            return [
                Sub(
                    d:
                        "M4 12c2.6-3.2 5.3-4.8 8-4.8s5.4 1.6 8 4.8c-2.6 3.2-5.3 4.8-8 4.8S6.6 15.2 4 12Z",
                    fill: false, strokeWidth: 1.9),
                Sub(d: "M7.5 12h9", fill: false, strokeWidth: 1.9),
            ]
        case .loop:
            return [
                Sub(d: "M3.6 12a8.4 8.4 0 0 1 14.3-6", fill: false, strokeWidth: 1.9),
                Sub(d: "M20.4 12a8.4 8.4 0 0 1-14.3 6", fill: false, strokeWidth: 1.9),
                Sub(d: "M18.3 2.6V6h-3.4", fill: false, strokeWidth: 1.9),
                Sub(d: "M5.7 21.4V18h3.4", fill: false, strokeWidth: 1.9),
            ]
        case .check:
            return [
                Sub(d: "M4.5 12.5l5 5 10-11", fill: false, strokeWidth: 2.7)
            ]
        case .arrow:
            return [
                Sub(d: "M4 12h15", fill: false, strokeWidth: 2.5),
                Sub(d: "M13 6l6 6-6 6", fill: false, strokeWidth: 2.5),
            ]
        case .close:
            return [
                Sub(d: "M6 6l12 12M18 6 6 18", fill: false, strokeWidth: 2.5)
            ]
        case .back:
            return [
                Sub(d: "M15 5l-7 7 7 7", fill: false, strokeWidth: 2.5)
            ]
        case .play:
            return [
                Sub(d: "M8 5.4v13.2l10.5-6.6Z", fill: true, strokeWidth: 0)
            ]
        case .mic:
            return [
                Sub(d: rrect(x: 9, y: 2.6, w: 6, h: 11, r: 3), fill: false, strokeWidth: 1.9),
                Sub(d: "M5.5 11.5a6.5 6.5 0 0 0 13 0", fill: false, strokeWidth: 1.9),
                Sub(d: "M12 18v3.4", fill: false, strokeWidth: 1.9),
            ]
        case .link:
            return [
                Sub(d: "M9 12h6", fill: false, strokeWidth: 1.9),
                Sub(d: "M10 8H7.5a4 4 0 0 0 0 8H10", fill: false, strokeWidth: 1.9),
                Sub(d: "M14 8h2.5a4 4 0 0 1 0 8H14", fill: false, strokeWidth: 1.9),
            ]
        case .lock:
            return [
                Sub(d: rrect(x: 4.5, y: 10.5, w: 15, h: 10, r: 2.6), fill: false, strokeWidth: 1.9),
                Sub(d: "M8 10.5V7.6a4 4 0 0 1 8 0v2.9", fill: false, strokeWidth: 1.9),
            ]
        case .gear:
            return [
                Sub(d: circle(cx: 12, cy: 12, r: 3.2), fill: false, strokeWidth: 2.4),
                Sub(
                    d:
                        "M12 3v2.4M12 18.6V21M4.2 7.5l2 1.2M17.8 15.3l2 1.2M4.2 16.5l2-1.2M17.8 8.7l2-1.2",
                    fill: false, strokeWidth: 2.4),
            ]
        case .offline:
            return [
                Sub(d: "M5 12.5a9 9 0 0 1 14 0", fill: false, strokeWidth: 2.6),
                Sub(d: "M8.5 16a5 5 0 0 1 7 0", fill: false, strokeWidth: 2.6),
                Sub(d: circle(cx: 12, cy: 19.4, r: 0.7), fill: true, strokeWidth: 0),
                Sub(d: "M3 3l18 18", fill: false, strokeWidth: 2.6),
            ]
        case .speech:
            return [
                Sub(
                    d: "M20 12a7.5 7.5 0 0 1-10.9 6.7L4 20l1.4-4.3A7.5 7.5 0 1 1 20 12z",
                    fill: false, strokeWidth: 2.6)
            ]
        case .reviewLoop:
            return [
                Sub(d: "M3.5 12a8.5 8.5 0 1 1 2.6 6.1", fill: false, strokeWidth: 2.75),
                Sub(d: "M3 19v-5h5", fill: false, strokeWidth: 2.75),
            ]
        case .camera:
            return [
                Sub(d: "M4 8.5 5.2 6h5.6L12 8.5", fill: false, strokeWidth: 2.6),
                Sub(d: rrect(x: 3, y: 8.5, w: 18, h: 11.5, r: 3), fill: false, strokeWidth: 2.6),
                Sub(d: circle(cx: 12, cy: 14.2, r: 3.2), fill: false, strokeWidth: 2.6),
            ]
        case .pencil:
            return [
                Sub(d: "M15.5 4.5l4 4L9 19H5v-4z", fill: false, strokeWidth: 2.75)
            ]
        case .star:
            return [
                Sub(
                    d:
                        "M12 3.5 14.6 9l6 .9-4.3 4.2 1 6-5.3-2.8L6.7 20l1-6L3.4 9.9l6-.9z",
                    fill: false, strokeWidth: 2.75)
            ]
        case .chevron:
            return [
                Sub(d: "M9 5l7 7-7 7", fill: false, strokeWidth: 2.75)
            ]
        case .chevronDown:
            return [
                Sub(d: "M6 9l6 6 6-6", fill: false, strokeWidth: 2.75)
            ]
        case .alert:
            return [
                Sub(d: "M12 8v5", fill: false, strokeWidth: 2.75),
                Sub(d: circle(cx: 12, cy: 16.5, r: 0.6), fill: true, strokeWidth: 0),
                Sub(d: circle(cx: 12, cy: 12, r: 9), fill: false, strokeWidth: 2.75),
            ]
        case .clock:
            return [
                Sub(d: circle(cx: 12, cy: 12, r: 9), fill: false, strokeWidth: 2.75),
                Sub(d: "M12 7.5V12l3 2", fill: false, strokeWidth: 2.75),
            ]
        case .warning:
            return [
                Sub(d: "M12 8.5v5M12 17.2h.01", fill: false, strokeWidth: 3)
            ]
        case .sun:
            return [
                Sub(d: circle(cx: 12, cy: 12, r: 4.5), fill: false, strokeWidth: 2.0),
                Sub(
                    d:
                        "M12 2v2.5M12 19.5V22M2 12h2.5M19.5 12H22M4.93 4.93l1.77 1.77M17.3 17.3l1.77 1.77M4.93 19.07l1.77-1.77M17.3 6.7l1.77-1.77",
                    fill: false, strokeWidth: 2.0
                ),
            ]
        case .moon:
            return [
                Sub(
                    d: "M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z",
                    fill: false, strokeWidth: 2.0
                )
            ]
        case .sparkle:
            return [
                Sub(
                    d:
                        "M7 0 C7.6 5.1 8.9 6.4 14 7 C8.9 7.6 7.6 8.9 7 14 C6.4 8.9 5.1 7.6 0 7 C5.1 6.4 6.4 5.1 7 0 Z",
                    fill: true, strokeWidth: 0, box: 14)
            ]
        case .flame:
            return [
                Sub(
                    d:
                        "M12 2.5C9 6 6.5 8.2 6.5 12.5a5.5 5.5 0 0 0 11 0c0-2.2-1.1-3.4-2.2-4.6-.5 1-1.2 1.7-2.1 2.1.3-2.7-.5-5.4-1.2-7.5Z",
                    fill: true, strokeWidth: 0)
            ]
        case .trophy:
            return [
                Sub(d: rrect(x: 7, y: 4, w: 10, h: 8.5, r: 2), fill: false, strokeWidth: 1.9),
                Sub(
                    d: "M7 5.5H4.5a3 3 0 0 0 3 3M17 5.5h2.5a3 3 0 0 1-3 3", fill: false,
                    strokeWidth: 1.9),
                Sub(d: "M12 12.5v3M8.5 19.5h7M10 15.5h4l.8 4h-5.6Z", fill: false, strokeWidth: 1.9),
            ]
        }
    }

    /// Circle as two arcs — the way the authored symbols encode them.
    static func circle(cx: CGFloat, cy: CGFloat, r: CGFloat) -> String {
        "M\(cx) \(cy)m\(-r) 0a\(r) \(r) 0 1 0 \(2 * r) 0a\(r) \(r) 0 1 0 \(-2 * r) 0Z"
    }

    /// Rounded rect via arcs (rect rx, as authored).
    static func rrect(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, r: CGFloat) -> String {
        "M\(x + r) \(y)H\(x + w - r)A\(r) \(r) 0 0 1 \(x + w) \(y + r)V\(y + h - r)A\(r) \(r) 0 0 1 \(x + w - r) \(y + h)H\(x + r)A\(r) \(r) 0 0 1 \(x) \(y + h - r)V\(y + r)A\(r) \(r) 0 0 1 \(x + r) \(y)Z"
    }
}

extension AUIcon.Kind {
    /// Maps the authored `icon` strings on practice items.
    init?(rawIcon: String) {
        switch rawIcon {
        case "ear": self = .ear
        case "eye": self = .eye
        case "choose": self = .choose
        case "tap", "hand": self = .tap
        case "match": self = .match
        case "mouth", "speak": self = .mouth
        case "loop", "replay": self = .loop
        default: return nil
        }
    }
}
