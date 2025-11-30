//
//  SkyblockCalculator.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation

struct SkyblockCalculator {
    
    // --- 1. DYNAMIC SKILLS ---
    
    struct SkillInfo {
        let level: Int
        let progress: Double
        let currentXP: Double
        let goalXP: Double
        let isMaxed: Bool
    }
    
    static func calculateSkillDynamic(skillID: String, xp: Double) -> SkillInfo {
        
        guard let definition = SkyblockResourceManager.shared.skillDefinitions[skillID] else {
            return SkillInfo(level: 0, progress: 0, currentXP: 0, goalXP: 100, isMaxed: false)
        }
        
        let levels = definition.levels.sorted { $0.level < $1.level }
        
        var currentLevel = 0
        var currentLevelXP = 0.0
        var nextLevelGoal = 0.0
        var xpInCurrentLevel = 0.0
        var isMaxed = false
        
        for lvlInfo in levels {
            if xp >= lvlInfo.totalExpRequired {
                currentLevel = lvlInfo.level
                currentLevelXP = lvlInfo.totalExpRequired
            } else {
                let previousTotal = currentLevelXP
                let nextTotal = lvlInfo.totalExpRequired
                
                nextLevelGoal = nextTotal - previousTotal
                xpInCurrentLevel = xp - previousTotal
                
                isMaxed = false
                break
            }
        }
        
        if xp >= (levels.last?.totalExpRequired ?? Double.infinity) {
            isMaxed = true
            xpInCurrentLevel = 0
            nextLevelGoal = 0
        }
        
        let progress = isMaxed ? 1.0 : (nextLevelGoal > 0 ? xpInCurrentLevel / nextLevelGoal : 0)
        
        return SkillInfo(level: currentLevel, progress: progress, currentXP: xpInCurrentLevel, goalXP: nextLevelGoal, isMaxed: isMaxed)
    }
    
    static func calculateSkillAverage(profile: SkyblockMember) -> Double {
        let saSkills = ["COMBAT", "MINING", "FARMING", "FORAGING", "FISHING", "ENCHANTING", "ALCHEMY", "TAMING"]
        
        var totalLevels = 0
        
        for skillID in saSkills {
            let playerKey = "SKILL_\(skillID)"
            let xp = profile.playerData?.experience?[playerKey] ?? 0
            
            let info = calculateSkillDynamic(skillID: skillID, xp: xp)
            totalLevels += info.level
        }
        
        return Double(totalLevels) / Double(saSkills.count)
    }
    
    // --- 2. BASE STATS (Placeholder) ---
    
    struct CalculatedStats {
        var health: Double = 100
        var healthRegen: Double = 100
        var defense: Double = 0
        var strength: Double = 0
        var speed: Double = 100
        var critChance: Double = 30
        var critDamage: Double = 50
        var intelligence: Double = 0
        var magicFind: Double = 0
        var vitality: Double = 0
        var mending: Double = 0
        var bonusAttackSpeed: Double = 0
        var ferocity: Double = 0
        var fear: Double = 0
        var abilityDamage: Double = 0
        var petLuck: Double = 0
        var farmingFortune: Double = 0
        var miningFortune: Double = 0
        var miningSpeed: Double = 0
        var foragingFortune: Double = 0
        var gemstoneFortune: Double = 0
        var fishingSpeed: Double = 0
        var seaCreatureChance: Double = 0
        
        func fmt(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
    }
    
    static func calculateBaseStats(profile: SkyblockMember) -> CalculatedStats {
        // TODO: Implement complete system when the inventory will be decoded.
        
        var stats = CalculatedStats()
        
        if let souls = profile.fairySoul?.totalCollected {
            let packs = Double(souls) / 5.0
            stats.health += packs * 3
            stats.defense += packs * 1
            stats.strength += packs * 1
            stats.speed += (Double(souls) / 50.0)
        }
        
        return stats
    }
    
    // --- 3. DYNAMIC COLLECTIONS ---
    
    struct CollectionInfo {
        let tier: Int
        let tierRoman: String
        let progress: Double
        let current: Double
        let goal: Double
        let isMaxed: Bool
    }
    
    static func calculateCollectionDynamic(id: String, amount: Int) -> CollectionInfo {
        
        guard let definition = SkyblockResourceManager.shared.collectionDefinitions[id] else {
            return CollectionInfo(tier: 0, tierRoman: "-", progress: 0, current: 0, goal: 0, isMaxed: false)
        }
        
        let amountDouble = Double(amount)
        var currentTier = 0
        var goal = 0.0
        var isMaxed = false
        
        let sortedTiers = definition.tiers.sorted{ $0.tier < $1.tier }
        
        for tierInfo in sortedTiers {
            if amount >= tierInfo.amountRequired {
                currentTier = tierInfo.tier
            } else {
                goal = Double(tierInfo.amountRequired)
                isMaxed = false
                break
            }
        }
        
        if amount >= (sortedTiers.last?.amountRequired ?? Int.max) {
            isMaxed = true
            goal = Double(amount)
        }
        
        let progress = isMaxed ? 1.0 : (goal > 0 ? amountDouble / goal : 0)
        
        return CollectionInfo(
            tier: currentTier,
            tierRoman: toRoman(currentTier),
            progress: progress,
            current: amountDouble,
            goal: goal,
            isMaxed: isMaxed
        )
    }
    
    // --- 4. MINIONS ---
    
    struct MinionInfo: Identifiable {
        let id = UUID()
        let name: String
        let rawID: String
        let maxTierCrafted: Int
        let totalTiers: Int
        
        var progress: Double {
            return Double(maxTierCrafted) / Double(totalTiers)
        }
        
        var isMaxed: Bool {
            return maxTierCrafted >= totalTiers
        }
    }
    
    static func parseMinions(craftedList: [String]?) -> [MinionInfo] {
        guard let list = craftedList else { return [] }
        
        var minionMap: [String: Int] = [:]
        
        for entry in list {
            if let range = entry.range(of: "_", options: .backwards) {
                let name = String(entry[..<range.lowerBound])
                let tierStr = String(entry[range.upperBound...])
                
                if let tier = Int(tierStr) {
                    if let currentMax = minionMap[name] {
                        if tier > currentMax { minionMap[name] = tier }
                    } else {
                        minionMap[name] = tier
                    }
                }
            }
        }
        
        return minionMap.map { (key, value) in
            
            let maxPossible = MinionData.getMaxTier(for: key)
            
            return MinionInfo(
                name: formatMinionName(key),
                rawID: key,
                maxTierCrafted: value,
                totalTiers: maxPossible
            )
        }.sorted { $0.name < $1.name }
    }
    
    // --- 5. Pets ---
    
    struct PetInfo {
        let level: Int
        let currentXP: Double
        let goalXP: Double
        let progress: Double
        let isMaxed: Bool
    }
    
    static func calculatePetLevel(exp: Double, rarity: String) -> PetInfo {
        
        let table: [Double]
        switch rarity.uppercased() {
        case "COMMON": table = PetLevelData.common
        case "UNCOMMON": table = PetLevelData.uncommon
        case "RARE": table = PetLevelData.rare
        case "EPIC": table = PetLevelData.epic
        case "LEGENDARY", "MYTHIC": table = PetLevelData.legendary
        default: table = PetLevelData.legendary
        }
        
        var xpForNext = 0.0
        var isMaxed = false
        
        for (index, cap) in table.enumerated() {
            if exp < cap {
                let previousCap = (index == 0) ? 0 : table[index - 1]
                let nextCap = cap
                
                xpForNext = nextCap - previousCap
                let xpInLevel = exp - previousCap
                
                return PetInfo(
                    level: index + 1,
                    currentXP: xpInLevel,
                    goalXP: xpForNext,
                    progress: xpForNext > 0 ? xpInLevel / xpForNext : 0,
                    isMaxed: false
                )
            }
        }
        
        return PetInfo(
            level: 100,
            currentXP: 0,
            goalXP: 0,
            progress: 1.0,
            isMaxed: true
        )
    }
    
    // --- HELPERS ---
    
    static func toRoman(_ number: Int) -> String {
        let decimals = [10, 9, 5, 4, 1]
        let numerals = ["X", "IX", "V", "IV", "I"]
        var result = ""
        var num = number
        for (i, decimal) in decimals.enumerated() {
            while num >= decimal {
                result += numerals[i]
                num -= decimal
            }
        }
        return result.isEmpty ? "0" : result
    }
    
    private static func formatMinionName(_ raw: String) -> String {
        let cleaned = raw.replacingOccurrences(of: "_", with: " ").capitalized
        return "\(cleaned) Minion"
    }
}
