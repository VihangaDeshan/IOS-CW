//
//  AboutView.swift
//  IOS Clinic App
//

import SwiftUI

struct AboutView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var showTerms = false

    private let appVersion  = "1.0.0"
    private let buildNumber = "2026.03.12"

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.sm) {
                        appIdentityCard
                            .padding(.top, AppSpacing.md)

                        descriptionCard

                        infoCard

                        linksCard

                        contactCard

                        copyrightNote
                            .padding(.bottom, AppSpacing.xxxl)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showTerms) {
            TermsAndConditionsView()
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("About")
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

    // MARK: - App Identity Card

    private var appIdentityCard: some View {
        VStack(spacing: AppSpacing.md) {
            // App Icon
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.xl)
                    .fill(LinearGradient.clinicIcon)
                    .frame(width: 88, height: 88)
                    .shadow(color: Color.clinicIconBlue.opacity(0.35), radius: 16, x: 0, y: 8)
                Image(systemName: "cross.fill")
                    .font(.system(size: 38, weight: .medium))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text("ClinicFlow")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)

                HStack(spacing: AppSpacing.xs) {
                    Text("Version \(appVersion)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 4)
                        .background(Color.clinicPrimary.opacity(0.10), in: Capsule())

                    Text("Build \(buildNumber)")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(.secondaryLabel))
                        .padding(.horizontal, AppSpacing.sm)
                        .padding(.vertical, 4)
                        .background(Color(.systemGray6), in: Capsule())
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
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

    // MARK: - Description Card

    private var descriptionCard: some View {
        cardContainer {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                rowIcon("info.circle.fill", label: "About ClinicFlow")
                Text("ClinicFlow is your all-in-one clinic companion — designed to make healthcare more accessible, organised, and transparent. Book appointments, track your queue status, view prescriptions, check lab results, and manage your family's health records from the palm of your hand.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - App Info Card

    private var infoCard: some View {
        cardContainer {
            VStack(spacing: 0) {
                infoRow(icon: "app.badge.fill",      color: Color.clinicPrimary,  label: "App Name",   value: "ClinicFlow")
                Divider().padding(.horizontal, AppSpacing.xs)
                infoRow(icon: "number.square.fill",  color: .purple,              label: "Version",    value: appVersion)
                Divider().padding(.horizontal, AppSpacing.xs)
                infoRow(icon: "hammer.fill",         color: .orange,              label: "Build",      value: buildNumber)
                Divider().padding(.horizontal, AppSpacing.xs)
                infoRow(icon: "iphone",              color: .blue,                label: "Platform",   value: "iOS 17+")
                Divider().padding(.horizontal, AppSpacing.xs)
                infoRow(icon: "globe",               color: .teal,                label: "Language",   value: "English")
                Divider().padding(.horizontal, AppSpacing.xs)
                infoRow(icon: "calendar",            color: .red,                 label: "Released",   value: "March 2026")
            }
        }
    }

    // MARK: - Links Card

    private var linksCard: some View {
        cardContainer {
            VStack(spacing: 0) {
                Button {
                    showTerms = true
                } label: {
                    linkRow(icon: "doc.text.fill", color: Color.clinicPrimary, label: "Terms & Conditions")
                }
                .buttonStyle(.plain)

                Divider().padding(.horizontal, AppSpacing.xs)

                linkRow(icon: "lock.shield.fill",   color: .indigo,   label: "Privacy Policy")
                Divider().padding(.horizontal, AppSpacing.xs)
                linkRow(icon: "questionmark.circle.fill", color: .teal, label: "Help & Support")
            }
        }
    }

    // MARK: - Contact Card

    private var contactCard: some View {
        cardContainer {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                rowIcon("phone.fill", label: "Contact Us")
                VStack(spacing: AppSpacing.xs) {
                    contactItem(icon: "envelope",   text: "support@clinicflow.com")
                    contactItem(icon: "phone",       text: "+94 740 458 767")
                    contactItem(icon: "location",    text: "No. 42, Hospital Road, Colombo 10")
                }
            }
        }
    }

    // MARK: - Copyright

    private var copyrightNote: some View {
        VStack(spacing: 4) {
            Text("Made with ♥ for better healthcare")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.clinicPrimary)
            Text("© 2026 ClinicFlow. All rights reserved.")
                .font(.system(size: 12))
                .foregroundStyle(Color(.tertiaryLabel))
        }
        .multilineTextAlignment(.center)
        .padding(.top, AppSpacing.sm)
    }

    // MARK: - Helpers

    private func cardContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
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

    private func rowIcon(_ systemName: String, label: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: systemName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.clinicPrimary)
            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
        }
    }

    private func infoRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(color.opacity(0.12))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, AppSpacing.sm)
    }

    private func linkRow(icon: String, color: Color, label: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .fill(color.opacity(0.12))
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color(.systemGray3))
        }
        .padding(.vertical, AppSpacing.sm)
    }

    private func contactItem(icon: String, text: String) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(Color.clinicPrimary)
                .frame(width: 18)
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AboutView()
    }
}
