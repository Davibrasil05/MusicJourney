//
//  AddGoalsView.swift
//  MusicJourney
//

import SwiftUI

struct AddGoalsView: View {
    let objective: Objective
    let onFinish: () -> Void

    @StateObject private var viewModel: AddGoalsViewModel

    init(objective: Objective, onFinish: @escaping () -> Void) {
        self.objective = objective
        self.onFinish = onFinish
        _viewModel = StateObject(wrappedValue: AddGoalsViewModel(objective: objective, onFinish: onFinish))
    }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(objective.name ?? "Objetivo")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Adicione metas para alcançar esse objetivo")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // MARK: AI Section
                    aiSection

                    // MARK: Error banner
                    if let error = viewModel.aiErrorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text(error)
                                .font(.footnote)
                                .foregroundColor(.primary)
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.12))
                        .cornerRadius(10)
                    }

                    // MARK: Manual section
                    manualSection

                    // MARK: Unified goal list
                    if !viewModel.pendingGoals.isEmpty {
                        goalsListSection
                    }

                    // MARK: Save button
                    Button(action: { viewModel.saveGoals() }) {
                        Text("Salvar metas")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.hasSelectedGoals ? Color.accentColor : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.hasSelectedGoals)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .navigationTitle("Metas")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showManualSheet) {
            ManualGoalSheet(
                onSave: { name, desc, cat, diff in
                    viewModel.addManualGoal(name: name, description: desc, category: cat, difficulty: diff)
                    viewModel.showManualSheet = false
                },
                onCancel: { viewModel.showManualSheet = false }
            )
        }
    }

    // MARK: - Sub-views

    private var aiSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Gerar com IA")
                .font(.headline)
                .fontWeight(.semibold)

            TextField("Adicionar foco (opcional, ex: dedilhado)", text: $viewModel.aiFocusText)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            Button(action: { viewModel.generateWithAI() }) {
                HStack {
                    if viewModel.isLoadingAI {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.85)
                    } else {
                        Image(systemName: "sparkles")
                    }
                    Text(viewModel.isLoadingAI ? "Gerando…" : "Gerar metas com IA")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isLoadingAI ? Color.gray : Color.accentColor)
                .cornerRadius(10)
            }
            .disabled(viewModel.isLoadingAI)
        }
    }

    private var manualSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Adicionar manualmente")
                .font(.headline)
                .fontWeight(.semibold)

            Button(action: { viewModel.showManualSheet = true }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Adicionar meta")
                        .fontWeight(.medium)
                }
                .foregroundColor(.accentColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor.opacity(0.08))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                        .foregroundColor(Color.accentColor.opacity(0.4))
                )
            }
        }
    }

    private var goalsListSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Metas selecionadas (\(viewModel.pendingGoals.filter { $0.isSelected }.count)/\(viewModel.pendingGoals.count))")
                .font(.headline)
                .fontWeight(.semibold)

            ForEach(viewModel.pendingGoals) { item in
                GoalSuggestionCard(
                    name: item.name,
                    textDescription: item.textDescription,
                    category: item.category,
                    difficulty: item.difficulty,
                    isSelected: item.isSelected,
                    onToggle: { viewModel.toggleSelection(id: item.id) }
                )
            }
        }
    }
}

struct AddGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController(inMemory: true).container.viewContext
        let objective = Objective(context: context)
        objective.id = UUID()
        objective.name = "Tocar Linkin Park"
        objective.status = "active"

        return NavigationView {
            AddGoalsView(objective: objective, onFinish: {})
        }
        .environment(\.managedObjectContext, context)
        .previewDisplayName("AddGoalsView")
    }
}
