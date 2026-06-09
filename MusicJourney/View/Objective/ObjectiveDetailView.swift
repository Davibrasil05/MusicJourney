import SwiftUI

struct ObjectiveDetailView: View {
    @ObservedObject var viewModel: ObjectiveViewModel
    var objective: Objective
    
    @State private var showingAddGoalSheet = false
 
    @State private var newGoalName = ""
    @State private var newGoalDescription = ""
    @State private var newGoalCategory = "Técnica"
    @State private var newGoalDifficulty = "Média"
    @State private var newGoalPriority: Int16 = 1
    @State private var newGoalTime = Date()
    
    let categories = ["Técnica", "Repertório", "Teoria", "Leitura", "Outros"]
    let difficulties = ["Fácil", "Média", "Difícil", "Mestre"]
    
    var goals: [Goal] {
        let set = objective.goals as? Set<Goal> ?? []
        return set.sorted { ($0.priority) > ($1.priority) } // Ordena por prioridade
    }
    
    var body: some View {
        List {
            Section(header: Text("Metas (Goals)")) {
                if goals.isEmpty {
                    Text("Nenhuma meta ainda. Adicione uma!")
                        .foregroundColor(.gray)
                } else {
                    ForEach(goals) { goal in
                        HStack {
                            Image(systemName: goal.status ? "checkmark.square.fill" : "square")
                                .foregroundColor(goal.status ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleGoalStatus(goal: goal)
                                }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(goal.name ?? "Meta sem nome")
                                        .font(.headline)
                                        .strikethrough(goal.status)
                                    Spacer()
                                    if goal.priority > 3 {
                                        Image(systemName: "exclamationmark.circle.fill").foregroundColor(.red)
                                    }
                                }
                                Text(goal.description_name ?? "").font(.subheadline)
                                HStack {
                                    Text("Cat: \(goal.category ?? "")")
                                    Text("• Dif: \(goal.difficulty ?? "")")
                                    Spacer()
                                    Text(goal.time ?? Date(), style: .date)
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
                    
                    Section(header: Text("Classificação")) {
                        Picker("Categoria", selection: $newGoalCategory) {
                            ForEach(categories, id: \.self) { Text($0) }
                        }
                        Picker("Dificuldade", selection: $newGoalDifficulty) {
                            ForEach(difficulties, id: \.self) { Text($0) }
                        }
                        Stepper("Prioridade (1 a 5): \(newGoalPriority)", value: $newGoalPriority, in: 1...5)
                    }
                    
                    Section(header: Text("Prazo")) {
                        DatePicker("Data limite", selection: $newGoalTime, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                .navigationTitle("Nova Meta")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancelar") { showingAddGoalSheet = false }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salvar") {
                            viewModel.addGoal(to: objective, name: newGoalName, descriptionName: newGoalDescription, category: newGoalCategory, difficulty: newGoalDifficulty, priority: newGoalPriority, time: newGoalTime)
                            newGoalName = ""
                            newGoalDescription = ""
                            newGoalPriority = 1
                            showingAddGoalSheet = false
                        }
                        .disabled(newGoalName.isEmpty)
                    }
                }
            }
        }
    }
}
