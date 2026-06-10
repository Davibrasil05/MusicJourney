//
//  PresetCatalog+Violao.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

extension PresetCatalog {
    static let violaoPresets: [PresetObjective] = [
        // 1. Violão – Iniciante
        PresetObjective(
            instrument: "Violão",
            level: "Iniciante",
            name: "Tocar \"Knockin' On Heaven's Door\"",
            descriptionText: "Aprenda a tocar essa música clássica de Bob Dylan/Guns N' Roses usando apenas 4 acordes abertos e um ritmo básico de violão.",
            goals: [
                PresetGoal(name: "Aprender os 4 acordes abertos", textDescription: "Pratique as trocas entre os acordes G, D, Am e C até conseguir trocar sem pausas.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 1, isFinal: false, xpReward: 20),
                PresetGoal(name: "Dominar a batida básica", textDescription: "Pratique o padrão rítmico baixo-cima-baixo-cima (↓↑↓↑) mantendo o tempo constante.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 2, isFinal: false, xpReward: 20),
                PresetGoal(name: "Tocar a música do início ao fim", textDescription: "Junte acordes e ritmo e toque a música inteira acompanhando a gravação original.", category: "Repertório", difficulty: "Fácil", type: "milestone", order: 3, isFinal: true, xpReward: 50)
            ]
        ),

        // 2. Violão – Intermediário
        PresetObjective(
            instrument: "Violão",
            level: "Intermediário",
            name: "Tocar \"Blackbird\" (The Beatles)",
            descriptionText: "Aprenda o fingerpicking clássico de Paul McCartney, trabalhando independência dos dedos e movimentação pelo braço do violão.",
            goals: [
                PresetGoal(name: "Aprender o padrão de fingerpicking", textDescription: "Pratique o dedilhado polegar + indicador/médio alternados no padrão característico da música.", category: "Técnica", difficulty: "Médio", type: "practice", order: 1, isFinal: false, xpReward: 25),
                PresetGoal(name: "Dominar os acordes com movimentação", textDescription: "Pratique os acordes que sobem pelo braço do violão (posições 1 a 7) mantendo o fingerpicking.", category: "Técnica", difficulty: "Médio", type: "practice", order: 2, isFinal: false, xpReward: 30),
                PresetGoal(name: "Tocar Blackbird completa", textDescription: "Execute a música inteira com fluência, incluindo a parte do \"ponte\" e as variações de dinâmica.", category: "Repertório", difficulty: "Médio", type: "milestone", order: 3, isFinal: true, xpReward: 60)
            ]
        ),

        // 3. Violão – Avançado
        PresetObjective(
            instrument: "Violão",
            level: "Avançado",
            name: "Tocar \"Neon\" (John Mayer)",
            descriptionText: "Domine a técnica avançada de slap acústico com o polegar fazendo baixo e os dedos tocando a melodia simultaneamente.",
            goals: [
                PresetGoal(name: "Técnica de slap no polegar", textDescription: "Pratique o slap percussivo no polegar da mão direita isoladamente até conseguir um som limpo e rítmico.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 1, isFinal: false, xpReward: 35),
                PresetGoal(name: "Coordenar baixo + melodia", textDescription: "Junte o polegar (baixo com slap) e os dedos indicador/médio (melodia) nos primeiros 8 compassos.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 2, isFinal: false, xpReward: 40),
                PresetGoal(name: "Executar Neon completa", textDescription: "Toque a música inteira com o groove percussivo, variações de dinâmica e o solo.", category: "Repertório", difficulty: "Difícil", type: "milestone", order: 3, isFinal: true, xpReward: 80)
            ]
        )
    ]
}
