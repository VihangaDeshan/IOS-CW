//
//  ClinicMapView.swift
//  IOS Clinic App
//
//  Clinic indoor navigation — Select Destination screen.
//  Map (MapKit) · Current Location picker · Destination search · Find Route
//

import SwiftUI
import MapKit

// MARK: - Clinic Location Model

struct ClinicLocation: Identifiable, Equatable {
    let id          = UUID()
    let name:       String
    let coordinate: CLLocationCoordinate2D
    let icon:       String

    static func == (lhs: ClinicLocation, rhs: ClinicLocation) -> Bool { lhs.id == rhs.id }
}

// MARK: - View

struct ClinicMapView: View {

    // Sample clinic locations
    private let locations: [ClinicLocation] = [
        ClinicLocation(name: "Office",      coordinate: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), icon: "building.2"),
        ClinicLocation(name: "Laboratory",  coordinate: CLLocationCoordinate2D(latitude: 6.9275, longitude: 79.8618), icon: "flask"),
        ClinicLocation(name: "Room 18",     coordinate: CLLocationCoordinate2D(latitude: 6.9268, longitude: 79.8622), icon: "door.left.hand.closed"),
        ClinicLocation(name: "Room 38",     coordinate: CLLocationCoordinate2D(latitude: 6.9265, longitude: 79.8608), icon: "door.left.hand.closed"),
        ClinicLocation(name: "Counter",     coordinate: CLLocationCoordinate2D(latitude: 6.9278, longitude: 79.8605), icon: "list.clipboard"),
        ClinicLocation(name: "Pharmacy",    coordinate: CLLocationCoordinate2D(latitude: 6.9262, longitude: 79.8615), icon: "pills"),
        ClinicLocation(name: "Waiting Area",coordinate: CLLocationCoordinate2D(latitude: 6.9273, longitude: 79.8600), icon: "chair"),
    ]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span:   MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )

    @State private var currentLocation: ClinicLocation? = nil
    @State private var destination:     ClinicLocation? = nil

    @State private var showCurrentPicker = false
    @State private var showDestPicker    = false
    @State private var destSearchText    = ""

    private var filteredLocations: [ClinicLocation] {
        let query = destSearchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !query.isEmpty else { return locations }
        return locations.filter { $0.name.lowercased().contains(query) }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                // ── Map ───────────────────────────────────────────────
                mapSection

                // ── Bottom panel ──────────────────────────────────────
                bottomPanel
            }
        }
        .navigationBarHidden(true)
        // Current location picker sheet
        .sheet(isPresented: $showCurrentPicker) {
            LocationPickerSheet(
                title:     "Current Location",
                locations: locations,
                selected:  $currentLocation
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Select Destination")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button { } label: {
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
            .padding(.horizontal, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Map

    private var mapSection: some View {
        Map(coordinateRegion: $region, annotationItems: annotationItems) { loc in
            MapAnnotation(coordinate: loc.coordinate) {
                ZStack {
                    Circle()
                        .fill(pinColor(for: loc))
                        .frame(width: 28, height: 28)
                        .shadow(color: .black.opacity(0.18), radius: 3, x: 0, y: 2)
                    Image(systemName: loc.icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(height: 240)
        .clipShape(Rectangle())
    }

    private var annotationItems: [ClinicLocation] {
        var items = locations
        return items
    }

    private func pinColor(for loc: ClinicLocation) -> Color {
        if loc == destination     { return Color.clinicPrimary }
        if loc == currentLocation { return Color(red: 0.22, green: 0.71, blue: 0.38) }
        return Color(.systemGray3)
    }

    // MARK: - Bottom Panel

    private var bottomPanel: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {

                // ── Current Location ──────────────────────────────────
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Current Location")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    // If location selected → show filled chip; else → dropdown
                    if let loc = currentLocation {
                        HStack {
                            Text(loc.name)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.primary)
                            Spacer()
                            Button {
                                withAnimation { currentLocation = nil }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(Color(.systemGray3))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .frame(height: 44)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
                    } else {
                        Button { showCurrentPicker = true } label: {
                            HStack {
                                Image(systemName: "location.circle")
                                    .foregroundStyle(Color(.systemGray3))
                                Text("Select Location")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color(.tertiaryLabel))
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color(.systemGray3))
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .frame(height: 44)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
                        }
                        .buttonStyle(.plain)
                    }
                }

                // ── Destination Search ────────────────────────────────
                VStack(alignment: .leading, spacing: 0) {
                    // Search bar row
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 15))
                            .foregroundStyle(Color.clinicPrimary)
                        TextField("Search Here", text: $destSearchText)
                            .font(.system(size: 15))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.systemGray3))
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .frame(height: 44)

                    Divider()

                    // Location list
                    VStack(spacing: 0) {
                        ForEach(filteredLocations) { loc in
                            Button {
                                withAnimation(.easeInOut(duration: 0.18)) {
                                    destination = loc
                                    destSearchText = ""
                                    // Centre map on destination
                                    region.center = loc.coordinate
                                }
                            } label: {
                                HStack {
                                    Text(loc.name)
                                        .font(.system(size: 15))
                                        .foregroundStyle(destination == loc ? Color.clinicPrimary : .primary)
                                    Spacer()
                                    if destination == loc {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 13, weight: .semibold))
                                            .foregroundStyle(Color.clinicPrimary)
                                    }
                                }
                                .padding(.horizontal, AppSpacing.md)
                                .frame(height: 44)
                            }
                            .buttonStyle(.plain)

                            if loc.id != filteredLocations.last?.id {
                                Divider()
                                    .padding(.horizontal, AppSpacing.md)
                            }
                        }
                    }
                }
                .background(Color.clinicSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.lg)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )

                // ── Find Route button ─────────────────────────────────
                Button { } label: {
                    Text("Find Route")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(
                            destination != nil ? Color.clinicPrimary : Color(.systemGray3),
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
                .disabled(destination == nil)
                .animation(.easeInOut(duration: 0.2), value: destination != nil)
            }
            .padding(AppSpacing.lg)
            .padding(.bottom, AppSpacing.xxxl)
        }
    }
}

// MARK: - Location Picker Sheet

struct LocationPickerSheet: View {
    let title:     String
    let locations: [ClinicLocation]
    @Binding var selected: ClinicLocation?
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""

    private var filtered: [ClinicLocation] {
        let q = search.trimmingCharacters(in: .whitespaces).lowercased()
        return q.isEmpty ? locations : locations.filter { $0.name.lowercased().contains(q) }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Handle + title
            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.top, AppSpacing.sm)

                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color(.systemGray3))
                    TextField("Search", text: $search)
                        .font(.system(size: 15))
                }
                .padding(.horizontal, AppSpacing.md)
                .frame(height: 40)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.md))
                .padding(.horizontal, AppSpacing.lg)
            }

            Divider().padding(.top, AppSpacing.sm)

            List(filtered) { loc in
                Button {
                    selected = loc
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: loc.icon)
                            .foregroundStyle(Color.clinicPrimary)
                            .frame(width: 24)
                        Text(loc.name)
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                        Spacer()
                        if selected == loc {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.clinicPrimary)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Preview

#Preview {
    ClinicMapView()
}
