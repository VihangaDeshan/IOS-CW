//
//  PrimaryButton.swift
//  IOS Clinic App
//
//  Full-width, filled capsule button — the main CTA component.
//  Follows iOS HIG: minimum 44 pt tap target, system label colour on
//  filled background, disabled state, haptic feedback.
//

import SwiftUI
import UIKit

// MARK: - Primary Button

struct PrimaryButton: View {
    let title: String
    let icon:  String?
    let action: () -> Void

    var isLoading: Bool = false

    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title     = title
        self.icon      = icon
        self.isLoading = isLoading
        self.action    = action
    }

    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.body.weight(.semibold))
                    }
                    Text(title)
                        .font(.body.weight(.semibold))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: AppSize.buttonPrimary)
            .background(.clinicPrimary, in: Capsule())
            .shadow(color: .clinicPrimary.opacity(0.35), radius: 10, y: 5)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}

// MARK: - Outline Button

struct OutlineButton: View {
    let title: String
    let icon:  String?
    let action: () -> Void

    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title  = title
        self.icon   = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.medium))
                }
                Text(title)
                    .font(.body.weight(.medium))
            }
            .foregroundStyle(.clinicPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: AppSize.buttonSecond)
            .overlay(
                Capsule()
                    .strokeBorder(.clinicPrimary, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Text Link Button

struct TextLinkButton: View {
    let title: String
    var color: Color = .clinicPrimary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(color)
                .frame(minHeight: AppSize.minTapTarget)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Buttons") {
    VStack(spacing: AppSpacing.lg) {
        PrimaryButton("Sign In", icon: "arrow.right") { }
        PrimaryButton("Loading…", isLoading: true) { }
        OutlineButton("Create Account", icon: "person.badge.plus") { }
        TextLinkButton(title: "Forgot Password?") { }
    }
    .padding(AppSpacing.xl)
}
