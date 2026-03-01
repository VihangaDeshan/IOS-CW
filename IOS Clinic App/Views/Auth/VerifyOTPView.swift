import SwiftUI

struct VerifyOTPView: View {

    @Environment(AppRouter.self) private var router
    @State private var otpCode  = ""
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Custom navigation bar ────────────────────────────────
                navBar

                // Pushes logo to the upper-middle area
                Spacer()

                // ── App Icon Section ────────────────────────────────────────
                VStack(spacing: AppSpacing.md) {
                    ClinicFlowIcon(size: AppSize.logoWelcome)
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1 : 0.85)
                    
                    VStack(spacing: 4) {
                        Text("Verification")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        
                        Text("Enter the 6-digit code sent to you")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(appeared ? 1 : 0)
                }

                // Large spacer pushes the input section significantly lower
                Spacer()
                Spacer()
                
                // ── Input Section ────────────────────────────────────────────
                VStack(spacing: AppSpacing.lg) {
                    
                    // Improved OTP Input Container
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(Color.clinicPrimary)
                            .font(.system(size: 18))
                            .frame(width: 24)
                        
                        Divider()
                            .frame(height: 20)
                        
                        TextField("Enter OTP", text: $otpCode)
                            .keyboardType(.numberPad)
                            .font(.body.monospacedDigit()) // Better for alignment
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.clinicPrimary.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.horizontal, AppSpacing.xl)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .onChange(of: otpCode) { _, newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered.count > 6 {
                            otpCode = String(filtered.prefix(6))
                        } else {
                            otpCode = filtered
                        }
                    }

                    // ── Login Button ───────────────────────────────────────────
                    Button {
                        // mark logged in
                        router.isAuthorized = true
                        router.navigate(to: .main)
                    } label: {
                        Text("Login")
                            .font(Font.btnTitleSize)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: AppSize.buttonPrimary)
                            .background(
                                Color.clinicPrimary,
                                in: Capsule()
                            )
                            .shadow(color: Color.clinicPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, AppSpacing.xl)
                    .disabled(otpCode.count < 6)
                    .opacity(appeared ? (otpCode.count < 6 ? 0.5 : 1) : 0)
                    .offset(y: appeared ? 0 : 20)
                }

                // Fixed gap before social sign-in
                Spacer().frame(height: AppSpacing.xl)

                // ── Social Sign-In ───────────────────────────────────────────
                VStack(spacing: AppSpacing.md) {
                    Text("Or continue with")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: AppSpacing.lg) {
                        OTPSocialIconButton(
                            label: "G",
                            labelColor: Color(red: 0.90, green: 0.27, blue: 0.21)
                        ) { }
                        
                        Button { } label: {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 26))
                                .foregroundStyle(.primary)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color(.systemBackground)).shadow(radius: 2))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .opacity(appeared ? 1 : 0)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Custom nav bar

    private var navBar: some View {
        ZStack {
            Text("Verify OTP")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button {
                    router.navigate(to: .login)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.leading, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
    }
}

// MARK: - Social Icon Button Helper

private struct OTPSocialIconButton: View {
    let label:      String
    let labelColor: Color
    let action:     () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(label)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(labelColor)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color(.systemBackground)).shadow(radius: 2))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VerifyOTPView()
        .environment(AppRouter())
}
