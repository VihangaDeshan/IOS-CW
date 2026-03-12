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
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // ── Contact section ───────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            sectionLabel("Get in Touch")

                            HStack(spacing: 12) {
                                contactCard(
                                    icon: "phone.fill",
                                    iconColor: Color(red: 0.11, green: 0.49, blue: 0.98),
                                    title: "Call Us",
                                    detail: "+94 740 458 767"
                                )
                                contactCard(
                                    icon: "envelope.fill",
                                    iconColor: Color(red: 0.55, green: 0.35, blue: 0.96),
                                    title: "Email",
                                    detail: "support@\nclinicflow.com"
                                )
                            }
                            .padding(.horizontal)
                        }

                        // ── FAQ section ───────────────────────────
                        VStack(alignment: .leading, spacing: 12) {
                            sectionLabel("Frequently Asked Questions")

                            card {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(Array(faqs.enumerated()), id: \.element.id) { index, item in
                                        FAQRow(item: item, isExpanded: expandedIDs.contains(item.id)) {
                                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                                if expandedIDs.contains(item.id) {
                                                    expandedIDs.remove(item.id)
                                                } else {
                                                    expandedIDs.insert(item.id)
                                                }
                                            }
                                        }
                                        if index < faqs.count - 1 {
                                            Divider().padding(.leading, 4)
                                        }
                                    }
                                }
                            }
                        }

                        Spacer(minLength: AppSpacing.xxxl)
                    }
                    .padding(.top, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Sub-views

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
        .background(Color.white)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.horizontal)
    }

    private func contactCard(icon: String, iconColor: Color, title: String, detail: String) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(iconColor)
            }
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
            Text(detail)
                .font(.system(size: 12))
                .foregroundStyle(Color.clinicPrimary)
                .multilineTextAlignment(.center)
                .underline()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }

    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
            .padding(.horizontal)
    }
}

// MARK: - FAQ Row

private struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: toggle) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.clinicPrimary.opacity(0.10))
                            .frame(width: 28, height: 28)
                        Image(systemName: isExpanded ? "minus" : "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.clinicPrimary)
                    }
                    Text(item.question)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(item.answer)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 40)
                    .padding(.bottom, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
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
