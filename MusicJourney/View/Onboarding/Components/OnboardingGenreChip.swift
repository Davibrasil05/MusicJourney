//
//  OnboardingGenreChip.swift
//  MusicJourney
//

import SwiftUI

/// Multi-select chip used in the Genre selection step (Step 3).
struct OnboardingGenreChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))
                .frame(width: 167, height: 56)
                .background(chipBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var chipBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(isSelected ? Color("headerGreen") : Color("backgroundCards"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("headerGreen"), lineWidth: 1.5)
            )
    }
}

// MARK: - Preview

struct OnboardingGenreChip_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 10) {
            OnboardingGenreChip(title: "Rock",      isSelected: true,  onTap: {})
            OnboardingGenreChip(title: "MPB",       isSelected: false, onTap: {})
            OnboardingGenreChip(title: "Sertanejo", isSelected: true,  onTap: {})
        }
        .padding()
        .previewDisplayName("OnboardingGenreChip")
    }
}
