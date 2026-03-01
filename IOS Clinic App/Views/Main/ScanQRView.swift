import SwiftUI

struct ScanQRView: View {
    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(spacing: 0) {
            header
            
            // 1. TOP SPACER: Pushes content to center
            Spacer()
            
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                            .frame(height: 240)
                        
                        Image(systemName: "qrcode")
                            .font(.system(size: 96))
                            .foregroundColor(.clinicPrimary)
                    }
                    
                    Text("Scan the QR code from your appointment slip")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        router.navigate(to: .main)
                    } label: {
                        Text("Scan QR Code")
                            .font(Font.btnTitleSize)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
                .padding(24) // Better internal breathing room
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            
            // 2. BOTTOM SPACER: Keeps content centered
            Spacer()
        }
        
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Scan QR")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            HStack {
                Button { router.navigate(to: .checkIn) } label: {
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

struct ScanQRView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScanQRView()
        }
        .environment(AppRouter())
    }
}
