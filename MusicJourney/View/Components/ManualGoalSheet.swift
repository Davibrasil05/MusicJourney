//
//  ManualGoalSheet.swift
//  MusicJourney
//

import SwiftUI

struct ManualGoalSheet: View {
    let onSave: (_ name: String, _ description: String, _ category: String, _ difficulty: String) -> Void
    let onCancel: () -> Void

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: String = "Técnica"
    @State private var difficulty: String = "Fácil"

    private let categories = ["Técnica", "Repertório", "Teoria"]
    private let difficulties = ["Fácil", "Médio", "Desafio"]

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informações")) {
                    TextField("Nome da meta", text: $name)
                    TextField("Descrição (opcional)", text: $description)
                }

                Section(header: Text("Classificação")) {
                    Picker("Categoria", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    Picker("Dificuldade", selection: $difficulty) {
                        ForEach(difficulties, id: \.self) { Text($0) }
                    }
                }
            }
            .navigationTitle("Nova meta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar", action: onCancel)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        onSave(name, description, category, difficulty)
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

struct ManualGoalSheet_Previews: PreviewProvider {
    static var previews: some View {
        ManualGoalSheet(
            onSave: { _, _, _, _ in },
            onCancel: {}
        )
        .previewDisplayName("ManualGoalSheet")
    }
}
