
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
        Specialization(name: "Dentist",             icon: "mouth"),
        Specialization(name: "Pediatrician",        icon: "stethoscope"),
        Specialization(name: "Neurologist",         icon: "brain.head.profile"),
        Specialization(name: "Gastroenterologist",  icon: "fork.knife"),
        Specialization(name: "Ophthalmologist",      icon: "eye"),
        Specialization(name: "Pulmonologist",       icon: "lungs.fill"),
        Specialization(name: "Nephrologist",         icon: "ivfluid.bag"),
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
                        NavigationLink {
                            DoctorsForSpecializationView(specialization: spec)
                        } label: {
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
                    NavigationLink {
                        DoctorProfileView(doctor: doc)
                    } label: {
                        DoctorRow(doctor: doc)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)
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
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 24))
                .foregroundColor(.clinicPrimary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
    }
}




// MARK: - Pushed doctor screen

struct DoctorsForSpecializationView: View {
    @Environment(\.dismiss) private var dismiss
    let specialization: Specialization
    @State private var searchText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            header
            searchBar
            DoctorsListView(searchText: $searchText, specialization: specialization)
            Spacer(minLength: 0)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Specialists")
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
            TextField(specialization.name, text: $searchText)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

// MARK: - Doctor profile screen

struct DoctorProfileView: View {
    @Environment(\.dismiss) private var dismiss
    let doctor: Doctor
    @State private var searchText: String = ""
    @State private var selectedDateIndex: Int? = nil
    @State private var selectedTime: String? = nil
    @State private var appointmentCount: Int? = nil
    
    // sample dates (in real app these would be derived from availability)
    private let dates = ["11 Mon", "12 Tue", "13 Wed", "14 Thu", "15 Fri","16 Fri", "17 Sat"]

    var body: some View {
        VStack(spacing: 0) {
            header
            searchBar
            profileCard
            dateSelector
            if selectedDateIndex != nil {
                appointmentInfo
            }
            Spacer()
            bookButton
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Specialist Profile")
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
            TextField(doctor.name, text: $searchText)
                .textInputAutocapitalization(.none)
                .disableAutocorrection(true)
                .disabled(true) // <--- Add this to stop typing
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                Image(doctor.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("10+ Years")
                                .font(.headline)
                            Text("Experience")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("900+ Patients")
                                .font(.headline)
                            Text("Treated")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.clinicPrimary)
                        Text(String(format: "%.1f", doctor.rating))
                            .font(.body)
                        Text("(\(doctor.reviews))")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer().frame(height: AppSpacing.lg)
            Text("Expert cardiologist specializing in heart failure and hypertension management. Dedicated to patient-centered care with over 1,000 successful consultations.")
                .font(.subheadline)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var dateSelector: some View {
        VStack(alignment: .leading, spacing: 12) { // Changed to .leading
            
            // ── Topic Heading (Now Left Aligned) ────────────────
            Text("Select Date")
                .font(.system(size: 17, weight: .bold)) // Slightly larger for a "Section Header" feel
                .foregroundStyle(.primary)
                .padding(.horizontal, AppSpacing.lg)

            // ── Horizontal Date List ──────────────────────────
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(dates.indices, id: \.self) { idx in
                        let dateParts = dates[idx].components(separatedBy: " ")
                        
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedDateIndex = idx
                                // when date selected, set dummy time and count
                                selectedTime = "14:00"
                                appointmentCount = 10
                            }
                        }) {
                            VStack(spacing: 4) {
                                // Day (e.g., "Mon")
                                Text(dateParts[0])
                                    .font(.system(size: 14, weight: .semibold))
                                
                                // Date (e.g., "15")
                                Text(dateParts[1])
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .frame(width: 65, height: 80) // Fixed size for a clean look
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(selectedDateIndex == idx ? Color.clinicPrimary : Color(.systemGray6))
                            )
                            .foregroundColor(selectedDateIndex == idx ? .white : .primary)
                            // Simple border for unselected items
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(selectedDateIndex == idx ? Color.clear : Color(.systemGray4).opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.bottom, 5) // Space for the shadow if you add one
            }
        }
        .padding(.top, 20)
    }

    @State private var navigateToAppointment = false

    private var bookButton: some View {
        NavigationLink(isActive: $navigateToAppointment) {
            // pass date/time and doctor info
            let dateString = selectedDateIndex.map { dates[$0] } ?? ""
            AppointmentView(doctor: doctor, dateString: dateString, timeString: selectedTime ?? "")
        } label: {
            Button {
                navigateToAppointment = true
            } label: {
                Text("Book Appointment")
                    .font(Font.btnTitleSize)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: AppSize.buttonPrimary)
                    .background(selectedDateIndex == nil ? Color.clinicPrimary.opacity(0.5) : Color.clinicPrimary, in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(selectedDateIndex == nil)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }

    private var appointmentInfo: some View {
        HStack(spacing: 20) {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .foregroundColor(.clinicPrimary)
                Text(selectedTime ?? "")
                    .font(.body)
            }
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .foregroundColor(.clinicPrimary)
                Text("\(appointmentCount ?? 0)")
                    .font(.body)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, 12)
    }
}


// MARK: - Appointment screen

struct AppointmentView: View {
    @Environment(\.dismiss) private var dismiss
    let doctor: Doctor
    let dateString: String
    let timeString: String
    @State private var selectedMemberIndex: Int = 0
    @State private var nic: String = ""
    @State private var navigateToPayment = false
    @State private var billItems: [BillItem] = []

    // sample members
    // replace these asset names with your actual images added to Assets.xcassets
    private let members = ["Me", "Father", "Child"]
    private let memberImages = ["mr_kasun", "member_father", "member_child"]

    var body: some View {
        VStack(spacing: 0) {
            header
            doctorCard
            dateTimeRow
            memberSelector
            nicField
            Spacer()
            confirmButton
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Appointment")
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

    private var doctorCard: some View {
        HStack(spacing: 16) {
            Image(doctor.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading) {
                Text(doctor.name)
                    .font(.headline)
                Text(doctor.specialization)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.clinicPrimary)
                Text(String(format: "%.1f", doctor.rating))
                    .font(.caption)
                Text("(\(doctor.reviews))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 16)
    }

    private var dateTimeRow: some View {
        HStack(spacing: 16) {
            Text(dateString)
                .padding(8)
                .background(Color.clinicPrimary.opacity(0.2))
                .cornerRadius(12)
            Text(timeString)
                .padding(8)
                .background(Color.clinicPrimary.opacity(0.2))
                .cornerRadius(12)
        }
        .padding(.top, 12)
       
    }
    
    

    private var memberSelector: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: AppSpacing.xl)
            
            Text("Select Member")
                .font(.headline)
                .padding(.horizontal, AppSpacing.lg)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(members.indices, id: \.self) { idx in
                        let name = members[idx]
                        Button {
                            selectedMemberIndex = idx
                        } label: {
                            VStack {
                                Image(memberImages[idx % memberImages.count])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                Text(name)
                                    .font(.caption)
                            }
                            .padding(8)
                            .background(selectedMemberIndex == idx ? Color.clinicPrimary.opacity(0.2) : Color(.systemGray6))
                            .cornerRadius(16)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, AppSpacing.lg)
            }
        }
    }

    private var nicField: some View {
        HStack {
            Image(systemName: "person.crop.rectangle")
                .foregroundColor(.clinicPrimary)
            TextField("Enter your NIC", text: $nic)
                .textInputAutocapitalization(.none)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 16)
        
        .onChange(of: nic) { oldValue, newValue in
            // Filter out everything except numbers
            let filtered = newValue.filter { "0123456789".contains($0) }
            
            // Limit to 6 characters (standard nic length)
            if filtered.count > 15 {
                nic = String(filtered.prefix(6))
            } else {
                nic = filtered
            }
        }
    }

    private var confirmButton: some View {
        ZStack {
            // hidden navigation link to push to payment
            NavigationLink(isActive: $navigateToPayment) {
                let total = billItems.reduce(0) { $0 + $1.amount }
                PaymentView(total: total, billItems: billItems)
            } label: { EmptyView() }
            .hidden()

            Button {
                // when user taps confirm, prepare items and navigate
                billItems = [
                    BillItem(title: "Consultation Fee", subtitle: doctor.name, amount: 3000),
                    BillItem(title: "Hospital Fee", subtitle: "Asiri Hospital", amount: 2000),
                    BillItem(title: "Service Charge", subtitle: "10%", amount: 500)
                ]
                navigateToPayment = true
            } label: {
                Text("Confirm")
                    .font(Font.btnTitleSize)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: AppSize.buttonPrimary)
                    .background(nic.isEmpty ? Color.clinicPrimary.opacity(0.5) : Color.clinicPrimary, in: Capsule())
            }
            .buttonStyle(.plain)
            .disabled(nic.isEmpty)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

// Preview – embed inside the full tab shell for visual sanity
struct SpecializationView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environment(AppRouter())
    }
}
