import SwiftUI

struct SuccessView: View {
    @Environment(\.dismiss) private var dismiss
    var isPharmacy: Bool = false

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.clinicPrimary)
                .padding(20)
                .background(glassCard(cornerRadius: AppRadius.xl))

            Text(isPharmacy ? "Payment Successful" : "Booking Confirmed")
                .font(.app(size: 28, weight: .semibold))
                .foregroundStyle(.primary)
                .padding(.horizontal, AppSpacing.lg)

            if !isPharmacy {
                HStack(spacing: 12) {
                    Text("Apr 1, 2025")
                        .padding(8)
                        .background(glassCard(cornerRadius: AppRadius.sm))
                    Text("9:41 AM")
                        .padding(8)
                        .background(glassCard(cornerRadius: AppRadius.sm))
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
                .background(glassCard(cornerRadius: AppRadius.lg))
                .padding(.horizontal)
            } else {
                 Text("Your pharmacy order has been placed successfully.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, AppSpacing.lg)
                    .padding(.horizontal)
                    .background(glassCard(cornerRadius: AppRadius.lg))
                    .padding(.horizontal, AppSpacing.lg)
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
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

private extension SuccessView {
    func glassCard(cornerRadius: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.75), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
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
