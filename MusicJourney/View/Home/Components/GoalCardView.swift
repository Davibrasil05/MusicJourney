//
//  GoalCardView.swift
//  MusicJourney
//
//  Created by Academy on 11/06/26.
//

import SwiftUI
struct GoalCardView: View {
    var goalName: String
    var state: GoalState
    
    var body: some View {
        HStack(spacing: 16) {
            // O ícone da esquerda muda de cor se estiver bloqueado
            ZStack {
                Circle()
                    .fill(state == .locked ? Color.gray.opacity(0.4) : Color.orange)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "guitars.fill") // Use seu ícone correto aqui
                    .foregroundColor(state == .locked ? .gray : .white)
            }
            
            // O texto fica clarinho se estiver bloqueado
            Text(goalName)
                .font(.headline)
                .foregroundColor(state == .locked ? .gray : .black)
            
            Spacer()
            
            // O cadeado gigante na direita (só aparece se estiver locked)
            if state == .locked {
                Image(systemName: "lock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 40)
                    .foregroundColor(Color.gray.opacity(0.5))
            }
        }
        .padding()
        .frame(height: 90) // Altura fixa aproximada do Figma
        // As cores de fundo mudam baseadas no estado
        .background(state == .locked ? Color.gray.opacity(0.15) : Color(white: 0.95))
        .cornerRadius(16)
        // A borda laranja só aparece quando a meta está ATIVA
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(state == .active ? Color.orange : Color.clear, lineWidth: 2)
        )
    }
}
