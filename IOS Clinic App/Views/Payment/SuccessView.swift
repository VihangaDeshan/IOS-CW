import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
            Text("Booking Confirmed")
                .font(.title)
                .fontWeight(.semibold)
            HStack(spacing: 12) {
                Text("Apr 1, 2025")
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                Text("9:41 AM")
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.clinicPrimary)
                    Text("Dr. Namal Balahewa")
                    Spacer()
                }
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.clinicPrimary)
                    Text("Appointment No 10")
                    Spacer()
                }
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.clinicPrimary)
                    Text("Appointment for father")
                    Spacer()
                }
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(.clinicPrimary)
                    Text("Room 1")
                    Spacer()
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                NotificationCenter.default.post(name: .bookingSuccess, object: nil)
            }
        }
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SuccessView()
        }
    }
}

// notification used when a booking/payment completes
extension Notification.Name {
    static let bookingSuccess = Notification.Name("bookingSuccess")
}
