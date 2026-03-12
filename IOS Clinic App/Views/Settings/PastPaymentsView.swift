//
//  PastPaymentsView.swift
//  IOS Clinic App
//
//  Shows the user's past payment history.
//

import SwiftUI

// MARK: - Model

struct PastPayment: Identifiable {
    let id = UUID()
    let date: String
    let time: String
    let doctor: String
    let specialization: String
    let items: [String]
    let total: Double
    let method: String
    let status: PaymentStatus

    enum PaymentStatus {
        case paid, pending, failed
        var label: String {
            switch self { case .paid: "Paid"; case .pending: "Pending"; case .failed: "Failed" }
        }
        var color: Color {
            switch self { case .paid: .green; case .pending: .orange; case .failed: .red }
        }
        var icon: String {
            switch self { case .paid: "checkmark.circle.fill"; case .pending: "clock.fill"; case .failed: "xmark.circle.fill" }
        }
    }
}

// MARK: - View

struct PastPaymentsView: View {

    @Environment(\.dismiss) private var dismiss

    private let payments: [PastPayment] = [
        PastPayment(
            date: "Mar 10, 2026", time: "10:30 AM",
            doctor: "Dr. Namal Balahewa", specialization: "Cardiologist",
            items: ["Consultation Fee", "ECG Test"],
            total: 4500.00, method: "Apple Pay", status: .paid
        ),
        PastPayment(
            date: "Feb 22, 2026", time: "2:15 PM",
            doctor: "Dr. Chandana Perera", specialization: "General Physician",
            items: ["Consultation Fee", "Blood Test"],
            total: 2800.00, method: "Credit Card ....4256", status: .paid
        ),
        PastPayment(
            date: "Feb 5, 2026", time: "9:00 AM",
            doctor: "Dr. Jayantha Kumara", specialization: "Neurologist",
            items: ["Consultation Fee"],
            total: 3200.00, method: "Apple Pay", status: .paid
        ),
        PastPayment(
            date: "Jan 18, 2026", time: "11:45 AM",
            doctor: "Dr. Namal Balahewa", specialization: "Cardiologist",
            items: ["Consultation Fee", "X-Ray", "Echo"],
            total: 8750.00, method: "Credit Card ....4256", status: .paid
        ),
        PastPayment(
            date: "Jan 3, 2026", time: "3:00 PM",
            doctor: "Dr. Chandana Perera", specialization: "General Physician",
            items: ["Consultation Fee"],
            total: 1500.00, method: "Apple Pay", status: .failed
        ),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    // Summary strip
                    summaryStrip
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)

                    // Payment cards
                    ForEach(payments) { payment in
                        PaymentHistoryCard(payment: payment)
                            .padding(.horizontal, AppSpacing.lg)
                    }
                }
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .background(Color(.systemBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // MARK: - Header

    private var header: some View {
        ZStack {
            Text("Payment History")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                }
                Spacer()
            }
            .padding(.leading, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Summary strip

    private var summaryStrip: some View {
        let paid = payments.filter { $0.status == .paid }
        let totalSpent = paid.reduce(0) { $0 + $1.total }

        return HStack(spacing: 0) {
            summaryTile(
                icon: "creditcard.fill",
                label: "Total Spent",
                value: "LKR \(String(format: "%.0f", totalSpent))"
            )
            Divider().frame(height: 36)
            summaryTile(
                icon: "checkmark.seal.fill",
                label: "Completed",
                value: "\(paid.count) visits"
            )
            Divider().frame(height: 36)
            summaryTile(
                icon: "calendar",
                label: "Last Visit",
                value: paid.first?.date ?? "—"
            )
        }
        .padding(.vertical, AppSpacing.md)
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
    }

    private func summaryTile(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Color.clinicPrimary)
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Payment History Card

private struct PaymentHistoryCard: View {

    let payment: PastPayment
    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Main row
            Button { withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) { expanded.toggle() } } label: {
                HStack(alignment: .top, spacing: AppSpacing.md) {

                    // Status icon circle
                    ZStack {
                        Circle()
                            .fill(payment.status.color.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: payment.status.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(payment.status.color)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(payment.doctor)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Text(payment.specialization)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 11))
                            Text("\(payment.date)  •  \(payment.time)")
                                .font(.system(size: 12))
                        }
                        .foregroundStyle(Color(.tertiaryLabel))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("LKR \(String(format: "%.2f", payment.total))")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.clinicPrimary)
                        Text(payment.status.label)
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(payment.status.color.opacity(0.12), in: Capsule())
                            .foregroundStyle(payment.status.color)
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                }
                .padding(AppSpacing.md)
            }
            .buttonStyle(.plain)

            // Expandable detail
            if expanded {
                Divider()
                    .padding(.horizontal, AppSpacing.md)

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    // Bill breakdown
                    Text("Bill Breakdown")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)

                    ForEach(payment.items, id: \.self) { item in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 5))
                                .foregroundStyle(Color(.tertiaryLabel))
                            Text(item)
                                .font(.system(size: 14))
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                    }

                    Divider()

                    // Payment method
                    HStack {
                        Image(systemName: "creditcard")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.clinicPrimary)
                        Text("Paid via")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Text(payment.method)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primary)
                        Spacer()
                        Text("LKR \(String(format: "%.2f", payment.total))")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(Color.clinicPrimary)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
                .padding(.bottom, AppSpacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
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
    }
}

#Preview {
    NavigationStack {
        PastPaymentsView()
    }
}
