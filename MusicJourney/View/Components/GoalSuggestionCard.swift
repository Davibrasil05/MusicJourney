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
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .accentColor : Color(.tertiaryLabel))
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)

                    if !textDescription.isEmpty {
                        Text(textDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }

                    HStack(spacing: 6) {
                        TagBadge(text: category)
                        TagBadge(text: difficulty)
                    }
                    .padding(.top, 2)
                }
                Spacer(minLength: 0)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor.opacity(0.08) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor.opacity(0.4) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct TagBadge: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(4)
            .foregroundColor(.secondary)
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
        }
        .padding()
        .previewDisplayName("GoalSuggestionCard")
    }
}
