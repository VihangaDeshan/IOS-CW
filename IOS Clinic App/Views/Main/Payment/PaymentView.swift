import SwiftUI

// Represents a single bill line item
struct BillItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let amount: Double
}

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    let total: Double
    let billItems: [BillItem]
    var isPharmacy: Bool = false
    @State private var selectedPayment: PaymentMethod = .applePay
    @State private var navigateToCheckout = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer().frame(height: 24)
            Text("LKR \(String(format: "%.2f", total))")
                .font(.app(size: 32, weight: .bold))
                .foregroundColor(.clinicPrimary)
            Spacer().frame(height: 16)
            billSection
            Spacer()
            paymentMethodSection
            proceedButton
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Payment")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.app(size: 18, weight: .semibold))
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
        .background(Color.white)
    }

    private var billSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Bill Details")
                .font(.headline)
                .padding(.horizontal)
                .padding(.bottom, 4)
            ForEach(billItems) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .foregroundStyle(.primary)
                        if let sub = item.subtitle {
                            Text(sub)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    Text("LKR \(String(format: "%.2f", item.amount))")
                        .foregroundStyle(.primary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
    }

    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Payment Method")
                .font(.headline)
                .padding(.horizontal)
            VStack(spacing: 12) {
                PaymentMethodRow(method: .applePay, selected: $selectedPayment)
                PaymentMethodRow(method: .creditCard(number: "....4256"), selected: $selectedPayment)
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
        }
    }

    private var proceedButton: some View {
        NavigationLink(isActive: $navigateToCheckout) {
            CheckoutView(amount: total, isPharmacy: isPharmacy)
        } label: {
            Text("Proceed to pay")
                .font(Font.btnTitleSize)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(Color.clinicPrimary, in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

// MARK: - Payment Method Helpers

enum PaymentMethod: Hashable {
    case applePay
    case creditCard(number: String)
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    @Binding var selected: PaymentMethod

    var body: some View {
        Button {
            selected = method
        } label: {
            HStack {
                switch method {
                case .applePay:
                    Image(systemName: "applelogo")
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading) {
                        Text("Apple Pay")
                            .foregroundStyle(.white)
                        Text("Default payment")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    Spacer()
                case .creditCard(let number):
                    Image(systemName: "creditcard")
                        .foregroundColor(.primary)
                        .frame(width: 24, height: 24)
                    VStack(alignment: .leading) {
                        Text("Credit Card")
                            .foregroundStyle(.primary)
                        Text(number)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    if selected == method {
                        Image(systemName: "checkmark")
                            .foregroundColor(.clinicPrimary)
                    }
                }
            }
            .padding()
            .background(glassBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var glassBackground: some View {
        switch method {
        case .applePay:
            RoundedRectangle(cornerRadius: 12)
                .fill(selected == method ? Color.black : Color.black.opacity(0.75))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                }
        case .creditCard(_):
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            selected == method ? Color.clinicPrimary.opacity(0.5) : Color.clear,
                            lineWidth: 1.5
                        )
                }
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PaymentView(total: 5500, billItems: [
                BillItem(title: "Consultation Fee", subtitle: "Dr. Namal Balahewa", amount: 3000),
                BillItem(title: "Hospital Fee", subtitle: "Asiri Hospital", amount: 2000),
                BillItem(title: "Service Charge", subtitle: "10%", amount: 500)
            ])
        }
    }
}
