//
//  GoalDetailView.swift
//  MusicJourney
//
//  Created by Academy on 10/06/26.
//

import SwiftUI

struct GoalDetailView: View {
    // Para atualizar a tela automaticamente quando o Core Data mudar
    @ObservedObject var goal: Goal
    
    // Convertendo o NSSet do Core Data para um Array Swift ordenado
    var pastSessions: [Session] {
        let set = goal.sessions as? Set<Session> ?? []
        // Ordena para que as sessões mais recentes apareçam no topo
        return set.sorted { ($0.createdAt ?? Date()) > ($1.createdAt ?? Date()) }
    }
    
    var body: some View {
        VStack {
            // Cabeçalho com info da meta
            VStack(spacing: 8) {
                Text(goal.textDescription ?? "Sem descrição")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
            // Lista de sessões passadas
            List {
                Section(header: Text("Histórico de Práticas")) {
                    if pastSessions.isEmpty {
                        Text("Você ainda não praticou esta meta.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(pastSessions) { session in
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    // Formata a data (ex: 05 Jun 2026)
                                    Text(session.createdAt ?? Date(), style: .date)
                                        .font(.headline)
                                    // Mostra a duração formatada
                                    Text("Duração: \(formatDuration(seconds: Int(session.duration)))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            }
            
            // Botão flutuante ou fixo embaixo para Iniciar a Prática
            NavigationLink(destination: PracticeSessionView(goal: goal)) {
                Text("Adicionar Nova Sessão")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(goal.name ?? "Detalhe da Meta")
    }
    
    // Função auxiliar para deixar os segundos bonitos (ex: "12m 30s")
    private func formatDuration(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return "\(minutes)m \(remainingSeconds)s"
    }
}
