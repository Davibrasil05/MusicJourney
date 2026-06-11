//
//  PrimaryActionButton.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import SwiftUI

struct PrimaryActionButton: View {

    var title: String
    
    // A ação que será executada ao clicar
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                // Usando as medidas exatas que você passou
                .frame(width: 362, height: 72)
                .background(Color("buttonPurple"))
                // O cornerRadius deixa as bordas arredondadas (pela imagem parece ser algo em torno de 16)
                .cornerRadius(16)
                // Adicionando a leve sombra que dá aquele aspecto "saltado" 3D que vimos na imagem
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)
        }
    }
}

// MARK: - Preview
struct PrimaryActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            // Fundo claro apenas para destacar a sombra do botão no preview
            Color("cardCream")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                PrimaryActionButton(title: "Iniciar prática") {
                    print("Ação de iniciar clicada!")
                }
                
                PrimaryActionButton(title: "Continuar") {
                    print("Ação de continuar clicada!")
                }
            }
        }
    }
}
