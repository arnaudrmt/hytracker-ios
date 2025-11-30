//
//  SkyblockIcons.swift
//  HyTracker
//
//  Created by Arnaud on 27/11/2025.
//

import Foundation
import SwiftUI

enum SBIcon {
    
    case health, healthRegen, vitality, mending
    case defense
    case strength, bonusAttackSpeed, ferocity, fear
    case intelligence, abilityDamage
    case critChance, critDamage
    case speed
    case magicFind, petLuck
    case seaCreatureChance, fishingSpeed
    
    case miningFortune, miningSpeed
    case farmingFortune
    case foragingFortune
    case gemstoneFortune
    
    case unknown
        
    var unicode: String {
        switch self {
            
            case .health: return "❤"
            case .healthRegen: return "❣\u{FE0E}"
            case .defense: return "❈"
            case .vitality: return "♨\u{FE0E}"
            case .mending: return "☄\u{FE0E}"
                
            case .strength: return "❁"
            case .bonusAttackSpeed: return "⚔"
            case .critChance: return "☣"
            case .critDamage: return "☠"
            case .ferocity: return "⫽"
            case .fear: return "☠"
                
            case .intelligence: return "✎"
            case .abilityDamage: return "๑"
                
            case .speed: return "✦"
            case .magicFind: return "✯"
            case .petLuck: return "♣"
            case .seaCreatureChance: return "α"
            case .fishingSpeed: return "☂\u{FE0E}"
                
            case .farmingFortune: return "☘"
            case .foragingFortune: return "☘"
            case .miningFortune: return "☘"
            case .gemstoneFortune: return "☘"
            case .miningSpeed: return "⸕"
                
            default: return "\u{2E0E}"
        }
    }
    
    func view(size: CGFloat = 16, color: Color) -> Text {
        return Text(self.unicode)
            .font(.custom("icomoon", size: size))
            .foregroundColor(color)
    }
}
