import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) private var dismiss
    var isPharmacy: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
            Text(isPharmacy ? "Payment Successful" : "Booking Confirmed")
                .font(.title)
                .fontWeight(.semibold)
            
            if !isPharmacy {
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
                            .font(.subheadline)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.clinicPrimary)
                        Text("Appointment No 10")
                            .font(.subheadline)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "checkmark")
                             .foregroundColor(.clinicPrimary)
                        Text("Appointment for father")
                            .font(.subheadline)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "checkmark")
                            .foregroundColor(.clinicPrimary)
                        Text("Room 1")
                            .font(.subheadline)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            } else {
                 Text("Your pharmacy order has been placed successfully.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .background(isPharmacy ? Color.white.ignoresSafeArea() : Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if isPharmacy {
                    NotificationCenter.default.post(name: .pharmacyPaymentSuccess, object: nil)
                } else {
                    NotificationCenter.default.post(name: .bookingSuccess, object: nil)
                }
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
    static let bookingSuccess  = Notification.Name("bookingSuccess")
    static let pharmacyPaymentSuccess = Notification.Name("pharmacyPaymentSuccess")
    static let switchToHomeTab = Notification.Name("switchToHomeTab")
}
