//
//  GoalSuggestionCard.swift
//  MusicJourney
//

import SwiftUI

struct GoalSuggestionCard: View {
    let name: String
    let textDescription: String
    let category: String
    let difficulty: String
    let isSelected: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 12) {

                // Checkbox circle — orange when selected, outlined when not
                ZStack {
                    Circle()
                        .fill(isSelected ? Color("headerGreen") : Color.clear)
                        .frame(width: 26, height: 26)
                    Circle()
                        .stroke(
                            isSelected ? Color("headerGreen") : Color("inputGray"),
                            lineWidth: 2
                        )
                        .frame(width: 26, height: 26)
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("textDark"))
                        .multilineTextAlignment(.leading)

                    if !textDescription.isEmpty {
                        Text(textDescription)
                            .font(.caption)
                            .foregroundColor(Color("textDark").opacity(0.78))
                            .multilineTextAlignment(.leading)
                    }

                    HStack(spacing: 6) {
                        GoalTagBadge(text: category)
                        DifficultyTagBadge(difficulty: difficulty)
                    }
                    .padding(.top, 2)
                }

                Spacer(minLength: 0)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("cardCream"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color("headerGreen").opacity(0.5) : Color("inputGray").opacity(0.5),
                        lineWidth: 1.2
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

private struct GoalTagBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(Color("inputGray").opacity(0.25))
            .cornerRadius(5)
            .foregroundColor(Color("textDark").opacity(0.7))
    }
}

private struct DifficultyTagBadge: View {
    let difficulty: String

    private var style: (background: Color, foreground: Color) {
        switch difficulty.normalizedDifficulty {
        case .easy:
            return (Color("difficultyEasyBg"), Color("difficultyEasyText"))
        case .medium:
            return (Color("difficultyMediumBg"), Color("difficultyMediumText"))
        case .hard:
            return (Color("difficultyHardBg"), Color("difficultyHardText"))
        case .unknown:
            return (Color("inputGray").opacity(0.25), Color("textDark").opacity(0.7))
        }
    }

    var body: some View {
        Text(difficulty)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(style.background)
            .cornerRadius(5)
            .foregroundColor(style.foreground)
    }
}

private enum NormalizedDifficulty {
    case easy
    case medium
    case hard
    case unknown
}

private extension String {
    var normalizedDifficulty: NormalizedDifficulty {
        let value = folding(options: .diacriticInsensitive, locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        switch value {
        case "facil", "fácil":
            return .easy
        case "medio", "médio", "media", "média":
            return .medium
        case "desafio", "dificil", "difícil", "mestre":
            return .hard
        default:
            return .unknown
        }
    }
}

struct GoalSuggestionCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            GoalSuggestionCard(
                name: "Praticar escala pentatônica",
                textDescription: "Treinar a escala em todas as posições do braço da guitarra.",
                category: "Técnica",
                difficulty: "Fácil",
                isSelected: false,
                onToggle: {}
            )
            GoalSuggestionCard(
                name: "Aprender intro de Nothing Else Matters",
                textDescription: "Aprender o arpejo com precisão antes de aumentar o tempo.",
                category: "Repertório",
                difficulty: "Médio",
                isSelected: true,
                onToggle: {}
            )
            GoalSuggestionCard(
                name: "Solo completo de Tempo Perdido",
                textDescription: "Executar o solo com técnica limpa e timing consistente.",
                category: "Repertório",
                difficulty: "Desafio",
                isSelected: false,
                onToggle: {}
            )
        }
        .padding()
        .background(Color("cardCream"))
        .previewDisplayName("GoalSuggestionCard")
    }
}
