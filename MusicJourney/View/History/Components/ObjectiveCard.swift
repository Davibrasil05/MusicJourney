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
        let mainColor = Color("headerGreen")
        let bgColor = Color("backgroundCards")
        
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 50)
                .fill(bgColor)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .strokeBorder(mainColor, lineWidth: 2)
                )
            
            HStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(mainColor)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(bgColor)
                }
                
                Spacer().frame(width: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(objective.name ?? "Objetivo Concluído")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    
                    if let date = objective.completedAt {
                        Text(formatDate(date))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy • HH:mm"
        return formatter.string(from: date)
    }
}

