//
//  ManageMembersView.swift
//  IOS Clinic App
//
//  Member selector + detail viewer with inline edit and link to add new member.
//

import SwiftUI

// MARK: - Member Model

struct FamilyMember: Identifiable {
    let id          = UUID()
    let name:       String
    let shortLabel: String
    let phone:      String
    let age:        String
    let notes:      String
    let imageName:  String   // asset name — falls back to person.circle SF symbol
}

// MARK: - View

struct ManageMembersView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedIndex = 0
    @State private var showNewMember = false
    
    // Editable state
    @State private var editName: String = ""
    @State private var editPhone: String = ""
    @State private var editAge: String = ""
    @State private var editNotes: String = ""

    // Sample members — in production this would come from a store/model
    @State private var members: [FamilyMember] = [
        FamilyMember(name: "Sarath Perera",  shortLabel: "Me",     phone: "075 679 8576", age: "75", notes: "",                   imageName: "mr_kasun"),
        FamilyMember(name: "Kamal Perera",   shortLabel: "Father", phone: "071 234 5678", age: "70", notes: "Diabetic patient",   imageName: "member_father"),
        FamilyMember(name: "Sitha Perera",   shortLabel: "Child",  phone: "077 987 6543", age: "12", notes: "Asthma follow-up",   imageName: "member_child"),
    ]

    private var selected: FamilyMember { members[selectedIndex] }

    var body: some View {
        ZStack(alignment: .top) {
            Color.clinicSurface.ignoresSafeArea()

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {

                        // ── Member selector row ───────────────────────
                        memberSelectorSection

                        // ── Detail fields ─────────────────────────────
                        detailFields

                        // ── Update button ─────────────────────────────
                        updateButton
                            .padding(.top, AppSpacing.sm)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xxxl)
                }
            }
        }
        .onAppear {
            updateEditFields()
        }
        .onChange(of: selectedIndex) { _ in
            updateEditFields()
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showNewMember) {
            NewMemberView { newMember in
                members.append(newMember)
            }
        }
    }

    // MARK: - Nav Bar

    private var navBar: some View {
        ZStack {
            Text("Manage Members")
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

    // MARK: - Member Selector

    private var memberSelectorSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Select Member")
                .font(.app(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(members.indices, id: \.self) { index in
                        MemberAvatar(
                            member:     members[index],
                            isSelected: selectedIndex == index
                        ) {
                            withAnimation(.easeInOut(duration: 0.18)) {
                                selectedIndex = index
                            }
                        }
                    }

                    // Add new member chip — appears after existing members
                    Button { showNewMember = true } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                Circle()
                                    .fill(Color(.systemGray6))
                                    .frame(width: 64, height: 64)
                                Image(systemName: "plus")
                                    .font(.app(size: 26, weight: .medium))
                                    .foregroundStyle(Color.clinicPrimary)
                            }
                            Text("Add")
                                .font(.app(size: 12, weight: .regular))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }

    // MARK: - Detail Fields

    private var detailFields: some View {
        VStack(spacing: AppSpacing.sm) {
            
            // Name
            VStack(alignment: .leading, spacing: 4) {
                Text("Name")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "person.crop.circle")
                        .font(.app(size: 17))
                        .foregroundStyle(Color.clinicPrimary)
                        .frame(width: 28)
                        
                    TextField("Name", text: $editName)
                        .font(.app(size: 15))
                        .textFieldStyle(.plain)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.md)
                .frame(height: 50)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
            }

            // Phone
            VStack(alignment: .leading, spacing: 4) {
                 Text("Phone")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "phone")
                        .font(.app(size: 17))
                        .foregroundStyle(Color.clinicPrimary)
                        .frame(width: 28)
                    
                    TextField("Phone", text: $editPhone)
                        .font(.app(size: 15))
                        .keyboardType(.phonePad)
                        .textFieldStyle(.plain)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.md)
                .frame(height: 50)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
            }

            // Age
            VStack(alignment: .leading, spacing: 4) {
                 Text("Age")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "person.2")
                        .font(.app(size: 17))
                        .foregroundStyle(Color.clinicPrimary)
                        .frame(width: 28)
                    
                    TextField("Age", text: $editAge)
                        .font(.app(size: 15))
                        .keyboardType(.numberPad)
                        .textFieldStyle(.plain)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.md)
                .frame(height: 50)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
            }
            
            // Notes
            VStack(alignment: .leading, spacing: 4) {
                 Text("Notes")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.leading, 4)
                
                HStack(spacing: AppSpacing.md) {
                    Image(systemName: "note.text")
                        .font(.app(size: 17))
                        .foregroundStyle(Color.clinicPrimary)
                        .frame(width: 28)
                    
                    TextField("Add notes here...", text: $editNotes)
                        .font(.app(size: 15))
                        .textFieldStyle(.plain)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.md)
                .frame(height: 50)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
            }
        }
    }

    // MARK: - Update Button

    private var updateButton: some View {
        Button {
             if selectedIndex >= 0 && selectedIndex < members.count {
                let current = members[selectedIndex]
                
                // Create updated member
                let updated = FamilyMember(
                    name: editName,
                    shortLabel: current.shortLabel,
                    phone: editPhone,
                    age: editAge,
                    notes: editNotes,
                    imageName: current.imageName
                )
                
                // Update array
                members[selectedIndex] = updated
                
                // Ideally dismiss or show success feedback
                // For now, just print or maybe show an alert (optional)
            }
        
        } label: {
            Text("Update Member")
                .font(.app(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: AppSize.buttonPrimary)
                .background(Color.clinicPrimary, in: Capsule())
        }
        .buttonStyle(.plain)
    }
    private func updateEditFields() {
        guard selectedIndex >= 0 && selectedIndex < members.count else { return }
        let current = members[selectedIndex]
        editName  = current.name
        editPhone = current.phone
        editAge   = current.age
        editNotes = current.notes
    }
}

// MARK: - Member Avatar Chip

private struct MemberAvatar: View {
    let member:     FamilyMember
    let isSelected: Bool
    let onTap:      () -> Void

    var body: some View {
        Button { onTap() } label: {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 64, height: 64)

                    // Try image asset, fall back to SF symbol
                    Image(member.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())

                    if isSelected {
                        Circle()
                            .strokeBorder(Color.clinicPrimary, lineWidth: 3)
                            .frame(width: 64, height: 64)
                    }
                }

                Text(member.shortLabel)
                    .font(.app(size: 12, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? Color.clinicPrimary : .secondary)
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - Info Row

private struct InfoRow: View {
    let icon:  String
    let value: String
    var muted: Bool = false

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.app(size: 17))
                .foregroundStyle(Color.clinicPrimary)
                .frame(width: 28)

            Text(value)
                .font(.app(size: 15))
                .foregroundStyle(muted ? Color(.tertiaryLabel) : .primary)

            Spacer()
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(minHeight: AppSize.fieldHeight)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: AppRadius.lg))
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ManageMembersView()
    }
}
