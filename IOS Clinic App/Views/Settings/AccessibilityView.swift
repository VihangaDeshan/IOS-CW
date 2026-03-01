import SwiftUI

struct AccessibilityView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var textSize: Double = 0.5
    @State private var highContrast: Bool = false
    @State private var voiceGuidance: Bool = false
    @State private var largerTargets: Bool = false
    @State private var reduceMotion: Bool = false
    @State private var languageEnglish: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            header
            Spacer().frame(height: 24)
            VStack(spacing: 12) {
                card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Text Size")
                            .font(.headline)
                        Text("Adjust text size for readability")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Slider(value: $textSize, in: 0...1)
                            .padding(.vertical, 4)
                            .accentColor(.clinicPrimary)
                            .overlay(
                                HStack {
                                    Text("A")
                                        .font(.caption)
                                    Spacer()
                                    Text("A")
                                        .font(.title3)
                                }
                                .padding(.horizontal, 8)
                            )
                    }
                }
                card {
                    settingRow(title: "High Contrast", subtitle: "Increase Visibility", isOn: $highContrast)
                }
                card {
                    settingRow(title: "Voice Guidance", subtitle: "Enable audio instructions", isOn: $voiceGuidance)
                }
                card {
                    settingRow(title: "Larger Touch Targets", subtitle: "Easier button", isOn: $largerTargets)
                }
                card {
                    settingRow(title: "Reduce Motion", subtitle: "Minimize animations", isOn: $reduceMotion)
                }
                card {
                    settingRow(title: "Language", subtitle: languageEnglish ? "English" : "", isOn: $languageEnglish)
                }
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Accessibility")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
            HStack {
                Button { dismiss() } label: {
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

    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
    }

    private func settingRow(title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
        }
    }
}

struct AccessibilityView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccessibilityView()
        }
    }
}
