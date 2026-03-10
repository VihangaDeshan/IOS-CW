//
//  VisitProgressView.swift
//  IOS Clinic App
//
//  Visit queue progress screen — shown when patient taps "Check in".
//  Timeline: Registration ✓ → Consultation (active) → Laboratory → Pharmacy → Payment
//

import SwiftUI

// MARK: - Data Model

private enum StepStatus {
    case completed
    case inProgress
    case pending
}

private struct VisitStep: Identifiable {
    let id       = UUID()
    let title:   String
    let subtitle: String
    let status:  StepStatus
    let nextAction: String?          // shown only for in-progress step
}

// MARK: - View

struct VisitProgressView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var showQueueStatus    = false
    @State private var showPrescriptions  = false

    private let steps: [VisitStep] = [
        VisitStep(
            title:      "Registration",
            subtitle:   "Completed at 9:15 AM",
            status:     .completed,
            nextAction: nil
        ),
        VisitStep(
            title:      "Consultation",
            subtitle:   "In Progress — Room 3B",
            status:     .inProgress,
            nextAction: "Please proceed to Room 3B\nDr. Nimal Balahewa"
        ),
        VisitStep(
            title:      "Laboratory",
            subtitle:   "Pending",
            status:     .pending,
            nextAction: nil
        ),
        VisitStep(
            title:      "Pharmacy",
            subtitle:   "Pending",
            status:     .pending,
            nextAction: nil
        ),
        VisitStep(
            title:      "Payment",
            subtitle:   "Pending",
            status:     .pending,
            nextAction: nil
        ),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Custom nav bar ────────────────────────────────────────
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {

                        // ── Queue number card ─────────────────────────────
                        queueCard

                        // ── Timeline ──────────────────────────────────────
                        timelineSection
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showQueueStatus) {
            QueueStatusView()
        }
        .navigationDestination(isPresented: $showPrescriptions) {
            PrescriptionListView()
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Visit Progress")
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

    // MARK: - Queue Card

    private var queueCard: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Your Queue Number")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)

            Text("A-042")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.primary)
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

    // MARK: - Timeline Section

    private var timelineSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                StepRowView(
                    step:       step,
                    stepNumber: index + 1,
                    isLast:     index == steps.count - 1,
                    onTap:      step.status == .inProgress ? { showQueueStatus = true }
                                  : step.title == "Pharmacy"   ? { showPrescriptions = true }
                                  : nil
                )
            }
        }
    }
}

// MARK: - Step Row

private struct StepRowView: View {

    let step:       VisitStep
    let stepNumber: Int
    let isLast:     Bool
    var onTap:      (() -> Void)? = nil

    // Estimated connector-line height based on content height
    private var lineHeight: CGFloat {
        switch step.status {
        case .inProgress: return 140   // taller due to next-action box
        case .completed:  return 72
        case .pending:    return 60
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {

            // ── Left column: circle + connector line ─────────────────
            VStack(spacing: 0) {
                stepCircle
                    .zIndex(1)

                if !isLast {
                    Rectangle()
                        .fill(Color.clinicPrimary.opacity(0.55))
                        .frame(width: 2)
                        .frame(height: lineHeight)
                }
            }
            .frame(width: 30)

            // ── Right column: card ────────────────────────────────────
            stepCard
                .padding(.bottom, isLast ? 0 : AppSpacing.xs)
                .contentShape(Rectangle())
                .onTapGesture { onTap?() }
        }
    }

    // MARK: Step circle

    @ViewBuilder
    private var stepCircle: some View {
        switch step.status {

        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(Color.clinicPrimary)
                .frame(width: 30, height: 30)

        case .inProgress:
            ZStack {
                Circle()
                    .strokeBorder(Color.clinicPrimary, lineWidth: 2.5)
                    .frame(width: 28, height: 28)
                Image(systemName: "arrow.2.circlepath")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.clinicPrimary)
            }
            .frame(width: 30, height: 30)

        case .pending:
            ZStack {
                Circle()
                    .fill(Color(.systemGray3))
                    .frame(width: 28, height: 28)
                Text("\(stepNumber)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 30, height: 30)
        }
    }

    // MARK: Step card

    private var stepCard: some View {
        let isActive  = step.status == .inProgress
        let isPending = step.status == .pending

        return VStack(alignment: .leading, spacing: AppSpacing.xs) {

            // Title
            Text(step.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(isPending ? Color(.systemGray) : .primary)

            // Subtitle
            Text(step.subtitle)
                .font(.system(size: 13))
                .foregroundStyle(isPending ? Color(.systemGray3) : .secondary)

            // Next action box — only for in-progress step
            if isActive, let action = step.nextAction {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Next Action:")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primary)
                        Spacer()
                        // Chevron hint — signals this card is tappable
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                    Text(action)
                        .font(.system(size: 13))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(AppSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.md))
                .padding(.top, AppSpacing.xs)
            }
        }
        .padding(.bottom, AppSpacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        VisitProgressView()
    }
}
