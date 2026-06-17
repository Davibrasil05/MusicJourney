//
//  OnboardingOptionRow.swift
//  MusicJourney
//

import SwiftUI

/// Single-select row used for Experience Level and Practice Schedule steps.
struct OnboardingOptionRow: View {
    let title: String
    let subtitle: String
    let icon: String?
    let isSelected: Bool
    let onTap: () -> Void

    init(
        title: String,
        subtitle: String = "",
        icon: String? = nil,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isSelected = isSelected
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(
                            isSelected ? Color("buttonPurple") : Color("textDark").opacity(0.4)
                        )
                        .frame(width: 30)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("textDark"))

                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundColor(Color("textDark").opacity(0.55))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                Spacer()

                radioButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(rowBackground)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    private var radioButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    isSelected ? Color("buttonPurple") : Color("textDark").opacity(0.3),
                    lineWidth: 2
                )
                .frame(width: 22, height: 22)

            if isSelected {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("buttonPurple"))
                    .frame(width: 12, height: 12)
            }
        }
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("inputGray"))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color("buttonPurple") : Color.clear,
                        lineWidth: 2
                    )
            )
    }
}

// MARK: - Preview

struct OnboardingOptionRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            OnboardingOptionRow(
                title: "Iniciante",
                subtitle: "Estou começando agora ou voltando depois de muito tempo",
                isSelected: false,
                onTap: {}
            )
            OnboardingOptionRow(
                title: "Avançado",
                subtitle: "Tenho experiência sólida e quero manter a consistência",
                isSelected: true,
                onTap: {}
            )
            OnboardingOptionRow(
                title: "Noite",
                subtitle: "18:00 – 23:00",
                icon: "moon.stars.fill",
                isSelected: true,
                onTap: {}
            )
        }
        .padding()
        .previewDisplayName("OnboardingOptionRow")
    }
}
