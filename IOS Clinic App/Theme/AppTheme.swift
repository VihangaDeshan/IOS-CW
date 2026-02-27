//
//  AppTheme.swift
//  IOS Clinic App
//
//  Design token system — single source of truth for colours,
//  gradients, spacing, corner radii and component sizing.
//

import SwiftUI

// MARK: - Colour Palette

extension Color {
    // Primary brand spectrum
    static let clinicPrimary      = Color(red: 0.06, green: 0.39, blue: 0.80)
    static let clinicPrimaryDark  = Color(red: 0.03, green: 0.21, blue: 0.58)
    static let clinicPrimaryLight = Color(red: 0.25, green: 0.62, blue: 0.97)

    // Accent
    static let clinicAccent   = Color(red: 0.0,  green: 0.68, blue: 0.72)
    static let clinicSuccess  = Color(red: 0.18, green: 0.76, blue: 0.44)
    static let clinicWarning  = Color(red: 1.00, green: 0.62, blue: 0.00)

    // Gradient stops
    static let clinicGradientTop    = Color(red: 0.03, green: 0.19, blue: 0.58)
    static let clinicGradientBottom = Color(red: 0.09, green: 0.52, blue: 0.88)

    // Semantic surface colours (auto dark-mode adaptive)
    static let clinicSurface        = Color(.systemBackground)
    static let clinicSurfaceSecond  = Color(.secondarySystemBackground)
    static let clinicFieldBg        = Color(.tertiarySystemBackground)
    static let clinicSeparator      = Color(.separator)
}

// MARK: - Gradient Presets

extension LinearGradient {
    /// Main brand hero gradient used across onboarding screens.
    static var clinicHero: LinearGradient {
        LinearGradient(
            colors: [.clinicGradientTop, .clinicGradientBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Subtle card tint gradient.
    static var clinicCard: LinearGradient {
        LinearGradient(
            colors: [.clinicPrimary.opacity(0.08), .clinicAccent.opacity(0.04)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Spacing Scale

enum AppSpacing {
    static let xxs: CGFloat =  4
    static let xs:  CGFloat =  8
    static let sm:  CGFloat = 12
    static let md:  CGFloat = 16
    static let lg:  CGFloat = 24
    static let xl:  CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius Scale

enum AppRadius {
    static let sm:   CGFloat =  8
    static let md:   CGFloat = 12
    static let lg:   CGFloat = 16
    static let xl:   CGFloat = 24
    static let xxl:  CGFloat = 32
    static let pill: CGFloat = 100
}

// MARK: - Component Sizing

enum AppSize {
    static let minTapTarget:   CGFloat = 44   // iOS HIG minimum
    static let buttonPrimary:  CGFloat = 54
    static let buttonSecond:   CGFloat = 48
    static let fieldHeight:    CGFloat = 54
    static let iconHero:       CGFloat = 100
    static let iconFeature:    CGFloat = 44
    static let iconField:      CGFloat = 20
    static let logoOnboarding: CGFloat = 88
    static let logoAuth:       CGFloat = 64
}
