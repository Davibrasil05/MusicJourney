//
//  OnboardingTextOptionButton.swift
//  MusicJourney
//

import SwiftUI

/// Full-width single-select button with centered text.
/// Used for Experience Level and any other single-option list.
struct OnboardingTextOptionButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(buttonBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(isSelected ? Color("headerGreen") : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("headerGreen"), lineWidth: 1.5)
            )
    }
}

// MARK: - Preview

struct OnboardingTextOptionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            OnboardingTextOptionButton(title: "Iniciante",     isSelected: true,  onTap: {})
            OnboardingTextOptionButton(title: "Intermediário", isSelected: false, onTap: {})
            OnboardingTextOptionButton(title: "Avançado",      isSelected: false, onTap: {})
        }
        .padding(24)
        .background(Color("cardCream"))
        .previewDisplayName("OnboardingTextOptionButton")
    }
}
