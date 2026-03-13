//
//  LoginRequiredView.swift
//  IOS Clinic App
//
//  Shown to guest users when they attempt to access a restricted feature.
//

import SwiftUI

struct LoginRequiredView: View {

    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // ── Lock inside scan-frame icon ────────────────────────
                ZStack {
                    // Corner scan frame (Face ID style)
                    ScanFrameShape()
                        .stroke(Color.clinicPrimary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 90, height: 90)

                    Image(systemName: "lock.fill")
                        .font(.app(size: 34, weight: .medium))
                        .foregroundStyle(Color.clinicPrimary)
                }

                Spacer().frame(height: AppSpacing.xxl)

                // ── Title ─────────────────────────────────────────────
                Text("Login Required")
                    .font(.app(size: 22, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer().frame(height: AppSpacing.sm)

                // ── Body text ─────────────────────────────────────────
                Text("You must be logged in to continue.\nPlease sign in to access this feature securely.")
                    .font(.app(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xxl)

                Spacer().frame(height: AppSpacing.xxl + AppSpacing.md)

                // ── Buttons ───────────────────────────────────────────
                VStack(spacing: AppSpacing.md) {

                    // Sign In — filled
                    Button {
                        dismiss()
                        router.isGuest = false
                        router.navigate(to: .login)
                    } label: {
                        Text("Sign In")
                            .font(.app(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .background(Color.clinicPrimary, in: Capsule())
                    }
                    .buttonStyle(.plain)

                    // Go Back — outline
                    Button {
                        dismiss()
                        NotificationCenter.default.post(name: .switchToHomeTab, object: nil)
                    } label: {
                        Text("Go Back")
                            .font(.app(size: 17, weight: .semibold))
                            .foregroundStyle(Color.clinicPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .overlay(Capsule().strokeBorder(Color.clinicPrimary, lineWidth: 1.5))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, AppSpacing.xl)

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Scan-frame corner shape

private struct ScanFrameShape: Shape {
    private let corner: CGFloat = 20   // length of each corner bracket arm

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = CGFloat(12)            // corner radius of the bracket

        // Top-left
        p.move(to: CGPoint(x: rect.minX, y: rect.minY + corner))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        p.addArc(center: CGPoint(x: rect.minX + r, y: rect.minY + r),
                 radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        p.addLine(to: CGPoint(x: rect.minX + corner, y: rect.minY))

        // Top-right
        p.move(to: CGPoint(x: rect.maxX - corner, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
                 radius: r, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + corner))

        // Bottom-right
        p.move(to: CGPoint(x: rect.maxX, y: rect.maxY - corner))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
        p.addArc(center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
                 radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        p.addLine(to: CGPoint(x: rect.maxX - corner, y: rect.maxY))

        // Bottom-left
        p.move(to: CGPoint(x: rect.minX + corner, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
        p.addArc(center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
                 radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - corner))

        return p
    }
}

#Preview {
    LoginRequiredView()
        .environment(AppRouter())
}
