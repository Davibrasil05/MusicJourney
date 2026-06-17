import Foundation

class GeminiService {
    static let shared = GeminiService()

    /// Gera metas musicais usando a API da OpenAI.
    /// - Parameters:
    ///   - instrument: Instrumento do usuário (ex: Violão)
    ///   - level: Nível de experiência (ex: Iniciante)
    ///   - genres: Gêneros musicais favoritos
    ///   - objectiveTitle: Título do objetivo criado na tela anterior
    ///   - focus: Foco opcional digitado na seção "Gerar com IA"
    func generateGoals(
        instrument: String,
        level: String,
        genres: String,
        objectiveTitle: String,
        focus: String = ""
    ) async throws -> [GoalDTO] {

        let systemPrompt = """
        Você é o "MusicJourney Coach", um professor de música especialista, focado em psicologia da aprendizagem e na metodologia "Hábitos Atômicos" de James Clear.
        Sua missão é criar metas musicais pequenas, concretas e motivadoras.
        Você responde EXCLUSIVAMENTE com um objeto JSON válido, sem nenhum texto extra, sem blocos markdown (```json).
        """

        let trimmedFocus = focus.trimmingCharacters(in: .whitespacesAndNewlines)
        let focusLine = trimmedFocus.isEmpty
            ? "- Foco adicional: (não informado)"
            : "- Foco adicional: \(trimmedFocus)"

        let userPrompt = """
        [PERFIL DO USUÁRIO]
        - Instrumento: \(instrument)
        - Nível: \(level)
        - Gêneros Favoritos: \(genres)
        - Objetivo Global: \(objectiveTitle)
        \(focusLine)

        [REGRAS DE GERAÇÃO]
        1. Gere entre 3 a 5 metas musicais práticas e específicas.
        2. Variabilidade: Ao menos 1 meta com difficulty "Fácil" e 1 com "Desafio".
        3. Guardrail — retorne {"goals": []} se QUALQUER condição abaixo for verdadeira:
           a) O "Objetivo Global" for totalmente irrelevante à música ou instrumentos.
           b) O "Foco adicional" foi informado e NÃO tem relação com música, prática instrumental ou aprendizado musical (ex: academia, treino de peito, dieta, finanças, programação). Nesse caso, retorne vazio mesmo que o Objetivo Global seja musical.
           c) O "Foco adicional" contradiz ou desvia claramente do contexto musical do objetivo.
        4. Quando o foco adicional for musical e relevante, use-o como prioridade na geração das metas.
        5. Saída: Retorne ESTRITAMENTE o objeto JSON abaixo, sem nenhum texto antes ou depois.

        [ESTRUTURA JSON ESPERADA]
        {
          "goals": [
            {
              "name": "Nome curto e motivador da Meta",
              "textDescription": "Descrição detalhada explicando o que praticar e por quê isso ajuda no objetivo global.",
              "category": "Técnica",
              "difficulty": "Fácil",
              "type": "practice"
            }
          ]
        }

        Os valores válidos para "category" são: "Técnica", "Repertório" ou "Teoria".
        Os valores válidos para "difficulty" são: "Fácil", "Médio" ou "Desafio".
        O valor de "type" deve ser sempre "practice".
        """

        let body: [String: Any] = [
            "model": "gpt-4.1-mini",
            "response_format": ["type": "json_object"],
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": userPrompt]
            ],
            "temperature": 0.7,
            "max_tokens": 1024
        ]

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Secrets.openAIKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HTTP Status Code: \(httpResponse.statusCode)")
            if let errorBody = String(data: data, encoding: .utf8) {
                print("Resposta do Servidor: \(errorBody)")
            }
            throw URLError(.badServerResponse)
        }

        // Estrutura interna para decodificar a resposta da OpenAI
        struct OpenAIResponse: Decodable {
            struct Choice: Decodable {
                struct Message: Decodable {
                    let content: String
                }
                let message: Message
            }
            let choices: [Choice]
        }

        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)

        guard let jsonString = openAIResponse.choices.first?.message.content else {
            throw URLError(.cannotDecodeRawData)
        }

        // Limpeza de segurança caso venha algum markdown residual
        let cleanJSON = jsonString
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = cleanJSON.data(using: .utf8) else {
            throw URLError(.cannotDecodeRawData)
        }

        let result = try JSONDecoder().decode(GoalGenerationResponse.self, from: jsonData)
        return result.goals
    }
}
