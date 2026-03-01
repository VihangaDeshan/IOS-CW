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

    @State private var currentPage = 0
    private let totalPages = 2

    var body: some View {
        ZStack(alignment: .bottom) {

            TabView(selection: $currentPage) {
                Onboarding1View()
                    .tag(0)

                Onboarding2View()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // Page indicator dots
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage
                              ? Color.clinicPrimary
                              : Color(.systemGray4))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.25), value: currentPage)
                }
            }
            .padding(.bottom, AppSpacing.xl)
        }
    }
}

#Preview {
    OnboardingContainerView()
        .environment(AppRouter())
}
