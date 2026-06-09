//
//  ObjectiveListView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//
import SwiftUI

struct ObjectiveListView: View {
    @StateObject private var viewModel = ObjectiveViewModel()
    
    // Trocamos Alert por Sheet
    @State private var showingAddSheet = false
    @State private var newObjectiveName = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.objectives) { objective in
                    NavigationLink(destination: ObjectiveDetailView(viewModel: viewModel, objective: objective)) {
                        HStack {
                            Image(systemName: objective.status ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(objective.status ? .green : .gray)
                                .onTapGesture {
                                    viewModel.toggleObjectiveStatus(objective: objective)
                                }
                            
                            Text(objective.name ?? "Objetivo Sem Nome")
                                .strikethrough(objective.status)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteObjective)
            }
            .navigationTitle("Meus Objetivos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            // Aqui está a mágica: Usamos um Sheet com um Form!
            .sheet(isPresented: $showingAddSheet) {
                NavigationView {
                    Form {
                        TextField("Nome do objetivo", text: $newObjectiveName)
                    }
                    .navigationTitle("Novo Objetivo")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancelar") {
                                newObjectiveName = ""
                                showingAddSheet = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Salvar") {
                                if !newObjectiveName.isEmpty {
                                    viewModel.addObjective(name: newObjectiveName)
                                    newObjectiveName = ""
                                    showingAddSheet = false
                                }
                            }
                            // O botão salvar fica cinza se estiver vazio
                            .disabled(newObjectiveName.isEmpty)
                        }
                    }
                }
            }
        }
    }
}
