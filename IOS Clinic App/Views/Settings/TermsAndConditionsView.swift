//
//  TermsAndConditionsView.swift
//  IOS Clinic App
//

import SwiftUI

// MARK: - Model

private struct TermsSection: Identifiable {
    let id    = UUID()
    let icon:  String
    let title: String
    let body:  String
}

// MARK: - View

struct TermsAndConditionsView: View {

    @Environment(\.dismiss) private var dismiss

    private let effectiveDate = "12 March 2026"

    private let sections: [TermsSection] = [
        TermsSection(
            icon:  "hand.raised.fill",
            title: "1. Acceptance of Terms",
            body:  "By downloading, installing, or using ClinicFlow ("the App"), you confirm that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree, please discontinue use of the App immediately. These terms apply to all visitors, users, and others who access or use the App."
        ),
        TermsSection(
            icon:  "iphone",
            title: "2. Use of the App",
            body:  "ClinicFlow is provided for personal, non-commercial use only. You agree not to misuse the App or help anyone else do so. Prohibited activities include, but are not limited to: attempting to gain unauthorised access to any part of the App or its connected systems, using automated tools to scrape or harvest data, and transmitting any harmful or fraudulent content."
        ),
        TermsSection(
            icon:  "cross.case.fill",
            title: "3. Medical Disclaimer",
            body:  "The information and services provided through ClinicFlow are intended to supplement — not replace — the advice of qualified healthcare professionals. Nothing in the App constitutes medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition. Never disregard professional medical advice because of something you have read in the App."
        ),
        TermsSection(
            icon:  "lock.shield.fill",
            title: "4. Privacy & Data",
            body:  "Your privacy is important to us. We collect and process personal data — including health-related information — strictly to provide the App's features and to improve your experience. Data is encrypted in transit and at rest. We do not sell your personal data to third parties. For full details on how we collect, use, and protect your data, please read our Privacy Policy available within the App settings."
        ),
        TermsSection(
            icon:  "person.fill.checkmark",
            title: "5. User Accounts & Responsibility",
            body:  "You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must immediately notify ClinicFlow of any unauthorised use of your account. We reserve the right to suspend or terminate accounts that violate these terms, engage in fraudulent activity, or pose a risk to other users or the App."
        ),
        TermsSection(
            icon:  "doc.badge.ellipsis",
            title: "6. Appointments & Bookings",
            body:  "Appointment bookings made through the App are subject to availability and confirmation by the relevant clinic or healthcare provider. ClinicFlow acts as an intermediary only and is not liable for missed, cancelled, or rescheduled appointments. Cancellation policies set by individual clinics or doctors apply independently of any terms stated here."
        ),
        TermsSection(
            icon:  "creditcard.fill",
            title: "7. Payments & Billing",
            body:  "All payments processed through ClinicFlow are handled via secure third-party payment gateways. Charges are clearly displayed before confirmation. Refund requests are subject to the individual clinic's refund policy. ClinicFlow is not responsible for pricing errors originating from third-party service providers. Receipts are available within the App under Payment History."
        ),
        TermsSection(
            icon:  "c.circle",
            title: "8. Intellectual Property",
            body:  "All content within the App — including text, graphics, logos, icons, and software — is the property of ClinicFlow or its content suppliers and is protected by applicable intellectual property laws. You may not reproduce, distribute, or create derivative works from any content in the App without our prior written permission."
        ),
        TermsSection(
            icon:  "exclamationmark.triangle.fill",
            title: "9. Limitation of Liability",
            body:  "To the maximum extent permitted by applicable law, ClinicFlow and its affiliates, officers, employees, agents, and licensors shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of, or inability to use, the App. Our total liability for any claims under these terms shall not exceed the amount you paid to us in the twelve months preceding the claim."
        ),
        TermsSection(
            icon:  "arrow.triangle.2.circlepath",
            title: "10. Changes to These Terms",
            body:  "We reserve the right to update or modify these Terms and Conditions at any time. When we make material changes, we will notify you through the App or via the email address associated with your account. Your continued use of the App after any such changes constitutes your acceptance of the new terms. We encourage you to review this page periodically."
        ),
        TermsSection(
            icon:  "envelope.fill",
            title: "11. Contact Us",
            body:  "If you have any questions, concerns, or requests regarding these Terms and Conditions, please contact us:\n\nClinicFlow Support Team\nEmail: legal@clinicflow.com\nPhone: +94 740 458 767\nAddress: No. 42, Hospital Road, Colombo 10, Sri Lanka\n\nWe aim to respond to all enquiries within 3 business days."
        ),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.sm) {
                        effectiveDateBadge
                            .padding(.top, AppSpacing.md)

                        ForEach(sections) { section in
                            sectionCard(section)
                        }

                        footerNote
                            .padding(.bottom, AppSpacing.xxxl)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Terms & Conditions")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 34, height: 34)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Effective Date Badge

    private var effectiveDateBadge: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "calendar")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.clinicPrimary)
            Text("Effective \(effectiveDate)")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.clinicPrimary)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.xs)
        .background(Color.clinicPrimary.opacity(0.08), in: Capsule())
        .padding(.horizontal, AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Section Card

    private func sectionCard(_ section: TermsSection) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Header row
            HStack(spacing: AppSpacing.sm) {
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(Color.clinicPrimary.opacity(0.10))
                        .frame(width: 36, height: 36)
                    Image(systemName: section.icon)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                }
                Text(section.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
            }

            // Body text
            Text(section.body)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.clinicPrimary.opacity(0.06), radius: 8, x: 0, y: 4)
        .padding(.horizontal, AppSpacing.lg)
    }

    // MARK: - Footer

    private var footerNote: some View {
        Text("By using ClinicFlow, you acknowledge that you have read and understood these Terms and Conditions.")
            .font(.system(size: 12))
            .foregroundStyle(Color(.tertiaryLabel))
            .multilineTextAlignment(.center)
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.sm)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TermsAndConditionsView()
    }
}
