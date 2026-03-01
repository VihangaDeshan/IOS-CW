//
//  QueueStatusView.swift
//  IOS Clinic App
//
//  Live queue status — navigated to from the Consultation step
//  in VisitProgressView when the patient taps the in-progress card.
//

import SwiftUI

struct QueueStatusView: View {

    @Environment(\.dismiss) private var dismiss

    // Queue data (would come from a real-time source in production)
    private let queueNumber  = "A-042"
    private let aheadCount   = 3
    private let totalAhead   = 8          // denominator for the progress bar
    private let room         = "Room 3B"
    private let doctor       = "Dr. Nimal Balahewa"
    private let estimatedWait = "15 Min"
    private let currentQueue = "A-039"

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Custom nav bar ────────────────────────────────────
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {

                        // ── Your number card ──────────────────────────
                        yourNumberCard

                        // ── Room + doctor ─────────────────────────────
                        roomCard

                        // ── Stats card ────────────────────────────────
                        statsCard

                        // ── Notification hint ─────────────────────────
                        notificationHint

                        // ── View Clinic Map button ─────────────────────
                        mapButton
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
            Text("Queue Status")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button {
                    dismiss()
                } label: {
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
            .padding(.leading, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Your Number Card

    private var yourNumberCard: some View {
        VStack(spacing: AppSpacing.md) {

            Text("Your Number")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)

            Text(queueNumber)
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.primary)

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)

                    let progress = max(0, CGFloat(totalAhead - aheadCount) / CGFloat(totalAhead))
                    Capsule()
                        .fill(Color.clinicPrimary)
                        .frame(width: geo.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, AppSpacing.lg)

            Text("\(aheadCount) people ahead of you")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xl)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Room Card

    private var roomCard: some View {
        VStack(spacing: 4) {
            Text(room)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)
            Text(doctor)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.lg)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Stats Card

    private var statsCard: some View {
        VStack(spacing: 0) {
            statRow(label: "Estimated Wait", value: estimatedWait, isFirst: true)
            Divider()
                .padding(.horizontal, AppSpacing.md)
            statRow(label: "Current Queue", value: currentQueue, isFirst: false)
        }
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    private func statRow(label: String, value: String, isFirst: Bool) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundStyle(.primary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
    }

    // MARK: - Notification Hint

    private var notificationHint: some View {
        HStack(alignment: .top, spacing: AppSpacing.sm) {
            Image(systemName: "bell.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color(.systemGray3))
                .padding(.top, 1)

            Text("You will receive a notification when its almost your turn")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, AppSpacing.xs)
    }

    // MARK: - Map Button

    private var mapButton: some View {
        Button { } label: {
            Text("View Clinic Map")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(Color.clinicPrimary, in: Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        QueueStatusView()
    }
}
