import SwiftUI

struct AccountView: View {
    // 1. Fixed: Added the router environment to fix the 'scope' error
    @Environment(AppRouter.self) private var router
    @State private var showManageMembers = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 2. Fixed: Included the custom navBar in the view hierarchy
                navBar
                
                ScrollView {
                    VStack(spacing: AppSpacing.sm) {
                        // Profile Section (Optional but looks professional)
                        profileHeader
                            .padding(.vertical, AppSpacing.lg)

                        // Menu options
                        AccountRow(
                            title: "Edit Profile",
                            subtitle: "Manage your details"
                        ) {
                            // TODO: router.navigate(to: .editProfile)
                        }

                        AccountRow(
                            title: "Manage Members",
                            subtitle: "Manage your health members"
                        ) {
                            showManageMembers = true
                        }

                        AccountRow(
                            title: "Manage Login",
                            subtitle: "Manage your security settings"
                        ) {
                            // TODO: router.navigate(to: .loginSettings)
                        }

                        AccountRow(
                            title: "Your Profile QR",
                            subtitle: "To share your info via QR"
                        ) {
                            // TODO: show QR code sheet
                        }
                        
                    }
                    .padding(.horizontal, AppSpacing.xl)
                }

                Spacer()
                
             

                // Logout button
                // In AccountView.swift
                Button {
                    router.logout()
                    withAnimation(.easeInOut(duration: 0.38)) {
                        router.navigate(to: .login)
                    }
                } label: {
                    Text("Logout")
                        .font(Font.btnTitleSize)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppSize.buttonPrimary)
                        .background(Color.clinicPrimary, in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, AppSpacing.xl)
                Spacer()
               
            }
            .background(Color.clinicSurface.ignoresSafeArea())
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showManageMembers) {
                ManageMembersView()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var navBar: some View {
        ZStack {
            Text("My Account")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

           
            .padding(.leading, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
    }
    
    private var profileHeader: some View {
        VStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 80, height: 80)
                Image("mr_kasun") // Your asset name
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1)) // Optional border
            }
            
            VStack(spacing: 4) {
                Text("Mr. Kasun") // Replace with dynamic user data
                    .font(.title3.weight(.bold))
                Text("0740459735")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Row component

private struct AccountRow: View {
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
        .environment(AppRouter())
}
