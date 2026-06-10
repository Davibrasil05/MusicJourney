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
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(buttonBackground)
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }

    private var buttonBackground: some View {
        Capsule()
            .fill(isEnabled ? Color("buttonPurple") : Color("inputGray"))
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
