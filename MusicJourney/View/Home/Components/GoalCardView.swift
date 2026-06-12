import SwiftUI

struct GoalCardView: View {
    var goalName: String
    var state: GoalState
    
    var body: some View {
        let isLocked = state == .locked
        // A cor laranja é chamada de headerGreen no seu Assets
        let mainColor = isLocked ? Color.gray : Color("headerGreen")
        // O fundo da tag onde fica o nome
        let bgColor = Color("backgroundCards")
        
        ZStack(alignment: .leading) {
            // Fundo do card em formato de pílula (Capsule)
            RoundedRectangle(cornerRadius: 50)
                .fill(bgColor)
                .frame(width: 363, height: 100)
                // Contorno do card
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke(mainColor, lineWidth: 2)
                )
            
            HStack(spacing: 0) {
                // Círculo esquerdo (Laranja se ativo, Cinza se bloqueado)
                ZStack {
                    Circle()
                        .fill(mainColor)
                        .frame(width: 100, height: 100)
                    
                    // Ícone no meio do círculo
                    Image(systemName: isLocked ? "music.note" : "guitars.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(bgColor) // Cor do ícone = backgroundCards
                }
                
                // Espaçamento exato de 20 entre o círculo e o texto
                Spacer().frame(width: 20)
                
                // Título da Meta
                Text(goalName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isLocked ? .gray : .black)
                
                Spacer()
                
                // Cadeado (Se bloqueado)
                if isLocked {
                    Image(systemName: "lock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 24)
                        .foregroundColor(.gray)
                        .padding(.trailing, 24)
                }
            }
            .frame(width: 363, height: 100)
        }
    }
}
