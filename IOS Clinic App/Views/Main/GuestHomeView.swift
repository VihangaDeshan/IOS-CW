//
//  GuestHomeView.swift
//  IOS Clinic App
//
//  Home dashboard for guest users — mirrors HomeView layout.
//  Unlocked: Visit Progress · Queue Status · Map
//  Locked tiles show LoginRequiredView.
//

import SwiftUI
import Combine

struct GuestHomeView: View {

    @Environment(AppRouter.self) private var router
    @State private var searchText        = ""
    @State private var showVisitProgress = false
    @State private var showLoginRequired = false
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
                    HomeView.HeroCarouselView()
                        .padding(.horizontal, AppSpacing.lg)

                    // ── Search bar ────────────────────────────────────────
                    searchBar
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)

                    // ── Guest info banner ─────────────────────────────────
                    guestBanner
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    // ── Visit Progress ────────────────────────────────────
                    sectionHeader(title: "My Visit", action: nil)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    visitProgressCard
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)

                    // ── Services ──────────────────────────────────────────
                    sectionHeader(title: "Services", action: nil)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    servicesGrid
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)

                    // ── Doctor's Suggestions (locked) ─────────────────────
                    sectionHeader(title: "Doctor's Suggestions", action: nil)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.xl)

                    lockedDoctorCard
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.sm)
                        .padding(.bottom, AppSpacing.xxxl)
                }
            }
            .background(Color.clinicSurface.ignoresSafeArea())
            .onTapGesture { isSearchFocused = false }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showVisitProgress) { VisitProgressView() }
            .navigationDestination(isPresented: $showLoginRequired) { LoginRequiredView() }
        }
    }

    // MARK: - Greeting Header

    private var greetingHeader: some View {
        HStack {
            Text("Hello, Guest")
                .font(.app(size: 26, weight: .bold))
                .foregroundStyle(.primary)
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "person.slash")
                    .font(.app(size: 12, weight: .medium))
                Text("Guest")
                    .font(.app(size: 12, weight: .medium))
            }
            .foregroundStyle(Color.clinicPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.clinicPrimary.opacity(0.10), in: Capsule())
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.app(size: 15, weight: .medium))
                .foregroundStyle(Color(.tertiaryLabel))
            TextField("Find the right doctor for you", text: $searchText)
                .font(.app(size: 15))
                .foregroundStyle(.primary)
                .focused($isSearchFocused)
            if isSearchFocused {
                Button { isSearchFocused = false } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.app(size: 22))
                        .foregroundStyle(Color.clinicPrimary)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 44)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.xl))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearchFocused)
    }

    // MARK: - Guest Banner

    private var guestBanner: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "info.circle.fill")
                .font(.app(size: 20))
                .foregroundStyle(Color.clinicPrimary)
            VStack(alignment: .leading, spacing: 2) {
                Text("You're browsing as a guest")
                    .font(.app(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("Sign in to unlock all features")
                    .font(.app(size: 13))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                router.isGuest = false
                router.navigate(to: .login)
            } label: {
                Text("Sign In")
                    .font(.app(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                    .background(Color.clinicPrimary, in: Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(AppSpacing.md)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.clinicPrimary.opacity(0.4), Color.clinicPrimary.opacity(0.1)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, action: String?) -> some View {
        HStack {
            Text(title)
                .font(.app(size: 18, weight: .bold))
                .foregroundStyle(.primary)
            Spacer()
            if let action {
                Text(action)
                    .font(.app(size: 14, weight: .medium))
                    .foregroundStyle(Color.clinicPrimary)
            }
        }
    }

    // MARK: - Visit Progress Card

    private var visitProgressCard: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color.clinicPrimary.opacity(0.12))
                    .frame(width: 56, height: 56)
                Image(systemName: "clock.arrow.2.circlepath")
                    .font(.app(size: 24))
                    .foregroundStyle(Color.clinicPrimary)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Visit")
                    .font(.app(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)
                Text("Queue number: A-042")
                    .font(.app(size: 13))
                    .foregroundStyle(.secondary)
                HStack(spacing: AppSpacing.lg) {
                    Text("In Progress")
                        .font(.app(size: 13, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                    Button { showVisitProgress = true } label: {
                        Text("Track")
                            .font(.app(size: 13, weight: .semibold))
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

    private let services: [(icon: String, label: String, color: Color, locked: Bool)] = [
        ("flask.fill",    "Laboratory",    Color(red: 0.29, green: 0.56, blue: 0.89), true),
        ("pills.fill",    "Prescriptions", Color(red: 0.55, green: 0.35, blue: 0.96), true),
        ("person.3.fill", "Queue",         Color(red: 0.22, green: 0.71, blue: 0.64), false),
    ]

    private var servicesGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())], spacing: AppSpacing.md) {
                ForEach(services, id: \.label) { svc in
                    if svc.locked {
                        Button { showLoginRequired = true } label: {
                            GuestLockedServiceCell(icon: svc.icon, label: svc.label, color: svc.color)
                                .frame(width: 100)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink { QueueStatusView() } label: {
                            GuestServiceCell(icon: svc.icon, label: svc.label, color: svc.color)
                                .frame(width: 100)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.xs)
        }
    }

    // MARK: - Locked Doctor Suggestions Card

    private var lockedDoctorCard: some View {
        Button { showLoginRequired = true } label: {
            ZStack {
                // Blurred skeleton
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    HStack(spacing: AppSpacing.md) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 50, height: 50)
                        VStack(alignment: .leading, spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray4))
                                .frame(width: 120, height: 13)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(width: 80, height: 11)
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(0..<3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(maxWidth: .infinity)
                                .frame(height: 11)
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.md))
                }
                .padding(AppSpacing.md)
                .background(Color.clinicSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .blur(radius: 3)

                // Lock overlay
                VStack(spacing: AppSpacing.sm) {
                    Image(systemName: "lock.fill")
                        .font(.app(size: 28))
                        .foregroundStyle(Color.clinicPrimary)
                    Text("Sign in to view suggestions")
                        .font(.app(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                }
                .padding(AppSpacing.lg)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppRadius.md))
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Unlocked Service Cell

private struct GuestServiceCell: View {
    let icon: String; let label: String; let color: Color
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(color.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.app(size: 22, weight: .medium))
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(color)
            }
            Text(label)
                .font(.app(size: 12, weight: .medium))
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

// MARK: - Locked Service Cell

private struct GuestLockedServiceCell: View {
    let icon: String; let label: String; let color: Color
    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(color.opacity(0.08))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.app(size: 22, weight: .medium))
                    .foregroundStyle(color.opacity(0.35))
                // Lock badge
                Image(systemName: "lock.fill")
                    .font(.app(size: 11, weight: .bold))
                    .foregroundStyle(Color(.systemGray3))
                    .offset(x: 16, y: 16)
            }
            Text(label)
                .font(.app(size: 12, weight: .medium))
                .foregroundStyle(Color(.systemGray3))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.sm)
        .background(Color.clinicSurface)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    GuestHomeView()
        .environment(AppRouter())
}
