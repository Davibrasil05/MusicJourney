//
//  OnboardingGenreStep.swift
//  MusicJourney
//

import SwiftUI

struct OnboardingGenreStep: View {
    let currentStep: Int
    @Binding var selectedGenres: Set<MusicGenre>
    let canAdvance: Bool
    let onBack: () -> Void
    let onNext: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                headerSection
                    .frame(height: geometry.size.height * 0.28)
                    .background(Color("headerGreen"))

                cardSection
                    .frame(maxHeight: .infinity)
            }
            .background(Color("headerGreen").ignoresSafeArea())
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            backButton

            VStack(spacing: 10) {
                OnboardingDotsIndicator(currentStep: currentStep, totalSteps: 5, onColoredBackground: true)

                Text("Gêneros músicais")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("cardCream"))
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
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
                    Text("Qual estilo você gosta ?")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("textDark"))
                        .padding(.top, 28)

                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(MusicGenre.allCases) { genre in
                            OnboardingGenreChip(
                                title: genre.rawValue,
                                isSelected: selectedGenres.contains(genre),
                                onTap: {
                                    if selectedGenres.contains(genre) {
                                        selectedGenres.remove(genre)
                                    } else {
                                        selectedGenres.insert(genre)
                                    }
                                }
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
        .background(
            Color("cardCream")
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

// MARK: - Preview

struct OnboardingGenreStep_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingGenreStep(
            currentStep: 3,
            selectedGenres: .constant([.rock, .jazz]),
            canAdvance: true,
            onBack: {},
            onNext: {}
        )
        .previewDisplayName("OnboardingGenreStep")
    }
}
