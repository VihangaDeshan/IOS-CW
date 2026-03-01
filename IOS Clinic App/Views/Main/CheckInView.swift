import SwiftUI

struct CheckInView: View {
    @Environment(AppRouter.self) private var router
    @State private var appointmentID: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            header
            
            // --- TOP SPACER ---
            // This pushes the content down from the header
            Spacer()
            
            // MAIN CONTENT CARD
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    // Scan Section
                    Button {
                        router.navigate(to: .scanQR)
                    } label: {
                        Text("Scan QR Code")
                            .font(Font.btnTitleSize)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)

                    Text("OR")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    // Manual Entry Section
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.clinicPrimary)
                            TextField("Enter appointment id", text: $appointmentID)
                                .textInputAutocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)

                        Button {
                            router.navigate(to: .main)
                        } label: {
                            Text("Check-In")
                                .font(Font.btnTitleSize)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: AppSize.buttonPrimary)
                                .background(Color.clinicPrimary, in: Capsule())
                        }
                        .buttonStyle(.plain)
                        .disabled(appointmentID.isEmpty)
                        // Visual feedback for disabled state
                        .opacity(appointmentID.isEmpty ? 0.6 : 1.0)
                    }
                }
                .padding(24) // Increased padding for a better look
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .cornerRadius(24)
                .padding(.horizontal)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
            }
            
            // --- BOTTOM SPACER ---
            // This competes with the top spacer to keep the content centered
            Spacer()
            
            // Optional: add a small fixed spacer if you want it slightly
            // "optical centered" (slightly above true geometric center)
            // Spacer().frame(height: 40)
        }
        
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Check-In")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            HStack {
                Button { router.navigate(to: .welcome) } label: {
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
}

// MARK: - Preview
struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CheckInView()
        }
        .environment(AppRouter())
    }
}
