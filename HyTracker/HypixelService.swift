//
//  HypixelService.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import Foundation
import SwiftUI

class HypixelAPI {
    
    struct HypixelResponse: Decodable {
        let success: Bool
        let player: HypixelPlayer?
    }
    
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
    
    struct PlayerStats: Decodable {
        let bedwars: BedwarsStats?
        let skywars: SkyWarsStats?
        
        enum CodingKeys: String, CodingKey {
            case bedwars = "Bedwars"
            case skywars = "SkyWars"
        }
    }
    
    struct BedwarsStats: Decodable {
        let gamesPlayed: Int?
        let wins: Int?
        let kills: Int?
        let deaths: Int?
        let finalKills: Int?
        let finalDeaths: Int?
        
        enum CodingKeys: String, CodingKey {
            case gamesPlayed = "games_played_bedwars"
            case wins = "wins_bedwars"
            case kills = "kills_bedwars"
            case deaths = "deaths_bedwars"
            case finalKills = "final_kills_bedwars"
            case finalDeaths = "final_deaths_bedwars"
        }
    }
    
    struct SkyWarsStats: Decodable {
        let gamesPlayed: Int?
        let wins: Int?
        let kills: Int?
        let deaths: Int?
        
        enum CodingKeys: String, CodingKey {
            case gamesPlayed = "games_played_skywars"
            case wins = "wins"
            case kills = "kills"
            case deaths = "deaths"
        }
    }
     
    static let apiKey: String = "example_key"
    
    static func getPlayer(uuid: String) async throws -> HypixelPlayer? {
        
        guard let url = URL(string: "https://api.hypixel.net/player?key=\(HypixelAPI.apiKey)&uuid=\(uuid)") else {
            return nil
        }
        
        do {
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                return nil
            }
            
            let result = try JSONDecoder().decode(HypixelResponse.self, from: data)
            return result.player
            
        } catch {
            print("Error Hypixel API: \(error.localizedDescription)")
            return nil
        }
    }
}

extension HypixelAPI.HypixelPlayer {
    
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

extension HypixelAPI.BedwarsStats {
    
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
}

extension HypixelAPI.SkyWarsStats {
    
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
}
