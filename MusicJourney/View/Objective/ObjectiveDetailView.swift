//
//  ObjectiveDetailView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//
import SwiftUI

struct ObjectiveDetailView: View {
    @ObservedObject var viewModel: ObjectiveRepository
    var objective: Objective
    
    @State private var showingAddGoalSheet = false
 
    @State private var newGoalName = ""
    @State private var newGoalDescription = ""
    @State private var newGoalCategory = "Técnica"
    @State private var newGoalDifficulty = "Média"
    @State private var newGoalOrder: Int16 = 1 // Mudou: Agora usamos 'order' no lugar de 'priority'
    
    let categories = ["Técnica", "Repertório", "Teoria", "Leitura", "Outros"]
    let difficulties = ["Fácil", "Média", "Difícil", "Mestre"]
    
    var goals: [Goal] {
        let set = objective.goals as? Set<Goal> ?? []
        // Mudou: Agora ordena apenas pela 'order' em ordem crescente (Passo 1, Passo 2...)
        return set.sorted { $0.order < $1.order }
    }
    
    var body: some View {
        List {
            Section(header: Text("Trilha de Metas")) {
                if goals.isEmpty {
                    Text("Nenhuma meta ainda. Adicione uma!")
                        .foregroundColor(.gray)
                } else {
                    ForEach(goals) { goal in
                        HStack {
                            // Mudou: Status agora é comparado como String
                            Image(systemName: goal.status == "completed" ? "checkmark.square.fill" : "square")
                                .foregroundColor(goal.status == "completed" ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleGoalStatus(goal: goal)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(goal.name ?? "Meta sem nome")
                                        .font(.headline)
                                        .strikethrough(goal.status == "completed") // Mudou: String
                                    Spacer()
                                    // Bônus: Como não temos mais prioridade, coloquei uma estrelinha
                                    // laranja caso a meta seja a dificuldade "Mestre"
                                    if goal.difficulty == "Mestre" {
                                        Image(systemName: "star.fill").foregroundColor(.orange)
                                    }
                                }
                                // Mudou: Agora é textDescription
                                Text(goal.textDescription ?? "").font(.subheadline)
                                HStack {
                                    Text("Cat: \(goal.category ?? "")")
                                    Text("• Dif: \(goal.difficulty ?? "")")
                                }
                                .font(.caption)
                                .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        if let index = indexSet.first {
                            viewModel.deleteGoal(goal: goals[index])
                        }
                    }
                }
            }
        }
        .navigationTitle(objective.name ?? "Detalhes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddGoalSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGoalSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Informações Básicas")) {
                        TextField("Nome da meta", text: $newGoalName)
                        TextField("Breve descrição", text: $newGoalDescription)
                    }
                    
                    Section(header: Text("Classificação e Ordem")) {
                        Picker("Categoria", selection: $newGoalCategory) {
                            ForEach(categories, id: \.self) { Text($0) }
                        }
                        Picker("Dificuldade", selection: $newGoalDifficulty) {
                            ForEach(difficulties, id: \.self) { Text($0) }
                        }
                        // Mudou: Stepper agora controla a etapa/ordem da meta na trilha
                        Stepper("Ordem na trilha: \(newGoalOrder)º", value: $newGoalOrder, in: 1...20)
                    }
                    // A seção de Prazo (time) foi removida porque não existe mais no Core Data
                }
                .navigationTitle("Nova Meta")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancelar") { showingAddGoalSheet = false }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salvar") {
                            // Mudou: A função agora chama os parâmetros corretos da nova ViewModel!
                            viewModel.addGoal(to: objective,
                                              name: newGoalName,
                                              textDescription: newGoalDescription,
                                              category: newGoalCategory,
                                              difficulty: newGoalDifficulty,
                                              order: newGoalOrder)
                            
                            newGoalName = ""
                            newGoalDescription = ""
                            newGoalOrder = 1
                            showingAddGoalSheet = false
                        }
                        .disabled(newGoalName.isEmpty)
                    }
                }
            }
        }
    }
}
