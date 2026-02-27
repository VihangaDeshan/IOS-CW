//
//  HomeView.swift
//  IOS Clinic App
//
//  Main dashboard — scrollable home tab.
//  Sections: greeting · hero banner · search · appointments · services · doctor suggestions
//

import SwiftUI

// MARK: - Home View

struct HomeView: View {

    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // ── Greeting header ───────────────────────────────────
                    greetingHeader
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        .padding(.bottom, AppSpacing.lg)

                    // ── Hero banner ───────────────────────────────────────
                    heroBanner
                        .padding(.horizontal, AppSpacing.lg)

                    // ── Search bar ────────────────────────────────────────
                    searchBar
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)

                    // ── My Appointments ───────────────────────────────────
                    sectionHeader(title: "My Appointments", action: "See All")
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    appointmentCard
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)

                    // ── Services ──────────────────────────────────────────
                    sectionHeader(title: "Services", action: nil)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    servicesGrid
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)

                    // ── Doctor's Suggestions ──────────────────────────────
                    sectionHeader(title: "Doctor's Suggestions", action: nil)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    doctorSuggestionsCard
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)
                        .padding(.bottom, AppSpacing.xxxl)
                }
            }
            .background(Color.clinicSurface.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    // MARK: - Greeting Header

    private var greetingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Hello, Kasun")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.primary)
            }
            Spacer()
            Button { } label: {
                Image(systemName: "bell")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Hero Banner

    private var heroBanner: some View {
        ZStack(alignment: .leading) {
            // Gradient background
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.62, green: 0.88, blue: 0.95),
                            Color(red: 0.78, green: 0.93, blue: 0.98)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 150)

            // Doctor silhouette on the right
            HStack {
                Spacer()
                Image(systemName: "stethoscope")
                    .font(.system(size: 72, weight: .light))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color(red: 0.07, green: 0.45, blue: 0.90).opacity(0.25))
                    .padding(.trailing, AppSpacing.lg)
            }

            // Text + button
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Book Your\nAppointment\nToday !")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(Color(red: 0.07, green: 0.25, blue: 0.45))
                    .lineSpacing(2)

                Button { } label: {
                    Text("Book Now")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.vertical, AppSpacing.xs)
                        .background(Color.clinicPrimary, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.leading, AppSpacing.lg)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color(.tertiaryLabel))

            TextField("Find the right doctor for you", text: $searchText)
                .font(.system(size: 15))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 44)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.xl))
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, action: String?) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.primary)
            Spacer()
            if let action {
                Button { } label: {
                    Text(action)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Appointment Card

    private var appointmentCard: some View {
        HStack(spacing: AppSpacing.md) {
            // Doctor avatar
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 56, height: 56)
                Image(systemName: "person.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(.systemGray2))
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text("Dr. Jayantha Udupitiya")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("Mar 15, 2026")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)

                HStack(spacing: AppSpacing.lg) {
                    Text("9:41 AM")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)

                    Button { } label: {
                        Text("Check in")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.clinicPrimary)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .padding(AppSpacing.md)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    // MARK: - Services Grid

    private let services: [(icon: String, label: String, color: Color)] = [
        ("flask.fill",         "Laboratory",    Color(red: 0.29, green: 0.56, blue: 0.89)),
        ("pills.fill",         "Prescriptions", Color(red: 0.55, green: 0.35, blue: 0.96)),
        ("person.3.fill",      "Queue",         Color(red: 0.22, green: 0.71, blue: 0.64)),
        ("heart.text.clipboard.fill", "Records", Color(red: 0.93, green: 0.42, blue: 0.36)),
        ("video.fill",         "Telemedicine",  Color(red: 0.25, green: 0.74, blue: 0.48)),
        ("creditcard.fill",    "Payments",      Color(red: 0.96, green: 0.62, blue: 0.19)),
    ]

    private var servicesGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: AppSpacing.md
        ) {
            ForEach(services, id: \.label) { service in
                ServiceCell(icon: service.icon, label: service.label, color: service.color)
            }
        }
    }

    // MARK: - Doctor Suggestions Card

    private var doctorSuggestionsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {

            // Doctor info row
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 50, height: 50)
                    Image(systemName: "person.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(.systemGray2))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Dr. Namal Balahewa")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Specialist-Lungs")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }

            // Suggestions text box
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                SuggestionLine(text: "Complete full medication course & steam therapy as directed.")
                SuggestionLine(text: "Prioritize rest and warm fluids; avoid dust exposure.")
                SuggestionLine(text: "Complete required tests before Feb 21 follow-up.")
                SuggestionLine(text: "Urgent: Return immediately for difficulty breathing, chest pain, or high fever.")
            }
            .padding(AppSpacing.md)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.md))
        }
        .padding(AppSpacing.md)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Service Cell

private struct ServiceCell: View {
    let icon:  String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(color.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

// MARK: - Suggestion Line

private struct SuggestionLine: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 14))
            .foregroundStyle(.primary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    MainTabView()
}
