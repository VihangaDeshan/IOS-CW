//
//  PrescriptionListView.swift
//  IOS Clinic App
//
//  Prescription list — mode switcher (Prescriptions / Pharmacy Status)
//  filterable by Appointment / Patient / Doctor
//

import SwiftUI

// MARK: - Page Mode

private enum PageMode: String, CaseIterable {
    case prescriptions = "Prescriptions"
    case pharmacy      = "Pharmacy Status"
}

// MARK: - Models

enum PrescriptionFilter: String, CaseIterable {
    case appointment = "Appointment"
    case patient     = "Patient"
    case doctor      = "Doctor"
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

    @State private var pageMode: PageMode          = .prescriptions
    @State private var selectedFilterIndex: Int    = 0
    @State private var searchText                  = ""

    // Prescription navigation
    @State private var selectedRecord: PrescriptionRecord? = nil
    @State private var navigateToDetail = false

    // Pharmacy navigation
    @State private var selectedOrder: PharmacyOrder? = nil
    @State private var navigateToPharmacy = false

    private var selectedFilter: PrescriptionFilter {
        PrescriptionFilter.allCases[selectedFilterIndex]
    }

    private var filteredPrescriptions: [PrescriptionRecord] {
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        return PrescriptionRecord.samples.filter { rec in
            guard !q.isEmpty else { return true }
            switch selectedFilter {
            case .appointment: return rec.diagnosis.lowercased().contains(q) || rec.date.lowercased().contains(q)
            case .patient:     return rec.patientName.lowercased().contains(q) || rec.patientID.lowercased().contains(q)
            case .doctor:      return rec.doctorName.lowercased().contains(q) || rec.specialization.lowercased().contains(q)
            }
        }
    }

    private var filteredOrders: [PharmacyOrder] {
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        return PharmacyOrder.samples.filter { order in
            guard !q.isEmpty else { return true }
            switch selectedFilter {
            case .appointment: return order.status.rawValue.lowercased().contains(q)
            case .patient:     return order.patientName.lowercased().contains(q) || order.patientID.lowercased().contains(q)
            case .doctor:      return order.doctorName.lowercased().contains(q)
            }
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
            if let record = selectedRecord {
                PrescriptionDetailView(record: record)
            }
        }
        .navigationDestination(isPresented: $navigateToPharmacy) {
            if let order = selectedOrder {
                PharmacyStatusDetailView(order: order)
            }
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text(pageMode == .prescriptions ? "Prescription" : "Pharmacy Status")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.18), value: pageMode)

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
            .padding(.horizontal, AppSpacing.md)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Mode Switcher

    private var modeSwitcher: some View {
        HStack(spacing: 0) {
            ForEach(PageMode.allCases, id: \.self) { mode in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        pageMode = mode
                        searchText = ""
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: mode == .prescriptions ? "doc.text" : "pills")
                            .font(.system(size: 12, weight: .semibold))
                        Text(mode.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(pageMode == mode ? Color.clinicPrimary : Color(.secondaryLabel))
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(
                        pageMode == mode
                            ? Color.clinicPrimary.opacity(0.10)
                            : Color.clear,
                        in: RoundedRectangle(cornerRadius: AppRadius.md)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.md + 4))
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
    }

    // MARK: - Filter Tabs

    private var filterTabs: some View {
        Picker(selection: $selectedFilterIndex, label: EmptyView()) {
            ForEach(0..<PrescriptionFilter.allCases.count, id: \.self) { index in
                Text(PrescriptionFilter.allCases[index].rawValue).tag(index)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.sm)
        .background(Color.clinicSurface)
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color(.tertiaryLabel))
                .font(.system(size: 15))
            TextField("Search", text: $searchText)
                .font(.system(size: 15))
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 44)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, AppSpacing.sm)
    }

    // MARK: - Content List

    private var contentList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                Text("Mar 1, 2025")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)

                Text(pageMode == .prescriptions ? "All Prescriptions" : "All Orders")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.sm)

                if pageMode == .prescriptions {
                    prescriptionCards
                } else {
                    pharmacyCards
                }
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
    }

    // Prescription cards

    private var prescriptionCards: some View {
        Group {
            if filteredPrescriptions.isEmpty {
                emptyState(label: "No prescriptions found")
            } else {
                VStack(spacing: 0) {
                    ForEach(filteredPrescriptions) { record in
                        PrescriptionCard(record: record) {
                            selectedRecord = record
                            navigateToDetail = true
                        }
                        if record.id != filteredPrescriptions.last?.id {
                            Divider().padding(.horizontal, AppSpacing.lg)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(Color(.systemGray5), lineWidth: 1))
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }

    // Pharmacy order cards

    private var pharmacyCards: some View {
        Group {
            if filteredOrders.isEmpty {
                emptyState(label: "No pharmacy orders found")
            } else {
                VStack(spacing: 0) {
                    ForEach(filteredOrders) { order in
                        PharmacyOrderCard(order: order) {
                            selectedOrder = order
                            navigateToPharmacy = true
                        }
                        if order.id != filteredOrders.last?.id {
                            Divider().padding(.horizontal, AppSpacing.lg)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(Color(.systemGray5), lineWidth: 1))
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }

    private func emptyState(label: String) -> some View {
        Text(label)
            .font(.system(size: 15))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.xxxl)
    }
}

// MARK: - Prescription Card

private struct PrescriptionCard: View {
    let record: PrescriptionRecord
    let onTap:  () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(record.patientName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("ID: \(record.patientID)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text(record.date)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text(record.doctorName)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text(record.specialization)
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
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
    let order: PharmacyOrder
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(order.patientName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text("ID: \(order.patientID)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    HStack(spacing: 4) {
                        Text("Status:")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                        Text(order.status.rawValue)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(order.status.color)
                    }

                    Text("Counter: \(order.counter)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
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

// MARK: - Preview

#Preview {
    NavigationStack {
        PrescriptionListView()
    }
}
