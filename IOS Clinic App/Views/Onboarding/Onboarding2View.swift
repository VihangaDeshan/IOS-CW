//
//  Onboarding2View.swift
//  IOS Clinic App
//
//  Second introductory screen:
//  Features overview — three key value propositions.
//

import SwiftUI

// MARK: - Feature Info Model

private struct Feature: Identifiable {
    let id    = UUID()
    let icon:  String
    let color: Color
    let title: String
    let body:  String
}

private let features: [Feature] = [
    Feature(
        icon:  "calendar.badge.checkmark",
        color: Color(red: 0.25, green: 0.62, blue: 0.97),
        title: "Book Appointments",
        body:  "Schedule visits with your preferred doctor in seconds."
    ),
    Feature(
        icon:  "stethoscope",
        color: Color(red: 0.0, green: 0.68, blue: 0.72),
        title: "Consult Specialists",
        body:  "Connect with certified specialists from the comfort of home."
    ),
    Feature(
        icon:  "heart.text.clipboard",
        color: Color(red: 0.50, green: 0.27, blue: 0.90),
        title: "Health Records",
        body:  "View test results, prescriptions and visit history anytime."
    ),
]

// MARK: - View

struct Onboarding2View: View {

    @State private var cardsVisible = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient.clinicHero
                .ignoresSafeArea()

            // Decorative blobs mirrored from page 1
            ZStack {
                Circle()
                    .fill(.white.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .offset(x: -140, y: -240)

                Circle()
                    .fill(.white.opacity(0.06))
                    .frame(width: 260, height: 260)
                    .offset(x: 130, y: 230)
            }

            VStack(spacing: 0) {

                Spacer()

                // Top badge
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 110, height: 110)
                    Image(systemName: "star.circle.fill")
                        .font(.system(size: 62, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white)
                }
                .opacity(cardsVisible ? 1 : 0)
                .scaleEffect(cardsVisible ? 1 : 0.7)

                Spacer().frame(height: AppSpacing.lg)

                // Heading
                VStack(spacing: AppSpacing.xxs + 2) {
                    Text("Everything You Need")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("One app. All your healthcare.")
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.white.opacity(0.75))
                }
                .opacity(cardsVisible ? 1 : 0)
                .offset(y: cardsVisible ? 0 : 20)

                Spacer().frame(height: AppSpacing.xl)

                // Feature cards
                VStack(spacing: AppSpacing.sm) {
                    ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                        FeatureRow(feature: feature)
                            .opacity(cardsVisible ? 1 : 0)
                            .offset(y: cardsVisible ? 0 : 24)
                            .animation(
                                .spring(response: 0.55, dampingFraction: 0.78)
                                    .delay(0.08 * Double(index)),
                                value: cardsVisible
                            )
                    }
                }
                .padding(.horizontal, AppSpacing.xl)

                // Bottom breathing room
                Spacer().frame(height: 148)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78).delay(0.1)) {
                cardsVisible = true
            }
        }
    }
}

// MARK: - Feature Row Card

private struct FeatureRow: View {
    let feature: Feature

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Icon badge
            Image(systemName: feature.icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(feature.color)
                .frame(width: AppSize.iconFeature, height: AppSize.iconFeature)
                .background(.white.opacity(0.15), in: RoundedRectangle(cornerRadius: AppRadius.md))

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)

                Text(feature.body)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.70))
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(.white.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview("Onboarding 2") {
    Onboarding2View()
}
