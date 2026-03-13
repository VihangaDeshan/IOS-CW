import SwiftUI

struct ProfileQRView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            header
            
            Spacer()
            
            VStack(spacing: 24) {
                 ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        .frame(width: 300, height: 300)
                    
                    Image(systemName: "qrcode")
                        .font(.system(size: 200))
                        .foregroundColor(.primary)
                }
                
                VStack(spacing: 8) {
                    Text("Your Profile QR")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Show this QR to the receptionist")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
            
            Spacer()
        }
        .background(Color.clinicSurface.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                }
                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)
            
            Text("Profile QR")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.top, AppSpacing.xs)
    }
}
