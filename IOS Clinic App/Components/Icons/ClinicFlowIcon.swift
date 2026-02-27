//
//  ClinicFlowIcon.swift
//  IOS Clinic App
//
//  Reusable app icon tile matching the Figma design:
//  light-gray rounded-square tile containing a teal→blue
//  gradient shield with a white ECG line + white plus badge.
//

import SwiftUI

struct ClinicFlowIcon: View {

    /// Overall tile side length.
    var size: CGFloat = 88

    private var tileRadius: CGFloat { size * 0.22 }
    private var shieldSize: CGFloat { size * 0.62 }
    private var ecgSize:    CGFloat { size * 0.38 }
    private var plusSize:   CGFloat { size * 0.18 }

    var body: some View {
        ZStack {
            // ── Tile background ────────────────────────────────────────
            RoundedRectangle(cornerRadius: tileRadius)
                .fill(Color(.systemGray6))
                .frame(width: size, height: size)

            // ── Shield with gradient ───────────────────────────────────
            ZStack {
                // Gradient fill behind the shield shape
                RoundedRectangle(cornerRadius: shieldSize * 0.28)
                    .fill(LinearGradient.clinicIcon)
                    .frame(width: shieldSize, height: shieldSize)
                    

                Image(systemName: "shield.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(LinearGradient.clinicIcon)
                    .frame(width: shieldSize, height: shieldSize)

                // ECG / heartbeat line
                Image(systemName: "waveform.path.ecg")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: ecgSize, height: ecgSize * 0.5)
                    .offset(y: size * 0.04)

                // Plus badge (top-right area of shield)
                Image(systemName: "plus")
                    .font(.system(size: plusSize, weight: .bold))
                    .foregroundStyle(.white)
                    .offset(x: shieldSize * 0.22, y: -shieldSize * 0.22)
            }
        }
    }
}

// MARK: - Previews

#Preview("Icon sizes") {
    HStack(spacing: 24) {
        ClinicFlowIcon(size: 60)
        ClinicFlowIcon(size: 88)
        ClinicFlowIcon(size: 110)
    }
    .padding(32)
}
