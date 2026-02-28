
import SwiftUI

// simple model representing a medical specialization
struct Specialization: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
}

struct SpecializationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var selectedSegment = 0 // 0 = specializations, 1 = doctors

    // header title adjusts based on selected segment
    private var headerTitle: String {
        selectedSegment == 0 ? "Specialization" : "Specialists"
    }

    // hard‑coded sample data; in a real app this would come from a service
    private let allSpecializations: [Specialization] = [
        Specialization(name: "Cardiologist",        icon: "heart"),
        Specialization(name: "Dentist",             icon: "tooth"),
        Specialization(name: "Pediatrician",        icon: "stethoscope"),
        Specialization(name: "Neurologist",         icon: "brain.head.profile"),
        Specialization(name: "Gastroenterologist",  icon: "fork.knife"),
        Specialization(name: "Ophthalmologist",      icon: "eye"),
        Specialization(name: "Pulmonologist",       icon: "lungs.fill"),
        Specialization(name: "Radiologist",         icon: "xray"),
    ]

    // filtered list according to search text
    private var filteredSpecializations: [Specialization] {
        guard !searchText.isEmpty else { return allSpecializations }
        return allSpecializations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            Picker(selection: $selectedSegment, label: EmptyView()) {
                Text("Specialization").tag(0)
                Text("Doctors").tag(1)
            }
            .pickerStyle(.segmented)
            .scaleEffect(y: 1.2) // Increases height by 20%
            .padding(.horizontal)
            .padding(.top, 8)

            searchBar

            content

            Spacer(minLength: 0)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text(headerTitle)
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            HStack {
                Button(action: { dismiss() }) {
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

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search", text: $searchText)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var content: some View {
        if selectedSegment == 0 {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 12) {
                    ForEach(filteredSpecializations) { spec in
                        NavigationLink(value: spec) {
                            SpecializationRow(specialization: spec)
                                .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 8)
            }
        } else {
            DoctorsListView(searchText: $searchText, specialization: nil)
        }
    }
}

struct SpecializationRow: View {
    let specialization: Specialization
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: specialization.icon)
                .font(.system(size: 20))
                .foregroundColor(.clinicPrimary)
                .frame(width: 32, height: 32)
            Text(specialization.name)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
    }
}

// simple doctor model
struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let specialization: String
    let rating: Double
    let reviews: Int
    let imageName: String
}

struct DoctorsListView: View {
    @Binding var searchText: String
    let specialization: Specialization?

    private let allDoctors: [Doctor] = [
        Doctor(name: "Dr. Rasika Perera", specialization: "Dentists", rating: 4.8, reviews: 86, imageName: "dr_rasika"),
        Doctor(name: "Dr. Namal Udugoda", specialization: "Cardiologists", rating: 4.6, reviews: 106, imageName: "dr_namal"),
        Doctor(name: "Dr. Chandana Bandara", specialization: "Neurologist", rating: 4.5, reviews: 66, imageName: "dr_chandana"),
        Doctor(name: "Dr. Jayantha Udupitiya", specialization: "Cardiologists", rating: 4.4, reviews: 58, imageName: "dr_jayantha"),
    ]

    private var filteredDoctors: [Doctor] {
        allDoctors.filter { doc in
            var match = true
            if let spec = specialization {
                match = doc.specialization.localizedCaseInsensitiveContains(spec.name)
            }
            if !searchText.isEmpty {
                match = match && doc.name.localizedCaseInsensitiveContains(searchText)
            }
            return match
        }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(filteredDoctors) { doc in
                    DoctorRow(doctor: doc)
                        .padding(.horizontal)
                }
            }
            .padding(.top, 8)
        }
    }
}

private struct DoctorRow: View {
    let doctor: Doctor
    var body: some View {
        HStack(spacing: 16) {
            Image(doctor.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(doctor.specialization)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.clinicPrimary)
                    Text(String(format: "%.1f", doctor.rating))
                        .font(.caption)
                        .foregroundColor(.primary)
                    Text("(\(doctor.reviews))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Button(action: {
                // booking action
            }) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 24))
                    .foregroundColor(.clinicPrimary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
    }
}



// Preview – embed inside the full tab shell for visual sanity
struct SpecializationView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(AppRouter())
    }
}
