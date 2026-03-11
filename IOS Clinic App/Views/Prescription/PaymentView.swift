//
//  PaymentView.swift
//  IOS Clinic App
//
//  Payment screen — reached from Pharmacy Status "Proceed to pay"
//

import SwiftUI

struct PaymentView: View {

    @Environment(\.dismiss) private var dismiss

    private let amount = "LKR 2,450.00"
    private let items: [(label: String, value: String)] = [
        ("Amoxicillin 500mg × 21", "LKR 1,200.00"),
        ("Cough Syrup 100ml",       "LKR  850.00"),
        ("Consultation fee",        "LKR  400.00"),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.md) {
                        summaryCard
                        totalCard
                        payButton
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Payment")
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

    // MARK: - Summary Card

    private var summaryCard: some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { i in
                HStack {
                    Text(items[i].label)
                        .font(.system(size: 14))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text(items[i].value)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.md)

                if i < items.count - 1 {
                    Divider().padding(.horizontal, AppSpacing.lg)
                }
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Total Card

    private var totalCard: some View {
        HStack {
            Text("Total")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
            Spacer()
            Text(amount)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.clinicPrimary)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Pay Button

    private var payButton: some View {
        Button { } label: {
            Text("Confirm & Pay \(amount)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(Color.clinicPrimary, in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.top, AppSpacing.xs)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack { PaymentView() }
}
