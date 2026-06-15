//
//  PracticeBottomSheet.swift
//  MusicJourney
//
//  Created by academy on 11/06/26.
//

import SwiftUI

// MARK: - Shape customizado para arredondar apenas cantos específicos (iOS 15)
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Componente do Botão da Grade
struct ToolGridButton: View {
    var title: String
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 12) {

                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .foregroundColor(Color("textDark"))
                
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
            }
            .frame(width: 140, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("backgroundCards"))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color("headerGreen"), lineWidth: 2)
            )
        }
    }
}

private struct DescriptionHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Descrição expansível
private struct ExpandableGoalDescription: View {
    let text: String
    @State private var isExpanded = false
    @State private var contentHeight: CGFloat = 0

    private let expandAnimation = Animation.spring(response: 0.34, dampingFraction: 0.86)

    var body: some View {
        if !text.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Button(action: {
                    withAnimation(expandAnimation) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Text(isExpanded ? "Ocultar descrição" : "Ver descrição")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("headerGreen"))

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("headerGreen"))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(expandAnimation, value: isExpanded)

                        Spacer(minLength: 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Text(text)
                    .font(.subheadline)
                    .foregroundColor(Color("textDark").opacity(isExpanded ? 0.78 : 0))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: isExpanded ? contentHeight : 0, alignment: .top)
                    .clipped()
                    .overlay(alignment: .top) {
                        Text(text)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .hidden()
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .preference(
                                            key: DescriptionHeightPreferenceKey.self,
                                            value: geometry.size.height
                                        )
                                }
                            )
                    }
            }
            .onPreferenceChange(DescriptionHeightPreferenceKey.self) { height in
                if height > 0 {
                    contentHeight = height
                }
            }
        }
    }
}

// MARK: - Componente Principal (A Gaveta Inferior)
struct PracticeBottomSheet: View {
    
    var goalName: String
    var goalDescription: String
    var onNoteTapped: () -> Void
    var onAudioTapped: () -> Void
    var onVideoTapped: () -> Void
    var onMetronomeTapped: () -> Void
    var onStartPracticeTapped: () -> Void
    var isFinishEnabled: Bool
    
    // Configuração das duas colunas da Grid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(goalName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("textDark"))
                    .multilineTextAlignment(.leading)

                ExpandableGoalDescription(text: goalDescription)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 28)

            LazyVGrid(columns: columns, spacing: 24) {
                ToolGridButton(title: "Nota", iconName: "square.and.pencil", action: onNoteTapped)
                ToolGridButton(title: "Áudio", iconName: "mic.fill", action: onAudioTapped)
                ToolGridButton(title: "Vídeo", iconName: "play.rectangle.fill", action: onVideoTapped)
                ToolGridButton(title: "Metrônomo", iconName: "metronome.fill", action: onMetronomeTapped)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            PrimaryActionButton(title: "Concluir") {
                onStartPracticeTapped()
            }
            .disabled(!isFinishEnabled)
            .padding(.top, 50)
            
            // Empurra tudo para cima e deixa um respiro no fundo
            Spacer()
        }
        .frame(maxWidth: .infinity)
        // Cor do fundo
        .background(Color("cardCream"))
        // Arredonda APENAS os cantos superiores
        .clipShape(RoundedCorner(radius: 32, corners: [.topLeft, .topRight]))
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

// MARK: - Preview
struct PracticeBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottom) {
            // Fundo da tela inteira (headerGreen)
            Color("headerGreen")
                .ignoresSafeArea()
            
            // O BottomSheet colado embaixo
            PracticeBottomSheet(
                goalName: "Aprender o riff de Feel Good Inc",
                goalDescription: "Pratique o riff lentamente, focando na precisão dos dedos antes de aumentar o andamento.",
                onNoteTapped: { print("Nota") },
                onAudioTapped: { print("Audio") },
                onVideoTapped: { print("Video") },
                onMetronomeTapped: { print("Metronomo") },
                onStartPracticeTapped: { print("Iniciar") },
                isFinishEnabled: true
            )
            // Faz o card cobrir aquela margem branca do fundo da tela
            .ignoresSafeArea(edges: .bottom)
            // Ocupa mais ou menos 65% da tela para deixar o timer aparecer em cima
            .frame(height: UIScreen.main.bounds.height * 0.65)
        }
    }
}
