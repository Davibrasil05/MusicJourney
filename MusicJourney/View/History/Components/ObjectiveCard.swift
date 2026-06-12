//
//  ObjectiveCard.swift
//  MusicJourney
//
//  Created by Academy on 12/06/26.
//

import SwiftUI

struct ObjectiveCard: View {
    let objective: Objective
    
    // Ícone simulado usando hash do nome para variar, baseado na imagem do Figma
    private var iconName: String {
        let icons = ["trophy.fill", "guitars.fill", "checkmark.seal.fill", "star.fill"]
        let hash = abs(objective.name?.hashValue ?? 0)
        return icons[hash % icons.count]
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Lado Laranja com o ícone
            ZStack {
                Color("headerGreen")
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .frame(width: 100) // Mais largo para o Capsule não esmagar
            
            // Dados (Nome e Data)
            VStack(alignment: .leading, spacing: 12) {
                Text(objective.name ?? "Objetivo Concluído")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                if let date = objective.completedAt {
                    Text(formatDate(date))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.clear)
        }
        .frame(minHeight: 100)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color("headerGreen"), lineWidth: 2))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy • HH:mm"
        return formatter.string(from: date)
    }
}

