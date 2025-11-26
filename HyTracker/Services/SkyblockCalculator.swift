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
}
