//
//  MinionData.swift
//  HyTracker
//
//  Created by Arnaud on 30/11/2025.
//

import Foundation

import Foundation

struct MinionData {
    
    static let categoryMap: [String: String] = [
        
        // --- FARMING ---
        
        "WHEAT": "FARMING",
        "POTATO": "FARMING",
        "CARROT": "FARMING",
        "PUMPKIN": "FARMING",
        "MELON": "FARMING",
        "MUSHROOM": "FARMING",
        "COCOA": "FARMING",
        "CACTUS": "FARMING",
        "SUGAR_CANE": "FARMING",
        "NETHER_WARTS": "FARMING",
        "COW": "FARMING",
        "PIG": "FARMING",
        "CHICKEN": "FARMING",
        "SHEEP": "FARMING",
        "RABBIT": "FARMING",
        
        // --- MINING ---
        
        "COBBLESTONE": "MINING",
        "COAL": "MINING",
        "IRON": "MINING",
        "GOLD": "MINING",
        "DIAMOND": "MINING",
        "LAPIS": "MINING",
        "EMERALD": "MINING",
        "REDSTONE": "MINING",
        "QUARTZ": "MINING",
        "OBSIDIAN": "MINING",
        "GLOWSTONE": "MINING",
        "GRAVEL": "MINING",
        "ICE": "MINING",
        "SAND": "MINING",
        "ENDER_STONE": "MINING",
        "MITHRIL": "MINING",
        "HARD_STONE": "MINING",
        "SNOW": "MINING",
        
        // --- COMBAT ---
        
        "ZOMBIE": "COMBAT",
        "SKELETON": "COMBAT",
        "SPIDER": "COMBAT",
        "CAVESPIDER": "COMBAT",
        "CREEPER": "COMBAT",
        "ENDERMAN": "COMBAT",
        "GHAST": "COMBAT",
        "SLIME": "COMBAT",
        "BLAZE": "COMBAT",
        "MAGMA_CUBE": "COMBAT",
        
        // --- SLAYER MINIONS ---
        
        "REVENANT": "COMBAT",
        "TARANTULA": "COMBAT",
        "VOIDGLOOM": "COMBAT",
        "INFERNO": "COMBAT",
        "VAMPIRE": "COMBAT",
        
        // --- FORAGING ---
        
        "OAK": "FORAGING",
        "SPRUCE": "FORAGING",
        "BIRCH": "FORAGING",
        "DARK_OAK": "FORAGING",
        "ACACIA": "FORAGING",
        "JUNGLE": "FORAGING",
        "FLOWER": "FORAGING",
        
        // --- FISHING ---
        
        "FISHING": "FISHING",
        "CLAY": "FISHING",
    ]
    
    static func getCategory(for minionID: String) -> String {
        return categoryMap[minionID] ?? "MISC"
    }
    
    static let maxTierMap: [String: Int] = [
        
        // --- FARMING ---
        
        "WHEAT": 12,
        "CARROT": 12,
        "POTATO": 12,
        "PUMPKIN": 12,
        "MELON": 12,
        "MUSHROOM": 12,
        "COCOA": 12,
        "CACTUS": 12,
        "SUGAR_CANE": 12,
        "NETHER_WARTS": 12,
        "COW": 12,
        "PIG": 12,
        "CHICKEN": 12,
        "SHEEP": 12,
        "RABBIT": 12,
        
        // --- MINING ---
        
        "HARD_STONE": 12,
        
        // --- COMBAT ---
        
        "REVENANT": 12,
        "TARANTULA": 12,
        "VOIDGLOOM": 12,
        "INFERNO": 12,
        "VAMPIRE": 12,
        
        // --- FISHING ---
        "FISHING": 12,
    ]
    
    static func getMaxTier(for minionID: String) -> Int {
        return maxTierMap[minionID] ?? 11
    }
}
