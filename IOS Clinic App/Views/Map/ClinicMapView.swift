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
    @State private var isFindingRoute    = false
    @State private var routeSummary: String? = nil
    @State private var routePolyline: MKPolyline? = nil
    @State private var routeErrorMessage = "Unable to find a route for the selected locations."
    @State private var showRouteError    = false

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
            routeSummary = nil
            routePolyline = nil
        }
        .onChange(of: destination?.id) { _ in
            routeSummary = nil
            routePolyline = nil
        }
        .alert("Route Error", isPresented: $showRouteError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(routeErrorMessage)
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
        ClinicRouteMapView(
            region: $region,
            locations: annotationItems,
            currentLocation: currentLocation,
            destination: destination,
            routePolyline: routePolyline
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

                // ── Find Route button ─────────────────────────────────
                Button { findRoute() } label: {
                    Text(isFindingRoute ? "Finding Route..." : "Find Route")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(
                            (destination != nil && currentLocation != nil && !isFindingRoute) ? Color.clinicPrimary : Color(.systemGray3),
                            in: Capsule()
                        )
                }
                .buttonStyle(.plain)
                .disabled(destination == nil || currentLocation == nil || isFindingRoute)
                .animation(.easeInOut(duration: 0.2), value: destination != nil || currentLocation != nil)

                if let routeSummary {
                    Text(routeSummary)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(AppSpacing.lg)
            .padding(.bottom, AppSpacing.xxxl)
        }
    }

    private func findRoute() {
        guard let currentLocation, let destination else {
            routeErrorMessage = "Please select both current location and destination."
            showRouteError = true
            return
        }

        isFindingRoute = true
        routeSummary = nil
        routePolyline = nil

        requestRoadRoute(
            from: currentLocation.coordinate,
            to: destination.coordinate
        ) { route in
            DispatchQueue.main.async {
                isFindingRoute = false

                if let route {
                    routeSummary = "\(formattedDistance(route.distance)) • \(formattedTime(route.expectedTravelTime))"
                    routePolyline = route.polyline

                    let paddedRect = route.polyline.boundingMapRect.insetBy(
                        dx: -route.polyline.boundingMapRect.size.width * 0.4,
                        dy: -route.polyline.boundingMapRect.size.height * 0.4
                    )
                    region = MKCoordinateRegion(paddedRect)
                    return
                }
                routeSummary = nil
                routePolyline = nil
                routeErrorMessage = "Road route is not available for these exact points. Try another nearby start or destination."
                showRouteError = true
            }
        }
    }

    private func requestRoadRoute(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        completion: @escaping (MKRoute?) -> Void
    ) {
        requestRoute(
            from: source,
            to: destination,
            transportTypes: [.walking, .automobile, .any]
        ) { route in
            if let route {
                completion(route)
                return
            }

            let sourceCandidates = nearbyCandidates(for: source)
            let destinationCandidates = nearbyCandidates(for: destination)

            let attempts: [(CLLocationCoordinate2D, CLLocationCoordinate2D)] = sourceCandidates.flatMap { s in
                destinationCandidates.map { d in (s, d) }
            }

            let maxAttempts = 450
            let limitedAttempts = Array(attempts.prefix(maxAttempts))

            attemptRoutePairs(
                limitedAttempts,
                index: 0,
                completion: completion
            )
        }
    }

    private func attemptRoutePairs(
        _ attempts: [(CLLocationCoordinate2D, CLLocationCoordinate2D)],
        index: Int,
        completion: @escaping (MKRoute?) -> Void
    ) {
        guard index < attempts.count else {
            completion(nil)
            return
        }

        let pair = attempts[index]
        requestRoute(
            from: pair.0,
            to: pair.1,
            transportTypes: [.walking, .automobile, .any]
        ) { route in
            if let route {
                completion(route)
            } else {
                attemptRoutePairs(attempts, index: index + 1, completion: completion)
            }
        }
    }

    private func nearbyCandidates(for coordinate: CLLocationCoordinate2D) -> [CLLocationCoordinate2D] {
        let radiiMeters: [Double] = [0, 50, 120, 220, 350, 500, 750]
        let bearings: [Double] = Array(stride(from: 0.0, to: 360.0, by: 30.0))

        var result: [CLLocationCoordinate2D] = []
        for radius in radiiMeters {
            if radius == 0 {
                result.append(coordinate)
                continue
            }
            for bearing in bearings {
                result.append(offsetCoordinate(coordinate, meters: radius, bearingDegrees: bearing))
            }
        }
        return result
    }

    private func offsetCoordinate(
        _ coordinate: CLLocationCoordinate2D,
        meters: Double,
        bearingDegrees: Double
    ) -> CLLocationCoordinate2D {
        let earthRadius = 6_378_137.0
        let bearing = bearingDegrees * .pi / 180

        let lat1 = coordinate.latitude * .pi / 180
        let lon1 = coordinate.longitude * .pi / 180
        let angularDistance = meters / earthRadius

        let lat2 = asin(
            sin(lat1) * cos(angularDistance) +
            cos(lat1) * sin(angularDistance) * cos(bearing)
        )
        let lon2 = lon1 + atan2(
            sin(bearing) * sin(angularDistance) * cos(lat1),
            cos(angularDistance) - sin(lat1) * sin(lat2)
        )

        return CLLocationCoordinate2D(
            latitude: lat2 * 180 / .pi,
            longitude: lon2 * 180 / .pi
        )
    }

    private func requestRoute(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        transportTypes: [MKDirectionsTransportType],
        completion: @escaping (MKRoute?) -> Void
    ) {
        guard let transportType = transportTypes.first else {
            completion(nil)
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = transportType

        MKDirections(request: request).calculate { response, _ in
            if let route = response?.routes.first {
                completion(route)
            } else {
                requestRoute(
                    from: source,
                    to: destination,
                    transportTypes: Array(transportTypes.dropFirst()),
                    completion: completion
                )
            }
        }
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
    let routePolyline: MKPolyline?

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
        mapView.removeOverlays(mapView.overlays)

        mapView.addAnnotations(locations.map(ClinicPointAnnotation.init))

        if let routePolyline {
            mapView.addOverlay(routePolyline)
        }
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

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }

            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor(Color.clinicPrimary)
            renderer.lineWidth = 4
            return renderer
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
