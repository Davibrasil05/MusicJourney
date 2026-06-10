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
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(chipBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var chipBackground: some View {
        Capsule()
            .fill(isSelected ? Color("headerGreen") : Color("inputGray"))
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
