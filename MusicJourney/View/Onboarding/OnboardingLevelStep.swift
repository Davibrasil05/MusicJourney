//
//  OnboardingLevelStep.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingLevelStep: View {
    let currentStep: Int
    @Binding var selectedLevel: MusicLevel?
    let canAdvance: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            Color("headerGreen").ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                cardSection
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            backButton

            VStack(spacing: 10) {
                OnboardingDotsIndicator(currentStep: currentStep, totalSteps: 5, onColoredBackground: true)

                Text("Nível de experiência")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 40)
    }

    private var backButton: some View {
        Button(action: onBack) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                Text("Voltar")
                    .font(.system(size: 16))
            }
            .foregroundColor(Color("cardCream"))
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Card

    private var cardSection: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    Text("Qual o seu nível?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("textDark"))
                        .padding(.top, 28)

                    VStack(spacing: 12) {
                        ForEach(MusicLevel.allCases) { level in
                            OnboardingTextOptionButton(
                                title: level.rawValue,
                                isSelected: selectedLevel == level,
                                onTap: { selectedLevel = level }
                            )
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding(.horizontal, 24)
            }

            OnboardingPrimaryButton(
                title: "Continuar",
                isEnabled: canAdvance,
                action: onNext
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("cardCream"))
        .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview

struct OnboardingLevelStep_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingLevelStep(
            currentStep: 1,
            selectedLevel: .constant(.iniciante),
            canAdvance: true,
            onBack: {},
            onNext: {}
        )
        .previewDisplayName("OnboardingLevelStep")
    }
}
