//
//  SkyblockCalculator.swift
//  HyTracker
//
//  Created by Arnaud on 26/11/2025.
//

import Foundation

import Foundation

struct SkyblockCalculator {
    
    static let standardLevels: [Double] = [
        50, 125, 200, 300, 500, 750, 1000, 1500, 2000, 3500, 5000, 7500, 10000, 15000, 20000, 30000, 50000, 75000, 100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000, 1100000, 1200000, 1300000, 1400000, 1500000, 1600000, 1700000, 1800000, 1900000, 2000000, 2100000, 2200000, 2300000, 2400000, 2500000, 2600000, 2750000, 2900000, 3100000, 3400000, 3700000, 4000000, 4300000, 4600000, 4900000, 5200000, 5500000, 5800000, 6100000, 6400000, 6700000, 7000000
    ]
    
    static let runecraftingLevels: [Double] = [
        50, 100, 125, 160, 200, 250, 315, 400, 500, 625, 785, 1000, 1250, 1600, 2000, 2465, 3125, 4000, 5000, 6200, 7800, 9800, 12200, 15300
    ]
    
    struct SkillInfo {
        let level: Int
        let progress: Double
        let currentXP: Double
        let goalXP: Double
    }
    
    static func calculateSkillLevel(xp: Double, type: SkyblockModuleType) -> SkillInfo {
        let table: [Double]
        if type == .runecrafting {
            table = runecraftingLevels
        } else {
            table = standardLevels
        }
        
        var remainingXP = xp
        var level = 0
        
        for cap in table {
            if remainingXP >= cap {
                remainingXP -= cap
                level += 1
            } else {
                return SkillInfo(
                    level: level,
                    progress: remainingXP / cap,
                    currentXP: remainingXP,
                    goalXP: cap
                )
            }
        }
        
        return SkillInfo(level: level, progress: 1.0, currentXP: remainingXP, goalXP: remainingXP)
    }
    
    static func calculateSkillAverage(skills: [Double?]) -> Double {
        let validSkills = skills.compactMap { $0 }
        if validSkills.isEmpty { return 0 }
        let totalLevels = validSkills.reduce(0) { sum, xp in
            sum + Double(calculateSkillLevel(xp: xp, type: .combat).level)
        }
        return totalLevels / Double(validSkills.count)
    }
    
    struct CalculatedStats {
        var health: Double = 100
        var healthRegen: Double = 100
        var defense: Double = 0
        var vitality: Double = 100
        var mending: Double = 100
        
        var strength: Double = 0
        var speed: Double = 100
        var critChance: Double = 30
        var critDamage: Double = 50
        var attackSpeed: Double = 0
        var ferocity: Double = 0
        
        var intelligence: Double = 0
        var abilityDamage: Double = 0
        var magicFind: Double = 0
        var petLuck: Double = 0
        var fear: Double = 0
        
        var miningFortune: Double = 0
        var miningSpeed: Double = 0
        var gemstoneFortune: Double = 0
        var farmingFortune: Double = 0
        var foragingFortune: Double = 0
        var fishingSpeed: Double = 0
        var seaCreatureChance: Double = 20
        
        func fmt(_ value: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
        }
    }
}

extension SkyblockCalculator {
    
    static func calculateBaseStats(profile: HypixelAPI.SkyblockMember) -> CalculatedStats {
        var stats = CalculatedStats()
        let data = profile.playerData
        
        if let xp = data?.farmingXP {
            let lvl = calculateSkillLevel(xp: xp, type: .farming).level
            stats.health += Double(lvl * 3)
            stats.farmingFortune += Double(lvl * 4)
        }
        
        if let xp = data?.miningXP {
            let lvl = calculateSkillLevel(xp: xp, type: .mining).level
            stats.defense += Double(lvl * 2)
            stats.miningFortune += Double(lvl * 4)
        }
        
        if let xp = data?.combatXP {
            let lvl = calculateSkillLevel(xp: xp, type: .combat).level
            stats.critChance += Double(lvl) * 0.5
        }
        
        if let xp = data?.foragingXP {
            let lvl = calculateSkillLevel(xp: xp, type: .foraging).level
            stats.strength += Double(lvl * 2)
            stats.foragingFortune += Double(lvl * 4)
        }
        
        if let xp = data?.enchantingXP {
            let lvl = calculateSkillLevel(xp: xp, type: .enchanting).level
            stats.intelligence += Double(lvl * 2)
            stats.abilityDamage += Double(lvl) * 0.5
        }
        
        if let xp = data?.alchemyXP {
            let lvl = calculateSkillLevel(xp: xp, type: .alchemy).level
            stats.intelligence += Double(lvl * 2)
        }
        
        if let xp = data?.tamingXP {
            let lvl = calculateSkillLevel(xp: xp, type: .taming).level
            stats.petLuck += Double(lvl * 1)
        }
        
        if let xp = data?.fishingXP {
            let lvl = calculateSkillLevel(xp: xp, type: .fishing).level
            stats.health += Double(lvl * 3)
        }
        
        if let xp = data?.carpentryXP {
            let lvl = calculateSkillLevel(xp: xp, type: .carpentry).level
            stats.health += Double(lvl)
        }
        
        if let souls = profile.fairySoul?.totalCollected {
            let packs = Double(souls) / 5.0
            stats.health += packs * 3
            stats.defense += packs * 1
            stats.strength += packs * 1
            stats.speed += (Double(souls) / 50.0)
        }
        
        return stats
    }
}
