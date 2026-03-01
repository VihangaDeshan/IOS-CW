//
//  MainTabView.swift
//  IOS Clinic App
//
//  Root tab shell after login.
//  Tabs: Home · Book · Map · User · Setting
//

import SwiftUI

struct MainTabView: View {

    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem {
                    Label("Home",    systemImage: selectedTab == 0 ? "house.fill"          : "house")
                }
                .tag(0)

            BookView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Book",    systemImage: selectedTab == 1 ? "calendar.badge.plus"  : "calendar")
                }
                .tag(1)

            MapView()
                .tabItem {
                    Label("Map",     systemImage: "map")
                }
                .tag(2)

            AccountView()
                .tabItem {
                    Label("User",    systemImage: selectedTab == 3 ? "person.fill"          : "person")
                }
                .tag(3)

            SettingView()
                .tabItem {
                    Label("Setting", systemImage: selectedTab == 4 ? "gearshape.fill"       : "gearshape")
                }
                .tag(4)
        }
        .tint(Color.clinicPrimary)
        .onReceive(NotificationCenter.default.publisher(for: .bookingSuccess)) { _ in
            // switch to home tab when booking succeeds
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
    var body: some View { PlaceholderTabView(title: "Map", icon: "map.fill") }
}
struct UserView: View {
    var body: some View { PlaceholderTabView(title: "User Profile", icon: "person.circle.fill") }
}
struct SettingView: View {
    var body: some View { PlaceholderTabView(title: "Settings", icon: "gearshape.2.fill") }
}

private struct PlaceholderTabView: View {
    let title: String
    let icon:  String
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 56))
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
