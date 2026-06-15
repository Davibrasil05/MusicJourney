//
//  OnboardingDotsIndicator.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingDotsIndicator: View {
    let currentStep: Int
    let totalSteps: Int
    var onColoredBackground: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 20)
                    .fill(dotColor(for: index))
                    .frame(width: dotSize(for: index), height: dotSize(for: index))
                    .animation(.easeInOut(duration: 0.25), value: currentStep)
            }
        }
    }

    private func dotColor(for index: Int) -> Color {
        let base = onColoredBackground ? Color("cardCream") : Color("textDark")
        return index == currentStep ? base : base.opacity(0.35)
    }

    private func dotSize(for index: Int) -> CGFloat {
        index == currentStep ? 10 : 8
    }
}

// MARK: - Preview

struct OnboardingDotsIndicator_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            OnboardingDotsIndicator(currentStep: 0, totalSteps: 5)
            OnboardingDotsIndicator(currentStep: 2, totalSteps: 5, onColoredBackground: true)
                .padding()
                .background(Color("headerGreen"))
            OnboardingDotsIndicator(currentStep: 4, totalSteps: 5)
        }
        .padding()
        .previewDisplayName("OnboardingDotsIndicator")
    }
}
