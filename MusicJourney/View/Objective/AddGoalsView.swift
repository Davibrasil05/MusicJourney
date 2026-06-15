//
//  AddGoalsView.swift
//  MusicJourney
//

import SwiftUI

struct AddGoalsView: View {
    let objective: Objective
    let onFinish: () -> Void

    @StateObject private var viewModel: AddGoalsViewModel
    @Environment(\.presentationMode) var presentationMode

    init(objective: Objective, onFinish: @escaping () -> Void) {
        self.objective = objective
        self.onFinish = onFinish
        _viewModel = StateObject(wrappedValue: AddGoalsViewModel(objective: objective, onFinish: onFinish))
    }

    var body: some View {
        ZStack {
            Color("headerGreen").ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Orange header
                VStack(spacing: 6) {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Casa")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    VStack(spacing: 6) {
                        Text(objective.name ?? "Novo objetivo")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text("Adicione metas para alcançar esse objetivo")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }

                // MARK: Cream content card
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // MARK: AI Section
                        aiSection

                        // MARK: Error banner
                        if let error = viewModel.aiErrorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(Color("headerGreen"))
                                Text(error)
                                    .font(.footnote)
                                    .foregroundColor(Color("textDark"))
                            }
                            .padding(12)
                            .background(Color("headerGreen").opacity(0.10))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("headerGreen").opacity(0.3), lineWidth: 1)
                            )
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
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(
                                    viewModel.hasSelectedGoals
                                        ? Color("primaryBlue")
                                        : Color("inputGray")
                                )
                                .cornerRadius(12)
                        }
                        .disabled(!viewModel.hasSelectedGoals)
                        .padding(.top, 4)

                        Spacer(minLength: 32)
                    }
                    .padding(24)
                }
                .background(Color("cardCream"))
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $viewModel.showAIErrorAlert) {
            Alert(
                title: Text("Não foi possível gerar"),
                message: Text(viewModel.aiErrorMessage ?? "Tente novamente."),
                dismissButton: .default(Text("OK"))
            )
        }
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
                .fontWeight(.bold)
                .foregroundColor(Color("textDark"))

            TextField("Adicionar foco (ex: dedilhado, ritmo...)", text: $viewModel.aiFocusText)
                .padding(14)
                .background(Color("cardCream"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("inputGray"), lineWidth: 1)
                )

            Button(action: { viewModel.generateWithAI() }) {
                HStack(spacing: 8) {
                    if viewModel.isLoadingAI {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.85)
                    } else {
                        Image(systemName: "sparkles")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    Text(viewModel.isLoadingAI ? "Gerando…" : "Gerar metas com IA")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(viewModel.isLoadingAI ? Color("inputGray") : Color("headerGreen"))
                .cornerRadius(10)
            }
            .disabled(viewModel.isLoadingAI)
        }
    }

    private var manualSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Adicionar manualmente")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("textDark"))

            Button(action: { viewModel.showManualSheet = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .bold))
                    Text("Adicionar meta")
                        .fontWeight(.bold)
                }
                .foregroundColor(Color("textDark"))
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(Color("cardCream"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 2, dash: [7])
                        )
                        .foregroundColor(Color("headerGreen"))
                )
            }
        }
    }

    private var goalsListSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Metas")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("textDark"))
                Spacer()
                Text("\(viewModel.pendingGoals.filter { $0.isSelected }.count)/\(viewModel.pendingGoals.count) selecionadas")
                    .font(.caption)
                    .foregroundColor(Color("textDark").opacity(0.5))
            }

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
