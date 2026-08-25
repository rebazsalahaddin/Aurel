import SwiftUI

// MARK: - Stories hub (Practice tab)
//
// Ported from Aurel.dc.html lines 993–1273 (+ STORY constants).

struct StoriesView: View {
    @Environment(AppEnvironment.self) private var env
    /// Craft overhaul P7: the locked story whose explainer is showing.
    @State private var lockedNote: String? = nil

    var body: some View {
        let r = env.router
        ZStack(alignment: .bottom) {
            Color.auBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Practice")
                        .font(.caprasimo(size: 34))
                        .tracking(-0.85)
                        .padding(.bottom, 7)
                    Text(AppRouter.TopLevelSection.practice.purpose.auLocalized)
                        .font(.figtree(.regular, size: 13.5))
                        .auLine(13.5, 1.5)
                        .foregroundStyle(Color.auTextSecondary)
                        .padding(.bottom, 24)
                        .accessibilityIdentifier("au.practice.purpose")

                    hubRow(
                        icon: .speech, tint: Color.auAccent2Ramp(600),
                        iconFg: AUSceneArt.onAccent2,
                        title: String(localized: "Scenes"),
                        sub: r.sceneTurn > 0
                            ? String(localized: "In progress · about 5 min · \(env.scene.title)")
                            : String(
                                localized: "About 5 min · choose replies in a complete exchange"),
                        radius: 28, filled: true
                    ) { r.nav(.scene) }
                    .padding(.bottom, 12)

                    hubRow(
                        icon: .mic, tint: Color.auAccentRamp(600),
                        iconFg: AUSceneArt.onAccent,
                        title: String(localized: "Say it aloud"),
                        sub: String(localized: "About 3 min · compare clarity, never accent"),
                        radius: 28, filled: true
                    ) { r.nav(.speak) }
                    .padding(.bottom, 12)

                    // The quiet variant: 42 pt grey disc, Figtree 15.5/600 title,
                    // divider outline, no fill or lift.
                    quietRow(
                        icon: .reviewLoop,
                        title: String(localized: "Review mistakes"),
                        sub: r.mistakes.isEmpty
                            ? String(localized: "Nothing due · try speaking or a story")
                            : String(
                                localized:
                                    "\(r.mistakes.count) waiting · about \(min(r.mistakes.count, 5)) min"
                            ),
                        dashed: false
                    ) { r.nav(.review) }
                    .padding(.bottom, 26)

                    HStack(alignment: .firstTextBaseline) {
                        Text("Stories")
                            .font(.figtree(.bold, size: 10.5))
                            .tracking(1.47)
                            .textCase(.uppercase)
                        Spacer()
                        Text("Reading library")
                            .font(.figtree(.regular, size: 11.5))
                            .foregroundStyle(Color.auTextTertiary)
                    }
                    .padding(.bottom, 14)

                    // stories list (line 2257) — open the chapter player on the reading screen
                    ForEach(Array(storyRows.enumerated()), id: \.offset) { i, st in
                        storyRow(st) {
                            // Craft overhaul P7: a locked row used to no-op.
                            // Now it explains itself with a calm note + haptic.
                            if st.locked {
                                AUFeedback.press()
                                withAnimation(AUMotion.quick) { lockedNote = st.title }
                            } else {
                                st.open?()
                            }
                        }
                        .auStagger(i)
                        .padding(.bottom, 12)
                    }

                    // Craft overhaul P7: the locked-story explainer.
                    if let lockedNote {
                        HStack(alignment: .top, spacing: 10) {
                            AUIcon(kind: .lock, size: 14, color: .auAccentText)
                                .padding(.top, 1)
                            Text(
                                "“\(lockedNote)” opens as its chapter is written — Chapter 1 comes first."
                            )
                            .font(.figtree(.regular, size: 12.5))
                            .auLine(12.5, 1.5)
                            .foregroundStyle(Color.auTextSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 13)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.auTintBg)
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.bottom, 12)
                        .onTapGesture {
                            withAnimation(AUMotion.quick) { self.lockedNote = nil }
                        }
                    }

                    Text(
                        // Craft overhaul P6: dropped the meta/engineering footer
                        // ("nothing here is invented for the app layer") — this
                        // learner-facing line is all that remains.
                        "Every text opens in the lesson where you first met it."
                    )
                    .font(.figtree(.regular, size: 12))
                    .auLine(12, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .padding(.bottom, 44)
                }
                .padding(.horizontal, 24)
                .padding(.top, 70)
                .padding(.bottom, 130)
            }
        }
        .auScreenEntrance()
    }

    private struct StoryRow {
        let title: String
        let meta: String
        let band: String
        let mark: String
        let locked: Bool
        let open: (() -> Void)?
    }

    private var storyRows: [StoryRow] {
        let r = env.router
        func openReading(_ chIdx: Int, _ lesIdx: Int) -> (() -> Void)? {
            let course = env.course
            guard course.chapters.indices.contains(chIdx),
                course.chapters[chIdx].lessons.indices.contains(lesIdx)
            else { return nil }
            let lesson = course.chapters[chIdx].lessons[lesIdx]
            let at = lesson.screens.firstIndex { $0.kind == .reading } ?? 0
            let pos = course.coursePos(chapterIdx: chIdx, lessonIdx: lesIdx) + at
            return {
                r.chapterIdx = chIdx
                r.courseLesson = min(lesIdx, 3)
                r.coursePos = pos
                r.pending = nil
                r.reviewMode = false
                r.screen = .course
            }
        }
        return [
            StoryRow(
                title: "Name badges and the welcome card",
                meta: "Chapter 1 · Lesson 3 · Two short readings",
                band: "A1", mark: "I", locked: false, open: openReading(0, 2)),
            StoryRow(
                title: "The register form and a message card",
                meta: "Chapter 2 · Lesson 3 · Reading and writing", band: "A1", mark: "II",
                locked: false,
                open: openReading(1, 2)),
            StoryRow(
                title: "Three profile cards and the class roll", meta: "Chapter 3 · Lesson 3",
                band: "A1", mark: "III", locked: false, open: openReading(2, 2)),
            StoryRow(
                title: "The day’s sign-in sheet",
                meta: "Chapter 4 · Lesson 2", band: "A1",
                mark: "IV", locked: false, open: openReading(3, 1)),
        ]
    }

    private func storyRow(_ st: StoryRow, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Text(st.mark)
                    .font(.caprasimo(size: 26))
                    .frame(width: 74, height: 74)
                    .background(
                        // Craft overhaul P15: nested radius = outer(28) − pad(15).
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .fill(
                                (st.mark == "II" || st.mark == "IV")
                                    ? Color.auAccent2Ramp(200) : Color.auAccentRamp(200)
                            )
                    )
                    .foregroundStyle(
                        (st.mark == "II" || st.mark == "IV")
                            ? Color.auAccent2Ramp(800) : Color.auAccentRamp(800)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text(st.title)
                        .font(.caprasimo(size: 17))
                        .auHeadLine(17, 1.2)
                    Text(st.meta)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auTextSecondary)
                    Text(st.band)
                        .font(.figtree(.regular, size: 10.5))
                        .tracking(0.42)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 3)
                        // Craft overhaul P14: neutral level chip (was green
                        // success semantics for A1, grey for the rest).
                        .background(Capsule().fill(Color.auFlatBg))
                        .foregroundStyle(Color.auFlatText)
                        .padding(.top, 9)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if st.locked {
                    AUIcon(kind: .lock, size: 17, color: .auText.opacity(0.35))
                }
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.auFill))
            .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(Color.auEdge, lineWidth: 1))
            .auLift()
            .opacity(st.locked ? 0.5 : 1)
        }
        .buttonStyle(.auTap)
    }

    /// The quiet hub entry (Review mistakes): a 42 pt grey disc, a Figtree
    /// 15.5/600 title, and a divider outline — no fill, no lift.
    private func quietRow(
        icon: AUIcon.Kind, title: String, sub: String, dashed: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                AUIcon(kind: icon, size: 19, color: .auAccent)
                    .frame(width: 42, height: 42)
                    .background(Circle().fill(Color.auText.opacity(0.08)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title.auLocalized)
                        .font(.figtree(.semibold, size: 15.5))
                        .auLine(15.5, 1.55)
                    Text(sub.auLocalized)
                        .font(.figtree(.regular, size: 12.5))
                        .auLine(12.5, 1.55)
                        .foregroundStyle(Color.auTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AUIcon(kind: .chevron, size: 17, color: .auText.opacity(0.4))
            }
            .padding(.horizontal, 21)
            .padding(.vertical, 19)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(
                        Color.auDivider,
                        style: StrokeStyle(lineWidth: 1, dash: dashed ? [5, 4] : []))
            )
        }
        .buttonStyle(.auTap)
    }

    private func hubRow(
        icon: AUIcon.Kind, tint: Color, iconFg: Color, title: String, sub: String, radius: CGFloat,
        filled: Bool, action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                AUIcon(kind: icon, size: 21, color: iconFg)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(tint))
                VStack(alignment: .leading, spacing: 3) {
                    Text(title.auLocalized)
                        .font(.caprasimo(size: 19))
                        .auHeadLine(19, 1.2)
                    Text(sub.auLocalized)
                        .font(.figtree(.regular, size: 12.5))
                        .auLine(12.5, 1.55)
                        .foregroundStyle(Color.auTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AUIcon(kind: .chevron, size: 17, color: .auText.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 19)
            .background(
                RoundedRectangle(cornerRadius: radius, style: .continuous).fill(Color.auFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius).strokeBorder(Color.auEdge, lineWidth: 1)
            )
            .auLift()
        }
        .buttonStyle(.auTap)
    }
}
