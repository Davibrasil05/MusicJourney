//
//  OnboardingWelcomeStep.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingWelcomeStep: View {
    let currentStep: Int
    let onNext: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Color("headerGreen").ignoresSafeArea()

            VStack(spacing: 0) {
                // ÁREA LARANJA (TOPO)
                VStack(spacing: 30) {
                    dotsRow
                        .padding(.top, 40)
                    
                    Text("Bem vindo!")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.bottom, 50)
                
                // ÁREA CREME (INFERIOR)
                VStack(spacing: 0) {
                    Spacer()
                    
                    Text("Com o MusicJourney você cria metas\npara acompanhar sua evolução!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Spacer()

                    OnboardingPrimaryButton(
                        title: "Começar",
                        isEnabled: true,
                        action: onNext
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("cardCream"))
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    private var dotsRow: some View {
        OnboardingDotsIndicator(currentStep: currentStep, totalSteps: 5)
    }

}

// MARK: - Preview

struct OnboardingWelcomeStep_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingWelcomeStep(currentStep: 0, onNext: {})
            .previewDisplayName("OnboardingWelcomeStep")
    }
}
