//
//  PrescriptionListView.swift
//  IOS Clinic App
//
//  Prescription list — mode switcher (Prescriptions / Pharmacy Status)
//  Prescription filters: Appointment · Patient · Doctor
//  Pharmacy filters:     All · Processing · Ready · Completed
//

import SwiftUI

// MARK: - Page Mode

private enum PageMode: String, CaseIterable {
    case prescriptions = "Prescriptions"
    case pharmacy      = "Pharmacy Status"
}

// MARK: - Filters

enum PrescriptionFilter: String, CaseIterable {
    case appointment = "Appointment"
    case patient     = "Patient"
    case doctor      = "Doctor"
}

enum PharmacyFilter: String, CaseIterable {
    case all        = "All"
    case processing = "Processing"
    case ready      = "Ready"
    case completed  = "Completed"
}

struct PrescriptionRecord: Identifiable {
    let id             = UUID()
    let patientName:   String
    let patientID:     String
    let date:          String
    let doctorName:    String
    let specialization: String
    let diagnosis:     String
    let medicines:     [MedicineItem]
}

struct MedicineItem: Identifiable {
    let id          = UUID()
    let name:       String
    let dosage:     String
    let frequency:  String
    let duration:   String
    let notes:      String?
}

// MARK: - Sample Data

extension PrescriptionRecord {
    static let samples: [PrescriptionRecord] = [
        PrescriptionRecord(
            patientName:    "Vihanga Deshan",
            patientID:      "#123456",
            date:           "14 Feb 2026",
            doctorName:     "Dr. Namal Balahewa",
            specialization: "Specialization - Lungs",
            diagnosis:      "Acute Bronchitis",
            medicines: [
                MedicineItem(name: "Amoxicillin 500mg", dosage: "1 capsule", frequency: "3 times daily", duration: "7 days", notes: "Take after meals"),
                MedicineItem(name: "Cough Syrup",       dosage: "10ml",       frequency: "2 times daily", duration: "5 days", notes: nil),
                MedicineItem(name: "Steam Inhalation",  dosage: "",           frequency: "",              duration: "",       notes: nil),
            ]
        ),
        PrescriptionRecord(
            patientName:    "Vihanga Deshan",
            patientID:      "#123456",
            date:           "14 Feb 2026",
            doctorName:     "Dr. Namal Balahewa",
            specialization: "Specialization - Lungs",
            diagnosis:      "Upper Respiratory Tract Infection",
            medicines: [
                MedicineItem(name: "Paracetamol 500mg", dosage: "1 tablet",  frequency: "3 times daily", duration: "5 days", notes: "After meals"),
                MedicineItem(name: "Vitamin C",         dosage: "1 tablet",  frequency: "Once daily",    duration: "14 days", notes: nil),
            ]
        ),
        PrescriptionRecord(
            patientName:    "Vihanga Deshan",
            patientID:      "#123456",
            date:           "01 Mar 2025",
            doctorName:     "Dr. Namal Balahewa",
            specialization: "Specialization - Lungs",
            diagnosis:      "Seasonal Allergies",
            medicines: [
                MedicineItem(name: "Cetrizine 10mg", dosage: "1 tablet", frequency: "Once daily", duration: "10 days", notes: "Take at night"),
            ]
        ),
    ]
}

// MARK: - View

struct PrescriptionListView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var pageMode: PageMode            = .prescriptions
    @State private var rxFilterIndex: Int            = 0   // PrescriptionFilter index
    @State private var phFilterIndex: Int            = 0   // PharmacyFilter index
    @State private var searchText                    = ""

    @State private var selectedRecord: PrescriptionRecord? = nil
    @State private var navigateToDetail              = false
    @State private var selectedOrder: PharmacyOrder? = nil
    @State private var navigateToPharmacy            = false

    private var rxFilter: PrescriptionFilter { PrescriptionFilter.allCases[rxFilterIndex] }
    private var phFilter: PharmacyFilter     { PharmacyFilter.allCases[phFilterIndex] }

    private var searchPlaceholder: String {
        if pageMode == .pharmacy { return "Search by patient name or ID" }
        switch rxFilter {
        case .appointment: return "Search by diagnosis or date"
        case .patient:     return "Search by patient name or ID"
        case .doctor:      return "Search by doctor or specialization"
        }
    }

    // ── Prescription filtering ────────────────────────────────────────
    private var filteredPrescriptions: [PrescriptionRecord] {
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        return PrescriptionRecord.samples.filter { rec in
            // apply search only when text is non-empty
            if !q.isEmpty {
                switch rxFilter {
                case .appointment:
                    return rec.diagnosis.lowercased().contains(q)
                        || rec.date.lowercased().contains(q)
                case .patient:
                    return rec.patientName.lowercased().contains(q)
                        || rec.patientID.lowercased().contains(q)
                case .doctor:
                    return rec.doctorName.lowercased().contains(q)
                        || rec.specialization.lowercased().contains(q)
                }
            }
            return true
        }
    }

    // ── Pharmacy filtering ────────────────────────────────────────────
    private var filteredOrders: [PharmacyOrder] {
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()

        // 1. Apply status filter
        let statusFiltered: [PharmacyOrder]
        switch phFilter {
        case .all:        statusFiltered = PharmacyOrder.samples
        case .processing: statusFiltered = PharmacyOrder.samples.filter { $0.status == .preparing   }
        case .ready:      statusFiltered = PharmacyOrder.samples.filter { $0.status == .readyPickup }
        case .completed:  statusFiltered = PharmacyOrder.samples.filter { $0.status == .finished    }
        }

        // 2. Apply search text on top
        guard !q.isEmpty else { return statusFiltered }
        return statusFiltered.filter {
            $0.patientName.lowercased().contains(q) || $0.patientID.lowercased().contains(q)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                modeSwitcher
                filterTabs
                searchBar
                contentList
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToDetail) {
            if let record = selectedRecord { PrescriptionDetailView(record: record) }
        }
        .navigationDestination(isPresented: $navigateToPharmacy) {
            if let order = selectedOrder { PharmacyStatusDetailView(order: order) }
        }
        .onReceive(NotificationCenter.default.publisher(for: .pharmacyPaymentSuccess)) { _ in
            navigateToPharmacy = false
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text(pageMode == .prescriptions ? "Prescription" : "Pharmacy Status")
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
                            .font(.app(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Mode Switcher (iOS standard segmented control)

    private var modeSwitcher: some View {
        Picker("", selection: $pageMode) {
            ForEach(PageMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .scaleEffect(y: 1.2)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.xs)
        .onChange(of: pageMode) { _ in
            searchText = ""
        }
    }

    // MARK: - Filter Tabs (iOS standard segmented control)

    @ViewBuilder
    private var filterTabs: some View {
        if pageMode == .prescriptions {
            Picker("", selection: $rxFilterIndex) {
                ForEach(PrescriptionFilter.allCases.indices, id: \.self) { i in
                    Text(PrescriptionFilter.allCases[i].rawValue).tag(i)
                }
            }
            .pickerStyle(.segmented)
            .scaleEffect(y: 1.2)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
            .transition(.opacity)
        } else {
            Picker("", selection: $phFilterIndex) {
                ForEach(PharmacyFilter.allCases.indices, id: \.self) { i in
                    Text(PharmacyFilter.allCases[i].rawValue).tag(i)
                }
            }
            .pickerStyle(.segmented)
            .scaleEffect(y: 1.2)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
            .transition(.opacity)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(searchText.isEmpty ? Color(.tertiaryLabel) : Color.clinicPrimary)
                .font(.app(size: 15))
            TextField(searchPlaceholder, text: $searchText)
                .font(.app(size: 15))
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color(.tertiaryLabel))
                        .font(.app(size: 15))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 44)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.sm)
        .animation(.easeInOut(duration: 0.15), value: searchText.isEmpty)
    }

    // MARK: - Content List

    private var contentList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                if pageMode == .prescriptions {
                    sectionHeader(
                        date:  "Mar 1, 2025",
                        title: "All Prescriptions (\(filteredPrescriptions.count))"
                    )
                    prescriptionCards
                } else {
                    sectionHeader(
                        date:  "Mar 1, 2025",
                        title: "\(phFilter.rawValue) Orders (\(filteredOrders.count))"
                    )
                    pharmacyCards
                }
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
        // Crossfade list content when mode changes — standard iOS transition
        .id(pageMode)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: pageMode)
    }

    private func sectionHeader(date: String, title: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(date)
                .font(.app(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            Text(title)
                .font(.app(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
    }

    // ── Prescription cards ────────────────────────────────────────────

    private var prescriptionCards: some View {
        Group {
            if filteredPrescriptions.isEmpty {
                emptyState(icon: "doc.text.magnifyingglass", label: "No prescriptions match your search")
            } else {
                cardContainer {
                    ForEach(filteredPrescriptions) { record in
                        PrescriptionCard(record: record, searchQuery: searchText, filter: rxFilter) {
                            selectedRecord    = record
                            navigateToDetail  = true
                        }
                        if record.id != filteredPrescriptions.last?.id {
                            Divider().padding(.horizontal, AppSpacing.lg)
                        }
                    }
                }
            }
        }
    }

    // ── Pharmacy order cards ──────────────────────────────────────────

    private var pharmacyCards: some View {
        Group {
            if filteredOrders.isEmpty {
                emptyState(icon: "pills.circle", label: "No orders match your filter")
            } else {
                cardContainer {
                    ForEach(filteredOrders) { order in
                        PharmacyOrderCard(order: order, searchQuery: searchText) {
                            selectedOrder     = order
                            navigateToPharmacy = true
                        }
                        if order.id != filteredOrders.last?.id {
                            Divider().padding(.horizontal, AppSpacing.lg)
                        }
                    }
                }
            }
        }
    }

    private func cardContainer<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(spacing: 0) { content() }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(Color(.systemGray5), lineWidth: 1))
            .padding(.horizontal, AppSpacing.lg)
    }

    private func emptyState(icon: String, label: String) -> some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(.app(size: 34, weight: .light))
                .foregroundStyle(Color(.systemGray3))
            Text(label)
                .font(.app(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.xxxl)
    }
}

// MARK: - Prescription Card

private struct PrescriptionCard: View {
    let record:      PrescriptionRecord
    let searchQuery: String
    let filter:      PrescriptionFilter
    let onTap:       () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                // Diagnosis icon
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(Color.clinicPrimary.opacity(0.1))
                        .frame(width: 42, height: 42)
                    Image(systemName: "doc.text")
                        .font(.app(size: 18, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                }

                VStack(alignment: .leading, spacing: 3) {
                    // Primary row — depends on active filter
                    switch filter {
                    case .appointment:
                        Text(record.diagnosis)
                            .font(.app(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Text(record.date)
                            .font(.app(size: 13))
                            .foregroundStyle(.secondary)
                    case .patient:
                        Text(record.patientName)
                            .font(.app(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Text("ID: \(record.patientID)")
                            .font(.app(size: 13))
                            .foregroundStyle(.secondary)
                    case .doctor:
                        Text(record.doctorName)
                            .font(.app(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Text(record.specialization)
                            .font(.app(size: 13))
                            .foregroundStyle(.secondary)
                    }

                    // Secondary row always shows patient
                    HStack(spacing: 4) {
                        Image(systemName: "person")
                            .font(.app(size: 11))
                        Text(record.patientName)
                            .font(.app(size: 12))
                    }
                    .foregroundStyle(Color(.tertiaryLabel))
                    .padding(.top, 1)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.app(size: 12, weight: .semibold))
                    .foregroundStyle(Color(.systemGray3))
                    .padding(.top, 4)
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pharmacy Order Card

private struct PharmacyOrderCard: View {
    let order:       PharmacyOrder
    let searchQuery: String
    let onTap:       () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: AppSpacing.md) {
                // Status icon
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(order.status.color.opacity(0.12))
                        .frame(width: 42, height: 42)
                    Image(systemName: "pills")
                        .font(.app(size: 18, weight: .medium))
                        .foregroundStyle(order.status.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(order.patientName)
                        .font(.app(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("Order \(order.id)")
                        .font(.app(size: 13))
                        .foregroundStyle(.secondary)
                    Text("Counter: \(order.counter)")
                        .font(.app(size: 13))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                // Status badge
                Text(order.status.rawValue)
                    .font(.app(size: 11, weight: .semibold))
                    .foregroundStyle(order.status.color)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 4)
                    .background(order.status.color.opacity(0.12), in: Capsule())

                Image(systemName: "chevron.right")
                    .font(.app(size: 12, weight: .semibold))
                    .foregroundStyle(Color(.systemGray3))
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PrescriptionListView()
    }
}
