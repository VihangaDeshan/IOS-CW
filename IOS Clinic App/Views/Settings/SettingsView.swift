import SwiftUI

// Views
import Foundation

struct SettingsOption: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String?
    let destination: AnyView
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    private let options: [SettingsOption] = [
        SettingsOption(title: "My Account", subtitle: "Manage your profile", destination: AnyView(AccountView())),
        SettingsOption(title: "Payments", subtitle: "View your payment history", destination: AnyView(PastPaymentsView())),
        SettingsOption(title: "Accessibility", subtitle: "Customize your experience", destination: AnyView(AccessibilityView())),
        SettingsOption(title: "Help & Support", subtitle: "Get assistance", destination: AnyView(HelpSupportView())),
        SettingsOption(title: "Terms & conditions", subtitle: "Legal information", destination: AnyView(Text("Terms & conditions"))),
        SettingsOption(title: "About", subtitle: "Version 1.0.0", destination: AnyView(Text("About")))
    ]

    var body: some View {
        ZStack {
            // Gradient backdrop that makes the glass effect visible
            
           

            VStack(spacing: 0) {
                header
                Spacer().frame(height: 24)
                VStack(spacing: 12) {
                    ForEach(options) { opt in
                        NavigationLink(destination: opt.destination) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(opt.title)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    if let subtitle = opt.subtitle {
                                        Text(subtitle)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.6), Color.white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                            .shadow(color: Color.clinicPrimary.opacity(0.06), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Settings")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
        }
    }
}
