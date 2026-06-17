//
//  OnboardingStepHeader.swift
//  MusicJourney
//

import SwiftUI

// MARK: - View

struct OnboardingStepHeader: View {
    let currentStep: Int
    let totalSteps: Int
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 14) {
            progressIndicator
            titleBlock
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .padding(.top, 52)
        .padding(.bottom, 20)
    }

    private var progressIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        index <= currentStep
                            ? Color("textDark")
                            : Color("textDark").opacity(0.22)
                    )
                    .frame(width: index == currentStep ? 28 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
    }

    private var titleBlock: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color("textDark"))
                .multilineTextAlignment(.center)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundColor(Color("textDark").opacity(0.65))
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Preview

struct OnboardingStepHeader_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStepHeader(
            currentStep: 1,
            totalSteps: 4,
            title: "Qual instrumento você toca?",
            subtitle: "Escolha seu instrumento principal"
        )
        .background(Color("headerGreen"))
        .previewDisplayName("OnboardingStepHeader")
    }
}
