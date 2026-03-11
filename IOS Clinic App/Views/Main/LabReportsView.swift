import SwiftUI

struct LabReport: Identifiable {
    let id = UUID()
    let title: String
}

struct LabReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMemberIndex: Int = 0

    // sample data
    private let members = ["Me", "Father", "Child"]
    private let memberImages = ["mr_kasun", "member_father", "member_child"]

    // sample reports mapped by member index
    private let reportsByMember: [Int: [(String, [LabReport])]] = [
        0: [
            ("Apr 1, 2025", [LabReport(title: "T4 12345"), LabReport(title: "Lipid profile 12345"), LabReport(title: "Fbc 12345")]),
            ("Mar 24, 2025", [LabReport(title: "TSH 12345"), LabReport(title: "Glucose 12345")])
        ],
        1: [
            ("Apr 3, 2025", [LabReport(title: "CBC 67890"), LabReport(title: "Kidney Panel 67890")])
        ],
        2: [
            ("Apr 5, 2025", [LabReport(title: "Allergy Test 11223"), LabReport(title: "Iron 11223")])
        ]
    ]

    // reports currently shown
    @State private var currentReports: [(String, [LabReport])] = []

    var body: some View {
        VStack(spacing: 0) {
            header
            memberSelector
                .onChange(of: selectedMemberIndex) { newIndex in
                    currentReports = reportsByMember[newIndex] ?? []
                }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(currentReports, id: \.0) { (date, reports) in
                        dateSection(date: date, reports: reports)
                    }
                }
                .padding(.top, 16)
            }
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            currentReports = reportsByMember[selectedMemberIndex] ?? []
        }
    }

    private var header: some View {
        ZStack {
            Text("Lab reports")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                }
                Spacer()
            }
            .padding(.leading, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    private var memberSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(members.indices, id: \.self) { idx in
                    Button {
                        selectedMemberIndex = idx
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray5))
                                    .frame(width: 64, height: 64)

                                Image(memberImages[idx % memberImages.count])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())

                                if selectedMemberIndex == idx {
                                    Circle()
                                        .strokeBorder(Color.clinicPrimary, lineWidth: 3)
                                        .frame(width: 64, height: 64)
                                }
                            }

                            Text(members[idx])
                                .font(.system(size: 12, weight: selectedMemberIndex == idx ? .semibold : .regular))
                                .foregroundStyle(selectedMemberIndex == idx ? Color.clinicPrimary : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }

    private func dateSection(date: String, reports: [LabReport]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(date)
                .font(.headline)
                .foregroundColor(.clinicPrimary)
            ForEach(reports) { report in
                HStack {
                    Text(report.title)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.clinicPrimary)
                        .frame(width: 24, height: 24)
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.clinicPrimary.opacity(0.06), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal)
    }
}

struct LabReportsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LabReportsView()
        }
    }
}
