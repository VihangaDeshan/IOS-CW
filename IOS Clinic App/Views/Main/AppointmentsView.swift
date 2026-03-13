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
    let id: UUID
    let number:     String   // e.g. "234"
    let patientTag: String   // e.g. "Myself"
    let date:       String
    let time:       String
    let room:       String
    let doctor:     String
    let status:     AppointmentStatus
    
    init(
        id: UUID = UUID(),
        number: String,
        patientTag: String,
        date: String,
        time: String,
        room: String,
        doctor: String,
        status: AppointmentStatus
    ) {
        self.id = id
        self.number = number
        self.patientTag = patientTag
        self.date = date
        self.time = time
        self.room = room
        self.doctor = doctor
        self.status = status
    }
}

// MARK: - View

struct AppointmentsView: View {

    @Environment(\.dismiss) private var dismiss
    var searchQuery: String = ""
    var onReturnHome: (() -> Void)? = nil
    @State private var selectedFilter: AppointmentStatus = .all
    @State private var showReschedule = false
    
    // Cancellation Flow State
    @State private var showProcessingScreen = false
    @State private var appointmentToCancel: Appointment?

    @State private var appointments: [Appointment] = [
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
                    .padding(.horizontal, AppSpacing.xs)

                Divider()
                    .padding(.top, AppSpacing.sm)

                // ── Content ───────────────────────────────────────────
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // Section title
                        VStack(alignment: .leading, spacing: 2) {
                            Text(selectedFilter.rawValue)
                                .font(.app(size: 16, weight: .semibold))
                                .foregroundStyle(.primary)
                            if !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                                Text("Results for \"\(searchQuery)\"")
                                    .font(.app(size: 13))
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
                                    onReschedule: { showReschedule = true },
                                    onCancel: {
                                        appointmentToCancel = appointment
                                    }
                                )
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.bottom, AppSpacing.md)
                            }
                        }
                    }
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
            
            if showProcessingScreen {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    CancellationProcessingView {
                        showProcessingScreen = false
                        selectedFilter = .cancelled
                    }
                }
                .transition(.opacity)
                .zIndex(100)
            }
        }
        .navigationBarHidden(true)
        .sheet(item: $appointmentToCancel) { appointment in
            AppointmentCancellationView(
                appointment: appointment,
                onKeepAppointment: {
                    appointmentToCancel = nil
                },
                onConfirmCancellation: {
                    // Cancel Logic
                    cancelAppointment(appointment)
                    appointmentToCancel = nil
                    
                    // Show processing after sheet dismiss
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            showProcessingScreen = true
                        }
                    }
                }
            )
            .presentationDetents([.fraction(0.6)])
        }
        .navigationDestination(isPresented: $showReschedule) {
            SpecializationView(isReschedule: true)
                .environment(\.onRescheduleComplete, {
                    showReschedule = false
                    DispatchQueue.main.async {
                        onReturnHome?()
                        NotificationCenter.default.post(name: .switchToHomeTab, object: nil)
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
                            .font(.app(size: 14, weight: .semibold))
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
        Picker("Appointment Filter", selection: $selectedFilter) {
            ForEach(AppointmentStatus.allCases, id: \.self) { filter in
                Text(filter.shortLabel)
                    .tag(filter)
            }
        }
        .pickerStyle(.segmented)
        .scaleEffect(y: 1.2)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer().frame(height: AppSpacing.xxxl)
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.app(size: 48))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color(.systemGray3))
            Text("No \(selectedFilter.rawValue) appointments")
                .font(.app(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Logic

    private func cancelAppointment(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            var updatedAppointment = appointment
            // Create a new copy with updated status since it's a struct
            updatedAppointment = Appointment(
                id: appointment.id,
                number: appointment.number,
                patientTag: appointment.patientTag,
                date: appointment.date,
                time: appointment.time,
                room: appointment.room,
                doctor: appointment.doctor,
                status: .cancelled
            )
            appointments[index] = updatedAppointment
        }
    }
}

// MARK: - Appointment Card

private struct AppointmentCard: View {

    let appointment: Appointment
    let onReschedule: () -> Void
    var onCancel: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {

            // ── Title row ───────────────────────────────────────────
            HStack(alignment: .top) {
                Text("#\(appointment.number) Appointment")
                    .font(.app(size: 16, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()

                // Patient tag (only "Myself" in All tab mostly)
                if !appointment.patientTag.isEmpty {
                    Text(appointment.patientTag)
                        .font(.app(size: 13))
                        .foregroundStyle(.secondary)
                }

                // Action icons for upcoming appointments
                if appointment.status == .upcoming {
                    HStack(spacing: AppSpacing.sm) {
                        Button { onReschedule() } label: {
                            Image(systemName: "calendar.badge.plus")
                                .font(.app(size: 18))
                                .foregroundStyle(Color.clinicPrimary)
                                .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        Button { onCancel?() } label: {
                            Image(systemName: "xmark.circle")
                                .font(.app(size: 18))
                                .foregroundStyle(Color(red: 0.92, green: 0.24, blue: 0.24))
                                .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // ── Info rows ───────────────────────────────────────────
            HStack {
                Text("Date \(appointment.date)")
                    .font(.app(size: 13))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Time \(appointment.time)")
                    .font(.app(size: 13))
                    .foregroundStyle(.secondary)
            }

            Text(appointment.room)
                .font(.app(size: 13))
                .foregroundStyle(.secondary)

            // ── Doctor + Status row ─────────────────────────────────
            HStack {
                Text(appointment.doctor)
                    .font(.app(size: 13))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(appointment.status.rawValue)
                    .font(.app(size: 13, weight: .semibold))
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
