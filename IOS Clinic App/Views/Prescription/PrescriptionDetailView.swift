//
//  PrescriptionDetailView.swift
//  IOS Clinic App
//
//  Full prescription detail — patient info · diagnosis · medicines · Send to Pharmacy
//

import SwiftUI

struct PrescriptionDetailView: View {

    let record: PrescriptionRecord

    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmation = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.md) {
                        patientCard
                        diagnosisCard
                        medicinesCard
                        sendButton
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showConfirmation) {
            PharmacyConfirmationView()
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

    // MARK: - Patient Info Card

    private var patientCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(record.patientName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)
            Text("ID: \(record.patientID)")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(record.date)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(record.doctorName)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text(record.specialization)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Diagnosis Card

    private var diagnosisCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Diagnosis")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)
            Text(record.diagnosis)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Medicines Card

    private var medicinesCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Medicines")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                ForEach(record.medicines) { med in
                    MedicineRow(med: med)

                    if med.id != record.medicines.last?.id {
                        Divider()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }

    // MARK: - Send Button

    private var sendButton: some View {
        Button { showConfirmation = true } label: {
            Text("Send to Pharmacy")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(Color.clinicPrimary, in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.top, AppSpacing.xs)
    }
}

// MARK: - Medicine Row

private struct MedicineRow: View {
    let med: MedicineItem

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(med.name)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.primary)

            if !med.dosage.isEmpty {
                Text("\(med.dosage) – \(med.frequency)")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            if !med.duration.isEmpty {
                Text("Duration: \(med.duration)")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            if let notes = med.notes {
                Text(notes)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        PrescriptionDetailView(record: PrescriptionRecord.samples[0])
    }
}
