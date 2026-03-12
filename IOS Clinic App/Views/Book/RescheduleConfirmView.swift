//
//  RescheduleConfirmView.swift
//  IOS Clinic App
//
//  Success screen shown after a reschedule is confirmed.
//  No payment step — booking details are summarised with a checkmark.
//

import SwiftUI

struct RescheduleConfirmView: View {

    @Environment(\.dismiss) private var dismiss

    let doctor:     Doctor
    let dateString: String
    let timeString: String
    let member:     String

    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                Spacer()

                // ── Success graphic ───────────────────────────────────
                ZStack {
                    Circle()
                        .fill(Color.clinicPrimary.opacity(0.08))
                        .frame(width: 130, height: 130)
                    Circle()
                        .fill(Color.clinicPrimary.opacity(0.14))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                }
                .scaleEffect(appeared ? 1 : 0.4)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1), value: appeared)

                // ── Headline ──────────────────────────────────────────
                VStack(spacing: AppSpacing.xs) {
                    Text("Appointment Rescheduled!")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("Your appointment has been successfully rescheduled. No additional payment is required.")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.xl)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)
                .animation(.easeOut(duration: 0.4).delay(0.3), value: appeared)
                .padding(.top, AppSpacing.lg)

                // ── Details card ──────────────────────────────────────
                VStack(spacing: 0) {
                    detailRow(icon: "person.fill",      color: .blue,             label: "Doctor",   value: doctor.name)
                    Divider().padding(.horizontal, AppSpacing.md)
                    detailRow(icon: "stethoscope",       color: .teal,             label: "Specialty", value: doctor.specialization)
                    Divider().padding(.horizontal, AppSpacing.md)
                    detailRow(icon: "calendar",           color: Color.clinicPrimary, label: "New Date",  value: dateString)
                    Divider().padding(.horizontal, AppSpacing.md)
                    detailRow(icon: "clock.fill",         color: .orange,           label: "Time",     value: timeString.isEmpty ? "TBC" : timeString)
                    Divider().padding(.horizontal, AppSpacing.md)
                    detailRow(icon: "person.2.fill",      color: .purple,           label: "Patient",  value: member)
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(Color(.systemGray5), lineWidth: 1))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.45), value: appeared)

                // ── No payment notice ─────────────────────────────────
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(.green)
                    Text("No payment required for rescheduling")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.pill))
                .padding(.top, AppSpacing.lg)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.55), value: appeared)

                Spacer()

                // ── Done button ───────────────────────────────────────
                Button { dismiss() } label: {
                    Text("Done")
                        .font(Font.btnTitleSize)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(Color.clinicPrimary, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.35).delay(0.65), value: appeared)
            }
        }
        .navigationBarHidden(true)
        .onAppear { appeared = true }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Confirmation")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Detail Row

    private func detailRow(icon: String, color: Color, label: String, value: String) -> some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm + AppSpacing.xxs)
    }
}

#Preview {
    NavigationStack {
        RescheduleConfirmView(
            doctor:     Doctor(name: "Dr. Namal Udugoda", specialization: "Cardiologists", rating: 4.6, reviews: 106, imageName: "dr_namal"),
            dateString: "14 Thu",
            timeString: "14:00",
            member:     "Me"
        )
    }
}
