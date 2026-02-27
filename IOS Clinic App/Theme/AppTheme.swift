//
//  AppTheme.swift
//  IOS Clinic App
//
//  Design token system — matches Figma «Clinic Flow» designs.
//  Clean white surfaces, system blue CTA, teal-to-blue icon gradient.
//

import SwiftUI

// MARK: - Colour Palette

extension Color {
    /// Primary CTA blue — matches Figma button colour.
    static let clinicPrimary     = Color(red: 0.11, green: 0.49, blue: 0.98)

    /// Icon gradient stops (shield: teal → blue).
    static let clinicIconTeal    = Color(red: 0.00, green: 0.76, blue: 0.70)
    static let clinicIconBlue    = Color(red: 0.07, green: 0.45, blue: 0.90)

    // Semantic — auto adaptive for Dark Mode
    static let clinicSurface       = Color(.systemBackground)
    static let clinicSurfaceSecond = Color(.secondarySystemBackground)
    static let clinicFieldBg       = Color(.systemGray6)
    static let clinicSeparator     = Color(.separator)
    static let clinicSubtitle      = Color(.secondaryLabel)
    
}

extension Font {
    static let navTitleSize: Font = .system(size: 34, weight: .semibold)
}

// MARK: - Icon Gradient

extension LinearGradient {
    /// Teal → blue gradient used on the shield app icon.
    static var clinicIcon: LinearGradient {
        LinearGradient(
            colors: [Color.clinicIconTeal, Color.clinicIconBlue],
            startPoint: .bottomLeading,
            endPoint: .topTrailing
        )
    }
}

// MARK: - Spacing Scale

enum AppSpacing {
    static let xxs:  CGFloat =  4
    static let xs:   CGFloat =  8
    static let sm:   CGFloat = 12
    static let md:   CGFloat = 16
    static let lg:   CGFloat = 24
    static let xl:   CGFloat = 32
    static let xxl:  CGFloat = 48
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
    static let minTapTarget:   CGFloat = 44
    static let buttonPrimary:  CGFloat = 54
    static let buttonSecond:   CGFloat = 50
    static let fieldHeight:    CGFloat = 54
    static let iconField:      CGFloat = 20
    static let logoOnboarding: CGFloat = 88
    static let logoAuth:       CGFloat = 72
    static let logoWelcome:    CGFloat = 80
}
