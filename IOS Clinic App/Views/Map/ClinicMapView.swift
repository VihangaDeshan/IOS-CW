//
//  ClinicMapView.swift
//  IOS Clinic App
//
//  Clinic indoor navigation — Select Destination screen.
//  Map markers + indoor wayfinding steps (no exact route lines)
//

import SwiftUI
import MapKit

// MARK: - Clinic Location Model

struct ClinicLocation: Identifiable, Equatable {
    let id          = UUID()
    let name:       String
    let coordinate: CLLocationCoordinate2D
    let icon:       String
    let floor:      Int
    let wing:       String
    let landmark:   String

    static func == (lhs: ClinicLocation, rhs: ClinicLocation) -> Bool { lhs.id == rhs.id }
}

// MARK: - View

struct ClinicMapView: View {

    @Environment(\.dismiss) private var dismiss

    // Sample clinic locations
    private let locations: [ClinicLocation] = [
        ClinicLocation(name: "Office",       coordinate: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), icon: "building.2", floor: 1, wing: "Central Wing", landmark: "Reception desk"),
        ClinicLocation(name: "Laboratory",   coordinate: CLLocationCoordinate2D(latitude: 6.9275, longitude: 79.8618), icon: "flask", floor: 1, wing: "East Wing", landmark: "Red LAB sign"),
        ClinicLocation(name: "Room 18",      coordinate: CLLocationCoordinate2D(latitude: 6.9268, longitude: 79.8622), icon: "door.left.hand.closed", floor: 1, wing: "East Wing", landmark: "Door number 18"),
        ClinicLocation(name: "Room 38",      coordinate: CLLocationCoordinate2D(latitude: 6.9265, longitude: 79.8608), icon: "door.left.hand.closed", floor: 2, wing: "West Wing", landmark: "Door number 38"),
        ClinicLocation(name: "Counter",      coordinate: CLLocationCoordinate2D(latitude: 6.9278, longitude: 79.8605), icon: "list.clipboard", floor: 1, wing: "Central Wing", landmark: "Queue counter display"),
        ClinicLocation(name: "Pharmacy",     coordinate: CLLocationCoordinate2D(latitude: 6.9262, longitude: 79.8615), icon: "pills", floor: 1, wing: "West Wing", landmark: "Green cross signage"),
        ClinicLocation(name: "Waiting Area", coordinate: CLLocationCoordinate2D(latitude: 6.9273, longitude: 79.8600), icon: "chair", floor: 1, wing: "Central Wing", landmark: "Blue seating bay"),
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
    @State private var isBuildingGuide   = false
    @State private var guideSummary: String = ""
    @State private var guidanceSteps: [String] = []
    @State private var showGuidanceScreen = false

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
        .onChange(of: currentLocation?.id) { _ in
            guideSummary = ""
            guidanceSteps = []
        }
        .onChange(of: destination?.id) { _ in
            guideSummary = ""
            guidanceSteps = []
        }
        .sheet(isPresented: $showGuidanceScreen) {
            if let currentLocation, let destination {
                IndoorGuidanceView(
                    initialRegion: region,
                    locations: annotationItems,
                    currentLocation: currentLocation,
                    destination: destination,
                    summary: guideSummary,
                    steps: guidanceSteps
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            } else {
                EmptyView()
            }
        }
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
                Button { dismiss() } label: {
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
        ClinicRouteMapView(
            region: $region,
            locations: annotationItems,
            currentLocation: currentLocation,
            destination: destination
        )
        .frame(height: 240)
        .clipShape(Rectangle())
    }

    private var annotationItems: [ClinicLocation] {
        var items = locations
        return items
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

                // ── Indoor Guide button ───────────────────────────────
                Button { buildIndoorGuide() } label: {
                    Text(isBuildingGuide ? "Building Guide..." : "Show Indoor Guide")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(
                            (destination != nil && currentLocation != nil && !isBuildingGuide) ? Color.clinicPrimary : Color(.systemGray3),
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
                .disabled(destination == nil || currentLocation == nil || isBuildingGuide)
                .animation(.easeInOut(duration: 0.2), value: destination != nil || currentLocation != nil)

            }
            .padding(AppSpacing.lg)
            .padding(.bottom, AppSpacing.xxxl)
        }
    }

    private func buildIndoorGuide() {
        guard let currentLocation, let destination else {
            return
        }

        isBuildingGuide = true
        guideSummary = ""
        guidanceSteps = []

        let straightDistance = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            .distance(from: CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude))

        let indoorDistance = max(35, straightDistance * 1.45)
        let indoorSeconds = indoorDistance / 1.1

        var steps: [String] = []
        steps.append("Start from \(currentLocation.name). Face corridor signage and follow arrows for \(destination.wing).")

        if currentLocation.floor != destination.floor {
            steps.append("Go to the nearest lift or stairs and move to Floor \(destination.floor).")
        } else {
            steps.append("Stay on Floor \(destination.floor) and continue along the main corridor.")
        }
        if currentLocation.wing != destination.wing {
            steps.append("At the junction near the central lobby, follow signs to \(destination.wing).")
        }

        steps.append("Look for \(destination.landmark) and proceed to \(destination.name).")
        steps.append("If unsure, check wall signage for floor and room numbers; ask the nearest counter staff for \(destination.name).")

        guideSummary = "~\(formattedDistance(indoorDistance)) walk • ~\(formattedTime(indoorSeconds))"
        guidanceSteps = steps
        isBuildingGuide = false

        region.center = destination.coordinate
        showGuidanceScreen = true
    }

    private func formattedDistance(_ meters: CLLocationDistance) -> String {
        if meters < 1000 {
            return "\(Int(meters.rounded())) m"
        }
        return String(format: "%.1f km", meters / 1000)
    }

    private func formattedTime(_ seconds: TimeInterval) -> String {
        let minutes = max(1, Int((seconds / 60).rounded()))
        return "\(minutes) min"
    }
}

struct IndoorGuidanceView: View {
    @Environment(\.dismiss) private var dismiss

    let locations: [ClinicLocation]
    let currentLocation: ClinicLocation
    let destination: ClinicLocation
    let summary: String
    let steps: [String]

    @State private var region: MKCoordinateRegion

    init(
        initialRegion: MKCoordinateRegion,
        locations: [ClinicLocation],
        currentLocation: ClinicLocation,
        destination: ClinicLocation,
        summary: String,
        steps: [String]
    ) {
        self.locations = locations
        self.currentLocation = currentLocation
        self.destination = destination
        self.summary = summary
        self.steps = steps
        _region = State(initialValue: initialRegion)
    }

    var body: some View {
        VStack(spacing: 0) {
            navBar

            ClinicRouteMapView(
                region: $region,
                locations: locations,
                currentLocation: currentLocation,
                destination: destination
            )
            .frame(height: 260)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Text(summary)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)

                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Indoor Guidance")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)

                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: AppSpacing.sm) {
                                Text("\(index + 1)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 22, height: 22)
                                    .background(Color.clinicPrimary, in: Circle())

                                Text(step)
                                    .font(.system(size: 14))
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(Color.clinicSurface, in: RoundedRectangle(cornerRadius: AppRadius.lg))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                }
                .padding(AppSpacing.lg)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .background(Color.clinicSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var navBar: some View {
        ZStack {
            Text("Indoor Guidance")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button { dismiss() } label: {
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
}

private final class ClinicPointAnnotation: NSObject, MKAnnotation {
    let location: ClinicLocation
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String? { location.name }

    init(location: ClinicLocation) {
        self.location = location
        self.coordinate = location.coordinate
        super.init()
    }
}

private struct ClinicRouteMapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    let locations: [ClinicLocation]
    let currentLocation: ClinicLocation?
    let destination: ClinicLocation?

    func makeCoordinator() -> Coordinator {
        Coordinator(region: $region)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        context.coordinator.currentLocationID = currentLocation?.id
        context.coordinator.destinationID = destination?.id

        mapView.setRegion(region, animated: true)

        mapView.removeAnnotations(mapView.annotations)

        mapView.addAnnotations(locations.map(ClinicPointAnnotation.init))
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var region: MKCoordinateRegion
        var currentLocationID: UUID?
        var destinationID: UUID?

        init(region: Binding<MKCoordinateRegion>) {
            _region = region
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            region = mapView.region
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? ClinicPointAnnotation else { return nil }

            let identifier = "clinic-marker"
            let markerView: MKMarkerAnnotationView
            if let reused = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                markerView = reused
            } else {
                markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                markerView.canShowCallout = false
            }

            markerView.annotation = annotation
            markerView.glyphImage = UIImage(systemName: annotation.location.icon)

            if annotation.location.id == destinationID {
                markerView.markerTintColor = UIColor(Color.clinicPrimary)
            } else if annotation.location.id == currentLocationID {
                markerView.markerTintColor = UIColor(Color(red: 0.22, green: 0.71, blue: 0.38))
            } else {
                markerView.markerTintColor = .systemGray3
            }

            return markerView
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
