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
                Color("headerGreen").ignoresSafeArea()

                // Hidden NavigationLink — fires when navigateToGoals becomes true
                NavigationLink(
                    destination: createdObjective.map { obj in
                        AddGoalsView(objective: obj, onFinish: onFinish)
                    },
                    isActive: $navigateToGoals
                ) { EmptyView() }.hidden()

                VStack(spacing: 0) {

                    // MARK: Orange header
                    VStack(spacing: 6) {
                        HStack {
                            Button(action: onFinish) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.white.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        VStack(spacing: 6) {
                            Text("Novo objetivo")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Defina uma meta para praticar")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.85))
                        }
                        .padding(.vertical, 20)
                    }

                    // MARK: Cream content card
                    ScrollView {
                        VStack(alignment: .leading, spacing: 28) {

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Título do objetivo")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("textDark"))

                                TextField("Ex: Tocar Linkin Park", text: $viewModel.title)
                                    .padding(14)
                                    .background(Color("cardCream"))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color("inputGray"), lineWidth: 1)
                                    )
                            }

                            Button(action: {
                                if let objective = viewModel.createObjective() {
                                    createdObjective = objective
                                    navigateToGoals = true
                                }
                            }) {
                                Text("Continuar")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(
                                        viewModel.canContinue
                                            ? Color("primaryBlue")
                                            : Color("inputGray")
                                    )
                                    .cornerRadius(12)
                            }
                            .disabled(!viewModel.canContinue)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.6, alignment: .top)
                    }
                    .background(Color("cardCream"))
                    .cornerRadius(24, corners: [.topLeft, .topRight])
                    .ignoresSafeArea(edges: .bottom)
                }
            }
            .navigationBarHidden(true)
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
