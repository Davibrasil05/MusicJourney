//
//  HistoryView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color("headerGreen").ignoresSafeArea() // Cor laranja base
            
            VStack(spacing: 0) {
                // 1. ÁREA SUPERIOR (LARANJA)
                VStack(spacing: 20) {
                    HStack() {
                        Spacer()
                        
                        // Botão + (mesmo da Home)
                        Button(action: { }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // INDICADOR DE NÍVEL
                    HStack(spacing: 16) {
                        Text("Lev. \(viewModel.currentUser?.level ?? 1)")
                            .bold()
                            .foregroundColor(.white)
                        
                        let xpAtual = Double(viewModel.currentUser?.xp ?? 0)
                        LevelProgressBar(percentage: xpAtual / 100.0)
                        
                        Text("\(Int(xpAtual))%")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 23)
                    .padding(.bottom, 30)
                }
                
                // 2. CAIXA INFERIOR (CREME)
                VStack(spacing: 24) {
                    Text("Relembre seus objetivos!")
                        .font(.system(size: 22, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top, 40)
                    
                    if viewModel.completedObjectives.isEmpty {
                        Spacer()
                        Text("Você ainda não concluiu nenhum objetivo.\nContinue praticando!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(viewModel.completedObjectives) { objective in
                                    NavigationLink(destination: GoalsView(objective: objective)) {
                                        ObjectiveCard(objective: objective)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.top, 10)
                            // Padding extra para não ficar escondido sob a TabBar
                            .padding(.bottom, 120)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("cardCream"))
                .clipShape(RoundedCorner(radius: 40, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadCompletedObjectives()
        }
    }
}
