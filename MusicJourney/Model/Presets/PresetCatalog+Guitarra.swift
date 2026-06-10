//
//  PresetCatalog+Guitarra.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

extension PresetCatalog {
    static let guitarraPresets: [PresetObjective] = [
        // 4. Guitarra – Iniciante
        PresetObjective(
            instrument: "Guitarra",
            level: "Iniciante",
            name: "Tocar \"Smells Like Teen Spirit\" (Nirvana)",
            descriptionText: "Aprenda o riff mais icônico do grunge usando power chords e a técnica de palm muting básico.",
            goals: [
                PresetGoal(name: "Aprender os power chords", textDescription: "Domine os 4 power chords da música (F5, Bb5, Ab5, Db5) e pratique as trocas.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 1, isFinal: false, xpReward: 20),
                PresetGoal(name: "Dominar o palm muting", textDescription: "Pratique abafar as cordas com a palma da mão direita para criar o efeito percussivo do verso.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 2, isFinal: false, xpReward: 20),
                PresetGoal(name: "Tocar a música com backing track", textDescription: "Toque o riff e os versos completos acompanhando uma backing track da música.", category: "Repertório", difficulty: "Fácil", type: "milestone", order: 3, isFinal: true, xpReward: 50)
            ]
        ),

        // 5. Guitarra – Intermediário
        PresetObjective(
            instrument: "Guitarra",
            level: "Intermediário",
            name: "Tocar \"Sweet Child O' Mine\" (Guns N' Roses)",
            descriptionText: "Domine o riff lendário de Slash trabalhando palhetada alternada, saltos de corda e precisão rítmica.",
            goals: [
                PresetGoal(name: "Aprender o riff de introdução", textDescription: "Decore as notas do riff principal e pratique lentamente (60 BPM), subindo o andamento gradualmente.", category: "Repertório", difficulty: "Médio", type: "practice", order: 1, isFinal: false, xpReward: 30),
                PresetGoal(name: "Palhetada alternada fluida", textDescription: "Pratique o riff usando rigorosamente palhetada alternada (↓↑↓↑) até atingir 100 BPM sem erros.", category: "Técnica", difficulty: "Médio", type: "practice", order: 2, isFinal: false, xpReward: 30),
                PresetGoal(name: "Tocar intro + verso no tempo original", textDescription: "Execute a introdução e os versos no andamento original (122 BPM) com precisão.", category: "Repertório", difficulty: "Médio", type: "milestone", order: 3, isFinal: true, xpReward: 60)
            ]
        ),

        // 6. Guitarra – Avançado
        PresetObjective(
            instrument: "Guitarra",
            level: "Avançado",
            name: "Tocar \"Master of Puppets\" (Metallica)",
            descriptionText: "Enfrente o desafio do downpicking implacável em alta velocidade e o solo técnico de Kirk Hammett.",
            goals: [
                PresetGoal(name: "Downpicking no riff principal", textDescription: "Pratique o riff principal usando apenas palhetadas para baixo (↓) começando em 160 BPM até chegar a 212 BPM.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 1, isFinal: false, xpReward: 40),
                PresetGoal(name: "Seção limpa do interlúdio", textDescription: "Aprenda os arpejos limpos da parte intermediária da música, trabalhando dinâmica e limpeza sonora.", category: "Repertório", difficulty: "Médio", type: "practice", order: 2, isFinal: false, xpReward: 35),
                PresetGoal(name: "Executar a música completa", textDescription: "Toque a música inteira do início ao fim, incluindo os riffs, interlúdio e solo, no andamento original.", category: "Repertório", difficulty: "Difícil", type: "milestone", order: 3, isFinal: true, xpReward: 80)
            ]
        )
    ]
}
