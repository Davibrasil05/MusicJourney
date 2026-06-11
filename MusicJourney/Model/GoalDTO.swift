import Foundation

/// DTO (Data Transfer Object) para decodificar a resposta raiz da IA.
struct GoalGenerationResponse: Codable {
    let goals: [GoalDTO]
}

/// DTO que representa a sugestão de meta gerada pela IA.
/// Usamos isso para desacoplar a internet do Core Data temporariamente.
struct GoalDTO: Codable, Identifiable {
    var id: UUID = UUID() // Útil para iteração em listas no SwiftUI (ForEach)
    let name: String
    let textDescription: String
    let category: String // ex: "Técnica", "Repertório", "Teoria"
    let difficulty: String // ex: "Fácil", "Médio", "Desafio"
    let type: String // ex: "practice", "behavioral"
    
    // O CodingKeys é necessário para ignorar o 'id' na hora de decodificar do JSON do Gemini
    enum CodingKeys: String, CodingKey {
        case name, textDescription, category, difficulty, type
    }
}
