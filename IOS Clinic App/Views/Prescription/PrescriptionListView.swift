//
//  PrescriptionListView.swift
//  IOS Clinic App
//
//  Prescription list — filterable by Appointment / Patient / Doctor
//  Tapping a card navigates to PrescriptionDetailView.
//

import SwiftUI

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

    @State private var selectedFilterIndex: Int = 0
    @State private var searchText = ""
    @State private var selectedRecord: PrescriptionRecord? = nil
    @State private var navigateToDetail = false

    private var selectedFilter: PrescriptionFilter {
        PrescriptionFilter.allCases[selectedFilterIndex]
    }

    private var filtered: [PrescriptionRecord] {
        let q = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        return PrescriptionRecord.samples.filter { rec in
            guard q.isEmpty else {
                switch selectedFilter {
                case .appointment: return rec.diagnosis.lowercased().contains(q) || rec.date.lowercased().contains(q)
                case .patient:     return rec.patientName.lowercased().contains(q) || rec.patientID.lowercased().contains(q)
                case .doctor:      return rec.doctorName.lowercased().contains(q) || rec.specialization.lowercased().contains(q)
                }
            }
            return true
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar
                    filterTabs
                searchBar
                prescriptionList
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToDetail) {
            if let record = selectedRecord {
                PrescriptionDetailView(record: record)
            }
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Prescription")
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
            .padding(.horizontal, AppSpacing.md)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Filter Tabs

    private var filterTabs: some View {
            Picker(selection: $selectedFilterIndex, label: EmptyView()) {
                ForEach(0..<PrescriptionFilter.allCases.count, id: \.self) { index in
                    Text(PrescriptionFilter.allCases[index].rawValue).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .scaleEffect(y: 1.2)
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

    // MARK: - List

    private var prescriptionList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                // Date section header
                Text("Mar 1, 2025")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)

                Text("All Prescriptions")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.sm)

                VStack(spacing: 0) {
                    ForEach(filtered) { record in
                        PrescriptionCard(record: record) {
                            selectedRecord = record
                            navigateToDetail = true
                        }

                        if record.id != filtered.last?.id {
                            Divider()
                                .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                }
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.lg)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding(.horizontal, AppSpacing.lg)
            }
            .padding(.bottom, AppSpacing.xxxl)
        }
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

// MARK: - Preview

#Preview {
    NavigationStack {
        PrescriptionListView()
    }
}
