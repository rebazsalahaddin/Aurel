import SwiftUI

// MARK: - Welcome (Aurel.dc.html lines 125–178)

struct WelcomeView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        ZStack {
            WelcomeDusk()

            VStack(spacing: 0) {
                AUWordmarkRow()
                    .padding(.top, 70)
                    .padding(.horizontal, 28)

                Spacer(minLength: 0)

                VStack(alignment: .leading, spacing: 0) {
                    // The glass chip
                    HStack(spacing: 8) {
                        Circle().fill(Color.auAccent2).frame(width: 6, height: 6)
                        Text("Chapter One free, no account")
                            .font(.figtree(.semibold, size: 11.5))
                            .tracking(0.23)
                            .foregroundStyle(
                                Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.86))
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 14)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.10))
                    )
                    .overlay(
                        Capsule().strokeBorder(
                            Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.18), lineWidth: 1
                        )
                    )
                    .auStagger(0)

                    Text("English,\nunhurried.")
                        .font(.caprasimo(size: 44))
                        .lineSpacing(44 * 0.02)
                        .tracking(-1.1)
                        .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886))
                        .padding(.top, 22)
                        .auStagger(1)

                    Text(
                        "One short lesson a day, rebuilt each morning around the words you are about to forget."
                    )
                    .font(.figtree(.regular, size: 15.5))
                    .lineSpacing(15.5 * 0.6)
                    .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.76))
                    .frame(maxWidth: 330, alignment: .leading)
                    .padding(.top, 14)
                    .padding(.bottom, 30)
                    .auStagger(2)

                    // .au-key — Begin the path
                    Button {
                        env.router.nav(.goal)
                    } label: {
                        HStack(spacing: 12) {
                            Text("Begin the path")
                                .font(.figtree(.bold, size: 16.5))
                                .tracking(0.08)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            // knob
                            AUIcon(kind: .arrow, size: 19, color: .auAccentRamp(700))
                                .frame(width: 46, height: 46)
                                .background(
                                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                                        .fill(Color.auPrimaryButtonText)
                                )
                                .shadow(color: .black.opacity(0.22), radius: 4, y: 2)
                        }
                        .padding(.leading, 24)
                        .padding(.trailing, 8)
                        .padding(.vertical, 7)
                        .background(keyGradient)
                        .clipShape(RoundedRectangle(cornerRadius: AURadius.key, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: AURadius.key, style: .continuous)
                                .strokeBorder(
                                    Color(UIColor(hex: 0x602e10)).opacity(0.16), lineWidth: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AURadius.key, style: .continuous)
                                .strokeBorder(.white.opacity(0.26), lineWidth: 1)
                                .blur(radius: 0.4)
                                .mask(
                                    Rectangle().frame(height: 1).frame(
                                        maxHeight: .infinity, alignment: .top))
                        )
                        .shadow(color: .black.opacity(0.22), radius: 3, y: 2)
                        .shadow(
                            color: Color(UIColor(hex: 0x643312)).opacity(0.42), radius: 11, y: 5)
                    }
                    .buttonStyle(.auTap)
                    .auStagger(3)

                    // Already learning? · Sign in
                    HStack(spacing: 15) {
                        LinearGradient(
                            colors: [
                                .clear, Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.22),
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
                                    .foregroundStyle(
                                        Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.58))
                                Text("Sign in")
                                    .font(.caprasimo(size: 16))
                                    .tracking(0.19)
                                    .foregroundStyle(Color(red: 0.969, green: 0.937, blue: 0.886))
                                    .underline(
                                        color: Color(red: 0.969, green: 0.937, blue: 0.886).opacity(
                                            0.38)
                                    )
                                    .padding(.bottom, 2)
                            }
                        }
                        .buttonStyle(.auTap)
                        LinearGradient(
                            colors: [
                                .clear, Color(red: 0.969, green: 0.937, blue: 0.886).opacity(0.22),
                            ], startPoint: .trailing, endPoint: .leading
                        )
                        .frame(height: 1)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 2)
                    .auStagger(4)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 44)
            }
        }
        .ignoresSafeArea()
    }

    private var keyGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: Color.auAccentRamp(600).mixed(with: 0.10, of: .white), location: 0),
                .init(color: Color.auAccentRamp(600), location: 0.46),
                .init(color: Color.auAccentRamp(700), location: 1),
            ],
            startPoint: .top, endPoint: .bottom
        )
    }
}
