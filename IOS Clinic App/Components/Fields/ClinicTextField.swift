//
//  ClinicTextField.swift
//  IOS Clinic App
//
//  Reusable text-input components following iOS HIG:
//  - minimum 44 pt tap target on the field
//  - clear semantic icons via SF Symbols
//  - focused-state border highlight
//  - supports both plain and secure entry
//

import SwiftUI

// MARK: - Plain Text Field

struct ClinicTextField: View {
    let label:       String
    let icon:        String
    var keyboardType: UIKeyboardType     = .default
    var autocap:     TextInputAutocapitalization = .sentences
    var textContent: UITextContentType?  = nil

    @Binding var text: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.app(size: AppSize.iconField, weight: .medium))
                .foregroundStyle(isFocused ? Color.clinicPrimary : Color.secondary)
                .frame(width: AppSize.iconField)
                .animation(.easeInOut(duration: 0.2), value: isFocused)

            TextField(label, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocap)
                .autocorrectionDisabled()
                .focused($isFocused)
                .font(.body)
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: AppSize.fieldHeight)
        .background(Color.clinicFieldBg, in: RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    isFocused ? Color.clinicPrimary : Color.clinicSeparator,
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Secure Field

struct ClinicSecureField: View {
    let label: String
    let icon:  String

    @Binding var text: String
    @State   private var isRevealed = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            // Leading lock icon
            Image(systemName: icon)
                .font(.app(size: AppSize.iconField, weight: .medium))
                .foregroundStyle(isFocused ? Color.clinicPrimary : Color.secondary)
                .frame(width: AppSize.iconField)
                .animation(.easeInOut(duration: 0.2), value: isFocused)

            // Input (toggles secure/plain)
            Group {
                if isRevealed {
                    TextField(label, text: $text)
                        .focused($isFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } else {
                    SecureField(label, text: $text)
                        .focused($isFocused)
                }
            }
            .font(.body)

            // Eye toggle — minimum 44×44 tap target
            Button {
                isRevealed.toggle()
            } label: {
                Image(systemName: isRevealed ? "eye.slash" : "eye")
                    .font(.app(size: AppSize.iconField))
                    .foregroundStyle(.secondary)
                    .frame(width: AppSize.minTapTarget, height: AppSize.minTapTarget)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: AppSize.fieldHeight)
        .background(Color.clinicFieldBg, in: RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .strokeBorder(
                    isFocused ? Color.clinicPrimary : Color.clinicSeparator,
                    lineWidth: isFocused ? 1.5 : 1
                )
        )
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: isRevealed)
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var email    = ""
    @Previewable @State var password = ""

    VStack(spacing: AppSpacing.md) {
        ClinicTextField(
            label: "Email address",
            icon: "envelope",
            keyboardType: .emailAddress,
            autocap: .never,
            text: $email
        )
        ClinicSecureField(
            label: "Password",
            icon: "lock",
            text: $password
        )
    }
    .padding(AppSpacing.xl)
}
