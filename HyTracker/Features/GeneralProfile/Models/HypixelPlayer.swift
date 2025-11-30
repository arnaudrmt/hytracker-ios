//
//  HypixelPlayer.swift
//  HyTracker
//
//  Created by Arnaud on 29/11/2025.
//

import Foundation
import SwiftUI

struct HypixelPlayer: Decodable {
    let displayName: String
    let networkExp: Double?
    let stats: PlayerStats?
    
    let newPackageRank: String?
    let monthlyPackageRank: String?
    let rank: String?
    
    enum CodingKeys: String, CodingKey {
        case displayName = "displayname"
        case networkExp, stats, newPackageRank, monthlyPackageRank, rank
    }
    
    var hypixelLevel: Double {
        let exp = networkExp ?? 0
        return (sqrt(exp / 1250 + 12.25) - 3.5)
    }
}

struct Guild: Decodable {
    let name: String
    let tag: String?
    let tagColor: String?
}

struct PlayerStats: Decodable {
    let bedwars: BedwarsStats?
    let skywars: SkyWarsStats?
    let duels: DuelStats?
    let murderMystery: MurderMysteryStats?
    
    enum CodingKeys: String, CodingKey {
        case bedwars = "Bedwars"
        case skywars = "SkyWars"
        case duels = "Duels"
        case murderMystery = "MurderMystery"
    }
}

extension HypixelPlayer {
    
    var formattedRank: String {
        
        if let r = rank, r != "NORMAL" {
            switch r {
            case "YOUTUBER": return "[YT]"
            case "MODERATOR": return "[MOD]"
            case "GAME_MASTER": return "[GM]"
            default:  return "[\(r)]"
            }
        }
        
        if monthlyPackageRank == "SUPERSTAR" {
            return "[MVP++]"
        }
        
        if let package = newPackageRank {
            switch package {
            case "VIP": return "[VIP]"
            case "VIP_PLUS": return "[VIP+]"
            case "MVP": return "[MVP]"
            case "MVP_PLUS": return "[MVP+]"
            default: return ""
            }
        }
        return ""
    }
    
    var rankColor: Color {
        if let r = rank, r != "NORMAL" { return .red }
        
        if monthlyPackageRank == "SUPERSTAR" { return .orange }
        
        if let package = newPackageRank {
            switch package {
                case "VIP", "VIP_PLUS": return .green
                case "MVP", "MVP_PLUS": return .cyan
                default: return .gray
            }
        }
        return .gray
    }
}

extension BedwarsStats {
    
    var kdRatio: Double {
        let k = Double(kills ?? 0)
        let d = Double(deaths ?? 0)
        if d == 0 { return k }
        return k / d
    }
    
    var wlRatio: Double {
        let w = Double(wins ?? 0)
        let totalGames = gamesPlayed ?? 0
        let l = Double(totalGames - (wins ?? 0))
        
        if l == 0 { return w }
        return w / l
    }
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
    }
}

extension SkyWarsStats {
    
    var kdRatio: Double {
        let k = Double(kills ?? 0)
        let d = Double(deaths ?? 0)
        if d == 0 { return k }
        return k / d
    }
    
    var wlRatio: Double {
        let w = Double(wins ?? 0)
        let totalGames = gamesPlayed ?? 0
        let l = Double(totalGames - (wins ?? 0))
        
        if l == 0 { return w }
        return w / l
    }
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
    }
}

extension DuelStats {
    
    var kdRatio: Double {
        let k = Double(kills ?? 0)
        let d = Double(deaths ?? 0)
        if d == 0 { return k }
        return k / d
    }
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
    }
}

extension MurderMysteryStats {
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
    }
}
