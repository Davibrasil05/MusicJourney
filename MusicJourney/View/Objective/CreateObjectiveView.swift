//
//  CreateObjectiveView.swift
//  MusicJourney
//
//

import SwiftUI
import UniformTypeIdentifiers

struct TempGoal: Identifiable, Equatable {
    let id = UUID()
    var title: String
}

struct GoalDropDelegate: DropDelegate {
    let item: TempGoal
    @Binding var goals: [TempGoal]
    @Binding var draggingGoal: TempGoal?

    func dropEntered(info: DropInfo) {
        guard let dragging = draggingGoal else { return }
        guard let from = goals.firstIndex(of: dragging), let to = goals.firstIndex(of: item) else { return }
        
        if from != to {
            withAnimation(.default) {
                goals.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        draggingGoal = nil
        return true
    }
}


struct CreateObjectiveView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var objectiveTitle: String = ""
    @State private var goals: [TempGoal] = [TempGoal(title: "")]
    @State private var draggingGoal: TempGoal?
    @State private var deadline: Date = Date()
    @State private var reminderTime: Date = Date()
    @State private var isDailyReminder: Bool = false
    
    let bgColor = Color(red: 244/255, green: 241/255, blue: 234/255)
    let primaryRed = Color(red: 0.6, green: 0.1, blue: 0.05)
    
    var body: some View {
        NavigationView {
            ZStack {
                bgColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Título do objetivo")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            TextField("Ex: Tocar Linkin Park", text: $objectiveTitle)
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        // 2. METAS DEFINIDAS
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Metas Definidas")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Adicione 3 ou mais metas para alcançar seus objetivos")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            // Lista Dinâmica de Metas
                            ForEach($goals) { $goal in
                                let index = goals.firstIndex(where: { $0.id == goal.id }) ?? 0
                                
                                HStack {
                                    // Ícone de hambúrguer (Drag handle visual)
                                    Image(systemName: "line.3.horizontal")
                                        .foregroundColor(.gray)
                                    
                                    ZStack {
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 24, height: 24)
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                    
                                    TextField("Nome da meta...", text: $goal.title)
                                    
                                    Button(action: {
                                        if goals.count > 1 {
                                            goals.removeAll { $0.id == goal.id }
                                        }
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                                .onDrag {
                                    self.draggingGoal = goal
                                    return NSItemProvider(object: goal.id.uuidString as NSString)
                                }
                                .onDrop(of: [UTType.text], delegate: GoalDropDelegate(item: goal, goals: $goals, draggingGoal: $draggingGoal))
                                
                            }
                            Button(action: {
                              
                                withAnimation {
                                    goals.append(TempGoal(title: ""))
                                }
                            }) {
                                HStack {
                                    Image(systemName: "plus")
                                    Text("Adicionar meta")
                                }
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                        .foregroundColor(.orange)
                                )
                            }
                            .padding(.top, 8)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Prazo para conclusão")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            DatePicker("Selecionar uma data", selection: $deadline, displayedComponents: .date)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            
                            DatePicker("Horário do lembrete", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lembrete diário")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Toggle(isOn: $isDailyReminder) {
                                Text("Receba um lembrete para não esquecer sua prática")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .tint(.orange)
                        }
                        
                        Button(action: {
                            viewModel.saveFullObjective(
                                title: objectiveTitle,
                                deadline: deadline,
                                reminderTime: reminderTime,
                                isDailyReminder: isDailyReminder,
                                tempGoals: goals
                            )
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Enviar")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryRed)
                                .cornerRadius(12)
                        }
                        .padding(.top, 24)
                        .disabled(objectiveTitle.isEmpty)
                        
                    }
                    .padding()
                }
            }
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title2)
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
