//
//  PresetCatalog.swift
//  MusicJourney
//
//  Created by academy on 10/06/26.
//

import Foundation

// MARK: - Catálogo de objetivos pré-definidos (hardcoded)
// 18 combinações: 6 instrumentos × 3 níveis

struct PresetCatalog {

    /// Retorna os presets filtrados por instrumento e nível do usuário
    static func presets(instrument: String, level: String) -> [PresetObjective] {
        
         let allPresets = flautaPresets + guitarraPresets + tecladoPresets + ukulelePresets + violaoPresets
        
        return allPresets.filter {
            $0.instrument.lowercased() == instrument.lowercased() &&
            $0.level.lowercased() == level.lowercased()
        }
    }
}
