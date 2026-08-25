import SwiftUI

// MARK: - Login (Aurel.dc.html lines 412–449)

struct LoginView: View {
    @Environment(AppEnvironment.self) private var env
    @State private var showForgotPassword = false
    @State private var shakeAttempts: CGFloat = 0
    @FocusState private var passwordFocused: Bool

    @ViewBuilder
    var body: some View {
        if env.router.capabilities.accounts {
            loginForm
        } else {
            CapabilityUnavailableView(
                title: "Accounts aren't available.",
                message:
                    "Your learning stays on this iPhone. You can begin or continue without signing in.",
                buttonTitle: "Back",
                aid: "au.capability.accounts-unavailable"
            ) {
                env.router.nav(.welcome)
            }
        }
    }

    private var loginForm: some View {
        GeometryReader { geo in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HStack {
                        Button {
                            env.router.nav(.welcome)
                        } label: {
                            AUIcon(kind: .back, size: 17)
                                .frame(width: 44, height: 44)
                                .background(Circle().strokeBorder(Color.auDivider, lineWidth: 1))
                        }
                        .buttonStyle(.auTap)
                        .accessibilityLabel("Back")
                        Spacer()
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
                                aid: "au.login.email",
                                contentType: .emailAddress,
                                submitLabel: .next,
                                onSubmit: { passwordFocused = true })
                        }
                        AUField(label: "Password") {
                            AUTextField(
                                text: Binding(
                                    get: { env.router.pass },
                                    set: { env.router.setPass($0) }
                                ), placeholder: "••••••••", secure: true, aid: "au.login.pass",
                                contentType: .password,
                                submitLabel: .go,
                                onSubmit: { env.router.signIn() },
                                externalFocus: $passwordFocused)
                        }
                    }
                    .modifier(AUShakeEffect(animatableData: shakeAttempts))
                    .padding(.bottom, 10)

                    HStack {
                        Spacer()
                        Button {
                            showForgotPassword = true
                        } label: {
                            Text("Forgot password?")
                                .font(.figtree(.semibold, size: 13))
                                .foregroundStyle(Color.auAccentText)
                        }
                        .buttonStyle(.auTap)
                    }
                    .padding(.bottom, 22)

                    if !env.router.loginErr.isEmpty {
                        // AUBanner carries the authored top+fade entrance
                        // (craft overhaul M9 — the old banner hard-cut because
                        // loginErr was mutated outside any animation).
                        AUBanner(text: env.router.loginErr, tone: .error)
                            .padding(.bottom, 12)
                    }

                    APillButton(title: "Sign in") {
                        env.router.signIn()
                        if !env.router.loginErr.isEmpty {
                            AUFeedback.miss()
                            withAnimation(.default) {
                                shakeAttempts += 1
                            }
                        }
                    }
                    .padding(.bottom, 20)

                    // Craft overhaul C2: the fake Apple/Google buttons are
                    // gone — they navigated straight to .home with no
                    // credential flow (App Store Guideline 4.8). Social
                    // sign-in returns when it is real (SignInWithAppleButton).

                    Spacer(minLength: 20)

                    HStack(spacing: 4) {
                        Text("New here?")
                            .foregroundStyle(Color.auTextSecondary)
                        ALinkButton(title: "Create an account") {
                            env.router.nav(.goal)
                        }
                        .fixedSize()
                    }
                    .font(.figtree(.regular, size: 13))
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.top, 74)
                .padding(.bottom, 32)
                .frame(minHeight: geo.size.height, alignment: .top)
            }
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordSheet()
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
    /// AutoFill/QuickType content type (craft overhaul M8).
    var contentType: UITextContentType? = nil
    var submitLabel: SubmitLabel = .return
    var onSubmit: () -> Void = {}
    /// Optional external focus (email→password chaining); internal otherwise.
    var externalFocus: FocusState<Bool>.Binding? = nil

    @FocusState private var internalFocus: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var focused: Bool { externalFocus?.wrappedValue ?? internalFocus }

    var body: some View {
        Group {
            if let externalFocus {
                core.focused(externalFocus)
            } else {
                core.focused($internalFocus)
            }
        }
        .keyboardType(keyboard)
        .textContentType(contentType)
        .submitLabel(submitLabel)
        .onSubmit(onSubmit)
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
                // Craft overhaul M8: focus ring — accent border on focus.
                .strokeBorder(
                    focused ? Color.auAccent : Color.auEdge,
                    lineWidth: focused ? 1.5 : 1
                )
                .animation(
                    AUMotion.animation(AUMotion.instant, reduceMotion: reduceMotion),
                    value: focused
                )
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

    @ViewBuilder
    private var core: some View {
        if secure {
            SecureField(
                "", text: $text,
                prompt: Text(placeholder.auLocalized).foregroundStyle(Color.auTextTertiary))
        } else {
            TextField(
                "", text: $text,
                prompt: Text(placeholder.auLocalized).foregroundStyle(Color.auTextTertiary))
        }
    }
}
