import SwiftUI

struct AccessibilityView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AccessibilitySettingsKey.textScale) private var textSize: Double = AccessibilitySettingsKey.defaultTextScale
    @State private var highContrast: Bool = false
    @State private var voiceGuidance: Bool = false
    @State private var largerTargets: Bool = false
    @State private var reduceMotion: Bool = false
    @State private var selectedLanguage: String = "English"

    private let languages = ["English", "Sinhala", "Tamil", "French", "Arabic"]

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
                        HStack(spacing: 8) {
                            Text("A")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Slider(
                                value: $textSize,
                                in: AccessibilitySettingsKey.minTextScale...AccessibilitySettingsKey.maxTextScale
                            )
                                .accentColor(.clinicPrimary)
                            Text("A")
                                .font(.title3)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.top, 4)

                        HStack {
                            Text("Small")
                            Spacer()
                            Text("Large")
                        }
                        .font(.caption2)
                        .foregroundStyle(.secondary)
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
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Language")
                                .font(.headline)
                            Text("Select your preferred language")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Menu {
                            ForEach(languages, id: \.self) { lang in
                                Button(lang) { selectedLanguage = lang }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(selectedLanguage)
                                    .font(.subheadline)
                                    .foregroundColor(.clinicPrimary)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.app(size: 11, weight: .semibold))
                                    .foregroundColor(.clinicPrimary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.clinicPrimary.opacity(0.08))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            Spacer()
        }
        .background(Color(.systemBackground).ignoresSafeArea())
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
                        .font(.app(size: 18, weight: .semibold))
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
