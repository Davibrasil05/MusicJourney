//
//  UserProfileView.swift
//  MusicJourney
//
//  Created by Academy on 05/06/26.
//

import SwiftUI
import Foundation

struct UserProfileView: View {
    @StateObject private var viewModel = UserRepository()
    @StateObject private var objectiveRepo = ObjectiveRepository()

    // Picker state — initialised from Core Data in onAppear
    @State private var selectedInstrument: MusicInstrument = .violao
    @State private var selectedLevel: MusicLevel = .iniciante
    @State private var selectedSchedule: PracticeSchedule = .noite
    @State private var selectedGenres: Set<MusicGenre> = []

    @State private var showingAddSheet = false
    @State private var newObjectiveName = ""
    @State private var newObjectiveDescription = ""

    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                Form {

                    // MARK: - Perfil Musical
                    Section(header: Text("Perfil Musical")) {
                        Picker("Instrumento", selection: $selectedInstrument) {
                            ForEach(MusicInstrument.allCases) { instrument in
                                Text(instrument.rawValue).tag(instrument)
                            }
                        }

                        Picker("Nível", selection: $selectedLevel) {
                            ForEach(MusicLevel.allCases) { level in
                                Text(level.rawValue).tag(level)
                            }
                        }

                        Picker("Horário de prática", selection: $selectedSchedule) {
                            ForEach(PracticeSchedule.allCases) { schedule in
                                Text(schedule.rawValue).tag(schedule)
                            }
                        }

                        NavigationLink(destination: GenrePickerView(selectedGenres: $selectedGenres)) {
                            HStack {
                                Text("Gêneros")
                                Spacer()
                                Text(selectedGenres.isEmpty
                                     ? "Nenhum"
                                     : selectedGenres.map(\.rawValue).sorted().joined(separator: ", "))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }

                    // MARK: - Jornada
                    Section(header: Text("Sua Jornada")) {
                        HStack {
                            Text("Nível Musical")
                            Spacer()
                            Text("Lvl \(user.level)").fontWeight(.bold).foregroundColor(.blue)
                        }
                        HStack {
                            Text("Experiência (XP)")
                            Spacer()
                            Text("\(user.xp) / 100 XP").foregroundColor(.green)
                        }
                        HStack {
                            Text("Ofensiva (Dias Seguidos)")
                            Spacer()
                            Text("🔥 \(user.streak) dias").foregroundColor(.orange)
                        }
                    }

                    // MARK: - Ferramentas
                    Section(header: Text("Ferramentas de Prática")) {
                        NavigationLink(destination: MetronomeOverlayView(viewModel: PracticeSessionViewModel())) {
                            Label("Testar Metrônomo", systemImage: "metronome.fill")
                        }
                                            }

                    // MARK: - Ferramentas de Teste
                    Section(header: Text("Ferramentas de Teste")) {
                        Button(action: { showingAddSheet = true }) {
                            Label("Criar Objetivo de Teste", systemImage: "target")
                        }
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
                }
                .navigationTitle("Meu Perfil")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Salvar") { saveProfile(to: user) }
                    }
                }
                .onAppear { loadProfile(from: user) }
                .sheet(isPresented: $showingAddSheet) {
                    NavigationView {
                        Form {
                            Section(header: Text("O que você quer aprender?")) {
                                TextField("Nome (ex: Tocar a música X)", text: $newObjectiveName)
                                TextField("Descrição (opcional)", text: $newObjectiveDescription)
                            }
                        }
                        .navigationTitle("Novo Objetivo")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Cancelar") { resetSheetState() }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Salvar") {
                                    guard !newObjectiveName.isEmpty else { return }
                                    objectiveRepo.addObjective(name: newObjectiveName, descriptionText: newObjectiveDescription)
                                    resetSheetState()
                                }
                                .disabled(newObjectiveName.isEmpty)
                            }
                        }
                    }
                }
            } else {
                ProgressView("Carregando perfil...")
            }
        }
    }

    // MARK: - Helpers

    private func loadProfile(from user: User) {
        selectedInstrument = MusicInstrument(rawValue: user.instrument ?? "") ?? .violao
        selectedLevel      = MusicLevel(rawValue: user.experienceLevel ?? "") ?? .iniciante
        selectedSchedule   = PracticeSchedule(rawValue: user.practiceSchedule ?? "") ?? .noite
        let saved = user.genres as? [String] ?? []
        selectedGenres     = Set(saved.compactMap { MusicGenre(rawValue: $0) })
    }

    private func saveProfile(to user: User) {
        user.instrument      = selectedInstrument.rawValue
        user.experienceLevel = selectedLevel.rawValue
        user.level           = selectedLevel.levelValue
        user.practiceSchedule = selectedSchedule.rawValue
        user.genres          = selectedGenres.map(\.rawValue) as NSArray
        viewModel.save()
    }

    private func resetSheetState() {
        newObjectiveName = ""
        newObjectiveDescription = ""
        showingAddSheet = false
    }
}

// MARK: - Genre Picker (sub-tela com checkmarks)

private struct GenrePickerView: View {
    @Binding var selectedGenres: Set<MusicGenre>

    var body: some View {
        List {
            ForEach(MusicGenre.allCases) { genre in
                Button(action: { toggle(genre) }) {
                    HStack {
                        Text(genre.rawValue).foregroundColor(.primary)
                        Spacer()
                        if selectedGenres.contains(genre) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
        .navigationTitle("Gêneros")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func toggle(_ genre: MusicGenre) {
        if selectedGenres.contains(genre) {
            selectedGenres.remove(genre)
        } else {
            selectedGenres.insert(genre)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environment(\.managedObjectContext,
                         PersistenceController.preview.container.viewContext)
            .previewDisplayName("UserProfileView")
    }
}
