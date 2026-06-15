//
//  ObjectiveWarning.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import SwiftUI

struct ObjectiveWarning: View {
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            // Fundo escuro
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            // Cartão do Pop-up
            VStack(spacing: 0) {
                // Parte Colorida Superior
                ZStack {
                    Color("headerGreen")
                    
                    // Ícone centralizado
                    Image(systemName: "exclamationmark.triangle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(Color(red: 244/255, green: 241/255, blue: 234/255))
                }
                .frame(height: 120)
                
                // Parte Branca Inferior
                VStack(spacing: 16) {
                    Text("Atenção!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                    
                    Text("Você já possui um objetivo em andamento.\nSe você criar um novo, o atual será desativado.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black.opacity(0.8))
                        
                    HStack(spacing: 16) {
                        Button(action: onCancel) {
                            Text("Cancelar")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(12)
                        }
                        
                        Button(action: onConfirm) {
                            Text("Continuar")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color("headerGreen"))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 24)
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
}
