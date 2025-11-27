//
//  SkyblockStyle.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation
import SwiftUI

enum SkyblockModuleType {
    case combat, mining, farming, foraging, fishing, enchanting, alchemy, taming
    case runecrafting, social, carpentry // <--- NOUVEAUX
    case catacombs, slayer, banking, inventory, misc

    var title: String {
        switch self {
        case .combat: return "Combat"
        case .mining: return "Mining"
        case .farming: return "Farming"
        case .foraging: return "Foraging"
        case .fishing: return "Fishing"
        case .enchanting: return "Enchanting"
        case .alchemy: return "Alchemy"
        case .taming: return "Taming"
        case .runecrafting: return "Runecrafting"
        case .social: return "Social"
        case .carpentry: return "Carpentry"
        case .catacombs: return "Dungeons"
        case .slayer: return "Slayer"
        case .banking: return "Bank"
        case .inventory: return "Inventory"
        case .misc: return "Misc"
        }
    }
    
    var iconName: String {
        switch self {
        case .combat: return "minecraft_item_stone_sword"
        case .mining: return "minecraft_item_stone_pickaxe"
        case .farming: return "minecraft_item_golden_hoe"
        case .foraging: return "minecraft_block_spruce_sapling"
        case .fishing: return "minecraft_item_fishing_rod"
        case .enchanting: return "minecraft_block_enchanting_table"
        case .alchemy: return "minecraft_block_brewing_stand"
        case .taming: return "minecraft_item_golem_spawn_egg"
        case .runecrafting: return "minecraft_item_magma_cream"
        case .social: return "minecraft_item_emerald"
        case .carpentry: return "minecraft_block_crafting_table"
        default: return "archivebox.fill"
        }
    }
    
    var isAsset: Bool {
        switch self {
        case .catacombs, .slayer, .banking, .inventory, .misc: return false
        default: return true
        }
    }
    
    var color: Color {
        switch self {
        case .combat: return .red
        case .mining: return .gray
        case .farming: return .yellow
        case .foraging: return .brown
        case .fishing: return .blue
        case .enchanting: return .purple
        case .alchemy: return .purple.opacity(0.7)
        case .taming: return .green
        case .runecrafting: return .pink
        case .social: return .cyan
        case .carpentry: return .orange
        case .catacombs: return .red.opacity(0.8)
        case .slayer: return .black.opacity(0.8)
        case .banking: return .yellow
        case .inventory: return .orange
        case .misc: return .pink
        }
    }
}
