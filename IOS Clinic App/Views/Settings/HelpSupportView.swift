import SwiftUI

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var expandedIDs: Set<UUID> = []

    private let faqs: [FAQItem] = [
        FAQItem(question: "How do I view my lab results?", answer: "You can view lab results from the Home screen by tapping the 'Lab Results' section."),
        FAQItem(question: "Can I reschedule my appointment online?", answer: "Yes, go to 'My Appointments' and select the appointment you'd like to reschedule."),
        FAQItem(question: "What insurance providers do you accept?", answer: "We accept all major national insurance providers. Please contact support for specifics.")
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
            header
            Spacer().frame(height: 24)
            VStack(spacing: 12) {
                card {
                    VStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.clinicPrimary)
                        Text("Call Us")
                            .font(.headline)
                        Text("+94 740 458 767")
                            .font(.subheadline)
                            .underline()
                            .foregroundStyle(.blue)
                    }
                }
                card {
                    VStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.clinicPrimary)
                        Text("Email Support")
                            .font(.headline)
                        Text("support@clinicflow.com")
                            .font(.subheadline)
                            .underline()
                            .foregroundStyle(.blue)
                    }
                }
                card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Frequently Asked Questions")
                            .font(.headline)
                        ForEach(faqs) { item in
                            FAQRow(item: item, isExpanded: expandedIDs.contains(item.id)) {
                                if expandedIDs.contains(item.id) {
                                    expandedIDs.remove(item.id)
                                } else {
                                    expandedIDs.insert(item.id)
                                }
                            }
                        }
                    }
                }
            }
            Spacer()
            }
        }
        .navigationBarHidden(true)
    }

    private var header: some View {
        ZStack {
            Text("Help & Support")
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
}

private struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(spacing: 4) {
            Button(action: toggle) {
                HStack {
                    Text(item.question)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "minus" : "plus")
                        .foregroundColor(Color.clinicPrimary)
                }
            }
            .buttonStyle(.plain)
            if isExpanded {
                Text(item.answer)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
            Divider()
        }
    }
}

struct HelpSupportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HelpSupportView()
        }
    }
}
