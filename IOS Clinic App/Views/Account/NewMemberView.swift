//
//  NewMemberView.swift
//  IOS Clinic App
//
//  Add a new family member — name, phone, age, notes fields + avatar picker.
//

import SwiftUI

struct NewMemberView: View {

    @Environment(\.dismiss) private var dismiss

    // Callback so ManageMembersView can append the new member
    var onAdd: ((FamilyMember) -> Void)? = nil

    @State private var name  = ""
    @State private var phone = ""
    @State private var age   = ""
    @State private var notes = ""

    private var formIsValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {

                        // ── Avatar placeholder ────────────────────────
                        avatarPlaceholder
                            .padding(.top, AppSpacing.xl)

                        // ── Form fields ───────────────────────────────
                        formFields

                        // ── Add button ────────────────────────────────
                        addButton
                            .padding(.top, AppSpacing.sm)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("New Member")
                .font(Font.navTitleSize)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)

            HStack {
                Button { dismiss() } label: {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray6))
                            .frame(width: 34, height: 34)
                        Image(systemName: "chevron.left")
                            .font(.app(size: 14, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal, AppSpacing.xs)
        }
        .frame(height: AppSize.minTapTarget)
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.xs)
        .background(Color.clinicSurface)
    }

    // MARK: - Avatar Placeholder

    private var avatarPlaceholder: some View {
        VStack(spacing: AppSpacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(Color(.systemGray6))
                    .frame(width: 88, height: 88)

                Image(systemName: "pencil.circle")
                    .font(.app(size: 36, weight: .light))
                    .foregroundStyle(Color.clinicPrimary)
            }

            Text("Name")
                .font(.app(size: 13))
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Form Fields

    private var formFields: some View {
        VStack(spacing: AppSpacing.sm) {
            FormField(icon: "person.crop.circle", placeholder: "Enter name",         text: $name,  keyboard: .default)
            FormField(icon: "phone",              placeholder: "Enter phone number",  text: $phone, keyboard: .phonePad)
            FormField(icon: "person.2",           placeholder: "Enter age",           text: $age,   keyboard: .numberPad)
            FormField(icon: "note.text",          placeholder: "Notes",               text: $notes, keyboard: .default)
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            guard formIsValid else { return }
            let member = FamilyMember(
                name:       name,
                shortLabel: String(name.split(separator: " ").first ?? "New"),
                phone:      phone,
                age:        age,
                notes:      notes,
                imageName:  ""
            )
            onAdd?(member)
            dismiss()
        } label: {
            Text("Add Member")
                .font(.app(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(
                    formIsValid ? Color.clinicPrimary : Color(.systemGray3),
                    in: Capsule()
                )
        }
        .buttonStyle(.plain)
        .disabled(!formIsValid)
        .animation(.easeInOut(duration: 0.18), value: formIsValid)
    }
}

// MARK: - Form Field

private struct FormField: View {
    let icon:        String
    let placeholder: String
    @Binding var text: String
    let keyboard:    UIKeyboardType

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.app(size: 17))
                .foregroundStyle(isFocused ? Color.clinicPrimary : Color(.systemGray2))
                .frame(width: 28)

            TextField(placeholder, text: $text)
                .font(.app(size: 15))
                .keyboardType(keyboard)
                .focused($isFocused)
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(minHeight: AppSize.fieldHeight)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    isFocused ? Color.clinicPrimary.opacity(0.55) : Color.clear,
                    lineWidth: 1.5
                )
        )
        .animation(.easeInOut(duration: 0.18), value: isFocused)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        NewMemberView()
    }
}
