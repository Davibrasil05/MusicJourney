//
//  PresetCatalog+Teclado.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

extension PresetCatalog {
    static let tecladoPresets: [PresetObjective] = [
        // 13. Teclado – Iniciante
        PresetObjective(
            instrument: "Teclado",
            level: "Iniciante",
            name: "Tocar \"Let It Be\" (The Beatles)",
            descriptionText: "Aprenda esta música clássica usando tríades simples na mão direita e notas graves na mão esquerda.",
            goals: [
                PresetGoal(name: "Aprender as tríades básicas", textDescription: "Pratique as tríades de C, G, Am e F na mão direita até conseguir trocar sem olhar.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 1, isFinal: false, xpReward: 20),
                PresetGoal(name: "Coordenar as duas mãos", textDescription: "Adicione as notas graves na mão esquerda enquanto toca as tríades com a direita.", category: "Técnica", difficulty: "Fácil", type: "practice", order: 2, isFinal: false, xpReward: 20),
                PresetGoal(name: "Tocar Let It Be completa", textDescription: "Toque a música inteira com as duas mãos, seguindo a estrutura verso-refrão.", category: "Repertório", difficulty: "Fácil", type: "milestone", order: 3, isFinal: true, xpReward: 50)
            ]
        ),

        // 14. Teclado – Intermediário
        PresetObjective(
            instrument: "Teclado",
            level: "Intermediário",
            name: "Tocar \"Clocks\" (Coldplay)",
            descriptionText: "Domine os arpejos repetitivos e hipnóticos de Chris Martin, trabalhando independência das mãos e síncope.",
            goals: [
                PresetGoal(name: "Aprender o arpejo da mão direita", textDescription: "Pratique o padrão de arpejo descendente em grupos de 3 notas que cruza os compassos.", category: "Técnica", difficulty: "Médio", type: "practice", order: 1, isFinal: false, xpReward: 25),
                PresetGoal(name: "Adicionar a mão esquerda", textDescription: "Pratique os acordes sustentados na mão esquerda enquanto mantém o arpejo fluindo.", category: "Técnica", difficulty: "Médio", type: "practice", order: 2, isFinal: false, xpReward: 30),
                PresetGoal(name: "Tocar Clocks completa", textDescription: "Execute a música inteira com ambas as mãos, incluindo as transições entre as seções.", category: "Repertório", difficulty: "Médio", type: "milestone", order: 3, isFinal: true, xpReward: 60)
            ]
        ),

        // 15. Teclado – Avançado
        PresetObjective(
            instrument: "Teclado",
            level: "Avançado",
            name: "Tocar \"Fantasie Impromptu\" (Chopin)",
            descriptionText: "Enfrente um dos maiores desafios do piano clássico: polirritmia 4 contra 3, velocidade e dinâmica romântica.",
            goals: [
                PresetGoal(name: "Dominar a polirritmia 4 contra 3", textDescription: "Pratique lentamente a coordenação de 4 semicolcheias na mão direita contra 3 na mão esquerda.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 1, isFinal: false, xpReward: 40),
                PresetGoal(name: "Seção rápida com agilidade", textDescription: "Trabalhe as passagens rápidas da seção A, subindo o andamento gradualmente até o tempo original.", category: "Técnica", difficulty: "Difícil", type: "practice", order: 2, isFinal: false, xpReward: 40),
                PresetGoal(name: "Executar a peça completa", textDescription: "Toque a peça inteira com dinâmica, rubato e expressividade, incluindo a seção cantabile.", category: "Repertório", difficulty: "Difícil", type: "milestone", order: 3, isFinal: true, xpReward: 80)
            ]
        )
    ]
}
