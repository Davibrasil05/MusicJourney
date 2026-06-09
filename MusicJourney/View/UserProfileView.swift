//
//  UserProfileView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                Form {
                    Section(header: Text("Quem é você?")) {
                        TextField("Seu Nome", text: Binding(
                            get: { user.name ?? "" }, set: { user.name = $0 }
                        ))
                        TextField("Qual seu instrumento?", text: Binding(
                            get: { user.instrument ?? "" }, set: { user.instrument = $0 }
                        ))
                        TextField("Nível (ex: Intermediário)", text: Binding(
                            get: { user.experienceLevel ?? "" }, set: { user.experienceLevel = $0 }
                        ))
                    }
                    
                    Section(header: Text("Sua Jornada (Status)")) {
                        HStack {
                            Text("Nível Musical")
                            Spacer()
                            Text("Lvl \(user.level)")
                                .fontWeight(.bold).foregroundColor(.blue)
                        }
                        
                        HStack {
                            Text("Experiência (XP)")
                            Spacer()
                            Text("\(user.xp) / 100 XP")
                                .foregroundColor(.green)
                        }
                        
                        HStack {
                            Text("Ofensiva (Dias Seguidos)")
                            Spacer()
                            Text("🔥 \(user.streak) dias")
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // Um botão para você testar como a gamificação vai funcionar depois
                    Button(action: { viewModel.gainXP(amount: 15) }) {
                        Text("Praticar (Ganhar +15 XP)")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                    .listRowBackground(Color.clear)
                }
                .navigationTitle("Meu Perfil")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salvar") { viewModel.saveChanges() }
                    }
                }
            } else {
                ProgressView("Carregando perfil...")
            }
        }
    }
}
