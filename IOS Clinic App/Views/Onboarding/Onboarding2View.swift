//
//  Onboarding2View.swift
//  IOS Clinic App
//
//  Second intro screen — white background.
//  Same icon + “Save your time using this app” subtitle
//  + “Get Start” primary button that navigates to WelcomeView.
//

import SwiftUI

struct Onboarding2View: View {

    @State private var appeared = false
    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()

                // ── App icon ────────────────────────────────────────────────
                ClinicFlowIcon(size: AppSize.logoOnboarding)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.82)

                Spacer().frame(height: AppSpacing.xxl)

                // ── Wordmark ────────────────────────────────────────────────
                VStack(spacing: AppSpacing.sm) {
                    Text("Clinic Flow")
                        .font(.system(size: 28, weight: .bold))   // Title 1 – SF Pro
                        .foregroundStyle(.primary)

                    Text("Save your time using this app")
                        .font(.system(size: 17, weight: .regular)) // Body – SF Pro
                        .foregroundStyle(Color.clinicSubtitle)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)

                Spacer().frame(height: AppSpacing.xxl + AppSpacing.lg)

                // ── Get Start button ────────────────────────────────────────────
                Button {
                    router.navigate(to: .welcome)
                } label: {
                    Text("Get Start")
                        .font(.system(size: 17, weight: .semibold)) // Body semibold
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(Color.clinicPrimary, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)

                // Space reserved for the page-dot bar
                Spacer().frame(height: 60)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.80).delay(0.12)) {
                appeared = true
            }
        }
    }
}

#Preview {
    Onboarding2View()
        .environment(AppRouter())
}


