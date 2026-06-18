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
                        Text("Histórico")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                        Spacer()
                        
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
                VStack(spacing: 15) {
                    HStack{
                        Text("Reveja seus registros!")
                            .font(.system(size: 22, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.top, 40)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    if viewModel.completedObjectives.isEmpty {
                        Spacer()
                        Text("Você ainda não concluiu nenhum objetivo.\nContinue praticando!")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.bottom, 100)
                        Spacer()
                    } else {
                        List {
                            ForEach(viewModel.completedObjectives) { objective in
                                NavigationLink(destination: GoalsView(objective: objective)) {
                                    ObjectiveCard(objective: objective)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.vertical, 10)
                                .padding(.horizontal, 15)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                            }
                        }
                        .listStyle(.plain)
                    }
                }
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
