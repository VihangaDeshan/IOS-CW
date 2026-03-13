//
//  PharmacyConfirmationView.swift
//  IOS Clinic App
//
//  "Prescription Sent" success screen — shown after tapping "Send to Pharmacy"
//

import SwiftUI

struct PharmacyConfirmationView: View {

    @Environment(\.dismiss) private var dismiss

    private let statusItems: [String] = [
        "Your prescription has been sent to the pharmacy.",
        "Status: Preparing Medicines",
        "Pickup Time: ~20 minutes",
        "Counter: Pharmacy Desk 2",
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.xl) {
                        Spacer().frame(height: AppSpacing.xl)

                        // ── Icon ──────────────────────────────────────────
                        Image(systemName: "calendar.badge.checkmark")
                            .font(.app(size: 72, weight: .light))
                            .foregroundStyle(Color.clinicPrimary)
                            .padding(.bottom, AppSpacing.sm)

                        // ── Title ─────────────────────────────────────────
                        Text("Prescription Sent")
                            .font(.app(size: 26, weight: .bold))
                            .foregroundStyle(.primary)

                        // ── Status card ───────────────────────────────────
                        VStack(spacing: 0) {
                            ForEach(statusItems.indices, id: \.self) { i in
                                HStack(alignment: .top, spacing: AppSpacing.md) {
                                    Image(systemName: "checkmark")
                                        .font(.app(size: 13, weight: .semibold))
                                        .foregroundStyle(Color.clinicPrimary)
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .padding(.top, 1)

                                    Text(statusItems[i])
                                        .font(.app(size: 14))
                                        .foregroundStyle(.primary)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Spacer()
                                }
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.vertical, AppSpacing.md)

                                if i < statusItems.count - 1 {
                                    Divider()
                                        .padding(.horizontal, AppSpacing.lg)
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.lg)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        .padding(.horizontal, AppSpacing.lg)

                        Spacer()
                    }
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Pharmacy")
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
                            .font(.app(size: 14, weight: .semibold))
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
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PharmacyConfirmationView()
    }
}
