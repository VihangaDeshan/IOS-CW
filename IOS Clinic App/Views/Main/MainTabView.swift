//
//  MainTabView.swift
//  IOS Clinic App
//
//  Root tab shell after login.
//  Tabs: Home · Book · Map · User · Setting
//

import SwiftUI

// import new settings screen
import Foundation

struct MainTabView: View {

    @Environment(AppRouter.self) private var router
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            // Home — guest sees stripped-down GuestHomeView
            Group {
                if router.isGuest {
                    GuestHomeView()
                } else {
                    HomeView()
                }
            }
            .tabItem {
                Label("Home", systemImage: selectedTab == 0 ? "house.fill" : "house")
            }
            .tag(0)

            // Book — guests blocked
            Group {
                if router.isGuest {
                    NavigationStack { LoginRequiredView() }
                } else {
                    BookView(selectedTab: $selectedTab)
                }
            }
            .tabItem {
                Label("Book", systemImage: selectedTab == 1 ? "calendar.badge.plus" : "calendar")
            }
            .tag(1)

            // Map — always available
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(2)

            // Account — guests blocked
            Group {
                if router.isGuest {
                    NavigationStack { LoginRequiredView() }
                } else {
                    NavigationStack { ManageMembersView() }
                }
            }
            .tabItem {
                Label("User", systemImage: selectedTab == 3 ? "person.fill" : "person")
            }
            .tag(3)

            // Settings — guests blocked
            Group {
                if router.isGuest {
                    NavigationStack { LoginRequiredView() }
                } else {
                    NavigationStack { SettingsView() }
                }
            }
            .tabItem {
                Label("Setting", systemImage: selectedTab == 4 ? "gearshape.fill" : "gearshape")
            }
            .tag(4)
        }
        .tint(Color.clinicPrimary)
        .onReceive(NotificationCenter.default.publisher(for: .bookingSuccess)) { _ in
            selectedTab = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: .switchToHomeTab)) { _ in
            selectedTab = 0
        }
    }
}

// MARK: - Placeholder tabs

struct BookView: View {
    @Binding var selectedTab: Int
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            SpecializationView()
        }
        .onReceive(NotificationCenter.default.publisher(for: .bookingSuccess)) { _ in
            // clear navigation stack when coming back
            path = NavigationPath()
        }
    }
}
struct MapView: View {
    var body: some View { ClinicMapView() }
}
struct UserView: View {
    var body: some View { PlaceholderTabView(title: "User Profile", icon: "person.circle.fill") }
}

private struct PlaceholderTabView: View {
    let title: String
    let icon:  String
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.app(size: 56))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color.clinicPrimary)
                Text(title)
                    .font(.title3.bold())
                Text("Coming soon")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(AppRouter())
}
