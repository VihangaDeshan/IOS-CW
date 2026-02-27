//
//  LoginView.swift
//  IOS Clinic App
//
//  Authentication screen.
//  Layout: hero header → glass-tinted form card → action buttons.
//  No backend required — prototype navigation only.
//

import SwiftUI

struct LoginView: View {

    @Environment(AppRouter.self) private var router

    @State private var email    = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var headerVisible = false
    @State private var formVisible   = false

    // Validation (lightweight: non-empty)
    private var canSubmit: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        !password.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // ── Hero header ──────────────────────────────────────
                heroHeader

                // ── Form card ────────────────────────────────────────
                formCard
                    .padding(.horizontal, AppSpacing.lg)
                    .offset(y: -AppSpacing.xxl)        // Overlaps header slightly
                    .opacity(formVisible ? 1 : 0)
                    .offset(y: formVisible ? 0 : 24)

                // ── Register link ────────────────────────────────────
                registerLink
                    .padding(.top, AppSpacing.md)
                    .opacity(formVisible ? 1 : 0)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .background(Color.clinicSurface)
        .ignoresSafeArea(edges: .top)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45).delay(0.05)) {
                headerVisible = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.80).delay(0.28)) {
                formVisible = true
            }
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        ZStack(alignment: .bottom) {
            // Gradient background
            LinearGradient.clinicHero
                .frame(height: 290)

            // Decorative circle
            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 260, height: 260)
                .offset(x: 120, y: -60)

            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 180, height: 180)
                .offset(x: -110, y: 20)

            // Branding stack
            VStack(spacing: AppSpacing.xs) {
                // App icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.18))
                        .frame(width: 88, height: 88)

                    Image(systemName: "cross.case.fill")
                        .font(.system(size: AppSize.logoAuth, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                }

                Text("MediCare")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.bottom, AppSpacing.xxl + AppSpacing.lg)
            .opacity(headerVisible ? 1 : 0)
            .scaleEffect(headerVisible ? 1 : 0.85)
        }
        .frame(height: 290)
    }

    // MARK: - Form Card

    private var formCard: some View {
        VStack(spacing: AppSpacing.lg) {

            // Card heading
            VStack(spacing: AppSpacing.xxs + 2) {
                Text("Welcome Back")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)

                Text("Sign in to your account to continue")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, AppSpacing.lg)

            Divider()

            // ── Fields ───────────────────────────────────────────────
            VStack(spacing: AppSpacing.md) {
                ClinicTextField(
                    label: "Email address",
                    icon: "envelope",
                    keyboardType: .emailAddress,
                    autocap: .never,
                    text: $email
                )

                ClinicSecureField(
                    label: "Password",
                    icon: "lock",
                    text: $password
                )

                // Forgot password
                HStack {
                    Spacer()
                    TextLinkButton(title: "Forgot Password?") {
                        // Navigate to forgot password flow (future)
                    }
                }
                .padding(.top, -AppSpacing.xxs)
            }

            // ── Sign In CTA ──────────────────────────────────────────
            PrimaryButton(
                "Sign In",
                icon: "arrow.right",
                isLoading: isSigningIn
            ) {
                signIn()
            }
            .disabled(!canSubmit)
            .opacity(canSubmit ? 1 : 0.55)
            .animation(.easeInOut(duration: 0.2), value: canSubmit)

            // ── Divider with OR ──────────────────────────────────────
            HStack(spacing: AppSpacing.md) {
                Rectangle().fill(Color.clinicSeparator).frame(height: 1)
                Text("OR")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                Rectangle().fill(Color.clinicSeparator).frame(height: 1)
            }

            // ── Social placeholder buttons ────────────────────────────
            HStack(spacing: AppSpacing.md) {
                SocialButton(icon: "apple.logo",   label: "Apple")  { }
                SocialButton(icon: "globe",         label: "Google") { }
            }
            .padding(.bottom, AppSpacing.lg)
        }
        .padding(.horizontal, AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.xxl)
                .fill(Color.clinicSurface)
                .shadow(color: .black.opacity(0.10), radius: 20, y: 8)
        )
    }

    // MARK: - Register Link

    private var registerLink: some View {
        HStack(spacing: AppSpacing.xxs + 2) {
            Text("Don't have an account?")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            TextLinkButton(title: "Register") {
                router.navigate(to: .register)
            }
        }
        .padding(.bottom, AppSpacing.xxxl)
    }

    // MARK: - Actions

    private func signIn() {
        isSigningIn = true
        // Prototype delay — replace with real auth
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isSigningIn = false
            router.navigate(to: .main)
        }
    }
}

// MARK: - Social Button

private struct SocialButton: View {
    let icon:   String
    let label:  String
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: icon)
                    .font(.body.weight(.medium))
                Text(label)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSize.buttonSecond)
            .background(Color.clinicFieldBg, in: RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .strokeBorder(Color.clinicSeparator, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Login") {
    LoginView()
        .environment(AppRouter())
}
