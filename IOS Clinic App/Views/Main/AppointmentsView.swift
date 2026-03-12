//
//  AppointmentsView.swift
//  IOS Clinic App
//
//  Full appointments list with filtered tabs:
//  All · Ongoing · Upcoming · Completed · Cancelled
//

import SwiftUI

// MARK: - Model

enum AppointmentStatus: String, CaseIterable {
    case all       = "All"
    case ongoing   = "Ongoing"
    case upcoming  = "Upcoming"
    case completed = "Completed"
    case cancelled = "Cancelled"

    var color: Color {
        switch self {
        case .all:       return .primary
        case .ongoing:   return Color(red: 0.98, green: 0.60, blue: 0.12)
        case .upcoming:  return Color(red: 0.15, green: 0.72, blue: 0.38)
        case .completed: return Color(red: 0.11, green: 0.49, blue: 0.98)
        case .cancelled: return Color(red: 0.92, green: 0.24, blue: 0.24)
        }
    }

    var shortLabel: String { rawValue }
}

struct Appointment: Identifiable {
    let id          = UUID()
    let number:     String   // e.g. "234"
    let patientTag: String   // e.g. "Myself"
    let date:       String
    let time:       String
    let room:       String
    let doctor:     String
    let status:     AppointmentStatus
}

// MARK: - View

struct AppointmentsView: View {

    @Environment(\.dismiss) private var dismiss
    var searchQuery: String = ""
    @State private var selectedFilter: AppointmentStatus = .all
    @State private var showReschedule = false

    private let appointments: [Appointment] = [
        Appointment(number: "234", patientTag: "Myself",    date: "2026.01.05", time: "12.30pm", room: "Room 3B", doctor: "Dr. Nimal Balahewa", status: .completed),
        Appointment(number: "134", patientTag: "",          date: "2026.01.05", time: "12.30pm", room: "Room 3B", doctor: "Dr. Nimal Balahewa", status: .ongoing),
        Appointment(number: "087", patientTag: "",          date: "2026.01.05", time: "12.30pm", room: "Room 3B", doctor: "Dr. Nimal Balahewa", status: .upcoming),
        Appointment(number: "056", patientTag: "",          date: "2026.01.04", time: "10.00am", room: "Room 1A", doctor: "Dr. Nimal Balahewa", status: .cancelled),
    ]

    private var filtered: [Appointment] {
        let byStatus = selectedFilter == .all ? appointments : appointments.filter { $0.status == selectedFilter }
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else { return byStatus }
        return byStatus.filter { $0.doctor.localizedCaseInsensitiveContains(searchQuery) }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Custom nav bar ────────────────────────────────────
                navBar

                // ── Filter pills ──────────────────────────────────────
                filterBar
                    .padding(.top, AppSpacing.sm)

                Divider()
                    .padding(.top, AppSpacing.sm)

                // ── Content ───────────────────────────────────────────
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // Section title
                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedFilter.rawValue)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                            if !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                                Text("Results for \"\(searchQuery)\"")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)
                        .padding(.bottom, AppSpacing.sm)

                        if filtered.isEmpty {
                            emptyState
                        } else {
                            ForEach(filtered) { appointment in
                                AppointmentCard(
                                    appointment: appointment,
                                    onReschedule: { showReschedule = true }
                                )
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.bottom, AppSpacing.md)
                            }
                        }
                    }
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showReschedule) {
            SpecializationView(isReschedule: true)
                .environment(\.onRescheduleComplete, {
                    showReschedule = false
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .switchToHomeTab, object: nil)
                        dismiss()
                    }
                })
        }
        .animation(.easeInOut(duration: 0.22), value: selectedFilter)
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Appointments")
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

    // MARK: - Filter Bar

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.xs) {
                ForEach(AppointmentStatus.allCases, id: \.self) { filter in
                    FilterPill(
                        label:      filter.shortLabel,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer().frame(height: AppSpacing.xxxl)
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 48))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color(.systemGray3))
            Text("No \(selectedFilter.rawValue) appointments")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Filter Pill

private struct FilterPill: View {
    let label:      String
    let isSelected: Bool
    let action:     () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? Color.clinicPrimary
                        : Color(.systemGray6),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - Appointment Card

private struct AppointmentCard: View {

    let appointment: Appointment
    let onReschedule: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {

            // ── Title row ───────────────────────────────────────────
            HStack(alignment: .top) {
                Text("#\(appointment.number) Appointment")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()

                // Patient tag (only "Myself" in All tab mostly)
                if !appointment.patientTag.isEmpty {
                    Text(appointment.patientTag)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }

                // Action icons for upcoming appointments
                if appointment.status == .upcoming {
                    HStack(spacing: AppSpacing.sm) {
                        Button { onReschedule() } label: {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.clinicPrimary)
                                .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        Image(systemName: "xmark.circle")
                            .font(.system(size: 18))
                            .foregroundStyle(Color(red: 0.92, green: 0.24, blue: 0.24))
                            .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                            .contentShape(Rectangle())
                    }
                }
            }

            // ── Info rows ───────────────────────────────────────────
            HStack {
                Text("Date \(appointment.date)")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Time \(appointment.time)")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            Text(appointment.room)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)

            // ── Doctor + Status row ─────────────────────────────────
            HStack {
                Text(appointment.doctor)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(appointment.status.rawValue)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(appointment.status.color)
            }
        }
        .padding(AppSpacing.md)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AppointmentsView()
    }
}
