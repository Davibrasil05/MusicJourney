//
//  OnboardingInstrumentCard.swift
//  MusicJourney
//

import SwiftUI

/// Card used in the Instrument selection step.
struct OnboardingInstrumentCard: View {
    let title: String
    let sfSymbol: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                Image(systemName: sfSymbol)
                    .font(.system(size: 26))
                    .foregroundColor(
                        isSelected ? Color("buttonPurple") : Color("textDark").opacity(0.5)
                    )
                    .frame(height: 34)

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color("textDark"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color("inputGray"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isSelected ? Color("buttonPurple") : Color.clear,
                                lineWidth: 2.5
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - Preview

struct OnboardingInstrumentCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 12) {
            OnboardingInstrumentCard(title: "Violão",   sfSymbol: "guitars",         isSelected: true,  onTap: {})
            OnboardingInstrumentCard(title: "Bateria",  sfSymbol: "music.note.list", isSelected: false, onTap: {})
            OnboardingInstrumentCard(title: "Teclado",  sfSymbol: "pianokeys",       isSelected: false, onTap: {})
        }
        .padding()
        .previewDisplayName("OnboardingInstrumentCard")
    }
}
