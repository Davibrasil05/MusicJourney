//
//  OnboardingInstrumentCard.swift
//  MusicJourney
//

import SwiftUI

/// 2x2 grid card for instrument selection. Uses a custom asset image.
struct OnboardingInstrumentCard: View {
    let title: String
    let assetName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                Image(assetName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .foregroundColor(isSelected ? Color("cardCream") : Color("textDark").opacity(0.35))

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(isSelected ? Color("headerGreen") : Color("inputGray"))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color("headerGreen") : Color("headerGreen").opacity(0.3), lineWidth: 1.5)
            )
    }
}

// MARK: - Preview

struct OnboardingInstrumentCard_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
            OnboardingInstrumentCard(title: "Violão",  assetName: "instrument-violao",  isSelected: true,  onTap: {})
            OnboardingInstrumentCard(title: "Ukulele", assetName: "instrument-ukulele", isSelected: false, onTap: {})
            OnboardingInstrumentCard(title: "Teclado", assetName: "instrument-teclado", isSelected: false, onTap: {})
            OnboardingInstrumentCard(title: "Bateria", assetName: "instrument-bateria", isSelected: false, onTap: {})
        }
        .padding(24)
        .background(Color("cardCream"))
        .previewDisplayName("OnboardingInstrumentCard")
    }
}
