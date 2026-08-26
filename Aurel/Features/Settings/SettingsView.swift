import SwiftUI

// MARK: - Settings
//
// Ported from Aurel.dc.html lines 1275–1515 (settings section).

struct SettingsView: View {
    @Environment(AppEnvironment.self) private var env
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var confirmDelete = false

    var body: some View {
        let r = env.router

        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Settings")
                    .font(.caprasimo(size: 29))
                    .tracking(-0.58)
                    .padding(.bottom, 6)
                Text(AppRouter.TopLevelSection.you.purpose.auLocalized)
                    .font(.figtree(.regular, size: 13.5))
                    .auLine(13.5, 1.5)
                    .foregroundStyle(Color.auTextSecondary)
                    .padding(.bottom, 22)
                    .accessibilityIdentifier("au.settings.purpose")

                if !r.loginErr.isEmpty {
                    AUBanner(text: r.loginErr, tone: .error)
                        .padding(.bottom, 18)
                }

                sectionLabel("Practice")
                VStack(spacing: 0) {
                    if r.capabilities.notifications {
                        switchRow("Daily reminder", "One, at \(r.remindAt)", on: r.sw.reminder) {
                            r.toggleSw(\.reminder)
                        }
                    }
                    switchRow("Sound", "Soft and sparse", on: r.sw.sound) { r.toggleSw(\.sound) }
                    switchRow(
                        "Haptics", "On answer and completion", on: r.sw.haptics,
                        divider: r.capabilities.weeklyEmail
                    ) {
                        r.toggleSw(\.haptics)
                    }
                    if r.capabilities.weeklyEmail {
                        switchRow(
                            "Weekly summary", "Sunday evening, by email", on: r.sw.weekly,
                            divider: false
                        ) {
                            r.toggleSw(\.weekly)
                        }
                    }
                }
                .settingsCard()
                .padding(.bottom, 22)

                if r.capabilities.notifications {
                    sectionLabel("Notifications")
                    VStack(spacing: 0) {
                        switchRow(
                            "Dawn", "Today's lesson is ready, at \(r.remindAt)", on: r.notif.dawn
                        ) {
                            r.toggleNotif(\.dawn)
                        }
                        switchRow(
                            "Sundown", "Only when something is actually due", on: r.notif.sundown
                        ) {
                            r.toggleNotif(\.sundown)
                        }
                        switchRow(
                            "Milestones", "When you pass something worth naming",
                            on: r.notif.milestone
                        ) { r.toggleNotif(\.milestone) }
                        switchRow(
                            "Cedar Group", "Standings and results — off by default",
                            on: r.notif.cohort,
                            divider: false
                        ) { r.toggleNotif(\.cohort) }
                    }
                    .settingsCard()
                    .padding(.bottom, 22)
                }

                if r.capabilities.widget {
                    sectionLabel("Home Screen")
                    HStack(spacing: 18) {
                        WidgetPreview(streak: "\(max(r.streak, 0))")
                        VStack(alignment: .leading, spacing: 4) {
                            Text("The arc, on your Home Screen")
                                .font(.figtree(.semibold, size: 14.5))
                            Text(
                                "Long-press your Home Screen, then add the small Aurel widget. The sun moves as the day is finished."
                            )
                            .font(.figtree(.regular, size: 12.5))
                            .auLine(12.5, 1.5)
                            .foregroundStyle(Color.auTextSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .auLift()
                    .padding(.bottom, 22)
                }

                sectionLabel("Comparison")
                Button {
                    r.boardOut.toggle()
                } label: {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Cedar Group")
                                .font(.figtree(.semibold, size: 15))
                            Text("Off hides the group everywhere. Nothing is lost.")
                                .font(.figtree(.regular, size: 12.5))
                                .foregroundStyle(Color.auTextSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        AuthoredSwitch(isOn: !r.boardOut)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.auTap)
                .accessibilityLabel("Cedar Group")
                .accessibilityAddTraits(!r.boardOut ? .isSelected : [])
                sectionLabel("Appearance")
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Theme")
                            .font(.figtree(.semibold, size: 15))
                        Spacer()
                        Text(themeLabel(for: r.themeMode))
                            .font(.figtree(.regular, size: 13))
                            .foregroundStyle(Color.auAccent)
                    }

                    HStack(spacing: 8) {
                        themeOptionButton(
                            title: "System", icon: .gear, mode: 0, current: r.themeMode
                        ) {
                            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.38)) {
                                r.setThemeMode(0)
                            }
                        }
                        themeOptionButton(title: "Light", icon: .sun, mode: 1, current: r.themeMode)
                        {
                            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.38)) {
                                r.setThemeMode(1)
                            }
                        }
                        themeOptionButton(title: "Dark", icon: .moon, mode: 2, current: r.themeMode)
                        {
                            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.38)) {
                                r.setThemeMode(2)
                            }
                        }
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.auFill.opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    )
                }
                .padding(20)
                .settingsCard()
                .padding(.bottom, 22)

                sectionLabel("Reading")
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Text size")
                            .font(.figtree(.semibold, size: 15))
                        Spacer()
                        Text(typeLabel)
                            .font(.figtree(.regular, size: 13))
                            .foregroundStyle(Color.auAccent)
                    }
                    GeometryReader { geo in
                        let step = min(max(r.typeStep, 0), 4)
                        let travel = max(0, geo.size.width - 20)
                        let progress = CGFloat(step) / 4

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.auText.opacity(0.12))
                                .frame(height: 4)
                                .padding(.horizontal, 10)
                            Capsule()
                                .fill(Color.auAccent)
                                .frame(width: 10 + travel * progress, height: 4)
                                .padding(.leading, 10)
                            Circle()
                                .fill(Color.auAccent)
                                .frame(width: 20, height: 20)
                                .shadow(color: Color.auAccent.opacity(0.20), radius: 4, y: 2)
                                .offset(x: travel * progress)
                                // Craft overhaul R5: the knob springs between
                                // steps instead of hard-snapping.
                                .animation(
                                    AUMotion.animation(AUMotion.snap, reduceMotion: reduceMotion),
                                    value: step
                                )
                            HStack(spacing: 0) {
                                ForEach(0..<5, id: \.self) { target in
                                    Button {
                                        AUFeedback.selection()
                                        r.setTypeStep(target)
                                    } label: {
                                        Color.clear
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .contentShape(Rectangle())
                                    }
                                    // Craft overhaul G17: a real pressed state
                                    // + haptic (was .plain, no feedback).
                                    .buttonStyle(.auTap)
                                    .accessibilityLabel(typeLabel(for: target))
                                    .accessibilityIdentifier("au.settings.type.\(target)")
                                }
                            }
                        }
                    }
                    // Craft overhaul G17: taller lane so each step target
                    // clears 44pt (was 30).
                    .frame(height: 44)
                    Text("Pleased to meet you.")
                        .font(.figtree(.regular, size: typePreview))
                    Text(
                        "Type size adapts across Aurel, including the largest accessibility settings."
                    )
                    .font(.figtree(.regular, size: 12))
                    .auLine(12, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 28, style: .continuous).fill(Color.auFill)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28).strokeBorder(Color.auEdge, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .auLift()
                .padding(.bottom, 22)

                sectionLabel(r.capabilities.accounts ? "Account and data" : "Data on this iPhone")
                VStack(spacing: 0) {
                    if r.capabilities.commerce {
                        accountRow("Subscription", r.pro ? "Subscribed" : "Free") {
                            r.nav(.paywall)
                        }
                    }
                    if r.capabilities.accounts {
                        infoRow("Email", r.email.isEmpty ? "Not signed in" : r.email)
                        accountRow("Sign out", "", tint: .auAccentText) { r.signOut() }
                    } else {
                        infoRow("Learning data", "Stored locally")
                    }
                    accountRow(
                        "Delete local data", "Permanent", tint: .auErr, divider: false,
                        aid: "au.settings.delete-local-data"
                    ) {
                        confirmDelete = true
                    }
                }
                .settingsCard()
            }
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .padding(.bottom, 34)
        }
        .background(Color.auBackground.ignoresSafeArea())
        .alert(
            "Delete local learning data?",
            isPresented: $confirmDelete
        ) {
            Button("Delete local data", role: .destructive) {
                r.deleteLocalData()
            }
            Button("Cancel", role: .cancel) {
                r.cancelLocalDataDeletion()
            }
        } message: {
            Text(
                "Your progress, streaks, and settings on this iPhone will be erased. This cannot be undone."
            )
        }
        .auScreenEntrance()
    }

    private func themeOptionButton(
        title: String, icon: AUIcon.Kind, mode: Int, current: Int, action: @escaping () -> Void
    ) -> some View {
        let isSelected = current == mode
        return Button(action: {
            AUFeedback.selection()
            action()
        }) {
            HStack(spacing: 6) {
                AUIcon(kind: icon, size: 15, color: isSelected ? .auAccentText : .auTextSecondary)
                Text(title)
                    .font(.figtree(.semibold, size: 13.5))
                    .foregroundStyle(isSelected ? Color.auAccentText : Color.auTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 38)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.auFill)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color.auEdge, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.06), radius: 3, y: 1.5)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.auTap)
        .accessibilityLabel("\(title) theme")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityIdentifier("au.settings.theme.\(title.lowercased())")
    }

    private func themeLabel(for mode: Int) -> String {
        switch mode {
        case 1: "Light"
        case 2: "Dark"
        default: "Automatic (System)"
        }
    }

    private var typeLabel: String {
        ["Smaller", "Small", "Default", "Large", "Largest"][min(max(env.router.typeStep, 0), 4)]
    }
    private var typePreview: CGFloat {
        [12.5, 13.5, 14.5, 17, 20][min(max(env.router.typeStep, 0), 4)]
    }

    private func typeLabel(for step: Int) -> String {
        ["Smaller", "Small", "Default", "Large", "Largest"][min(max(step, 0), 4)]
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.figtree(.bold, size: 10.5))
            .tracking(1.47)
            .textCase(.uppercase)
            .foregroundStyle(Color.auTextSecondary)
            .padding(.bottom, 12)
    }

    private func switchRow(
        _ label: String, _ sub: String, on: Bool, divider: Bool = true,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.figtree(.semibold, size: 15))
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                AuthoredSwitch(isOn: on)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .overlay(alignment: .bottom) {
                if divider { Divider().overlay(Color.auDivider) }
            }
        }
        .buttonStyle(.auTap)
        .accessibilityLabel(label)
        .accessibilityAddTraits(on ? .isSelected : [])
    }

    private func accountRow(
        _ label: String, _ value: String, tint: Color = .auText, divider: Bool = true,
        aid: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(label)
                    .font(.figtree(.semibold, size: 15))
                    .foregroundStyle(tint)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(value)
                    .font(.figtree(.regular, size: 13))
                    .foregroundStyle(Color.auTextTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 17)
            .overlay(alignment: .bottom) {
                if divider { Divider().overlay(Color.auDivider) }
            }
        }
        .buttonStyle(.auTap)
        .frame(maxWidth: .infinity, minHeight: 52)
        .contentShape(Rectangle())
        .accessibilityIdentifier(aid ?? "au.settings.\(label.auSlug)")
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack(spacing: 12) {
            Text(label)
                .font(.figtree(.semibold, size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(value)
                .font(.figtree(.regular, size: 13))
                .foregroundStyle(Color.auTextTertiary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 17)
        .overlay(alignment: .bottom) {
            Divider().overlay(Color.auDivider)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct AuthoredSwitch: View {
    let isOn: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Capsule()
            .fill(isOn ? Color.auAccent : Color.auText.opacity(0.16))
            .frame(width: 50, height: 30)
            .overlay(alignment: isOn ? .trailing : .leading) {
                Circle()
                    .fill(Color.auBackground)
                    .frame(width: 24, height: 24)
                    .shadow(color: Color.auText.opacity(0.16), radius: 2, y: 1)
                    .padding(3)
            }
            // Craft overhaul R4: the knob slides + the track cross-fades
            // (was an instant snap).
            .animation(
                AUMotion.animation(AUMotion.snap, reduceMotion: reduceMotion),
                value: isOn
            )
            .accessibilityHidden(true)
    }
}

extension View {
    fileprivate func settingsCard() -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Color.auFill))
            .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(Color.auEdge, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .auLift()
    }
}

/// The home-screen widget preview (settings, lines 1428–1439).
struct WidgetPreview: View {
    let streak: String

    var body: some View {
        ZStack {
            AUGradients.sky
            GeometryReader { geo in
                let sx = geo.size.width / 96
                let sy = geo.size.height / 96
                // arc
                Path { p in
                    p.move(to: CGPoint(x: 12, y: 58))
                    p.addQuadCurve(to: CGPoint(x: 84, y: 58), control: CGPoint(x: 48, y: 8))
                }
                .stroke(
                    Color.auText.opacity(0.16),
                    style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [2, 6])
                )
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                // dunes
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 62))
                    p.addQuadCurve(to: CGPoint(x: 48, y: 60), control: CGPoint(x: 24, y: 54))
                    p.addQuadCurve(to: CGPoint(x: 96, y: 56), control: CGPoint(x: 72, y: 66))
                    p.addLine(to: CGPoint(x: 96, y: 96))
                    p.addLine(to: CGPoint(x: 0, y: 96))
                    p.closeSubpath()
                }
                .fill(Color.auDune)
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: 74))
                    p.addQuadCurve(to: CGPoint(x: 54, y: 72), control: CGPoint(x: 28, y: 66))
                    p.addQuadCurve(to: CGPoint(x: 96, y: 70), control: CGPoint(x: 78, y: 78))
                    p.addLine(to: CGPoint(x: 96, y: 96))
                    p.addLine(to: CGPoint(x: 0, y: 96))
                    p.closeSubpath()
                }
                .fill(Color.auDune2)
                .scaleEffect(x: sx, y: sy, anchor: .topLeading)
                // sun
                Circle()
                    .fill(
                        RadialGradient(
                            stops: [
                                .init(color: Color(UIColor(hex: 0xfff1d4)), location: 0),
                                .init(color: Color(UIColor(hex: 0xf7c489)), location: 0.42),
                                .init(color: Color(UIColor(hex: 0xe08f4c)), location: 0.72),
                                .init(color: .clear, location: 0.80),
                            ],
                            center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: 9
                        )
                    )
                    .frame(width: 18, height: 18)
                    .position(x: 0.48 * geo.size.width, y: 0.12 * geo.size.height)
                // streak text
                VStack(alignment: .leading, spacing: 2) {
                    Text(streak)
                        .font(.figtree(.bold, size: 15))
                        .monospacedDigit()
                    Text("Half done")
                        .font(.figtree(.bold, size: 7))
                        .tracking(0.98)
                        .textCase(.uppercase)
                        .opacity(0.7)
                }
                .foregroundStyle(Color.auDuneText)
                .position(x: 30, y: geo.size.height - 22)
            }
        }
        .frame(width: 96, height: 96)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .auLift()
    }
}
