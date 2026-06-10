//
//  OnboardingWelcomeStep.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingWelcomeStep: View {
    let currentStep: Int
    let onNext: () -> Void

    var body: some View {
        ZStack {
            Color("cardCream").ignoresSafeArea()

            VStack(spacing: 0) {
                dotsRow
                    .padding(.top, 60)

                Spacer()

                welcomeContent

                Spacer()

                OnboardingPrimaryButton(
                    title: "Começar",
                    isEnabled: true,
                    action: onNext
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }

    private var dotsRow: some View {
        OnboardingDotsIndicator(currentStep: currentStep, totalSteps: 5)
    }

    private var welcomeContent: some View {
        VStack(spacing: 12) {
            Text("Bem vindo!")
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color("textDark"))

            Text("Com o MusicJourney você cria\nmetas para acompanhar sua evolução")
                .font(.system(size: 15))
                .foregroundColor(Color("textDark").opacity(0.65))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 32)
    }
}

// MARK: - Preview

struct OnboardingWelcomeStep_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcomeStep(currentStep: 0, onNext: {})
            .previewDisplayName("OnboardingWelcomeStep")
    }
}
