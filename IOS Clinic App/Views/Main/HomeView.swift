//
//  HomeView.swift
//  IOS Clinic App
//
//  Main dashboard — scrollable home tab.
//  Sections: greeting · hero banner · search · appointments · services · doctor suggestions
//

import SwiftUI
import Combine

// MARK: - Home View

struct HomeView: View {

    @State private var searchText        = ""
    @State private var showVisitProgress  = false
    @State private var showAppointments   = false
    @State private var showAlerts         = false
    @FocusState private var isSearchFocused: Bool

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
                    HeroCarouselView()
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
            .onTapGesture {
                    isSearchFocused = false
                }
                // ────────────────────────────────────────────────────────
               
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity)
            .navigationDestination(isPresented: $showVisitProgress) {
                VisitProgressView()
            }
            .navigationDestination(isPresented: $showAppointments) {
                AppointmentsView()
            }
            .navigationDestination(isPresented: $showAlerts) {
                AlertsView()
            }
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
            Button { showAlerts = true } label: {
                Image(systemName: "bell")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Hero Banner

    struct HeroCarouselView: View {
        @State private var currentIndex = 0
        private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
        
        // Define your 3 banners here
        let banners = [
            (title: "Book Your\nAppointment\nToday !", color1: Color(red: 0.62, green: 0.88, blue: 0.95), color2: Color(red: 0.78, green: 0.93, blue: 0.98)),
            (title: "Check Your\nHealth Report\nOnline", color1: Color(red: 0.95, green: 0.80, blue: 0.80), color2: Color(red: 0.98, green: 0.88, blue: 0.88)),
            (title: "Consult with\nTop Specialists\nNow", color1: Color(red: 0.80, green: 0.95, blue: 0.85), color2: Color(red: 0.88, green: 0.98, blue: 0.92))
        ]

        var body: some View {
            TabView(selection: $currentIndex) {
                ForEach(0..<banners.count, id: \.self) { index in
                    heroBannerContent(title: banners[index].title, c1: banners[index].color1, c2: banners[index].color2)
                        .tag(index)
                }
            }
            .frame(height: 160) // Slightly taller to accommodate pagination dots
            .tabViewStyle(.page(indexDisplayMode: .always))
            .onReceive(timer) { _ in
                withAnimation(.linear(duration: 2.0)) {
                    currentIndex = (currentIndex + 1) % banners.count
                }
            }
        }

        // This is your original banner UI, now modular
        private func heroBannerContent(title: String, c1: Color, c2: Color) -> some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(LinearGradient(colors: [c1, c2], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 150)

                HStack {
                    Spacer()
                    Image(systemName: "stethoscope")
                        .font(.system(size: 72, weight: .light))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color.blue.opacity(0.15))
                        .padding(.trailing, AppSpacing.lg)
                }

                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color(red: 0.07, green: 0.25, blue: 0.45))
                        .lineSpacing(2)

                    Button { } label: {
                        Text("Book")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.vertical, AppSpacing.xs)
                            .background(Color.blue, in: Capsule())
                    }
                }
                .padding(.leading, AppSpacing.lg)
            }
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
                .focused($isSearchFocused) // Track focus here

            // Conditional Navigatable Icon
            if isSearchFocused {
                Button {
                    // Action for the arrow (e.g., submit search)
                    isSearchFocused = false
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.clinicPrimary) // Replace with your color
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 44)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.xl))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearchFocused)
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, action: String?) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.primary)
            Spacer()
            if let action {
                Button {
                    if action == "See All" { showAppointments = true }
                } label: {
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
                Image("dr_jayantha") // Your asset name
                    .resizable()
                    .scaledToFill()
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1)) // Optional border
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

                    Button {
                        showVisitProgress = true
                    } label: {
                        Text("Check in")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, 5)
                            .background(Color.clinicPrimary, in: Capsule())
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
        
    ]
    
    

    private var servicesGrid: some View {
        // 1. Wrap in a horizontal ScrollView
        ScrollView(.horizontal, showsIndicators: false) {
            // 2. Change to LazyHGrid
            LazyHGrid(
                // 3. Columns become 'rows' in an HGrid. Use one flexible row for a single line.
                rows: [GridItem(.flexible())],
                spacing: AppSpacing.md
            ) {
                ForEach(services, id: \.label) { service in
                    if service.label == "Laboratory" {
                        NavigationLink {
                            LabReportsView()
                        } label: {
                            ServiceCell(icon: service.icon, label: service.label, color: service.color)
                                .frame(width: 100)
                        }
                        .buttonStyle(.plain)
                    } else if service.label == "Queue" {
                        NavigationLink {
                            QueueStatusView()
                        } label: {
                            ServiceCell(icon: service.icon, label: service.label, color: service.color)
                                .frame(width: 100)
                        }
                        .buttonStyle(.plain)
                    } else if service.label == "Prescriptions" {
                        NavigationLink {
                            PrescriptionListView()
                        } label: {
                            ServiceCell(icon: service.icon, label: service.label, color: service.color)
                                .frame(width: 100)
                        }
                        .buttonStyle(.plain)
                    } else {
                        ServiceCell(icon: service.icon, label: service.label, color: service.color)
                            .frame(width: 100)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.xs) // Match your app's side padding
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
                    ZStack {
                        Image("dr_namal") // Your asset name
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1)) // Optional border
                    }
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
