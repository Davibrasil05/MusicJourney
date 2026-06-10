//
//  PresetCatalog+Flauta.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

extension PresetCatalog {
    static let flautaPresets: [PresetObjective] = [
        // 16. Flauta – Iniciante
        PresetObjective(
            instrument: "Flauta",
            level: "Iniciante",
            name: "Tocar \"My Heart Will Go On\" (Celine Dion)",
            descriptionText: "Aprenda a melodia do tema de Titanic, trabalhando emissão de som, respiração controlada e notas longas.",
            goals: [
                PresetGoal(name: "Exercícios de emissão e respiração", textDescription: "Pratique notas longas mantendo um som limpo e estável por pelo menos 4 tempos.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 1, isFinal: false, xpReward: 20),
                PresetGoal(name: "Aprender a melodia principal", textDescription: "Decore as notas da melodia do refrão, praticando as ligaduras e a afinação de cada nota.", category: "Repertório", difficulty: "Fácil", type: "practice", order: 2, isFinal: false, xpReward: 20),
                PresetGoal(name: "Tocar a música com backing track", textDescription: "Toque a melodia completa acompanhando uma backing track orquestral.", category: "Repertório", difficulty: "Fácil", type: "milestone", order: 3, isFinal: true, xpReward: 50)
            ]
        ),

        // 17. Flauta – Intermediário
        PresetObjective(
            instrument: "Flauta",
            level: "Intermediário",
            name: "Tocar \"Bourrée\" (Bach / Jethro Tull)",
            descriptionText: "Domine esta peça clássica de Bach na versão rock de Jethro Tull, trabalhando articulação staccato e saltos de oitava.",
            goals: [
                PresetGoal(name: "Dominar a articulação staccato", textDescription: "Pratique notas curtas e destacadas usando a língua para criar o efeito staccato.", category: "Técnica", difficulty: "Médio", type: "practice", order: 1, isFinal: false, xpReward: 25),
                PresetGoal(name: "Saltos de oitava e registro agudo", textDescription: "Pratique os saltos entre o registro grave e agudo sem perder afinação.", category: "Técnica", difficulty: "Médio", type: "practice", order: 2, isFinal: false, xpReward: 30),
                PresetGoal(name: "Tocar Bourrée completa", textDescription: "Execute a peça inteira com articulação clara, dinâmica e as repetições no estilo rock-flute.", category: "Repertório", difficulty: "Médio", type: "milestone", order: 3, isFinal: true, xpReward: 60)
            ]
        ),

        // 18. Flauta – Avançado
        PresetObjective(
            instrument: "Flauta",
            level: "Avançado",
            name: "Tocar \"Flight of the Bumblebee\" (Rimsky-Korsakov)",
            descriptionText: "Enfrente uma das peças mais rápidas do repertório: cromatismos em velocidade extrema com controle total de fôlego.",
            goals: [
                PresetGoal(name: "Exercícios cromáticos em velocidade", textDescription: "Pratique escalas cromáticas ascendentes e descendentes começando lentamente.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 1, isFinal: false, xpReward: 35),
                PresetGoal(name: "Controle de fôlego em passagens rápidas", textDescription: "Trabalhe a respiração estratégica em pontos específicos da peça sem quebrar a frase.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 2, isFinal: false, xpReward: 40),
                PresetGoal(name: "Executar a peça no andamento original", textDescription: "Toque a peça completa no andamento rápido original com clareza em cada nota.", category: "Repertório", difficulty: "Difícil", type: "milestone", order: 3, isFinal: true, xpReward: 80)
            ]
        )
    ]
}
