//
//  LoginView.swift
//  IOS Clinic App
//
//  Login screen matching Figma design:
//  Custom nav bar (“<” back + “Login” title), app icon, phone
//  number field, “Get Code” CTA, Google + Apple social icons.
//

import SwiftUI

struct LoginView: View {

    @Environment(AppRouter.self) private var router
    @State private var mobileNumber = ""
    @State private var appeared     = false

    var body: some View {
        ZStack {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Custom navigation bar ────────────────────────────────
                navBar

                Spacer()
                Spacer().frame(height: AppSpacing.xxxl + AppSpacing.lg)
              

                // ── App icon ────────────────────────────────────────────────
                ClinicFlowIcon(size: AppSize.logoWelcome)
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.85)

                Spacer().frame(height: AppSpacing.xxxl + AppSpacing.lg)
                Spacer().frame(height: AppSpacing.xxxl + AppSpacing.lg)
                Spacer().frame(height: AppSpacing.xxxl + AppSpacing.lg)
                // ── Phone number field ─────────────────────────────────────
                ClinicTextField(
                    label: "Enter your Mobile Number",
                    icon: "phone",
                    keyboardType: .phonePad,
                    autocap: .never,
                    text: $mobileNumber
                )
                
                .frame(maxWidth: .infinity) // Ensure it stretches wide
                .frame(height: 60)          // Set your desired height here
                .background(Color.white.opacity(0.1)) // Added background so you can see the height
                .cornerRadius(30)
                
                .padding(.horizontal, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                
                .onChange(of: mobileNumber) { oldValue, newValue in
                    // Filter out everything except numbers
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    
                    // Limit to 6 characters (standard OTP length)
                    if filtered.count > 10 {
                        mobileNumber = String(filtered.prefix(6))
                    } else {
                        mobileNumber = filtered
                    }
                }

                Spacer().frame(height: AppSpacing.lg)
                

                // ── Get Code button ──────────────────────────────────────────
                Button {
                    router.navigate(to: .verifyOTP)
                } label: {
                    Text("Get Code")
                        .font(Font.btnTitleSize)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(Color.clinicPrimary, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AppSpacing.xl)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)

                Spacer()

                // ── Social sign-in row ────────────────────────────────────────
                HStack(spacing: AppSpacing.xs) {
                    // Google “G” icon button
                    SocialIconButton(
                        label: "G",
                        labelColor: Color(red: 0.90, green: 0.27, blue: 0.21)
                    ) { }

                    // Apple logo button
                    Button { } label: {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundStyle(.primary)
                            .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    }
                    .buttonStyle(.plain)
                }
                .opacity(appeared ? 1 : 0)
                .padding(.bottom, AppSpacing.xxxl)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.82).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Custom nav bar

    private var navBar: some View {
        ZStack {
            Text("Login")
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
                        .contentShape(Rectangle())
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

// MARK: - Social Icon Button

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
                .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LoginView()
        .environment(AppRouter())
}
