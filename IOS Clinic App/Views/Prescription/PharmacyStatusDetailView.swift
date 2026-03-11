//
//  PharmacyStatusDetailView.swift
//  IOS Clinic App
//
//  Pharmacy status detail — patient info, medicine status, counter, Proceed to Pay
//

import SwiftUI

// MARK: - Model

enum PharmacyStatus: String {
    case preparing    = "Preparing"
    case readyPickup  = "Ready To Pick-up"
    case finished     = "Finished"

    var color: Color {
        switch self {
        case .preparing:   return Color(red: 1.0, green: 0.60, blue: 0.0)
        case .readyPickup: return Color(red: 0.11, green: 0.49, blue: 0.98)
        case .finished:    return Color(red: 0.22, green: 0.71, blue: 0.38)
        }
    }
}

struct PharmacyOrder: Identifiable {
    let id              = UUID()
    let patientName:    String
    let patientID:      String
    let date:           String
    let doctorName:     String
    let specialization: String
    let status:         PharmacyStatus
    let counter:        String
}

extension PharmacyOrder {
    static let samples: [PharmacyOrder] = [
        PharmacyOrder(
            patientName:    "Vihanga Deshan",
            patientID:      "#123456",
            date:           "14 Feb 2026",
            doctorName:     "Dr. Namal Balahewa",
            specialization: "Specialization - Lungs",
            status:         .readyPickup,
            counter:        "Pharmacy Desk 02"
        ),
        PharmacyOrder(
            patientName:    "Vihanga Deshan",
            patientID:      "#173456",
            date:           "01 Mar 2025",
            doctorName:     "Dr. Namal Balahewa",
            specialization: "Specialization - Lungs",
            status:         .finished,
            counter:        "Pharmacy Desk 01"
        ),
    ]
}

// MARK: - Detail View

struct PharmacyStatusDetailView: View {

    let order: PharmacyOrder

    @Environment(\.dismiss) private var dismiss
    @State private var showPayment = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.md) {
                        patientCard
                        statusCard
                        if order.status != .finished {
                            proceedButton
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showPayment) {
            PaymentView()
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Pharmacy Status")
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

    // MARK: - Patient Info Card

    private var patientCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(order.patientName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
            Text("ID: \(order.patientID)")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(order.date)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(order.doctorName)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(order.specialization)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Status Card

    private var statusCard: some View {
        VStack(spacing: 0) {
            // Status row
            HStack {
                Text("Status")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(order.status.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(order.status.color)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, 4)
                    .background(order.status.color.opacity(0.12), in: Capsule())
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)

            Divider().padding(.horizontal, AppSpacing.lg)

            // Counter row
            HStack {
                Text("Counter")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(order.counter)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Proceed Button

    private var proceedButton: some View {
        Button { showPayment = true } label: {
            Text("Proceed to pay")
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
    NavigationStack {
        PharmacyStatusDetailView(order: PharmacyOrder.samples[0])
    }
}
