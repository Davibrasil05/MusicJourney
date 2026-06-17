//
//  CompletedObjectivePopUp.swift
//  MusicJourney
//
//  Created by Academy on 12/06/26.
//

import SwiftUI

struct CompletedObjectivePopUp: View {
    let objectiveName: String
    let completionDate: Date
    let onClose: () -> Void
    
    var body: some View {
        ZStack {
            // Fundo escuro
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }
            
            // Cartão do Pop-up
            VStack(spacing: 0) {
                // Parte Laranja Superior
                ZStack {
                    Color(red: 220/255, green: 110/255, blue: 0/255)
                    
                    // Ícone centralizado
                    ZStack {
                        Image(systemName: "seal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color(red: 244/255, green: 241/255, blue: 234/255))
                        
                        Image(systemName: "checkmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(red: 220/255, green: 110/255, blue: 0/255))
                    }
                }
                .frame(height: 140)
                
                // Parte Branca Inferior
                VStack(spacing: 12) {
                    Text("Você concluiu o\nobjetivo \(objectiveName.lowercased())")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                    
                    Text(formatDate(completionDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Parabéns por finalizar o Objetivo!\nVocê já pode iniciar outro para\nnão perder o ritmo.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.8))
                        .padding(.bottom, 32)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(.horizontal, 40)
            .shadow(radius: 10)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy • HH:mm"
        return formatter.string(from: date)
    }
}

