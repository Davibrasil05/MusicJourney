//
//  ObjectiveListView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//
import SwiftUI

struct ObjectiveListView: View {
    @StateObject private var viewModel = ObjectiveRepository()
    
    @State private var showingAddSheet = false
    @State private var newObjectiveName = ""
    @State private var newObjectiveDescription = "" // Novo: Variável para a descrição
    
    var body: some View {
        NavigationView {
            Group {
                // MARK: - Estado Vazio (Conforme o PDF)
                if viewModel.objectives.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Sua jornada começa aqui!")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Crie seu primeiro objetivo para começar a praticar e gerar suas metas.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: { showingAddSheet = true }) {
                            Text("Criar Primeiro Objetivo")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue) // Altere para a cor de acento do seu app
                                .cornerRadius(12)
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 10)
                    }
                }
                // MARK: - Estado Normal (Lista)
                else {
                    List {
                        ForEach(viewModel.objectives) { objective in
                            NavigationLink(destination: ObjectiveDetailView(viewModel: viewModel, objective: objective)) {
                                HStack {
                                    // Atualizado: Agora checa se a String é "completed"
                                    Image(systemName: objective.status == "completed" ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(objective.status == "completed" ? .green : .gray)
                                        .onTapGesture {
                                            viewModel.toggleObjectiveStatus(objective: objective)
                                        }
                                    
                                    VStack(alignment: .leading) {
                                        Text(objective.name ?? "Objetivo Sem Nome")
                                            .strikethrough(objective.status == "completed")
                                            .fontWeight(.semibold)
                                        
                                        // Mostra a descrição abaixo do nome, se existir
                                        if let desc = objective.descriptionText, !desc.isEmpty {
                                            Text(desc)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .strikethrough(objective.status == "completed")
                                                .lineLimit(1)
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteObjective)
                    }
                }
            } 
            .navigationTitle("Histórico") // Ou "Meus Objetivos", confira com o design do seu app
            .toolbar {
                // Só mostra o botão "+" no topo se a lista já tiver itens
                ToolbarItem(placement: .navigationBarTrailing) {
                        if !viewModel.objectives.isEmpty {
                        Button(action: { showingAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            // MARK: - Modal de Criação (Sheet)
            .sheet(isPresented: $showingAddSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("O que você quer aprender?")) {
                            TextField("Nome (ex: Tocar a música X)", text: $newObjectiveName)
                            TextField("Descrição (opcional)", text: $newObjectiveDescription) // Adicionado
                        }
                    }
                    .navigationTitle("Novo Objetivo")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancelar") {
                                resetSheetState()
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Salvar") {
                                if !newObjectiveName.isEmpty {
                                    // Agora envia nome E descrição para a ViewModel!
                                    viewModel.addObjective(name: newObjectiveName, descriptionText: newObjectiveDescription)
                                    resetSheetState()
                                }
                            }
                            .disabled(newObjectiveName.isEmpty)
                        }
                    }
                }
            }
        }
    }
    
    // Helper para limpar os campos ao fechar a modal
    private func resetSheetState() {
        newObjectiveName = ""
        newObjectiveDescription = ""
        showingAddSheet = false
    }
}
