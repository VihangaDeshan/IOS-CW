//
//  ContentView.swift
//  IOS Clinic App
//
//  Root view — owns the AppRouter and switches top-level destinations.
//  All child views access the router via @Environment(AppRouter.self).
//

import SwiftUI

struct ContentView: View {

    @State private var router = AppRouter()

    var body: some View {
        ZStack {
            switch router.currentRoute {

            case .onboarding:
                OnboardingContainerView()
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .welcome:
                WelcomeView()
                    .transition(.move(edge: .trailing))

            case .login:
                LoginView()
                    .transition(.move(edge: .trailing))
                
            case .verifyOTP:
                VerifyOTPView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading) .combined(with: .opacity)
                    ))

            case .register:
                // Register screen — next phase
                RegisterView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal:   .move(edge: .leading) .combined(with: .opacity)
                    ))

            case .main:
                MainTabView()
                    .transition(.scale(scale: 0.96).combined(with: .opacity))
            }
        }
        .environment(router)
        .animation(.easeInOut(duration: 0.38), value: router.currentRoute)
    }
}

// MARK: - Coming Soon Placeholder

/// Lightweight placeholder for routes not yet implemented.
/// Shows the screen name and a back-to-login option.
struct ComingSoonView: View {

    let title: String
    let icon:  String

    @Environment(AppRouter.self) private var router

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: AppSpacing.lg) {
                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 72))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.clinicPrimary)

                VStack(spacing: AppSpacing.xs) {
                    Text(title)
                        .font(.title.bold())

                    Text("Coming soon — stay tuned!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    router.navigate(to: .login)
                } label: {
                    Label("Back to Login", systemImage: "arrow.left")
                        .font(.body.weight(.medium))
                }
                .padding(.bottom, AppSpacing.xxl)
            }
            .padding(AppSpacing.xl)
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
