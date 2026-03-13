//
//  AppointmentCancellationFlow.swift
//  IOS Clinic App
//
//  Flow for cancelling an appointment and showing confirmation/refund info.
//

import SwiftUI

// MARK: - Cancellation View

struct AppointmentCancellationView: View {
    let appointment: Appointment
    let onKeepAppointment: () -> Void
    let onConfirmCancellation: () -> Void

    @State private var selectedReason: String?
    let reasons = [
        "Scheduling conflict",
        "Found another doctor",
        "Wait time too long",
        "Treatment no longer needed",
        "Other"
    ]

    var body: some View {
        VStack(spacing: AppSpacing.lg) {

            // Header
            Text("Cancel Appointment")
                .font(.app(size: 20, weight: .bold))
                .padding(.top, AppSpacing.lg)

            Text("Are you sure you want to cancel your appointment with \(appointment.doctor)?")
                .font(.app(size: 16))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, AppSpacing.lg)

            // Reason Selection
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Please select a reason for cancellation:")
                    .font(.app(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, AppSpacing.lg)

                ForEach(reasons, id: \.self) { reason in
                    Button {
                        selectedReason = reason
                    } label: {
                        HStack {
                            Text(reason)
                                .font(.app(size: 16))
                                .foregroundStyle(.primary)
                            Spacer()
                            if selectedReason == reason {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(Color.clinicPrimary)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .background(Color.clinicSurface)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AppSpacing.lg)
                }
            }

            Spacer()

            // Actions
            VStack(spacing: AppSpacing.md) {
                PrimaryButton("Confirm Cancellation", isLoading: false) {
                    onConfirmCancellation()
                }
                .disabled(selectedReason == nil)
                .opacity(selectedReason == nil ? 0.6 : 1.0)

                Button("Keep Appointment") {
                    onKeepAppointment()
                }
                .font(.app(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
                .padding()
            }
            .padding(AppSpacing.lg)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Processing / Refund Info View

struct CancellationProcessingView: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.green)

            VStack(spacing: AppSpacing.sm) {
                Text("Appointment Cancelled")
                    .font(.app(size: 24, weight: .bold))

                Text("Your appointment has been successfully cancelled.")
                    .font(.app(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: AppSpacing.sm) {
                Text("Refund Processing")
                    .font(.app(size: 18, weight: .semibold))

                Text("A refund has been initiated and will be processed within 3-5 business days to your original payment method.")
                    .font(.app(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, AppSpacing.xl)
            }
            .padding()
            .background(Color.clinicSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .padding(.horizontal, AppSpacing.lg)

            Spacer()

            PrimaryButton("Back to Appointments") {
                onDismiss()
            }
            .padding(AppSpacing.lg)
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    AppointmentCancellationView(
        appointment: Appointment(number: "001", patientTag: "", date: "2026.01.01", time: "10:00", room: "Room 1", doctor: "Dr. Test", status: .upcoming),
        onKeepAppointment: {},
        onConfirmCancellation: {}
    )
}

#Preview("Processing") {
    CancellationProcessingView(onDismiss: {})
}
