//
//  OnboardingPrimaryButton.swift
//  MusicJourney
//

import SwiftUI

/// Primary action button used at the bottom of each onboarding step.
struct OnboardingPrimaryButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(
                    isEnabled ? Color("cardCream") : Color("cardCream").opacity(0.5)
                )
                .frame(width: 362, height: 72)
                .background(buttonBackground)
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }

    private var buttonBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(isEnabled ? Color("primaryBlue") : Color("inputGray"))
    }
}

// MARK: - Preview

struct OnboardingPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            OnboardingPrimaryButton(title: "Próximo",        isEnabled: true,  action: {})
            OnboardingPrimaryButton(title: "Começar Jornada", isEnabled: false, action: {})
        }
        .padding()
        .previewDisplayName("OnboardingPrimaryButton")
    }
}
