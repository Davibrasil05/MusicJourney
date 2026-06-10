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
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(chipBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var chipBackground: some View {
        Capsule()
            .fill(isSelected ? Color("headerGreen") : Color.clear)
            .overlay(
                Capsule()
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
