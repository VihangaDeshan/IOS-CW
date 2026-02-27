//
//  Onboarding1View.swift
//  IOS Clinic App
//
//  First intro screen — pure white, no button.
//  “Clinic Flow” wordmark + “Dont miss your turn in the queue”.
//

import SwiftUI

struct Onboarding1View: View {

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                Spacer()

                // App icon
                ClinicFlowIcon(size: AppSize.logoOnboarding)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.82)

                Spacer().frame(height: AppSpacing.xxl)

                // Wordmark
                VStack(spacing: AppSpacing.sm) {
                    Text("Clinic Flow")
                        .font(.system(size: 28, weight: .bold))   // Title 1 – SF Pro
                        .foregroundStyle(.primary)

                    Text("Dont miss your turn in the queue")
                        .font(.system(size: 17, weight: .regular)) // Body – SF Pro
                        .foregroundStyle(Color.clinicSubtitle)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)

                Spacer()

                // Space for the page-dot bar rendered by the container
                Spacer().frame(height: 60)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.80).delay(0.1)) {
                appeared = true
            }
        }
    }
}

#Preview {
    Onboarding1View()
}
