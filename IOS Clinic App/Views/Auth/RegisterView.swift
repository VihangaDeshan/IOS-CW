import SwiftUI

struct RegisterView: View {

    @Environment(AppRouter.self) private var router
    @State private var mobileNumber = ""
    @State private var name = ""
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Custom navigation bar ────────────────────────────────
                navBar

                // Pushes the logo section to the upper-middle area
                Spacer()

                // ── App Icon & Title Section ────────────────────────────────
                VStack(spacing: AppSpacing.md) {
                    ClinicFlowIcon(size: AppSize.logoWelcome)
                        .opacity(appeared ? 1 : 0)
                        .scaleEffect(appeared ? 1 : 0.85)
                    
                    VStack(spacing: 4) {
                        Text("Create Account")
                            .font(.title2.bold())
                            .foregroundStyle(.primary)
                        
                        Text("Join our clinic community today")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .opacity(appeared ? 1 : 0)
                }

                // Large spacers push the input section significantly lower
                Spacer()
                Spacer()
                
                // ── Input Section ────────────────────────────────────────────
                VStack(spacing: AppSpacing.lg) {
                    
                    // Name Field Container
                    HStack(spacing: 12) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(Color.clinicPrimary)
                            .font(.system(size: 18))
                            .frame(width: 24)
                        
                        Divider()
                            .frame(height: 20)
                        
                        TextField("Enter your Name", text: $name)
                            .textInputAutocapitalization(.words)
                            .font(.body)
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

                    // Mobile Number Field Container
                    HStack(spacing: 12) {
                        Image(systemName: "phone.fill")
                            .foregroundStyle(Color.clinicPrimary)
                            .font(.system(size: 18))
                            .frame(width: 24)
                        
                        Text("+94")
                            .font(.body.bold())
                            .foregroundStyle(.secondary)
                        
                        Divider()
                            .frame(height: 20)
                        
                        TextField("Enter Mobile Number", text: $mobileNumber)
                            .keyboardType(.phonePad)
                            .font(.body)
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
                    .onChange(of: mobileNumber) { _, newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered.count > 10 {
                            mobileNumber = String(filtered.prefix(10))
                        } else {
                            mobileNumber = filtered
                        }
                    }

                    // ── Get Code Button ──────────────────────────────────────────
                    Button {
                        router.navigate(to: .verifyOTP)
                    } label: {
                        Text("Get Code")
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
                    .disabled(mobileNumber.count < 9 || name.isEmpty)
                    .opacity(appeared ? (mobileNumber.count < 9 || name.isEmpty ? 0.5 : 1) : 0)
                    .offset(y: appeared ? 0 : 20)
                }

                // Fixed gap before social sign-in
                Spacer().frame(height: AppSpacing.xl)

                // ── Social Sign-In ───────────────────────────────────────────
                VStack(spacing: AppSpacing.md) {
                    Text("Or register with")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack(spacing: AppSpacing.lg) {
                        SocialIconButton(
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
            Text("Register")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button {
                    router.navigate(to: .welcome)
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

private struct SocialIconButton: View {
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
    RegisterView()
        .environment(AppRouter())
}
