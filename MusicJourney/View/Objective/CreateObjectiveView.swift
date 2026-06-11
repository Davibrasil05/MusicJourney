//
//  CreateObjectiveView.swift
//  MusicJourney
//

import SwiftUI

struct CreateObjectiveView: View {
    let onFinish: () -> Void

    @StateObject private var viewModel = CreateObjectiveViewModel()
    @State private var createdObjective: Objective?
    @State private var navigateToGoals = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()

                // Hidden NavigationLink activated after objective is created
                NavigationLink(
                    destination: createdObjective.map { obj in
                        AddGoalsView(objective: obj, onFinish: onFinish)
                    },
                    isActive: $navigateToGoals
                ) { EmptyView() }.hidden()

                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Qual é o seu objetivo?")
                                .font(.title2)
                                .fontWeight(.bold)

                            Text("Seja específico — isso ajuda a IA a gerar metas mais relevantes para você.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Título do objetivo")
                                .font(.headline)
                                .fontWeight(.semibold)

                            TextField("Ex: Tocar Linkin Park", text: $viewModel.title)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            if let objective = viewModel.createObjective() {
                                createdObjective = objective
                                navigateToGoals = true
                            }
                        }) {
                            Text("Continuar")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.canContinue ? Color.accentColor : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(!viewModel.canContinue)
                    }
                    .padding()
                }
            }
            .navigationTitle("Novo objetivo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onFinish) {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct CreateObjectiveView_Previews: PreviewProvider {
    static var previews: some View {
        CreateObjectiveView(onFinish: {})
            .environment(
                \.managedObjectContext,
                PersistenceController(inMemory: true).container.viewContext
            )
            .previewDisplayName("CreateObjectiveView")
    }
}
