//
//  WelcomeView.swift
//  IOS Clinic App
//
//  Third screen in the user flow — shown after onboarding.
//  Matches Figma: white background, app icon, headline,
//  "Continue as Guest" outline + "Login" filled buttons,
//  "New here? Create an Account" text link.
//

import SwiftUI

struct WelcomeView: View {

    @Environment(AppRouter.self) private var router
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()

                // ── App icon ──────────────────────────────────────────
                ClinicFlowIcon(size: AppSize.logoWelcome)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.82)

                Spacer().frame(height: AppSpacing.xxl)

                // ── Headline ──────────────────────────────────────────
                VStack(spacing: AppSpacing.xs) {
                    Text("Welcome to Clinical Flow")
                        .font(.system(size: 22, weight: .bold))   // Title 2
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("Choose how you'd like to Continue")
                        .font(.system(size: 15, weight: .regular)) // Subheadline
                        .foregroundStyle(Color.clinicSubtitle)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 14)

                Spacer().frame(height: AppSpacing.xxl + AppSpacing.md)

                // ── Buttons ───────────────────────────────────────────
                VStack(spacing: AppSpacing.md) {

                    // Continue as Guest — outline
                    Button {
                        router.navigate(to: .main)
                    } label: {
                        Text("Continue as Guest")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Color.clinicPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .overlay(
                                Capsule()
                                    .strokeBorder(Color.clinicPrimary, lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)

                    // Login — filled
                    Button {
                        router.navigate(to: .login)
                    } label: {
                        Text("Login")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)

                Spacer().frame(height: AppSpacing.xl)

                // ── Create account link ───────────────────────────────
                HStack(spacing: 4) {
                    Text("New here?")
                        .font(.system(size: 15, weight: .regular)) // Subheadline
                        .foregroundStyle(Color.clinicSubtitle)

                    Button {
                        router.navigate(to: .register)
                    } label: {
                        Text("Create an Account")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.clinicPrimary)
                    }
                    .buttonStyle(.plain)
                }
                .frame(minHeight: AppSize.minTapTarget)
                .opacity(appeared ? 1 : 0)

                Spacer().frame(height: AppSpacing.xxxl)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.82).delay(0.08)) {
                appeared = true
            }
        }
    }
}

#Preview {
    WelcomeView()
        .environment(AppRouter())
}
