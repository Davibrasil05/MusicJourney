//
//  PracticeView.swift
//  MusicJourney
//
//  Created by Academy on 10/06/26.
//
// PracticeSessionView.swift
import SwiftUI

struct PracticeSessionView: View {
    // A meta que foi clicada na tela anterior!
    var goal: Goal
    
    // Seu ViewModel que vai lidar com o Repository e o Timer
    @StateObject private var viewModel = PracticeViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Praticando: \(goal.name ?? "")")
                .font(.title2)
                .bold()
            
            // Exemplo visual do Timer
            Text(viewModel.formattedTime)
                .font(.system(size: 70, weight: .bold, design: .monospaced))
            
            HStack(spacing: 20) {
                if !viewModel.isPracticing {
                    Button(action: {
                        // 1. O usuário aperta o play
                        // 2. O ViewModel vai no Repository, cria a Session e atrela ao Goal
                        viewModel.startPractice(for: goal)
                    }) {
                        Text("Iniciar Prática")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {
                        // 1. O usuário termina
                        // 2. O ViewModel atualiza a Session salva no banco com a duração final
                        viewModel.finishPractice()
                    }) {
                        Text("Concluir Sessão")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sessão Prática")
        .navigationBarTitleDisplayMode(.inline)
    }
}
