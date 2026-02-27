//
//  OnboardingContainerView.swift
//  IOS Clinic App
//
//  Hosts both onboarding pages inside a swipeable TabView.
//  Overlays a persistent bottom navigation bar with:
//   - animated page indicator dots
//   - Skip (text) and Next / Get Started (capsule) buttons
//

import SwiftUI

struct OnboardingContainerView: View {

    @State   private var currentPage = 0
    @Environment(AppRouter.self) private var router

    private let totalPages = 2

    var body: some View {
        ZStack(alignment: .bottom) {

            // ── Swipeable pages ──────────────────────────────────────
            TabView(selection: $currentPage) {
                Onboarding1View()
                    .tag(0)

                Onboarding2View()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // ── Persistent bottom navigation overlay ─────────────────
            VStack(spacing: AppSpacing.md) {

                // Page indicator dots
                HStack(spacing: AppSpacing.xs) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage
                                  ? Color.white
                                  : Color.white.opacity(0.35))
                            .frame(
                                width:  index == currentPage ? 28 : 8,
                                height: 8
                            )
                            .animation(.spring(response: 0.32, dampingFraction: 0.72),
                                       value: currentPage)
                    }
                }

                // Skip / Next row
                HStack {
                    // Skip
                    TextLinkButton(title: "Skip", color: .white.opacity(0.75)) {
                        router.navigate(to: .login)
                    }
                    .frame(width: 72)

                    Spacer()

                    // Next / Get Started
                    Button {
                        if currentPage < totalPages - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            router.navigate(to: .login)
                        }
                    } label: {
                        HStack(spacing: AppSpacing.xxs + 2) {
                            Text(currentPage < totalPages - 1 ? "Next" : "Get Started")
                                .font(.subheadline.weight(.semibold))

                            Image(systemName: currentPage < totalPages - 1
                                  ? "arrow.right"
                                  : "arrow.right.circle.fill")
                            .font(.subheadline.weight(.semibold))
                        }
                        .foregroundStyle(.clinicPrimary)
                        .padding(.horizontal, AppSpacing.lg)
                        .frame(height: 46)
                        .background(.white, in: Capsule())
                        .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.xl)
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
    }
}

// MARK: - Preview

#Preview("Onboarding Flow") {
    OnboardingContainerView()
        .environment(AppRouter())
}
