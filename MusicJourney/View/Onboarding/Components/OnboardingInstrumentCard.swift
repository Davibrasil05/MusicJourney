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
                    .frame(width: 35, height: 35)
                    .foregroundColor(isSelected ? Color("cardCream") : .black)

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? Color("cardCream") : Color("textDark"))
            }
            .frame(width: 167, height: 140)
            .background(cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(isSelected ? Color("headerGreen") : Color("backgroundCards"))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(isSelected ? Color("headerGreen") : Color("headerGreen").opacity(0.3), lineWidth: 2.5)
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
