//
//  PresetCatalog+Ukulele.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

extension PresetCatalog {
    static let ukulelePresets: [PresetObjective] = [
        // 7. Ukulele – Iniciante
        PresetObjective(
            instrument: "Ukulele",
            level: "Iniciante",
            name: "Tocar \"Riptide\" (Vance Joy)",
            descriptionText: "Aprenda um dos maiores hits do ukulele usando apenas 3 acordes fáceis e a famosa batida \"calypso\".",
            goals: [
                PresetGoal(name: "Aprender os acordes Am, G e C", textDescription: "Pratique a posição de cada acorde e faça trocas limpas entre eles.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 1, isFinal: false, xpReward: 20),
                PresetGoal(name: "Dominar a batida calypso", textDescription: "Pratique o padrão rítmico ↓ ↓↑ ↑↓↑ (a batida \"calypso\") até ficar automático.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 2, isFinal: false, xpReward: 20),
                PresetGoal(name: "Tocar e cantar Riptide", textDescription: "Toque a música completa com a batida calypso, acompanhando o ritmo original.", category: "Repertório", difficulty: "Fácil", type: "milestone", order: 3, isFinal: true, xpReward: 50)
            ]
        ),

        // 8. Ukulele – Intermediário
        PresetObjective(
            instrument: "Ukulele",
            level: "Intermediário",
            name: "Tocar \"Somewhere Over the Rainbow\"",
            descriptionText: "Aprenda a versão do Israel Kamakawiwo'ole com a batida havaiana característica e acordes com pestana.",
            goals: [
                PresetGoal(name: "Aprender a batida havaiana", textDescription: "Pratique o padrão rítmico havaiano com ênfase nos acentos do tempo fraco, criando o swing característico.", category: "Técnica", difficulty: "Médio", type: "practice", order: 1, isFinal: false, xpReward: 25),
                PresetGoal(name: "Dominar o acorde E7 com pestana", textDescription: "Pratique a transição para o E7 (que exige pestana parcial) sem perder o ritmo da batida.", category: "Técnica", difficulty: "Médio", type: "practice", order: 2, isFinal: false, xpReward: 30),
                PresetGoal(name: "Tocar a música completa", textDescription: "Execute a música inteira com fluência, mantendo o swing havaiano e as transições de acorde suaves.", category: "Repertório", difficulty: "Médio", type: "milestone", order: 3, isFinal: true, xpReward: 60)
            ]
        ),

        // 9. Ukulele – Avançado
        PresetObjective(
            instrument: "Ukulele",
            level: "Avançado",
            name: "Tocar \"While My Guitar Gently Weeps\"",
            descriptionText: "Domine o arranjo solo virtuosístico de Jake Shimabukuro, combinando melodia e harmonia simultaneamente.",
            goals: [
                PresetGoal(name: "Aprender a melodia principal", textDescription: "Decore as notas da melodia principal na 1ª corda, praticando a articulação e expressividade.", category: "Repertório", difficulty: "Difícil", type: "practice", order: 1, isFinal: false, xpReward: 35),
                PresetGoal(name: "Integrar harmonia e melodia (chord melody)", textDescription: "Junte os acordes de acompanhamento com a melodia, tocando ambos simultaneamente com tremolo.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 2, isFinal: false, xpReward: 40),
                PresetGoal(name: "Executar o arranjo completo", textDescription: "Toque o arranjo inteiro com dinâmicas, variações de andamento e a seção climática final.", category: "Repertório", difficulty: "Difícil", type: "milestone", order: 3, isFinal: true, xpReward: 80)
            ]
        )
    ]
}
