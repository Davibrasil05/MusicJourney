//
//  ObjectiveWarning.swift
//  MusicJourney
//
//  Created by Academy on 15/06/26.
//

import SwiftUI

struct ObjectiveWarning: View {
    var title: String = "Atenção!"
    var message: String = "Você já possui um objetivo em andamento.\nSe você criar um novo, o atual será desativado."
    var cancelTitle: String = "Cancelar"
    var confirmTitle: String = "Continuar"
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
            
            VStack {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.14)
                
                VStack(spacing: 0) {
                    ZStack {
                        Color("headerGreen")
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color(red: 244/255, green: 241/255, blue: 234/255))
                    }
                    .frame(height: 120)
                    
                    VStack(spacing: 16) {
                        Text(title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                        
                        Text(message)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black.opacity(0.8))
                            
                        HStack(spacing: 12) {
                            Button(action: onCancel) {
                                Text(cancelTitle)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                            }
                            
                            Button(action: onConfirm) {
                                Text(confirmTitle)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
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
                .padding(.horizontal, 28)
                .shadow(radius: 10)
                
                Spacer()
            }
        }
    }
}

struct ObjectiveWarning_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ObjectiveWarning(
                onCancel: {},
                onConfirm: {}
            )
            .previewDisplayName("Objetivo em andamento")
            
            ObjectiveWarning(
                title: "Atenção!",
                message: "Você praticou por menos de 3 minutos.\nQuer concluir tão rápido assim ou prefere praticar mais?",
                cancelTitle: "Praticar mais",
                confirmTitle: "Concluir",
                onCancel: {},
                onConfirm: {}
            )
            .previewDisplayName("Conclusão antecipada")
        }
    }
}
