import SwiftUI

// MARK: - Welcome (Aurel.dc.html lines 125–178)

struct WelcomeView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        ZStack {
            WelcomeDusk()

            VStack(spacing: 0) {
                HStack {
                    AUWordmarkRow()
                    Spacer()
                    if env.router.capabilities.accounts {
                        Button {
                            env.router.nav(.login)
                        } label: {
                            Text("Sign in")
                                .font(.figtree(.semibold, size: 14))
                                .foregroundStyle(AUSceneArt.duskCream.opacity(0.85))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(AUSceneArt.duskCream.opacity(0.12)))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Sign in with existing account")
                    }
                }
                .padding(.top, 64)
                .padding(.horizontal, 24)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 0) {
                    // The glass chip
                    HStack(spacing: 8) {
                        // #a3b383 — a fixed art colour, not the adaptive sage token.
                        Circle().fill(Color(UIColor(hex: 0xa3b383)))
                            .frame(width: 6, height: 6)
                        Text("Chapter One free, no account")
                            .font(.figtree(.semibold, size: 11.5))
                            .tracking(0.23)
                            .foregroundStyle(
                                AUSceneArt.duskCream.opacity(0.86)
                            )
                            .fixedSize()
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(AUSceneArt.duskCream.opacity(0.10))
                    )
                    .overlay(
                        Capsule().strokeBorder(
                            AUSceneArt.duskCream.opacity(0.18), lineWidth: 1
                        )
                    )
                    .overlay(alignment: .top) {
                        // inset 0 1px 0 rgba(255,255,255,.22)
                        Capsule()
                            .strokeBorder(.white.opacity(0.22), lineWidth: 1)
                            .mask(
                                Rectangle().frame(height: 1)
                                    .frame(maxHeight: .infinity, alignment: .top))
                    }
                    .auStagger(0)

                    AUHeading(
                        text: "English,\nunhurried.",
                        size: 42, lineHeight: 1.02, tracking: -1.1,
                        color: AUSceneArt.duskCream
                    )
                    .auClampText(minScale: 0.85)
                    .padding(.top, 18)
                    .auStagger(1)

                    AUParagraph(
                        text:
                            "One lesson at a time, rebuilt each morning around the words you are about to forget.",
                        size: 15, lineHeight: 1.55,
                        color: AUSceneArt.duskCream.opacity(0.76)
                    )
                    .frame(maxWidth: 330, alignment: .leading)
                    .padding(.top, 12)
                    .padding(.bottom, 26)
                    .auStagger(2)

                    // .au-key — Begin the path
                    AUKeyButton(title: "Begin the path", aid: "au.btn.begin-the-path") {
                        env.router.nav(.onboardingSample)
                    }
                    .auStagger(3)

                    if env.router.capabilities.accounts {
                        // Already learning? · Sign in — keep on one line.
                        HStack(spacing: 15) {
                            LinearGradient(
                                colors: [
                                    .clear, AUSceneArt.duskCream.opacity(0.22),
                                ], startPoint: .leading, endPoint: .trailing
                            )
                            .frame(height: 1)
                            Button {
                                env.router.nav(.login)
                            } label: {
                                HStack(alignment: .firstTextBaseline, spacing: 7) {
                                    Text("Already learning?")
                                        .font(.figtree(.regular, size: 13.5))
                                        .tracking(0.14)
                                        .foregroundStyle(AUSceneArt.duskCream.opacity(0.58))
                                        .fixedSize()
                                    Text("Sign in")
                                        .font(.caprasimo(size: 16))
                                        .tracking(0.19)
                                        .foregroundStyle(AUSceneArt.duskCream)
                                        .underline(
                                            color: AUSceneArt.duskCream.opacity(0.38)
                                        )
                                        .fixedSize()
                                        .padding(.bottom, 2)
                                }
                                .fixedSize()
                                .padding(.vertical, 8)
                                .padding(.horizontal, 4)
                                .frame(minHeight: 44)
                            }
                            .buttonStyle(.auTap)
                            .layoutPriority(1)
                            LinearGradient(
                                colors: [
                                    .clear, AUSceneArt.duskCream.opacity(0.22),
                                ], startPoint: .trailing, endPoint: .leading
                            )
                            .frame(height: 1)
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 2)
                        .auStagger(4)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 38)
            }
        }
        .ignoresSafeArea()
    }
}
