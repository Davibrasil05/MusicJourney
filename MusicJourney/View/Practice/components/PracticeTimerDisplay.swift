//
//  PracticeTimerDisplay.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import SwiftUI

struct PracticeTimerDisplay: View {
    var timeString: String
    
    var body: some View {
        Text(timeString)
            .font(.system(size: 64, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(minWidth: 220)
            .padding(.vertical, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.45), lineWidth: 2)
            )
    }
}

// MARK: - Preview
struct PracticeTimerDisplay_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Simulando o fundo laranja/marrom da sua tela para podermos ver as letras brancas
            Color("headerGreen")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                PracticeTimerDisplay(timeString: "00:00")
                PracticeTimerDisplay(timeString: "04:20")
            }
        }
    }
}
