import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    let amount: Double
    var isPharmacy: Bool = false
    @State private var cardNumber: String = ""
    @State private var cardHolder: String = ""
    @State private var expiry: String = ""
    @State private var cvv: String = ""
    @State private var acceptedTerms: Bool = false
    @State private var navigateToSuccess = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer().frame(height: 24)
            Text("LKR \(String(format: "%.2f", amount))")
                .font(.app(size: 32, weight: .bold))
                .foregroundColor(.clinicPrimary)
            Spacer().frame(height: 16)
            cardForm
            Spacer()
            termsToggle
            Spacer().frame(height: AppSpacing.lg)
            payButton
        }
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToSuccess) {
            SuccessView(isPharmacy: isPharmacy)
        }
    }

    private var header: some View {
        ZStack {
            Text("Check -Out")
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

    private var cardForm: some View {
        VStack(spacing: 16) {
            LabeledInputField(label: "Card Number") {
                CustomTextField(placeholder: "Enter card number", text: $cardNumber)
            }
            LabeledInputField(label: "Card Holder Name") {
                CustomTextField(placeholder: "Enter card holder name", text: $cardHolder)
            }
            HStack(spacing: 12) {
                LabeledInputField(label: "Expiry") {
                    CustomTextField(placeholder: "MM/YY", text: $expiry)
                }
                LabeledInputField(label: "CVV") {
                    CustomTextField(placeholder: "CVV", text: $cvv)
                }
            }
        }
        .padding(.horizontal)
    }

    private var termsToggle: some View {
        HStack {
            Button {
                acceptedTerms.toggle()
            } label: {
                Image(systemName: acceptedTerms ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(acceptedTerms ? .clinicPrimary : .secondary)
            }
            Text("Terms & Conditions")
                .font(.subheadline)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, AppSpacing.md)
    }

    private var payButton: some View {
        Button {
            navigateToSuccess = true
        } label: {
            Text("Pay")
                .font(Font.btnTitleSize)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(acceptedTerms ? Color.clinicPrimary : Color.clinicPrimary.opacity(0.5), in: Capsule())
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.bottom, 16)
        .disabled(!acceptedTerms)
    }
}

struct LabeledInputField<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(label)
                .font(.app(size: 14, weight: .semibold))
                .foregroundStyle(.primary)

            content
        }
    }
}

// helper textfield with rounded background
struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
            .keyboardType(.default)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CheckoutView(amount: 5500)
        }
    }
}
