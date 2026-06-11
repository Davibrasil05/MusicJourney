import SwiftUI

struct BPMAdjustButtonsView: View {
    var onDecrement: () -> Void
    var onIncrement: () -> Void
    var onStop: () -> Void
    
    var body: some View {
        HStack(spacing: 40) {
            Button(action: onDecrement) {
                Image(systemName: "minus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
            }
            
            Button(action: onStop) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    // 1. Define o tamanho do quadrado azul por dentro
                    .frame(width: 44, height: 44)
                    // 2. Define o tamanho total da caixa por fora
                    .frame(width: 57, height: 57)
                    // 3. Aplica a linha preta respeitando o frame de fora (57x57)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12) // O raio de fora costuma ser maior pra ficar harmonioso
                            .stroke(Color.black, lineWidth: 2)
                    )
            }
            
            Button(action: onIncrement) {
                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
            }
        }
    }
}
