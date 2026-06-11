//
//  PracticeBottomSheet.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import SwiftUI

// MARK: - Shape customizado para arredondar apenas cantos específicos (iOS 15)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Componente do Botão da Grade
struct ToolGridButton: View {
    var title: String
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 12) {

                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .foregroundColor(Color("textDark"))
                
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(width: 167, height: 140)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("headerGreen"), lineWidth: 2)
            )
            .background(Color.clear)
        }
    }
}

// MARK: - Componente Principal (A Gaveta Inferior)
struct PracticeBottomSheet: View {
    
    // Ações que a View Principal vai receber quando o usuário clicar em algo
    var onNoteTapped: () -> Void
    var onAudioTapped: () -> Void
    var onTabTapped: () -> Void
    var onMetronomeTapped: () -> Void
    var onStartPracticeTapped: () -> Void
    
    // Configuração das duas colunas da Grid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 32) {
            LazyVGrid(columns: columns, spacing: 20) {
                ToolGridButton(title: "Nota", iconName: "square.and.pencil", action: onNoteTapped)
                ToolGridButton(title: "Áudio", iconName: "mic.fill", action: onAudioTapped)
                ToolGridButton(title: "Tablatura", iconName: "doc.text.fill", action: onTabTapped)
                ToolGridButton(title: "Metrônomo", iconName: "metronome.fill", action: onMetronomeTapped)
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            // O botão principal que fizemos no passo anterior
            PrimaryActionButton(title: "Iniciar prática") {
                onStartPracticeTapped()
            }
            
            // Empurra tudo para cima e deixa um respiro no fundo
            Spacer()
        }
        .frame(maxWidth: .infinity)
        // Cor do fundo
        .background(Color("cardCream"))
        // Arredonda APENAS os cantos superiores
        .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

// MARK: - Preview
struct PracticeBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            // Fundo da tela inteira (headerGreen)
            Color("headerGreen")
                .ignoresSafeArea()
            
            // O BottomSheet colado embaixo
            PracticeBottomSheet(
                onNoteTapped: { print("Nota") },
                onAudioTapped: { print("Audio") },
                onTabTapped: { print("Tab") },
                onMetronomeTapped: { print("Metronomo") },
                onStartPracticeTapped: { print("Iniciar") }
            )
            // Faz o card cobrir aquela margem branca do fundo da tela
            .ignoresSafeArea(edges: .bottom)
            // Ocupa mais ou menos 65% da tela para deixar o timer aparecer em cima
            .frame(height: UIScreen.main.bounds.height * 0.65)
        }
    }
}
