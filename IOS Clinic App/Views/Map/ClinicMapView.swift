//
//  ClinicMapView.swift
//  IOS Clinic App
//
//  Clinic indoor navigation — 4-screen flow:
//  Select Destination → Indoor Map → Outdoor Map → Route Info
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

// MARK: - Route Segment Model

struct RouteSegment: Identifiable {
    let id         = UUID()
    let from:      ClinicLocation
    let to:        ClinicLocation
    let directions: [String]
}

// MARK: - Route Service

struct RouteService {

    // Predefined intermediate stops keyed by "Origin|Destination"
    private static let predefinedWaypoints: [String: [String]] = [
        "Office|Laboratory":   ["Hall A"],
        "Office|Room 3B":      ["Hall A"],
        "Office|ECG Room":     ["Counter", "Hall A"],
        "Office|Pharmacy":     ["Counter"],
        "Office|Waiting Area": [],
        "Hall A|Laboratory":   [],
        "Hall A|Room 3B":      [],
        "Hall A|ECG Room":     [],
        "Counter|Laboratory":  ["Hall A"],
        "Counter|Room 3B":     ["Hall A"],
        "Pharmacy|Hall A":     ["Counter"],
    ]

    static func segments(from origin: ClinicLocation,
                         to destination: ClinicLocation,
                         allLocations: [ClinicLocation]) -> [RouteSegment] {
        let key     = "\(origin.name)|\(destination.name)"
        let revKey  = "\(destination.name)|\(origin.name)"

        let waypointNames: [String]
        if let fwd = predefinedWaypoints[key] {
            waypointNames = fwd
        } else if let rev = predefinedWaypoints[revKey] {
            waypointNames = rev.reversed()
        } else {
            // Generic fallback: add Hall A as midpoint if wings differ
            waypointNames = origin.wing != destination.wing ? ["Hall A"] : []
        }

        let waypointLocs = waypointNames.compactMap { name in allLocations.first { $0.name == name } }
        let path = [origin] + waypointLocs + [destination]

        return zip(path, path.dropFirst()).map { from, to in
            RouteSegment(from: from, to: to, directions: makeDirections(from: from, to: to))
        }
    }

    static func makeDirections(from: ClinicLocation, to: ClinicLocation) -> [String] {
        switch (from.name, to.name) {
        case ("Office", "Hall A"):
            return [
                "Start from your current position at the Reception desk",
                "Walk straight 10m along the main Central corridor",
                "Turn right at the first T-junction",
                "Walk 15m past the Waiting Area (blue seating bay)",
                "Look for 'Hall A' signage on your left",
                "Arrive at Hall A entrance"
            ]
        case ("Hall A", "Laboratory"):
            return [
                "Start from Hall A entrance",
                "Enter Hall A and head toward the far (east) end",
                "Look for the red LAB sign (A05) on your right",
                "Turn right into the East Wing corridor",
                "The Laboratory door is immediately on your right",
                "Arrive at Laboratory (A05)"
            ]
        case ("Hall A", "Room 3B"):
            return [
                "Start from Hall A entrance",
                "Enter Hall A and continue to the far east end",
                "Pass Laboratory (A05) on your right",
                "Room 3B is the next door on your right",
                "Look for Door 3B signage",
                "Arrive at Room 3B"
            ]
        case ("Hall A", "ECG Room"):
            return [
                "Start from Hall A entrance",
                "Walk straight through Hall A toward the West Wing",
                "Exit Hall A through the west corridor",
                "Walk 8m and look for ECG Room (A08) signage",
                "Arrive at ECG Room (A08)"
            ]
        case ("Office", "Counter"):
            return [
                "Start from the Reception desk",
                "Turn left from Reception into the Central corridor",
                "Walk 20m; the Counter queue display is directly ahead",
                "Arrive at the Counter area"
            ]
        case ("Counter", "Hall A"):
            return [
                "Start from the Counter area",
                "Face north and walk straight 12m along the North corridor",
                "Hall A entrance will appear on your right",
                "Arrive at Hall A entrance"
            ]
        case ("Office", "Waiting Area"):
            return [
                "Start from the Reception desk",
                "Walk straight along the Central corridor",
                "The blue seating bay (Waiting Area) is 8m ahead on your left",
                "Arrive at Waiting Area"
            ]
        case ("Counter", "Waiting Area"):
            return [
                "Start from the Counter area",
                "Turn and face the Central corridor",
                "Walk 10m; the blue seating Waiting Area is on your right",
                "Arrive at Waiting Area"
            ]
        default:
            var steps = ["Start from \(from.landmark)"]
            if from.wing != to.wing {
                steps.append("Follow corridor signs toward \(to.wing)")
            }
            if from.floor != to.floor {
                steps.append("Take the lift or stairs to Floor \(to.floor)")
            } else {
                steps.append("Continue along the main Floor \(to.floor) corridor")
            }
            steps.append("Look for \(to.landmark)")
            steps.append("Arrive at \(to.name)")
            return steps
        }
    }
}

// MARK: - Main View

struct ClinicMapView: View {

    @Environment(\.dismiss) private var dismiss

    private let locations: [ClinicLocation] = [
        ClinicLocation(name: "Office",       coordinate: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), icon: "building.2",             floor: 1, wing: "Central Wing", landmark: "Reception desk"),
        ClinicLocation(name: "Hall A",       coordinate: CLLocationCoordinate2D(latitude: 6.9281, longitude: 79.8625), icon: "door.french.open",        floor: 1, wing: "North Wing",   landmark: "Hall A entrance"),
        ClinicLocation(name: "Laboratory",   coordinate: CLLocationCoordinate2D(latitude: 6.9275, longitude: 79.8618), icon: "flask",                   floor: 1, wing: "East Wing",    landmark: "Red LAB sign (A05)"),
        ClinicLocation(name: "Room 3B",      coordinate: CLLocationCoordinate2D(latitude: 6.9268, longitude: 79.8622), icon: "door.left.hand.closed",   floor: 1, wing: "East Wing",    landmark: "Door 3B"),
        ClinicLocation(name: "ECG Room",     coordinate: CLLocationCoordinate2D(latitude: 6.9265, longitude: 79.8608), icon: "waveform.path.ecg",       floor: 1, wing: "West Wing",    landmark: "ECG Room (A08)"),
        ClinicLocation(name: "Counter",      coordinate: CLLocationCoordinate2D(latitude: 6.9278, longitude: 79.8605), icon: "list.clipboard",          floor: 1, wing: "Central Wing", landmark: "Queue counter"),
        ClinicLocation(name: "Pharmacy",     coordinate: CLLocationCoordinate2D(latitude: 6.9262, longitude: 79.8615), icon: "pills",                   floor: 1, wing: "West Wing",    landmark: "Green cross sign"),
        ClinicLocation(name: "Waiting Area", coordinate: CLLocationCoordinate2D(latitude: 6.9273, longitude: 79.8600), icon: "chair",                   floor: 1, wing: "Central Wing", landmark: "Blue seating bay"),
    ]

    // 0 = select destination; 1…N = waypoint steps; N+1 = arrived
    @State private var stepIndex:     Int            = 0
    @State private var routeSegments: [RouteSegment] = []

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span:   MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
    )

    @State private var currentLocation: ClinicLocation? = nil
    @State private var destination:     ClinicLocation? = nil

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()
            if stepIndex == 0 {
                selectDestinationView
            } else {
                let segIdx = stepIndex - 1
                if segIdx < routeSegments.count {
                    WaypointStepView(
                        segment:        routeSegments[segIdx],
                        segmentNumber:  segIdx + 1,
                        totalSegments:  routeSegments.count,
                        onBack: { withAnimation { stepIndex -= 1 } },
                        onNext: segIdx == routeSegments.count - 1
                            ? nil
                            : { withAnimation { stepIndex += 1 } }
                    )
                } else {
                    ArrivedView(destination: destination!) {
                        withAnimation { stepIndex = 0 }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Select Destination View

    private var selectDestinationView: some View {
        VStack(spacing: 0) {
            navBar
            ClinicRouteMapView(
                region: $region,
                locations: locations,
                currentLocation: currentLocation,
                destination: destination
            )
            .frame(height: 220)
            .clipShape(Rectangle())

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {

                    // ── Current Location ──────────────────────────────
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Current Location")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        Menu {
                            Button { withAnimation { currentLocation = nil } } label: {
                                Label("None", systemImage: "xmark")
                            }
                            Divider()
                            ForEach(locations) { loc in
                                Button { withAnimation { currentLocation = loc } } label: {
                                    Label(loc.name, systemImage: loc.icon)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "location.circle")
                                    .foregroundStyle(currentLocation != nil ? Color.clinicPrimary : Color(.systemGray3))
                                Text(currentLocation?.name ?? "Select Location")
                                    .font(.system(size: 15))
                                    .foregroundStyle(currentLocation != nil ? .primary : Color(.tertiaryLabel))
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .frame(height: 44)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
                        }
                        .buttonStyle(.plain)
                    }

                    // ── Destination ───────────────────────────────────
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("Destination")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.secondary)
                        Menu {
                            Button { withAnimation { destination = nil } } label: {
                                Label("None", systemImage: "xmark")
                            }
                            Divider()
                            ForEach(locations) { loc in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.18)) {
                                        destination = loc
                                        region.center = loc.coordinate
                                    }
                                } label: {
                                    Label(loc.name, systemImage: loc.icon)
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "mappin.circle")
                                    .foregroundStyle(destination != nil ? Color.clinicPrimary : Color(.systemGray3))
                                Text(destination?.name ?? "Select Destination")
                                    .font(.system(size: 15))
                                    .foregroundStyle(destination != nil ? .primary : Color(.tertiaryLabel))
                                Spacer()
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(.systemGray3))
                            }
                            .padding(.horizontal, AppSpacing.md)
                            .frame(height: 44)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
                        }
                        .buttonStyle(.plain)
                    }

                    // ── Find Route ────────────────────────────────────
                }
                .padding(AppSpacing.lg)
            }

            // ── Find Route button pinned at bottom ────────────────────
            let canRoute = currentLocation != nil && destination != nil
            Button {
                guard let origin = currentLocation, let dest = destination, origin != dest else { return }
                routeSegments = RouteService.segments(from: origin, to: dest, allLocations: locations)
                withAnimation { stepIndex = 1 }
            } label: {
                Text("Find Route")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: AppSize.buttonPrimary)
                    .background(canRoute ? Color.clinicPrimary : Color(.systemGray3), in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(!canRoute)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
            .padding(.top, AppSpacing.sm)
            .background(Color.clinicSurface)
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
                        Circle().fill(Color(.systemGray6)).frame(width: 34, height: 34)
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

// MARK: - Waypoint Step View

struct WaypointStepView: View {
    let segment:       RouteSegment
    let segmentNumber: Int
    let totalSegments: Int
    let onBack:        () -> Void
    let onNext:        (() -> Void)?   // nil on last segment (arrived)

    @State private var showDirections = false

    var body: some View {
        VStack(spacing: 0) {

            // ── Nav bar with step counter ───────────────────────────
            mapNavBar(
                title: "Clinic Map",
                stepIndicator: "Step \(segmentNumber) of \(totalSegments)",
                onBack: onBack
            )

            // ── "You are now at …" banner ───────────────────────────
            youAreNowBanner(name: segment.from.name)

            // ── Floor-plan schematic: tap → directions ──────────────
            ZStack(alignment: .bottomTrailing) {
                FloorPlanSchematicView(from: segment.from.name, to: segment.to.name)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture { showDirections = true }

                Button { showDirections = true } label: {
                    Label("Tap for directions", systemImage: "hand.tap")
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.45), in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(AppSpacing.md)
            }

            // ── "Head to …" instruction row ─────────────────────────
            HStack(spacing: 8) {
                Image(systemName: "arrow.turn.up.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.clinicPrimary)
                Text("Head to ") .font(.system(size: 14)).foregroundStyle(.primary) +
                Text(segment.to.name).font(.system(size: 14, weight: .semibold)).foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
            .background(Color.clinicSurface)

            Divider()

            // ── Previous / Next buttons ─────────────────────────────
            HStack {
                if segmentNumber > 1 {
                    Button { onBack() } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left").font(.system(size: 14, weight: .semibold))
                            Text("Previous").font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24).padding(.vertical, 13)
                        .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
                if let onNext {
                    Button { onNext() } label: {
                        HStack(spacing: 6) {
                            Text("Next").font(.system(size: 16, weight: .semibold))
                            Image(systemName: "chevron.right").font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24).padding(.vertical, 13)
                        .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)
                } else {
                    // Last segment — "Arrived" button
                    Button { onBack() } label: {
                        Text("Arrived 🎉")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24).padding(.vertical, 13)
                            .background(Color.green, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.lg)
            .background(Color.clinicSurface)
        }
        .background(Color.clinicSurface.ignoresSafeArea())
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showDirections) {
            SegmentDirectionsView(segment: segment, onBack: { showDirections = false })
        }
    }
}

// MARK: - Segment Directions View

struct SegmentDirectionsView: View {
    let segment: RouteSegment
    let onBack:  () -> Void

    var body: some View {
        VStack(spacing: 0) {
            mapNavBar(title: "Route Info", stepIndicator: nil, onBack: onBack)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(segment.to.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.primary)
                        Text("From \(segment.from.name)")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                    }

                    // Direction steps
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        ForEach(Array(segment.directions.enumerated()), id: \.offset) { _, step in
                            HStack(alignment: .top, spacing: AppSpacing.md) {
                                Image(systemName: "arrow.triangle.turn.up.right.circle")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color.clinicPrimary)
                                    .frame(width: 24)
                                Text(step)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))

                    Button { onBack() } label: {
                        Text("Back to map")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(AppSpacing.lg)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .background(Color.clinicSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - Arrived View

struct ArrivedView: View {
    let destination: ClinicLocation
    let onDone:      () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color.clinicPrimary)
            Text("You've arrived!")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.primary)
            Text(destination.name)
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
            Spacer()
            Button { onDone() } label: {
                Text("Done")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: AppSize.buttonPrimary)
                    .background(Color.clinicPrimary, in: Capsule())
                    .padding(.horizontal, AppSpacing.lg)
            }
            .buttonStyle(.plain)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(Color.clinicSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

// MARK: - Floor Plan Schematic (Indoor drawing)

struct FloorPlanSchematicView: View {
    let from: String
    let to: String

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ZStack {
                Color(red: 0.965, green: 0.938, blue: 0.882)

                Canvas { ctx, size in
                    let w = size.width
                    let h = size.height
                    let wallShading = GraphicsContext.Shading.color(Color(white: 0.15))
                    let routeShading = GraphicsContext.Shading.color(Color.clinicPrimary)
                    let bgShading = GraphicsContext.Shading.color(Color(red: 0.965, green: 0.938, blue: 0.882))
                    let wallStyle = StrokeStyle(lineWidth: 2.5)

                    // Left vertical corridor
                    ctx.stroke(Path(CGRect(x: w*0.08, y: h*0.14, width: w*0.13, height: h*0.66)),
                               with: wallShading, style: wallStyle)
                    // Top horizontal corridor
                    ctx.stroke(Path(CGRect(x: w*0.08, y: h*0.14, width: w*0.73, height: h*0.16)),
                               with: wallShading, style: wallStyle)
                    // Main room (destination)
                    ctx.stroke(Path(CGRect(x: w*0.41, y: h*0.14, width: w*0.52, height: h*0.52)),
                               with: wallShading, style: wallStyle)
                    // Origin room (current location)
                    ctx.stroke(Path(CGRect(x: w*0.08, y: h*0.62, width: w*0.20, height: h*0.18)),
                               with: wallShading, style: wallStyle)

                    // Door gap — exit of origin room into corridor
                    ctx.stroke(
                        { var p = Path(); p.move(to: CGPoint(x: w*0.21, y: h*0.65)); p.addLine(to: CGPoint(x: w*0.21, y: h*0.74)); return p }(),
                        with: bgShading, lineWidth: 4
                    )
                    // Door gap — entry into destination room
                    ctx.stroke(
                        { var p = Path(); p.move(to: CGPoint(x: w*0.41, y: h*0.31)); p.addLine(to: CGPoint(x: w*0.41, y: h*0.44)); return p }(),
                        with: bgShading, lineWidth: 4
                    )

                    // Dashed route: from origin → up corridor → right → into room
                    var route = Path()
                    route.move(to:    CGPoint(x: w*0.145, y: h*0.71))
                    route.addLine(to: CGPoint(x: w*0.145, y: h*0.22))
                    route.addLine(to: CGPoint(x: w*0.67,  y: h*0.22))
                    route.addLine(to: CGPoint(x: w*0.67,  y: h*0.40))
                    ctx.stroke(route, with: routeShading,
                               style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: [8, 5]))

                    // Arrowhead at destination end
                    let tip = CGPoint(x: w*0.67, y: h*0.40)
                    var arrowPath = Path()
                    arrowPath.move(to: tip); arrowPath.addLine(to: CGPoint(x: w*0.67 - 9, y: h*0.33))
                    arrowPath.move(to: tip); arrowPath.addLine(to: CGPoint(x: w*0.67 + 9, y: h*0.33))
                    ctx.stroke(arrowPath, with: routeShading,
                               style: StrokeStyle(lineWidth: 3, lineCap: .round))
                }

                // Room labels overlay
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Spacer()
                        HStack(spacing: 4) {
                            Text(to)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(.primary)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.clinicPrimary)
                        }
                        .padding(.top, h * 0.24)
                        .padding(.trailing, w * 0.06)
                    }
                    Spacer()
                    HStack {
                        Text(from)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(.leading, w * 0.10)
                            .padding(.bottom, h * 0.12)
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Shared UI Helpers

private func mapNavBar(title: String, stepIndicator: String?, onBack: @escaping () -> Void) -> some View {
    ZStack {
        VStack(spacing: 1) {
            Text(title)
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
            if let stepIndicator {
                Text(stepIndicator)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        HStack {
            Button { onBack() } label: {
                ZStack {
                    Circle().fill(Color(.systemGray6)).frame(width: 34, height: 34)
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

private func youAreNowBanner(name: String) -> some View {
    VStack(spacing: 2) {
        Text("You are now")
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
        Text(name)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.primary)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, AppSpacing.sm)
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
    .padding(.horizontal, AppSpacing.lg)
    .padding(.vertical, AppSpacing.sm)
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
