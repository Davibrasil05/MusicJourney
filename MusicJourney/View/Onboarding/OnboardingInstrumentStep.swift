//
//  OnboardingInstrumentStep.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingInstrumentStep: View {
    let currentStep: Int
    @Binding var selectedInstrument: MusicInstrument?
    let canAdvance: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    private let columns = [GridItem(.flexible(), spacing: 28), GridItem(.flexible())]

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

                Text("Instrumento")
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
                VStack(spacing: 20) {
                    Text("Qual instrumento\nvocê toca?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("textDark"))
                        .multilineTextAlignment(.center)
                        .padding(.top, 56)

                    LazyVGrid(columns: columns, spacing: 28) {
                        ForEach(MusicInstrument.allCases) { instrument in
                            OnboardingInstrumentCard(
                                title: instrument.rawValue,
                                assetName: instrument.assetName,
                                isSelected: selectedInstrument == instrument,
                                onTap: { selectedInstrument = instrument }
                            )
                        }
                    }
                    .padding(.bottom, 68)
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
            .padding(.top, 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("cardCream"))
        .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Preview

struct OnboardingInstrumentStep_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingInstrumentStep(
            currentStep: 2,
            selectedInstrument: .constant(.violao),
            canAdvance: true,
            onBack: {},
            onNext: {}
        )
        .previewDisplayName("OnboardingInstrumentStep")
    }
}
