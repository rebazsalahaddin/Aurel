import SwiftUI

// MARK: - Login (Aurel.dc.html lines 412–449)

struct LoginView: View {
    @Environment(AppEnvironment.self) private var env

    var body: some View {
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
                Text("Your path is where you left it.")
                    .font(.figtree(.regular, size: 14))
                    .lineSpacing(14 * 0.55)
                    .foregroundStyle(Color.auText.opacity(0.55))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)

            VStack(alignment: .leading, spacing: 14) {
                AUField(label: "Email") {
                    AUTextField(text: Binding(
                        get: { env.router.email },
                        set: { env.router.setEmail($0) }
                    ), placeholder: "you@example.com", keyboard: .emailAddress)
                }
                AUField(label: "Password") {
                    AUTextField(text: Binding(
                        get: { env.router.pass },
                        set: { env.router.setPass($0) }
                    ), placeholder: "••••••••", secure: true)
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
                        .stroke(Color.auErrText, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 15, height: 15)
                    Text(env.router.loginErr)
                        .font(.figtree(.regular, size: 12.5))
                        .lineSpacing(2)
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

            APillButton(title: "Continue with Apple", variant: .ghost) {
                env.router.nav(.home)
            }
            .padding(.bottom, 10)

            APillButton(title: "Continue with Google", variant: .ghost) {
                env.router.nav(.home)
            }

            Spacer(minLength: 20)

            (
                Text("New here? ")
                    .foregroundStyle(Color.auText.opacity(0.50))
                + Text("Create an account")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auAccent)
            )
            .font(.figtree(.regular, size: 12.5))
            .onTapGesture { env.router.nav(.goal) }
        }
        .padding(.horizontal, 24)
        .padding(.top, 74)
        .padding(.bottom, 32)
        .frame(minHeight: 874, alignment: .top)
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
            content
        }
    }
}

struct AUTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var secure = false
    var keyboard: UIKeyboardType = .default

    var body: some View {
        Group {
            if secure {
                SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.auText.opacity(0.35)))
            } else {
                TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(Color.auText.opacity(0.35)))
            }
        }
        .keyboardType(keyboard)
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
        .autocorrectionDisabled()
    }
}
