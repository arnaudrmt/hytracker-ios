//
//  SkyblockStyle.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

struct SkillTheme {
    let asset: String
    let color: Color
    let isAsset: Bool
}

class SkyblockStyle {
    
    static func getSkillTheme(id: String) -> SkillTheme {
        switch id {
        case "COMBAT":
            return SkillTheme(asset: "STONE_SWORD", color: Color("mc_blue"), isAsset: true)
        case "MINING":
            return SkillTheme(asset: "STONE_PICKAXE", color: Color("mc_blue"), isAsset: true)
        case "FARMING":
            return SkillTheme(asset: "GOLDEN_HOE", color: Color("mc_blue"), isAsset: true)
        case "FORAGING":
            return SkillTheme(asset: "SAPLING-3", color: Color("mc_blue"), isAsset: true)
        case "FISHING":
            return SkillTheme(asset: "FISHING_ROD", color: Color("mc_blue"), isAsset: true)
        case "ENCHANTING":
            return SkillTheme(asset: "ENCHANTING_TABLE", color: Color("mc_blue"), isAsset: true)
        case "ALCHEMY":
            return SkillTheme(asset: "BREWING_STAND", color: Color("mc_blue"), isAsset: true)
        case "TAMING":
            return SkillTheme(asset: "SPAWN_EGG-4", color: Color("mc_blue"), isAsset: true)
        case "CARPENTRY":
            return SkillTheme(asset: "CRAFTING_TABLE", color: Color("mc_blue"), isAsset: true)
        case "RUNECRAFTING":
            return SkillTheme(asset: "MAGMA_CREAM", color: Color("mc_blue"), isAsset: true)
        case "SOCIAL":
            return SkillTheme(asset: "EMERALD", color: Color("mc_blue"), isAsset: true)
        case "HUNTING":
            return SkillTheme(asset: "LEAD", color: Color("mc_blue"), isAsset: true)
            
        default:
            return SkillTheme(asset: "exclamationmark.triangle.fill", color: Color("mc_black"), isAsset: false)
        }
    }
    
    static func getCollectionSectionStyle(name: String) -> (icon: String, color: Color) {
        switch name.uppercased() {
        case "FARMING":
            return ("leaf.fill", .yellow)
        case "MINING":
            return ("hammer.fill",  Color("mc_gray"))
        case "COMBAT":
            return ("flame.fill",  Color("mc_red"))
        case "FORAGING":
            return ("tree.fill",  Color("mc_gold"))
        case "FISHING":
            return ("fish.fill",  Color("mc_dark_aqua"))
        case "RIFT":
            return ("eye.fill",  Color("mc_dark_purple"))
        case "BOSS":
            return ("skull.fill", Color("mc_black"))
        default:
            return ("exclamationmark.triangle.fill",  Color("mc_black"))
        }
    }
}

struct PetRarity {
    static func getColor(tier: String) -> Color {
        switch tier.uppercased() {
        case "COMMON": return Color("mc_gray")
        case "UNCOMMON": return Color("mc_green")
        case "RARE": return Color("mc_blue")
        case "EPIC": return Color("mc_dark_purple")
        case "LEGENDARY": return Color("mc_gold")
        case "MYTHIC": return Color("mc_light_purple")
        default: return Color("mc_primary")
        }
    }
    
    static func getOrder(tier: String) -> Int {
        switch tier.uppercased() {
        case "MYTHIC": return 0
        case "LEGENDARY": return 1
        case "EPIC": return 2
        case "RARE": return 3
        case "UNCOMMON": return 4
        case "COMMON": return 5
        default: return 6
        }
    }
}
