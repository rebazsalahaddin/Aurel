import SwiftUI

// MARK: - Paywall · Subscribe Account
//
// Ported from Aurel.dc.html lines 1275–1515 (+ plans, proFeatures — lines
// 2582–2791).

struct PaywallView: View {
    @Environment(AppEnvironment.self) private var env

    @ViewBuilder
    var body: some View {
        if env.router.capabilities.commerce {
            commercePaywall
        } else {
            CapabilityUnavailableView(
                title: "Additional chapters aren't available.",
                message:
                    "Chapter 1 is included in this build. Your progress remains on this iPhone.",
                buttonTitle: "Back to Learn",
                aid: "au.capability.chapters-unavailable"
            ) {
                env.router.nav(.home)
            }
        }
    }

    private var commercePaywall: some View {
        let r = env.router
        return ZStack {
            // dusk backdrop
            GeometryReader { geo in
                ZStack {
                    LinearGradient(
                        // Craft overhaul G24: dusk stops now come from
                        // AUSceneArt.paywallDuskDark (were 8 raw hexes).
                        stops: [
                            .init(color: AUSceneArt.paywallDuskDark[0], location: 0),
                            .init(color: AUSceneArt.paywallDuskDark[1], location: 0.24),
                            .init(color: AUSceneArt.paywallDuskDark[2], location: 0.46),
                            .init(color: AUSceneArt.paywallDuskDark[3], location: 0.62),
                            .init(color: AUSceneArt.paywallDuskDark[4], location: 0.72),
                            .init(color: AUSceneArt.paywallDuskDark[5], location: 0.80),
                            .init(color: AUSceneArt.paywallDuskDark[6], location: 0.88),
                            .init(color: AUSceneArt.paywallDuskDark[7], location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                    AUStars()
                    RadialGradient(
                        stops: [
                            .init(
                                color: AUSceneArt.sunMid.opacity(0.56),
                                location: 0),
                            .init(
                                color: AUSceneArt.sunDeep.opacity(0.22),
                                location: 0.44),
                            .init(color: .clear, location: 0.74),
                        ],
                        center: UnitPoint(x: 0.66, y: 0.80), startRadius: 0,
                        endRadius: geo.size.width * 0.9
                    )
                    GeometryReader { duneGeo in
                        ZStack(alignment: .bottom) {
                            DuneLayer(
                                fill: Color(UIColor(hex: 0x33241a)), rim: .clear, rimWidth: 0,
                                path: "M0 62 Q86 30 168 54 Q244 76 312 44 Q360 26 402 52")
                            DuneLayer(
                                fill: Color(UIColor(hex: 0x1a1310)), rim: .clear, rimWidth: 0,
                                path: "M0 104 Q96 74 184 96 Q258 114 326 88 Q368 72 402 96")
                        }
                        .frame(height: max(1, duneGeo.size.height * 0.22))
                    }
                    GrainOverlay()
                    LinearGradient(
                        stops: [
                            .init(
                                color: AUSceneArt.onAccent2Deep.opacity(0.6),
                                location: 0),
                            .init(
                                color: AUSceneArt.onAccent2Deep.opacity(0.46),
                                location: 0.38),
                            .init(
                                color: AUSceneArt.onAccent2Deep.opacity(0.5),
                                location: 0.72),
                            .init(color: Color.auBackground, location: 1),
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                }
            }
            .frame(height: 430)
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)

            // Craft overhaul G1: the whole paywall column scrolls now — the
            // old fixed VStack clipped content on small devices / large type.
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Spacer()
                        Button {
                            r.nav(.home)
                        } label: {
                            AUIcon(
                                kind: .close, size: 17,
                                color: AUSceneArt.duskCream
                            )
                            .frame(width: 44, height: 44)
                            .background(
                                Circle().fill(AUSceneArt.duskCream.opacity(0.2))
                            )
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Close")
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 44)

                    Text("Aurel Pro")
                        .font(.figtree(.bold, size: 10.5))
                        .tracking(2.1)
                        .textCase(.uppercase)
                        .foregroundStyle(AUSceneArt.sunMid)
                        .padding(.bottom, 10)

                    Text("Continue with\nChapters 2–4.")
                        .font(.caprasimo(size: 36))
                        .tracking(-0.9)
                        .auHeadLine(36, 1.06)
                        .foregroundStyle(AUSceneArt.duskCream)
                        .padding(.bottom, 12)

                    Text(
                        "Available course chapters, unlimited speaking practice, and review that brings words back when they need another look."
                    )
                    .font(.figtree(.regular, size: 14.5))
                    .auLine(14.5, 1.6)
                    .foregroundStyle(AUSceneArt.duskCream.opacity(0.75))
                    .frame(maxWidth: 290, alignment: .leading)
                    .padding(.bottom, 26)

                    // plans
                    VStack(spacing: 11) {
                        // Craft overhaul G2: honest price copy until StoreKit is
                        // wired — no fabricated amounts, no "App Store price" jargon.
                        planRow(
                            id: "annual", name: "Annual", sub: "Billed once a year",
                            price: "Yearly", badge: "Best value")
                        planRow(
                            id: "monthly", name: "Monthly", sub: "Cancel any time",
                            price: "Monthly", badge: "")
                    }
                    .padding(.bottom, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(
                            [
                                "Available chapters, including Checkpoint Review 1",
                                "Unlimited speaking sessions, scored on clarity not accent",
                                "Spaced review that decides when a word returns",
                                "Speaking practice and illustrated course scenes",
                            ], id: \.self
                        ) { f in
                            HStack(alignment: .top, spacing: 11) {
                                AUIcon(kind: .check, size: 16, color: .auAccent2)
                                    .padding(.top, 2)
                                Text(f)
                                    .font(.figtree(.regular, size: 14))
                                    .auLine(14, 1.45)
                            }
                        }
                    }
                    .padding(.bottom, 24)

                    Spacer(minLength: 12)

                    APillButton(title: r.hasAccount ? "Subscribe" : "Create account and subscribe")
                    {
                        r.startSubscribe()
                    }
                    .padding(.bottom, 6)

                    Button {
                        r.restorePurchase()
                    } label: {
                        Text("Restore purchase")
                            .font(.figtree(.semibold, size: 13))
                            .foregroundStyle(Color.auAccentText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.auTap)
                    .padding(.bottom, 10)

                    Text(
                        "No free trial — Chapter 1 is the free experience. Price, billing period, and renewal terms are set by the App Store at checkout. Cancel any time in Settings."
                    )
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 14)

                    // Craft overhaul G3: the legal row subscriptions require.
                    HStack(spacing: 22) {
                        Link(destination: URL(string: "https://aurel.app/terms")!) {
                            Text("Terms of Use")
                        }
                        Link(destination: URL(string: "https://aurel.app/privacy")!) {
                            Text("Privacy Policy")
                        }
                    }
                    .font(.figtree(.semibold, size: 12))
                    .foregroundStyle(Color.auAccentText)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
            }
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }

    private func planRow(id: String, name: String, sub: String, price: String, badge: String)
        -> some View
    {
        let on = env.router.plan == id
        return Button {
            AUFeedback.selection()
            env.router.plan = id
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .strokeBorder(on ? Color.auAccent : Color.auText.opacity(0.28), lineWidth: 1.5)
                    .frame(width: 22, height: 22)
                    .overlay {
                        if on {
                            Circle().fill(Color.auAccent).frame(width: 11, height: 11)
                        }
                    }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(name)
                            .font(.caprasimo(size: 18))
                        if !badge.isEmpty {
                            Text(badge)
                                .font(.figtree(.regular, size: 10))
                                .tracking(0.4)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color.auOkBg))
                                .foregroundStyle(Color.auOkQuiet)
                        }
                    }
                    Text(sub)
                        .font(.figtree(.regular, size: 12.5))
                        .foregroundStyle(Color.auTextSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(price)
                    .font(.figtree(.bold, size: 14.5))
                    .foregroundStyle(Color.auText.opacity(0.70))
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 17)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.auFill)
                    if on {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.auAccent.opacity(0.18), Color.auAccent.opacity(0.08),
                                    ],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                )
                            )
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.auAccent.opacity(0.70), lineWidth: 1.5)
                    } else {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(Color.auEdge, lineWidth: 1)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .auShimmerBorder(radius: 24, isActive: on && id == "annual")
            .auLift()
            .accessibilityAddTraits(on ? .isSelected : [])
        }
        .buttonStyle(.auTap)
    }
}

// MARK: Subscribe Account (Screen 20)

struct SubscribeAccountView: View {
    @Environment(AppEnvironment.self) private var env

    private var formValid: Bool {
        env.router.email.range(of: #".+@.+\..+"#, options: .regularExpression) != nil
            && env.router.pass.count >= 6
    }

    @ViewBuilder
    var body: some View {
        if env.router.capabilities.accounts && env.router.capabilities.commerce {
            accountForm
        } else {
            CapabilityUnavailableView(
                title: "Account subscriptions aren't available.",
                message: "Your Chapter 1 progress stays on this iPhone, with no account required.",
                buttonTitle: "Back to Learn",
                aid: "au.capability.account-subscription-unavailable"
            ) {
                env.router.nav(.home)
            }
        }
    }

    private var accountForm: some View {
        let r = env.router
        return ZStack {
            Color.auBackground.ignoresSafeArea()
            AUPaper().ignoresSafeArea()

            // Craft overhaul G4: the old fixed VStack let the keyboard cover
            // the password field and the CTA — now it scrolls.
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    AUHeader(kind: .back) { r.nav(.paywall) }
                        .padding(.horizontal, -24)
                        .padding(.bottom, 38)

                    AUHeading(
                        text: "Create your account.", size: 33, lineHeight: 1.12, tracking: -0.66
                    )
                    .padding(.bottom, 10)

                    AUParagraph(
                        text:
                            "Needed to subscribe, and to sync or restore your purchase. Your Chapter 1 progress carries over automatically.",
                        size: 14, lineHeight: 1.55, color: Color.auTextSecondary
                    )
                    .padding(.bottom, 30)

                    if !r.loginErr.isEmpty {
                        // Craft overhaul G21: authored entrance, not a hard cut.
                        AUBanner(text: r.loginErr, tone: .error)
                            .padding(.bottom, 16)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Email")
                                .font(.figtree(.semibold, size: 12))
                                .foregroundStyle(Color.auTextSecondary)
                            TextField(
                                "you@example.com",
                                text: Binding(
                                    get: { r.email },
                                    set: { r.setEmail($0) }
                                )
                            )
                            .font(.figtree(.medium, size: 15))
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .submitLabel(.next)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 18)
                            .frame(minHeight: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(Color.auEdge, lineWidth: 1)
                            )
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.figtree(.semibold, size: 12))
                                .foregroundStyle(Color.auTextSecondary)
                            SecureField(
                                "••••••••",
                                text: Binding(
                                    get: { r.pass },
                                    set: { r.setPass($0) }
                                )
                            )
                            .font(.figtree(.medium, size: 15))
                            .textContentType(.newPassword)
                            .submitLabel(.go)
                            .onSubmit { if formValid { r.createAccountAndSubscribe() } }
                            .padding(.horizontal, 18)
                            .frame(minHeight: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.auFill)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(Color.auEdge, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.bottom, 20)

                    Spacer(minLength: 24)

                    // Craft overhaul G22: disabled until the form is valid.
                    APillButton(title: "Create account and subscribe", disabled: !formValid) {
                        r.createAccountAndSubscribe()
                    }
                    .padding(.bottom, 12)

                    Text(
                        "Price, billing period, and renewal terms are set by the App Store at checkout. No free trial — Chapter 1 is the free experience."
                    )
                    .font(.figtree(.regular, size: 11.5))
                    .auLine(11.5, 1.5)
                    .foregroundStyle(Color.auTextTertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .auScreenEntrance()
    }
}
