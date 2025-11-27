//
//  HypixelService.swift
//  HyTracker
//
//  Created by Arnaud on 25/11/2025.
//

import Foundation
import SwiftUI

class HypixelAPI {
    
    struct CountsResponse: Decodable {
        let playerCount: Int
    }
    
    struct HypixelResponse: Decodable {
        let success: Bool
        let player: HypixelPlayer?
    }
    
    struct GuildResponse: Decodable {
        let guild: Guild?
    }
    
    struct SkyblockResponse: Decodable {
        let success: Bool
        let profiles: [SkyblockProfile]?
    }
    
    struct Guild: Decodable {
        let name: String
        let tag: String?
        let tagColor: String?
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
        let duels: DuelStats?
        let murderMystery: MurderMysteryStats?
        
        enum CodingKeys: String, CodingKey {
            case bedwars = "Bedwars"
            case skywars = "SkyWars"
            case duels = "Duels"
            case murderMystery = "MurderMystery"
        }
    }
    
    struct BedwarsStats: Decodable {
        let wins: Int?
        let kills: Int?
        let deaths: Int?
        let finalKills: Int?
        let finalDeaths: Int?
        let gamesPlayed: Int?
        
        enum CodingKeys: String, CodingKey {
            case wins = "wins_bedwars"
            case kills = "kills_bedwars"
            case deaths = "deaths_bedwars"
            case finalKills = "final_kills_bedwars"
            case finalDeaths = "final_deaths_bedwars"
            case gamesPlayed = "games_played_bedwars"
        }
    }
    
    struct SkyWarsStats: Decodable {
        let wins: Int?
        let kills: Int?
        let deaths: Int?
        let gamesPlayed: Int?
        
        enum CodingKeys: String, CodingKey {
            case wins = "wins"
            case kills = "kills"
            case deaths = "deaths"
            case gamesPlayed = "games_played_skywars"
        }
    }
    
    struct DuelStats: Decodable {
        let wins: Int?
        let kills: Int?
        let deaths: Int?
        let gamesPlayed: Int?
        
        enum CodingKeys: String, CodingKey {
            case wins = "wins"
            case kills = "kills"
            case deaths = "deaths"
            case gamesPlayed = "games_played_duels"
        }
    }
    
    struct MurderMysteryStats: Decodable {
        let wins: Int?
        let coins : Int?
        let kills: Int?
        let gamesPlayed: Int?
        
        enum CodingKeys: String, CodingKey {
            case wins = "wins"
            case coins = "coins"
            case kills = "kills"
            case gamesPlayed = "games"
        }
    }
    
    struct SkyblockProfile: Decodable, Identifiable {
        let profileId: String
        let cuteName: String
        let selected: Bool
        let members: [String: SkyblockMember]?
        let banking: BankingInfo?
        
        var id: String { profileId }
        
        enum CodingKeys: String, CodingKey {
            case profileId = "profile_id"
            case cuteName = "cute_name"
            case selected, members, banking
        }
    }
    
    struct BankingInfo: Decodable {
        let balance: Double?
    }
    
    struct SkyblockMember: Decodable {
        let currencies: Currencies?
        let playerData: PlayerData?
        let leveling: LevelingInfo?
        let fairySoul: FairySoulInfo?
        let profileData: MemberProfileData?
        
        enum CodingKeys: String, CodingKey {
            case currencies, leveling
            case playerData = "player_data"
            case fairySoul = "fairy_soul"
            case profileData = "profile"
        }
    }
    
    struct Currencies: Decodable {
        let coinPurse: Double?
        enum CodingKeys: String, CodingKey {
            case coinPurse = "coin_purse"
        }
    }

    struct LevelingInfo: Decodable {
        let experience: Double?
    }
    
    struct FairySoulInfo: Decodable {
        let totalCollected: Int?
        
        enum CodingKeys: String, CodingKey {
            case totalCollected = "total_collected"
        }
    }

    struct PlayerData: Decodable {
        let experience: [String: Double]?
        
        var combatXP: Double? { experience?["SKILL_COMBAT"] }
        var miningXP: Double? { experience?["SKILL_MINING"] }
        var farmingXP: Double? { experience?["SKILL_FARMING"] }
        var foragingXP: Double? { experience?["SKILL_FORAGING"] }
        var fishingXP: Double? { experience?["SKILL_FISHING"] }
        var enchantingXP: Double? { experience?["SKILL_ENCHANTING"] }
        var alchemyXP: Double? { experience?["SKILL_ALCHEMY"] }
        var tamingXP: Double? { experience?["SKILL_TAMING"] }
        var runecraftingXP: Double? { experience?["SKILL_RUNECRAFTING"] }
        var socialXP: Double? { experience?["SKILL_SOCIAL"] }
        var carpentryXP: Double? { experience?["SKILL_CARPENTRY"] }
    }
    
    struct MemberProfileData: Decodable {
        let firstJoin: Double?
        
        enum CodingKeys: String, CodingKey {
            case firstJoin = "first_join"
        }
    }
     
    static let apiKey: String = "YOUR-HYPIXEL-API-KEY"
    
    static func getPlayerCount() async throws -> Int {
        guard let url = URL(string: "https://api.hypixel.net/counts?key=\(apiKey)") else { return 0 }
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(CountsResponse.self, from: data)
        return result.playerCount
    }
    
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
    
    static func getGuild(uuid: String) async throws -> Guild? {
        
        guard let url = URL(string: "https://api.hypixel.net/guild?key=\(apiKey)&player=\(uuid)") else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        let result = try JSONDecoder().decode(GuildResponse.self, from: data)
        return result.guild
    }
    
    static func getSkyblockProfiles(uuid: String) async throws -> [SkyblockProfile]? {
        
        guard let url = URL(string: "https://api.hypixel.net/v2/skyblock/profiles?key=\(apiKey)&uuid=\(uuid)") else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        let result = try JSONDecoder().decode(SkyblockResponse.self, from: data)
        
        return result.profiles
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
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
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
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
    }
}

extension HypixelAPI.DuelStats {
    
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

extension HypixelAPI.MurderMysteryStats {
    
    var losses: Int {
        let totalGames = gamesPlayed ?? 0
        return totalGames - (wins ?? 0)
    }
}
