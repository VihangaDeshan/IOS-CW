//
//  Onboarding1View.swift
//  IOS Clinic App
//
//  First introductory screen:
//  Hero — app logo on gradient background.
//  Scroll-safe, supports Dynamic Type.
//

import SwiftUI

struct Onboarding1View: View {

    // Animate hero elements in on appear
    @State private var heroScale:   CGFloat = 0.75
    @State private var heroOpacity: CGFloat = 0.0
    @State private var textOffset:  CGFloat = 30

    var body: some View {
        ZStack {
            // ── Background ────────────────────────────────────────────
            LinearGradient.clinicHero
                .ignoresSafeArea()

            // Decorative blurred circles (depth layer)
            decorativeBlobs

            // ── Content ───────────────────────────────────────────────
            VStack(spacing: 0) {

                Spacer()

                // App icon badge
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 140, height: 140)

                    Circle()
                        .fill(.white.opacity(0.22))
                        .frame(width: 110, height: 110)

                    Image(systemName: "cross.case.fill")
                        .font(.system(size: AppSize.iconHero, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                }
                .scaleEffect(heroScale)
                .opacity(heroOpacity)

                Spacer().frame(height: AppSpacing.xxl)

                // Wordmark
                VStack(spacing: AppSpacing.sm) {
                    Text("MediCare")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Your Trusted Health Partner")
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.white.opacity(0.82))
                        .multilineTextAlignment(.center)
                }
                .offset(y: textOffset)
                .opacity(heroOpacity)

                Spacer().frame(height: AppSpacing.xl)

                // Feature bullet strip
                featureStrip
                    .offset(y: textOffset)
                    .opacity(heroOpacity)

                // Bottom breathing room for the overlay navigation bar
                Spacer().frame(height: 148)
            }
            .padding(.horizontal, AppSpacing.xl)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.72).delay(0.15)) {
                heroScale   = 1.0
                heroOpacity = 1.0
                textOffset  = 0
            }
        }
    }

    // MARK: - Sub-views

    private var decorativeBlobs: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.06))
                .frame(width: 340, height: 340)
                .offset(x: 130, y: -220)

            Circle()
                .fill(.white.opacity(0.05))
                .frame(width: 260, height: 260)
                .offset(x: -140, y: 220)
        }
    }

    private var featureStrip: some View {
        HStack(spacing: AppSpacing.xl) {
            FeaturePill(icon: "calendar.badge.checkmark", label: "Appointments")
            FeaturePill(icon: "stethoscope",               label: "Doctors")
            FeaturePill(icon: "heart.text.clipboard",      label: "Records")
        }
    }
}

// MARK: - Feature Pill (shared between pages)

struct FeaturePill: View {
    let icon:  String
    let label: String

    var body: some View {
        VStack(spacing: AppSpacing.xxs) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: AppRadius.md))

            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.80))
        }
    }
}

// MARK: - Preview

#Preview("Onboarding 1") {
    Onboarding1View()
}
