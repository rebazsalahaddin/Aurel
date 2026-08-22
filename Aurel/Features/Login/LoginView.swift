import SwiftUI

// MARK: - Login (Aurel.dc.html lines 412–449)

struct LoginView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                    }
                    .frame(height: 44)
                    .overlay(alignment: .leading) {
                        Button {
                            env.router.nav(.welcome)
                        } label: {
                            AUIcon(kind: .back, size: 17)
                                .frame(width: 44, height: 44)
                                .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Back")
                    }
                    .padding(.bottom, 38)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Welcome back.")
                            .font(.caprasimo(size: 33))
                            .tracking(-0.66)
                            .auHeadLine(33, 1.12)
                        AUParagraph(
                            text: "Your path is where you left it.", size: 14, lineHeight: 1.55,
                            color: Color.auText.opacity(0.55)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 30)

                    VStack(alignment: .leading, spacing: 14) {
                        AUField(label: "Email") {
                            AUTextField(
                                text: Binding(
                                    get: { env.router.email },
                                    set: { env.router.setEmail($0) }
                                ), placeholder: "you@example.com", keyboard: .emailAddress,
                                aid: "au.login.email")
                        }
                        AUField(label: "Password") {
                            AUTextField(
                                text: Binding(
                                    get: { env.router.pass },
                                    set: { env.router.setPass($0) }
                                ), placeholder: "••••••••", secure: true, aid: "au.login.pass")
                        }
                    }
                    .padding(.bottom, 10)

                    HStack {
                        Spacer()
                        Text("Forgot password")
                            .font(.figtree(.semibold, size: 12.5))
                            .foregroundStyle(Color.auAccent)
                    }
                    .padding(.bottom, 22)

                    if !env.router.loginErr.isEmpty {
                        HStack(spacing: 10) {
                            SVGPathShape(d: "M12 8.5v5M12 17.2h.01")
                                .stroke(
                                    Color.auErrText,
                                    style: StrokeStyle(lineWidth: 3 * 15 / 24, lineCap: .round)
                                )
                                .frame(width: 15, height: 15)
                            Text(env.router.loginErr)
                                .font(.figtree(.regular, size: 12.5))
                                .auLine(12.5, 1.4)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.auErrBg)
                        )
                        .foregroundStyle(Color.auErrText)
                        .padding(.bottom, 12)
                    }

                    APillButton(title: "Sign in") {
                        env.router.signIn()
                    }
                    .padding(.bottom, 20)

                    HStack(spacing: 14) {
                        Rectangle().fill(Color.auDivider).frame(height: 1)
                        Text("or")
                            .font(.figtree(.regular, size: 11))
                            .tracking(1.1)
                            .textCase(.uppercase)
                            .foregroundStyle(Color.auText.opacity(0.40))
                        Rectangle().fill(Color.auDivider).frame(height: 1)
                    }
                    .padding(.bottom, 20)

                    LoginGhostButton(title: "Continue with Apple", glyph: .apple) {
                        env.router.nav(.home)
                    }
                    .padding(.bottom, 10)

                    LoginGhostButton(title: "Continue with Google", glyph: .google) {
                        env.router.nav(.home)
                    }

                    Spacer(minLength: 20)

                    HStack(spacing: 4) {
                        Text("New here?")
                            .foregroundStyle(Color.auText.opacity(0.50))
                        Text("Create an account")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.auAccent)
                    }
                    .font(.figtree(.regular, size: 12.5))
                    .onTapGesture { env.router.nav(.goal) }
                }
                .padding(.horizontal, 24)
                .padding(.top, 74)
                .padding(.bottom, 32)
                .frame(minHeight: geo.size.height, alignment: .top)
            }
        }
        .background(Color.auBackground.ignoresSafeArea())
        .auScreenEntrance()
    }
}

// MARK: Field + input (the .field/.input treatment, glass variant)

struct AUField<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(.figtree(.regular, size: 12))
                .foregroundStyle(Color.auText.opacity(0.70))
            content
        }
    }
}

struct AUTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var secure = false
    var keyboard: UIKeyboardType = .default
    /// UI-test identifier applied to the field itself.
    var aid: String? = nil

    var body: some View {
        Group {
            if secure {
                SecureField(
                    "", text: $text,
                    prompt: Text(placeholder).foregroundStyle(Color.auText.opacity(0.35)))
            } else {
                TextField(
                    "", text: $text,
                    prompt: Text(placeholder).foregroundStyle(Color.auText.opacity(0.35)))
            }
        }
        .keyboardType(keyboard)
        .accessibilityIdentifier(aid ?? "au.field")
        .textInputAutocapitalization(.never)
        .font(.figtree(.regular, size: 15))
        .foregroundStyle(Color.auText)
        .padding(.horizontal, 18)
        .frame(height: 54)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AUGradients.glass())
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.auEdge, lineWidth: 1)
        )
        .overlay(alignment: .top) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.auHi, lineWidth: 1)
                .mask(
                    Rectangle().frame(height: 1)
                        .frame(maxHeight: .infinity, alignment: .top)
                )
        }
        .autocorrectionDisabled()
    }
}

private struct LoginGhostButton: View {
    let title: String
    let glyph: AUBrandMark.Kind
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                AUBrandMark(kind: glyph, size: 18, tint: .auText)
                Text(title)
                    .font(.figtree(.semibold, size: 16.5))
                    .tracking(0.2)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 22)
            .padding(.vertical, 17)
            .foregroundStyle(Color.auText)
            .background(AUGradients.glass())
            .clipShape(RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                    .strokeBorder(Color.auEdge, lineWidth: 1)
            )
            .overlay(alignment: .top) {
                RoundedRectangle(cornerRadius: AURadius.btn, style: .continuous)
                    .strokeBorder(Color.auHi, lineWidth: 1)
                    .mask(
                        Rectangle().frame(height: 1)
                            .frame(maxHeight: .infinity, alignment: .top)
                    )
            }
            .auSoft()
        }
        .buttonStyle(.auTap)
        .accessibilityIdentifier("au.btn.\(title.auSlug)")
    }
}
