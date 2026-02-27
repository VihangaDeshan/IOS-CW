import SwiftUI

struct ClinicFlowIcon: View {
    /// Overall tile side length.
    var size: CGFloat = 88

    // Proportions based on Figma design standards
    private var tileRadius: CGFloat { size * 0.22 }
    private var contentSize: CGFloat { size * 0.65 }

    var body: some View {
        ZStack {
            // ── Tile background (Light Gray Rounded Square) ────────────────
            RoundedRectangle(cornerRadius: tileRadius)
                .fill(Color(.systemGray6))
                .frame(width: 40, height: 40)
                // Subtle shadow to give the tile some "lift"
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)

            // ── The Logo ───────────────────────────────────────────────────
            // We use an Optional Image check to prevent empty space
            Image("ClinicLogo")
                .resizable()
                .scaledToFit()
                .frame(width: contentSize, height: contentSize)
                // Fallback: if "ClinicLogo" is missing, show a SF Symbol
                .cornerRadius(15)
                .background {
                    Image(systemName: "cross.case.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: contentSize * 0.8)
                        .foregroundStyle(.gray.opacity(0.2))
                }
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.clinicSurface.ignoresSafeArea()
        
        VStack(spacing: 30) {
            ClinicFlowIcon(size: 141)
            
            Text("Logo Preview")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
